local on_attach = function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end
	local telescope = require("telescope.builtin")

	nmap("<leader>R", vim.cmd.LspRestart, "Restart")
	nmap("<leader><C-r>", vim.cmd.LspStart, "Start / force restart")

	nmap("<leader>r", vim.lsp.buf.rename, "Rename")
	vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr }) -- 'weilbith/nvim-code-action-menu',

	nmap("gd", telescope.lsp_definitions, "Definition")
	nmap("gr", telescope.lsp_references, "References")
	nmap("gi", telescope.lsp_implementations, "Implementation")
	nmap("gy", telescope.lsp_type_definitions, "Type")

	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
end

---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"lukas-reineke/lsp-format.nvim",
			{
				"creativenull/efmls-configs-nvim",
				version = "v1.x.x", -- version is optional, but recommended
			},
		},

		config = function()
			local stylua = require("efmls-configs.formatters.stylua")
			local terraform_fmt = require("efmls-configs.formatters.terraform_fmt")
			-- not working right now
			-- local prettier = require("efmls-configs.formatters.prettier_d")
			local prettier = require("efmls-configs.formatters.prettier")
			local nixfmt = require("efmls-configs.formatters.nixfmt")

			require("lsp-format").setup({})

			local servers = {
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
				prismals = {},
				rust_analyzer = {},
				svelte = {},
				tsp_server = {},
				terraformls = {},
				tailwindcss = {
					filetypes = { "svelte" },
				},
				typos_lsp = {
					init_options = {
						config = os.getenv("XDG_CONFIG_HOME") .. "/typos-lsp/typos.toml",
						diagnosticSeverity = "hint",
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
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
					init_options = {
						hostInfo = "neovim",
						preferences = {
							includeCompletionsWithSnippetText = true,
							includeCompletionsForImportStatements = true,
						},
					},
				},
				vtsls = {
					autostart = false,
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = { completeFunctionCalls = true },
							tsserver = {
								maxTsServerMemory = 8192,
							},
						},
					},
					on_attach = function(client, bufnr)
						-- not working; open in picker
						vim.keymap.set("n", "gD", function()
							local params = vim.lsp.util.make_position_params()
							vim.lsp.buf_request(0, "workspace/executeCommand", {
								command = "typescript.goToSourceDefinition",
								arguments = { params.textDocument.uri, params.position },
							}, function() end)
						end, { desc = "TypeScript: Source Definition" })

						on_attach(client, bufnr)
					end,
				},
				lua_ls = {
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
					on_attach = require("lsp-format").on_attach,
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
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
						on_attach(client, bufnr)
					end,
					settings = {
						workingDirectories = { mode = "auto" },
						codeActionOnSave = { enable = true },
					},
				},
			}

			if os.getenv("SAM_VUE") ~= nil then
				servers.ts_ls.filetypes = {}
				servers.volar = {
					filetypes = { "typescript", "vue" },
					init_options = {
						vue = {
							hybridMode = false,
						},
					},
				}
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			for server_name, config in pairs(servers) do
				require("lspconfig")[server_name].setup(vim.tbl_extend("keep", config, {
					capabilities = capabilities,
					on_init = function(client)
						-- treesitter does our highlighting, thanks
						client.server_capabilities.semanticTokensProvider = nil
					end,
					on_attach = on_attach,
				}))
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
