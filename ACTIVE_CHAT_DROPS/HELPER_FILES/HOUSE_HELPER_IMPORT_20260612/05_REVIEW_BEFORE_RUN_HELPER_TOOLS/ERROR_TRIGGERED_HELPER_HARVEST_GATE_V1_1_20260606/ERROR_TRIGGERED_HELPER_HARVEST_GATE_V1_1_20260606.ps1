<#
SCRIPT NAME:
ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_20260606.ps1

PURPOSE:
Stable replacement for ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_20260606.

This version avoids the V1 runtime type problem and writes the exact visible file context
that the next code run must read.

EXACT OPERATING RULE:
MAIN QUEST RUNS.
IF ERROR APPEARS:
  pause main quest
  log error to standalone error ledger
  classify error family
  fix the immediate issue
  decide whether the fix exposed reusable helper code
  if yes, place/test/hash/cut-map/adopt/promote or park it
  write receipt
  return to main quest
IF NO ERROR:
  do not invent side helper work

STATUS:
ERROR_TRIGGER_GATE / PRE-RUN_CONTEXT_WRITER / SIDE_QUEST_ROUTER / NOT_DOCTRINE

THIS SCRIPT DOES:
- logs the V1 gate runtime type error as harvested error evidence
- scans HELPER_TOOL_CODES error ledgers
- classifies clean evidence vs open side quest triggers
- writes CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT.md
- writes CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT.json
- writes ERROR_TRIGGERED_HELPER_HARVEST_STATE.json
- writes report and receipt

THIS SCRIPT DOES NOT:
- repair every error by itself
- promote tools
- open VS Code
- close VS Code
- delete project files
- archive project files
- dedupe project files
- live install command center
- promote doctrine
- commit
- push
- create watcher
- create automation

FIRST RUN RULE:
If no prior state file exists, this run establishes baseline from existing error ledgers.
Existing ErrorCount > 0 ledgers become BASELINE_ERROR_HISTORY_VISIBLE unless -ForceOpenExisting is used.
After the baseline exists, new ErrorCount > 0 ledgers become OPEN_SIDE_QUEST triggers.

WHY V1.1 EXISTS:
V1 hit SCRIPT_RUNTIME_TYPE_ERROR: "Argument types do not match".
V1.1 uses plain arrays/PSCustomObjects and safer state writing.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Root = "C:\Users\13527\Desktop\123",

    [Parameter(Mandatory = $false)]
    [switch]$ForceOpenExisting,

    [Parameter(Mandatory = $false)]
    [switch]$CloseOpenTickets,

    [Parameter(Mandatory = $false)]
    [string]$ClosureReceiptPath = "",

    [Parameter(Mandatory = $false)]
    [switch]$SkipPriorV1ErrorLedger
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DateTag = "20260606"
$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

$ToolRoot = Join-Path $Root "_TOOLS_AND_SCRIPTS\HELPER_TOOL_CODES"
$IndexRoot = Join-Path $ToolRoot "00_TOOL_INDEX"
$ReceiptRoot = Join-Path $ToolRoot "03_TOOL_RECEIPTS"
$ErrorRoot = Join-Path $ReceiptRoot "ERROR_LOGS"
$GateRoot = Join-Path $ReceiptRoot "ERROR_TRIGGERED_HELPER_HARVEST_GATE"
$RunRoot = Join-Path $GateRoot ("RUN_ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_" + $RunStamp)

$CurrentContextPath = Join-Path $IndexRoot "CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT.md"
$MachineContextPath = Join-Path $IndexRoot "CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT.json"
$StatePath = Join-Path $IndexRoot "ERROR_TRIGGERED_HELPER_HARVEST_STATE.json"

$ReceiptPath = Join-Path $RunRoot "RECEIPT__ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_20260606.md"
$ReportPath = Join-Path $RunRoot "REPORT__ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_20260606.md"
$GateErrorLedgerPath = Join-Path $RunRoot "ERROR_LEDGER__ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_20260606.md"

function New-Dir {
    param([string]$Path)
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Get-UtcNow {
    return (Get-Date).ToUniversalTime().ToString("o")
}

function Escape-MdCell {
    param([object]$Text)
    if ($null -eq $Text) { return "" }
    return ([string]$Text).Replace("|", "\|").Replace("`r", " ").Replace("`n", " ")
}

function Get-ErrorCountFromText {
    param([string]$Text)

    $m = [regex]::Match($Text, "(?im)^\s*ErrorCount\s*:\s*(\d+)\s*$")
    if ($m.Success) {
        return [int]$m.Groups[1].Value
    }

    return 0
}

function Get-CategoryListFromText {
    param([string]$Text)

    $out = @()

    foreach ($line in ($Text -split "`r?`n")) {
        if ($line -match "^\|\s*Category\s*\|") { continue }
        if ($line -match "^\|\s*---") { continue }

        if ($line -match "^\|\s*([^|\s][^|]*?)\s*\|") {
            $cat = $matches[1].Trim()
            if ($cat -and $cat -ne "Category" -and $cat -notmatch "^-+$") {
                $out += $cat
            }
        }

        if ($line -match "(?im)^\s*Category\s*:\s*(.+?)\s*$") {
            $out += $matches[1].Trim()
        }
    }

    return @($out | Sort-Object -Unique)
}

function Read-StateRows {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    try {
        $raw = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
        if ([string]::IsNullOrWhiteSpace($raw)) {
            return @()
        }

        $parsed = $raw | ConvertFrom-Json
        return @($parsed)
    }
    catch {
        return @()
    }
}

function Write-StateRows {
    param(
        [object[]]$Rows,
        [string]$Path
    )

    @($Rows) | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Write-PriorV1ErrorLedger {
    param(
        [string]$ErrorRootPath,
        [string]$RunStampValue
    )

    $dir = Join-Path $ErrorRootPath ("GATE_REPAIR_ERRORS_ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_" + $RunStampValue)
    New-Dir $dir

    $ledger = Join-Path $dir "ERROR_LEDGER__GATE_V1_RUNTIME_TYPE_ERROR_REPAIRED_BY_V1_1.md"

    $lines = @(
        "# ERROR LEDGER",
        "## GATE V1 RUNTIME TYPE ERROR",
        "",
        "GeneratedUtc: $(Get-UtcNow)",
        "ErrorCount: 1",
        "",
        "| Category | Phase | Message | Resolution |",
        "|---|---|---|---|",
        "| SCRIPT_RUNTIME_TYPE_ERROR | ERROR_TRIGGER_GATE_V1_RUN | V1 gate reported: Argument types do not match. | Replace V1 with V1.1 using plain arrays, safer JSON/state writing, and current-context receipt. |",
        "",
        "## TRIAD_REPAIR_MEMORY",
        "",
        "### ROOT_ERROR 1",
        "PARENT_ROOT: SCRIPT_RUNTIME_TYPE_ERROR / ERROR_TRIGGER_GATE_V1_RUN",
        "BROKEN_CODE_OR_COMMAND: ERROR_TRIGGER_GATE_V1_RUN / V1 gate runtime path",
        "ERROR_TEXT: V1 gate reported: Argument types do not match.",
        "FIXED_CODE_OR_PATCH: Replace V1 with V1.1 using plain arrays, safer JSON/state writing, and current-context receipt.",
        "FIX_RESULT: Prior V1 error is preserved as repair memory; this ledger itself does not prove V1.1 fixed it.",
        "FIX_EVIDENCE: This prior error ledger plus V1.1 context/receipt when generated.",
        "",
        "DoesNotProve:",
        "This ledger does not prove the gate is fixed until V1.1 writes CURRENT_ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT and a clean receipt."
    )

    $lines | Set-Content -LiteralPath $ledger -Encoding UTF8
    return $ledger
}

function Scan-ErrorLedgers {
    param([string]$ErrorRootPath)

    if (-not (Test-Path -LiteralPath $ErrorRootPath)) {
        return @()
    }

    $files = Get-ChildItem -LiteralPath $ErrorRootPath -Filter "ERROR_LEDGER__*.md" -File -Recurse -Force -ErrorAction SilentlyContinue
    $rows = @()

    foreach ($f in $files) {
        try {
            $text = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction Stop
            $hash = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash
            $rows += [pscustomobject]@{
                Path = $f.FullName
                SHA256 = $hash
                LastWriteTimeUtc = $f.LastWriteTimeUtc.ToString("o")
                ErrorCount = Get-ErrorCountFromText -Text $text
                Categories = @(Get-CategoryListFromText -Text $text)
            }
        }
        catch {
            $rows += [pscustomobject]@{
                Path = $f.FullName
                SHA256 = "HASH_OR_READ_FAILED"
                LastWriteTimeUtc = $f.LastWriteTimeUtc.ToString("o")
                ErrorCount = 1
                Categories = @("ERROR_LEDGER_READ_FAILED")
            }
        }
    }

    return @($rows)
}

New-Dir $ToolRoot
New-Dir $IndexRoot
New-Dir $ReceiptRoot
New-Dir $ErrorRoot
New-Dir $GateRoot
New-Dir $RunRoot

$actions = @()
$gateErrors = @()
$priorV1ErrorLedger = ""

try {
    if (-not $SkipPriorV1ErrorLedger) {
        $priorV1ErrorLedger = Write-PriorV1ErrorLedger -ErrorRootPath $ErrorRoot -RunStampValue $RunStamp
        $actions += "WROTE_PRIOR_V1_ERROR_LEDGER: $priorV1ErrorLedger"
    }

    if ($CloseOpenTickets) {
        if ([string]::IsNullOrWhiteSpace($ClosureReceiptPath)) {
            $gateErrors += [pscustomobject]@{
                Category = "CLOSURE_RECEIPT_REQUIRED"
                Phase = "CLOSE_OPEN_TICKETS"
                Message = "CloseOpenTickets was set but ClosureReceiptPath was empty."
                Resolution = "Provide -ClosureReceiptPath."
            }
        }
        elseif (-not (Test-Path -LiteralPath $ClosureReceiptPath)) {
            $gateErrors += [pscustomobject]@{
                Category = "CLOSURE_RECEIPT_NOT_FOUND"
                Phase = "CLOSE_OPEN_TICKETS"
                Message = $ClosureReceiptPath
                Resolution = "Provide an existing closure receipt."
            }
        }
    }

    $stateExistedAtStart = Test-Path -LiteralPath $StatePath
    $baselineEstablishedNow = -not $stateExistedAtStart

    $oldState = @(Read-StateRows -Path $StatePath)
    $ledgerRows = @(Scan-ErrorLedgers -ErrorRootPath $ErrorRoot)

    $newState = @()
    $openRows = @()

    foreach ($ledger in $ledgerRows) {
        $existing = @($oldState | Where-Object { $_.SHA256 -eq $ledger.SHA256 -or $_.Path -eq $ledger.Path } | Select-Object -First 1)

        $status = "CLEAN_EVIDENCE"
        $firstSeen = Get-UtcNow
        $closedBy = ""
        $harvestDecision = "NO_ERROR_TRIGGER"

        if ($existing.Count -gt 0) {
            $status = [string]$existing[0].Status
            if ($existing[0].PSObject.Properties.Name -contains "FirstSeenUtc") {
                $firstSeen = [string]$existing[0].FirstSeenUtc
            }
            if ($existing[0].PSObject.Properties.Name -contains "ClosedByReceipt") {
                $closedBy = [string]$existing[0].ClosedByReceipt
            }
            if ($existing[0].PSObject.Properties.Name -contains "HarvestDecision") {
                $harvestDecision = [string]$existing[0].HarvestDecision
            }
        }
        else {
            if ([int]$ledger.ErrorCount -gt 0) {
                if ($baselineEstablishedNow -and (-not $ForceOpenExisting)) {
                    $status = "BASELINE_ERROR_HISTORY_VISIBLE"
                    $harvestDecision = "VISIBLE_HISTORY_NOT_NEW_TRIGGER"
                }
                else {
                    $status = "OPEN_SIDE_QUEST"
                    $harvestDecision = "ERROR_TRIGGERED_HELPER_HARVEST_REQUIRED"
                }
            }
        }

        if ($CloseOpenTickets -and $status -eq "OPEN_SIDE_QUEST" -and $gateErrors.Count -eq 0) {
            $status = "CLOSED_BY_RECEIPT"
            $closedBy = $ClosureReceiptPath
            $harvestDecision = "SIDE_QUEST_CLOSED_RETURN_TO_MAIN"
            $actions += "CLOSED_OPEN_TICKET_BY_RECEIPT: $($ledger.Path)"
        }

        $row = [pscustomobject]@{
            Path = [string]$ledger.Path
            SHA256 = [string]$ledger.SHA256
            FirstSeenUtc = [string]$firstSeen
            LastSeenUtc = [string](Get-UtcNow)
            LastWriteTimeUtc = [string]$ledger.LastWriteTimeUtc
            ErrorCount = [int]$ledger.ErrorCount
            Categories = @($ledger.Categories)
            Status = [string]$status
            HarvestDecision = [string]$harvestDecision
            ClosedByReceipt = [string]$closedBy
        }

        $newState += $row

        if ($status -eq "OPEN_SIDE_QUEST") {
            $openRows += $row
        }
    }

    Write-StateRows -Rows @($newState) -Path $StatePath
    $actions += "WROTE_STATE_FILE: $StatePath"

    $totalLedgerCount = @($ledgerRows).Count
    $errorTriggerCount = @($ledgerRows | Where-Object { [int]$_.ErrorCount -gt 0 }).Count
    $cleanLedgerCount = @($ledgerRows | Where-Object { [int]$_.ErrorCount -eq 0 }).Count
    $openSideQuestRequired = (@($openRows).Count -gt 0)

    $statusText = if ($gateErrors.Count -eq 0) {
        "ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT_WRITTEN"
    }
    else {
        "ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT_WRITTEN_WITH_GATE_ERRORS"
    }

    $machine = [pscustomobject]@{
        GeneratedUtc = Get-UtcNow
        RunStamp = $RunStamp
        Status = $statusText
        BaselineEstablishedNow = $baselineEstablishedNow
        TotalErrorLedgersScanned = $totalLedgerCount
        ErrorTriggerLedgerCount = $errorTriggerCount
        CleanLedgerCount = $cleanLedgerCount
        OpenSideQuestRequired = $openSideQuestRequired
        OpenSideQuestCount = @($openRows).Count
        PriorV1ErrorLedger = $priorV1ErrorLedger
        CurrentContextPath = $CurrentContextPath
        StatePath = $StatePath
        ReceiptPath = $ReceiptPath
        ReportPath = $ReportPath
        OpenTickets = @($openRows)
        GateErrors = @($gateErrors)
    }

    $context = @()
    $context += "# CURRENT ERROR TRIGGERED HELPER HARVEST CONTEXT"
    $context += ""
    $context += "GeneratedUtc: $(Get-UtcNow)"
    $context += "RunStamp: $RunStamp"
    $context += "Status: $statusText"
    $context += "BaselineEstablishedNow: $baselineEstablishedNow"
    $context += "TotalErrorLedgersScanned: $totalLedgerCount"
    $context += "ErrorTriggerLedgerCount: $errorTriggerCount"
    $context += "CleanLedgerCount: $cleanLedgerCount"
    $context += "OpenSideQuestRequired: $openSideQuestRequired"
    $context += "OpenSideQuestCount: $(@($openRows).Count)"
    $context += "PriorV1ErrorLedger: $priorV1ErrorLedger"
    $context += ""
    $context += "# Exact Operating Rule"
    $context += ""
    $context += "MAIN QUEST RUNS."
    $context += ""
    $context += "IF ERROR APPEARS:"
    $context += "1. pause main quest"
    $context += "2. log error to standalone error ledger"
    $context += "3. classify error family"
    $context += "4. fix the immediate issue"
    $context += "5. decide whether the fix exposed reusable helper code"
    $context += "6. if yes, place/test/hash/cut-map/adopt/promote or park it"
    $context += "7. write receipt"
    $context += "8. return to main quest"
    $context += ""
    $context += "IF NO ERROR:"
    $context += "do not invent side helper work"
    $context += ""
    $context += "# Meaning"
    $context += ""
    $context += "This is not recursive bloat."
    $context += "This is error-triggered helper harvest."
    $context += "Collect them as they fall, then return to the main quest."
    $context += ""
    $context += "# Next Code Run Requirement"
    $context += ""
    $context += "Before any next code helper is written or run, read this context file."
    $context += "If OpenSideQuestRequired is true, the next code run must pause the main quest and resolve/park the listed open side quest first."
    $context += "If OpenSideQuestRequired is false, continue the main quest and do not chase helper side work."
    $context += "Any new ErrorCount > 0 ledger after this baseline must become a visible side-quest trigger."
    $context += ""
    $context += "# Open Side Quest Tickets"
    $context += ""

    if (@($openRows).Count -eq 0) {
        $context += "None."
    }
    else {
        $context += "| Status | ErrorCount | Categories | ErrorLedger |"
        $context += "|---|---:|---|---|"
        foreach ($r in $openRows) {
            $context += "| $(Escape-MdCell $r.Status) | $($r.ErrorCount) | $(Escape-MdCell (($r.Categories) -join '; ')) | $(Escape-MdCell $r.Path) |"
        }
    }

    $context += ""
    $context += "# Ledger Summary"
    $context += ""
    $context += "| Status | ErrorCount | Categories | ErrorLedger |"
    $context += "|---|---:|---|---|"
    foreach ($r in $newState) {
        $context += "| $(Escape-MdCell $r.Status) | $($r.ErrorCount) | $(Escape-MdCell (($r.Categories) -join '; ')) | $(Escape-MdCell $r.Path) |"
    }

    $context += ""
    $context += "# DoesNotProve"
    $context += ""
    $context += "This context file does not prove a fix."
    $context += "This context file does not promote helper code."
    $context += "This context file does not approve live install."
    $context += "This context file does not promote doctrine."
    $context += "This context file does not authorize cleanup, deletion, archive, dedupe, commit, push, watcher, automation, or live mutation."

    $context | Set-Content -LiteralPath $CurrentContextPath -Encoding UTF8
    $machine | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $MachineContextPath -Encoding UTF8

    $gateErrorLines = @()
    $gateErrorLines += "# ERROR LEDGER"
    $gateErrorLines += "## ERROR TRIGGERED HELPER HARVEST GATE V1.1"
    $gateErrorLines += ""
    $gateErrorLines += "GeneratedUtc: $(Get-UtcNow)"
    $gateErrorLines += "ErrorCount: $($gateErrors.Count)"
    $gateErrorLines += ""
    $gateErrorLines += "| Category | Phase | Message | Resolution |"
    $gateErrorLines += "|---|---|---|---|"
    foreach ($e in $gateErrors) {
        $gateErrorLines += "| $(Escape-MdCell $e.Category) | $(Escape-MdCell $e.Phase) | $(Escape-MdCell $e.Message) | $(Escape-MdCell $e.Resolution) |"
    }

    $gateErrorLines += ""
    $gateErrorLines += "## TRIAD_REPAIR_MEMORY"
    $gateErrorLines += ""

    if ($gateErrors.Count -eq 0) {
        $gateErrorLines += "NO_ERROR_RECORDED:"
        $gateErrorLines += "BROKEN_CODE_OR_COMMAND: NONE"
        $gateErrorLines += "ERROR_TEXT: NONE"
        $gateErrorLines += "FIXED_CODE_OR_PATCH: NONE"
        $gateErrorLines += "FIX_RESULT: ERROR_TRIGGERED_HELPER_HARVEST_CONTEXT_WRITTEN"
        $gateErrorLines += "FIX_EVIDENCE: GateErrorCount 0 plus report/receipt/context paths."
    }
    else {
        $triadIndex = 0
        foreach ($e in $gateErrors) {
            $triadIndex++

            if ($triadIndex -eq 1) {
                $gateErrorLines += "### ROOT_ERROR $triadIndex"
            }
            else {
                $gateErrorLines += "### SUB_ERROR $triadIndex"
                $gateErrorLines += '"""" SAME ROOT AS ABOVE WHEN CATEGORY/PHASE MATCHES PRIOR ROOT; otherwise treat as new root.'
            }

            $parentRoot = "$(Escape-MdCell $e.Category) / $(Escape-MdCell $e.Phase)"
            $broken = "PHASE: $(Escape-MdCell $e.Phase)"
            $errText = "$(Escape-MdCell $e.Message)"
            $fixed = "NOT_APPLIED_BY_THIS_GATE; resolution records next safe action: $(Escape-MdCell $e.Resolution)"
            $fixResult = "$(Escape-MdCell $e.Resolution)"
            $fixEvidence = "GateErrorCount plus report/receipt/context paths."

            $gateErrorLines += "PARENT_ROOT: $parentRoot"
            $gateErrorLines += "BROKEN_CODE_OR_COMMAND: $broken"
            $gateErrorLines += "ERROR_TEXT: $errText"
            $gateErrorLines += "FIXED_CODE_OR_PATCH: $fixed"
            $gateErrorLines += "FIX_RESULT: $fixResult"
            $gateErrorLines += "FIX_EVIDENCE: $fixEvidence"
            $gateErrorLines += ""
        }
    }

    $gateErrorLines += ""
    $gateErrorLines += "DoesNotProve:"
    $gateErrorLines += "This gate error ledger does not approve live install or doctrine promotion."
    $gateErrorLines | Set-Content -LiteralPath $GateErrorLedgerPath -Encoding UTF8

    $report = @"
# REPORT
## ERROR TRIGGERED HELPER HARVEST GATE V1.1

Date: $DateTag
RunStamp: $RunStamp
Status: $statusText

BaselineEstablishedNow:
$baselineEstablishedNow

TotalErrorLedgersScanned:
$totalLedgerCount

ErrorTriggerLedgerCount:
$errorTriggerCount

CleanLedgerCount:
$cleanLedgerCount

OpenSideQuestRequired:
$openSideQuestRequired

OpenSideQuestCount:
$(@($openRows).Count)

PriorV1ErrorLedger:
$priorV1ErrorLedger

CurrentContext:
$CurrentContextPath

MachineContext:
$MachineContextPath

StatePath:
$StatePath

GateErrorLedger:
$GateErrorLedgerPath

Actions:
$($actions -join "`n")

Rule:
MAIN QUEST RUNS.
IF ERROR APPEARS, pause main quest, log/classify/fix/harvest-or-park/receipt, then return to main quest.
IF NO ERROR, do not invent helper side work.

DoesNotProve:
This report does not approve live install.
This report does not promote doctrine.
This report does not authorize cleanup.
"@

    $receipt = @"
# RECEIPT
## ERROR TRIGGERED HELPER HARVEST GATE V1.1

Date: $DateTag
RunStamp: $RunStamp
Status: $statusText

CurrentContext:
$CurrentContextPath

MachineContext:
$MachineContextPath

StatePath:
$StatePath

Report:
$ReportPath

GateErrorLedger:
$GateErrorLedgerPath

PriorV1ErrorLedger:
$priorV1ErrorLedger

TotalErrorLedgersScanned:
$totalLedgerCount

OpenSideQuestRequired:
$openSideQuestRequired

OpenSideQuestCount:
$(@($openRows).Count)

GateErrorCount:
$($gateErrors.Count)

NoMutationFlags:
RanRepair: false
PromotedTool: false
OpenedVSCode: false
ClosedVSCode: false
DeletedProjectWork: false
ArchivedProjectWork: false
DedupedProjectWork: false
LiveCommandCenterInstall: false
DoctrinePromoted: false
Committed: false
Pushed: false
WatcherInstalled: false
AutomationInstalled: false

NextLegalAction:
If OpenSideQuestRequired is true, resolve/park the listed side quest before returning to the main quest.
If OpenSideQuestRequired is false, continue the main quest and do not invent helper side work.
"@

    $report | Set-Content -LiteralPath $ReportPath -Encoding UTF8
    $receipt | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

    Write-Host ""
    Write-Host "Error-triggered helper harvest gate complete."
    Write-Host "Status:"
    Write-Host $statusText
    Write-Host ""
    Write-Host "BaselineEstablishedNow:"
    Write-Host $baselineEstablishedNow
    Write-Host ""
    Write-Host "OpenSideQuestRequired:"
    Write-Host $openSideQuestRequired
    Write-Host ""
    Write-Host "OpenSideQuestCount:"
    Write-Host @($openRows).Count
    Write-Host ""
    Write-Host "Current context:"
    Write-Host $CurrentContextPath
    Write-Host ""
    Write-Host "Receipt:"
    Write-Host $ReceiptPath
    Write-Host ""
    Write-Host "DONE_MARKER: ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_FINALIZED"
}
catch {
    $failDir = Join-Path $RunRoot "FAILED_TOP_LEVEL"
    New-Dir $failDir
    $failLedger = Join-Path $failDir "ERROR_LEDGER__ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1_TOP_LEVEL_FAILURE.md"

    @(
        "# ERROR LEDGER",
        "## ERROR TRIGGERED HELPER HARVEST GATE V1.1 TOP LEVEL FAILURE",
        "",
        "GeneratedUtc: $(Get-UtcNow)",
        "ErrorCount: 1",
        "",
        "| Category | Phase | Message | Resolution |",
        "|---|---|---|---|",
        "| GATE_V1_1_TOP_LEVEL_FAILURE | TOP_LEVEL | $(Escape-MdCell $_.Exception.Message) | Do not trust gate context until this script is repaired. |",
        "",
        "## TRIAD_REPAIR_MEMORY",
        "",
        "### ROOT_ERROR 1",
        "PARENT_ROOT: GATE_V1_1_TOP_LEVEL_FAILURE / TOP_LEVEL",
        "BROKEN_CODE_OR_COMMAND: TOP_LEVEL / ERROR_TRIGGERED_HELPER_HARVEST_GATE_V1_1",
        "ERROR_TEXT: $(Escape-MdCell $_.Exception.Message)",
        "FIXED_CODE_OR_PATCH: NOT_APPLIED_BY_THIS_GATE; repair this script before trusting generated context.",
        "FIX_RESULT: Do not trust gate context until this script is repaired.",
        "FIX_EVIDENCE: Failure ledger path plus parse/runtime repair receipt after fix.",
        "",
        "DoesNotProve:",
        "This failure ledger does not prove context was written."
    ) | Set-Content -LiteralPath $failLedger -Encoding UTF8

    Write-Host ""
    Write-Host "Gate V1.1 failed."
    Write-Host "Failure ledger:"
    Write-Host $failLedger
    throw
}

