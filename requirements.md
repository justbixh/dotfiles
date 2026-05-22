# initial requirement (from user)
Goal: A plug-and-play dotfiles repo — clone, install CLI tools, stow, and be ready on any machine.

Environments:
Daily: Ubuntu + Bash
Work: RHEL 9 / CentOS + Bash
Future: macOS + Zsh (possible)

Stow strategy: One folder per tool (fzf/, starship/, tmux/, yazi/, git/, etc.), shells in their own folders (bash/, zsh/).
Bootstrap: Single entry script that detects OS and delegates to OS-specific install scripts, with proper logging.
Constraint: On work laptops, can't stow .bashrc directly — existing content must be preserved. 
Prefer symlinking or aliasing to handle package name differences across distros.

# to be implemented now
- support zshrc
- after installation, show the summary of the installation
- .bashrc
    - see wheather to separate into 3 parts (shell, tools, aliases)
    - see how to make the my.bashrc that get sourced in bashrc
    - so in work-dev setup, it doesn't stow onto bashrc but append source my.bashrc there

## Recommendation given (by claude) good to have but gradually implement
Ask: Review critically — point out gaps, bad practices, and better approaches from all angles.

- create a new mythen append a single source line to the existing .bashrc. the existing bashrc stays untouched. Automate the append in bootstrap with an idempotency guard so it doesn't duplicate on re-runs.
- Installing CLI tools without pinning versions means the repo breaks silently over time. document expected versions. Better: a .tool-versions file (asdf) or a versions manifest.
- Package name mapping is implicit — You mention symlinking names but there's no central map. A single packages.toml / packages.yaml with ubuntu_name / rhel_name / brew_name columns is far easier to maintain than scattered conditionals across scripts.
- No idempotency guarantee — Bootstrap should be safe to re-run. Every install step needs a "already installed?" check before acting.
- Shell-agnostic shared config — Bash and Zsh share a lot (aliases, env vars, path). Factor that into a ~/.env_common or shell/common/ sourced by both, so you're not duplicating across bash/ and zsh/.
