# ESO Helper Load Pointer - 2026-06-12

Status: `HELPER_IMPORT_GOOD / OBSERVER_LEDGER_FOUND / HASH_MATCH`

This file is the ESO load pointer for the imported helper shelf. It is a pointer only. It does not scatter helper files into the repo and does not grant automatic command authority.

For the current outside-agent boot map, load:

`ACTIVE_CHAT_DROPS/07_OUTSIDE_AGENT_PROJECT_MAP_AND_TOOL_ACCESS.md`

Use that map to decide which helper, ledger, branch board, or receipt to open next. Do not bulk-load the helper shelf by default.

## Shelf To Load For Reference

For ESO helper and observer behavior, use this imported shelf as reference material:

`ACTIVE_CHAT_DROPS/HELPER_FILES/HOUSE_HELPER_IMPORT_20260612/`

Primary entry file:

`ACTIVE_CHAT_DROPS/HELPER_FILES/HOUSE_HELPER_IMPORT_20260612/00_READ_FIRST.md`

## Current Observer Ledger

Current approved observer ledger:

`ACTIVE_CHAT_DROPS/HELPER_FILES/HOUSE_HELPER_IMPORT_20260612/01_OBSERVER_AND_FRONT_DOOR_LEDGERS/CHAT_DROP_COPY__HOUSE_OBSERVER_RECEPTIONIST_LEDGER_V0_2_20260611.md`

Expected SHA256:

`17850BE80FB34A56F21DD685B4D07CA00533F26425F36CC63FB710E5559BD1B2`

Verification status:

- Import decision: `GOOD`
- Observer ledger: `FOUND / HASH_MATCH`
- Earlier failure: `PATH_ASSUMPTION_ERROR`
- Manifest class: `observer-ledger`
- Manifest role: `current-observer-ledger`

## Review-Before-Run Boundary

Imported script-like helper files are present and contained under these folders:

`ACTIVE_CHAT_DROPS/HELPER_FILES/HOUSE_HELPER_IMPORT_20260612/05_REVIEW_BEFORE_RUN_HELPER_TOOLS/`

`ACTIVE_CHAT_DROPS/HELPER_FILES/HOUSE_HELPER_IMPORT_20260612/06_REVIEW_BEFORE_RUN_CONTEXT_ORGANIZE/`

These files are review-before-run only. Do not execute, adapt, or promote any imported script unless it is deliberately selected, inspected, and authorized for ESO.

## Authority Limits

This pointer authorizes reference loading only. It does not authorize:

- Running imported scripts or helper tools.
- Cleaning, moving, deleting, or reorganizing repo files.
- Enforcing old house or `Desktop/123` routing rules inside ESO.
- Copying more helper files into public site paths.
- Committing, pushing, publishing, or releasing the helper shelf.
- Treating imported helper/control files as active tools.

Any commit or push decision must keep public site files separate from internal helper/control material.

## Public Boundary Note

Likely public-safe site work should be reviewed separately from internal helper/control files. Hold the helper shelf, quarantine material, raw incoming asset drops, receipts, and this pointer local unless explicitly approved for publication.

## Active Git / PowerShell Operator Rule

Use `git --no-pager` by default for Git readout commands in PowerShell. This prevents the `:` pager screen from making the user think the terminal is loading or stuck.

Canonical rule file:
`docs/GIT_NO_PAGER_POWERSHELL_RULE.md`

