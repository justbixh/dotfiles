# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal dotfiles repo managed with GNU Stow, used on macOS and WSL (the Ubuntu/RHEL paths exist but are untested). There is no build or test suite; "testing" a change means re-stowing/reloading the tool and looking at it.

## Layout and stow model

- Every top-level directory (`zsh`, `tmux`, `nvim`, `wezterm`, `yazi`, `starship`, `fzf`, `git`, `claude`) is an independent Stow package whose internal tree mirrors `$HOME`. E.g. `tmux/.config/tmux/tmux.conf` becomes `~/.config/tmux/tmux.conf`. New config files must be placed at the mirrored path inside the right package.
- `.stowrc` sets `--target=~` and ignores `more/` and `readme.md` (lowercase on purpose: `README.md` would also stop the package READMEs from being stowed). `macos/` is not a stow package (it holds `Brewfile` and `macos-defaults.sh`) and is not in the documented stow list.
- Because files are symlinked, editing the repo file edits the live config.
- Machine-specific settings go in untracked files (e.g. `~/.local.zshrc`). Plugin checkouts are gitignored: `zsh/.config/zsh/plugins/` and `tmux/.config/tmux/plugins/`.

## Commands

```bash
cd ~/dotfiles && stow <pkg>                      # link one package
stow --restow fzf nvim starship tmux yazi wezterm git zsh claude   # relink all (idempotent)
stow --simulate <pkg>                            # dry run
stow --delete <pkg>                              # unlink
bash more/check.sh                               # report which required tools are installed
brew bundle --file=macos/Brewfile                # macOS tool install
tmux source-file ~/.config/tmux/tmux.conf        # reload tmux (or prefix + r)
```

## Architecture notes

- **tmux** (`tmux/.config/tmux/tmux.conf`): plugins via TPM (`run tpm/tpm` stays at the bottom; only the `popup-style` override follows it, since TPM re-runs Catppuccin, which sets popup colors). Catppuccin is loaded *immediately* with `run '.../catppuccin.tmux'` before the `status-right` lines, because the `@thm_*` color variables must exist when they are expanded. The right status bar is built manually from pill segments (rounded Nerd Font caps, `@thm_*` colors, Material Design icons); several earlier themes are kept commented out. `scripts/quote.sh` supplies the quote-of-the-day pill; the battery pill tries `pmset` (macOS), then `/sys/class/power_supply/BAT*` (Linux), else shows `AC`.
- **zsh**: `zsh/.zshrc` sets up options, keybindings and tool hooks (atuin, zoxide, starship), then at the bottom sources, in order, `fzf/fzf.zsh`, `plugins.zsh`, `functions.zsh` and the untracked `~/.local.zshrc`. `plugins.zsh` downloads plugins from GitHub into the gitignored `plugins/` dir, sources zsh-vi-mode (which wipes all bindkeys on init, so keybindings must be defined in `zvm_after_init` in `.zshrc`) and runs `compinit`; keep hooks above it. Tools expected: starship, atuin, zoxide, fzf, eza, bat, fd, ripgrep.
- **fzf**: `fzf/.config/fzf/bin/ff` is the single file picker; it owns the search roots and the exclude list and only prints the picked paths (`ff` = system roots, `ff .` = current dir). The `ff-widget` / `ff-here-widget` widgets in `fzf.zsh` turn the picks into an `nvim <files>` command line (Ctrl+P / Ctrl+O, bound in `zvm_after_init`). Scripts in `bin/` run under macOS bash 3.2: no `printf '\u'`, and empty arrays under `set -u` need `${arr[@]+"${arr[@]}"}`.
- **nvim**: LazyVim-based (no extras enabled in `lazyvim.json`); custom config in `lua/config/` and `lua/plugins/`. Snacks.nvim (`lua/plugins/snacks.lua`) provides the picker and file explorer, not Telescope/Neo-tree. Clipboard in `options.lua` uses OSC 52 (win32yank on WSL), which relies on tmux `allow-passthrough on`. `Ctrl+h/j/k/l` is vim-tmux-navigator and needs both halves: `lua/plugins/tmux-navigator.lua` and the plugin line in `tmux.conf`.
- **claude**: only the Claude Code status line script (needs `jq`); `~/.claude/settings.json` stays untracked and points at it via `statusLine.command`. Its git segment mirrors `starship.toml` (same Nerd Font glyphs, written as `\xHH` byte escapes because macOS bash 3.2 `printf` has no `\u`), so update both together.
- **starship**: config lives at `~/.config/starship/starship.toml`, not starship's default path; `.zshrc` points at it with `STARSHIP_CONFIG`.
- **wezterm**: `wezterm.lua` is the macOS/Linux config; `wezterm.win.lua` is a separate Windows-host config that launches WSL Ubuntu.
- **Theme**: the `colors` table in `wezterm.lua` / `wezterm.win.lua` is the palette. zsh, starship and bat (`BAT_THEME="ansi"`) only use ANSI colors, so they follow it. tmux stays Catppuccin Mocha because the status bar pills use its `@thm_*` colors.
- **Nerd Font** is required for tmux/starship/wezterm glyphs. When editing files with private-use-area icons, write them with escapes (e.g. Python `"\U000f0079"`), since they are invisible in many editors and easy to lose. Install steps (macOS, Linux, Windows) are in `README.md` step 3.
- **git**: `git/.config/git/config` uses `includeIf "gitdir:..."` to load per-directory identities from untracked `~/.gitconfig.work` (see its README).
- READMEs in `tmux/.config/tmux/`, `nvim/.config/nvim/` and `git/.config/git/` document keybindings and per-package dependencies not covered by Stow; the top-level `README.md` "Offerings" table lists the shell-level keys. Update the relevant README when a keybinding changes.

## Conventions

- `.zshrc` sets `noclobber` and aliases `cat` → `bat` and `rm` → `trash`, so in shell commands use `command cat`, `command rm` and `>|` to overwrite.

- Commits follow [Conventional Commits](https://www.conventionalcommits.org): `type(scope): subject`, imperative mood, lowercase, no trailing period, one logical change per commit.
- New comments and README lines copy the format of their neighbours (tmux.conf section comments are one short line; README keybinding lists use `` `prefix + x` → action ``). Don't add notes that only call out the change being made.
