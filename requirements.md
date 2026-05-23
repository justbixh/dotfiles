# initial requirement (from user)
Goal: A plug-and-play dotfiles repo — clone, install CLI tools, stow, and be ready on any machine.

Environments:
Daily: Ubuntu
Work: RHEL 9 CentOS
Future: macOS + Zsh

Stow strategy: One folder per tool (fzf/, starship/, tmux/, git/, etc.), shells in their own folders (bash/, zsh/).
Bootstrap: Single entry script that detects OS and delegates to OS-specific install scripts, with proper logging.

On work laptops, can't stow .bashrc or .zshrc directly — existing content must be preserved. so append my.bashrc and my.zshrc
local aliases will be stored in .bashrc or .zshrc
Prefer symlinking or aliasing to handle package name differences across distros.

# todo
- download and install a nerd font
- 