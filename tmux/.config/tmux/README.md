## Features

   - Supports scratch shell popups, lazygit popups for quick commits without leaving current screen, Better session switcher, session persistence so sessions survive machine restarts, ssh split support, and much more 
   - Multiple themes are present. Uncomment to use one and, reload config (Prefix r) to apply
   - Uses the machine clipboard instead of tmux internal keyboard. :If shared keyboard not working, verify by checking Remote/SSH (headless VMs): confirm Neovim's `unnamedplus` + OSC 52 provider is also set up (see `nvim/` package) so yank reaches the local clipboard through nested tmux/SSH.


## Keybindings

   - Prefix is `C-b` (unchanged from default).
   - `prefix + c` → SSH-aware new window
   - `prefix + |` → split vertically (SSH-aware split)
   - `prefix + _` → split horizontally (SSH-aware split)
   - `prefix + Space` → cycle layouts 
   - `prefix + o` → pick a folder and open its tmux session (also Ctrl+O works)
   - `prefix + p` → pick a file and open it in Neovim (also Ctrl+P works)
   - `prefix + r` → reload config in place
   - `prefix + s` → sessionx fzf session switcher
   - `prefix + \`` → scratch popop with (requires floax. supports without pligin with less features)
   - `prefix + g` → lazygit popup (requires `lazygit` installed separately)

   Remote working-directory preservation requires an OSC 7 prompt or a `PS1` the plugin can parse.


## Dependencies not covered by Stow

These aren't dotfiles-managed and need manual install per machine:

| Tool | Used for | Install |
|---|---|---|
| `tpm` + plugins | plugin manager | step 3–4 above |
| `lazygit` | `prefix + g` popup | `brew install lazygit` / `dnf`/`apt` per distro, or gh release binary |
| `fzf` | sessionx picker backend | see `fzf/` stow package |


## New machine setup

If you are manually setting up only tmux, follow these steps. 

1. **Requires tmux** (>= 3.2 for `set-clipboard`, `allow-passthrough`)
   ```bash
   # macOS
   brew install tmux
   # Ubuntu/Debian
   sudo apt install tmux
   # RHEL/Oracle Linux
   sudo dnf install tmux
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
   Inside tmux, press `prefix + I` to install all plugins mentioned in configuration. 
   - `tmux-plugins/tpm`
   - `pschmitt/tmux-ssh-split` (SSH-aware splits and windows)
   - `omerxx/tmux-floax` (floating popup shell)
   - `omerxx/tmux-sessionx` (fzf session switcher)
