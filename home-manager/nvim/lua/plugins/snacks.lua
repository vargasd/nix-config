---@type LazySpec
return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			-- dashboard = { enabled = true },
			-- picker = { enabled = true },
			quickfile = { enabled = true },
	},
}
