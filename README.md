# Broxbhai Repository

## Quick Start (Clone + Restore DB)

### Run the sync script (bootstraps git, backs up DB, commits & pushes):
```bash
npm run sync
```

## When you need to pull `master` into `main`
If your local branch is `main` but the remote is `master`, run:

```bash
# Ensure you're on main
git checkout main

# Fetch latest remote state
git fetch origin

# Merge remote master into local main
git merge origin/master

# Push updated main (set upstream if needed)
git push --set-upstream origin main
```

Or, if you want to overwrite local main with remote master:

```bash
git fetch origin
git checkout main
git reset --hard origin/master
```
