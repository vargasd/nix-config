local markdown_fts = { "markdown", "codecompanion" }
---@type LazySpec
return {
	"nvim-tree/nvim-web-devicons",

	{ "folke/which-key.nvim", event = "VeryLazy" },

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
				progress = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			notify = { enabled = false },
			popupmenu = { enabled = false },
			messages = { enabled = false },
			presets = { lsp_doc_border = true },
		},
		init = function()
			vim.o.showmode = false
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		config = function()
			vim.o.shortmess = vim.o.shortmess .. "q" -- disables macro message
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
				desc = "Undo tree",
			},
		},
		init = function()
			vim.g.undotree_DiffAutoOpen = 0
		end,
	},

	{
		"voldikss/vim-floaterm",
		cmd = {
			"FloatermToggle",
			"FloatermNew",
		},
		keys = {
			{
				"<leader>t",
				function()
					vim.cmd.FloatermToggle("main")
				end,
				desc = "Terminal",
			},
			{
				"<leader>T",
				"<cmd>FloatermNew! --disposable cd %:p:h<CR>",
				desc = "Terminal at current dir",
			},
		},
		init = function()
			vim.g.floaterm_opener = "edit"
			vim.g.floaterm_height = 0.9
			vim.g.floaterm_width = 0.9

			for i = 0, 9 do
				vim.keymap.set("n", "<leader>" .. i, function()
					vim.cmd.FloatermToggle("terminal " .. i)
				end, { desc = "Terminal " .. i })
			end

			vim.api.nvim_create_autocmd("TermOpen", {
				callback = function(args)
					vim.keymap.set({ "n", "t" }, "<C-q>", vim.cmd.FloatermToggle, { buffer = args.buf })
					vim.keymap.set("t", "<C-z>", "<C-\\><C-n>", { buffer = args.buf })
					vim.keymap.set("n", "s", function()
						require("flash").jump({
							search = {
								mode = function(str)
									return "\\<" .. str
								end,
							},
						})
					end, { buffer = args.buf })
				end,
			})
		end,
	},

	{
		"chomosuke/term-edit.nvim",
		event = "TermOpen",
		version = "1.*",
		opts = {
			prompt_end = "%→ ",
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
					require("snacks.picker").grep({
						cwd = cwd,
						ignored = true,
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
					additional_vim_regex_highlighting = { "sql", "markdown" },
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
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			local ufo = require("ufo")
			ufo.setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})

			vim.o.foldenable = true
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.keymap.set("n", "zR", ufo.openAllFolds)
			vim.keymap.set("n", "zM", ufo.closeAllFolds)
			vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
			vim.keymap.set("n", "zm", ufo.closeFoldsWith)
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
			vim.keymap.set("n", "[d", diagnostics.goto_prev(diagnostic_opts), { desc = "Previous diagnostic" })
			vim.keymap.set("n", "]d", diagnostics.goto_next(diagnostic_opts), { desc = "Next diagnostic" })
		end,
	},

	{
		"cameron-wags/rainbow_csv.nvim",
		ft = require("common").csv_fts,
		priority = 100,
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
		"norcalli/nvim-colorizer.lua",
		ft = "css",
		cmd = { "ColorizerToggle" },
		opts = {
			"css",
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
