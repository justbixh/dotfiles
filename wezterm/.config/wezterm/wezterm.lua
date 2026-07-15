-- ~/.config/wezterm/wezterm.lua

local wezterm = require("wezterm")

-- ── startup ────────────────────────────────────────────────────────────
wezterm.on("gui-startup", function(cmd)
	local screen = wezterm.gui.screens().active
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	local gui_window = window:gui_window()

	-- exact size and position measured from your reference screenshot
	gui_window:set_inner_size(1029 * 2, 674 * 2)
	gui_window:set_position(screen.x + 1000, screen.y + 520)
end)

return {
	-- ── window ─────────────────────────────────────────────────────────────
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	adjust_window_size_when_changing_font_size = false,
	automatically_reload_config = true,
	-- win32_system_backdrop         = "Acrylic",

	macos_window_background_blur = 20, -- macOS-native blur
	native_macos_fullscreen_mode = true, -- use macOS's own fullscreen, not WezTerm's

	background = {
		{
			source = { Color = "#191d1f" },
			width = "100%",
			height = "100%",
			opacity = 1.35, -- 0.55
		},
	},

	-- window_padding = { left = 3, right = 3, top = 0, bottom = 0 },

	-- ── appearance ─────────────────────────────────────────────────────────
	color_scheme = "Catppuccin Frappe", -- "Batman" "Nord (Gogh)"
	-- font = wezterm.font("MesloLGS Nerd Font Mono", { weight = "Regular" }),
	font_size = 14.0,
	send_composed_key_when_left_alt_is_pressed = false, -- option works like alt
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
		{ key = "f", mods = "CMD", action = wezterm.action.ToggleFullScreen },
		{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
		{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "x", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
		{ key = "n", mods = "CMD", action = wezterm.action.SpawnWindow },
	}
}
