---@type LazySpec
return {
	{ "tpope/vim-sleuth", event = "VeryLazy" },

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "InsertEnter",
		opts = {
			indent = { char = "·" },
			scope = { enabled = false },
			whitespace = { remove_blankline_trail = true },
		},
	},

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
				add = "<C-s>a", -- Add surrounding in Normal and Visual modes
				delete = "<C-s>d", -- Delete surrounding
				find = "<C-s>f", -- Find surrounding (to the right)
				find_left = "<C-s>F", -- Find surrounding (to the left)
				highlight = "<C-s>h", -- Highlight surrounding
				replace = "<C-s>r", -- Replace surrounding
				update_n_lines = "", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		},
	},
}
