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
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"danielfalk/smart-open.nvim",
				branch = "0.2.x",
				dependencies = {
					"kkharji/sqlite.lua",
					-- Only required if using match_algorithm fzf
					{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				},
			},
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local builtins = require("telescope.builtin")
			local actions = require("telescope.actions")
			local split_layout_config = { fname_width = 1000 }

			telescope.setup({
				defaults = {
					cache_picker = {
						num_pickers = 20,
						ignore_empty_prompt = true,
					},
					path_display = { "truncate" },
					sorting_strategy = "ascending",
					layout_strategy = "vertical",
					layout_config = {
						vertical = {
							prompt_position = "top",
							mirror = true,
							preview_cutoff = 30,
						},
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob=!**/.git/**/*",
					},
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-u>"] = false,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-x>"] = actions.delete_buffer,
							["<C-f>"] = actions.to_fuzzy_refine,
							["<M-a>"] = actions.select_all,
							["<M-u>"] = actions.preview_scrolling_up,
							["<M-d>"] = actions.preview_scrolling_down,
						},
					},
				},
				pickers = {
					buffers = {
						ignore_current_buffer = true,
						sort_mru = true,
					},
					find_files = {
						find_command = { "rg", "--files", "-uu", "--glob=!**/.git/**/*" },
					},
					live_grep = split_layout_config,
					lsp_definitions = split_layout_config,
					lsp_document_symbols = split_layout_config,
					lsp_dynamic_workspace_symbols = split_layout_config,
					lsp_implementations = split_layout_config,
					lsp_incoming_calls = split_layout_config,
					lsp_outgoing_calls = split_layout_config,
					lsp_references = split_layout_config,
					lsp_type_definitions = split_layout_config,
					lsp_workspace_symbols = split_layout_config,
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_cursor(),
					},
					smart_open = {
						match_algorithm = "fzf",
						-- https://github.com/danielfalk/smart-open.nvim/issues/71
						mappings = {
							i = {
								["<C-w>"] = function()
									vim.api.nvim_input("<c-s-w>")
								end,
							},
						},
					},
					aerial = {
						format_symbol = function(symbol_path, filetype)
							if filetype == "json" or filetype == "yaml" then
								return table.concat(symbol_path, ".")
							else
								return symbol_path[#symbol_path]
							end
						end,
					},
				},
			})

			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")

			local grep_prompt = function(additional_args)
				builtins.grep_string({
					search = vim.fn.input("(grep) "),
					additional_args = function()
						return { additional_args }
					end,
				})
			end

			vim.keymap.set("n", "<leader>/", builtins.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>?", function()
				builtins.grep_string({ word_match = "-w" })
			end, { desc = "Grep cword" })
			vim.keymap.set("n", "<leader><leader>", builtins.pickers, { desc = "Recent pickers" })
			vim.keymap.set("n", "<leader>.", grep_prompt, { desc = "Grep in files" })
			vim.keymap.set("n", "<leader>>", function()
				grep_prompt("-uu")
			end, { desc = "Grep in all files" })
			vim.keymap.set("n", "<leader>f", function()
				require("telescope").extensions.smart_open.smart_open({
					cwd_only = true,
					filename_first = false,
				})
			end, { desc = "Find files" })
			vim.keymap.set("n", "<leader>F", builtins.find_files, { desc = "Find all Files" })
			vim.keymap.set("n", "<leader>b", builtins.buffers, { desc = "Find buffers" })
			vim.keymap.set("n", "<leader>B", builtins.oldfiles, { desc = "Find buffers" })
			vim.keymap.set("n", "<leader>d", function()
				builtins.diagnostics({ bufnr = 0 })
			end, { desc = "Diagnostics" })
			vim.keymap.set("n", "<leader>D", builtins.diagnostics, { desc = "Diagnostics" })
			vim.keymap.set("n", "<leader>h", builtins.help_tags, { desc = "Help topics" })
			vim.keymap.set("n", "<leader>H", builtins.highlights, { desc = "highlights" })
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
		"hedyhli/outline.nvim",
		keys = {
			{ "<leader>O", vim.cmd.Outline, desc = "Toggle outline" },
		},
		opts = {
			outline_window = {
				position = "left",
				auto_close = true,
			},
		},
	},

	{
		"stevearc/aerial.nvim",
		opts = {},
		keys = {
			{
				"<leader>o",
				function()
					vim.cmd.Telescope("aerial")
				end,
				desc = "Outline finder",
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope.nvim",
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

	{
		"3rd/image.nvim",
		ft = markdown_fts,
		build = false, -- do not build with hererocks
		---@module 'image'
		---@type Options
		opts = {
			processor = "magick_cli",
			kitty_method = "normal",
			backend = "kitty",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					only_render_image_at_cursor = true,
					only_render_image_at_cursor_mode = "popup",
					floating_windows = false, -- if true, images will be rendered in floating markdown windows
					filetypes = { "markdown" }, -- markdown extensions (ie. quarto) can go here
				},
			},
		},
	},

	{
		"3rd/diagram.nvim",
		ft = markdown_fts,
		dependencies = {
			"3rd/image.nvim",
		},
	},
}
