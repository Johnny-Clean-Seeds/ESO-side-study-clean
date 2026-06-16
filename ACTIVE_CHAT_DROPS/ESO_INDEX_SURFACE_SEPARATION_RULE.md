# ESO Index Surface Separation Rule

Current status:
ACTIVE_CURRENT_RULE

Rule:
The mockup main index is a living main index. It must remain a main index even after it is promoted to the real ESO reader.

Do not turn the mockup main index into Part 1.
Do not overwrite the mockup main index with a part index.
Do not consume or retire the mockup main index during promotion.

Correct structure:
MAIN INDEX:
ESO_INDEX_SITE_MOCKUP_20260611_152646/reader/index/public.html

PART INDEXES:
ESO_INDEX_SITE_MOCKUP_20260611_152646/reader/index/parts/part-01-index.html
ESO_INDEX_SITE_MOCKUP_20260611_152646/reader/index/parts/part-02-index.html
ESO_INDEX_SITE_MOCKUP_20260611_152646/reader/index/parts/part-03-index.html
And so on.

Promotion rule:
Mockup main may be copied to real main only after approval, but the mockup main remains alive in the mockup afterward.

Part build rule:
When building Part 1, create or edit Part 1's own index file. Do not reuse the mockup main index as Part 1.

Boundary:
Real reader files are not part of this recovery unless the user explicitly asks for a real-reader promotion.
