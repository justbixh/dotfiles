# ⚡ Custom Neovim Configuration Guide & Cheatsheet

Welcome to your custom Neovim setup. This configuration is built on top of **LazyVim** and optimized with **Snacks.nvim** for high-performance file searching, workspace exploration, and terminal Git integration. It also features out-of-the-box clipboard sharing for macOS and WSL.

---

## 📂 Configuration Structure
Your configuration lives in `~/.config/nvim/` and is structured as follows:
- [`init.lua`](file:///Users/bishnu/dotfiles/nvim/.config/nvim/init.lua): Entry point (loads LazyVim).
- [`lua/config/options.lua`](file:///Users/bishnu/dotfiles/nvim/.config/nvim/lua/config/options.lua): Global options (clipboard, WSL wrappers).
- [`lua/config/keymaps.lua`](file:///Users/bishnu/dotfiles/nvim/.config/nvim/lua/config/keymaps.lua): Custom global keymaps (mouse yank release, `jj` escape).
- [`lua/plugins/snacks.lua`](file:///Users/bishnu/dotfiles/nvim/.config/nvim/lua/plugins/snacks.lua): Configuration for Snacks.nvim (explorer, pickers, scratchpads, lazygit).
- [`lua/plugins/tmux-navigator.lua`](file:///Users/bishnu/dotfiles/nvim/.config/nvim/lua/plugins/tmux-navigator.lua): vim-tmux-navigator (`Ctrl + h/j/k/l` across nvim splits and tmux panes).

---

## 🧭 Discovering Features
This README covers the custom setup. To see everything that is active, ask Neovim:

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>` (wait) | **Which-key** | Popup of all leader keymaps, grouped; keep typing to drill down |
| `<leader> sk` | **Search Keymaps** | Fuzzy search every keymap and its description |
| `<leader> ?` | **Buffer Keymaps** | Keymaps for the current buffer only |
| `?` | **Window Help** | Inside the explorer or a picker, shows that window's keys |
| `:Lazy` | **Plugins** | Installed plugins; `Enter` on one shows its details |
| `:LazyExtras` | **Extras** | Optional feature packs (languages, AI, etc.); none enabled yet |

Full list of LazyVim defaults: https://www.lazyvim.org/keymaps

---

## 🎯 Keyboard Shortcuts (Cheatsheet)

### 🔍 Search & Navigation (Snacks.nvim)
These override default search tools with high-speed Lua pickers:

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `Ctrl + p` | **Find Files** | Fuzzy search files in the current workspace |
| `Ctrl + n` | **File Explorer** | Open/Toggle the sidebar file explorer (includes hidden files) |
| `<leader> <leader>` | **Recent Files** | Search through recently opened files |
| `<leader> fb` | **Buffers** | List active/open buffers |
| `<leader> fg` | **Grep Workspace** | Live grep (search for text inside all files) |

### 📁 File Explorer (Snacks)
Inside the explorer (`Ctrl + n`):

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `a` | **Add** | Create a file; end the name with `/` for a directory (`foo/bar.go` creates `foo` too) |
| `d` | **Delete** | Delete the file or directory |
| `r` | **Rename** | Rename the file or directory |
| `c` / `m` | **Copy / Move** | Copy or move the file |
| `y` / `p` | **Yank / Paste** | Yank files and paste them into another directory |
| `H` / `I` | **Hidden / Ignored** | Toggle hidden and git-ignored files |
| `o` | **Open** | Open with the system application |

### 🛠️ Utilities & Git
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader> lg` | **Lazygit** | Toggle Lazygit terminal UI popup |
| `<leader> gl` | **Lazygit Log** | Show Git commit history for the current workspace |
| `<leader> sf` | **Scratchpad** | Toggle a temporary floating scratch text buffer |
| `<leader> S` | **Select Scratch** | View and select from active scratch buffers |
| `Ctrl + /` | **Terminal** | Toggle a terminal split (root dir) |
| `<leader> uz` | **Zen Mode** | Distraction-free view of the current buffer |

Also enabled in `snacks.lua` with no extra keys: start dashboard, indent guides, notifications, image preview, and highlighting of other uses of the word under the cursor.

### ⌨️ Editing
- `jj` — Exit insert mode (same as `Esc`).
- `Ctrl + a` — Select the whole buffer.

### 📋 Clipboard & Mouse
Clipboard integration is unified across macOS, Linux, and Windows (WSL via `win32yank`).

- **Yank to Clipboard**: Any yank, `x`, `c` or `D` automatically copies to the system clipboard (`unnamedplus` enabled).
- **Delete without Copying**: `d` (and `dw`, `db`, `dd`, ...) only deletes; it never overwrites the clipboard.
- **Mouse Drag-to-Copy**: Selecting text with the mouse in Visual mode automatically yanks the selection to the system clipboard on release, preserving the visual selection highlight.

---

## 💤 Standard LazyVim Essentials

If you are new to the LazyVim ecosystem, here are the most important daily-use commands:

### ⚙️ Package Management
*   `:Lazy` — Open the package manager dashboard to check, update, or clean plugins.
*   `:LazyFormat` (or `<leader> cf`) — Formats the current buffer using configured formatters (conform.nvim).

### 💡 LSP & Code Actions
*   `K` — Show hover information/documentation for the symbol under the cursor.
*   `gD` — Jump to declaration.
*   `gd` — Jump to definition.
*   `gr` — Show references (uses Snacks picker).
*   `gI` — Jump to implementation.
*   `<leader> ca` — Show available LSP Code Actions (imports, quick-fixes).
*   `<leader> cr` — Rename symbol under the cursor workspace-wide.

### 🪟 Window & Buffer Management
*   `<leader> wd` — Close current window.
*   `Ctrl + h/j/k/l` — Navigate between window splits and tmux panes (left, down, up, right).
*   `<leader> bd` — Delete/Close current buffer.
*   `[b` / `]b` — Cycle to previous/next open buffer.

---

## 💡 Pro Tips
1. **Terminal Copy Bypass**: If you ever want to bypass Neovim's mouse capturing to select text using WezTerm's native copy behavior, hold down **Option** (macOS) or **Shift** (WSL/Linux) while dragging the mouse.
2. **Scratchpads**: Use `<leader> sf` to jot down quick notes, code snippets, or logs. They are saved in Neovim's state directory and persist across editor restarts!
