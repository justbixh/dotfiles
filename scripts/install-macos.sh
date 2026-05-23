#!/usr/bin/env bash
set -euo pipefail

# ── homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Apple Silicon: ensure brew is on PATH for this session
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ── brew packages ─────────────────────────────────────────────────────────────
echo "==> Installing brew packages..."
brew install \
    git \
    stow \
    curl \
    bat \
    fd \
    ripgrep \
    jq \
    ncdu \
    tmux \
    vim \
    eza \
    git-delta \
    lazygit \
    btop \
    fastfetch \
    yazi \
    yq \
    starship \
    zoxide \
    fzf \
    gh

# ── fzf-git (no brew formula) ─────────────────────────────────────────────────
echo "==> Installing fzf-git..."
mkdir -p "$HOME/.config/fzf-git"
curl -fsSL https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
    -o "$HOME/.config/fzf-git/fzf-git.sh"

# ── zsh plugins ───────────────────────────────────────────────────────────────
echo "==> Installing zsh plugins..."
mkdir -p "$HOME/.config/zsh/plugins"
curl -fsSL https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh \
    -o "$HOME/.config/zsh/plugins/zsh-autosuggestions.zsh"
curl -fsSL https://raw.githubusercontent.com/zsh-users/zsh-syntax-highlighting/master/zsh-syntax-highlighting.zsh \
    -o "$HOME/.config/zsh/plugins/zsh-syntax-highlighting.zsh"

echo "==> macOS install complete."