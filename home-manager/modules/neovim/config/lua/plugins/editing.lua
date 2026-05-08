---@type lze.Spec[]
return {
	{ "vim-sleuth", event = "DeferredUIEnter" },

	{
		"flash.nvim",
		keys = {
			{
				"s",
				mode = { "n", "v" },
				function()
					require("flash").jump({
						search = {
							mode = function(str) return "\\<" .. str end,
						},
					})
				end,
			},
		},
		after = function()
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
		"mini.surround",
		event = "DeferredUIEnter",
		after = function()
			require("mini.surround").setup({
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
			})
		end,
	},

	{
		"nvim-next",
		dep_of = { "gitsigns.nvim", "nvim-treesitter-textobjects" },
		event = "DeferredUIEnter",
		after = function()
			local builtins = require("nvim-next.builtins")
			local move = require("nvim-next.move")
			local next_integrations = require("nvim-next.integrations")
			local diag_prev, diag_next = move.make_repeatable_pair(function()
				vim.diagnostic.jump({
					count = -1,
					on_jump = function() vim.diagnostic.open_float() end,
				})
			end, function()
				vim.diagnostic.jump({
					count = 1,
					on_jump = function() vim.diagnostic.open_float() end,
				})
			end)
			local qf = next_integrations.quickfix()

			require("nvim-next").setup({
				items = {
					builtins.f,
					builtins.t,
				},
			})

			vim.keymap.set({ "n", "x", "o" }, ",", move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ";", move.repeat_last_move_opposite)

			vim.keymap.set({ "n", "x", "o" }, "[d", diag_prev)
			vim.keymap.set({ "n", "x", "o" }, "]d", diag_next)
			vim.keymap.set("n", "[q", qf.cprevious)
			vim.keymap.set("n", "]q", qf.cnext)
		end,
	},
}
