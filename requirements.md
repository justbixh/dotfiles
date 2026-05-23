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

# to be implemented now
- .bashrc
    - see wheather to separate into 3 parts (shell, tools, aliases)
    - see how to make the my.bashrc that get sourced in bashrc
    - so in work-dev setup, it doesn't stow onto bashrc but append source my.bashrc there

## Recommendation given (by claude) good to have but gradually implement
Ask: Review critically — point out gaps, bad practices, and better approaches from all angles.

- create a new mythen append a single source line to the existing .bashrc. the existing bashrc stays untouched. Automate the append in bootstrap with an idempotency guard so it doesn't duplicate on re-runs.
- Installing CLI tools without pinning versions means the repo breaks silently over time. document expected versions. Better: a .tool-versions file (asdf) or a versions manifest.
- No idempotency guarantee — Bootstrap should be safe to re-run. Every install step needs a "already installed?" check before acting.
