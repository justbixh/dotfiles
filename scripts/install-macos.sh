#!/usr/bin/env bash
set -euo pipefail

echo "Installing Homebrew..."
command -v brew &>/dev/null || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Apple Silicon: brew shellenv
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ── Homebrew packages ─────────────────────────────────────────────────────────
echo "Installing brew packages..."
brew install \
    git stow curl \
    bat fd ripgrep jq ncdu tmux vim \
    eza git-delta lazygit btop fastfetch yazi yq \
    starship zoxide fzf

# fzf-git (not in brew)
mkdir -p "$HOME/.config/fzf-git"
curl -fsSL https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
    -o "$HOME/.config/fzf-git/fzf-git.sh"

echo "macOS install complete."