-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ── Clipboard ─────────────────────────────────────────────────────────────────
-- Use the system clipboard for all yank/delete/paste operations (y, d, p, etc.)
-- On WSL: win32yank bridges WSL → Windows clipboard directly, no display server needed.
-- On macOS: pbcopy/pbpaste picked up automatically via unnamedplus.
-- On Linux with X/Wayland: xclip/xsel/wl-clipboard picked up automatically.
vim.opt.clipboard = "unnamedplus"

-- The wsl guard only fires on WSL — macOS and bare Linux automatically use their native providers (pbcopy, xclip, wl-clipboard) via the unnamedplus chain.
if vim.fn.has("wsl") == 1 then
  -- win32yank.exe must be on PATH or in ~/.local/bin
  -- Install: copy win32yank.exe to ~/.local/bin/win32yank (already done)
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
end
