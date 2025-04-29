---@type LazySpec[]
return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_auto_execute_table_helpers = 1
			vim.g.db_ui_winwidth = 25
			vim.g.db_ui_execute_on_save = 0
			vim.g.vim_dadbod_completion_lowercase_keywords = 1

			vim.api.nvim_set_hl(0, "NotificationInfo", { link = "DiagnosticFloatingInfo" })
			vim.api.nvim_set_hl(0, "NotificationWarning", { link = "DiagnosticFloatingWarn" })
			vim.api.nvim_set_hl(0, "NotificationError", { link = "DiagnosticFloatingError" })
		end,
	},

	{
		"mpas/marp-nvim",
		opts = {},
		cmd = { "MarpStart", "MarpToggle" },
	},

	{
		"olimorris/codecompanion.nvim",
		opts = {
			strategies = {
				chat = { adapter = "qwen2.5-coder" },
				inline = { adapter = "qwen2.5-coder" },
				cmd = { adapter = "qwen2.5-coder" },
			},
			adapters = {
				["qwen2.5-coder"] = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen",
						schema = {
							model = {
								default = "qwen2.5-coder:14b",
							},
						},
					})
				end,
			},
			display = {
				action_palette = { show_default_prompt_library = true },
			},
		},
		init = function()
			-- credit to haus20xx - https://github.com/olimorris/codecompanion.nvim/discussions/813#discussioncomment-12289384
			require("plugins.utils.codecompanion-noice").init()
		end,
		dependencies = {
			"folke/noice.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
