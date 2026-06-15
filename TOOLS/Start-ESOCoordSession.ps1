[CmdletBinding()]
param(
  [switch]$ForceNew,
  [switch]$NoOpenWorkshop,
  [switch]$NoOpenMockup
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$ToolsDir = Join-Path $Root "TOOLS"
$Bridge = Join-Path $ToolsDir "Start-R16CoordClipboardBridge.ps1"
$OpenWorkshop = Join-Path $ToolsDir "Open-ESO-Workshop.ps1"
$MockupPath = Join-Path $Root "ESO_INDEX_SITE_MOCKUP_20260611_152646\reader\index\public.html"
$ToolCss = Join-Path $Root "TOOLS\COORD_MARK_TOOL_R8_LOCKED\COORD_MARK_TOOL_R8.css"
$ToolFrag = Join-Path $Root "TOOLS\COORD_MARK_TOOL_R8_LOCKED\COORD_MARK_TOOL_R8.htmlfrag"

$RuntimeRoot = Join-Path $Root "ACTIVE_CHAT_DROPS\RUNTIME_SESSIONS"
$CurrentFile = Join-Path $RuntimeRoot "CURRENT_COORD_SESSION.json"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

New-Item -ItemType Directory -Force -Path $RuntimeRoot | Out-Null
Set-Location -LiteralPath $Root

function New-SessionDir {
  $dir = Join-Path $RuntimeRoot "COORD_SESSION_$Stamp"
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  return $dir
}

function Write-ProcessEvent {
  param(
    [string]$SessionDir,
    [string]$Type,
    [hashtable]$Data
  )

  if ($null -eq $Data) { $Data = @{} }

  $path = Join-Path $SessionDir "03_PROCESS_EVENTS.jsonl"
  $obj = [ordered]@{
    timestamp = (Get-Date).ToString("o")
    session_id = (Split-Path -Leaf $SessionDir)
    pid = $BridgePid
    event_type = $Type
  }

  foreach ($key in $Data.Keys) {
    $obj[$key] = $Data[$key]
  }

  ($obj | ConvertTo-Json -Compress -Depth 8) | Add-Content -LiteralPath $path -Encoding UTF8
}

function Get-HashSafe {
  param([string]$Path)
  if (!(Test-Path -LiteralPath $Path)) { return $null }
  return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Get-LastWriteSafe {
  param([string]$Path)
  if (!(Test-Path -LiteralPath $Path)) { return [datetime]::MinValue }
  return (Get-Item -LiteralPath $Path).LastWriteTime
}

function Read-CurrentSession {
  if (!(Test-Path -LiteralPath $CurrentFile)) { return $null }
  try {
    return Get-Content -LiteralPath $CurrentFile -Raw | ConvertFrom-Json
  } catch {
    return $null
  }
}

function Get-R16BridgeProcesses {
  Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
    Where-Object {
      $_.CommandLine -and $_.CommandLine -like "*Start-R16CoordClipboardBridge.ps1*"
    } |
    Sort-Object CreationDate -Descending |
    Select-Object ProcessId, Name, CreationDate, CommandLine
}

function Get-SessionDirFromCommandLine {
  param([string]$CommandLine)

  if ([string]::IsNullOrWhiteSpace($CommandLine)) { return $null }

  $m = [regex]::Match($CommandLine, '-SessionDir\s+(?<dir>.+?)\s+-Root\s+')
  if ($m.Success) { return $m.Groups["dir"].Value.Trim('"') }

  return $null
}

function Test-BridgeAlive {
  param([int]$BridgePid)

  if ($BridgePid -le 0) { return $false }

  $p = Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
    Where-Object {
      $_.ProcessId -eq $BridgePid -and
      $_.CommandLine -and
      $_.CommandLine -like "*Start-R16CoordClipboardBridge.ps1*"
    } |
    Select-Object -First 1

  return ($null -ne $p)
}

function Get-NewestTempWorkshop {
  $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "ESO_WORKSHOP_LAUNCHES"
  if (!(Test-Path -LiteralPath $tempDir)) { return $null }

  Get-ChildItem -LiteralPath $tempDir -Filter "ESO_WORKSHOP_R8_*_public.html" -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
}

function Test-WorkshopCurrent {
  param([string]$WorkshopPath)

  if ([string]::IsNullOrWhiteSpace($WorkshopPath)) { return $false }
  if (!(Test-Path -LiteralPath $WorkshopPath)) { return $false }

  $workshopTime = (Get-Item -LiteralPath $WorkshopPath).LastWriteTime
  $newestSource = @(
    (Get-LastWriteSafe -Path $ToolCss),
    (Get-LastWriteSafe -Path $ToolFrag),
    (Get-LastWriteSafe -Path $MockupPath)
  ) | Sort-Object -Descending | Select-Object -First 1

  return ($workshopTime -ge $newestSource)
}

function Open-WorkshopSurface {
  param(
    [string]$ExistingPath,
    [string]$SessionDir
  )

  if ($NoOpenWorkshop) {
    return [ordered]@{
      action = "SKIPPED_BY_FLAG"
      path = $ExistingPath
    }
  }

  if ((Test-WorkshopCurrent -WorkshopPath $ExistingPath)) {
    Start-Process -FilePath $ExistingPath
    Write-ProcessEvent -SessionDir $SessionDir -Type "workshop_reused" -Data @{ workshop_path = $ExistingPath }
    return [ordered]@{
      action = "REUSED"
      path = $ExistingPath
    }
  }

  $newest = Get-NewestTempWorkshop
  if ($newest -and (Test-WorkshopCurrent -WorkshopPath $newest.FullName)) {
    Start-Process -FilePath $newest.FullName
    Write-ProcessEvent -SessionDir $SessionDir -Type "workshop_reused_newest_temp" -Data @{ workshop_path = $newest.FullName }
    return [ordered]@{
      action = "REUSED_NEWEST_TEMP"
      path = $newest.FullName
    }
  }

  Write-ProcessEvent -SessionDir $SessionDir -Type "workshop_create_requested" -Data @{ launcher = $OpenWorkshop }

  $output = & $OpenWorkshop 2>&1
  foreach ($line in $output) {
    Write-Host $line
  }

  $path = $null
  foreach ($line in $output) {
    $s = [string]$line
    if ($s -match '^[A-Za-z]:\\.*ESO_WORKSHOP_R8_.*\.html$') {
      $path = $s.Trim()
    }
  }

  if ([string]::IsNullOrWhiteSpace($path)) {
    $latest = Get-NewestTempWorkshop
    if ($latest) { $path = $latest.FullName }
  }

  if ([string]::IsNullOrWhiteSpace($path) -or !(Test-Path -LiteralPath $path)) {
    throw "Workshop launcher ran, but no temp workshop path could be proven."
  }

  Write-ProcessEvent -SessionDir $SessionDir -Type "workshop_created" -Data @{ workshop_path = $path }

  return [ordered]@{
    action = "CREATED"
    path = $path
  }
}

function Open-MockupSurface {
  param([string]$SessionDir)

  if ($NoOpenMockup) {
    return [ordered]@{
      action = "SKIPPED_BY_FLAG"
      path = $MockupPath
    }
  }

  if (!(Test-Path -LiteralPath $MockupPath)) {
    throw "Missing mockup preview path: $MockupPath"
  }

  Start-Process -FilePath $MockupPath
  Write-ProcessEvent -SessionDir $SessionDir -Type "mockup_open_requested" -Data @{ mockup_path = $MockupPath }

  return [ordered]@{
    action = "OPEN_REQUESTED"
    path = $MockupPath
  }
}

Write-Host "=== ESO R16C THREE-SURFACE FRONT DOOR ===" -ForegroundColor Cyan

foreach ($required in @($Bridge, $OpenWorkshop, $MockupPath, $ToolCss, $ToolFrag)) {
  if (!(Test-Path -LiteralPath $required)) {
    throw "Missing required file: $required"
  }
}

$current = Read-CurrentSession
$bridgeAction = "UNKNOWN"
$bridgePid = $null
$sessionDir = $null

$live = @(Get-R16BridgeProcesses)

if (!$ForceNew -and $current -and $current.bridge_pid -and (Test-BridgeAlive -Pid ([int]$current.bridge_pid))) {
  $bridgePid = [int]$current.bridge_pid
  $sessionDir = [string]$current.session_dir
  if ([string]::IsNullOrWhiteSpace($sessionDir) -or !(Test-Path -LiteralPath $sessionDir)) {
    $sessionDir = New-SessionDir
  }
  $bridgeAction = "REUSED_CURRENT"
}
elseif (!$ForceNew -and $live.Count -gt 0) {
  $chosen = $live | Select-Object -First 1
  $bridgePid = [int]$chosen.ProcessId
  $sessionDir = Get-SessionDirFromCommandLine -CommandLine $chosen.CommandLine
  if ([string]::IsNullOrWhiteSpace($sessionDir) -or !(Test-Path -LiteralPath $sessionDir)) {
    $sessionDir = New-SessionDir
  }
  $bridgeAction = "REUSED_LIVE_DISCOVERED"
}
else {
  $sessionDir = New-SessionDir

  $parseErrors = $null
  $tokens = $null
  [System.Management.Automation.Language.Parser]::ParseFile($Bridge, [ref]$tokens, [ref]$parseErrors) | Out-Null
  if ($parseErrors -and $parseErrors.Count -gt 0) {
    $parseErrors | Format-List
    throw "R16 bridge parse failed. Session blocked."
  }

  Write-ProcessEvent -SessionDir $sessionDir -Type "bridge_parse_pass" -Data @{ bridge = $Bridge }

  $bridgeProc = Start-Process -FilePath "powershell.exe" -WorkingDirectory $Root -ArgumentList @(
    "-NoExit",
    "-ExecutionPolicy", "Bypass",
    "-File", $Bridge,
    "-SessionDir", $sessionDir,
    "-Root", $Root
  ) -PassThru

  Start-Sleep -Seconds 2

  if (!(Test-BridgeAlive -Pid $bridgeProc.Id)) {
    throw "R16 bridge did not appear healthy after start."
  }

  $bridgePid = [int]$bridgeProc.Id
  $bridgeAction = "STARTED_NEW"
  Write-ProcessEvent -SessionDir $sessionDir -Type "bridge_started" -Data @{ bridge_pid = $bridgePid; bridge = $Bridge }
}

New-Item -ItemType Directory -Force -Path $sessionDir | Out-Null

Write-ProcessEvent -SessionDir $sessionDir -Type "front_door_bridge_decision" -Data @{
  bridge_action = $bridgeAction
  bridge_pid = $bridgePid
}

$existingWorkshop = $null
if ($current -and $current.workshop_path) {
  $existingWorkshop = [string]$current.workshop_path
}

$workshop = Open-WorkshopSurface -ExistingPath $existingWorkshop -SessionDir $sessionDir
$mockup = Open-MockupSurface -SessionDir $sessionDir

$state = [ordered]@{
  version = "R16C_THREE_SURFACE_FRONT_DOOR_20260615"
  updated_at = (Get-Date).ToString("o")
  root = $Root
  session_dir = $sessionDir
  bridge_pid = $bridgePid
  bridge_action = $bridgeAction
  workshop_action = $workshop.action
  workshop_path = $workshop.path
  mockup_action = $mockup.action
  mockup_path = $mockup.path
  tool_css = $ToolCss
  tool_css_sha256 = Get-HashSafe -Path $ToolCss
  tool_fragment = $ToolFrag
  tool_fragment_sha256 = Get-HashSafe -Path $ToolFrag
  mockup_sha256 = Get-HashSafe -Path $MockupPath
}

($state | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath $CurrentFile -Encoding UTF8

$SessionReceipt = Join-Path $sessionDir "00_SESSION_RECEIPT.md"
$receiptText = @"
# R16C Coordinate Session Receipt

Timestamp: $Stamp

Session:
$sessionDir

Bridge action:
$bridgeAction

Bridge PID:
$bridgePid

Workshop action:
$($workshop.action)

Workshop path:
$($workshop.path)

Mockup action:
$($mockup.action)

Mockup path:
$($mockup.path)

Current session state:
$CurrentFile

Boundary:
Three-surface front door.
Healthy bridge is reused.
Workshop temp page is reused when current.
Plain mockup preview is opened/reopened.
No reader promotion.
No coordinate export applied.
"@

Set-Content -LiteralPath $SessionReceipt -Value $receiptText.TrimEnd() -Encoding UTF8

Write-Host ""
Write-Host "Bridge: $bridgeAction PID $bridgePid" -ForegroundColor Green
Write-Host "Workshop: $($workshop.action) $($workshop.path)" -ForegroundColor Green
Write-Host "Mockup: $($mockup.action) $($mockup.path)" -ForegroundColor Green
Write-Host "Current state: $CurrentFile"
Write-Host "Session receipt: $SessionReceipt"

Write-Host ""
Write-Host "STATUS: R16C_THREE_SURFACE_FRONT_DOOR_COMPLETE" -ForegroundColor Green
Write-Host "Keep the R16 bridge window open."
Write-Host "Use the fresh/current workshop tab only."
Write-Host "Use the mockup preview tab for visual check."
