## Plan: npm script to auto-backup DB + clear cache + git push

**TL;DR:**
Add an npm script (`npm run sync`) that:
1) clears build/cache folders, 2) creates a database dump (structure + data) under `Database/full/`, 3) stages/commits/pushes all changes to the configured Git remote.

This will allow cloning the repository on another machine and restoring the DB schema + data from the committed SQL file.

---

## Steps

### 1) Create a CLI backup helper (PHP)
- Add `scripts/db-backup.php` that:
  - Loads `public_html/_db.php` to reuse existing export helpers.
  - Calls `fullDatabaseSingleFileInit()` + `exportTableChunkToSingleFile()` / `finalizeSingleFile()` to produce a full dump (structure + data) in `Database/full/full_database_<timestamp>.sql`.
  - Also writes/updates `Database/full/latest.sql` so the most recent dump is always at a stable path.
  - Accepts these CLI options (via `$argv`):
    - `--structure-only` (dump schema only)
    - `--output <path>` (override output filename)
    - `--keep-archives` (keep older timestamped files; default: keep both latest + timestamped)
- Ensure the script exits non-zero on errors and prints useful status lines.

### 2) Create a Node orchestrator script
- Add `scripts/git-sync.js` that:
  - Runs the existing build/clean tasks:
    - `npm run clean:build` (cleans JS build outputs)
  - Removes cache/temp folders:
    - `storage/cache/` (if exists)
    - `public_html/uploads/tmp/` (if exists)
  - Runs the PHP backup helper:
    - `php scripts/db-backup.php --output Database/full/latest.sql`
    - (The helper will also produce a timestamped file by default.)
  - Uses `git` to:
    - `git add -A`
    - If there are changes (`git status --porcelain`):
      - `git commit -m "Auto backup + sync <YYYY-MM-DD HH:MM:SS>"`
      - `git push`
  - Prints a summary and exits with the same status as the last git command.

### 3) Add npm script
- Update `package.json`:
  - Add: `"sync": "node scripts/git-sync.js"`
  - (Optionally) add `"backup-db": "php scripts/db-backup.php"` for manual use.

### 4) Verify & document
- Confirm `Database/full/` is **not** ignored (it isn’t in `.gitignore`).
- Add a short note to `docs/` (or `README.md`) describing how to use `npm run sync` and how to restore from `Database/full/latest.sql`.
- (Optional) Add `.env.example` since `.env` is ignored.

---

## Relevant files to modify / create

- `package.json` → add `sync` (and optional helper scripts)
- `scripts/db-backup.php` → new PHP helper for CLI database export
- `scripts/git-sync.js` → new Node script that runs clean/backup/git steps
- `docs/...` (optional) → document usage

---

## Verification

1. Run `npm run sync` locally.
2. Confirm it:
   - Creates/updates a file like `Database/full/full_database_<timestamp>.sql` and `Database/full/latest.sql`.
   - Deletes cache dirs (e.g., `storage/cache`, `public_html/uploads/tmp`).
   - Performs `git add`, `git commit` (when needed), and `git push` successfully.
3. On another machine, clone the repo and confirm:
   - `Database/full/latest.sql` exists (or similar).
   - Running the existing PHP import workflow (via UI or CLI) restores schema + data.

---

## Decisions / Assumptions

- The repository already contains a database export utility (`public_html/_db.php`) so we reuse it instead of re-implementing dumping logic.
- We will store backups in `Database/full/`, which is already part of the repo.
- The script will rely on `php` and `git` being available in PATH.
- The backup will be a full dump (schema + data) by default.

---

## Open questions (for you)

1. Should the backup include **data** (full dump) or just **schema**? (Default will be full dump since you asked for tables.)
2. Should we keep both a stable `latest.sql` and timestamped archives, or only the stable file to avoid repo growth?
