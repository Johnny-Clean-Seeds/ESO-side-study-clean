# Error Log Repair Memory Compression Rule V0.1

Status: CHAT_DROP_HELPER_CARD / ERROR_LOG_MEMORY / REPAIR_PATTERN_LOGGING / DATA_BRAKE_SUPPORT / NOT_DOCTRINE  
Date: 2026-06-16  
Scope: Error logs, failure chains, repeated code failures, broken-code/fixed-code memory, sub-error compression.

## Purpose

Error logs are not only failure history.

Error logs are repair memory.

They should preserve what broke, why it broke, what code fixed it, and whether the fix held.

They should not repeat the whole root error story every time a sub-error appears.

## Core Rule

A root error entry records the full event.

A sub-error entry inherits the parent context and records only the new delta.

Use continuation marks such as `""""` to mean:

“same prior root context; only this new delta is being added.”

## Root Error Entry

A root error entry should record:

- error ID;
- date/time when practical;
- active object;
- script/code name;
- failure class;
- exact error text or clean summary;
- broken code or broken section;
- why it broke;
- fixed code or fixed section;
- proof/result after fix;
- what the fix does not prove;
- whether this failure family should become a reusable repair pattern.

## Sub-Error Entry

A sub-error entry does not repeat the full root event.

It records only:

- parent error ID or parent context pointer;
- what new part broke;
- why the new part broke;
- new code attempted;
- new fix code;
- proof/result;
- whether the root fix remains valid.

## Continuation Mark Rule

Use `""""` when the parent context is already known.

Example root:

Sally went to the store to get Mexican jumping beans.

Example sub-entry:

`""""` then Sally thought it would be a good idea to feed them candy.

Example sub-entry:

`""""` Sally was wrong; they do not eat candy or know how.

Combined meaning:

Sally went to the store to get Mexican jumping beans. Then Sally thought it would be a good idea to feed them candy. Sally was wrong; they do not eat candy or know how.

## Code Error Example

ROOT ERROR:

PowerShell script failed under StrictMode because `$Lines` was a single string and `.Count` was not valid.

BROKEN CODE:

manual loop used `$Lines.Count`

FIXED CODE:

force the result into an array or use `Select-String`

RESULT:

strict-mode section passed after repair

DOESNOTPROVE:

does not prove the whole script is correct, only that this failure was repaired

SUB ERROR:

`""""` output table collapsed and only showed the File column.

NEW BROKEN AREA:

report display formatting

NEW FIXED CODE:

export CSV and print File / Line / Text with wider/manual formatting

RESULT:

output showed enough path detail to continue

ROOT FIX STILL VALID:

yes

## Repair Memory Use

Before writing a new full repair, check whether the old error log already contains the same failure family.

Ask:

- what broke before?
- what exact code caused it?
- what exact code fixed it?
- did the fix hold?
- did a sub-error appear after the main fix?
- is this a repeated failure family?
- can the old fix become the smallest safe patch now?

## Repeat Control

Do not repeat the whole prior error story unless:

- the parent context is missing;
- the prior log is ambiguous;
- a new agent cannot understand the continuation;
- the root error changed;
- the old fix is no longer valid.

## DoesNotProve

This card proves only the intended error-log compression and repair-memory behavior.

It does not prove any script is correct.  
It does not authorize mutation.  
It does not authorize cleanup.  
It does not authorize Git commit or push.  
It does not replace the current user command.
