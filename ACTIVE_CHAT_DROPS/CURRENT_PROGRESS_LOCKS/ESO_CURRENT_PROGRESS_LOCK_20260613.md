# ESO CURRENT PROGRESS LOCK — 2026-06-13

Status: `LOCKED_CURRENT_PROGRESS / FAILURE_CHAIN_FROZEN / SNAP_FIT_PRESERVED`

Active local repo:

`C:\Users\13527\Desktop\ESO\ESO`

Active mockup:

`C:\Users\13527\Desktop\ESO\ESO\ESO_INDEX_SITE_MOCKUP_20260611_152646`

Active page:

`C:\Users\13527\Desktop\ESO\ESO\ESO_INDEX_SITE_MOCKUP_20260611_152646\reader\index\public.html`

Active CSS:

`C:\Users\13527\Desktop\ESO\ESO\ESO_INDEX_SITE_MOCKUP_20260611_152646\assets\styles.css`

Active front image original:

`C:\Users\13527\Desktop\ESO\ESO\ESO_INDEX_SITE_MOCKUP_20260611_152646\assets\images\page-kit\front\aa-front-original.png`

## Locked Progress

### 1. Responsive snap-fit work succeeded

The true-contain snap-fit rule was saved and read back successfully.

Verified saved rule cards:

`C:\Users\13527\Desktop\ESO\ESO\ESO_INDEX_SITE_MOCKUP_20260611_152646\_WORKSHOP_TOOLS\SNAP_RESIZE_RESPECT_EDGES_RULE_20260613.md`

`C:\Users\13527\Desktop\ESO\ESO\TOOLS\COORD_MARK_TOOL_R8_UNIVERSAL_CARD\SNAP_RESIZE_RESPECT_EDGES_RULE_20260613.md`

Matching card hash:

`70BC2BAA7DB6E9B5C9495ED304527F58FB20260FDB72F214D8892BAAB876F09A`

Receipt:

`C:\Users\13527\Desktop\ESO\ESO\ACTIVE_CHAT_DROPS\SITE_BACKUPS\REPAIR_TRUE_CONTAIN_SNAP_RULE_NO_HERESTRING_20260613_071256\REPAIR_TRUE_CONTAIN_SNAP_RULE_NO_HERESTRING_RECEIPT.md`

Receipt hash:

`2D042601A33D717B1260408C234C5B0A5C2028DF69220C9582F3D4A0583E68B8`

Snap rule plain form:

`WAIT. SNAP. TRUE-CONTAIN FIT. RESPECT EDGES. SCALE IMAGE AND HITBOXES TOGETHER.`

### 2. Current visual target is frozen

The active visual defect is not CSS/HTML layout.

The page shows two visible entry actions because the PNG itself contains:

`ENTER THE INDEX`

and the lower card contains:

`START HERE / BEGIN THE JOURNEY`

The transparent hotspot is not the visible top button. The top visible button is baked into the image asset.

Correct target:

`Remove the baked top ENTER THE INDEX button from the original PNG while preserving the original design.`

Keep:

`START HERE`

Keep:

`true-contain snap-fit`

Do not disturb:

`card hitboxes`

`coords`

`hover behavior`

`button glow`

`original image source unless creating a clean edited copy`

### 3. Bad repair chain is frozen

The following repair types are blocked for this target:

- HTML text overlay over the image.
- CSS fake text replacement.
- Creating another visible headline in the same gap.
- Cheap dark rectangle patch.
- Clone patch from a text area.
- Generated full-page replacement image.
- Any image generation unless the user explicitly asks for a generated replacement.
- Any action that replaces the artifact instead of repairing the actual original.

### 4. Required next order

Before any further repair, run a restore/readback pass.

Required order:

1. Verify current `public.html` image reference.
2. Verify current bad overlay blocks are absent or remove them.
3. Verify true-contain snap CSS remains present.
4. Verify true-contain snap script remains present.
5. Verify original PNG is still available.
6. Only then create a clean edited copy of the original PNG.
7. The edited PNG must remove only the baked `ENTER THE INDEX` button.
8. Update page to use the edited PNG.
9. Disable only `.aa-hotspot-enter`.
10. Leave `START HERE` as the only visible entry action.

## New Living Failure Rules

### Repeated Correction Gate

Trigger:

- User corrects the same target twice.
- User says the same issue in different words.
- User says “you are not listening,” “same problem,” “why do you keep doing this,” or equivalent.
- User anger rises after a previous claimed fix.
- Assistant has already produced two fixes on the same target.

Immediate action:

`STOP`

Blocked actions:

- No new code.
- No new generated image.
- No new workaround.
- No apology loop followed by more patching.
- No treating the next message as permission to continue patching.

Required review:

1. What is the user’s actual target?
2. What surface is the defect on?
3. What did the assistant wrongly assume?
4. Which previous fix made it worse?
5. What must be restored before continuing?
6. What is the smallest safe next action?

Resume condition:

Only resume after the target surface and next action are stated in one compact line.

### Surface Classification Gate

Classify the surface before acting:

`VISIBLE IMAGE CONTENT = IMAGE ASSET`

`CLICK AREA = HTML/CSS HOTSPOT`

`FIT / SNAP / VIEWPORT = CSS/JS`

`TEXT BAKED INTO PNG = IMAGE EDIT OR STOP`

`TEXT IN HTML = HTML/CSS`

If the visible defect is inside the PNG, do not fake it with HTML/CSS.

### No-Code Freeze After Failed Passes

After two same-target corrections:

`FREEZE / REVIEW ONLY`

After three same-target corrections:

`FAILURE REVIEW ONLY`

No code, no image, no workaround until target surface is classified and user accepts the next action.

## Current Correct One-Line Target

`Remove the baked top ENTER THE INDEX button from the original PNG; keep START HERE; keep snap-fit; no overlay text; no generated redesign; no cheap patch.`

## Current Blocked Claims

Do not claim:

- “The button was removed” unless the PNG itself has been inspected after edit.
- “The page is clean” if bad overlay/image references remain.
- “Done” unless readback confirms page, CSS, image reference, and snap code.
- “Clean” if any error, hang, bad output, generated replacement, or repair correction occurred.

## Save Boundary

This lock does not edit the page, CSS, or image.

It preserves current progress and freezes the next valid action.

No commit.

No push.
