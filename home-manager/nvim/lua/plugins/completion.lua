---@diagnostic disable: missing-fields
---@type lze.Spec[]
return {
	-- TODO: move to dap
	{ "blink.compat", dep_of = "cmp-dap" },
	{ "cmp-dap", dep_of = "blink.cmp" },

	{
		"blink.cmp",
		event = "InsertEnter",
		after = function()
			---@diagnostic disable-next-line: param-type-mismatch
			require("blink.cmp").setup({
				keymap = {
					preset = "enter",
					["<C-x>"] = { "show" },
				},
				completion = {
					documentation = { auto_show = true },
					menu = { border = "none", auto_show = true },
					list = { selection = { preselect = false } },
				},
				sources = {
					default = { "lsp", "buffer", "path", "omni", "snippets" },
					per_filetype = {
						sql = { "dadbod", "lsp", "buffer" },
						["dap-repl"] = { "dap", "lsp", "buffer" },
					},
					providers = {
						dadbod = { module = "vim_dadbod_completion.blink" },
						dap = { name = "dap", module = "blink.compat.source" },
					},
				},
			})
			vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
		end,
	},
}
