#!/usr/bin/env bash
# Wires shell aliases so you can enter each devbox env from anywhere.
# Run once per machine:    ./install.sh

set -eu

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

add_alias() {
  local file="$1"
  local name="$2"
  local cmd="devbox shell -c $REPO_DIR/$3"

  [ ! -f "$file" ] && return 0

  if grep -q "alias $name=" "$file"; then
    # Replace existing line (BSD/GNU sed compatibility)
    sed -i.bak "s|alias $name=.*|alias $name=\"$cmd\"|" "$file"
    rm -f "${file}.bak"
    echo "  ↻  $name updated in $file"
  else
    printf '\n# devbox-astegaru\nalias %s="%s"\n' "$name" "$cmd" >> "$file"
    echo "  +  $name added to $file"
  fi
}

for shell_rc in ~/.zshrc ~/.bashrc; do
  echo "==> $shell_rc"
  add_alias "$shell_rc" "sre-shell"       "sre"
  add_alias "$shell_rc" "tf-shell"        "terraform"
  add_alias "$shell_rc" "k8s-shell"       "k8s"
  add_alias "$shell_rc" "kubewerk-shell"  "kubewerk"
done

cat <<'EOF'

Done. Open a new shell or `exec zsh` and use:
  sre-shell       # full SRE toolkit
  tf-shell        # terraform-only fast shell
  k8s-shell       # kubernetes-focused
  kubewerk-shell  # KubeWerk-DE env

Exit any env with `exit` or Ctrl-D — returns to your normal shell.
EOF
