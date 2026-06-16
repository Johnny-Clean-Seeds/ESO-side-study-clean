# Code Failure Repair Memory Mini Pack Anchor V0.1

Status: CHAT_DROP_MINI_PACK_ANCHOR / CODE_FAILURE_REPAIR_MEMORY / DATA_CHURN_REDUCTION / NOT_DOCTRINE  
Date: 2026-06-16  
Scope: Code failure replies, small patch repair, error log repair memory, repeated code/script failures.

## Purpose

This mini-pack prevents code/script failures from turning into repeated full-code dumps.

When code breaks, the assistant/helper should diagnose the failure, send the smallest safe repair, and preserve the break/fix pattern in the error log so future runs can learn from it.

## Mini-Pack Files

This mini-pack has one anchor and two focused child cards.

1. `CHAT_DROP_COPY__CODE_FAILURE_REPAIR_MEMORY_MINI_PACK_ANCHOR_V0_1_20260616.md`

This file. It explains the whole system and points to the child cards.

2. `CHAT_DROP_COPY__CODE_FAILURE_SMALL_PATCH_PROTOCOL_V0_3_20260616.md`

Controls what to say and send back when code breaks.

3. `CHAT_DROP_COPY__ERROR_LOG_REPAIR_MEMORY_COMPRESSION_RULE_V0_1_20260616.md`

Controls how to store broken code, fixed code, sub-errors, and continuation chains.

## Core System

Code failure handling has two linked jobs.

First job:
Repair the live failure without wasting data.

Second job:
Store the repair memory so the same failure is not rediscovered later.

## Use This Mini-Pack When

Use this mini-pack when:

- PowerShell code fails;
- parser errors appear;
- a script enters `>>`;
- strict-mode breaks a section;
- a variable/path/staged-set/proof check fails;
- a prior code fix causes a sub-error;
- a helper starts resending whole scripts after small failures;
- an old error log may already contain the repair pattern;
- repeated failures suggest a failure family.

## Do Not Use This Mini-Pack For

Do not use this mini-pack to authorize:

- file mutation;
- cleanup;
- Git commit;
- Git push;
- route rewrites;
- broad helper edits;
- doctrine promotion;
- automation;
- watcher behavior.

It controls failure response and error-log memory only.

## Load Rule

Load the anchor first.

Load the Small Patch Protocol when the immediate question is:

“What should be sent back after code broke?”

Load the Error Log Repair Memory card when the immediate question is:

“How should this failure and fix be recorded so future agents learn?”

If both are needed, load both child cards.

## One-Line Rule

When code breaks:

Diagnose first, patch the smallest safe unit, then record both the broken code and the fixed code.

## DoesNotProve

This anchor proves only the intended mini-pack structure.

It does not prove any script is correct.  
It does not authorize mutation.  
It does not authorize cleanup.  
It does not authorize Git commit or push.  
It does not replace the current user command.
