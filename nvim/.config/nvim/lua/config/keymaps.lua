-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy to system clipboard on mouse release in Visual mode
vim.keymap.set("v", "<LeftRelease>", '"+ygv', { desc = "Copy mouse selection to system clipboard" })

-- jj → Escape in insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
