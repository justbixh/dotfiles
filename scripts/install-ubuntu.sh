#!/usr/bin/env bash
set -euo pipefail

ARCH="$(uname -m)"
BIN="$HOME/.local/bin"
mkdir -p "$BIN"

# ── apt ───────────────────────────────────────────────────────────────────────
sudo apt-get update -y -q

echo "==> Installing apt packages..."
sudo apt-get install -y -q \
    git \
    curl \
    wget \
    unzip \
    stow \
    btop \
    bat \
    fd-find \
    ripgrep \
    jq \
    yq \
    ncdu \
    tmux \
    vim \
    dnsutils \
    fastfetch \
    xclip

# Ubuntu naming quirks → fix with symlinks
ln -sf "$(which batcat)" "$BIN/bat"
ln -sf "$(which fdfind)" "$BIN/fd"

# ── gh cli (needed for all GitHub installs below) ────────────────────────────
if ! command -v gh &>/dev/null; then
    echo "==> Installing gh..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list
    sudo apt-get update -q && sudo apt-get install -y -q gh
fi

# ── zsh plugins (curl, not on gh releases) ────────────────────────────────────
echo "==> Installing zsh plugins..."
mkdir -p "$HOME/.config/zsh/plugins"
curl -fsSL https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh \
    -o "$HOME/.config/zsh/plugins/zsh-autosuggestions.zsh"
curl -fsSL https://raw.githubusercontent.com/zsh-users/zsh-syntax-highlighting/master/zsh-syntax-highlighting.zsh \
    -o "$HOME/.config/zsh/plugins/zsh-syntax-highlighting.zsh"

# ── starship (uses its own install script) ────────────────────────────────────
echo "==> Installing starship..."
curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

# ── zoxide (uses its own install script) ─────────────────────────────────────
echo "==> Installing zoxide..."
curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# ── fzf (git-based, its install script sets up shell integration) ─────────────
echo "==> Installing fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" 2>/dev/null \
    || git -C "$HOME/.fzf" pull --rebase
"$HOME/.fzf/install" --bin
ln -sf "$HOME/.fzf/bin/fzf" "$BIN/fzf"

# ── fzf-git (single script, no release) ──────────────────────────────────────
echo "==> Installing fzf-git..."
mkdir -p "$HOME/.config/fzf-git"
curl -fsSL https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
    -o "$HOME/.config/fzf-git/fzf-git.sh"

# ── gh release installs ───────────────────────────────────────────────────────
case "$ARCH" in
    x86_64)  TRIPLE_MUSL="x86_64-unknown-linux-musl"
              TRIPLE_GNU="x86_64-unknown-linux-gnu" ;;
    aarch64) TRIPLE_MUSL="aarch64-unknown-linux-musl"
              TRIPLE_GNU="aarch64-unknown-linux-gnu" ;;
esac

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# eza
echo "==> Installing eza..."
gh release download --repo eza-community/eza \
    --pattern "eza_${TRIPLE_MUSL}.tar.gz" --dir "$tmp"
tar -xzf "$tmp/eza_${TRIPLE_MUSL}.tar.gz" -C "$tmp"
cp "$tmp/eza" "$BIN/eza"

# git-delta
echo "==> Installing git-delta..."
gh release download --repo dandavison/delta \
    --pattern "delta-*-${TRIPLE_GNU}.tar.gz" --dir "$tmp"
tar -xzf "$tmp"/delta-*-"${TRIPLE_GNU}".tar.gz -C "$tmp"
find "$tmp" -name delta -type f -exec cp {} "$BIN/delta" \;

# lazygit
echo "==> Installing lazygit..."
case "$ARCH" in
    x86_64)  LG_PATTERN="lazygit_*_Linux_x86_64.tar.gz" ;;
    aarch64) LG_PATTERN="lazygit_*_Linux_arm64.tar.gz" ;;
esac
gh release download --repo jesseduffield/lazygit \
    --pattern "$LG_PATTERN" --dir "$tmp"
tar -xzf "$tmp"/$LG_PATTERN -C "$tmp"
cp "$tmp/lazygit" "$BIN/lazygit"

# yazi
echo "==> Installing yazi..."
gh release download --repo sxyazi/yazi \
    --pattern "yazi-${TRIPLE_GNU}.tar.gz" --dir "$tmp"
tar -xzf "$tmp/yazi-${TRIPLE_GNU}.tar.gz" -C "$tmp"
find "$tmp" -name yazi -type f -exec cp {} "$BIN/yazi" \;

echo "==> Ubuntu install complete."