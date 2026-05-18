#!/usr/bin/env bash
set -euo pipefail

ARCH="$(uname -m)"
BIN="$HOME/.local/bin"
mkdir -p "$BIN"

# ── dnf: stable tools ────────────────────────────────────────────────────────
sudo dnf install -y epel-release
sudo dnf config-manager --set-enabled crb 2>/dev/null \
    || sudo dnf config-manager --set-enabled powertools 2>/dev/null || true

echo "Installing dnf packages..."
sudo dnf install -y \
    git curl wget unzip stow \
    bat fd-find \
    ripgrep jq ncdu tmux vim-enhanced \
    bind-utils xclip

# fd is 'fd' on RHEL (not fdfind), but symlink anyway for consistency
ln -sf "$(which fd 2>/dev/null || which fdfind)" "$BIN/fd" 2>/dev/null || true

# ── GitHub: same block as Ubuntu ─────────────────────────────────────────────
# starship
echo "Installing starship..."
curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

# zoxide
echo "Installing zoxide..."
curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# fzf
echo "Installing fzf (latest)..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" 2>/dev/null \
    || git -C "$HOME/.fzf" pull --rebase
"$HOME/.fzf/install" --bin
ln -sf "$HOME/.fzf/bin/fzf" "$BIN/fzf"

# fzf-git
echo "Installing fzf-git..."
mkdir -p "$HOME/.config/fzf-git"
curl -fsSL https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
    -o "$HOME/.config/fzf-git/fzf-git.sh"

# eza
echo "Installing eza..."
case "$ARCH" in
    x86_64)  EZA_GLOB="eza_x86_64-unknown-linux-musl.tar.gz" ;;
    aarch64) EZA_GLOB="eza_aarch64-unknown-linux-musl.tar.gz" ;;
esac
EZA_URL=$(curl -fsSL https://api.github.com/repos/eza-community/eza/releases/latest \
    | grep browser_download_url | grep "$EZA_GLOB" | head -1 | cut -d'"' -f4)
tmp=$(mktemp -d)
curl -fsSL "$EZA_URL" -o "$tmp/eza.tar.gz"
tar -xzf "$tmp/eza.tar.gz" -C "$tmp"
cp "$tmp/eza" "$BIN/eza"
rm -rf "$tmp"

# git-delta
echo "Installing git-delta..."
case "$ARCH" in
    x86_64)  DELTA_GLOB="delta-.*-x86_64-unknown-linux-gnu.tar.gz" ;;
    aarch64) DELTA_GLOB="delta-.*-aarch64-unknown-linux-gnu.tar.gz" ;;
esac
DELTA_URL=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest \
    | grep browser_download_url | grep -E "$DELTA_GLOB" | head -1 | cut -d'"' -f4)
tmp=$(mktemp -d)
curl -fsSL "$DELTA_URL" -o "$tmp/delta.tar.gz"
tar -xzf "$tmp/delta.tar.gz" -C "$tmp"
find "$tmp" -name delta -type f -exec cp {} "$BIN/delta" \;
rm -rf "$tmp"

# lazygit
echo "Installing lazygit..."
case "$ARCH" in
    x86_64)  LG_GLOB="lazygit_.*_Linux_x86_64.tar.gz" ;;
    aarch64) LG_GLOB="lazygit_.*_Linux_arm64.tar.gz" ;;
esac
LG_URL=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep browser_download_url | grep -E "$LG_GLOB" | head -1 | cut -d'"' -f4)
tmp=$(mktemp -d)
curl -fsSL "$LG_URL" -o "$tmp/lazygit.tar.gz"
tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp"
cp "$tmp/lazygit" "$BIN/lazygit"
rm -rf "$tmp"

# btop
echo "Installing btop..."
case "$ARCH" in
    x86_64)  BTOP_GLOB="btop-x86_64-linux-musl.tbz" ;;
    aarch64) BTOP_GLOB="btop-aarch64-linux-musl.tbz" ;;
esac
BTOP_URL=$(curl -fsSL https://api.github.com/repos/aristocratos/btop/releases/latest \
    | grep browser_download_url | grep "$BTOP_GLOB" | head -1 | cut -d'"' -f4)
tmp=$(mktemp -d)
curl -fsSL "$BTOP_URL" -o "$tmp/btop.tbz"
tar -xjf "$tmp/btop.tbz" -C "$tmp"
cp "$tmp/btop/bin/btop" "$BIN/btop"
rm -rf "$tmp"

# fastfetch
echo "Installing fastfetch..."
case "$ARCH" in
    x86_64)  FF_GLOB="fastfetch-linux-amd64.tar.gz" ;;
    aarch64) FF_GLOB="fastfetch-linux-aarch64.tar.gz" ;;
esac
FF_URL=$(curl -fsSL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest \
    | grep browser_download_url | grep "$FF_GLOB" | head -1 | cut -d'"' -f4)
tmp=$(mktemp -d)
curl -fsSL "$FF_URL" -o "$tmp/ff.tar.gz"
tar -xzf "$tmp/ff.tar.gz" -C "$tmp"
find "$tmp" -name fastfetch -type f -exec cp {} "$BIN/fastfetch" \;
rm -rf "$tmp"

# yazi
echo "Installing yazi..."
case "$ARCH" in
    x86_64)  YZ_GLOB="yazi-x86_64-unknown-linux-gnu.tar.gz" ;;
    aarch64) YZ_GLOB="yazi-aarch64-unknown-linux-gnu.tar.gz" ;;
esac
YZ_URL=$(curl -fsSL https://api.github.com/repos/sxyazi/yazi/releases/latest \
    | grep browser_download_url | grep "$YZ_GLOB" | grep -v sha | head -1 | cut -d'"' -f4)
tmp=$(mktemp -d)
curl -fsSL "$YZ_URL" -o "$tmp/yazi.tar.gz"
tar -xzf "$tmp/yazi.tar.gz" -C "$tmp"
find "$tmp" -name yazi -type f -exec cp {} "$BIN/yazi" \;
rm -rf "$tmp"

# yq
echo "Installing yq..."
case "$ARCH" in
    x86_64)  YQ_BIN="yq_linux_amd64" ;;
    aarch64) YQ_BIN="yq_linux_arm64" ;;
esac
YQ_URL=$(curl -fsSL https://api.github.com/repos/mikefarah/yq/releases/latest \
    | grep browser_download_url | grep "/${YQ_BIN}\"" | head -1 | cut -d'"' -f4)
curl -fsSL "$YQ_URL" -o "$BIN/yq"
chmod +x "$BIN/yq"

echo "RHEL install complete."
