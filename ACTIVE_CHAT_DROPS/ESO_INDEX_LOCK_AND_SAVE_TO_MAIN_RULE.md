# ESO Index Lock And Save To Main Rule

Current status:
ACTIVE_CURRENT_RULE

Meaning:
When user says LOCK AND SAVE TO MAIN after index work, save the approved current index state to BOTH:
1. living mockup main
2. real main reader

Main surfaces:
MOCKUP MAIN:
ESO_INDEX_SITE_MOCKUP_20260611_152646/reader/index/public.html

REAL MAIN:
reader/index/public.html

Rule:
The mockup main remains alive after promotion.
The real main must be updated to match the approved mockup/candidate when user says lock and save to main.
Part indexes are separate files and must not overwrite mockup main.

Part index path pattern:
ESO_INDEX_SITE_MOCKUP_20260611_152646/reader/index/parts/part-01-index.html
ESO_INDEX_SITE_MOCKUP_20260611_152646/reader/index/parts/part-02-index.html
ESO_INDEX_SITE_MOCKUP_20260611_152646/reader/index/parts/part-03-index.html

Guard:
No restore/promotion may use an old ref unless the user visually approved that exact candidate first.
