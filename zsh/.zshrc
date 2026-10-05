# ~/.zshrc
setopt noclobber              # guards against accidental file overwriting from `>`

# ── PATH ─────────────────────────────────────────────────────────
typeset -U path PATH # keep PATH free of duplicates
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# ── editor and pager ─────────────────────────────────────────────
export EDITOR=nvim
export VISUAL="${EDITOR}"
export SUDO_EDITOR="${EDITOR}"

export PAGER=less
export LESS='-R -F --no-init'
export MANPAGER='sh -c "col -bx | bat --language=man --style=plain --paging=always"'
export MANROFFOPT='-c' 

alias vi='$EDITOR'
alias vv='fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs $EDITOR' 

# ── history ──────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTORY_IGNORE='(rm *|rf *)'

setopt share_history          # share history across sessions in real time 
setopt hist_ignore_all_dups   # a repeated command removes its older copy, so the newest run stays on top
setopt hist_ignore_space      # don't record lines that begin with a space
setopt hist_verify            # show expanded history (e.g. !!) before executing it

# ── shell options ─────────────────────────────────────────────────
setopt auto_cd                # typing a directory name alone cds into it
setopt no_beep                # no beeps on errors or completion failures
setopt numeric_glob_sort      # sort file10 after file9, not after file1
setopt glob_dots              # include dotfiles in globs and completions

# ── completion ────────────────────────────────────────────────────
# zstyle settings are read when compinit runs (in ~/.config/zsh/plugins.zsh),
# so they are set here first, before compinit scans $fpath.
zstyle ':completion:*' menu select                        # arrow-key menu: Tab opens, arrows move, Enter selects
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # color menu entries like ls
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'    # case-insensitive: "doc" matches "Documents"
zstyle ':completion:*' descriptions format '[%d]'         # group labels, e.g. [commands] [options]
zstyle ':completion:*' file-sort modification             # recently modified files first
zstyle ':completion:*' list-dirs-first yes
zstyle ':completion:*' ignored-patterns '.git'
zstyle ':completion:*' rehash false                       # better performance
zstyle ':completion:*' use-cache true

# ── vi mode and keybindings ─────────────────────────────────────────────────
# zsh-vi-mode (sourced from ~/.config/zsh/plugins.zsh) wipes all bindkeys on init.
# zvm_config and zvm_after_init are hooks it calls itself, so they only need
# to be defined before the plugin is sourced (see "sub configs" at the bottom).

# runs after the plugin defines its constants, so $ZVM_CURSOR_* are available
zvm_config() {
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jj             # jj → vi normal mode (like Esc)
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM     # insert: beam cursor
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK    # normal: block cursor
  ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK    # visual: block cursor
}

# runs after the plugin finishes init, so everything is re-registered here
zvm_after_init() {
  bindkey '^L' clear-screen                     # Ctrl+L: clear screen (overridden by zsh-vi-mode)
  bindkey '^[[1;5C' forward-word                # Ctrl+Right: forward one word
  bindkey '^[[1;5D' backward-word               # Ctrl+Left: backward one word
  bindkey '^e' autosuggest-accept               # Ctrl+E: accept autosuggestion
  bindkey '^\' autosuggest-toggle               # Ctrl+\: toggle autosuggestions
  bindkey '^[[A' history-substring-search-up    # Up: history search by prefix typed so far
  bindkey '^[[B' history-substring-search-down  # Down: history search by prefix typed so far
  
  bindkey '^P' ff-widget                        # Ctrl+P: find a file and open it in tmux
  bindkey '^O' fo-widget                        # Ctrl+O: choose a folder and open it in tmux
  bindkey '^T' fzf-file-widget                   # Ctrl+T: insert a selected file path
  bindkey '^[c' fzf-cd-widget                    # Alt+C: change to a selected directory

  # Ctrl+G: zoxide interactive jump
  zi-widget() { zi; zle reset-prompt; }
  zle -N zi-widget
  bindkey '^G' zi-widget                       

  # atuin keybindings are overridden by zsh-vi-mode, so register them again
  eval "$(atuin init zsh --disable-up-arrow)"

  # rebind after all plugins load, in case any plugin resets ^I
  # so typing a completion trigger such as ** and pressing Tab opens fzf’s fuzzy picker.
  bindkey '^I' fzf-completion
}

# ── misc ──────────────────────────────────────────────────────────
alias zshrc='$EDITOR ~/.zshrc'
alias reload='exec zsh -l'

# ── safety nets ───────────────────────────────────────────────────
alias cp='cp -i'
alias mv='mv -i'

# macOS only: move files to the Trash instead of deleting them; install: brew install trash
if [[ "$OSTYPE" == darwin* ]] && (( $+commands[trash] )); then
  alias rm='trash'
fi

# ── navigation and quality of life ────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias countfiles='for t in files links directories; do echo $(find . -type ${t:0:1} | wc -l) $t; done'
alias path='echo $PATH | tr ":" "\n"'

# ── disk and network ──────────────────────────────────────────────
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
alias gap='git add .'

alias gcm='git commit -m'
alias gce='git commit --amend'
alias gca='git commit --amend --no-edit'      # fold staged changes into last commit
alias gcr='git commit --amend --only'         # edit last commit message only
alias gunamend='git reset --soft "HEAD@{1}"'  # undo a bad amend (run right after)
alias gcam='git commit --amend -m'     --amend always targets HEAD

alias gp='git pull'
alias gl='git log --graph --decorate'
alias glo='git log --oneline --graph --decorate'
alias glot="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias gss='git show --stat --graph --decorate -20'
alias gd='git diff -w'
alias gds='git diff --staged -w'
alias gundo='git reset HEAD~1'
# git restore --staged FILENAME
alias lg='lazygit'
alias grs='git restore --staged'

# Conflicts (ours/theirs are swapped during a rebase) 
alias gconflicts='git diff --name-only --diff-filter=U'
gours()   { git checkout --ours -- "$@" && git add -- "$@" }
gtheirs() { git checkout --theirs -- "$@" && git add -- "$@" }
gconfedit() {
  local files=("${(@f)$(git diff --name-only --diff-filter=U)}")
  [[ -n "$files[1]" ]] && ${EDITOR:-vim} "${files[@]}"
}

# glf: browse log with diff preview
glf() {
  git log --oneline --color=always \
    | fzf --ansi --no-sort --reverse --preview 'git show --color=always {1}' --preview-window=right:60%
}

# ── tmux ───────────────────────────────────────────────────────────
alias t='tmux'
alias tl='tmux ls'
alias tn='tmux new-session -s'
alias ta='tmux attach -t'
alias tk='tmux kill-session -t'
alias tka='tmux kill-server'
alias tlk='tmux list-keys'
alias tm='tmux new-session -A -s main'

# session switcher from outside tmux
tt() {
  local session
  session=$(tmux ls -F '#S' 2>/dev/null | fzf-tmux -w 40 -h 12% --reverse) && tmux new -As "$session"
}

# ── systemd and journal ────────────────────────────────────────────
alias sy='sudo systemctl'
alias sys='sudo systemctl start'
alias syk='sudo systemctl stop'
alias syr='sudo systemctl reload'
alias syre='sudo systemctl restart'
alias syst='systemctl status'
alias syen='sudo systemctl enable'
alias syd='sudo systemctl disable'
alias sydr='sudo systemctl daemon-reload'
alias syrf='sudo systemctl reset-failed'

alias syls='systemctl list-units --type=service'
alias sylsa='systemctl list-units --type=service --all'
alias sylf='systemctl list-units --state=failed'
alias syf='systemctl list-unit-files --type=service'

alias j='sudo journalctl'
alias ju='sudo journalctl -u'
alias juf='sudo journalctl -f -u' 

# restart a service, then follow its logs
syrt() {
  sudo systemctl restart "$1" && sudo journalctl -u "$1" -f
}

# ── docker ─────────────────────────────────────────────────────────
alias dco='docker compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias dl='docker ps -l -q'
alias dx='docker exec -it'

# ── kubernetes ─────────────────────────────────────────────────────
export KUBECONFIG=~/.kube/config
alias k='kubectl'
alias ka='kubectl apply -f'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kgpo='kubectl get pod'
alias kgd='kubectl get deployments'
alias kl='kubectl logs -f'
alias ke='kubectl exec -it'
alias kc='kubectx'
alias kns='kubens'
alias kcns='kubectl config set-context --current --namespace'

# ── eza ───────────────────────────────────────────────────────────
alias lls='eza --icons'
alias ll='eza -l --icons --git'
alias l='eza -l --icons --sort=modified --git'
alias la='eza -la --icons --sort=modified --git'
alias lag='eza -lhag --icons --sort=modified --git'
alias lp='eza -lhg --icons --sort=modified --git --absolute=on'
alias lS='eza -lha --icons --sort=size --reverse'
alias lt='eza -lh --icons --sort=type'
alias lf='eza -lhg --icons --sort=modified --only-files'
alias ld='eza -lhgD --icons --sort=modified'
alias ldate='eza -lhg --icons --time-style="+%d %b %Y %H:%M" --sort=modified'
alias sl='eza -l --icons --sort=modified --git --color=always | tail -n 30'
alias tree='l --tree'

alias ltree='eza --tree --group-directories-first --icons --git-ignore --ignore-glob=".git"'
alias ltreea='ltree -a'
ltreel()   { ltree --level="$1" }
ltreeal()  { ltreea --level="$1" }
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

# ── zoxide ────────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ── starship ──────────────────────────────────────────────────────
export STARSHIP_CONFIG=~/.config/starship/starship.toml
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── atuin ─────────────────────────────────────────────────────────
# takes over Ctrl+R from fzf history search
# (keybindings are re-registered in zvm_after_init, see above)
# to remove: delete this block and the `atuin init` line in zvm_after_init(),
# then `rm -rf ~/.atuin` (or `brew uninstall atuin`)
if [[ -f "$HOME/.atuin/bin/env" ]]; then
  . "$HOME/.atuin/bin/env"
  command -v atuin &>/dev/null && eval "$(atuin init zsh)"
fi

# ── sub configs ───────────────────────────────────────────────────
# plugins.zsh sources zsh-vi-mode and runs compinit, so keep the hooks above it
[[ -f ~/.config/fzf/fzf.zsh ]]       && source ~/.config/fzf/fzf.zsh
[[ -f ~/.config/zsh/plugins.zsh ]]   && source ~/.config/zsh/plugins.zsh  
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh
[[ -f ~/.local.zshrc ]] && source ~/.local.zshrc

