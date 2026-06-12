# HELPER RUN SEQUENCE LABEL KEY

Date: 20260606
Status: LABEL KEY / HELPER RUN SEQUENCES / NOT DOCTRINE

## Labels

RUN_SEQUENCE:
An ordered multi-step path with trigger, commands/files, errors, fixes, receipts, state transitions, final verdict, and return-to-main point.

ERROR_HARVEST_RUN_SEQUENCE:
A RUN_SEQUENCE caused by a live error during the main quest. It pauses the main quest, harvests the error/fix/helper pattern, writes receipts, then returns.

TOOL_PAIR:
Exactly two tools intentionally designed to operate together as a repeatable pair.

RUN_CHAIN:
A looser human-facing phrase for a RUN_SEQUENCE. Use RUN_SEQUENCE in filenames for consistency.

## Rule

Collect them as they fall.
Do not chase helper work without a live trigger, proof need, or return path.
If an error appears, save the sequence.
If no error appears, return to the main quest.

## DoesNotProve

This label key does not approve live install.
This label key does not promote doctrine.
