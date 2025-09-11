---@type LazySpec[]
return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"|`",
				function() require("dap").toggle_breakpoint() end,
			},
			{
				"|b",
				function() require("dap").toggle_breakpoint() end,
			},
			{
				"|B",
				function() require("dap").toggle_breakpoint(vim.fn.input("condition: ")) end,
			},
			{
				"|_",
				function() require("dap").continue() end,
			},
			{
				"|c",
				function() require("dap").continue() end,
			},
			{
				"|<Up>",
				function() require("dap").step_out() end,
			},
			{
				"|<Down>",
				function() require("dap").step_into() end,
			},
			{
				"|<Right>",
				function() require("dap").step_over() end,
			},
			{
				"|q",
				function() require("dap").disconnect() end,
			},
			{
				"|d",
				function() require("dap.ui.widgets").hover() end,
			},
			{
				"||",
				function() require("dap.ui.widgets").hover() end,
			},
			{
				"|<Left>",
				function() require("dap").step_back() end,
			},
			{
				"|v",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes, { border = "rounded" })
				end,
			},
			{
				"|s",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.frames, { border = "rounded" })
				end,
			},
			{
				"|r",
				function() require("dap").repl.open() end,
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

			vim.fn.sign_define("DapBreakpoint", { text = "●" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "⊛" })
			vim.fn.sign_define("DapLogPoint", { text = "⊙" })
			-- vscode-js-debug will reject breakpoints but still hit them, so don't differentiate: https://github.com/mfussenegger/nvim-dap/issues/1522
			vim.fn.sign_define("DapBreakpointRejected", { text = "●" })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dap-float",
				callback = function() vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true }) end,
			})
		end,
	},
}
