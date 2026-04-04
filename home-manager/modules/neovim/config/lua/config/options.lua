vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.undodir = vim.fn.stdpath("state") .. "/undo//"
vim.o.undofile = true

vim.o.termguicolors = false
vim.o.guicursor = "a:block-blinkon0,i-ci-ve:ver25,r-cr-o:hor20"
vim.o.mouse = "nvi"
vim.o.mousemodel = "extend"

vim.o.swapfile = false
vim.o.updatetime = 10

vim.o.completeopt = "menuone,noselect"

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.sessionoptions = "buffers,sesdir"

vim.wo.signcolumn = "yes"
vim.o.number = true

-- until noice supports using this, we'll just go with what they use :(
vim.o.winborder = "single"

vim.opt.listchars = {
	tab = "· ",
	trail = "-",
}
vim.o.list = true
vim.opt.iskeyword:append("-")
vim.opt.iskeyword:append("#")

vim.opt.isfname:append("@-@")

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.ruler = false

vim.opt.fillchars.stl = " "
vim.opt.fillchars.stlnc = " "

vim.o.laststatus = 0
vim.o.statusline = " "
