---@type LazySpec[]
return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
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
				menu = { border = "none" },
			},
			sources = {
				-- `lsp`, `buffer`, `snippets`, `path` and `omni` are built-in
				-- so you don't need to define them in `sources.providers`
				default = { "lsp", "buffer", "snippets", "path" },

				per_filetype = { sql = { "dadbod" } },
				providers = {
					dadbod = { module = "vim_dadbod_completion.blink" },
				},
			},
		},
	},
}
