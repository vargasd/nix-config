---@diagnostic disable: missing-fields, undefined-field, need-check-nil
local wezterm = require("wezterm") --[[@as Wezterm]]
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local io = require("io")
local os = require("os")

local act = wezterm.action
local config = wezterm.config_builder()

config.cursor_blink_rate = 0
config.tab_bar_at_bottom = true
config.audible_bell = "Disabled"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_max_width = 1000
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 16
config.use_resize_increments = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.default_workspace = "~"
config.term = "wezterm"
config.set_environment_variables = {
	SAMTERM = "wezterm",
}

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- config.color_scheme = "Atlas (base16)"
-- config.color_scheme = "GruvboxDark"
-- config.color_scheme = "Popping and Locking"
config.color_scheme = "bluvbox"
config.bold_brightens_ansi_colors = "No"
config.quick_select_alphabet = "arstqwfpzxcvneioluymdhgjbk"
-- config.unzoom_on_switch_pane = false

local goto_pane = function(idx)
	return act.Multiple({
		act.SetPaneZoomState(false),
		act.ActivatePaneByIndex(idx),
		act.SetPaneZoomState(true),
	})
end

local open_link = act.QuickSelectArgs({
	patterns = { "https?://[^\\s]+" },
	action = wezterm.action_callback(function(window, pane)
		local url = window:get_selection_text_for_pane(pane)
		wezterm.open_with(url)
	end),
})

config.keys = {
	{ mods = "ALT", key = "1", action = goto_pane(0) },
	{ mods = "ALT", key = "2", action = goto_pane(1) },
	{ mods = "ALT", key = "3", action = goto_pane(2) },
	{ mods = "ALT", key = "4", action = goto_pane(3) },
	{ mods = "ALT", key = "5", action = goto_pane(4) },
	{ mods = "ALT", key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
	{ mods = "ALT", key = "RightArrow", action = act.ActivatePaneDirection("Right") },
	{ mods = "ALT", key = "UpArrow", action = act.ActivatePaneDirection("Up") },
	{ mods = "ALT", key = "DownArrow", action = act.ActivatePaneDirection("Down") },
	{ mods = "ALT|SHIFT", key = "LeftArrow", action = act.SplitPane({ direction = "Left" }) },
	{ mods = "ALT|SHIFT", key = "RightArrow", action = act.SplitPane({ direction = "Right" }) },
	{ mods = "ALT|SHIFT", key = "UpArrow", action = act.SplitPane({ direction = "Up" }) },
	{ mods = "ALT|SHIFT", key = "DownArrow", action = act.SplitPane({ direction = "Down" }) },
	{ mods = "ALT|SHIFT", key = "*", action = act.TogglePaneZoomState },
	{ mods = "CTRL|SHIFT", key = "w", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "o", mods = "CTRL|SHIFT", action = open_link },
	{ key = "s", mods = "CTRL|SHIFT", action = workspace_switcher.switch_workspace() },
	{ key = "z", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCopyMode },
	{ key = "x", mods = "CTRL|SHIFT", action = act.EmitEvent("trigger-vim-with-scrollback") },
	-- defaults I don't like
	{ mods = "ALT", key = "Enter", action = act.DisableDefaultAssignment },
	{ mods = "CMD", key = "m", action = act.DisableDefaultAssignment },
	{ mods = "CMD", key = "h", action = act.DisableDefaultAssignment },
}

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
	local text = pane:get_lines_as_escapes(pane:get_dimensions().scrollback_rows)

	local name = os.tmpname()
	local f = io.open(name, "w+")
	f:write(text)
	f:flush()
	f:close()

	window:perform_action(
		act.SpawnCommandInNewTab({
			args = { os.getenv("SHELL"), "-c", "nvim -c ':set nowrap nonumber signcolumn=no' ansify://" .. name },
			cwd = "/",
		}),
		pane
	)

	wezterm.sleep_ms(1000)
	os.remove(name)
end)

workspace_switcher.apply_to_config(config)
return config
