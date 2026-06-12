# Root Folder Cleanup Receipt

Status: `ROOT_CLEANUP_DONE`

Timestamp: `20260612_0130`

Repo root used:

`C:\Users\13527\Desktop\ESO\ESO`

Outer holding folder:

`C:\Users\13527\Desktop\ESO`

## Actions

- Moved outer root asset drop `eso_extracted_page_assets` into raw custody:
  `ACTIVE_CHAT_DROPS/RAW_INCOMING/ASSET_DROPS/EXTRACTED_PAGE_ASSETS_20260612_012754`
- Copied usable asset files into:
  `assets/images/page-kit/front`
  `assets/images/page-kit/part1`
- Copied asset-drop support files into:
  `assets/images/page-kit/extracted_page_assets_contact_sheet.jpg`
  `assets/images/page-kit/extracted_page_assets_manifest.raw.json`
- Moved duplicate repo-root image `aa-front-original.png` into:
  `ACTIVE_CHAT_DROPS/RAW_INCOMING/ASSET_DROPS/ROOT_DUPLICATES_20260611_213843/aa-front-original.png`
- Moved outer root `QUARANTINE` into:
  `ACTIVE_CHAT_DROPS/QUARANTINE/SITE_EDIT_SCRIPTS_AND_CHATGPT_EXPORT_20260611_230941`

## Notes

- The folder cleanup itself did not change live HTML or CSS.
- Follow-up site-health repair added the missing public-index search panel; see `ACTIVE_CHAT_DROPS/SITE_RECEIPTS/SEARCH_PANEL_REPAIR_RECEIPT_20260612_0138.md`.
- The nested `ESO` folder is the actual git repo. The outer folder is a holding/workspace folder.
- Existing uncommitted public-reader edits were already present before this cleanup and were left intact.
