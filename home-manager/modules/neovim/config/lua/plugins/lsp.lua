---@type lze.Spec[]
return {
	{
		"nvim-lspconfig",
		lazy = false,
		after = function()
			local has_biome = vim.fn.executable("biome") == 1
			local has_vue = vim.fn.executable("vue-language-server") == 1
			local has_tsgo = vim.fn.executable("tsgo") == 1

			local ts_preferences = {
				completions = { completeFunctionCalls = false },
				includeCompletionsWithSnippetText = false,
				includeCompletionsForImportStatements = true,
			}

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
				gopls = {},
				pyright = {},
				nixd = {},
				emmylua_ls = {},
				kotlin_language_server = {},
				gleam = {},
				zls = {},
				terraformls = {},
				tflint = {},
				phpactor = {},
				eslint = {},
				efm = {},
				biome = has_biome and {} or nil,
				vue_ls = has_vue and {} or nil,
				ts_ls = not has_tsgo and {
					format = false,
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					init_options = not has_vue and { hostInfo = "neovim", preferences = ts_preferences } or {
						hostInfo = "neovim",
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.exepath("vue-language-server"):gsub("/bin/[^/]+$", "")
									.. "/lib/language-tools/packages/language-server",
								languages = { "vue" },
								configNamespace = "typescript",
							},
						},
						preferences = ts_preferences,
					},
				} or nil,
				tsgo = has_tsgo and {
					format = false,
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
					init_options = { hostInfo = "neovim", preferences = ts_preferences },
				} or nil,
			}

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					if client then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = ev.buf,
							callback = function()
								if #vim.lsp.get_clients({ bufnr = ev.buf, name = "eslint" }) > 0 then
									vim.lsp.buf.format({ name = "eslint" })
								end
								if #vim.lsp.get_clients({ bufnr = ev.buf, name = "efm" }) > 0 then
									vim.lsp.buf.format({ name = "efm" })
								end
							end,
						})
					end
				end,
			})

			vim.lsp.config("*", {
				on_init = function(client) client.server_capabilities.semanticTokensProvider = nil end,
			})

			for server_name, config in pairs(servers) do
				if config.autostart ~= false then vim.lsp.enable(server_name) end
				vim.lsp.config(server_name, config)
			end
		end,
	},
}
