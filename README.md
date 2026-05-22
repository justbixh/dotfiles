# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Supports **Ubuntu**, **RHEL/CentOS/Rocky**, and **macOS**.

## Quick Start

Clone the repository and run the bootstrap script:

```bash
git clone git@github.com:YOU/dotfiles.git ~/.dotfiles
bash ~/.dotfiles/bootstrap.sh
```

**Options:**
- `--stow-only`: Skip package installation, only run stow to link configs.
- `--pkgs-only`: Skip stow, only install required packages.

The script automatically detects your OS, installs necessary tools (like `fzf`, `starship`, `zoxide`, `yazi`, `eza`), and configures your shell safely by appending to your existing `.bashrc` or `.zshrc`.

## Project Structure

```bash
 dotfiles
├──  bootstrap.sh
├── 󰊢 .gitignore
├── 󱆃 .stowrc
├──  scripts
│   ├──  detect-os.sh
│   ├──  install-macos.sh
│   ├──  install-rhel.sh
│   └──  install-ubuntu.sh
├──  bash
│   ├── 󱆃 .bashrc        # local configuration
│   └──  .config
│       └──  my.bashrc  # sourced inside .bashrc
├──  zsh
│   └── 󱆃 .zshrc         # local configuration 
│   └──  .config
│       └──  my.zshrc   # sourced inside .zshrc
├──  fzf
│   └──  .config
│       └──  fzf.sh     # sourced inside my.bashrc
├──  git
│   └── 󰊢 .gitconfig
├──  starship
│   └──  .config
│       └──  starship.toml
├──  tmux
│   └── 󱁻 .tmux.conf
├──  wezterm 
│   └── wezterm.lua    # to-add
```

## Machine-Local Overrides

A local configuration file is created during installation at `~/.config/shell/local`. This file is **not tracked in git**. 
Use it for machine-specific settings such as:
- Corporate proxies (`HTTP_PROXY`, etc.)
- Git identity (`GIT_AUTHOR_EMAIL`)
- Local paths (e.g., `JAVA_HOME`)
- Secrets and tokens

## Customizing Tools

The bootstrap script will install modern CLI alternatives into `~/.local/bin`, including:
- **Navigation:** `zoxide`, `yazi`, `fd`, `fzf`
- **System & Utils:** `eza`, `bat`, `btop`, `ripgrep`, `jq`, `yq`
- **Development:** `tmux`, `lazygit`, `git-delta`, `starship`

## Adding a New Machine or Distro

1. Create a new install script in `scripts/install-<distro>.sh`.
2. Add a detection case in `scripts/detect-os.sh`.
3. Call your script from `bootstrap.sh`.

To update tools later, you can simply re-run the bootstrap script with `--pkgs-only` or wait for the versions to update and fetch the latest binaries.
