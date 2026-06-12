# HOUSE OBSERVER RECEPTIONIST LEDGER V0.1

Date: 2026-06-11
Status: OBSERVER_RECEPTIONIST_LEDGER / ROUTING_SUPPORT / NOT_DOCTRINE / NOT_DECIDER
WorkKey: HOUSE-OBSERVER-RECEPTIONIST-LEDGER-20260611-V0-1
ActiveObject: HOUSE_OBSERVER_RECEPTIONIST_LEDGER_V0_1

## Purpose

This file is the front receptionist for incoming project material.

It observes new or changed objects, inventories them, classifies their likely role, and prepares a bounded packet for the correct decider/helper file.

It does not approve work.
It does not promote doctrine.
It does not replace receipts.
It does not replace source custody.
It does not replace the decider/helper lane.

## Core Rule

Observe first.
Inventory second.
Classify third.
Route fourth.
Only then ask the decider/helper file for a decision.

Short form:

NEW THING ARRIVES -> OBSERVER RECORDS IT -> CLASSIFIES IT -> ROUTES IT -> BUILDS DECIDER PACKET -> DECIDER HELPER CHOOSES ACTION

## Single Active Object Rule

Only one active object stays on the table during a run.

For this version, the active object is:

HOUSE_OBSERVER_RECEPTIONIST_LEDGER_V0_1

Side quests, broad cleanup, publishing, committing, pushing, renaming, merging, deleting, retiring rough state, and doctrine promotion remain blocked unless explicitly approved by the correct decider/helper lane.

## What This File Watches

- New Chat Drop helper files
- Updated Chat Drop helper files
- New local reports
- New receipts
- New scripts
- New pasted assistant/mule output
- New rule candidates
- New custody reports
- New rough_state objects
- New proof pointers
- New blocker reports
- Supersession conflicts between old and current helper files
- Parser, shell, readback, or static preflight boundary failures

## Existing Control Surfaces It Must Respect

- Two-location Chat Drop rule
- Mule Standing Issue Ledger
- Current Custody Anchor Addendum
- Chat Load Manifest
- URL / LEDGER / MAP / KEY source compressor
- Scissor / Sew / Smell / Bone / Nerve candidate grammar
- Any current project-specific source/custody gate

## Allowed Observer Words

- OBSERVED
- INVENTORIED
- PLACEMENT_GUESS
- DECIDER_REVIEW_REQUIRED
- BLOCKED_UNTIL_APPROVED
- FREEZE
- REPAIR_REQUIRED
- STATIC_PREFLIGHT_REQUIRED
- READBACK_REQUIRED
- DECIDER_PACKET_READY

## Blocked Observer Words

This file must not say the following unless it is quoting a scoped result from a decider/proof file:

- READY
- SAFE
- DONE
- APPROVED
- AUTHORITATIVE
- DOCTRINE
- PUBLIC_SAFE
- EXECUTION_SAFE

## Observer Intake Row Format

| Field | Value |
| --- | --- |
| ObservedObject |  |
| ObservedLocation |  |
| ObservedAt |  |
| ObservedBy |  |
| ObjectType |  |
| Freshness | NEW / CURRENT / SUPERSEDED / STALE / UNKNOWN |
| AuthorityLevel | ACTIVE_HELPER / SUPPORT_ONLY / PROOF_ONLY / CANDIDATE / RAW_HELD / BLOCKED |
| PlacementGuess |  |
| DeciderNeeded | YES / NO |
| SuggestedDecider |  |
| BlockedActions |  |
| NextSingleAction |  |
| DoesNotProve |  |

## Placement Classes

ACTIVE_HELPER:
Current helper/control file that can guide behavior, within scope.

SUPPORT_ONLY:
Useful orientation or method support, but not authority.

PROOF_ONLY:
Receipt, hash report, closeout, or historical proof. Preserved, not loaded as active instruction.

CANDIDATE:
Possible rule, method, tool grammar, or structural idea. Needs later adoption, adaptation, or block decision.

RAW_HELD:
Unreviewed source, rough material, local-only material, or sensitive/large evidence.

SUPERSEDED:
Old instruction replaced by newer rule. Preserve as history, do not load as active.

BLOCKED:
Known object or action that cannot proceed without explicit approval.

DECIDER_REVIEW_REQUIRED:
Observer cannot place it safely. Needs the right helper/decider lane.

## Routing Rules

If the object changes Chat Drop behavior, route to:
Mule Standing Issue Ledger + Two-Location Chat Drop Rule.

If the object changes current project anchors, route to:
Current Custody Anchor Addendum.

If the object changes load order or chat burden, route to:
Chat Load Manifest + URL / LEDGER / MAP / KEY source compressor.

If the object is proof/history, route to:
Proof/custody lane, not active helper carry.

If the object is raw, rough, sensitive, or not public-safe, route to:
_rough_state / local custody review.

If the object is a possible living rule, route to:
Rule candidate review, not doctrine.

If the object is a script or executable tool, route to:
Code gate / static preflight / no-execution proof first.

If the object hits a parser/readback/static boundary, route to:
Freeze-and-repair lane first, then decider/helper review.

## Parser Error Freeze-And-Repair Lane

A parser error changes the job.

The job stops being "finish the object" and becomes:

FREEZE -> CLASSIFY -> ROOT CAUSE -> NEW VERSION -> STATIC PREFLIGHT -> READBACK -> OBSERVER ROW -> DECIDER PACKET

When a parser error appears:

1. Stop the active move.
2. Do not add more features.
3. Do not rename things.
4. Do not publish.
5. Do not commit.
6. Do not call it done.
7. Freeze the exact error.
8. Mark the single active object.
9. Classify the parser error family.
10. Inspect structure before repair.
11. Make a repair copy instead of a silent overwrite.
12. Run static preflight before publishing or handoff.
13. Read back the repaired file.
14. Update the observer with the incident.
15. Hand to decider/helper.

## Parser Error Families

Use one of these families when classifying a parser/readback/static boundary:

- MARKDOWN_STRUCTURE_ERROR
- POWERSHELL_STRING_ERROR
- JSON_ESCAPE_ERROR
- TABLE_PIPE_ERROR
- YAML_FRONTMATTER_ERROR
- ENCODING_ERROR
- BAD_CODEBLOCK_FENCE
- UNBALANCED_QUOTE
- EMPTY_COLLECTION_PARSE_ERROR
- PATH_ESCAPE_ERROR
- UNKNOWN_PARSER_ERROR

## Freeze Evidence Required

Capture these fields before any repair:

| Field | Value |
| --- | --- |
| ObservedObject |  |
| ErrorType |  |
| BrokenVersion |  |
| RepairVersion |  |
| CommandUsed |  |
| ErrorText |  |
| FilePathParsed |  |
| Timestamp |  |
| ShellPath |  |
| WorkingDirectory |  |
| Cause |  |
| BlockedActions |  |
| NextSingleAction |  |
| DoesNotProve |  |

## Dirty Shell / Clean Shell Boundary

Dirty shell:
The shell where the error happened. It contains the failed command, bad parse state, maybe half-written output, and confusion residue.

Clean shell:
The verification lane. It does not continue improvising. It runs narrow checks only.

Clean shell questions:

- Can the file be read?
- Are code fences closed?
- Are tables valid?
- Does the hash match?
- Does the repaired version contain all intended material?
- Did the repair avoid mutating anything else?

The clean shell is not "try again harder." It is "prove what exists."

## Repair Version Rule

Do not repair inside the dirty assumption.

If the broken object is:

CHAT_DROP_COPY__HOUSE_OBSERVER_RECEPTIONIST_LEDGER_V0_1_20260611.md

then the repair object should be:

CHAT_DROP_COPY__HOUSE_OBSERVER_RECEPTIONIST_LEDGER_V0_2_20260611.md

The broken object remains preserved as evidence unless the user authorizes a move into old/repair history.

## Static Markdown Preflight

Before handoff, check:

- headings are present and ordered enough to read
- code fences are closed
- Markdown tables have valid pipe counts
- no accidental PowerShell variable expansion is required for the file to survive
- no weird invisible characters are present
- no unterminated quotes are present
- blank lines are handled as valid
- no fake YAML block exists unless intended
- file can be read back by path
- hash can be generated for the final version

## Parser Freeze Return Format

When this observer file hits a parser boundary, return this structure:

FREEZE: parser error while building observer receptionist ledger.

Active object:
CHAT_DROP_COPY__HOUSE_OBSERVER_RECEPTIONIST_LEDGER_V0_1_20260611.md

Error family:
[exact family]

Dirty action stopped:
No publish, no commit, no cleanup, no doctrine promotion.

Evidence captured:
- command
- error text
- file path
- timestamp
- shell path
- broken version path

Repair action:
Create V0_2 repair copy.
Run static Markdown/parser preflight.
Read back repaired file.
Only then update observer row and hand to decider/helper.

DoesNotProve:
This freeze does not prove the observer is wrong, complete, approved, or safe. It proves only that the attempted version hit a parser boundary and needs controlled repair.

## Decider Packet Format

When this observer hands work to a decider/helper, it must provide:

1. Object name.
2. Exact observed location.
3. What changed or appeared.
4. Why it matters.
5. Current placement guess.
6. What authority it does or does not have.
7. Blocked actions.
8. Suggested next single action.
9. DoesNotProve.

## Hard Limits

This file may not authorize:

- Git export
- commit
- push
- cleanup
- rename
- delete
- merge
- rough_state retirement
- doctrine promotion
- source replay
- fixture execution
- script execution
- broad scan
- watcher
- automation
- universal mapper
- self-approval after repair

## Current Event Ledger

| ObservedAt | ObservedObject | EventType | ErrorType | BrokenVersion | RepairVersion | Cause | BlockedActions | NextSingleAction | DoesNotProve |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-06-11 23:29:37 -04:00 | HOUSE_OBSERVER_RECEPTIONIST_LEDGER_V0_1 | INITIAL_LEDGER_CREATION | NONE_OBSERVED | NONE | NONE | User requested observer/receptionist ledger with parser freeze-and-repair boundary | publish, commit, push, cleanup, doctrine promotion, self-approval | Static preflight and readback of this V0_1 file | This row does not prove the observer is approved, safe, doctrine, complete, committed, pushed, or ready for execution |

## Update Rule

This observer may be updated when new material is introduced.

Structural changes to this observer should create a new versioned file.

Routine observed rows may be appended under the current version if the user authorizes this file as a living append ledger.

If parser/readback/static preflight fails, do not keep appending to the broken version. Freeze, classify, repair into a new version, preflight, read back, then create the observer row.

## Current Open Question

Should this observer be installed as:

A. one living append ledger, or
B. one current observer card plus a separate append-only event ledger?

Recommended: B if the system starts getting heavy. A if fewer files matter more than event separation.

## DoesNotProve

This observer proves only that an object was noticed, inventoried, and routed for decision.

It does not prove the object is correct, current, approved, safe, public-safe, committed, pushed, doctrine, cleaned up, or ready for execution.
