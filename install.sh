#!/usr/bin/env bash
# Wires shell aliases so you can enter each devbox env from anywhere.
# Run once per machine:    ./install.sh
#
# IMPORTANT: this uses awk + redirected output (`cat > file`) instead of
# `sed -i`. On macOS, BSD sed -i REPLACES symlinks with a new inode — which
# would break stow-managed dotfiles. The redirect approach follows symlinks.

set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Edit a file in-place while preserving any symlink it may be.
# Replaces an existing `alias <name>=...` line OR appends if not present.
add_or_replace_alias() {
  local file="$1"
  local name="$2"
  local cmd="$3"

  [ ! -f "$file" ] && return 0

  # Use a separate tempfile that the awk reads into, then redirect-write
  # back to $file. Redirect (`>`) follows symlinks; `mv` would break them.
  local tmp
  tmp=$(mktemp)
  if grep -q "^alias $name=" "$file"; then
    awk -v name="$name" -v cmd="$cmd" '
      $0 ~ "^alias " name "=" { printf "alias %s=\"%s\"\n", name, cmd; next }
      { print }
    ' "$file" > "$tmp"
    cat "$tmp" > "$file"
    echo "  ↻  $name updated in $file"
  else
    {
      cat "$file"
      printf '\n# devbox-astegaru\nalias %s="%s"\n' "$name" "$cmd"
    } > "$tmp"
    cat "$tmp" > "$file"
    echo "  +  $name added to $file"
  fi
  rm -f "$tmp"
}

for shell_rc in ~/.zshrc ~/.bashrc; do
  echo "==> $shell_rc"
  add_or_replace_alias "$shell_rc" "a-shell"       "devbox shell -c $REPO_DIR/sre"
  add_or_replace_alias "$shell_rc" "tf-shell"      "devbox shell -c $REPO_DIR/terraform"
  add_or_replace_alias "$shell_rc" "k8s-shell"     "devbox shell -c $REPO_DIR/k8s"
  add_or_replace_alias "$shell_rc" "kubewerk-shell" "devbox shell -c $REPO_DIR/kubewerk"
done

cat <<'EOF'

Done. Open a new shell or `exec zsh` and use:
  a-shell         # full SRE toolkit
  tf-shell        # terraform-only fast shell
  k8s-shell       # kubernetes-focused
  kubewerk-shell  # KubeWerk-DE env

Exit any env with `exit` or Ctrl-D — returns to your normal shell.
EOF
