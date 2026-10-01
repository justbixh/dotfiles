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

# ── zsh-autosuggestions ───────────────────────────────────────────
# Ghost text         — shows suggestion from history as you type (grayed out)
# Accept full        — Right arrow or Ctrl+E to accept full suggestion
# Accept word        — Ctrl+Right to accept next word only
# Toggle             — Ctrl+\ to enable/disable (your binding)
# Strategy           — defaults to history, can add completion fallback
# Async              — suggestions fetched without blocking input
_zplugin_load zsh-users zsh-autosuggestions

# ── zsh-history-substring-search ─────────────────────────────────
# Prefix search      — Up/Down searches history by what you've already typed
# Fuzzy-ish          — finds the substring anywhere in the command
# Highlight match    — matched portion is highlighted in results
# Cycle through      — keep pressing Up/Down to cycle all matches
# Works with vi mode — bind to ^[[A/^[[B inside zvm_after_init
_zplugin_load zsh-users zsh-history-substring-search

# ── zsh-vi-mode ───────────────────────────────────────────────────
# Cursor shape        — beam in insert, block in normal/visual (configurable)
# Mode switching      — Esc to normal, i/a/I/A to insert, v for visual
# Text objects        — ciw, di", ca(, ya{ etc. work properly
# Surround            — ys, cs, ds to add/change/delete surrounding chars
# Better undo         — per-line undo history (bash-like behavior)
# zvm_after_init      — hook to re-register bindings after plugin init wipes them
# vi operators        — d, c, y, p, >, < all work with motions
# Increment/decrement — Ctrl+a / Ctrl+x on numbers in normal mode
# String motions      — W, B, E for WORD (whitespace-delimited) movement
# Insert mode paste   — Ctrl+r in insert mode to paste from register
_zplugin_load jeffreytse zsh-vi-mode

# ── zsh-syntax-highlighting ───────────────────────────────────────
# Command highlight  — valid commands green, unknown/typos red
# Path highlight     — existing paths underlined, missing paths not
# String highlight   — quoted strings colored distinctly
# Bracket matching   — matching brackets highlighted on cursor
# Alias expansion    — aliases shown in distinct color
# Must load last     — wraps ZLE widgets; loading before others breaks them

# Skip highlighting very long command lines for responsiveness.
# Syntax highlighting now skips lines longer than 512 characters, which may prevent its redraw hook from stalling rapid b motions on long commands. 
ZSH_HIGHLIGHT_MAXLENGTH=512

_zplugin_load zsh-users zsh-syntax-highlighting # always last