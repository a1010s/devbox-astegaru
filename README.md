# devbox-astegaru

Per-project [devbox](https://www.jetify.com/devbox) environments — declarative
Nix-based tool sets. Each subdirectory is a self-contained env with pinned
package versions. `cd` into a subdir, direnv auto-activates the shell.

## Layout

| Subdir       | Purpose                                                 |
|--------------|---------------------------------------------------------|
| `sre/`       | Full SRE toolkit: terraform, kubectl, helm, k9s, sops…  |
| `terraform/` | Lightweight terraform-only shell (faster activation)    |
| `k8s/`       | Kubernetes-focused: kubectl, kubectx, k9s, helm, flux   |
| `kubewerk/`  | (placeholder) KubeWerk-DE specific tools                |

## First-time setup on a machine

```bash
# 1. Install devbox + direnv (if not already)
brew install direnv
# devbox installed manually at /opt/homebrew/bin/devbox (or via curl install.sh)

# 2. Make sure your shell sources direnv:
#    eval "$(direnv hook zsh)"   ← already in dotfiles-astegaru/zshrc/.zshrc

# 3. Enter an env:
cd ~/Documents/devbox-astegaru/sre
direnv allow                 # first time only: trust the .envrc

# First entry triggers Nix install (~5 min, asks for sudo password once).
# Subsequent entries are instant.
```

## Daily flow

```bash
cd sre              # direnv loads devbox shell automatically
terraform version   # versions pinned by devbox.json
kubectl version --client
exit                # or `cd` away — direnv unloads
```

## Adding a tool

```bash
cd sre
devbox add <pkg>           # appends to devbox.json
direnv reload              # pick up the new package
```

## Updating versions

```bash
cd sre
devbox update              # pulls latest within constraints in devbox.json
```

## Why multi-env?

A single bloated devbox would be slow to activate (every `cd` would reload all
packages). Splitting by domain keeps each env's startup tight. Subdirs can
share tools through symlink imports if needed later.
