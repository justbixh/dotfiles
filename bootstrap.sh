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
source "$DOTFILES/scripts/detect-os.sh"
detect_os

DO_PKGS=true ; DO_STOW=true
[ "${1:-}" = "--stow-only" ] && DO_PKGS=false
[ "${1:-}" = "--pkgs-only" ] && DO_STOW=false

# ── package installation ──────────────────────────────────────────────────────
if $DO_PKGS; then
    echo "==> Installing packages for $DISTRO..."
    case "$DISTRO" in
        ubuntu) bash "$DOTFILES/scripts/install-ubuntu.sh" ;;
        rhel)   bash "$DOTFILES/scripts/install-rhel.sh"   ;;
        macos)  bash "$DOTFILES/scripts/install-macos.sh"  ;;
        *)      echo "No install script for '$DISTRO'. Add scripts/${DISTRO}.sh" && exit 1 ;;
    esac
fi

# ── stow ──────────────────────────────────────────────────────────────────────
if $DO_STOW; then
    # Guard: stow must be present when running --stow-only (--stow-only skips the package install section entirely)
    if ! command -v stow &>/dev/null; then
        echo "==> stow not found. Run bootstrap.sh without --stow-only first, or: sudo apt install stow"
        exit 1
    fi

    cd "$DOTFILES"
    echo "==> Stowing dotfiles from $DOTFILES → $HOME..."
    stow --target="$HOME" --ignore="^\.bashrc$" --ignore="^\.zshrc$" --restow bash fzf git tmux starship yazi zsh
    
    # Idempotently append to existing bashrc / zshrc instead of replacing them
    if [ -f ~/.bashrc ]; then
        if ! grep -q "source ~/.config/my.bashrc" ~/.bashrc; then
            echo -e "\n# source dotfiles\nsource ~/.config/my.bashrc" >> ~/.bashrc
            echo "==> Appended source ~/.config/my.bashrc to ~/.bashrc"
        fi
    fi
    if [ -f ~/.zshrc ]; then
        if ! grep -q "source ~/.config/my.zshrc" ~/.zshrc; then
            echo -e "\n# source dotfiles\nsource ~/.config/my.zshrc" >> ~/.zshrc
            echo "==> Appended source ~/.config/my.zshrc to ~/.zshrc"
        fi
    fi
    
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

echo "─────────────────────────────────────────"
echo "==> Installation Summary:"
echo "    - Packages: $DO_PKGS"
echo "    - Stow:     $DO_STOW"
echo "    - Distro:   $DISTRO"
echo "==> Done. Restart your shell or run:"
echo "    source ~/.bashrc (or source ~/.zshrc)"
echo "─────────────────────────────────────────"