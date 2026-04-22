---@type lze.Spec[]
return {
	{
		"nvim-lspconfig",
		lazy = false,
		after = function()
			local prettier = {
				formatCanRange = true,
				formatCommand = "prettierd '${INPUT}' ${--range-start=charStart} ${--range-end=charEnd} --config-precedence=prefer-file",
				formatStdin = true,
				rootMarkers = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.js",
					".prettierrc.yml",
					".prettierrc.yaml",
					".prettierrc.json5",
					".prettierrc.mjs",
					".prettierrc.cjs",
					".prettierrc.toml",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
				},
			}

			local eslint_d = {
				formatCommand = "eslint_d --stdin --stdin-filename ${INPUT} --fix-to-stdout",
				formatStdin = true,
				rootMarkers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs" },
			}

			local _, env_lsp = pcall(vim.json.decode, os.getenv("SAM_LSP_CONFIGS") or "{}")
			local servers = vim.tbl_deep_extend("keep", vim.g.sam_lsp_configs or {}, env_lsp or {}, {
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
				cssls = {},
				html = {},
				marksman = {},
				harper_ls = {
					filetypes = { "markdown", "asciidoc", "tex" },
					settings = {
						["harper-ls"] = {
							linters = {
								SentenceCapitalization = false,
							},
						},
					},
				},
				typos_lsp = {
					autostart = false,
					init_options = {
						config = vim.fn.stdpath("config"):gsub("/.*?", "") .. "/typos-lsp/typos.toml",
					},
				},
				yamlls = {
					settings = {
						redhat = {
							telemetry = {
								enabled = false,
							},
						},
						yaml = {
							format = {
								enable = false,
							},
							schemas = {
								["https://taskfile.dev/schema.json"] = {
									"**/Taskfile.yml",
									"**/Taskfile.yaml",
								},
							},
						},
					},
				},
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
					format = false,
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
					init_options = {
						hostInfo = "neovim",
						preferences = {
							completions = { completeFunctionCalls = false },
							includeCompletionsWithSnippetText = false,
							includeCompletionsForImportStatements = true,
						},
					},
				},
				tsgo = {
					format = false,
					filetypes = {},
					init_options = {
						hostInfo = "neovim",
						preferences = {
							completions = { completeFunctionCalls = false },
							includeCompletionsWithSnippetText = false,
							includeCompletionsForImportStatements = true,
						},
					},
				},
				efm = {
					init_options = { documentFormatting = true },
					settings = {
						languages = {
							javascript = { eslint_d, prettier },
							json = { prettier },
							jsonc = { prettier },
							typescript = { eslint_d, prettier },
							svelte = { eslint_d, prettier },
							sql = {
								{
									formatCommand = "sqruff fix -",
									formatStdin = true,
									rootMarkers = { ".sqruff" },
								},
							},
							markdown = { prettier },
							typespec = { prettier },
							vue = { eslint_d, prettier },
							yaml = { prettier },
						},
					},
				},
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
					},
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					vim.lsp.semantic_tokens.enable(false)

					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					if client and client.name == "efm" then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = ev.buf,
							callback = function() vim.lsp.buf.format({ name = client.name, bufnr = ev.buf }) end,
						})
					end
				end,
			})

			for server_name, config in pairs(servers) do
				if config.autostart ~= false then vim.lsp.enable(server_name) end
				vim.lsp.config(server_name, config)
			end
		end,
	},
}
