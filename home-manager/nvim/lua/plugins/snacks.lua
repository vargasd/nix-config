---@module 'snacks'
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
			picker = {
				enabled = true,
				win = {
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
							["<a-a>"] = { "select_all", mode = { "i", "n" } },
							["<c-a>"] = { "<home>", mode = { "i" }, replace_keycodes = true, expr = true },
							["<c-u>"] = { "<c-u>", mode = { "i" }, replace_keycodes = true, expr = true },
							["<a-f>"] = { "<s-right>", mode = { "i" }, replace_keycodes = true, expr = true },
						},
					},
				},
				prompt = "> ", -- no fancy stuff here
				layouts = {
					samvert = {
						layout = {
							backdrop = false,
							width = 0.8,
							min_width = 80,
							height = 0.8,
							min_height = 30,
							box = "vertical",
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", min_height = 25, height = 0.4, border = "top" },
						},
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
