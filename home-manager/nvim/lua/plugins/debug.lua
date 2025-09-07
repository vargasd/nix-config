return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug",
					args = { "${port}" },
				},
			}
			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}
		end,
	},

	-- this always freezes
	-- {
	--     "igorlfs/nvim-dap-view",
	--     ---@module 'dap-view'
	--     ---@type dapview.Config
	--     opts = {},
	-- },

	{
		"rcarriga/nvim-dap-ui",
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "➜" },
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.33 },
							{ id = "breakpoints", size = 0.17 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40, -- width of left panel
						position = "left",
					},
					{
						elements = {
							"repl",
							"console",
						},
						size = 10, -- height of bottom panel
						position = "bottom",
					},
				},
				controls = {
					enabled = true,
					element = "repl",
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
			})
			-- Auto open/close dap-ui
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
			-- Keymap to toggle dap-ui
			vim.keymap.set("n", "<leader>B", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>D", function()
				dap.continue()
				dapui.toggle()
			end)
			-- vim.keymap.set("n", "<Home>", dap.step_back)
			vim.keymap.set("n", "<PageUp>", dap.step_out)
			vim.keymap.set("n", "<PageDown>", dap.step_into)
			vim.keymap.set("n", "<End>", dap.step_over)
		end,
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},
}
