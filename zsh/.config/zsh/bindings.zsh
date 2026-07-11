# ── keybindings ──────────────────────────────────────────────────────────────────────
# ~/.config/zsh/bindings.zsh

[[ -n "$ZSH_VERSION" ]] || return

# Cursor shape per vi mode: Insert mode: beam (|) cursor; normal/visual: block cursor
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

# No background highlight when switching to normal mode
# ZVM_VI_HIGHLIGHT_BACKGROUND=none
# ZVM_VI_HIGHLIGHT_FOREGROUND=none
# ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

# zsh-vi-mode wipes all bindkeys on init — re-register everything here
zvm_after_init() {
  bindkey '^[[1;5C' forward-word                 # Ctrl+Right  — jump forward one word
  bindkey '^[[1;5D' backward-word                # Ctrl+Left   — jump backward one word  
  bindkey '^\' autosuggest-toggle                # Ctrl+\      — toggle inline autosuggestions
  bindkey '^[[A' history-substring-search-up     # Up          — history search by prefix typed so far
  bindkey '^[[B' history-substring-search-down   # Down        — history search by prefix typed so far

  zi-widget() { zi; zle reset-prompt; }
  zle -N zi-widget
  bindkey '^G' zi-widget                         # Ctrl+G      — zoxide interactive directory jump

  eval "$(atuin init zsh --disable-up-arrow)"    # Re-register atuin after zsh-vi-mode wipes everything


  # rebind after all plugins load, in case any plugin resets ^I
  bindkey '^I' fzf-completion
}
