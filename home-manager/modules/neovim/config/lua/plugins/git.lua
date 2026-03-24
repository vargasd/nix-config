---@type lze.Spec[]
return {
	{
		"vim-fugitive",
		cmd = { "Git", "Gdiffsplit" },
		keys = {
			{
				"<leader>gb",
				function() vim.cmd.Git("blame") end,
			},
			{ "<leader>gd", vim.cmd.Gdiffsplit },
			{
				"<leader>g<Left>",
				function() vim.cmd.diffget("LOCAL") end,
			},
			{
				"<leader>g<Right>",
				function() vim.cmd.diffget("REMOTE") end,
			},
		},
		before = function() vim.g.fugitive_dynamic_colors = 0 end,
	},

	{
		"gitsigns.nvim",
		event = "DeferredUIEnter",
		after = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({
				current_line_blame = true,
				attach_to_untracked = true,
				on_attach = function(bufnr)
					local move = require("nvim-next.move")
					local prev, next = move.make_repeatable_pair(
						function()
							gitsigns.nav_hunk("prev", {
								navigation_message = false,
							})
						end,
						function()
							gitsigns.nav_hunk("next", {
								navigation_message = false,
							})
						end
					)

					-- don't override the built-in and fugitive keymaps
					vim.keymap.set({ "n", "v" }, "]g", function()
						if vim.wo.diff then return "]g" end
						vim.schedule(next)
						return "<Ignore>"
					end, { expr = true, buffer = bufnr })
					vim.keymap.set({ "n", "v" }, "[g", function()
						if vim.wo.diff then return "[g" end
						vim.schedule(prev)
						return "<Ignore>"
					end, { expr = true, buffer = bufnr })
					vim.keymap.set({ "n" }, "<leader>ga", gitsigns.stage_hunk)
					vim.keymap.set({ "n" }, "<leader>g<BS>", gitsigns.reset_hunk)
				end,
			})
		end,
	},
}
