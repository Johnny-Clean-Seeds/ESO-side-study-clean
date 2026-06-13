# REPAIR_SAVE_EXISTING_TIGHT_SNAP_RULE_20260613.ps1
# Purpose:
#   Repair the interrupted snap-rule save by reading the CURRENT tight snap code
#   already saved in the mockup page/CSS, then writing the saved rule cards and receipt.
#
# Scope:
#   - Reads:  mockup public.html and styles.css
#   - Writes: snap rule cards + repair receipt only
#   - Does NOT rewrite page HTML
#   - Does NOT rewrite CSS
#   - Does NOT change coords/image/button text/live ESO
#   - Does NOT commit or push

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step([string]$Message) {
  Write-Host $Message -ForegroundColor Cyan
}

function Write-Ok([string]$Message) {
  Write-Host $Message -ForegroundColor Green
}

function Write-Warn([string]$Message) {
  Write-Host $Message -ForegroundColor Yellow
}

$Root = "C:\Users\13527\Desktop\ESO\ESO"
$MockRoot = Join-Path $Root "ESO_INDEX_SITE_MOCKUP_20260611_152646"
$MockPage = Join-Path $MockRoot "reader\index\public.html"
$MockCss  = Join-Path $MockRoot "assets\styles.css"

$MockToolDir = Join-Path $MockRoot "_WORKSHOP_TOOLS"
$RealToolDir = Join-Path $Root "TOOLS\COORD_MARK_TOOL_R8_UNIVERSAL_CARD"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupDir = Join-Path $Root "ACTIVE_CHAT_DROPS\SITE_BACKUPS\REPAIR_SAVE_EXISTING_TIGHT_SNAP_RULE_$Stamp"
$ReceiptPath = Join-Path $BackupDir "REPAIR_SAVE_EXISTING_TIGHT_SNAP_RULE_RECEIPT.md"

$MockCard = Join-Path $MockToolDir "SNAP_RESIZE_RESPECT_EDGES_RULE_20260613.md"
$RealCard = Join-Path $RealToolDir "SNAP_RESIZE_RESPECT_EDGES_RULE_20260613.md"

Write-Step "=== REPAIR: SAVE EXISTING TIGHT SNAP RULE ==="

foreach ($p in @($Root, $MockRoot, $MockPage, $MockCss)) {
  if (!(Test-Path -LiteralPath $p)) {
    throw "Missing required path: $p"
  }
}

New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
New-Item -ItemType Directory -Force -Path $MockToolDir | Out-Null
New-Item -ItemType Directory -Force -Path $RealToolDir | Out-Null

Copy-Item -LiteralPath $MockPage -Destination (Join-Path $BackupDir "public_CURRENT.html") -Force
Copy-Item -LiteralPath $MockCss  -Destination (Join-Path $BackupDir "styles_CURRENT.css") -Force

if (Test-Path -LiteralPath $MockCard) {
  Copy-Item -LiteralPath $MockCard -Destination (Join-Path $BackupDir "mock_snap_rule_BEFORE.md") -Force
}

if (Test-Path -LiteralPath $RealCard) {
  Copy-Item -LiteralPath $RealCard -Destination (Join-Path $BackupDir "real_snap_rule_BEFORE.md") -Force
}

$html = Get-Content -LiteralPath $MockPage -Raw
$css  = Get-Content -LiteralPath $MockCss -Raw

$cssMatch = [regex]::Match(
  $css,
  '(?s)/\* AA_TIGHT_SNAP_RESIZE_RESPECT_EDGES_20260613 BEGIN \*/.*?/\* AA_TIGHT_SNAP_RESIZE_RESPECT_EDGES_20260613 END \*/'
)

$htmlMatch = [regex]::Match(
  $html,
  '(?s)<!-- AA_TIGHT_SNAP_RESIZE_RESPECT_EDGES_20260613 SCRIPT BEGIN -->.*?<!-- AA_TIGHT_SNAP_RESIZE_RESPECT_EDGES_20260613 SCRIPT END -->'
)

if (!$cssMatch.Success) {
  $oldCss = [regex]::Match(
    $css,
    '(?s)/\* AA_SNAP_RESIZE_RESPECT_EDGES_20260613 BEGIN \*/.*?/\* AA_SNAP_RESIZE_RESPECT_EDGES_20260613 END \*/'
  )
  if ($oldCss.Success) {
    throw "BLOCKED: tight snap CSS block is missing, but older snap CSS exists. Do not save stale rule. Re-run the tighter snap install, then this repair."
  }
  throw "BLOCKED: no tight snap CSS block found in current styles.css."
}

if (!$htmlMatch.Success) {
  $oldHtml = [regex]::Match(
    $html,
    '(?s)<!-- AA_SNAP_RESIZE_RESPECT_EDGES_20260613 SCRIPT BEGIN -->.*?<!-- AA_SNAP_RESIZE_RESPECT_EDGES_20260613 SCRIPT END -->'
  )
  if ($oldHtml.Success) {
    throw "BLOCKED: tight snap script block is missing, but older snap script exists. Do not save stale rule. Re-run the tighter snap install, then this repair."
  }
  throw "BLOCKED: no tight snap script block found in current public.html."
}

$CssBlock = $cssMatch.Value
$SnapScript = $htmlMatch.Value

$CardContent = @"
# SNAP RESIZE RESPECT EDGES RULE

Status: ACTIVE / SAVED_CODE_RULE / TIGHT_EDGE_SNAP

Card ID:

SNAP_RESIZE_RESPECT_EDGES / TIGHT_EDGE_FIT

Purpose:

Keep an image-map board responsive without manual vertical pushing.

## Rule

Use snap-after-resize for picture-map pages.

Do not live-fight the browser while the user is dragging the window. Wait briefly after resize settles, then calculate the fitted board size and snap to it.

## Fit Requirements

- Preserve the image aspect ratio.
- Respect top and bottom edges.
- Respect left and right edges.
- Keep gaps visually balanced.
- Do not crop the image.
- Do not stretch the image independently from hitboxes.
- Do not change coordinates.
- Do not change button text.
- Do not change hover behavior unless the user explicitly asks.
- Image and overlay/hitboxes must scale as one board.

## Current Tuned Values

- Image ratio: 1672 / 941
- Resize wait: 260ms
- Snap step: 4px
- Edge gap: clamp(4px, 1.2vmin, 14px)
- Desktop side allowance: up to 90vw, still clamped to available viewport width
- Mobile side allowance: available viewport width

## Saved CSS Block

````css
$CssBlock
````

## Saved JS Block

````html
$SnapScript
````

## Boundary

This rule is for image-map / index-map pages. It does not replace the coordinate tool. The coordinate tool still verifies hitbox alignment after responsive sizing.

## Plain Rule

WAIT. SNAP. RESPECT EDGES. SCALE IMAGE AND HITBOXES TOGETHER.
"@

Set-Content -LiteralPath $MockCard -Value $CardContent -Encoding UTF8
Set-Content -LiteralPath $RealCard -Value $CardContent -Encoding UTF8

$savedMockCard = Get-Content -LiteralPath $MockCard -Raw
$savedRealCard = Get-Content -LiteralPath $RealCard -Raw

if ($savedMockCard -notmatch 'WAIT\. SNAP\. RESPECT EDGES\. SCALE IMAGE AND HITBOXES TOGETHER\.') {
  throw "READBACK_FAILED: mock snap rule card missing plain rule."
}

if ($savedRealCard -notmatch 'WAIT\. SNAP\. RESPECT EDGES\. SCALE IMAGE AND HITBOXES TOGETHER\.') {
  throw "READBACK_FAILED: real snap rule card missing plain rule."
}

$PageHash = Get-FileHash -Algorithm SHA256 -LiteralPath $MockPage
$CssHash = Get-FileHash -Algorithm SHA256 -LiteralPath $MockCss
$MockCardHash = Get-FileHash -Algorithm SHA256 -LiteralPath $MockCard
$RealCardHash = Get-FileHash -Algorithm SHA256 -LiteralPath $RealCard

$Receipt = @"
# REPAIR SAVE EXISTING TIGHT SNAP RULE RECEIPT

STATUS: DONE_AFTER_REPAIR
DATE: $Stamp
SCOPE: SNAP RULE CARD + RECEIPT ONLY

ROOT_CAUSE:
USER_INTERRUPT_DURING_COMMAND_LAYER

WHAT_WENT_WRONG:
- Prior command was interrupted with Ctrl+C while PowerShell was inside the card-content here-string.
- HTML and CSS snap code had already been written before interruption.
- Snap rule cards and final receipt were not completed.

WHAT_CHANGED_NOW:
- Read current tight snap CSS block from styles.css.
- Read current tight snap script block from public.html.
- Saved those exact current blocks into the mockup snap rule card.
- Saved those exact current blocks into the real ESO tool snap rule card.
- Wrote this repair receipt.

WHAT_DID_NOT_CHANGE:
- Did not rewrite public.html.
- Did not rewrite styles.css.
- Did not change coordinates.
- Did not change image files.
- Did not change button text.
- Did not touch real ESO live page.
- Did not commit.
- Did not push.

PAGE_HASH:
$($PageHash.Hash)  $MockPage

CSS_HASH:
$($CssHash.Hash)  $MockCss

MOCK_CARD_HASH:
$($MockCardHash.Hash)  $MockCard

REAL_CARD_HASH:
$($RealCardHash.Hash)  $RealCard

BACKUP:
$BackupDir
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8
$ReceiptHash = Get-FileHash -Algorithm SHA256 -LiteralPath $ReceiptPath

Write-Ok "DONE_AFTER_REPAIR: existing tight snap code saved into rule cards."
Write-Host "PAGE: $MockPage" -ForegroundColor Cyan
Write-Host "PAGE_HASH: $($PageHash.Hash)" -ForegroundColor Cyan
Write-Host "CSS: $MockCss" -ForegroundColor Cyan
Write-Host "CSS_HASH: $($CssHash.Hash)" -ForegroundColor Cyan
Write-Host "MOCK SNAP RULE: $MockCard" -ForegroundColor Cyan
Write-Host "MOCK_CARD_HASH: $($MockCardHash.Hash)" -ForegroundColor Cyan
Write-Host "REAL SNAP RULE: $RealCard" -ForegroundColor Cyan
Write-Host "REAL_CARD_HASH: $($RealCardHash.Hash)" -ForegroundColor Cyan
Write-Warn "RECEIPT: $ReceiptPath"
Write-Warn "RECEIPT_HASH: $($ReceiptHash.Hash)"

Write-Host ""
Write-Step "=== READBACK: SNAP CSS SAVED TO CARD ==="
Write-Host $CssBlock

Write-Host ""
Write-Step "=== READBACK: SNAP SCRIPT SAVED TO CARD ==="
Write-Host $SnapScript

Write-Host ""
Write-Step "=== READBACK: MOCK SNAP RULE CARD TOP ==="
Get-Content -LiteralPath $MockCard -TotalCount 90 | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Ok "No page/css rewrite. No coords/image/button-text/live ESO changes. No commit. No push."

Write-Host ""
Write-Host "Press Enter to close this window." -ForegroundColor Yellow
[void][System.Console]::ReadLine()
