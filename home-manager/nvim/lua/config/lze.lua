require("enhansi").load()

require("lze").load({
	{
		"enhansi",
		colorscheme = "enhansi",
	},
	require("plugins.editing"),
	require("plugins.git"),
	require("plugins.completion"),
	require("plugins.debug"),
	require("plugins.db"),
	require("plugins.snacks"),
	require("plugins.lsp"),
	require("plugins.ui"),
})
