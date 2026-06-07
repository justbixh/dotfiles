# ── Zsh dotfile — sourced from ~/.zshrc ──────────────────────────────
# ~/.config/zsh/my.zshrc

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── editor ────────────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ── history ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY         # Append new history lines to the history file immediately, rather than waiting for the shell to exit
setopt SHARE_HISTORY          # Share history across all open terminal sessions in real-time
setopt HIST_IGNORE_ALL_DUPS   # If a new command duplicates an older one, remove the older one from history completely
setopt HIST_IGNORE_DUPS       # Don't save a command to the history file if it matches the previous one
setopt HIST_IGNORE_SPACE      # Do not record lines in the history that begin with a space character
setopt HIST_VERIFY            # don't execute expanded history immediately
setopt HIST_EXPIRE_DUPS_FIRST # If the history file fills up, oldest duplicate commands are deleted first
setopt HIST_FIND_NO_DUPS      # Do not display a line in history searches if it has already been encountered

# ── shell options ─────────────────────────────────────────────────────────────
setopt AUTO_CD                # Automatically 'cd' into a directory if you type just the directory name
setopt NO_BEEP                # Disable annoying audio beeps/bell sounds on errors or tab-completion failures
setopt CORRECT                # command name typo correction
setopt CORRECT_ALL            # arguments/filenames in a command
setopt NUMERIC_GLOB_SORT      # sort file10 after file9, not after file1

# ── completion ────────────────────────────────────────────────────────────────
# source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# plugins.zsh already handles plugin sourcing --- IGNORE ---

# navigable menu where while completions you can move through options with arrow keys and select with Enter.
# zstyle ':completion:*' menu select

# Example: "doc" can complete to "Documents"
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # lowercase input matches upper and lower

# ── misc ──────────────────────────────────────────────────────────────────────
alias zshrc='nvim ~/.zshrc'
alias myzsh='nvim ~/.config/zsh/my.zshrc'
alias reload='exec zsh -l'

# ── safety nets ───────────────────────────────────────────────────────────────
# alias rm='rm -i'
# alias rm=trash
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ── navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias countfiles='for t in files links directories; do echo $(find . -type ${t:0:1} | wc -l) $t; done'
function take { mkdir -p "$1"; cd "$1"; }

# ── disk / network ────────────────────────────────────────────────────────────
alias df='df -h'
alias du='du -h'
alias ducks='du -h --max-depth=1 | sort -rh | head -15'
alias myip='curl -s ifconfig.me'
alias ports='ss -tulanp'
alias listening='ss -tulanp | grep LISTEN'

# ── git ───────────────────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git log --graph --decorate -20'
alias glo='git log --oneline --graph --decorate -20'
alias gld="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias gd='git diff'
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
alias batp='bat --plain'

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

# ── zoxide ────────────────────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ── starship ──────────────────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── atuin ─────────────────────────────────────────────────────────────────────
# override default Ctrl+R history and fzf search with atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# ── sub configs ───────────────────────────────────────────────────────────────
source ~/.config/fzf/fzf.sh
source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/bindings.zsh

# ── local overrides (not in git: tokens, proxy, JAVA_HOME, work email) ────────
# [ -f ~/.config/shell/local ] && source ~/.config/shell/local
