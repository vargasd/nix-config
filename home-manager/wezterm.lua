local wezterm = require("wezterm") --[[@as Wezterm]]
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

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

-- config.color_scheme = "Atlas (base16)"
-- config.color_scheme = "GruvboxDark"
config.color_scheme = "Popping and Locking"
-- config.color_scheme = "atlas-mod"
config.bold_brightens_ansi_colors = "No"
config.quick_select_alphabet = "arstqwfpzxcvneioluymdhgjbk"
-- config.unzoom_on_switch_pane = false

config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		mods = "ALT",
		key = "1",
		action = act.Multiple({
			act.SetPaneZoomState(false),
			act.ActivatePaneByIndex(0),
			act.SetPaneZoomState(true),
		}),
	},
	{
		mods = "ALT",
		key = "2",
		action = act.Multiple({
			act.SetPaneZoomState(false),
			act.ActivatePaneByIndex(1),
			act.SetPaneZoomState(true),
		}),
	},
	{
		mods = "ALT",
		key = "3",
		action = act.Multiple({
			act.SetPaneZoomState(false),
			act.ActivatePaneByIndex(2),
			act.SetPaneZoomState(true),
		}),
	},
	{
		mods = "ALT",
		key = "4",
		action = act.Multiple({
			act.SetPaneZoomState(false),
			act.ActivatePaneByIndex(3),
			act.SetPaneZoomState(true),
		}),
	},
	{
		mods = "ALT",
		key = "5",
		action = act.Multiple({
			act.SetPaneZoomState(false),
			act.ActivatePaneByIndex(4),
			act.SetPaneZoomState(true),
		}),
	},
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
	{
		key = "o",
		mods = "CTRL|SHIFT",
		action = act.QuickSelectArgs({
			patterns = { "https?://[^\\s]+" },
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.open_with(url)
			end),
		}),
	},
	{
		key = "s",
		mods = "CTRL|SHIFT",
		action = workspace_switcher.switch_workspace(),
	},
	-- defaults I don't like
	{ mods = "ALT", key = "Enter", action = act.DisableDefaultAssignment },
	{ mods = "CMD", key = "m", action = act.DisableDefaultAssignment },
	{ mods = "CMD", key = "h", action = act.DisableDefaultAssignment },
}

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

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)

	return {
		{ Background = { AnsiColor = tab.is_active and "Yellow" or "Gray" } },
		{ Foreground = { AnsiColor = "Black" } },
		{
			Text = " " .. title .. " ",
		},
		{ Background = { AnsiColor = "Green" } },
	}
end)

config.default_workspace = "~"
-- loads the state whenever I create a new workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

-- Saves the state whenever I select a workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	resurrect.state_manager.save_state(workspace_state.get_workspace_state())
end)
workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { AnsiColor = "Green" } },
		{ Background = { Color = "black" } },
		{ Text = "󱂬: " .. label },
	})
end
wezterm.on("gui-startup", function()
	resurrect.state_manager.resurrect_on_gui_startup()
end)
resurrect.state_manager.periodic_save({
	interval_seconds = 60 * 5,
	save_windows = true,
	save_sessions = true,
})

workspace_switcher.apply_to_config(config)
return config
