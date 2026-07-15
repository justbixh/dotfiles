## Stow commands

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