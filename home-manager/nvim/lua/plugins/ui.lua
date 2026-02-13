---@type LazySpec
return {
	"tmccombs/ansify.nvim",

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			filter = function(mapping) return mapping.desc end,
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
				function() vim.cmd.Noice("all") end,
			},
		},
		init = function()
			vim.o.shortmess = vim.o.shortmess .. "qCcSsWF"
			vim.o.showmode = false
			vim.o.showcmd = false
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
				lualine_x = { "encoding", "fileformat", { "filetype", colored = false }, "location" },
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
		init = function() vim.g.undotree_DiffAutoOpen = 0 end,
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
				function() vim.cmd.Yazi("cwd") end,
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
		branch = "main",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				-- general
				"comment",
				"regex",

				-- tools
				"devicetree", -- zmk
				"graphql",
				"git_config",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"hurl",
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
				"toml",
				"yaml",

				"bash",
				"css",
				"gleam",
				"glimmer", -- handlebars
				"html",
				"lua",
				"javascript",
				"jsdoc",
				"kotlin",
				"rust",
				"sql",
				"svelte",
				"tsx",
				"typespec",
				"typescript",
				"vue",
				"php",
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local max_filesize = 500 * 1024 -- 500 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
					if ok and stats and stats.size > max_filesize then return end

					local lang = vim.treesitter.language.get_lang(args.match) or args.match
					local installed = require("nvim-treesitter").get_installed("parsers")
					if vim.tbl_contains(installed, lang) then vim.treesitter.start(args.buf) end

					-- sql treesitter isn't quite as good
					if lang == "sql" then vim.bo.syntax = "on" end

					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"

					vim.wo[0][0].foldtext = ""

					vim.wo[0][0].foldnestmax = 4
					vim.wo[0][0].foldlevel = 99
				end,
			})
		end,
	},

	{

		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "ghostbuster91/nvim-next" },
		event = "VeryLazy",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true
		end,
		config = function()
			local next_move = require("nvim-next.move")
			local textobjects_move = require("nvim-treesitter-textobjects.move")
			local textobjects_select = require("nvim-treesitter-textobjects.select")

			local mappings = {
				a = "@parameter",
				f = "@function",
				c = "@comment",
				v = "@assignment",
			}
			for key, selector in pairs(mappings) do
				local p, n = next_move.make_repeatable_pair(
					function() textobjects_move.goto_previous_start(selector .. ".outer", "textobjects") end,
					function() textobjects_move.goto_next_start(selector .. ".outer", "textobjects") end
				)

				vim.keymap.set({ "n", "x", "o" }, "[" .. key, p)
				vim.keymap.set({ "n", "x", "o" }, "]" .. key, n)
				vim.keymap.set(
					{ "x", "o" },
					"a" .. key,
					function() textobjects_select.select_textobject(selector .. ".outer", "textobjects") end
				)
				vim.keymap.set(
					{ "x", "o" },
					"i" .. key,
					function() textobjects_select.select_textobject(selector .. ".inner", "textobjects") end
				)
			end
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
			local qf = next_integrations.quickfix()

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
			vim.keymap.set({ "n", "x", "o" }, "[d", diagnostics.goto_prev(diagnostic_opts))
			vim.keymap.set({ "n", "x", "o" }, "]d", diagnostics.goto_next(diagnostic_opts))
			vim.keymap.set("n", "[q", qf.cprevious)
			vim.keymap.set("n", "]q", qf.cnext)
		end,
	},

	{
		"cameron-wags/rainbow_csv.nvim",
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
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
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
			heading = { enabled = false },
			sign = { enabled = false },
		},
	},
}
