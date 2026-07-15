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

## Quick Start

### 1. Clone

```shell
git clone https://github.com/justbixh/dotfiles.git ~/dotfiles
```

### 2. Check tools installed

```bash
bash ~/dotfiles/more/check.sh
```

### 3. Install tools (mac only)

```shell
# install [homebrew](https://brew.sh/) if not installed 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# running this command installs everything (comment not required tools in Brewfile)
brew bundle --file=~/dotfiles/macos/Brewfile
```

## Stow/Apply dotfiles

```bash
# stow a single package
cd ~/dotfiles && stow zsh

# stow all
cd ~/dotfiles && stow fzf nvim starship tmux yazi wezterm git zsh

# restow (re-links everything, safe to re-run)
cd ~/dotfiles && stow --restow fzf nvim starship tmux yazi wezterm git zsh

# unstow (removes symlinks)
cd ~/dotfiles && stow --delete zsh

# dry run — see what would happen without doing it
cd ~/dotfiles && stow --simulate zsh
```

### 5. Switch to zsh

```bash
chsh -s $(which zsh)
# then log out and back in
```

---

## dot files tree
```
dotfiles/
├── fzf/.config/fzf
│   └── .config
│       └── fzf
│           └── fzf.sh
├── git
│   └── .config
│       └── git
│           └── config
├── macos
│   ├── Brewfile
│   └── macos-defaults.sh
├── nvim
│   └── .config
│       └── nvim
│           ├── lua/
│           ├── .neoconf.json
│           ├── init.lua
│           ├── lazy-lock.json
│           ├── lazyvim.json
│           └── stylua.toml
├── starship
│   └── .config
│       └── starship
│           └── starship.toml
├── tmux
│   └── .config
│       └── tmux
│           └── tmux.conf
├── wezterm
│   └── .config
│       └── wezterm
│           ├── wezterm.lua
│           └── wezterm.win.lua
├── yazi
│   └── .config
│       └── yazi
│           └── yazi.toml
├── zsh
│   ├── .zshrc
│   └── .config
│       └── zsh
│           ├── functions.zsh
│           └── plugins.zsh
├── .gitignore
├── .stowrc
└── readme.md
```

> Each top-level directory is a stow package. The internal structure mirrors `$HOME`, so stow knows exactly where to place every symlink.

## post stow

```
$HOME/
  .zshrc
  .local.zshrc  # .gitignore'd
  .config/
    git/config
    nvim/
    fzf/fzf.sh
    starship/starship.toml
    tmux/tmux.conf
    wezterm/wezterm.lua
    yazi/yazi.toml
    zsh/
      functions.zsh
      plugins.zsh
```

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

and more. See Brewfile

---

<div align="center">

*Never lose your dotfiles. even if your laptop is nuked*

</div>