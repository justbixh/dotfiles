# tmux

Config lives at `~/.config/tmux/tmux.conf`, managed via GNU Stow from this repo's `tmux/` package.

## New machine setup

1. **Install tmux** (>= 3.2 for `set-clipboard`, `allow-passthrough`)
   ```bash
   # Ubuntu/Debian
   sudo apt install tmux
   # RHEL/Oracle Linux
   sudo dnf install tmux
   # macOS
   brew install tmux
   ```

2. **Stow this package**
   ```bash
   cd ~/dotfiles
   stow tmux
   ```
   This symlinks `tmux/.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`.

3. **Install TPM (Tmux Plugin Manager)** — not tracked in git, must be cloned fresh per machine
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```

4. **Start tmux and install plugins**
   ```bash
   tmux
   ```
   Inside tmux, press `prefix + I` (capital i) to fetch and install all plugins listed in `tmux.conf`:
   - `tmux-plugins/tpm`
   - `omerxx/tmux-floax` (floating popup shell)
   - `omerxx/tmux-sessionx` (fzf session switcher)

5. **Verify clipboard integration**
   - Local machine (WezTerm): OSC 52 should just work via `allow-passthrough on` + `terminal-features clipboard`.
   - Remote/SSH (headless VMs): confirm Neovim's `unnamedplus` + OSC 52 provider is also set up (see `nvim/` package) so yank reaches the local clipboard through nested tmux/SSH.

6. **Sanity check keybindings**
   - Prefix is `C-b` (unchanged from default).
   - `prefix + \`` → floax floating popup
   - `prefix + s` → sessionx fzf session switcher
   - `prefix + g` → lazygit popup (requires `lazygit` installed separately)
   - `prefix + r` → reload config in place

## Dependencies not covered by Stow

These aren't dotfiles-managed and need manual install per machine:

| Tool | Used for | Install |
|---|---|---|
| `tpm` + plugins | plugin manager | step 3–4 above |
| `lazygit` | `prefix + g` popup | `brew install lazygit` / `dnf`/`apt` per distro, or gh release binary |
| `fzf` | sessionx picker backend | see `fzf/` stow package |

## Notes

- `history-limit` is set high (1,000,000) — fine for local use, but on constrained bare-metal VMs consider lowering it if memory is tight.
- `escape-time 0` is required for Neovim to feel responsive; don't remove it.
- Status bar uses Catppuccin-derived hex colors — matches the rest of the dotfiles theme (see WezTerm/Neovim packages).
