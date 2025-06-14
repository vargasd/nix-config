---@type LazySpec[]
return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", lazy = true },
		event = "InsertEnter",
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
				["<C-x>"] = { "show" },
			},
			completion = {
				documentation = { auto_show = true },
				menu = { border = "none", auto_show = true },
			},
			sources = {
				default = { "lsp", "buffer", "path", "snippets" },
				per_filetype = {
					sql = { "dadbod", "lsp", "buffer" },
					lua = { "lazydev", "lsp", "buffer", "snippets", "path" },
				},
				providers = {
					dadbod = { module = "vim_dadbod_completion.blink" },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
		},
	},
}
