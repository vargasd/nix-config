---@class KeyMapOpts: vim.keymap.set.Opts
---@field mode? string | string[]
---@type [string, string|function, KeyMapOpts?][]
local mappings = {
	{ "H", vim.diagnostic.open_float, { desc = "Open Diagnostics Float" } },
	-- Undo should be shift-u
	{ "U", "<C-r>" },
	-- center bottom
	{ "G", "Gzz", { noremap = true } },
	-- no space ops since it's the leader
	{ "<Space>", "<Nop>", { silent = true, mode = { "n", "v" } } },
	-- unhighlight on esc
	{ "<esc>", "<cmd>nohlsearch<CR><esc>", { mode = { "n", "t" } } },

	-- UI Line movement
	{ "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
	{ "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },

	-- insert/command mode emacs bindings
	{ "<C-a>", "<Home>", { mode = { "i", "c" } } },
	{ "<C-b>", "<Left>", { mode = { "i", "c" } } },
	{ "<C-d>", "<Del>", { mode = { "i", "c" } } },
	{ "<C-e>", "<End>", { mode = { "i", "c" } } },
	{ "<C-f>", "<Right>", { mode = { "i", "c" } } },
	{ "<C-n>", "<Down>", { mode = { "i", "c" } } },
	{ "<C-p>", "<Up>", { mode = { "i", "c" } } },
	{ "<M-b>", "<S-Left>", { mode = { "i", "c" } } },
	{ "<M-f>", "<S-Right>", { mode = { "i", "c" } } },

	-- clipboard
	{ "<leader>YA", ':let @+=expand("%:p")<CR>', { silent = true, desc = "Yank Absolute path" } },
	{ "<leader>YF", ':let @+=expand("%:t")<CR>', { silent = true, desc = "Yank File name" } },
	{ "<leader>YR", ':let @+=expand("%")<CR>', { silent = true, desc = "Yank Relative path" } },
	{ "<leader>y", '"*y', { desc = "Yank to system clipboard", mode = { "n", "v" } } },
	{ "<leader>p", '"*p', { desc = "Paste from system clipboard", mode = { "n", "v" } } },
	{ "<leader>P", '"*P', { desc = "Paste from system clipboard", mode = { "n", "v" } } },

	-- tabby stuff
	{ "<C-w>t", "<C-w>T", { desc = "Send to tab" } },
	{ "[t", vim.cmd.tabprevious, { desc = "Previous tab" } },
	{ "]t", vim.cmd.tabnext, { desc = "Next tab" } },

	-- quitty stuff
	{ "<leader>q", vim.cmd.bdelete, { desc = "Quit buffer" } },
	{
		"<leader>Q",
		function()
			vim.cmd.bdelete({ bang = true })
		end,
		{ desc = "Force quit buffer" },
	},
	{
		"<leader><c-q>",
		function()
			vim.cmd.qall({ bang = true })
		end,
		{ desc = "Force quit all" },
	},

	-- I hate accidentally macroing
	{ "q", "<Nop>", { silent = true } },
	{ "Q", "q", {} },

	-- savey stuff
	{ "<leader>w", vim.cmd.write, { desc = "Write" } },
	{ "<leader>W", vim.cmd.wall, { desc = "Write" } },

	{
		"<C-q>",
		function()
			local qf_exists = false
			for _, win in pairs(vim.fn.getwininfo()) do
				if win["quickfix"] == 1 then
					qf_exists = true
				end
			end
			if qf_exists == true then
				vim.cmd("cclose")
				return
			end
			if not vim.tbl_isempty(vim.fn.getqflist()) then
				vim.cmd("copen")
			end
		end,
		{ desc = "Toggle quickfix" },
	},
}

for _, mapping in ipairs(mappings) do
	local mode = mapping[3] and mapping[3].mode or "n";
	(mapping[3] or {})["mode"] = nil
	vim.keymap.set(mode, mapping[1], mapping[2], mapping[3])
end

-- Use lowercase for global marks and uppercase for local marks.
local lower = function(i)
	return string.char(97 + i)
end
local upper = function(i)
	return string.char(65 + i)
end

for i = 0, 25 do
	vim.keymap.set("n", "m" .. lower(i), "m" .. upper(i))
	vim.keymap.set("n", "'" .. lower(i), "'" .. upper(i))
	vim.keymap.set("n", "`" .. lower(i), "`" .. upper(i))
	vim.keymap.set("n", "<Tab>" .. lower(i), "`" .. upper(i))
end
