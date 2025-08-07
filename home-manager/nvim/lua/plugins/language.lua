---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"creativenull/efmls-configs-nvim",
				version = "v1.x.x", -- version is optional, but recommended
			},
		},

		config = function()
			local stylua = require("efmls-configs.formatters.stylua")
			local terraform_fmt = require("efmls-configs.formatters.terraform_fmt")
			-- not working right now
			local prettier = require("efmls-configs.formatters.prettier_d")
			-- local prettier = require("efmls-configs.formatters.prettier")
			local nixfmt = require("efmls-configs.formatters.nixfmt")

			local servers = vim.tbl_deep_extend(
				"keep",
				vim.g.sam_lsp_configs or {},
				vim.json.decode(os.getenv("SAM_LSP_CONFIGS") or "{}"),
				{
					bashls = {
						settings = {
							bashIde = {
								shellcheckArguments = {
									-- disable unused variables warning
									"-e",
									"SC2034",
								},
							},
						},
					},
					clangd = {},
					cssls = {},
					html = {},
					marksman = {},
					harper_ls = {
						autostart = false,
						filetypes = { "markdown", "asciidoc", "tex", "text" },
						settings = {
							["harper-ls"] = {
								linters = {
									SentenceCapitalization = false,
								},
							},
						},
					},
					nixd = {},
					terraformls = {},
					typos_lsp = {
						autostart = false,
						init_options = {
							config = vim.fn.stdpath("config"):gsub("/.*?", "") .. "/typos-lsp/typos.toml",
						},
					},
					phpactor = {},
					yamlls = {},
					jsonls = {
						settings = {
							json = {
								schemas = {
									{
										fileMatch = { "package.json" },
										url = "https://json.schemastore.org/package.json",
									},
									{
										fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
										url = "https://json.schemastore.org/prettierrc.json",
									},
									{
										fileMatch = { ".swcrc", ".swcrc.json", "swc.config.json" },
										url = "https://swc.rs/schema.json",
									},
									{
										fileMatch = { "tsconfig.json", "tsconfig.*.json", "*.tsconfig.json" },
										url = "http://json.schemastore.org/tsconfig",
									},
								},
							},
						},
					},
					ts_ls = {
						filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }, -- when 4.4.0 is available , "vue"},
						init_options = {
							hostInfo = "neovim",
							preferences = {
								completions = { completeFunctionCalls = false },
								includeCompletionsWithSnippetText = false,
								includeCompletionsForImportStatements = true,
							},
						},
					},
					lua_ls = {
						enable_highlights = true,
						settings = {
							Lua = {
								telemetry = { enable = false },
								workspace = {
									checkThirdParty = false,
									library = vim.api.nvim_get_runtime_file("", true),
								},
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					},
					efm = {
						init_options = { documentFormatting = true },
						settings = {
							languages = {
								javascript = { prettier },
								json = { prettier },
								jsonc = { prettier },
								typescript = { prettier },
								svelte = { prettier },
								sql = { prettier },
								markdown = { prettier },
								typespec = { prettier },
								nix = { nixfmt },
								lua = { stylua },
								terraform = { terraform_fmt },
							},
						},
					},
					eslint = {
						settings = {
							workingDirectories = { mode = "auto" },
							codeActionOnSave = { enable = true },
						},
					},
				}
			)

			local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = lsp_fmt_group,
				callback = function(ev)
					if not vim.bo.modifiable or vim.b.skip_autoformat == true then
						return
					end

					local efm = vim.lsp.get_clients({ name = "efm", bufnr = ev.buf })
					local eslint = vim.lsp.get_clients({ name = "eslint", bufnr = ev.buf })
					if not vim.tbl_isempty(eslint) then
						vim.lsp.buf.format({ name = "eslint" })
					end

					if vim.tbl_isempty(efm) then
						vim.lsp.buf.format()
					else
						vim.lsp.buf.format({ name = "efm" })
					end
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local config = servers[client.name]
					if config and not config.enable_highlights then
						client.server_capabilities.semanticTokensProvider = nil
					end

					-- TODO: remove nvim-colorizer and use this when upgrading to 0.12
					-- vim.lsp.document_color.enable(true, args.buf)
				end,
			})

			for server_name, config in pairs(servers) do
				if config.autostart ~= false then
					vim.lsp.enable(server_name)
				end
				vim.lsp.config(server_name, config)
			end
		end,
	},

	{
		"folke/lazydev.nvim",
		dependencies = {
			{ "gonstoll/wezterm-types", lazy = true },
			{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
		},
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				"lazy.nvim",
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
		},
	},
}
