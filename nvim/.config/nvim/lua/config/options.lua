-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ── Clipboard ─────────────────────────────────────────────────────────────────
-- Use the system clipboard for all yank/delete/paste operations (y, d, p, etc.)
vim.opt.clipboard = "unnamedplus"

if vim.fn.has("wsl") == 1 then
  -- WSL: win32yank bridges WSL → Windows clipboard
  -- Install: copy win32yank.exe to ~/.local/bin/win32yank (no .exe extension)
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = { "win32yank", "-i", "--crlf" },
      ["*"] = { "win32yank", "-i", "--crlf" },
    },
    paste = {
      ["+"] = { "win32yank", "-o", "--lf" },
      ["*"] = { "win32yank", "-o", "--lf" },
    },
    cache_enabled = true,
  }
else
  -- macOS / Linux: use Neovim's built-in OSC 52 clipboard (requires Neovim 0.10+)
  -- Works inside tmux as long as: set -g allow-passthrough on (already set)
  -- No external tools (pbcopy, xclip, wl-copy) needed.
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end


