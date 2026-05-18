# ── PATH — local bin first (our symlinks live here) ──────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── editor ────────────────────────────────────────────────────────────────────
export EDITOR=vim
export VISUAL=vim

# ── history ───────────────────────────────────────────────────────────────────
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTCONTROL=erasedups:ignoredups:ignorespace
shopt -s histappend
PROMPT_COMMAND='history -a'

# ── colored man pages ─────────────────────────────────────────────────────────
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# ── shell behaviour ───────────────────────────────────────────────────────────
shopt -s checkwinsize
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous On"
bind '"\C-f":"zi\n"'        # Ctrl+F → zoxide interactive jump
set -o vi

# ── bat ───────────────────────────────────────────────────────────────────────
alias cat='bat --style=grid'
alias catn='bat --style=numbers'
alias batp='bat --plain'

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

# ── ripgrep ───────────────────────────────────────────────────────────────────
alias grep='rg'
alias rgi='rg -i'
alias rgl='rg -l'
alias rgc='rg --count'
# todo rgf (interactive rg+fzf)

# ── lazygit ───────────────────────────────────────────────────────────────────
alias lg='lazygit'

# ── safety nets ───────────────────────────────────────────────────────────────
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ── navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── disk ──────────────────────────────────────────────────────────────────────
alias df='df -h'
alias du='du -h'
alias ducks='du -h --max-depth=1 | sort -rh | head -15'

# ── network ───────────────────────────────────────────────────────────────────
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

# ── misc ──────────────────────────────────────────────────────────────────────
alias reload='source ~/.bashrc'
alias bashrc='${EDITOR:-vi} ~/.bashrc'
alias countfiles='for t in files links directories; do echo $(find . -type ${t:0:1} | wc -l) $t; done'

# ── yazi: cd on quit ─────────────────────────────────────────────────────────
ya() {
    local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"
    cd "$(cat "$tmp")" 2>/dev/null
    rm -f "$tmp"
}

# ── rg + fzf → open in vim ───────────────────────────────────────────────────
rgf() {
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --color=always {1} --highlight-line {2}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind 'enter:become(vim {1} +{2})'
}

# ── fzf ───────────────────────────────────────────────────────────────────────
source ~/.config/fzf/fzf.bash

# ── zoxide ────────────────────────────────────────────────────────────────────
eval "$(zoxide init bash)"

# ── starship ──────────────────────────────────────────────────────────────────
eval "$(starship init bash)"

# ── local overrides (not in git: tokens, proxy, JAVA_HOME, work email) ────────
[ -f ~/.config/shell/local ] && source ~/.config/shell/local
