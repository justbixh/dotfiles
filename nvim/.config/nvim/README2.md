Depends on which file explorer you're using in LazyVim — by default that's **Neo-tree** (`<leader>e` or `<leader>fe` typically toggles it in LazyVim).

**In Neo-tree:**

1. Open it: `<leader>e`
2. Navigate to (or select) the directory where you want the new file
3. Press `a` — prompts for a filename
4. Type the name, including subdirs if needed (e.g. `foo/bar.go` creates the `foo` dir too) and hit Enter

Other useful Neo-tree keys while you're there:

- `A` → create a directory
- `d` → delete
- `r` → rename
- `c` → copy
- `x` / `p` → cut / paste
- `R` → refresh tree

**If you're using Telescope/oil.nvim/mini.files instead** (some LazyVim setups swap the default explorer), the keybind differs:

- **oil.nvim**: just edit the buffer like a normal text buffer — type a new filename as a line and save (`:w`) to create it
- **mini.files**: press `N` typically, or check `:Mini` docs

Which one are you actually running — can you check with `:Lazy` and search for `neo-tree`, or tell me what pops up when you press `<leader>e`?
