<div align="center">

```
    ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
    ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
    ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
    ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
    ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
    ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
```

**Clone. Stow. Work.**

*Your terminal. Every machine. Zero compromise.*


![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-1a1a2e?style=flat-square&logo=gnubash&logoColor=white)
![Stow](https://img.shields.io/badge/managed%20by-GNU%20Stow-4a9eff?style=flat-square)
![OS](https://img.shields.io/badge/OS-Ubuntu%20%7C%20RHEL%20%7C%20macOS-orange?style=flat-square&logo=linux&logoColor=white)
![License](https://img.shields.io/badge/license-do%20whatever-green?style=flat-square)

</div>

---

## What's this?

A plug-and-play dotfiles setup that works the same on your Ubuntu workstation, your work RHEL laptop, and whatever else you throw it at. Symlink-managed via GNU Stow. Idempotent. Safe to re-run. Doesn't nuke your existing configs.

*Built for devs who SSH into too many machines and got tired of reconfiguring everything.*

---

## Project Layout

```
dotfiles/
├── bash/               # .config/bash/my.bashrc
├── zsh/                # .config/zsh/{my.zshrc,bindings,plugins}
├── nvim/               # Full LazyVim setup
├── tmux/               # .tmux.conf
├── git/                # .gitconfig + aliases
├── fzf/                # .config/fzf/fzf.sh
├── starship/           # .config/starship.toml
├── wezterm/            # .wezterm.lua
├── yazi/               # .config/yazi/yazi.toml
├── bootstrap.sh        # Stow orchestrator — run this
├── check.sh            # Verify what's installed
├── stowing.md          # Stow cheatsheet
├── tool-installation.md # manual tool installation blocks
└── readme.md           # you are here 
```

> Each top-level directory is a stow package. The internal structure mirrors `$HOME`, so stow knows exactly where to place every symlink.

---

## Quick Start

### 1. Clone

```bash
git clone https://github.com/justbixh/dotfiles.git ~/dotfiles
```

### 2. Check what's installed

```bash
bash ~/dotfiles/check.sh
```

### 3. Install missing tools

```bash
# The md file has per-OS install commands
cat ~/dotfiles/tool-installation.md
```

### 4. Stow everything

```bash
# Dry run first — always a good idea
bash ~/dotfiles/bootstrap.sh --dry

# Apply
bash ~/dotfiles/bootstrap.sh
```

### 5. (Optional) Switch to zsh

```bash
chsh -s $(which zsh)
# then log out and back in
```

---

## Features

| | |
|---|---|
| **Append-safe** | Sources new configs from `my.bashrc` and `my.zshrc` while keeping your  existing `.bashrc`/`.zshrc` configs safe — nothing gets overwritten |
| **Idempotent** | Run bootstrap as many times as you want |
| **Modular** | Stow one package or all of them |
| **OS detection** | Handles Ubuntu, RHEL/CentOS, macOS automatically |
| **Dry-run mode** | `--dry` flag previews all symlink operations before touching anything |

---

## Stow in 30 Seconds

```bash
cd ~/dotfiles

stow bash               # symlink just bash config
stow tmux nvim git      # multiple packages at once
stow --delete tmux      # remove tmux symlinks
stow --restow nvim      # refresh (useful after adding files)
```

Full reference: [`stowing.md`](./stowing.md)

---

## CLI tools pick

| Tool | Purpose |
|---|---|
| **zsh** | modern bash |
| **starship** | Prompt |
| **fzf** | Fuzzy finder |
| **fzf-git** | Git Fuzzy finder |
| **lazygit** | git tui |
| **atuin** | History manager |
| **yazi** | File manager |
| **Neovim** (LazyVim) | Editor |
| **tmux** | Terminal multiplexer |
| **wezterm** | Terminal emulator |
| **bat** | better cat |
| **eza** | better ls |
| **btop** | better top |
| **fd** | better find |
| **rg** | better grep |
| **zoxide** | a smarter cd |
| **procs** | tabular ps |
| **ncdu** | disk usage analyzer |
| **duf** | nicer du df |
| **Nerd Font** | Glyph support for everything above |

---

## Multi-Machine Strategy (Under work)

```
~/dotfiles/
└── backup/
    └── detect-os.sh   ← knows if you're on apt, dnf, or brew
```

`bootstrap.sh` calls OS detection before stowing, so the same repo behaves correctly across distros. Work laptop on RHEL 9? Home box on Ubuntu? Same commands, same result.

---

<div align="center">

*One repo to rule the `~`. Stow it once. Find it everywhere.*

</div>