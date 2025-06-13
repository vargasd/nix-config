---@diagnostic disable: missing-fields, inject-field
---@module 'snacks'
---@type snacks.win.Config
local float_win = {
	relative = "editor",
	backdrop = false,
	width = 0.9,
	height = 0.9,
	border = "rounded",
}
---@type LazySpec
return {
	{
		"folke/snacks.nvim",

		dependencies = {
			{
				"olimorris/persisted.nvim",
				event = "VeryLazy",
				opts = {
					autostart = false,
				},
			},
		},

		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				preset = {
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{
							icon = " ",
							key = "/",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "s",
							desc = "Start/Restore Session",
							action = function()
								require("persisted").start()
								require("persisted").load()
							end,
						},
						{ icon = "󰙅 ", key = "e", desc = "Yazi", action = ":Yazi" },
						{ icon = " ", key = "d", desc = "DBUI", action = ":bd | DBUI" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					function()
						math.randomseed(os.time())
						local shuffled = {}
						for _, v in ipairs({
							[[███    ██ ███████  ██████  ██    ██ ██ ███    ███]],
							[[████   ██ ██      ██    ██ ██    ██ ██ ████  ████]],
							[[██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██]],
							[[██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██]],
							[[██   ████ ███████  ██████    ████   ██ ██      ██]],
						}) do
							local pos = math.random(1, #shuffled + 1)
							table.insert(shuffled, pos, v)
						end
						return {
							header = table.concat(shuffled, "\n"),
							align = "center",
							padding = 2,
						}
					end,
					{ section = "keys", gap = 1, padding = 1 },
					{ title = "Sessions", padding = 1 },
					{ section = "projects", padding = 1 },
				},
			},
			image = { enabled = true },
			lazygit = { configure = false },
			picker = {
				enabled = true,
				toggles = {
					tests = "",
				},
				formatters = {
					file = {
						filename_first = true,
						truncate = 60,
					},
					selected = {
						show_always = true,
						unselected = false,
					},
				},
				icons = {
					files = { enabled = false },
				},
				transform = function(item, ctx)
					local disallowed = ".spec.ts"
					local allowed = ctx.picker.opts.tests
						or not (item.file and item.file:sub(-#disallowed) == disallowed)
					return allowed
				end,
				tests = true,
				actions = {
					toggle_tests = function(picker)
						picker.opts.tests = not picker.opts.tests
						picker:find()
					end,
				},
				win = {
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
							["<a-a>"] = { "select_all", mode = { "i", "n" } },
							["<c-a>"] = { "<home>", mode = { "i" }, replace_keycodes = true, expr = true },
							["<c-u>"] = { "<c-u>", mode = { "i" }, replace_keycodes = true, expr = true },
							["<a-f>"] = { "<s-right>", mode = { "i" }, replace_keycodes = true, expr = true },
							["<a-t>"] = { "toggle_tests", mode = { "i", "n" } },
						},
					},
				},
				sources = {
					grep = {
						finder = function(opts, ctx)
							local glob = "!**/*.spec.ts"
							local globs = type(opts.glob) == "table" and opts.glob or { opts.glob }
							opts.glob = vim.tbl_filter(function(arg)
								return arg ~= glob
							end, globs)
							if not opts.tests then
								table.insert(opts.glob, glob)
							end
							return require("snacks.picker.source.grep").grep(opts, ctx)
						end,
					},
					smart = { formatters = { file = { filename_first = false, truncate = 80 } } },
					files = { formatters = { file = { filename_first = false, truncate = 80 } } },
				},
				prompt = "> ", -- no fancy stuff here
				layouts = {
					samvert = {
						layout = vim.tbl_extend("error", float_win, {
							box = "vertical",
							title = "{title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", min_height = 15, height = 0.4, border = "top" },
						}),
					},
				},
				layout = {
					cycle = true,
					preset = function()
						return vim.o.columns >= 200 and "default" or "samvert"
					end,
				},
			},
			notifier = {
				enabled = true,
				top_down = false,
				style = function(buf, notif, ctx)
					ctx.opts.border = "none"
					local whl = ctx.opts.wo.winhighlight
					ctx.opts.wo.winhighlight = whl:gsub(ctx.hl.msg, "SnacksNotifierMinimal")
					vim.api.nvim_buf_set_lines(
						buf,
						0,
						-1,
						false,
						vim.tbl_map(function(msg)
							return msg .. "   "
						end, vim.split(notif.msg, "\n"))
					)
					vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
						virt_text = { { notif.icon, ctx.hl.icon }, { " " } },
						virt_text_pos = "inline",
					})
				end,
			},
			quickfile = { enabled = true },
			terminal = {
				win = vim.tbl_extend("error", float_win, {
					keys = {
						{ "<c-q>", "hide", mode = "t" },
						{
							"<c-z>",
							function()
								vim.cmd("stopinsert")
							end,
							mode = "t",
						},
						{ "<esc>", "<esc>", mode = "t", expr = true },
					},
				}),
			},
		},
		keys = {
			{
				"<leader>m",
				function()
					Snacks.notifier.show_history()
				end,
			},
			{
				"<leader>o",
				function()
					Snacks.picker.lsp_symbols({
						filter = {
							default = {
								"Class",
								"Constructor",
								"Function",
								"Method",
								"Module",
								"Namespace",
								"Package",
							},
						},
					})
				end,
			},
			{
				"<leader>O",
				function()
					Snacks.picker.lsp_symbols()
				end,
			},
			{
				"grd",
				function()
					Snacks.picker.lsp_definitions()
				end,
			},
			{
				"grr",
				function()
					Snacks.picker.lsp_references()
				end,
			},
			{
				"gri",
				function()
					Snacks.picker.lsp_implementations()
				end,
			},
			{
				"gry",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
			},
			{
				"<leader>/",
				function()
					Snacks.picker.grep({
						hidden = true,
					})
				end,
			},
			{
				"<leader>?",
				function()
					Snacks.picker.grep_word({
						hidden = true,
					})
				end,
			},
			{
				"<leader><leader>",
				function()
					Snacks.picker.resume()
				end,
			},
			{
				"<leader>f",
				function()
					Snacks.picker.smart()
				end,
			},
			{
				"<leader>F",
				function()
					Snacks.picker.files({
						hidden = true,
						ignored = true,
					})
				end,
			},
			{
				"<leader>b",
				function()
					Snacks.picker.buffers({
						current = false,
						sort_lastused = true,
					})
				end,
			},
			{
				"<leader>B",
				function()
					Snacks.picker.recent()
				end,
			},
			{
				"<leader>d",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
			},
			{
				"<leader>D",
				function()
					Snacks.picker.diagnostics()
				end,
			},
			{
				"<leader>h",
				function()
					Snacks.picker.help()
				end,
			},
			{
				"<leader>H",
				function()
					Snacks.picker.highlights()
				end,
			},
			{
				"<leader>gh",
				function()
					Snacks.lazygit.log_file()
				end,
			},
			{
				"<leader>G",
				function()
					Snacks.lazygit.open()
				end,
			},
			{
				"<leader>t",
				function()
					Snacks.terminal.toggle(vim.o.shell)
				end,
			},
			{
				"<leader>T",
				function()
					Snacks.terminal.toggle(vim.o.shell, { cwd = vim.fn.expand("%:p:h") })
				end,
			},
		},
		init = function()
			vim.g.snacks_animate = false

			vim.api.nvim_create_autocmd("LspProgress", {
				---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
				callback = function(ev)
					vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
						id = "lsp_progress",
						title = "LSP Progress",
						opts = function(notif)
							notif.icon = ev.data.params.value.kind == "end" and " " or ""
						end,
					})
				end,
			})
		end,
	},
}
