# ── ~/.config/shell/fzf.bash ─────────────────────────────────────────────────
# Stow package: fzf/
# Sourced from .bashrc as: source ~/.config/shell/fzf.bash

# ── shell integration ─────────────────────────────────────────────────────────
eval "$(fzf --bash)"

# ── fd as the default finder ──────────────────────────────────────────────────
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# ── base style (one place to change) ─────────────────────────────────────────
_FZF_STYLE="--info=inline --no-separator --preview-border=dashed --margin=1 --padding=1"

# ── ctrl-t: preview files with bat, dirs with eza ────────────────────────────
export FZF_CTRL_T_OPTS="
    --preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'
    $_FZF_STYLE"

# ── alt-c: preview dirs with eza ─────────────────────────────────────────────
export FZF_ALT_C_OPTS="
    --preview 'eza --tree --color=always {} | head -200'
    $_FZF_STYLE"

# ── ctrl-r: history preview, ctrl-y to yank ──────────────────────────────────
export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --style minimal
    --preview-window 'up:3:hidden:wrap'
    --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip)+abort'"

# ── ** completion: per-command previews ───────────────────────────────────────
_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' $_FZF_STYLE "$@" ;;
        export|unset) fzf --preview 'bash -c "echo \${!1}" _ {}'              $_FZF_STYLE "$@" ;;
        ssh)          fzf --preview 'dig {}'                                   $_FZF_STYLE "$@" ;;
        *)            fzf --preview "if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi" $_FZF_STYLE "$@" ;;
    esac
}

# ── fd as path/dir generator for ** completion ────────────────────────────────
_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1"; }


# ── fzf-git ───────────────────────────────────────────────────────────────────
[ -f ~/.config/fzf-git/fzf-git.sh ] && source ~/.config/fzf-git/fzf-git.sh

export FZF_GIT_FZF_OPTS="$_FZF_STYLE --ansi"

_fzf_git_fzf() {
    fzf --height 50% --tmux 90%,70% \
        --layout reverse --multi --min-height 20+ --border \
        --no-separator --header-border horizontal \
        --border-label-pos 2 \
        --color 'label:blue' \
        --preview-window 'right,50%' --preview-border line \
        --bind 'ctrl-/:change-preview-window(down,50%|hidden|)' "$@"
}
