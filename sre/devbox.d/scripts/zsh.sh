#!/usr/bin/env zsh
# Per-env zsh init. Sourced from devbox.json's init_hook.

# Make completion files from devbox-installed packages discoverable.
# This auto-wires kubectl/helm/flux/stern/etc completions without
# manual `source <(... completion zsh)` calls.
fpath+=("$DEVBOX_PACKAGES_DIR/share/zsh/site-functions")
autoload -Uz compinit && compinit -i

# Colored kubectl. Aliases share kubectl's completion via compdef.
if command -v kubecolor >/dev/null 2>&1; then
  alias k="kubecolor"
  alias kubectl="kubecolor"
  alias wk="watch --color kubecolor --force-colors"
  compdef kubecolor=kubectl
  compdef wk=kubectl
fi
alias kctx="kubectx"
alias kns="kubens"
