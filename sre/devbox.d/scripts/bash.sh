#!/usr/bin/env bash
# Per-env bash init. Sourced from devbox.json's init_hook.

# Source completion files from devbox-installed packages, if any.
for f in "$DEVBOX_PACKAGES_DIR"/share/bash-completion/completions/*; do
  [ -f "$f" ] && source "$f"
done

if command -v kubecolor >/dev/null 2>&1; then
  alias k="kubecolor"
  alias kubectl="kubecolor"
  alias wk="watch --color kubecolor --force-colors"
  complete -F __start_kubectl kubecolor 2>/dev/null || true
  complete -F __start_kubectl k 2>/dev/null || true
fi
alias kctx="kubectx"
alias kns="kubens"
