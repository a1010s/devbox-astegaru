#!/usr/bin/env bash
# After `devbox add <pkg>` (which writes @latest), run this to resolve all
# @latest entries in devbox.json to their currently installed versions.
#
# Usage:  devbox run pin    # from inside the env dir
#         OR  ./scripts/pin-versions.sh

set -euo pipefail

cd "$DEVBOX_CONFIG_DIR" 2>/dev/null || cd "$(dirname "$0")/.."

[ -f devbox.json ] || { echo "no devbox.json in $(pwd)"; exit 1; }

changed=0
# `devbox list` prints lines like: "* terraform@latest - 1.15.4"
while IFS= read -r line; do
  if [[ "$line" =~ ^\*[[:space:]]+([a-zA-Z0-9_+\.-]+)@latest[[:space:]]+-[[:space:]]+(.+)$ ]]; then
    pkg="${BASH_REMATCH[1]}"
    ver="${BASH_REMATCH[2]}"
    if grep -q "\"${pkg}@latest\"" devbox.json; then
      sed -i.bak "s|\"${pkg}@latest\"|\"${pkg}@${ver}\"|g" devbox.json
      echo "  ↻  ${pkg}@latest → ${pkg}@${ver}"
      changed=$((changed + 1))
    fi
  fi
done < <(devbox list 2>/dev/null)

rm -f devbox.json.bak
if [ "$changed" -eq 0 ]; then
  echo "✓ nothing to pin — devbox.json already uses concrete versions"
else
  echo "✓ pinned $changed package(s). Review and commit:"
  echo "    git diff devbox.json"
fi
