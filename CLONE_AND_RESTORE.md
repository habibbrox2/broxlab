# Clone & Restore (One Command)

This repo includes helper scripts to clone, install dependencies, and restore the latest database dump in one go.

## Windows (PowerShell)
```powershell
node scripts/git-sync.js --init --remote "https://github.com/<your>/<repo>.git" --branch main --force-remote
```

## Bash / WSL / macOS
```bash
node scripts/git-sync.js --init --remote "https://github.com/<your>/<repo>.git" --branch main --force-remote
```

## CI-friendly (environment variables)
```bash
export GIT_REMOTE="https://github.com/<your>/<repo>.git"
export GIT_BRANCH="main"
node scripts/git-sync.js --init --force-remote
```

---

### Notes
- This will:
  1. Clean build caches
  2. Export the DB to `Database/full/latest.sql`
  3. Initialize git + configure remote (if requested)
  4. Commit and push changes

- If you only need a backup (no git), run:
```bash
npm run backup-db
```
