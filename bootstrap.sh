#!/usr/bin/env bash
# dotfiles/bootstrap.sh
# Stow-only bootstrap — assumes packages are already installed manually.
#
# Usage:
#   bash ~/dotfiles/bootstrap.sh          # stow all packages
#   bash ~/dotfiles/bootstrap.sh --dry    # dry run, no changes

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DRY=false
[ "${1:-}" = "--dry" ] && DRY=true

STOW_FLAGS="--restow"
$DRY && STOW_FLAGS="--simulate"

# guard
if ! command -v stow &>/dev/null; then
    echo "stow not found. Install it first: sudo apt[dnf][brew] install stow"
    exit 1
fi

# stow packages
cd "$DOTFILES"
echo "==> Stowing dotfiles → $HOME..."
stow $STOW_FLAGS zsh nvim tmux git fzf starship yazi wezterm install

# rc source-line append (idempotent)
if ! $DRY; then
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -qF "source ~/.config/zsh/my.zshrc" "$HOME/.zshrc"; then
            printf '\n# dotfiles\n[[ $- == *i* && -f ~/.config/zsh/my.zshrc ]] && source ~/.config/zsh/my.zshrc\n' >> "$HOME/.zshrc"
            echo "==> Appended my.zshrc line to ~/.zshrc"
        fi
    fi

    # if [ -f "$HOME/.bashrc" ]; then
    #     if ! grep -qF "source ~/.config/bash/my.bashrc" "$HOME/.bashrc"; then
    #         printf '\n# dotfiles\n[[ $- == *i* && -f ~/.config/bash/my.bashrc ]] && source ~/.config/bash/my.bashrc\n' >> "$HOME/.bashrc"
    #         echo "==> Appended my.bashrc to ~/.bashrc"
    #     fi
    # fi
fi

echo "==> Done. Run: source ~zshrc or ~/.bashrc"
