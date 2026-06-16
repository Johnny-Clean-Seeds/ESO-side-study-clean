# Code Failure Small Patch Protocol V0.3

Status: CHAT_DROP_HELPER_CARD / CODE_FAILURE_REPAIR / SMALL_PATCH_PROTOCOL / DATA_BRAKE_SUPPORT / NOT_DOCTRINE  
Date: 2026-06-16  
Scope: Code blocks, PowerShell scripts, helper scripts, dry-run scripts, parser failures, patch replies.

## Purpose

Reduce data churn, prevent repeated full-code dumps, and make code failures easier to repair without losing the lane.

## Default

When code breaks, return a structured failure packet and the smallest safe repair.

Do not resend the full code by default.

## Failure Packet

Every code failure response should start with a short packet.

STATUS:

CODE BROKE / SCRIPT BLOCKED / PATCH NEEDED / RETRYABLE_FAILURE / DEAD_PATCH

FAILURE CLASS:

parser  
strict-mode  
runtime exception  
missing variable  
bad path  
failed proof  
staged-set violation  
git/remote failure  
formatting/output collapse  
unknown

BROKEN AREA:

line number, section, function, loop, guard, command, or report block

CAUSE:

plain explanation in one or two sentences

RETRY SAFETY:

retry same block / do not retry same block / retry only after patch / unknown

PATCH SIZE:

Level 1 — one-line fix  
Level 2 — replacement block  
Level 3 — find/replace patch  
Level 4 — unified diff  
Level 5 — full script resend

## Default Max

Use Level 1 or Level 2 when possible.

Do not jump to Level 5 unless it is necessary.

## Patch Size Levels

Level 1 — One-line fix

Use when one line is wrong.

Level 2 — Replacement block

Use when a small section is wrong.

Level 3 — Find/replace patch

Use when the user needs a clear “find this / replace with this” operation.

Level 4 — Unified diff

Use when exact file patching is safer than manual replacement.

Level 5 — Full script resend

Use only when partial patching is unsafe.

## Full Resend Rule

Full script resend is allowed only when:

- parser structure is broken across the whole script;
- multiple sections are contaminated;
- state is unknown;
- partial replacement would be dangerous;
- the user asks for the full script.

Full resend is the exception, not the default.

## Proof Line

Every patch response must say why the patch is enough.

Example:

“This is enough because only the Select-String/read loop failed under StrictMode.”

## Do Not Rerun Line

Every patch response must say whether the old block should not be rerun.

Example:

“Do not rerun the old full block. Replace only the loop section.”

## Stop-After-Two Rule

If two patch attempts fail on the same issue, stop patching.

Request exact error output or run a narrow diagnostic.

Do not keep guessing.

## Dead Patch Rule

If a code block repeatedly fails, quarantine it as DEAD_PATCH.

Do not keep repairing from the same broken body.

Create a fresh narrow diagnostic from the error and target section.

## Good Response Shape

SCRIPT BLOCKED.

Failure class:  
Broken area:  
Cause:  
Retry safety:  
Patch size:  
Proof line:  

Paste only this replacement:

[small fix]

Do not rerun the old full block.

## No-Noise Rule

No roleplay.  
No blame.  
No clever phrases.  
No long apology.  
No repeated plan.  
No rank or deference language.  
No “you did / I did” unless needed for exact command history.

## DoesNotProve

This card proves only the intended small-patch behavior after code failure.

It does not prove any script is correct.  
It does not authorize file mutation.  
It does not authorize cleanup.  
It does not authorize Git commit or push.  
It does not replace the current user command.
