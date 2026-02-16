---@type lze.Spec[]
return {
	{

		{ "vim-dadbod", dep_of = "vim-dadbod-ui" },

		{
			"vim-dadbod-completion",
			on_plugin = "vim-dadbod-ui",
			before = function() vim.g.vim_dadbod_completion_lowercase_keywords = 1 end,
			after = function()
				local blink = require("blink.cmp")
				local source = "dadbod"
				blink.add_source_provider(source, {
					module = "vim_dadbod_completion.blink",
				})
				blink.add_filetype_source("sql", source)
			end,
		},

		{
			"vim-dadbod-ui",
			cmd = {
				"DBUI",
				"DBUIToggle",
				"DBUIAddConnection",
				"DBUIFindBuffer",
			},
			before = function()
				vim.g.db_ui_use_nerd_fonts = 1
				vim.g.db_ui_auto_execute_table_helpers = 1
				vim.g.db_ui_winwidth = 25
				vim.g.db_ui_execute_on_save = 0
				vim.g.db_ui_use_nvim_notify = 1
			end,
		},
	},
}
