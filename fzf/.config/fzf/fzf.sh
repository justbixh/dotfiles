# ── Fuzzy Finder integration - Sourced from both .bashrc and .zshrc ─────────────────────────────────────────────────────────
# ~/.config/fzf/fzf.sh
# Stow package: fzf
# Requires fd, rg, bat, and eza to be installed for the previews to work.

# ── shell integration ─────────────────────────────────────────────────────────
if [ -n "$ZSH_VERSION" ]; then
    eval "$(fzf --zsh)"
elif [ -n "$BASH_VERSION" ]; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash  # needed for git install, not apt
    eval "$(fzf --bash)"                       # needed for package manager install
fi

# ── base styling — FZF_DEFAULT_OPTS applies to every fzf call ────────────────
# avoids word-splitting issues between bash and zsh
export FZF_DEFAULT_OPTS="--no-separator --preview-border=dashed --margin=1 --padding=1"

# ── ctrl-t: preview files with bat, dirs with eza ────────────────────────────
export FZF_CTRL_T_OPTS="--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200;
else bat -n --color=always --line-range :500 {}; fi'"

# ── alt-c: preview dirs with eza ─────────────────────────────────────────────
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# ── ctrl-r: history preview, ctrl-y to yank ──────────────────────────────────
# overrides default configuration from FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --style minimal
    --preview-window 'up:3:hidden:wrap'
    --margin 0
    --padding 0
    --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip)+abort'"

# ── ** completion: per-command previews ───────────────────────────────────────
# FZF_DEFAULT_OPTS already applied — no need to pass style flags here
_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview 'bash -c "echo \${!1}" _ {}'              "$@" ;;
        ssh)          fzf --preview 'dig {}'                                   "$@" ;;
        *)            fzf --preview "if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi" "$@" ;;
    esac
}



# ── fzf-fd: faster finder for fzf, ctrl-t, alt-c ─────────────────────────────
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# ── fzf-fd: faster finder during **<TAB> completion ──────────────────────────
_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1"; }



# ── fzf-rg → open in vim ─────────────────────────────────────────────────────
rgf() {
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --color=always {1} --highlight-line {2}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind 'enter:become(vim {1} +{2})'
}

# ── fzf-git ───────────────────────────────────────────────────────────────────
[ -f ~/.config/fzf-git/fzf-git.sh ] && source ~/.config/fzf-git/fzf-git.sh  # setup via github download

# can add later to override default configuration: --margin 0 --padding 0 \
_fzf_git_fzf() {
    fzf --height 50% --tmux 90%,70% \
        --layout reverse --multi --min-height 20+ --border \
        --no-separator --header-border horizontal \
        --border-label-pos 2 \
        --color 'label:blue' \
        --preview-window 'right,50%' --preview-border line \
        --bind 'ctrl-/:change-preview-window(down,50%|hidden|)' "$@"
}

# ── key bindings ──────────────────────────────────────────────────────────────
# Ctrl+O — fzf file picker (hidden files excluded)
_fzf_file_no_hidden() {
  local result
  result=$(fd --type f --strip-cwd-prefix --exclude .git 2>/dev/null | fzf)
  [[ -n "$result" ]] && LBUFFER+="$result"
  zle reset-prompt
}


if [ -n "$ZSH_VERSION" ]; then
  zle -N _fzf_file_no_hidden
  bindkey '^O' _fzf_file_no_hidden # Ctrl+O for fzf file picker (hidden files excluded)
elif [ -n "$BASH_VERSION" ]; then 
  bind -r '"\C-r"' # unbind Ctrl+R so atuin can take over history search
  bind -x '"\C-o": _fzf_file_no_hidden' # Ctrl+O for fzf file picker (hidden files excluded)
fi


