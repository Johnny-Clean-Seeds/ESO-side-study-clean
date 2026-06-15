[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string]$SessionDir,

  [Parameter(Mandatory=$false)]
  [string]$Root = "C:\Users\13527\Desktop\ESO\ESO"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$MockupCss = Join-Path $Root "ESO_INDEX_SITE_MOCKUP_20260611_152646\assets\styles.css"
$BackupDir = Join-Path $SessionDir "BACKUPS"
$EventLog = Join-Path $SessionDir "02_BRIDGE_EVENTS.jsonl"
$HeartbeatLog = Join-Path $SessionDir "04_HEARTBEAT.log"
$LastKnownCoords = Join-Path $SessionDir "05_LAST_KNOWN_COORDS.json"
$LastAppliedCss = Join-Path $SessionDir "06_LAST_APPLIED_CSS.css"
$BackupsCreated = Join-Path $SessionDir "07_BACKUPS_CREATED.txt"
$TranscriptPath = Join-Path $SessionDir "09_BRIDGE_TRANSCRIPT.log"
$LockDir = Join-Path $Root "ACTIVE_CHAT_DROPS\RUNTIME_LOCKS"
$PidFile = Join-Path $LockDir "ESO_COORD_CLIPBOARD_BRIDGE.pid"

New-Item -ItemType Directory -Force -Path $SessionDir | Out-Null
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
New-Item -ItemType Directory -Force -Path $LockDir | Out-Null
Set-Location -LiteralPath $Root

$SessionId = Split-Path -Leaf $SessionDir

function Write-BridgeEvent {
  param(
    [string]$Type,
    [hashtable]$Data
  )

  if ($null -eq $Data) { $Data = @{} }

  $obj = [ordered]@{
    timestamp = (Get-Date).ToString("o")
    session_id = $SessionId
    pid = $PID
    event_type = $Type
  }

  foreach ($key in $Data.Keys) {
    $obj[$key] = $Data[$key]
  }

  ($obj | ConvertTo-Json -Compress -Depth 8) | Add-Content -LiteralPath $EventLog -Encoding UTF8
}

function Write-Heartbeat {
  $line = "{0} | PID {1} | SESSION {2} | watching clipboard | target {3}" -f (Get-Date).ToString("o"), $PID, $SessionId, $MockupCss
  Add-Content -LiteralPath $HeartbeatLog -Value $line -Encoding UTF8
}

try {
  Start-Transcript -LiteralPath $TranscriptPath -Append | Out-Null
} catch {
  Write-BridgeEvent -Type "transcript_failed" -Data @{ error = $_.Exception.Message }
}

try {
  $Host.UI.RawUI.WindowTitle = "ESO R16 BRIDGE ACTIVE PID $PID"
} catch {}

if (!(Test-Path -LiteralPath $MockupCss)) {
  Write-BridgeEvent -Type "bridge_start_failed" -Data @{ error = "missing mockup css"; target_css = $MockupCss }
  throw "Missing mockup CSS: $MockupCss"
}

Set-Content -LiteralPath $PidFile -Value ([string]$PID) -Encoding ASCII

Write-Host "=== ESO R16 JOURNALED COORD BRIDGE RUNNING ===" -ForegroundColor Cyan
Write-Host "Session: $SessionId"
Write-Host "PID: $PID"
Write-Host "Target CSS: $MockupCss"
Write-Host "Bridge event log: $EventLog"
Write-Host "Heartbeat log: $HeartbeatLog"
Write-Host "Click COPY COORDS in the active shop. Do not paste coords into PowerShell."
Write-Host "Stop with Ctrl+C."

Write-BridgeEvent -Type "bridge_started" -Data @{
  target_css = $MockupCss
  pid_file = $PidFile
  transcript = $TranscriptPath
}

$Selectors = [ordered]@{
  ".aa-top-hotspot-search" = "search"
  ".aa-hotspot-enter"      = "enter_index"
  ".aa-card-start"         = "start_here"
  ".aa-card-index"         = "research_index"
  ".aa-card-records"       = "source_records"
  ".aa-card-notes"         = "visual_notes"
  ".aa-card-spine"         = "documentary_spine"
  ".aa-card-parts"         = "part_index"
}

function Get-ClipboardTextSafe {
  try {
    return Get-Clipboard -Raw -ErrorAction Stop
  } catch {
    try {
      return (Get-Clipboard -ErrorAction Stop | Out-String)
    } catch {
      return ""
    }
  }
}

function Get-TextHash {
  param([string]$Text)

  $sha = [System.Security.Cryptography.SHA256]::Create()
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
  $hash = $sha.ComputeHash($bytes)
  return ([BitConverter]::ToString($hash)).Replace("-", "")
}

function Extract-Coords {
  param([string]$Text)

  if ([string]::IsNullOrWhiteSpace($Text)) { return $null }
  if ($Text -notmatch "aa-top-hotspot-search" -or $Text -notmatch "aa-card-parts") { return $null }

  $coords = [ordered]@{}

  foreach ($selector in $Selectors.Keys) {
    $escaped = [regex]::Escape($selector)
    $pattern = "(?s)$escaped\s*\{.*?left:\s*(?<left>-?\d+(?:\.\d+)?)%\s*(?:!important)?\s*;.*?top:\s*(?<top>-?\d+(?:\.\d+)?)%\s*(?:!important)?\s*;.*?width:\s*(?<width>-?\d+(?:\.\d+)?)%\s*(?:!important)?\s*;.*?height:\s*(?<height>-?\d+(?:\.\d+)?)%\s*(?:!important)?\s*;.*?\}"

    $m = [regex]::Match($Text, $pattern)
    if (!$m.Success) {
      return $null
    }

    $coords[$selector] = [ordered]@{
      name = $Selectors[$selector]
      left = $m.Groups["left"].Value
      top = $m.Groups["top"].Value
      width = $m.Groups["width"].Value
      height = $m.Groups["height"].Value
    }
  }

  return $coords
}

function Build-FinalBlock {
  param($coords)

  $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $lines = New-Object System.Collections.Generic.List[string]

  $lines.Add("")
  $lines.Add("/* FINAL_BUTTON_COORDS_LOCK_20260614_R8_EXPORT BEGIN */")
  $lines.Add("/* R16_JOURNALED_COORD_BRIDGE_APPLY_20260615")
  $lines.Add("   Applied by R16 journaled clipboard bridge at $stamp.")
  $lines.Add("   Source: active coord shop COPY COORDS clipboard output.")
  $lines.Add("   Mockup-only write. */")
  $lines.Add("")

  foreach ($selector in $Selectors.Keys) {
    $c = $coords[$selector]
    $lines.Add(("{0} {{" -f $selector))
    $lines.Add(("  left: {0}% !important;" -f $c.left))
    $lines.Add(("  top: {0}% !important;" -f $c.top))
    $lines.Add(("  width: {0}% !important;" -f $c.width))
    $lines.Add(("  height: {0}% !important;" -f $c.height))
    $lines.Add("}")
    $lines.Add("")
  }

  $lines.Add("/* FINAL_BUTTON_COORDS_LOCK_20260614_R8_EXPORT END */")
  return ($lines -join "`r`n")
}

function Apply-Coords {
  param(
    $coords,
    [string]$clipHash
  )

  $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
  $backup = Join-Path $BackupDir "styles_before_R16_coord_clipboard_apply_$stamp.css"

  Write-BridgeEvent -Type "valid_coordinate_css_detected" -Data @{
    clipboard_hash = $clipHash
    target_css = $MockupCss
  }

  Copy-Item -LiteralPath $MockupCss -Destination $backup -Force
  Add-Content -LiteralPath $BackupsCreated -Value $backup -Encoding UTF8

  Write-BridgeEvent -Type "mockup_css_backup_made" -Data @{
    backup_path = $backup
    clipboard_hash = $clipHash
  }

  $text = Get-Content -LiteralPath $MockupCss -Raw
  $block = Build-FinalBlock -coords $coords
  $pattern = '(?s)\r?\n?/\* FINAL_BUTTON_COORDS_LOCK_20260614_R8_EXPORT BEGIN \*/.*?/\* FINAL_BUTTON_COORDS_LOCK_20260614_R8_EXPORT END \*/'

  Write-BridgeEvent -Type "mockup_css_write_started" -Data @{
    target_css = $MockupCss
    clipboard_hash = $clipHash
  }

  if ($text -match $pattern) {
    $text = [regex]::Replace($text, $pattern, "`r`n$block", 1)
  } else {
    $text = $text.TrimEnd() + "`r`n" + $block + "`r`n"
  }

  Set-Content -LiteralPath $MockupCss -Value $text.TrimEnd() -Encoding UTF8
  Set-Content -LiteralPath $LastAppliedCss -Value $block.TrimEnd() -Encoding UTF8
  ($coords | ConvertTo-Json -Depth 8) | Set-Content -LiteralPath $LastKnownCoords -Encoding UTF8

  Write-BridgeEvent -Type "mockup_css_write_succeeded" -Data @{
    target_css = $MockupCss
    backup_path = $backup
    clipboard_hash = $clipHash
  }

  Write-Host ""
  Write-Host "APPLIED COORDS TO MOCKUP CSS" -ForegroundColor Green
  Write-Host "Time: $stamp"
  Write-Host "Clipboard SHA256: $clipHash"
  Write-Host "Backup: $backup"
  Write-Host "Now Ctrl+F5 the mockup tab."
}

$lastHash = ""
$lastHeartbeat = Get-Date

try {
  while ($true) {
    Start-Sleep -Milliseconds 650

    $now = Get-Date
    if (($now - $lastHeartbeat).TotalSeconds -ge 10) {
      Write-Heartbeat
      Write-BridgeEvent -Type "heartbeat" -Data @{ target_css = $MockupCss }
      $lastHeartbeat = $now
    }

    $clip = Get-ClipboardTextSafe
    if ([string]::IsNullOrWhiteSpace($clip)) { continue }

    $hash = Get-TextHash -Text $clip
    if ($hash -eq $lastHash) { continue }

    Write-BridgeEvent -Type "clipboard_changed" -Data @{ clipboard_hash = $hash }

    $coords = Extract-Coords -Text $clip
    if ($null -eq $coords) {
      Write-BridgeEvent -Type "clipboard_ignored" -Data @{ clipboard_hash = $hash }
      $lastHash = $hash
      continue
    }

    Apply-Coords -coords $coords -clipHash $hash
    $lastHash = $hash
  }
} catch {
  Write-BridgeEvent -Type "bridge_fatal_error" -Data @{ error = $_.Exception.Message }
  throw
} finally {
  Write-BridgeEvent -Type "bridge_stopped" -Data @{ stop_time = (Get-Date).ToString("o") }
  try { Stop-Transcript | Out-Null } catch {}
}
