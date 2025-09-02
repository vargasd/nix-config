---@type LazySpec
return {
	{
		"NickvanDyke/opencode.nvim",
		opts = {
			terminal = {
				win = {
					position = "float",
					enter = true,
				},
			},
		},
		keys = {
			{
				"<leader>C",
				function()
					require("opencode").toggle()
				end,
			},
			{
				"<leader>C",
				function()
					require("opencode").ask("@selection: ")
				end,
				mode = "v",
			},
			{
				"<leader>cc",
				function()
					require("opencode").ask()
				end,
				"Code companion chat add",
				mode = "n",
			},
			{
				"<leader>cf",
				function()
					require("opencode").select_prompt()
				end,
				mode = { "n", "v" },
			},
		},
	},
}
