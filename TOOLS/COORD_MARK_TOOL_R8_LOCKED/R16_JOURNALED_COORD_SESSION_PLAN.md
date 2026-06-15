# R16 Journaled Coordinate Session Plan

Status: DESIGN_PLAN / NOT_EXECUTABLE / SUPERSEDABLE

Working name:

R16_JOURNALED_COORD_SESSION_NO_UNLOGGED_ACTIONS_20260615

## Goal

Make the coordinate workshop and clipboard bridge recoverable, accountable, and power-loss resistant.

The bridge should not be the first proof that work happened. The workshop must journal actions as they happen.

## Planned parts

1. Shop action journal.
2. Bridge event journal.
3. Process event journal.
4. Heartbeat file.
5. Last known coordinate snapshot.
6. Last applied CSS snapshot.
7. Controlled closeout receipt.
8. Session manager.

## Future launch rule

OPEN_ESO_WORKSHOP.cmd should eventually call:

TOOLS\Start-ESOCoordSession.ps1

The session manager should:

1. Create a session folder.
2. Inventory old bridge workers.
3. Write pre-close process facts.
4. Stop old bridge workers only after receipt.
5. Start the journal listener.
6. Start the managed bridge.
7. Launch the fresh workshop.
8. Print the session id, active PID, temp shop path, mockup CSS target, and log paths.

## Non-goals

Do not fix this by only making the blue bridge window louder.
Do not rely on shell color.
Do not rely on terminal scrollback.
Do not kill shop tabs as proof of freshness.
Do not write to real reader pages.
Do not promote mockup CSS to real site without user approval.

## Acceptance test

A real implementation must prove:

One active bridge PID.
PID lock exists.
Session folder exists.
Shop actions log before COPY COORDS.
Bridge events log after COPY COORDS.
Last known coords update after move or resize.
Old worker shutdown is recorded before termination.
Power-loss recovery can identify latest known coordinates.
