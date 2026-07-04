# ~/.config/bash/my.bashrc
# ── sourced from ~/.bashrc via: source ~/.config/bash/my.bashrc ───────────────

# ── PATH — local bin first (our symlinks live here) ───────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── editor ────────────────────────────────────────────────────────────────────
export EDITOR=vim
export VISUAL=vim
set -o vi # vi mode

# ── history ───────────────────────────────────────────────────────────────────
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTCONTROL=erasedups:ignoredups:ignorespace
export HISTTIMEFORMAT="%F %T "   # timestamp in history
# every command is flushed to disk right away, so other shells (or a crash recovery) can see it.
# atuin writes to its own SQLite db via bash-preexec on every command so this is not strictly necessary
[[ "$PROMPT_COMMAND" != *"history -a"* ]] && PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# ── options ───────────────────────────────────────────────────────────────────
set -o noclobber # refuces accidental file overwriting with `>`
shopt -s checkwinsize     # recheck terminal width after each command
shopt -s histappend       # append to history, don't overwrite
shopt -s autocd           # type a directory name to cd into it
shopt -s cdspell          # minor typo correction for cd
shopt -s dirspell         # typo correction during completion

bind "set completion-ignore-case on"   # case-insensitive tab completion
bind "set show-all-if-ambiguous On"    # single Tab shows all matches

# ── keybinds ──────────────────────────────────────────────────────────────────
bind '"\C-f":"zi\n"'                    # Ctrl+F → zoxide interactive jump
# bind "set enable-bracketed-paste On"  # uncomment if paste issues arise

# ── safety nets ───────────────────────────────────────────────────────────────
# alias rm='rm -i'
# alias rm=trash
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ── disk ──────────────────────────────────────────────────────────────────────
alias df='df -h'
alias du='du -h'
alias ducks='du -h --max-depth=1 | sort -rh | head -15'

# ── network ───────────────────────────────────────────────────────────────────
alias myip='curl -s ifconfig.me'
alias ports='ss -tulanp'
alias listening='ss -tulanp | grep LISTEN'

# ── navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias countfiles='for t in files links directories; do echo $(find . -type ${t:0:1} | wc -l) $t; done'
take() {
    mkdir -p "$1" && cd "$1"
}

# ── misc ──────────────────────────────────────────────────────────────────────
alias bashrc='vim ~/.bashrc'
alias mybash='vim ~/.config/bash/my.bashrc'
alias reload='source ~/.bashrc'

# ── git ───────────────────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gd='git diff'
alias gl='git log --graph --decorate -20'
alias glo='git log --oneline --graph --decorate -20'
alias gld="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias gundo='git reset HEAD~1'

# ── eza ───────────────────────────────────────────────────────────────────────
alias l='eza -l --icons --sort=modified'
alias sl='eza -lh --icons --sort=modified --color=always | tail -n 30'
alias la='eza -lha --icons --sort=modified'
alias lag='eza -lhag --icons --sort=modified'
alias lp='eza -lhg --icons --sort=modified --absolute=on'
alias lS='eza -lha --icons --sort=size --reverse'
alias ldate='eza -lhg --icons --time-style="+%d %b %Y %H:%M" --sort=modified'
alias ltreep='eza --tree --git-ignore --ignore-glob=".git"'
alias ltree='eza --tree --icons --git-ignore --ignore-glob=".git"'
alias ltree1='eza --tree --icons --git-ignore --ignore-glob=".git" --level=1'
alias ltree2='eza --tree --icons --git-ignore --ignore-glob=".git" --level=2'
alias ltree3='eza --tree --icons --git-ignore --ignore-glob=".git" --level=3'
alias lf='eza -lhg --icons --sort=modified --only-files'
alias ld='eza -lhgD --icons --sort=modified'

# ── bat ───────────────────────────────────────────────────────────────────────
alias cat='bat --style=grid'
alias catn='bat --style=numbers'
alias batp='bat --plain'         # plain, no decorations (good for copy-paste)
export BAT_THEME="Dracula"  # bat theme (used by bat, delta, fzf previews)

# ── ripgrep ───────────────────────────────────────────────────────────────────
# NOTE: not aliasing grep=rg — too many scripts rely on grep's specific flags
alias rgi='rg -i'
alias rgl='rg -l'
alias rgc='rg --count'
# rgf (interactive rg+fzf) see .config/fzf.sh

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

# ── zoxide ────────────────────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# ── zoxide interactive jump (zi) ─────────────────────────────────
_zi_widget() {
    zi
    PS1="$PS1"   # force prompt redraw
}
bind -x '"\C-f": _zi_widget'

# ── sub configs ───────────────────────────────────────────────────────────────
[ -f ~/.config/fzf/fzf.sh ] && source ~/.config/fzf/fzf.sh

# ── atuin ─────────────────────────────────────────────────────────────────────
. "$HOME/.atuin/bin/env"
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# ── starship - Starship needs to be the last thing touching the prompt ────────
command -v starship &>/dev/null && eval "$(starship init bash)"

# ── local overrides (not in git: tokens, proxy, JAVA_HOME, work email) ────────
# [ -f ~/.config/shell/local ] && source ~/.config/shell/local
