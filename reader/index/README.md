# Living Index Folder

`reader/index` is the source-of-truth folder for the story index system.

- `public.html` is the slow-release public index. It should only link chapters approved for release.
- `full.html` is the internal full story shelf for the current built arc.
- `../../index.html` is only the clean front door that routes readers into `public.html`.

When a chapter is approved for release:

1. Build or update its public chapter page under `reader/public`.
2. Add the chapter link to `public.html`.
3. Keep unreleased chapter drafts linked only from `full.html` or the hidden chapter shelf.
4. Rebuild the read-along package from public files only.
