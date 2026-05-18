#!/usr/bin/env bash

# ── bootstrap.sh ──────────────────────────────────────────────────────────────
# One-shot setup: installs packages then stows dotfiles.

# Usage:
#   git clone git@github.com:YOU/dotfiles.git ~/.dotfiles
#   bash ~/.dotfiles/bootstrap.sh [--stow-only | --pkgs-only]

# Options:
#   --stow-only    skip package install, only run stow
#   --pkgs-only    skip stow, only install packages

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES/install/detect-os.sh"
detect_os

DO_PKGS=true ; DO_STOW=true
[ "${1:-}" = "--stow-only" ] && DO_PKGS=false
[ "${1:-}" = "--pkgs-only" ] && DO_STOW=false

# ── package installation ──────────────────────────────────────────────────────
if $DO_PKGS; then
    echo "==> Installing packages for $DISTRO..."
    case "$DISTRO" in
        ubuntu) bash "$DOTFILES/install/linux-ubuntu.sh" ;;
        rhel)   bash "$DOTFILES/install/linux-rhel.sh"   ;;
        macos)  bash "$DOTFILES/install/darwin.sh"       ;;
        *)      echo "No install script for '$DISTRO'. Add install/${DISTRO}.sh" && exit 1 ;;
    esac
fi

# ── stow ──────────────────────────────────────────────────────────────────────
if $DO_STOW; then
    # Guard: stow must be present when running --stow-only (--stow-only skips the package install section entirely)
    if ! command -v stow &>/dev/null; then
        echo "==> stow not found. Run bootstrap.sh without --stow-only first, or: sudo apt install stow"
        exit 1
    fi

    # Back up any existing bashrc that isn't already our symlink
    if [ -f ~/.bashrc ] && [ ! -L ~/.bashrc ]; then
        cp ~/.bashrc ~/.bashrc.bak."$(date +%s)"
        echo "==> Backed up existing ~/.bashrc"
    fi

    cd "$DOTFILES/stow"
    echo "==> Stowing dotfiles from $DOTFILES/stow → $HOME..."
    stow --target="$HOME" --restow bash fzf git tmux starship yazi
    
    # Optional packages
    # stow nvim yazi btop fastfetch

    # Create local overrides file (not tracked)
    if [ ! -f ~/.config/shell/local ]; then
        mkdir -p ~/.config/shell
        cat > ~/.config/shell/local <<'EOF'
# Machine-local config — not in git.
# Put here: proxy settings, work tokens, JAVA_HOME, GIT_AUTHOR_EMAIL, etc.
EOF
        echo "==> Created ~/.config/shell/local"
    fi
fi

# echo "==> Done. Run: source ~/.bashrc"
echo "==> Bootstrap complete. Open a new shell or: source ~/.bashrc"
