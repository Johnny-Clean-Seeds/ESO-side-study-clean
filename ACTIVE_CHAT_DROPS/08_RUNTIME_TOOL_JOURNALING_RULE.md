# R16 Runtime Tool Journaling Rule

Status: CURRENT_WORKING_RULE / SUPERSEDABLE

Rule name:

R16_JOURNALED_COORD_SESSION_NO_UNLOGGED_ACTIONS_20260615

Core rule:

LOG FIRST / THEN ACT

This rule exists because a tool shell can appear dead while still working, a bridge can write files without a clear session owner, and a forced restart can destroy useful output unless the process is inventoried before shutdown.

## Required laws

1. No unlogged worker shells.
2. No force-close without a pre-close receipt.
3. No workshop action should wait until COPY COORDS to be saved.
4. No bridge write should happen without an event log.
5. Shell scrollback is not the authority. Disk logs are the authority.
6. The session manager must not blindly kill the shop and bridge together.

## Required session folder

ACTIVE_CHAT_DROPS\RUNTIME_SESSIONS\COORD_SESSION_<timestamp>\

Required files:

00_SESSION_RECEIPT.md
01_SHOP_ACTIONS.jsonl
02_BRIDGE_EVENTS.jsonl
03_PROCESS_EVENTS.jsonl
04_HEARTBEAT.log
05_LAST_KNOWN_COORDS.json
06_LAST_APPLIED_CSS.css
07_BACKUPS_CREATED.txt
08_CLOSEOUT_RECEIPT.md

## Shop actions that must be journaled

Tool loaded.
Target image loaded.
Box created.
Box selected.
Box moved.
Box resized.
Box deleted.
Box tagged or marked.
Adjust mode toggled.
Lock created.
Lock cleared.
Copy coords clicked.
Export created.
Error caught.
Journal offline fallback used.

## Bridge events that must be journaled

Bridge started.
PID lock written.
Old bridge inventoried.
Old bridge stopped.
Heartbeat.
Clipboard changed.
Clipboard ignored.
Valid coordinate CSS detected.
Mockup CSS backup made.
Mockup CSS write started.
Mockup CSS write succeeded.
Mockup CSS write failed.
Bridge close requested.
Bridge stopped.

## Power outage rule

The latest safe state is not the visible screen.

The latest safe state is the newest successfully written shop event and the newest LAST_KNOWN_COORDS file.

## Implementation boundary

This card is not executable implementation.

Next stage must inspect current workshop and bridge code before writing the journal system.
