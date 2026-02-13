local wezterm = require("wezterm") --[[@as Wezterm]]
local io = require("io")
local os = require("os")
local act = wezterm.action

local M = {}

-- this should really be in data but oh wezterm doesn't expose that
local workspace_path = wezterm.config_dir .. "/workspaces.json"

local save_workspaces = function()
	local f = io.open(workspace_path, "w")
	f:write(wezterm.json_encode(wezterm.GLOBAL.workspaces))
	f:flush()
	f:close()
end

function shellexpand(path)
	local home = os.getenv("HOME")
	return path:gsub("^~", home)
end

function shellcondense(path)
	local home = os.getenv("HOME")
	return path:gsub("^" .. home, "~")
end

function M.apply_to_config(config)
	wezterm.on("gui-startup", function()
		local f = io.open(workspace_path, "r")

		if f ~= nil then
			wezterm.GLOBAL.workspaces = wezterm.json_parse(f:read("*all")) or {}
			f:close()
		end

		for name, cfg in pairs(wezterm.GLOBAL.workspaces) do
			wezterm.mux.spawn_window({
				workspace = name,
				cwd = cfg.dir,
			})
		end
	end)

	table.insert(config.keys, {
		key = "a",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			local dir = pane:get_current_working_dir().file_path
			local name = shellcondense(dir)
			wezterm.GLOBAL.workspaces[name] = { dir = dir }
			save_workspaces()

			window:perform_action(act.SwitchToWorkspace({ name = name }), pane)
		end),
	})

	table.insert(config.keys, {
		key = "d",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win)
			wezterm.GLOBAL.workspaces[win:active_workspace()] = nil
			save_workspaces()
		end),
	})
end

return M
