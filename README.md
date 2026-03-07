# BroxLab

## Quick start (clone + restore database)

### 1) Clone the repo and restore the latest DB dump (Windows)
```powershell
node scripts/git-sync.js --init --remote "https://github.com/<your>/<repo>.git" --branch main --force-remote
```

### 2) Clone the repo and restore the latest DB dump (Bash / WSL / macOS)
```bash
node scripts/git-sync.js --init --remote "https://github.com/<your>/<repo>.git" --branch main --force-remote
```

### 3) CI-friendly variant (env vars)
```bash
export GIT_REMOTE="https://github.com/<your>/<repo>.git"
export GIT_BRANCH="main"
node scripts/git-sync.js --init --force-remote
```

---

## Notes
- The sync script will:
  1) clean build caches
  2) export the DB to `Database/full/latest.sql`
  3) commit & push changes (if in a git repo)
  4) automatically initialize git + set remote when asked

- If you only want the DB backup (no git), use:
```bash
npm run backup-db
```
