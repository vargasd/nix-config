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
			vim.g.db_ui_use_nvim_notify = 1
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
}
