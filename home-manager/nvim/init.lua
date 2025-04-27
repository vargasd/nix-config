require("config.options")
require("config.lazy")
require("config.keymap")

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = "DiagnosticNumWarn",
			[vim.diagnostic.severity.ERROR] = "DiagnosticNumError",
			[vim.diagnostic.severity.INFO] = "DiagnosticNumInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticNumHint",
		},
	},
	virtual_lines = {
		current_line = true,
	},
	float = {
		source = true,
		header = "",
		prefix = "",
		border = "rounded",
	},
	update_in_insert = false,
	severity_sort = true,
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.filetype.add({
	extension = {
		jsonl = "json",
		mustache = "handlebars",
		keymap = "dts",
		overlay = "dts",
	},
	pattern = {
		[".env.*"] = "sh",
	},
})
