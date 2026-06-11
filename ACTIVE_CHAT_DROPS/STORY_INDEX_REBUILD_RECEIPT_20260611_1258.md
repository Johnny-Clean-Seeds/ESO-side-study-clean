# Story Index Rebuild Receipt

Status: `PUBLIC_PART_1_OPEN / LIVING_INDEX_FOLDER_ADDED / PACKAGE_REFRESHED`

Backup made before this pass:

`ACTIVE_CHAT_DROPS/SITE_BACKUPS/living_index_rebuild_20260611_125247`

## What Changed

- Root `index.html` is now a clean doorway into the living index folder.
- New living index folder created at `reader/index`.
- Public slow-release index moved to `reader/index/public.html`.
- Internal full story shelf created at `reader/index/full.html`.
- Public Part 1 chapter created at `reader/public/part-01-front-door.html`.
- `assets/styles.css` now includes the living story-index layout, scrapbook board styling, responsive chapter tickets, side menus, public chapter layout, and mobile checks.

## Image Used

Public visual concept image:

`assets/images/scrapbook-dossier-board.jpg`

Placement:

- Hero board on `reader/index/public.html`.
- Clickable visual concept board on `reader/public/part-01-front-door.html`.
- Internal visual board on `reader/index/full.html`.

## Release Behavior

- Public readers enter through `index.html`, which routes to `reader/index/public.html`.
- Public index links only to `reader/public/part-01-front-door.html`.
- Parts 2-5 appear on the public index as non-clickable coming-later chapter cards.
- Internal full index links the current hidden chapter shelf for Parts 2-5.
- Later parts are not exposed in public or internal index pages in this pass.

## Public Package

Package:

`DOWNLOADS/ESO_READ_ALONG_PACKAGE.zip`

SHA256:

`1A874CEAF5A3BC722CF2CDCE4028C58C23BDA24A03A66F4E5F8984AD004B6526`

Package contents verified:

- `index.html`
- `assets/styles.css`
- `assets/images/scrapbook-dossier-board.jpg`
- `reader/index/public.html`
- `reader/public/part-01-front-door.html`

Package excludes:

- `ACTIVE_CHAT_DROPS`
- `HALL_COOP_LEY`
- `SOURCE_ARCHIVE`
- `reader/chapters`
- `reader/index/full.html`
- raw incoming files

## QA

- Local link check passed.
- Public leak check passed for later-part terms and builder/status terms.
- Browser check passed at desktop and 390px mobile widths.
- Public index, public Part 1, and internal full index loaded with no horizontal overflow.
- Scrapbook image loaded on all checked pages.
- Browser console error check passed.

## Next Move

When Part 2 is approved for public release, build `reader/public/part-02-mesoamerican-foundation.html`, update only `reader/index/public.html`, rebuild the public package, and append a new receipt.
