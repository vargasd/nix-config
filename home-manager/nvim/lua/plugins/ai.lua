---@type LazySpec
return {
	{
		"NickvanDyke/opencode.nvim",
		init = function()
			vim.g.opencode_opts = {
				terminal = {
					win = {
						position = "float",
						enter = true,
					},
				},
			}
		end,
		keys = {
			{
				"<leader>C",
				function() require("opencode").toggle() end,
			},
			{
				"<leader>C",
				function() require("opencode").ask("@selection: ") end,
				mode = "v",
			},
			{
				"<leader>cc",
				function() require("opencode").ask() end,
				"Code companion chat add",
				mode = "n",
			},
			{
				"<leader>cf",
				function() require("opencode").select_prompt() end,
				mode = { "n", "v" },
			},
		},
	},
}
