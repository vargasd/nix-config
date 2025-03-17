vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.undodir = vim.fn.stdpath("state") .. "/undo//"
vim.o.undofile = true

vim.o.termguicolors = false
vim.o.mouse = "nvi"
vim.o.mousemodel = "extend"

vim.o.swapfile = false
vim.o.updatetime = 10
vim.o.timeoutlen = 300

vim.o.completeopt = "menuone,noselect"

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.autoindent = true
vim.o.smartindent = true

vim.wo.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.number = true

vim.opt.listchars = {
	tab = "· ",
	trail = "-",
}
vim.o.list = true
vim.opt.iskeyword:append("-")
vim.opt.iskeyword:append("#")

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.ruler = false

vim.opt.fillchars.stl = " "
vim.opt.fillchars.stlnc = " "

-- --#region kitty/wezterm
vim.o.laststatus = 0
-- --#endregion kitty
--#region alacritty/ghostty/tmux
-- set title dynamimcally by buffer
-- local overridetitle = ""
-- -- vim.o.laststatus = 3
-- vim.opt.title = true
-- vim.opt.titlelen = 0
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	callback = function(args)
-- 		local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
-- 		if overridetitle == "" and buftype == "" then
-- 			vim.o.titlestring = vim.fn.expand("%:p:h:t")
-- 				.. "/"
-- 				.. vim.fn.expand("%:t")
-- 				.. " ("
-- 				.. vim.fn.expand("%:~:.:h:h")
-- 				.. ")"
-- 			-- else
-- 			-- 	vim.o.titlestring = buftype
-- 		end
-- 	end,
-- })

vim.api.nvim_create_user_command("SetTitle", function(opts)
	overridetitle = opts.fargs[1]
	vim.o.titlestring = overridetitle
end, { nargs = 1 })
--#endregion
