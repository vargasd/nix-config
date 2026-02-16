---@diagnostic disable: missing-fields
---@type lze.Spec[]
return {
	{
		"blink.cmp",
		event = "InsertEnter",
		dep_of = { "vim-dadbod-completion" },
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
			})
			vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
		end,
	},
}
