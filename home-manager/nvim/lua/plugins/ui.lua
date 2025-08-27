local markdown_fts = { "markdown", "codecompanion" }

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(ev)
		vim.defer_fn(function()
			local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(ev.buf))
			if ok and size < 1024 * 1024 then
				vim.opt.foldmethod = "expr"
				vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
				vim.opt.foldtext = ""

				vim.opt.foldnestmax = 4
				vim.opt.foldlevel = 99
				vim.opt.foldlevelstart = 99
			end
		end, 100)
	end,
})

---@type LazySpec
return {
	"nvim-tree/nvim-web-devicons",

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			filter = function(mapping)
				return mapping.desc
			end,
		},
	},

	{
		"vargasd/enhansi",
		priority = 1000,
		config = function()
			require("enhansi").setup({
				transparent_mode = true,
				invert_selection = true,
			})

			vim.cmd.colorscheme("enhansi")
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
		---@module 'noice'
		---@type NoiceConfig
		opts = {
			lsp = {
				progress = { enabled = true },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			popupmenu = { enabled = false },
			messages = { enabled = true },
			presets = { lsp_doc_border = true },
			commands = {
				all = {
					view = "popup",
					opts = { enter = true, format = "details" },
				},
			},
		},
		keys = {
			{
				"<leader>m",
				function()
					vim.cmd.Noice("all")
				end,
			},
		},
		init = function()
			vim.o.shortmess = vim.o.shortmess .. "qCcSsWF"
			vim.o.showmode = false
			vim.o.cmdheight = 0
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local function macro_recording()
				-- https://old.reddit.com/r/neovim/comments/18r2bxo/is_there_a_way_to_display_macro_recording_message/keze7b9/
				local reg = vim.fn.reg_recording()
				return reg == "" and "" or "recording @" .. reg
			end

			local base_config = {
				lualine_b = {
					{
						"diff",
						diff_color = {
							added = "Added",
							modified = "Changed",
							removed = "Removed",
						},
					},
					{
						"diagnostics",
						diagnostics_color = {
							error = "DiagnosticError",
							warn = "DiagnosticWarn",
							info = "DiagnosticInfo",
							hint = "DiagnosticHint",
						},
					},
				},
				lualine_c = { macro_recording },
				lualine_x = { "encoding", "fileformat", "filetype", "location" },
				lualine_y = { "branch" },
			}
			local winbar = vim.tbl_extend("keep", base_config, {
				lualine_a = {
					{
						"filename",
						file_status = true,
						path = 1,
					},
				},
				lualine_z = { "mode" },
			})
			local sections = vim.tbl_extend("keep", base_config, {
				lualine_a = { "mode" },
			})

			require("lualine").setup({
				options = {
					component_separators = "|",
					section_separators = "",

					theme = {
						normal = {
							a = { bg = 7, fg = 0 },
							b = { bg = "NONE", fg = 7 },
							c = { bg = "NONE", fg = 7 },
						},
						insert = {
							a = { bg = "Blue", fg = 0 },
						},
						visual = {
							a = { bg = "Yellow", fg = 0 },
						},
						replace = {
							a = { bg = "Red", fg = 0 },
						},
						command = {
							a = { bg = "Green", fg = 0 },
						},
						inactive = {
							a = { bg = 8, fg = 0 },
						},
					},
				},
				-- sections = sections,
				-- inactive_sections = sections,
				sections = {},
				inactive_sections = {},
				winbar = winbar,
				inactive_winbar = winbar,
			})
		end,
	},

	{
		"mbbill/undotree",
		cmd = { "UndotreeShow" },
		keys = {
			{
				"<leader>u",
				function()
					vim.cmd.UndotreeShow()
					vim.cmd.UndotreeFocus()
				end,
			},
		},
		init = function()
			vim.g.undotree_DiffAutoOpen = 0
		end,
	},

	{
		"chomosuke/term-edit.nvim",
		event = "TermOpen",
		version = "1.*",
		---@module 'term-edit'
		---@type TermEditOpts
		---@diagnostic disable-next-line: missing-fields
		opts = {
			prompt_end = "%→ ",
			mapping = {
				n = {
					s = false,
				},
			},
		},
	},

	{
		"mikavilpas/yazi.nvim",
		dependencies = { "folke/snacks.nvim" },
		keys = {
			{
				"<leader>e",
				vim.cmd.Yazi,
			},
			{
				"<leader>E",
				function()
					vim.cmd.Yazi("cwd")
				end,
			},
		},
		---require('yazi')
		---@type YaziConfig | {}
		opts = {
			open_for_directories = true,
			integrations = {
				grep_in_directory = function(cwd)
					Snacks.picker.grep({
						cwd = cwd,
						hidden = true,
					})
				end,
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"ghostbuster91/nvim-next",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-next.integrations").treesitter_textobjects()
			require("nvim-treesitter.configs").setup({
				modules = {},
				sync_install = false,
				ignore_install = {},
				ensure_installed = {
					-- general
					"comment",
					"regex",

					-- tools
					"devicetree", -- zmk
					"dockerfile",
					"graphql",
					"git_config",
					"git_rebase",
					"gitattributes",
					"gitcommit",
					"gitignore",
					"jq",
					"markdown",
					"markdown_inline",
					"nix",
					"prisma",
					"terraform",
					"vim",
					"vimdoc",

					-- config
					"json",
					"jsonc",
					"toml",
					"yaml",

					"bash",
					"css",
					"glimmer", -- handlebars
					"html",
					"lua",
					"javascript",
					"jsdoc",
					"rust",
					"sql",
					"svelte",
					"tsx",
					"typespec",
					"typescript",
					"vue",
					"php",
				},
				auto_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "sql" },
					disable = function(lang, buf)
						if vim.list_contains(require("common").csv_fts, vim.bo.filetype) then
							return false
						end

						local max_filesize = 500 * 1024 -- 500 KB
						local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
				},
				indent = { enable = true },
				playground = { enable = true },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@comment.outer",
							["ic"] = "@comment.inner",
						},
					},
				},
				nvim_next = {
					enable = true,
					textobjects = {
						move = {
							set_jumps = true,
							goto_next_start = {
								["]f"] = "@function.outer",
								["]a"] = "@parameter.outer",
								["]]"] = "@block.inner",
								["]c"] = "@comment.inner",
								["]v"] = "@assignment.lhs",
							},
							goto_previous_start = {
								["[f"] = "@function.outer",
								["[a"] = "@parameter.outer",
								["[["] = "@block.inner",
								["[c"] = "@comment.inner",
								["[v"] = "@assignment.lhs",
							},
						},
					},
				},
			})
		end,
	},

	{
		"ghostbuster91/nvim-next",
		event = "VeryLazy",
		config = function()
			local builtins = require("nvim-next.builtins")
			local move = require("nvim-next.move")
			local next_integrations = require("nvim-next.integrations")
			local diagnostics = next_integrations.diagnostic()
			next_integrations.quickfix().setup()

			require("nvim-next").setup({
				items = {
					builtins.f,
					builtins.t,
				},
			})

			vim.keymap.set({ "n", "x", "o" }, ",", move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ";", move.repeat_last_move_opposite)

			local diagnostic_opts = {
				severity = {
					min = vim.diagnostic.severity.WARN,
				},
			}
			vim.keymap.set("n", "[d", diagnostics.goto_prev(diagnostic_opts))
			vim.keymap.set("n", "]d", diagnostics.goto_next(diagnostic_opts))
		end,
	},

	{
		"cameron-wags/rainbow_csv.nvim",
		ft = require("common").csv_fts,
		priority = 100,
		opts = {},
		keys = {
			{
				"<leader>r",
				vim.cmd.RainbowAlign,
			},
			{
				"<leader>R",
				vim.cmd.RainbowShrink,
			},
		},
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowDelimQuoted",
			"RainbowMultiDelim",
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = markdown_fts,
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
			heading = { enabled = false },
		},
	},
}
