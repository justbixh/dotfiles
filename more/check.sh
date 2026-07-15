#!/usr/bin/env bash
# check.sh — show install status of all tools

set -uo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

ok()      { echo -e "  ${GREEN}✔${RESET}  $1"; }
missing() { echo -e "  ${RED}✘${RESET}  $1"; }
section() { echo -e "\n${CYAN}${BOLD}── $1 ──────────────────────────────${RESET}"; }

# ── helpers ───────────────────────────────────────────────────────────────────

# Check by command name
has_cmd() { command -v "$1" &>/dev/null; }

# ── APT packages ──────────────────────────────────────────────────────────────
section "APT packages"

for cmd in git curl stow tmux btop jq ncdu vim xclip nvim; do
    if has_cmd "$cmd"; then ok "$cmd"; else missing "$cmd"; fi
done

# Ubuntu quirk: bat is batcat, fd is fdfind
if has_cmd bat || has_cmd batcat; then ok "bat (batcat)"; else missing "bat / batcat"; fi
if has_cmd fd  || has_cmd fdfind; then ok "fd (fdfind)";  else missing "fd / fdfind";  fi
if has_cmd rg;                    then ok "ripgrep (rg)"; else missing "ripgrep (rg)"; fi
if has_cmd yq;                    then ok "yq";           else missing "yq";           fi
if has_cmd dig;                   then ok "dnsutils (dig)"; else missing "dnsutils";   fi

# ── GitHub / script installs ──────────────────────────────────────────────────
section "GitHub / script installs"

for cmd in fzf eza delta lazygit yazi starship zoxide gh fastfetch atuin; do
    if has_cmd "$cmd"; then ok "$cmd"; else missing "$cmd"; fi
done

# ── zsh plugins (file-based, no command) ──────────────────────────────────────
section "zsh plugins"

ZSH_PLUGIN_DIR="$HOME/.config/zsh/plugins"

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [ -f "$ZSH_PLUGIN_DIR/${plugin}/${plugin}.plugin.zsh" ]; then
        ok "$plugin"
    else
        missing "$plugin"
    fi
done

if [ -d "$HOME/.fzf" ]; then ok "fzf shell integration (~/.fzf)"; else missing "fzf shell integration"; fi
if [ -f "$HOME/.config/fzf-git/fzf-git.sh" ]; then ok "fzf-git"; else missing "fzf-git"; fi

# ── summary ───────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}Done. Fix missing tools → see INSTALL.md${RESET}\n"