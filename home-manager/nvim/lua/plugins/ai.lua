---@type LazySpec
return {
	{
		"olimorris/codecompanion.nvim",
		keys = {
			{
				"<leader>C",
				function()
					vim.cmd.CodeCompanionChat("Toggle")
				end,
				"Toggle code companion",
				mode = "n",
			},
			{
				"<leader>C",
				function()
					vim.cmd.CodeCompanionChat("Add")
				end,
				"Code companion chat add",
				mode = "v",
			},
			{ "<leader>cf", vim.cmd.CodeCompanionActions, "Code companion actions" },
		},
		opts = {
			strategies = {
				chat = { adapter = "qwen3" },
				inline = { adapter = "qwen3" },
				cmd = { adapter = "qwen3" },
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
				qwen3 = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen",
						schema = {
							model = {
								default = "qwen3:30b-a3b",
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
			require("plugins.ai.noice").init()
		end,
		dependencies = {
			"folke/noice.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
