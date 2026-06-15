# R16F Mockup To Real Main Promotion Receipt

Timestamp: 20260615_063018

Status:
PROMOTED_AND_LOCKED_LOCAL_PENDING_GIT_RESULT

Promotion direction:
MOCKUP -> REAL MAIN

Source mockup:
C:\Users\13527\Desktop\ESO\ESO\ESO_INDEX_SITE_MOCKUP_20260611_152646\reader\index\public.html
C:\Users\13527\Desktop\ESO\ESO\ESO_INDEX_SITE_MOCKUP_20260611_152646\assets\styles.css
C:\Users\13527\Desktop\ESO\ESO\ESO_INDEX_SITE_MOCKUP_20260611_152646\assets\images\page-kit

Destination real reader:
C:\Users\13527\Desktop\ESO\ESO\reader\index\public.html
C:\Users\13527\Desktop\ESO\ESO\assets\styles.css
C:\Users\13527\Desktop\ESO\ESO\assets\images\page-kit

Backups:
C:\Users\13527\Desktop\ESO\ESO\ACTIVE_CHAT_DROPS\RUNTIME_SESSIONS\R16F_MOCKUP_TO_REAL_PROMOTION_20260615_063018\reader_index_public_before_R16F_20260615_063018.html
C:\Users\13527\Desktop\ESO\ESO\ACTIVE_CHAT_DROPS\RUNTIME_SESSIONS\R16F_MOCKUP_TO_REAL_PROMOTION_20260615_063018\assets_styles_before_R16F_20260615_063018.css

Guard result:
PASS - no workshop/shop/tool tokens in mockup page/css before copy.
PASS - no workshop/shop/tool tokens in real reader page/css after copy.

Forbidden tokens checked:
COORD SHOP, coord-panel, coord-target, coord-copy, coord-nudge, COORD_MARK_TOOL, OPEN_ESO_WORKSHOP, Start-ESO, R16E3_NUDGE, R16E2_NUDGE, R16E1_NUDGE, _WORKSHOP_TOOLS

Expected public selectors checked:
aa-top-hotspot-search, aa-hotspot-enter, aa-card-start, aa-card-index, aa-card-records, aa-card-notes, aa-card-spine, aa-card-parts

SHA256:
mockup public.html: 84178E1A53612D1A71F94867CEAA3366CC8832F4C09D661E9FA9FC3401798F04
mockup styles.css: D21B565362140541B3FC9AE7087F723739B688C1B03F3C54C679E27D8C07B6A1
real public.html: B15608491602DCC2CAD05FA4A1BC8276CCFA126DC7D977E4AA53C7C967271956
real styles.css: 264BB3C84E90EA21C391B99EE10A7F097A75F6825EEDD9AA9B148F63A612513B
tool htmlfrag: 143F56EED427E2FE557009A2FB469F4E2C8B1051AB624A998C98B43D01A9B7AD
tool css: A9A5A3C0C5159CC3573D9055992793053DA3BF3D74AC8C0169327328256539A5

Workshop/tool progress locked separately:
C:\Users\13527\Desktop\ESO\ESO\TOOLS\COORD_MARK_TOOL_R8_LOCKED\COORD_MARK_TOOL_R8.htmlfrag
C:\Users\13527\Desktop\ESO\ESO\TOOLS\COORD_MARK_TOOL_R8_LOCKED\COORD_MARK_TOOL_R8.css
C:\Users\13527\Desktop\ESO\ESO\TOOLS\OPEN_ESO_WORKSHOP.cmd
C:\Users\13527\Desktop\ESO\ESO\TOOLS\Start-ESOCoordSession.ps1
C:\Users\13527\Desktop\ESO\ESO\TOOLS\Start-R16CoordClipboardBridge.ps1

Boundary:
The real reader index received only the built public page, public CSS, and public page-kit assets.
The real reader index did not receive workshop/shop scripts, coordinate panel code, bridge code, or tool fragments.
Workshop code remains under TOOLS only.
