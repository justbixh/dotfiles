# stow.md — Dotfiles Stow Reference

## How stow works

Stow creates symlinks from your dotfiles repo into `$HOME`.

```
~/dotfiles/zsh/.config/zsh/my.zshrc
                 ↓ stow
~/.config/zsh/my.zshrc  →  ~/dotfiles/zsh/.config/zsh/my.zshrc
```

The folder structure inside each package mirrors where files should land in `$HOME`.
Stow just links them there — no copying.

---

## Repo structure expected

```
~/dotfiles/
├── bash/
│   └── .config/
│       └── my.bashrc
├── zsh/
│   └── .config/
│       └── my.zshrc
├── git/
│   └── .gitconfig
├── tmux/
│   └── .config/
│       └── tmux/
│           └── tmux.conf
├── starship/
│   └── .config/
│       └── starship.toml
├── fzf/
│   └── .config/
│       └── fzf/
│           └── fzf.conf
└── nvim/
    └── .config/
        └── nvim/
```

---

## .stowrc

Place `.stowrc` at the root of your dotfiles repo.
Stow reads it automatically — no need to pass flags every time.

```
# ~/dotfiles/.stowrc
--target=/home/YOUR_USER
--dir=/home/YOUR_USER/dotfiles
--verbose=1
```

> Replace `YOUR_USER` with your actual username, or use the setup script below
> to generate it dynamically.

---

## Stow commands

```bash
cd ~/dotfiles

# stow a single package
stow zsh

# stow multiple packages
stow zsh git tmux starship

# restow (re-links everything, safe to re-run)
stow --restow zsh git tmux starship fzf bash

# unstow (removes symlinks)
stow --delete zsh

# dry run — see what would happen without doing it
stow --simulate zsh
```

---

## Stow only (skip package install)

```bash
bash ~/dotfiles/bootstrap.sh --stow
```

---

## Common issues

**Conflict: file already exists**
```
WARNING! stowing zsh would cause conflicts
existing target is not owned by stow: .zshrc
```
Stow won't overwrite existing files. Back up and remove the conflicting file first:
```bash
mv ~/.zshrc ~/.zshrc.bak
stow zsh
```

**Wrong target directory**
If symlinks land in the wrong place, check `.stowrc` — the `--target` must be `$HOME`.

**Symlink but file not loading**
The symlink exists but the shell isn't sourcing it.
Check that your `.zshrc` / `.bashrc` has the source line:
```bash
grep "my.zshrc" ~/.zshrc
```
If missing, bootstrap.sh appends it automatically.