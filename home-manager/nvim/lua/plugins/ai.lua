---@type LazySpec
return {
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		build = "bundled_build.lua",
		cmd = "MCPHub",
		opts = {
			use_bundled_binary = true,
			auto_approve = true,
		},
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		config = function()
			require("copilot").setup({})
		end,
	},

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = { "CodeCompanionChat", "CodeCompanionInline", "CodeCompanion", "CodeCompanionCmd" },
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
			{ "<leader>cf", vim.cmd.CodeCompanionActions, "Code companion actions", mode = { "n", "v" } },
			{ "<leader>cc", ":CodeCompanion ", "Code companion inline", mode = { "n", "v" } },
		},
		opts = {
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						show_result_in_chat = true,
						make_vars = true,
						make_slash_commands = true,
					},
				},
			},
			strategies = {
				chat = {
					-- adapter = "qwen3",
					tools = {
						opts = {
							requires_approval = false,
							auto_submit_errors = true, -- Send any errors to the LLM automatically?
							auto_submit_success = true, -- Send any successful output to the LLM automatically?
						},
					},
					keymaps = {
						clear = { modes = { n = "g<BS>" } },
					},
				},
				-- inline = { adapter = "qwen3" },
				-- cmd = { adapter = "qwen3" },
			},
			adapters = {
				-- copilot = function()
				-- 	return require("codecompanion.adapters").extend("copilot", {
				-- 		schema = {
				-- 			model = {
				-- 				default = "claude-3.5-sonnet",
				-- 			},
				-- 		},
				-- 	})
				-- end,
				qcode = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen",
						schema = {
							model = {
								default = "qwen2.5-coder:14b",
							},
						},
					})
				end,
				q3 = function()
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
			-- require("plugins.ai.noice").init()
			-- credit to mbriggs - https://github.com/olimorris/codecompanion.nvim/discussions/912#discussion-7961073
			require("plugins.ai.notifier").setup()
			vim.g.codecompanion_auto_tool_mode = true
			vim.g.mcphub_auto_approve = true
		end,
	},
}
