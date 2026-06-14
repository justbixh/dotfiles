# ── Zsh dotfile — sourced from ~/.zshrc ──────────────────────────
# ~/.config/zsh/my.zshrc

# ── PATH ─────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── editor ───────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ── history ──────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY         # Append new history lines immediately, not on shell exit
setopt SHARE_HISTORY          # Share history across all open terminal sessions in real-time
setopt HIST_IGNORE_ALL_DUPS   # If a new command duplicates an older one, remove the older one
setopt HIST_IGNORE_DUPS       # Don't save a command if it matches the previous one
setopt HIST_IGNORE_SPACE      # Don't record lines that begin with a space
setopt HIST_VERIFY            # Don't execute expanded history immediately — show it first
setopt HIST_EXPIRE_DUPS_FIRST # When history fills up, delete oldest duplicates first
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching history

# ── shell options ─────────────────────────────────────────────────
setopt AUTO_CD                # Type a directory name alone to cd into it
setopt NO_BEEP                # Disable audio beeps on errors or tab-completion failures
setopt CORRECT                # Suggest corrections for mistyped command names
setopt CORRECT_ALL            # Suggest corrections for arguments and filenames too
setopt NUMERIC_GLOB_SORT      # Sort file10 after file9, not after file1

# ── completion ────────────────────────────────────────────────────
# zstyle settings are read when compinit runs (inside plugins.zsh below)
# Set them here first so they're ready when compinit scans $fpath

zstyle ':completion:*' menu select                        # Arrow-key navigable menu — Tab opens, arrows move, Enter selects
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Color files and dirs in the menu using $LS_COLORS (same as ls)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'    # Case-insensitive: "doc" matches "Documents"
zstyle ':completion:*' descriptions format '[%d]'         # Group label above each section e.g. [commands] [options]

# ── misc ──────────────────────────────────────────────────────────
alias zshrc='nvim ~/.zshrc'
alias myzsh='nvim ~/.config/zsh/my.zshrc'
alias reload='exec zsh -l'

# ── safety nets ───────────────────────────────────────────────────
# alias rm='rm -i'
# alias rm=trash
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ── navigation ────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias countfiles='for t in files links directories; do echo $(find . -type ${t:0:1} | wc -l) $t; done'
function take { mkdir -p "$1"; cd "$1"; }

# ── disk / network ────────────────────────────────────────────────
alias df='df -h'
alias du='du -h'
alias ducks='du -h --max-depth=1 | sort -rh | head -15'
alias myip='curl -s ifconfig.me'
alias ports='ss -tulanp'
alias listening='ss -tulanp | grep LISTEN'

# ── git ───────────────────────────────────────────────────────────
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gcm='git commit -m'
alias gcam='git commit --amend -m'      # --amend always targets HEAD
alias gp='git push'
alias gl='git log --graph --decorate -20'
alias glo='git log --oneline --graph --decorate -20'
alias gss='git show --stat --graph --decorate -20'
alias gd='git diff'
alias gds='git diff --staged'
alias gundo='git reset HEAD~1'
# git restore --staged FILENAME

# ── eza ───────────────────────────────────────────────────────────
alias l='eza -l --icons --sort=modified'
alias sl='eza -lh --icons --sort=modified --color=always | tail -n 30'
alias la='eza -lha --icons --sort=modified'
alias lag='eza -lhag --icons --sort=modified'
alias lp='eza -lhg --icons --sort=modified --absolute=on'
alias lS='eza -lha --icons --sort=size --reverse'
alias ldate='eza -lhg --icons --time-style="+%d %b %Y %H:%M" --sort=modified'
alias ltree='eza --tree --icons --git-ignore --ignore-glob=".git"'
ltreel() { eza --tree --icons --git-ignore --ignore-glob=".git" --level="$1"; }
ltreep() { eza --tree --git-ignore --ignore-glob=".git" --level="$1"; }
alias lf='eza -lhg --icons --sort=modified --only-files'
alias ld='eza -lhgD --icons --sort=modified'

# ── bat ───────────────────────────────────────────────────────────
alias cat='bat --style=grid'
alias catn='bat --style=numbers'
alias batp='bat --plain'

# ── ripgrep ───────────────────────────────────────────────────────
alias rgi='rg -i'
alias rgl='rg -l'
alias rgc='rg --count'

# ── lazygit ───────────────────────────────────────────────────────
alias lg='lazygit'

# ── yazi: cd on quit ──────────────────────────────────────────────
ya() {
    local tmp
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"
    if [ -s "$tmp" ]; then cd "$(cat "$tmp")" || true; fi
    rm -f "$tmp"
}

# ── zoxide ────────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ── starship ──────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── atuin ─────────────────────────────────────────────────────────
# Overrides default Ctrl+R and fzf history search with atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# ── sub configs ───────────────────────────────────────────────────
source ~/.config/fzf/fzf.sh
source ~/.config/zsh/plugins.zsh  
source ~/.config/zsh/bindings.zsh

# ── tool completions ──────────────────────────────────────────────
# Not from zsh-completions — each tool generates its own script from its binary at runtime
# source <(...) calls compdef internally — needs compinit already run (inside plugins.zsh) - must come after plugins.zsh
command -v kubectl       &>/dev/null && source <(kubectl completion zsh)   # kubectl get <Tab>, kubectl --<Tab>
command -v docker        &>/dev/null && source <(docker completion zsh)    # docker run <Tab>, docker ps <Tab>
command -v aws_completer &>/dev/null && complete -C aws_completer aws      # aws s3 <Tab>, aws ec2 <Tab>

# ── local overrides (not in git: tokens, proxy, JAVA_HOME, work email) ───
# [ -f ~/.config/shell/local ] && source ~/.config/shell/local
