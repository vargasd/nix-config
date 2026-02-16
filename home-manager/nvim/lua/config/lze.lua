vim.cmd.colorscheme("enhansi")

require("lze").load({
	require("plugins.editing"),
	require("plugins.git"),
	require("plugins.completion"),
	require("plugins.debug"),
	require("plugins.db"),
	require("plugins.snacks"),
	require("plugins.lsp"),
	require("plugins.ui"),
})
