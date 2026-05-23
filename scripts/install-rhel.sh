#!/usr/bin/env bash
set -euo pipefail

ARCH="$(uname -m)"
BIN="$HOME/.local/bin"
mkdir -p "$BIN"

# ── dnf ───────────────────────────────────────────────────────────────────────
sudo dnf install -y epel-release
sudo dnf config-manager --set-enabled crb 2>/dev/null \
    || sudo dnf config-manager --set-enabled powertools 2>/dev/null \
    || true

echo "==> Installing dnf packages..."
sudo dnf install -y \
    # git \
    # curl \ 
    # wget \ 
    # unzip \ 
    stow \
    bat \
    fd-find \
    ripgrep \
    ncdu \
    tmux \
    bind-utils \
    xclip \
    git-delta \
    btop \
    fastfetch \
    yq \
    jq

# fd is 'fd' on RHEL (not fdfind), but symlink anyway for consistency
ln -sf "$(which fd 2>/dev/null || which fdfind)" "$BIN/fd" 2>/dev/null || true

# ── gh cli ───────────────────────────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
    echo "==> Installing gh..."
    sudo dnf install -y 'dnf-command(config-manager)'
    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install -y gh
fi

# ── zsh plugins ───────────────────────────────────────────────────────────────
echo "==> Installing zsh plugins..."
mkdir -p "$HOME/.config/zsh/plugins"
curl -fsSL https://raw.githubusercontent.com/zsh-users/zsh-autosuggestions/master/zsh-autosuggestions.zsh \
    -o "$HOME/.config/zsh/plugins/zsh-autosuggestions.zsh"
curl -fsSL https://raw.githubusercontent.com/zsh-users/zsh-syntax-highlighting/master/zsh-syntax-highlighting.zsh \
    -o "$HOME/.config/zsh/plugins/zsh-syntax-highlighting.zsh"

# ── starship ──────────────────────────────────────────────────────────────────
echo "==> Installing starship..."
curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

# ── zoxide ────────────────────────────────────────────────────────────────────
echo "==> Installing zoxide..."
curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# ── fzf ───────────────────────────────────────────────────────────────────────
echo "==> Installing fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" 2>/dev/null \
    || git -C "$HOME/.fzf" pull --rebase
"$HOME/.fzf/install" --bin
ln -sf "$HOME/.fzf/bin/fzf" "$BIN/fzf"

# ── fzf-git ───────────────────────────────────────────────────────────────────
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

# eza (git-delta is already installed via dnf on RHEL)
echo "==> Installing eza..."
gh release download --repo eza-community/eza \
    --pattern "eza_${TRIPLE_MUSL}.tar.gz" --dir "$tmp"
tar -xzf "$tmp/eza_${TRIPLE_MUSL}.tar.gz" -C "$tmp"
cp "$tmp/eza" "$BIN/eza"

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

echo "==> RHEL install complete."