local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():center()
end)

return {

	-- ── startup ────────────────────────────────────────────────────────────
	default_prog = { "wsl.exe", "--distribution", "Ubuntu" },
	initial_cols = 105,
	initial_rows = 30,

	-- ── window ─────────────────────────────────────────────────────────────
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	-- win32_system_backdrop         = "Acrylic",

	adjust_window_size_when_changing_font_size = false,
	automatically_reload_config = true,

	background = {
		{
			source = { Color = "#191d1f" },
			width = "100%",
			height = "100%",
			opacity = 0.3, -- 0.55
		},
	},

	-- window_padding = { left = 3, right = 3, top = 0, bottom = 0 },

	-- ── appearance ─────────────────────────────────────────────────────────
	color_scheme = "Catppuccin Frape", -- "Batman" "Nord (Gogh)"
	font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Regular" }),
	font_size = 12.5,
	enable_tab_bar = false,
	default_cursor_style = "BlinkingBar",

	colors = {
		foreground = "#CBE0F0",
		background = "#011423",
		cursor_bg = "#47FF9C",
		cursor_border = "#47FF9C",
		cursor_fg = "#011423",
		selection_bg = "#033259",
		selection_fg = "#CBE0F0",
		ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
		brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
	},

	-- window_padding = {
	--   left = 3,
	--   right = 3,
	--   top = 0,
	--   bottom = 0,
	-- },

	-- ── mouse ──────────────────────────────────────────────────────────────
	mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},

	-- ── keys ───────────────────────────────────────────────────────────────
	keys = {
		{ key = "x", mods = "ALT", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "q", mods = "CTRL", action = wezterm.action.ToggleFullScreen },
		{ key = "w", mods = "CTRL", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	},
}
