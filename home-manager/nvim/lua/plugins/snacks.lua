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
			-- picker = { enabled = true },
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
				desc = "Show Messages",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("LspProgress", {
				---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
				callback = function(ev)
					local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
					vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
						id = "lsp_progress",
						title = "LSP Progress",
						opts = function(notif)
							notif.icon = ev.data.params.value.kind == "end" and " "
								or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
						end,
					})
				end,
			})
		end,
	},
}
