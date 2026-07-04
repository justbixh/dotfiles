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

## Stow only (skip package install)

```bash
bash ~/dotfiles/bootstrap.sh
bash ~/dotfiles/bootstrap.sh --dry # dryrun
```

## Common issues

**Wrong target directory**
If symlinks land in the wrong place, check `.stowrc` — the `--target` must be `$HOME`.

**Symlink but file not loading**
The symlink exists but the shell isn't sourcing it.
Check that your `.zshrc` / `.bashrc` has the source line:
```bash
grep "my.zshrc" ~/.zshrc
```
If missing, bootstrap.sh appends it automatically.