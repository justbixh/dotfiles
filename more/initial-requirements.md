Goal: A plug-and-play dotfiles repo — clone, install CLI tools, stow, and be ready on any machine.

Environments:
Personal-1: macOS + Zsh
Personal-2: Ubuntu
Work: RHEL 9 CentOS

Stow strategy: One folder per tool (fzf/, starship/, tmux/, git/, etc.), shells in their own folders (bash/, zsh/).
Bootstrap: Single entry script that detects OS and delegates to OS-specific install scripts, with proper logging.

On work laptops, can't stow .bashrc or .zshrc directly — existing content must be preserved. so append my.bashrc and my.zshrc
Local aliases will be stored in .bashrc or .zshrc
Work laptop will have their own project specific rc file, eg: ~/.sndrc
Prefer symlinking or aliasing to handle package name differences across distros.

# todo
- download and install a nerd font
- install cli tools 
