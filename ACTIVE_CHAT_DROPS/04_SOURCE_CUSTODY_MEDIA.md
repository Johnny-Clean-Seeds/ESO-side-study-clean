# ESO SOURCE CUSTODY AND MEDIA

Status: `ACTIVE_CUSTODY_SURFACE / NO_LOSS_DROP`

This file explains what is in the compact drop, where the old material went, and how media/source custody should be handled.

## Active Drop File Count

Current active chat drop:

| File | Use |
| --- | --- |
| `ACTIVE_CHAT_DROPS/00_AGENT_HANDOFF_LOAD_ORDER.md` | Load order, branch status, next actions, guardrails. |
| `ACTIVE_CHAT_DROPS/01_METHOD_WORKING_ORDER.md` | Shared method, rooms, rule cards, proof labels. |
| `ACTIVE_CHAT_DROPS/02_HALL_COOP_LEY_ACTIVE.md` | Hall/Cooper/Mercy Hunter active branch state. |
| `ACTIVE_CHAT_DROPS/03_GROVE_ACTIVE.md` | Bohemian Club/Grove active branch state. |
| `ACTIVE_CHAT_DROPS/GROVE_RAW.txt` | Original Grove raw workstream; required custody file. |
| `ACTIVE_CHAT_DROPS/04_SOURCE_CUSTODY_MEDIA.md` | Custody, archive map, media rules. |
| `ACTIVE_CHAT_DROPS/05_DOCUMENTARY_SOURCE_SPINE.md` | Documentary/news-style source spine, updated as new material arrives. |
| `ACTIVE_CHAT_DROPS/06_KEEP_PHOTO_BOARD.md` | Photo/citation target board with clickable source routes. |
| `ACTIVE_CHAT_DROPS/HANDOFFS/HANDOFF_1_LOCAL_READER_REBUILD_SCOPE.txt` | Current reader rebuild handoff captured from attachment. |
| `ACTIVE_CHAT_DROPS/HELPER_FILES/ESO_HALL_COOP_LEY_WORKING_METHOD_FULL_PACKET_20260611.md` | Full working method helper packet moved out of root. |
| `PICTURES/NORTH AMERICAN BRANCH/*` and `PICTURES/SOUTH_AMERICAN_BRANCH/*` | Active visual shelf split by branch. Use only source-routed targets as evidence. |

Total active drop files:

`variable; do not bulk-drop the full PICTURES shelf into tight future chats`

If a hard 20-file ceiling returns, drop the active markdown files, `GROVE_RAW.txt`, and only the specific image targets needed for the active run.

## Archive Location

The old full workspace was packed into:

`ESO_SOURCE_ARCHIVE_20260610.zip`

Use it only when auditing exact old wording, recovering raw source packets, checking hashes, or inspecting old media folders. Do not include it in a normal agent chat drop unless the next agent explicitly needs the full old packet.

Archive contents include the previous `HALL_COOP_LEY`, previous `GROVE`, and the old root `00_BRANCH_TREE.md`.

Archive SHA256:

`504AF26571EEF78881BF7FD212B7E97ECA704E8C1AB62BF80A8EEC85D99A6227`

## Raw Original Custody

Grove raw-original custody:

| Raw file | SHA256 |
| --- | --- |
| `GROVE/ARCHIVE/ORIGINAL_PACKET/GROVE_RAW.txt` | `8E6F1FA7ACB6B859742C73DF688503F426E62FA35483EEF22265414F0B076CA3` |
| `GROVE/ARCHIVE/ORIGINAL_PACKET/BOHEMIAN_RAW_CAPTURE_PASTED_TEXT_20260610.txt` | `8E6F1FA7ACB6B859742C73DF688503F426E62FA35483EEF22265414F0B076CA3` |
| `GROVE_RAW.txt` | `8E6F1FA7ACB6B859742C73DF688503F426E62FA35483EEF22265414F0B076CA3` |

The matching hashes show the root raw drop file is the same raw text as the preserved Grove original captures.

Hall full-source preservation custody:

| File | SHA256 |
| --- | --- |
| `HALL_COOP_LEY/ARCHIVE/DROP_FILES/09_UNIFIED_SOURCE_PRESERVATION_FULL_TEXT.md` | `FFAE08104A8250CAAAC577F123F58BD36D1990802FEB5C16BE484000C726BB44` |

This Hall preservation stream is the recovery vault for exact old wording. It is not the active first-read surface.

New root update custody:

| Raw intake file | SHA256 | Storage rule |
| --- | --- | --- |
| `ACTIVE_CHAT_DROPS/RAW_INCOMING/update.txt` | `75DE601FF250F65499C355A9D70FC074439AF34C57A41CCED77EDAC8BD1D5BF1` | Raw original preserved. Do not overwrite. |
| `ACTIVE_CHAT_DROPS/RAW_INCOMING/update1.txt` | `1C6F5B093631E69CF7AA43F3DE8EB398A54E62E5BA5984DEB7B2F21A57E7295A` | Raw original preserved. Do not overwrite. |
| `ACTIVE_CHAT_DROPS/RAW_INCOMING/Update_20260611_041416_PART5.txt` | `C7632C6AD11606AF3D6B1B3C34F80D5B41F2048C2C37867E4E475810BACC87B3` | Raw original preserved. Do not overwrite. |
| `ACTIVE_CHAT_DROPS/RAW_INCOMING/UPDATE_WHEN_READY_20260611_042503_PART5_PART6.txt` | `00C24D4D6CA30967F6B96583CE41FEE05D6D2A7C9AF5F31725C419951ABAD100` | Raw original preserved. Do not overwrite. |

Part 6 + Part 7 bounded-run custody:

| Material | SHA256 / status | Custody rule |
| --- | --- | --- |
| `HALL_COOP_LEY/MEDIA/03_DROP_TARGET_FOLDERS/AUDIO_OR_TRANSCRIPTS/PASSAGE_REWIND_AMERICAS_ASSIGNMENT/06__Passage_Rewind__Americas_Assignment_Part_6_of_13__cA0b3f2Ne28/INFO.txt` | `VIDEO CUSTODY / BLOCKED_AUTO_CAPTIONS_ONLY` | Part 6 video route only; no auto-caption transcript truth. |
| `HALL_COOP_LEY/MEDIA/03_DROP_TARGET_FOLDERS/AUDIO_OR_TRANSCRIPTS/PASSAGE_REWIND_AMERICAS_ASSIGNMENT/07__Passage_Rewind__Americas_Assignment_Part_7_of_13__II2dKoOFeb4/INFO.txt` | `VIDEO CUSTODY / BLOCKED_AUTO_CAPTIONS_ONLY` | Part 7 video route only; no auto-caption transcript truth. |
| `ESO_INDEX_SITE_MOCKUP_20260611_152646/outside  agent/INDEX_IMAGES/PART_6FINAL.png` | `BD5D0A7EAE23D055FAE817D279AE03F1AFCA952F7C32AF7A7838F141572C6414` | Part 6 story image target; not source proof. |
| `ESO_INDEX_SITE_MOCKUP_20260611_152646/outside  agent/INDEX_IMAGES/PART_7.png` | `CE7B5C23E577FC689F4EAADC3C8F39A336B622A0E5C58AFC7137DBFE7A2BBA22` | Part 7 staged support; Part 6-adjacent, not proof. |
| `ESO_INDEX_SITE_MOCKUP_20260611_152646/outside  agent/INDEX_IMAGES/PART_7V.png` | `B038E85C99305D7C43A086316CCB25ABE7375EB7BDE81FBAB8EF68CCA7F656A8` | Part 7 staged support; broad claims held. |

Part 6 source-route additions now support the green-cross banner description, LOC object-custody route, and Fendler title target. They do not prove Templar identity, a decoded cipher, Columbus as a secret-society agent, or Hall's hidden-plan claim-chain.

Part 7 remains staged until Part 6 is cleanly closed. Franklin/Nine Sisters and civic-knowledge routes may be used as source candidates, but bloodline, power-behind-nations, or global hidden-current claims are held unless direct source control appears.

Root cleanup rule:

`Root = local reader surface only. Loose active docs, raw updates, receipts, and loose media go under ACTIVE_CHAT_DROPS. No raw original file is deleted.`

Read-along package:

`DOWNLOADS/ESO_READ_ALONG_PACKAGE.zip`

Package SHA256 is recorded after build in:

`DOWNLOADS/ESO_READ_ALONG_PACKAGE.sha256.txt`

The package is now release-safe for the public reader. It contains the main `index.html`, `assets`, and the hidden Parts 1-5 draft shelf under `reader/chapters`. It does not include active chat drops, raw updates, Hall active boards, or later unreleased research material.

## What Was Preserved In The Compact Drop

Preserved from Hall:

`active object`

`voice split`

`Hall/Cooper/Mercy Hunter separation`

`BAE mound report lane`

`Mississippian culture-province correction`

`orenda / manito / totem mechanism`

`SECC / Southern Cult bridge`

`object-symbol network`

`Spiro object cosmogram`

`Cahokia path grammar`

`Moundville site-center`

`upper/lower split`

`Great Seal official/esoteric firewall`

`Ephesians theology firewall`

`center-stack model`

`red-marker source gap`

`blue-map source gap`

`video-sequence gap`

`lineage block`

`33rd parallel quarantine`

`parked follow-up: RETRACE-RUN-002 / ROUND 2`

`source-spine update: PART 5 STRUCTURE LOCKED / PART 6 COLUMBUS GATE OPEN`

`transcript-spine update: NON-AUTO TRANSCRIPTION ROUTE STILL PENDING`

Preserved from Grove:

`branch identity`

`object lock`

`cover / marker / riddle split`

`Branch A active / not exhausted`

`Branch B draft / queued`

`city address drift problem`

`marker object card`

`date pressure cards`

`source bank route starts`

`next run: BATCH A1.2 - EARLY ADDRESS LOCK`

## Media Rules

A media file is not proof until it has:

`source route`

`capture date or source date`

`object label`

`timestamp/order when video-related`

`claim boundary`

The copied Hall and branch images are active reference objects only. They include the map crops that must be source-locked later. They do not prove the red-marker source, the blue-line origin, Hall authorship, editor intent, or any lineage claim.

## Transcript Custody Rules

Mule harvests transcript custody. Mule does not judge alignment during the raw harvest pass.

Every video transcript surface must preserve:

`video title`

`video ID`

`playlist or source position`

`transcript text`

`timestamps if available`

`caption source`

`extraction method/tool`

`errors or blocked videos`

`hash or receipt if files are saved`

Current Passage Rewind output root:

`HALL_COOP_LEY/MEDIA/03_DROP_TARGET_FOLDERS/AUDIO_OR_TRANSCRIPTS/PASSAGE_REWIND_AMERICAS_ASSIGNMENT`

Primary custody surfaces:

`INDEX.md`

`INDEX.csv`

`ERRORS.tsv`

`HARVEST_RECEIPT.md`

`MANIFEST_SHA256.txt`

2026-06-11 harvest result:

`RAW_CUSTODY_INDEX / HOUSE_TRANSCRIPT_PULLER_PATTERN / NO_AUTO_CAPTIONS`

The 13 Mercy Hunter `Passage Rewind: America's Assignment` parts, the Bill Cooper Today repost, and related extras were indexed. No manual captions were exposed. YouTube automatic captions were not harvested because the active user boundary says not to use them.

Do not paste YouTube auto transcript text into the active documents unless the user explicitly reverses that rule. Auto-only videos stay `BLOCKED_AUTO_CAPTIONS_ONLY` until a non-auto transcript source, local speech-to-text pass, or manual transcript is available.

## Documentary Reader Rules

The local front page is the evolving reader document. It should read like a documentary/news report, not a raw wiki dump.

Use clickable citations for every specific source lane. Use clickable photo/source routes when a photo target is called out. Do not hotlink weak image caches as proof when an institutional source page or catalog route is available.

Photo targets are comparison targets until exact Mercy frame, source route, timestamp/order, and claim boundary are logged.

## When To Open The Archive

Open the archive only for one of these reasons:

`exact old wording needed`

`source route missing from compact files`

`old media inventory needed`

`hash/custody audit needed`

`agent must compare active compact state against original packet`

If opening the archive, keep archive material in audit mode until promoted through the proof ladder.
