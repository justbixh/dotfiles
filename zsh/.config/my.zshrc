### gc2j
### ~/.zshrc
### ── managed by stow (dotfiles/.zshrc) ────────────────────────────────────

# ~/.config/my.zshrc
# ── Zsh-specific dotfile — sourced from ~/.zshrc ──────────────────────────────
# This file is managed by stow (dotfiles/zsh/.config/my.zshrc).

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── editor ────────────────────────────────────────────────────────────────────
export EDITOR=vim
export VISUAL=vim

# ── history ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY          # share history across sessions
setopt APPEND_HISTORY
setopt HIST_VERIFY            # don't execute expanded history immediately

# ── coloured man pages ────────────────────────────────────────────────────────
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# ── shell options ─────────────────────────────────────────────────────────────
setopt AUTO_CD                # bare directory → cd
setopt CORRECT                # command typo correction
setopt CORRECT_ALL            # argument typo correction
setopt NO_BEEP

# ── completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── vi mode ───────────────────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1

# ── keybinds ──────────────────────────────────────────────────────────────────
bindkey '^F' autosuggest-accept 2>/dev/null || true   # Ctrl+F → zoxide jump (same as bash)
# bindkey '^F' 'zi\n'          # Ctrl+F → zoxide interactive jump (like bash)
zle -N zi-widget() { zi; zle reset-prompt; } 2>/dev/null
bindkey '^F' zi-widget 2>/dev/null || true
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ── misc ──────────────────────────────────────────────────────────────────────
alias myzshrc='vim ~/.config/my.zshrc'
alias zshrc='vim ~/.zshrc'
alias reload='exec zsh -l'

# ── safety nets ───────────────────────────────────────────────────────────────
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ── navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias countfiles='for t in files links directories; do echo $(find . -type ${t:0:1} | wc -l) $t; done'

# ── disk / network ────────────────────────────────────────────────────────────
alias df='df -h'
alias du='du -h'
alias ducks='du -h --max-depth=1 | sort -rh | head -15'
alias myip='curl -s ifconfig.me'
alias ports='ss -tulanp'
alias listening='ss -tulanp | grep LISTEN'

# ── git ───────────────────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --graph --decorate -20'
alias gl1='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gundo='git reset HEAD~1'

# ── eza ───────────────────────────────────────────────────────────────────────
alias l='eza -lhg --icons --sort=modified'
alias ll='eza -lhg --icons --sort=modified --color=always | tail -n 30'
alias la='eza -lhga --icons --sort=modified'
alias lp='eza -lhg --icons --sort=modified --absolute=on'
alias lS='eza -lhga --icons --sort=size --reverse'
alias ltree='eza --tree --icons'
alias ltree2='eza --tree --icons --level=2'
alias ldate='eza -lhg --icons --time-style="+%d %b %Y %H:%M" --sort=modified'
alias lf='eza -lhg --icons --sort=modified --only-files'
alias ld='eza -lhgD --icons --sort=modified'

# ── bat ───────────────────────────────────────────────────────────────────────
alias cat='bat --style=grid'
alias catn='bat --style=numbers'
alias batp='bat --plain'
export BAT_THEME="Dracula"

# ── ripgrep ───────────────────────────────────────────────────────────────────
alias rgi='rg -i'
alias rgl='rg -l'
alias rgc='rg --count'

# ── lazygit ───────────────────────────────────────────────────────────────────
alias lg='lazygit'

# ── yazi: cd on quit ──────────────────────────────────────────────────────────
ya() {
    local tmp
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"
    if [ -s "$tmp" ]; then cd "$(cat "$tmp")" || true; fi
    rm -f "$tmp"
}

# ── fzf ───────────────────────────────────────────────────────────────────────
[ -f ~/.config/fzf.sh ] && source ~/.config/fzf.sh

# ── zoxide ────────────────────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ── starship ──────────────────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── local overrides (not in git: tokens, proxy, JAVA_HOME, work email) ────────
[ -f ~/.config/shell/local ] && source ~/.config/shell/local
