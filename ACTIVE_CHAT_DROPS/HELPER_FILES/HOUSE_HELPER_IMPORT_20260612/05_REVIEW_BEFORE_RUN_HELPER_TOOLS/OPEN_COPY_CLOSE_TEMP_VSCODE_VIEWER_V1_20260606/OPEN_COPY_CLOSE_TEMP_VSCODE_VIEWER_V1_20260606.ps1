<#
SCRIPT NAME:
OPEN_COPY_CLOSE_TEMP_VSCODE_VIEWER_V1_20260606.ps1

PURPOSE:
Open a target file in a temporary VS Code viewer, wait 5 seconds,
copy the target file content from disk, close only the temporary VS Code viewer,
and write a receipt/error ledger.

STATUS:
VIEWER_HELPER / COPY_HELPER / TEMP_PROFILE_ONLY / NO_PROJECT_MUTATION

THIS SCRIPT DOES:
- open VS Code using a temporary user-data-dir and extensions-dir
- wait 5 seconds after launch
- copy target file content from disk, not from the visible page
- close only VS Code processes tied to the temporary user-data-dir
- write a viewer receipt
- write a small error ledger if needed

THIS SCRIPT DOES NOT:
- close the user's normal VS Code windows
- edit the target file
- approve live install
- promote doctrine
- delete project work
- archive project work
- dedupe project work
- commit
- push
- create watcher
- create automation

IMPORTANT:
This tool is for temporary viewing only.
Open/view is not proof.
Copying comes from the saved file on disk, not the VS Code page.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [string]$TargetFile = "",

    [Parameter(Mandatory = $false)]
    [string]$TargetKind = "LATEST_CUT_MAP",

    [Parameter(Mandatory = $false)]
    [int]$LoadWaitSeconds = 5,

    [Parameter(Mandatory = $false)]
    [int]$CloseWaitSeconds = 2,

    [Parameter(Mandatory = $false)]
    [switch]$NoClipboard,

    [Parameter(Mandatory = $false)]
    [switch]$NoClose
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DateTag = "20260606"
$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

$ToolRoot = Join-Path $Root "_TOOLS_AND_SCRIPTS\HELPER_TOOL_CODES"
$ReceiptRoot = Join-Path $ToolRoot "03_TOOL_RECEIPTS"
$ViewerRoot = Join-Path $ReceiptRoot "VIEWER_LIFECYCLE"
$RunRoot = Join-Path $ViewerRoot ("RUN_OPEN_COPY_CLOSE_TEMP_VSCODE_VIEWER_V1_" + $RunStamp)
$TempProfileRoot = Join-Path $RunRoot "TEMP_VSCODE_PROFILE"
$TempExtensionsRoot = Join-Path $RunRoot "TEMP_VSCODE_EXTENSIONS"

$ReceiptPath = Join-Path $RunRoot "RECEIPT__OPEN_COPY_CLOSE_TEMP_VSCODE_VIEWER_V1_20260606.md"
$ErrorLedgerPath = Join-Path $RunRoot "ERROR_LEDGER__OPEN_COPY_CLOSE_TEMP_VSCODE_VIEWER_V1_20260606.md"

$Errors = New-Object System.Collections.Generic.List[object]
$Actions = New-Object System.Collections.Generic.List[string]

function New-Dir {
    param([string]$Path)
    [System.IO.Directory]::CreateDirectory($Path) | Out-Null
}

function Get-UtcNow {
    return (Get-Date).ToUniversalTime().ToString("o")
}

function Add-ViewerError {
    param(
        [string]$Category,
        [string]$Phase,
        [string]$Message,
        [string]$Resolution = "",
        [string]$BrokenCodeOrCommand = "",
        [string]$ErrorText = "",
        [string]$FixedCodeOrPatch = "",
        [string]$FixResult = "",
        [string]$FixEvidence = "",
        [string]$ParentRoot = ""
    )

    if ([string]::IsNullOrWhiteSpace($ErrorText)) { $ErrorText = $Message }
    if ([string]::IsNullOrWhiteSpace($FixResult)) { $FixResult = $Resolution }
    if ([string]::IsNullOrWhiteSpace($BrokenCodeOrCommand)) { $BrokenCodeOrCommand = "PHASE: $Phase" }
    if ([string]::IsNullOrWhiteSpace($FixedCodeOrPatch)) { $FixedCodeOrPatch = "NOT_APPLIED_BY_THIS_HELPER; resolution records next safe action." }
    if ([string]::IsNullOrWhiteSpace($FixEvidence)) { $FixEvidence = "FinalStatus plus ErrorCount plus receipt/error-ledger path." }
    if ([string]::IsNullOrWhiteSpace($ParentRoot)) { $ParentRoot = "$Category / $Phase" }

    $Errors.Add([pscustomobject]@{
        TimestampUtc = Get-UtcNow
        Category = $Category
        Phase = $Phase
        Message = $Message
        Resolution = $Resolution
        BrokenCodeOrCommand = $BrokenCodeOrCommand
        ErrorText = $ErrorText
        FixedCodeOrPatch = $FixedCodeOrPatch
        FixResult = $FixResult
        FixEvidence = $FixEvidence
        ParentRoot = $ParentRoot
        ContinuationMarker = '""""'
    })
}

function Find-LatestCutMap {
    param([string]$RootPath)

    $cutRoot = Join-Path $RootPath "_TOOLS_AND_SCRIPTS\HELPER_TOOL_CODES\05_ADOPTION_CUT_MAPS"

    if (-not (Test-Path -LiteralPath $cutRoot)) {
        throw "CUT_MAP_ROOT_NOT_FOUND: $cutRoot"
    }

    $latest = Get-ChildItem -LiteralPath $cutRoot -Filter "CUT_MAP__*.md" -File -Recurse -Force -ErrorAction Stop |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($null -eq $latest) {
        throw "NO_CUT_MAP_FOUND_UNDER: $cutRoot"
    }

    return $latest.FullName
}

function Find-CodeCommand {
    $cmd = Get-Command "code.cmd" -ErrorAction SilentlyContinue
    if ($null -ne $cmd) {
        return $cmd.Source
    }

    $cmd2 = Get-Command "code" -ErrorAction SilentlyContinue
    if ($null -ne $cmd2) {
        return $cmd2.Source
    }

    $common = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin\code.cmd"),
        "C:\Program Files\Microsoft VS Code\bin\code.cmd",
        "C:\Program Files (x86)\Microsoft VS Code\bin\code.cmd"
    )

    foreach ($p in $common) {
        if (Test-Path -LiteralPath $p) {
            return $p
        }
    }

    throw "VS_CODE_COMMAND_NOT_FOUND"
}

function Get-CodeProcessesForProfile {
    param([string]$ProfilePath)

    $needle = $ProfilePath.Replace("\", "\\")

    $processes = Get-CimInstance Win32_Process -Filter "name = 'Code.exe'" -ErrorAction SilentlyContinue |
        Where-Object {
            $_.CommandLine -and (
                $_.CommandLine -like "*$ProfilePath*" -or
                $_.CommandLine -like "*$needle*"
            )
        }

    return @($processes)
}

New-Dir $ToolRoot
New-Dir $ReceiptRoot
New-Dir $ViewerRoot
New-Dir $RunRoot
New-Dir $TempProfileRoot
New-Dir $TempExtensionsRoot

try {
    if ([string]::IsNullOrWhiteSpace($TargetFile)) {
        if ($TargetKind -eq "LATEST_CUT_MAP") {
            $TargetFile = Find-LatestCutMap -RootPath $Root
            $Actions.Add("TARGET_SELECTED_LATEST_CUT_MAP")
        }
        else {
            throw "TARGET_FILE_REQUIRED_FOR_TARGET_KIND: $TargetKind"
        }
    }

    $TargetFile = [System.IO.Path]::GetFullPath($TargetFile)

    if (-not (Test-Path -LiteralPath $TargetFile)) {
        throw "TARGET_FILE_NOT_FOUND: $TargetFile"
    }

    $targetItem = Get-Item -LiteralPath $TargetFile -Force
    if ($targetItem.PSIsContainer) {
        throw "TARGET_IS_FOLDER_NOT_FILE: $TargetFile"
    }

    $CodeCommand = Find-CodeCommand
    $Actions.Add("CODE_COMMAND_FOUND: $CodeCommand")

    $args = @(
        "--new-window",
        "--user-data-dir", $TempProfileRoot,
        "--extensions-dir", $TempExtensionsRoot,
        $TargetFile
    )

    $Actions.Add("STARTING_TEMP_VSCODE_VIEWER")
    $launch = Start-Process -FilePath $CodeCommand -ArgumentList $args -PassThru -WindowStyle Normal
    $Actions.Add("START_PROCESS_RETURNED_PID: $($launch.Id)")

    Write-Host ""
    Write-Host "Temporary VS Code viewer requested."
    Write-Host "Waiting $LoadWaitSeconds seconds for viewer load..."
    Start-Sleep -Seconds $LoadWaitSeconds

    if (-not $NoClipboard) {
        try {
            $content = Get-Content -LiteralPath $TargetFile -Raw -ErrorAction Stop
            Set-Clipboard -Value $content
            $Actions.Add("COPIED_TARGET_FILE_CONTENT_FROM_DISK_TO_CLIPBOARD")
        }
        catch {
            Add-ViewerError -Category "CLIPBOARD_COPY_FAILED" -Phase "COPY_FROM_DISK" -Message $_.Exception.Message -Resolution "Open the target file manually or rerun without clipboard dependency."
        }
    }
    else {
        $Actions.Add("CLIPBOARD_COPY_SKIPPED_BY_FLAG")
    }

    Start-Sleep -Seconds $CloseWaitSeconds

    if (-not $NoClose) {
        $viewerProcesses = Get-CodeProcessesForProfile -ProfilePath $TempProfileRoot
        $Actions.Add("TEMP_PROFILE_CODE_PROCESS_COUNT: $($viewerProcesses.Count)")

        foreach ($p in $viewerProcesses) {
            try {
                Stop-Process -Id $p.ProcessId -Force -ErrorAction Stop
                $Actions.Add("STOPPED_TEMP_VSCODE_PROCESS: $($p.ProcessId)")
            }
            catch {
                Add-ViewerError -Category "VIEWER_CLOSE_FAILED" -Phase "CLOSE_TEMP_VSCODE" -Message $_.Exception.Message -Resolution "Close the temporary VS Code window manually. Do not close unrelated unsaved VS Code work."
            }
        }

        if ($viewerProcesses.Count -eq 0) {
            Add-ViewerError -Category "VIEWER_PROCESS_NOT_FOUND" -Phase "CLOSE_TEMP_VSCODE" -Message "No Code.exe process was found with the temporary user-data-dir." -Resolution "The viewer may have exited already or VS Code reused another process. Do not force-close unrelated VS Code windows."
        }
    }
    else {
        $Actions.Add("VIEWER_CLOSE_SKIPPED_BY_FLAG")
    }
}
catch {
    Add-ViewerError -Category "VIEWER_HELPER_FAILED" -Phase "TOP_LEVEL" -Message $_.Exception.Message -Resolution "Review receipt and rerun with explicit -TargetFile if needed."
}

$finalStatus = if ($Errors.Count -eq 0) {
    "VIEWER_OPEN_COPY_CLOSE_COMPLETE"
}
else {
    "VIEWER_OPEN_COPY_CLOSE_COMPLETED_WITH_ERRORS"
}

$errorLines = New-Object System.Collections.Generic.List[string]
$errorLines.Add("# ERROR LEDGER")
$errorLines.Add("## OPEN_COPY_CLOSE_TEMP_VSCODE_VIEWER V1")
$errorLines.Add("")
$errorLines.Add("GeneratedUtc: $(Get-UtcNow)")
$errorLines.Add("RunStamp: $RunStamp")
$errorLines.Add("ErrorCount: $($Errors.Count)")
$errorLines.Add("")
$errorLines.Add("| Category | Phase | Message | Resolution |")
$errorLines.Add("|---|---|---|---|")
foreach ($e in $Errors) {
    $msg = ([string]$e.Message).Replace("|", "\|").Replace("`r", " ").Replace("`n", " ")
    $res = ([string]$e.Resolution).Replace("|", "\|").Replace("`r", " ").Replace("`n", " ")
    $errorLines.Add("| $($e.Category) | $($e.Phase) | $msg | $res |")
}

$errorLines.Add("")
$errorLines.Add("## TRIAD_REPAIR_MEMORY")
$errorLines.Add("")

if ($Errors.Count -eq 0) {
    $errorLines.Add("NO_ERROR_RECORDED:")
    $errorLines.Add("BROKEN_CODE_OR_COMMAND: NONE")
    $errorLines.Add("ERROR_TEXT: NONE")
    $errorLines.Add("FIXED_CODE_OR_PATCH: NONE")
    $errorLines.Add("FIX_RESULT: VIEWER_OPEN_COPY_CLOSE_COMPLETE")
    $errorLines.Add("FIX_EVIDENCE: ErrorCount 0 plus receipt path.")
}
else {
    $triadIndex = 0
    foreach ($e in $Errors) {
        $triadIndex++

        if ($triadIndex -eq 1) {
            $errorLines.Add("### ROOT_ERROR $triadIndex")
        }
        else {
            $errorLines.Add("### SUB_ERROR $triadIndex")
            $errorLines.Add('"""" SAME ROOT AS ABOVE WHEN CATEGORY/PHASE MATCHES PRIOR ROOT; otherwise treat as new root.')
        }

        $broken = ([string]$e.BrokenCodeOrCommand).Replace("`r", " ").Replace("`n", " ")
        $errText = ([string]$e.ErrorText).Replace("`r", " ").Replace("`n", " ")
        $fixed = ([string]$e.FixedCodeOrPatch).Replace("`r", " ").Replace("`n", " ")
        $fixResult = ([string]$e.FixResult).Replace("`r", " ").Replace("`n", " ")
        $fixEvidence = ([string]$e.FixEvidence).Replace("`r", " ").Replace("`n", " ")
        $parentRoot = ([string]$e.ParentRoot).Replace("`r", " ").Replace("`n", " ")

        $errorLines.Add("PARENT_ROOT: $parentRoot")
        $errorLines.Add("BROKEN_CODE_OR_COMMAND: $broken")
        $errorLines.Add("ERROR_TEXT: $errText")
        $errorLines.Add("FIXED_CODE_OR_PATCH: $fixed")
        $errorLines.Add("FIX_RESULT: $fixResult")
        $errorLines.Add("FIX_EVIDENCE: $fixEvidence")
        $errorLines.Add("")
    }
}

$errorLines.Add("")
$errorLines.Add("## DoesNotProve")
$errorLines.Add("")
$errorLines.Add("This error ledger does not prove live install.")
$errorLines.Add("This error ledger does not prove doctrine promotion.")
$errorLines.Add("This error ledger does not authorize cleanup.")
$errorLines | Set-Content -LiteralPath $ErrorLedgerPath -Encoding UTF8

$receipt = @"
# RECEIPT
## OPEN COPY CLOSE TEMP VSCODE VIEWER V1

Date: $DateTag
RunStamp: $RunStamp
FinalStatus: $finalStatus

TargetFile:
$TargetFile

LoadWaitSeconds:
$LoadWaitSeconds

CloseWaitSeconds:
$CloseWaitSeconds

TempProfileRoot:
$TempProfileRoot

TempExtensionsRoot:
$TempExtensionsRoot

Actions:
$($Actions -join "`n")

ErrorCount:
$($Errors.Count)

ErrorLedger:
$ErrorLedgerPath

NoMutationFlags:
EditedTargetFile: false
ClosedUserNormalVSCode: false
LiveCommandCenterInstall: false
DoctrinePromoted: false
DeletedProjectWork: false
ArchivedProjectWork: false
DedupedProjectWork: false
Committed: false
Pushed: false
WatcherInstalled: false
AutomationInstalled: false

Rule:
Open/view is not proof.
Copying comes from saved file content on disk.
Close only VS Code processes tied to this temporary user-data-dir.
Main shell should finish independently of viewer lifecycle.

DoesNotProve:
This viewer receipt does not approve live install.
This viewer receipt does not promote doctrine.
This viewer receipt does not prove the target file is correct.
This viewer receipt does not authorize cleanup, deletion, archive, dedupe, commit, push, watcher, automation, or live mutation.
"@

$receipt | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

Write-Host ""
Write-Host "Viewer helper complete."
Write-Host "FinalStatus:"
Write-Host $finalStatus
Write-Host ""
Write-Host "ErrorCount:"
Write-Host $Errors.Count
Write-Host ""
Write-Host "Receipt:"
Write-Host $ReceiptPath
Write-Host ""
Write-Host "ErrorLedger:"
Write-Host $ErrorLedgerPath
Write-Host ""
Write-Host "TargetFile:"
Write-Host $TargetFile
Write-Host ""
Write-Host "DONE_MARKER: VIEWER_HELPER_FINALIZED"

