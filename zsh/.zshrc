# ~/.zshrc

# ── PATH ─────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"
command -v nerdfetch &> /dev/null && nerdfetch

# ── editor ───────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL="${EDITOR}"
export SUDO_EDITOR=nvim
alias v='$EDITOR'
alias vi='$EDITOR'
alias c='clear'
alias vv='fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs $EDITOR' # tmux popup nvim https://youtube.com/shorts/K1FxGIG_lcA?si=TpBDYrRDQ6BE2lrR

# ── pager ────────────────────────────────────────────────────────
export PAGER=less
export LESS='-R -F --no-init'
# -R         → pass ANSI color codes through (needed for bat, git diff, man)
# -F         → quit immediately if output fits on one screen (like cat)
# --no-init  → don't clear screen on exit (less jarring)

export MANPAGER='sh -c "col -bx | bat --language=man --style=plain --paging=always"'
export MANROFFOPT='-c'   # prevents col from getting raw troff codes

# ── history ──────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt noclobber              # guards against accidental file overwriting from `>`
setopt append_history         # Append new history lines immediately, not on shell exit
setopt share_history          # Share history across all open terminal sessions in real-time
setopt hist_ignore_all_dups   # If a new command duplicates an older one, remove the older one
setopt hist_ignore_dups       # Don't save a command if it matches the previous one
setopt hist_ignore_space      # Don't record lines that begin with a space
setopt hist_verify            # Don't execute expanded history immediately — show it first
setopt hist_expire_dups_first # When history fills up, delete oldest duplicates first
setopt hist_find_no_dups      # Don't show duplicates when searching history
HISTORY_IGNORE='(rm *|rf *)'

# ── shell options ─────────────────────────────────────────────────
setopt auto_cd                # Type a directory name alone to cd into it
setopt no_beep                # Disable audio beeps on errors or tab-completion failures
# setopt correct                # Suggest corrections for mistyped command names
# setopt correct_all            # Suggest corrections for arguments and filenames too
setopt numeric_glob_sort      # Sort file10 after file9, not after file1
setopt glob_dots  # include dotfiles into completion by default

# ── completion ────────────────────────────────────────────────────
# zstyle settings are read when compinit runs (inside zsh/plugins.zsh)
# Set them here first so they're ready when compinit scans $fpath
# continuation after dotfiles/zsh/.config/zsh/plugins.zsh

zstyle ':completion:*' menu select                        # Arrow-key navigable menu — Tab opens, arrows move, Enter selects
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Color files and dirs in the menu using $LS_COLORS (same as ls)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'    # Case-insensitive: "doc" matches "Documents"
zstyle ':completion:*' descriptions format '[%d]'         # Group label above each section e.g. [commands] [options]

zstyle ':completion:*' file-sort modification  # show recently used files first
zstyle ':completion:*' list-dirs-first yes
zstyle ':completion:*' ignored-patterns '.git'
zstyle ':completion:*' rehash false  # improves performance
zstyle ':completion:*' use-cache true

# ── keybindings ────────────────────────────────────────────────────
# Cursor shape per vi mode: Insert mode: beam (|) cursor; normal/visual: block cursor
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj   # jj → vi normal mode (like Esc)
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

# zsh-vi-mode wipes all bindkeys on init — re-register everything here.
# This is a hook function: must be *defined* before plugins.zsh sources
# zsh-vi-mode below, but zsh-vi-mode itself calls it after its own init finishes —
# so placement here (before sourcing) is required, exact position otherwise doesn't matter.
zvm_after_init() {
  bindkey '^[[1;5C' forward-word                 # Ctrl+Right  — jump forward one word
  bindkey '^[[1;5D' backward-word                # Ctrl+Left   — jump backward one word
  bindkey '^\' autosuggest-toggle                # Ctrl+\      — toggle inline autosuggestions
  bindkey '^[[A' history-substring-search-up     # Up          — history search by prefix typed so far
  bindkey '^[[B' history-substring-search-down   # Down        — history search by prefix typed so far

  zi-widget() { zi; zle reset-prompt; }
  zle -N zi-widget
  bindkey '^G' zi-widget                         # Ctrl+G      — zoxide interactive directory jump

  # re-registered here because zsh-vi-mode overrides atuin's keybindings on init
  eval "$(atuin init zsh --disable-up-arrow)"

  # rebind after all plugins load, in case any plugin resets ^I
  bindkey '^I' fzf-completion
}

bindkey '^e' autosuggest-accept 

# ── misc ──────────────────────────────────────────────────────────
alias zshrc='$EDITOR ~/.zshrc'
alias reload='exec zsh -l'

# ── safety nets ───────────────────────────────────────────────────
# alias rm='rm -i'
# alias rm=trash
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ── navigation ────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias countfiles='for t in files links directories; do echo $(find . -type ${t:0:1} | wc -l) $t; done'

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
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gcam='git commit --amend -m'      # --amend always targets HEAD
alias gp='git push'
alias gl='git log --graph --decorate'
alias glo='git log --oneline --graph --decorate'
alias glot="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias gss='git show --stat --graph --decorate -20'
alias gd='git diff -w'
alias gds='git diff --staged -w'
alias gundo='git reset HEAD~1'
# git restore --staged FILENAME

# ── tmux ───────────────────────────────────────────────────────────
alias t="tmux"
alias tl="tmux ls"
alias ta="tmux attach -t"
alias tk="tmux kill-session -t"
alias tks="tmux kill-server"
alias tlk="tmux list-keys"

# session switcher from outside tmux
tt() {
  local session
  session=$(tmux ls -F '#S' 2>/dev/null | fzf-tmux -w 40 -h 12% --reverse) && tmux new -As "$session"
}

tt() {
  if [ -n "$TMUX" ]; then
    echo "Already inside tmux — use your session switcher/prefix binding instead."
    return 1
  fi

  local session
  session=$(tmux ls -F '#S' 2>/dev/null | COLUMNS=40 fzf --height=~40% --reverse)
  [ -z "$session" ] && return

  tmux new -As "$session"
}

# ── system ─────────────────────────────────────────────────────────
alias sys='sudo systemctl'
alias scs='systemctl status'
alias scr='sudo systemctl restart'
alias sca='sudo systemctl start'
alias sck='sudo systemctl stop'
alias sce='sudo systemctl enable'
alias scd='sudo systemctl disable'
alias scrl='sudo systemctl reload'
alias scdr='sudo systemctl daemon-reload'

alias scls='systemctl list-units --type=service'
alias sclsa='systemctl list-units --type=service --all'
alias scf='systemctl list-unit-files --type=service'
alias scrf='sudo systemctl reset-failed'

alias jc='sudo journalctl'
alias jcu='sudo journalctl -u'          # jcu <unit>
alias jcf='sudo journalctl -f -u'       # jcf <unit> -> follow logs
alias jce='sudo journalctl -u --since today'

screstart() {
  sudo systemctl restart "$1" && sudo journalctl -u "$1" -f
}

scstatusall() {
  for svc in "$@"; do
    echo "── $svc ──"
    systemctl status "$svc" --no-pager -l | head -n 5
    echo
  done
}

# ── docker ─────────────────────────────────────────────────────────
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# ── kubernetes ─────────────────────────────────────────────────────
export KUBECONFIG=~/.kube/config
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kgpo="kubectl get pod"
alias kgd="kubectl get deployments"
alias kc="kubectx"
alias kns="kubens"
alias kl="kubectl logs -f"
alias ke="kubectl exec -it"
alias kcns='kubectl config set-context --current --namespace'

# ── eza ───────────────────────────────────────────────────────────
alias l='eza -l --icons --sort=modified --git'
alias tree='l --tree'
alias sl='eza -l --icons --sort=modified --git --color=always | tail -n 30'
alias la='eza -la --icons --sort=modified --git'
alias lag='eza -lhag --icons --sort=modified --git'
alias lp='eza -lhg --icons --sort=modified --git --absolute=on'
alias lS='eza -lha --icons --sort=size --reverse'
alias lt='eza -lh --icons --sort=type'
alias ldate='eza -lhg --icons --time-style="+%d %b %Y %H:%M" --sort=modified'
alias lf='eza -lhg --icons --sort=modified --only-files'
alias ld='eza -lhgD --icons --sort=modified'

alias ltree='eza --tree --group-directories-first --icons --git-ignore --ignore-glob=".git"'
alias ltreea='ltree -a'
ltreel()  { ltree --level="$1" }
ltreeal() { ltreea --level="$1" }
ltreelp()  { eza --tree --group-directories-first --git-ignore --ignore-glob=".git" --level="${1:-2}" }
ltreealp() { eza --tree --group-directories-first --git-ignore --ignore-glob=".git" -a --level="${1:-2}" }

# ── bat ───────────────────────────────────────────────────────────
alias cat='bat'
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
export STARSHIP_CONFIG=~/.config/starship/starship.toml
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── atuin ─────────────────────────────────────────────────────────
# Overrides default Ctrl+R and fzf history search with atuin
if [[ -f "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
  command -v atuin &>/dev/null && eval "$(atuin init zsh)"
fi # re-registers shortcuts in binding.zsh, cause plugins.zsh-vi-mode overrides atuin keybindings
# to remove atuin: delete this block + the `eval atuin init` line in zvm_after_init(), then `rm -rf ~/.atuin` (or `brew uninstall atuin`)

# ── sub configs ───────────────────────────────────────────────────
[[ -f ~/.config/fzf/fzf.sh ]]        && source ~/.config/fzf/fzf.sh
[[ -f ~/.config/zsh/plugins.zsh  ]]  && source ~/.config/zsh/plugins.zsh  
# [[ -f ~/.config/zsh/bindings.zsh ]]  && source ~/.config/zsh/bindings.zsh
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh

# ── tool completions ──────────────────────────────────────────────
# Not from zsh-completions — each tool generates its own script from its binary at runtime
# source <(...) calls compdef internally — needs compinit already run (inside plugins.zsh) - must come after plugins.zsh
command -v kubectl       &>/dev/null && source <(kubectl completion zsh)   # kubectl get <Tab>, kubectl --<Tab>
command -v docker        &>/dev/null && source <(docker completion zsh)    # docker run <Tab>, docker ps <Tab>
command -v aws_completer &>/dev/null && complete -C aws_completer aws      # aws s3 <Tab>, aws ec2 <Tab>

# ── local overrides ───
[[ -f ~/.local.zshrc ]] && source ~/.local.zshrc
