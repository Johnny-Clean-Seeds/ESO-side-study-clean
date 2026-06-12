# Image Hotspot 2-Click Calibration Method

Status: ACTIVE METHOD NOTE

Purpose: place clickable HTML hotspot rectangles over a static image mockup without guessing.

CORE METHOD:
1. Use the static image as the visual surface.
2. Add a temporary marker panel over .aa-front-image-stage.
3. Each clickable target gets two clicks only:
   - first click = top-left corner of painted target
   - second click = bottom-right corner of painted target
4. Convert the two points into CSS percentages:
   - left
   - top
   - width
   - height
5. Remove the marker tool after capture.
6. Install final invisible hotspot CSS.

WHY THIS EXISTS:
The code can know target order, but it cannot know the painted button geometry inside a raster image. The user marks the rectangle once. Codex then uses the measured CSS.

GOOD OUTPUT SHAPE:
TARGET NAME
  top-left: x 23.494% | y 95.324%
  bottom-right: x 30.470% | y 96.429%
  CSS: .target-selector { left: 23.494%; top: 95.324%; width: 6.975%; height: 1.105%; }

BAD CAPTURE SIGNS:
- height near 0.000%
- width near 0.000%
- overlapping click pairs
- clicking center dots instead of corners
- clicking across a row instead of one target rectangle

ROW CLEANUP RULE:
If the user has hand wobble or carpal tunnel, average shared row top and height values. Preserve individual left and width values, with slight padding for easier clicking.

CURRENT TARGET GROUPS:
- top nav: HOME, INDEX, RECORDS, NOTES, PARTS, ABOUT, SEARCH
- hero: ENTER THE INDEX, BROWSE THE PARTS
- cards: START HERE, RESEARCH INDEX, SOURCE RECORDS, VISUAL NOTES, DOCUMENTARY SPINE, PART INDEX
- footer: ABOUT THIS SITE, RESEARCH ETHICS, HOW TO HELP, CONTACT, TERMS, PRIVACY, PUBLIC COLLABORATIVE NONPROFIT

SAFETY:
This method controls website image-overlay geometry only. It does not prove research claims. Do not expose unreleased parts as real links. Part 1 remains the only real public part until explicitly released.
