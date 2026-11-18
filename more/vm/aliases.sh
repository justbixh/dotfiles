# Minimal bash config for throwaway VMs. Source from ~/.bashrc:
#   [ -f ~/vm/aliases.sh ] && . ~/vm/aliases.sh
# Block order and names mirror zsh/.zshrc. Only uses what a stock Oracle Linux / RHEL
# server ships (bash, coreutils, grep, find, ss, curl, git); no extra tools needed.

case $- in *i*) ;; *) return 0 2>/dev/null ;; esac
[ -n "$BASH_VERSION" ] || return 0 2>/dev/null

# ── PATH ─────────────────────────────────────────────────────────
case ":$PATH:" in
*":$HOME/.local/bin:"*) ;;
*) export PATH="$HOME/.local/bin:$HOME/bin:$PATH" ;;
esac

# ── editor and pager ─────────────────────────────────────────────
if command -v vim >/dev/null 2>&1; then export EDITOR=vim; else export EDITOR=vi; fi
export VISUAL="${EDITOR}"
export SUDO_EDITOR="${EDITOR}"

export PAGER=less
export LESS='-R -F --no-init'

alias vi='$EDITOR'

# ── history ──────────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=10000
HISTIGNORE='rm:rm *'
HISTCONTROL=ignoreboth:erasedups # ignore lines starting with a space and repeated commands
shopt -s histappend              # append to the history file instead of overwriting it
shopt -s histverify              # show expanded history (e.g. !!) before executing it

# ── shell options ─────────────────────────────────────────────────
set -o noclobber            # guards against accidental file overwriting from `>`
shopt -s autocd 2>/dev/null # typing a directory name alone cds into it
shopt -s checkwinsize
bind 'set bell-style none'

# ── completion ────────────────────────────────────────────────────
bind 'set completion-ignore-case on' # case-insensitive: "doc" matches "Documents"
bind 'set show-all-if-ambiguous on'
bind '"\t": menu-complete'            # Tab cycles through matches
bind '"\e[Z": menu-complete-backward' # Shift+Tab goes back

# ── misc ──────────────────────────────────────────────────────────
alias bashrc='$EDITOR ~/.bashrc'
alias reload='exec bash -l'

# ── safety nets ───────────────────────────────────────────────────
alias cp='cp -i'
alias mv='mv -i'

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
alias ducks='du -h -d 1 | sort -rh | head -15' # -d works on both GNU and BSD du
alias myip='curl -s ifconfig.me'
alias ports='ss -tulanp'
alias listening='ss -tulanp | grep LISTEN'

# ── git ───────────────────────────────────────────────────────────
alias ga='git add'
alias gaa='git add .'
alias gap='git add -p'
alias gr='git restore'
alias grs='git restore --staged'
alias gs='git status'

alias gcm='git commit -m'
alias gca='git commit --amend --no-edit' # fold staged changes into last commit
alias gce='git commit --amend'
alias gcr='git commit --amend --only'                                           # edit last commit message only
alias gcam='git commit --amend -m'                                              # amend always targets HEAD
alias gunamend='git reset --soft "HEAD@{1}"'                                    # undo a bad amend (run right after)
alias gamendP='git commit --amend --no-edit && git push --force-with-lease'     # amend last commit with staged changes only, then force-push
alias gamendPa='git commit -a --amend --no-edit && git push --force-with-lease' # amend the last commit, then force-push.

alias gpr='git pull --rebase'
alias gprs='git pull --rebase --autostash'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gp='git pull'
alias gP='git push'
alias gPf='git push --force-with-lease'

alias gl='git log --graph --decorate'
alias glo='git log --oneline --graph --decorate'
alias glot="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias gss='git show --stat --graph --decorate -20'
alias gd='git diff -w'
alias gds='git diff --staged -w'
alias gundo='git reset HEAD~1'
alias grs='git restore --staged'

# ── branches ──
alias gb='git branch --sort=-committerdate'
alias gsw='git switch'
alias gco='git checkout'
alias gbrename='git branch -m'
alias gswc='git switch -c' # create + switch
alias gsw-='git switch -'  # back to previous branch
alias gbd='git branch -d'  # delete merged branch
alias gbD='git branch -D'  # force delete

# Conflicts (ours/theirs are swapped during a rebase)
alias gconflicts='git diff --name-only --diff-filter=U'
gours() { git checkout --ours -- "$@" && git add -- "$@"; }
gtheirs() { git checkout --theirs -- "$@" && git add -- "$@"; }
gconfedit() {
  local files
  files=$(git diff --name-only --diff-filter=U)
  [ -n "$files" ] && ${EDITOR:-vim} $files
}

# ── recovery / inspection ──
alias grl='git reflog' # find "lost" commits
alias gcp='git cherry-pick'
alias glf='git log --follow -p --' # history of one file: glf path/to/file
alias gbl='git blame -w'
sdiff2() {
  git diff --no-index --word-diff=color --word-diff-regex=. <(printf '%s\n' "$1") <(printf '%s\n' "$2")
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
# names follow the oh-my-zsh docker and docker-compose plugins
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dl='docker ps -l -q' # id of the last container, e.g. docker logs $(dl)
alias dr='docker container run'
alias drit='docker container run -it'
alias dst='docker container start'
alias dstp='docker container stop'
alias drs='docker container restart'
alias drm='docker container rm'
alias dlo='docker container logs'
alias dxc='docker container exec'
alias dxcit='docker container exec -it'
alias dbl='docker build'
alias dpu='docker pull'
alias dils='docker image ls'
alias dirm='docker image rm'
alias dvls='docker volume ls'
alias dnls='docker network ls'
alias dsts='docker stats'
alias dsprune='docker system prune'

# compose
alias dc='docker compose'
alias dcup='docker compose up'
alias dcupd='docker compose up -d'
alias dcupdb='docker compose up -d --build'
alias dcd='docker compose down'
alias dcps='docker compose ps'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dce='docker compose exec'
alias dcr='docker compose run'
alias dcrestart='docker compose restart'
alias dcpull='docker compose pull'

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
alias kcns='kubectl config set-context --current --namespace'

# ── ls ────────────────────────────────────────────────────────────
ls --color=auto -d . >/dev/null 2>&1 && alias ls='ls --color=auto'
alias lls='ls'
alias ll='ls -lh'
alias l='ls -lhtr'
alias la='ls -lhAtr'
alias lag='ls -lhAtr'
alias lp='ls -lhtr -d "$PWD"/*'
alias lS='ls -lhAS'
alias lt='ls -lhAX'
alias lf="ls -lhtr | grep -v '^[dt]'"
alias ld='ls -lhtrd */'
alias ldate="ls -lhtr --time-style='+%d %b %Y %H:%M'"
alias sl='ls -lhtr | tail -n 30'

# ltree [level]: find-based tree, ltreea includes dotfiles
ltree() {
  local n=2
  [[ $1 =~ ^[0-9]+$ ]] && n=$1
  find . -maxdepth "$n" -not -path '*/.*' | sort
}
ltreea() {
  local n=2
  [[ $1 =~ ^[0-9]+$ ]] && n=$1
  find . -maxdepth "$n" -not -path '*/.git' -not -path '*/.git/*' | sort
}

# ── cat ───────────────────────────────────────────────────────────
alias catn='cat -n'

# ── grep ──────────────────────────────────────────────────────────
alias rgi='grep -rIi'
alias rgl='grep -rIl'
alias rgc='grep -rIc'

# ── prompt ────────────────────────────────────────────────────────
# user, directory and git branch
_vm_branch() { git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null; }
PS1='\u \w$(b=$(_vm_branch); [ -n "$b" ] && echo " on $b") \$ '

# ── functions ─────────────────────────────────────────────────────
cl() { cd "${1:-$HOME}" && l; } # cd + ls
mkcd() { mkdir -p "$1" && cd "$1"; }

# Backs up files into .bak/, preserving attributes
# output: .sndrc.2026-07-03-143205.bak
backup() {
  local dir=".bak"
  local timestamp
  timestamp="$(date +%F-%H%M%S)"

  if [[ $# -eq 0 ]]; then
    echo "Usage: backup <file1> [file2 ...]"
    return 1
  fi

  mkdir -p "$dir"

  for file in "$@"; do
    if [[ ! -e "$file" ]]; then
      echo "Skipping (not found): $file"
      continue
    fi
    if [[ -d "$file" ]]; then
      cp -rp -- "$file" "$dir/$(basename "$file").${timestamp}.bak"
    else
      cp -p -- "$file" "$dir/$(basename "$file").${timestamp}.bak"
    fi
    echo "Backed up: $file -> $dir/$(basename "$file").${timestamp}.bak"
  done
}

# Search process
pc() {
  ps -ef | grep -i "$1" | grep -v grep
}

# ── local ─────────────────────────────────────────────────────────
[ -f ~/.local.bashrc ] && . ~/.local.bashrc
