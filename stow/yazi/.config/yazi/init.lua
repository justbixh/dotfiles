-- ~/.config/yazi/init.lua

-- ── git status in file listing ────────────────────────────────────────────────
require("git"):setup()

-- ── show full path in header ──────────────────────────────────────────────────
Header:children_add(function()
  if cx.active.preview.skip == 0 then return ui.Line {} end
  return ui.Line {
    ui.Span(string.format("  %d%%", cx.active.preview.skip * 100 // cx.active.preview.total)),
  }
end, 500, Header.RIGHT)

-- ── header: show current git branch ──────────────────────────────────────────
Header:children_add(function()
  local branch = ya.sync(function()
    return cx.active.current.cwd
  end)
  return ui.Line { ui.Span(" ") }
end, 500, Header.RIGHT)

-- ── status bar: show file permissions ────────────────────────────────────────
Status:children_add(function()
  local h = cx.active.current.hovered
  if not h then return ui.Line {} end
  return ui.Line {
    ui.Span("  " .. ya.readable_size(h:size() or 0)):fg("blue"),
  }
end, 500, Status.RIGHT)

-- ── augment-command: better rename, create etc. ───────────────────────────────
-- requires: ya pack -a yazi-rs/plugins#augment-command
require("augment-command"):setup({
    prompt = true,
    default_item_group_for_prompt = "hovered",
})

-- Plugins to install (run once):
-- ya pack -a yazi-rs/plugins#git
-- ya pack -a yazi-rs/plugins#augment-command
-- ya pack -a yazi-rs/flavors#catppuccin-mocha