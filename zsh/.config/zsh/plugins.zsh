# --- Plugins - downloads and sources pluins from github -----------
# ~/.config/zsh/plugins.zsh

ZPLUGINDIR="$HOME/.config/zsh/plugins"

_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Installing ${2}..."
    git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
      || { echo "ERROR: failed to install ${2}" >&2; return 1; }
  fi
  source "${plugin_path}/${2}.plugin.zsh"
}

zplugin-update() {
  local dir
  for dir in "${ZPLUGINDIR}"/*/; do
    echo "Updating ${dir:t}..."
    git -C "$dir" pull --ff-only
  done
}

# ── zsh-autosuggestions key features ─────────────────────────────
#
# Ghost text         — shows suggestion from history as you type (grayed out)
# Accept full        — Right arrow or Ctrl+E to accept full suggestion
# Accept word        — Ctrl+Right to accept next word only
# Toggle             — Ctrl+\ to enable/disable (your binding)
# Strategy           — defaults to history, can add completion fallback
# Async              — suggestions fetched without blocking input
_zplugin_load zsh-users zsh-autosuggestions

# ── zsh-history-substring-search key features ────────────────────
#
# Prefix search      — Up/Down searches history by what you've already typed
# Fuzzy-ish          — finds the substring anywhere in the command
# Highlight match    — matched portion is highlighted in results
# Cycle through      — keep pressing Up/Down to cycle all matches
# Works with vi mode — bind to ^[[A/^[[B inside zvm_after_init
_zplugin_load zsh-users zsh-history-substring-search

# ── zsh-vi-mode key features ─────────────────────────────────────
#
# Cursor shape       — beam in insert, block in normal/visual (configurable)
# Mode switching     — Esc to normal, i/a/I/A to insert, v visual
# Text objects       — ciw, di", ca(, ya{ etc. work properly
# Surround           — ys, cs, ds to add/change/delete surrounding chars
# Better undo        — per-line undo history (bash-like behavior)
# zvm_after_init     — hook to re-register bindings after plugin init wipes them
# vi operators       — d, c, y, p, >, < all work with motions
# Increment/decrement — Ctrl+a / Ctrl+x on numbers in normal mode
# String motions     — W, B, E for WORD (whitespace-delimited) movement
# Insert mode paste  — Ctrl+r in insert mode to paste from register
_zplugin_load jeffreytse zsh-vi-mode

# ── zsh-syntax-highlighting key features ─────────────────────────
#
# Command highlight  — valid commands green, unknown/typos red
# Path highlight     — existing paths underlined, missing paths not
# String highlight   — quoted strings colored distinctly
# Bracket matching   — matching brackets highlighted on cursor
# Alias expansion    — aliases shown in distinct color
# Must load last     — wraps ZLE widgets; loading before others breaks them
_zplugin_load zsh-users zsh-syntax-highlighting # always last

# ── fast-syntax-highlighting key features ────────────────────────
#
# Everything in zsh-syntax-highlighting, plus:
# Themes             — built-in themes via `fast-theme`, unlike zsh-syntax-highlighting
# Chroma highlighters — language-aware highlighting inside $() git, make, awk etc.
# Secondary colors   — distinguishes flags, options, values with separate colors
# Correct cmdsubst   — highlights inside $(command substitution) properly
# Performance        — faster than zsh-syntax-highlighting on long lines
# Per-word coloring  — each word in a pipeline gets context-aware color
# `fast-theme -l`    — list available themes
# `fast-theme xyz`   — switch theme on the fly
# _zplugin_load zdharma-continuum fast-syntax-highlighting # always last