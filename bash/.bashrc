# ~/.bashrc
# ── Managed by stow (dotfiles/stow/bash/.bashrc) ─────────────────────────────
# On WORK machines this file is NOT stowed — instead bootstrap appends a single
# source line to the existing .bashrc. Either way, my.bashrc is what runs.

# If not running interactively, bail out
case $- in
    *i*) ;;
      *) return ;;
esac

source ~/.config/my.bashrc


# Also this is the local bash where i put my configs as per environments