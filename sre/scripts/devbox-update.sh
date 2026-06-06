#!/usr/bin/env bash
# Runs on every `devbox shell` entry.
# Checks if the devbox-astegaru repo is behind origin/main; offers to rebase.

set -eu

# DEVBOX_CONFIG_DIR is the per-env dir (e.g. .../sre/). We want the repo root.
REPO_ROOT="$(cd "$DEVBOX_CONFIG_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Fail silently on offline / no network — don't block shell entry.
if ! git fetch --quiet 2>/dev/null; then
  exit 0
fi

# How many commits is origin/main ahead of our HEAD?
behind=$(git rev-list --count HEAD..origin/main 2>/dev/null || echo 0)

if [ "$behind" -gt 0 ]; then
  echo "⚠  devbox-astegaru is $behind commit(s) behind origin/main."
  printf "   Rebase now? [y/N] "
  read -r ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    git pull --rebase --autostash
    echo "   ✓ updated. Exit and re-enter the shell to pick up changes:  exit && sre-shell"
  fi
fi
