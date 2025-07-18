---@type LazySpec
return {
	{ "tpope/vim-sleuth", event = "VeryLazy" },

	{
		"folke/flash.nvim",
		keys = {
			{
				"s",
				mode = { "n", "v" },
				function()
					require("flash").jump({
						search = {
							mode = function(str)
								return "\\<" .. str
							end,
						},
					})
				end,
				desc = "Flash",
			},
		},
		config = function()
			require("flash").setup({
				labels = "arstgmneiozxcdvkqwfpbjluy",
				modes = {
					search = {
						enabled = false,
					},
					char = {
						enabled = false,
					},
				},
			})
		end,
	},

	{
		"mg979/vim-visual-multi",
		keys = {
			{ "<C-Down>", "<Plug>(VM-Add-Cursor-Down)" },
			{ "<C-Up>", "<Plug>(VM-Add-Cursor-Up)" },
			{ "<C-n>", "<Plug>(VM-Find-Under)" },
		},
	},

	{
		"echasnovski/mini.surround",
		version = "*",
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "Sa",
				delete = "Sd",
				replace = "Sr",
				-- these will set horrible defaults if not blank
				find = "",
				find_left = "",
				highlight = "",
				update_n_lines = "",

				suffix_last = "l",
				suffix_next = "n",
			},
		},
	},
}
