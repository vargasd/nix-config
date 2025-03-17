require("config.options")
require("config.lazy")
require("config.keymap")

-- Diagnostics
local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	virtual_text = {
		severity = {
			min = vim.diagnostic.severity.WARN,
		},
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
