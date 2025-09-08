---@type LazySpec[]
return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"|b",
				function()
					require("dap").toggle_breakpoint()
				end,
			},
			{
				"|c",
				function()
					require("dap").continue()
				end,
			},
			{
				"|<Up>",
				function()
					require("dap").step_out()
				end,
			},
			{
				"|<Down>",
				function()
					require("dap").step_into()
				end,
			},
			{
				"|<Right>",
				function()
					require("dap").step_over()
				end,
			},
			{
				"||",
				function()
					require("dap").disconnect()
				end,
			},
			{
				"|v",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes, { border = "rounded" })
				end,
			},
			{
				"|f",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.frames, { border = "rounded" })
				end,
			},
			{
				"|r",
				function()
					require("dap").repl.open()
				end,
			},
		},
		config = function()
			local dap = require("dap")
			local node_adapter = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug",
					args = { "${port}" },
				},
			}
			dap.adapters.node = node_adapter
			dap.adapters["pwa-node"] = node_adapter

			local configs = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					resolveSourceMapLocations = { "!**" },
					skipFiles = { "<node_internals>/**" },
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach 9229",
					port = 9229,
					cwd = "${workspaceFolder}",
					resolveSourceMapLocations = { "!**" },
					skipFiles = { "<node_internals>/**" },
				},
			}

			dap.configurations.javascript = configs
			dap.configurations.typescript = configs

			for _, group in pairs({
				"DapBreakpoint",
				"DapBreakpointCondition",
				"DapBreakpointRejected",
				"DapLogPoint",
			}) do
				vim.fn.sign_define(group, { text = "●", texthl = group, priority = 50 })
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dap-float",
				callback = function()
					vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
				end,
			})
		end,
	},
}
