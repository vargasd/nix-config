---@type LazySpec[]
return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local dashboard = require("alpha.themes.dashboard")

			-- just some silly stuff
			math.randomseed(os.time())
			local shuffled = {}
			for _, v in ipairs({
				[[███    ██ ███████  ██████  ██    ██ ██ ███    ███]],
				[[████   ██ ██      ██    ██ ██    ██ ██ ████  ████]],
				[[██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██]],
				[[██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██]],
				[[██   ████ ███████  ██████    ████   ██ ██      ██]],
			}) do
				local pos = math.random(1, #shuffled + 1)
				table.insert(shuffled, pos, v)
			end

			local branch =
				vim.fn.system("git branch --show-current 2> /dev/null | rev | cut -d / -f 1 | rev | tr -d '\n'")
			local branch_has_session = false
			local git_sha = vim.fn.system("git rev-parse --short HEAD 2> /dev/null | tr -d '\n'")

			local cwd = vim.fn.getcwd()
			local cwd_tail = string.match(cwd, "[^/]*$")
			local session_name = cwd_tail .. "__" .. branch
			local all_sessions = require("possession.session").list()
			local cwd_sessions = {}
			local other_sessions = {}
			for _, session in pairs(all_sessions) do
				if session.cwd == cwd then
					if session.name == session_name then
						branch_has_session = true
					else
						table.insert(cwd_sessions, session.name)
					end
				else
					table.insert(other_sessions, session.name)
				end
			end

			dashboard.section.header.val = shuffled
			dashboard.section.buttons.val = {
				dashboard.button(
					"f",
					"  Find Files",
					":Telescope smart_open filename_first=false" .. (#git_sha == 0 and "" or " cwd_only=true") .. "<cr>"
				),
				dashboard.button("/", " " .. " Find Text", ":Telescope live_grep <CR>"),
				dashboard.button("e", "󰙅 " .. " Open Explorer", ":Yazi <CR>"),
				(function()
					if branch ~= "" then
						return dashboard.button(
							"<CR>",
							"󰘬  " .. (branch_has_session and "Load" or "New") .. " Branch Session",
							(branch_has_session and ":PossessionLoad " or ":PossessionSave ") .. session_name .. "<CR>"
						)
					end
				end)(),
				dashboard.button("q", " " .. " Quit", ":qa<CR>"),
				dashboard.button("d", " " .. " DBUI", ":bd<CR>:DBUI<CR>"),
				{ type = "padding", val = 1 },
				(function()
					local group = {
						type = "group",
						opts = { spacing = 1 },
						val = {
							{
								type = "text",
								val = "Sessions",
								opts = {
									position = "center",
								},
							},
						},
					}

					vim.list_extend(cwd_sessions, other_sessions)
					for i = 1, 10, 1 do
						if cwd_sessions[i] ~= nil then
							table.insert(
								group.val,
								dashboard.button(
									tostring(i),
									"󰆓  " .. cwd_sessions[i],
									"<cmd>PossessionLoad " .. cwd_sessions[i] .. "<cr>"
								)
							)
						end
					end
					return group
				end)(),
			}
			dashboard.opts.layout[1].val = 8

			require("alpha").setup(dashboard.opts)
		end,
	},

	{
		"jedrzejboczar/possession.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },

		keys = {
			{
				"<leader>sf",
				function()
					require("telescope").extensions.possession.list()
				end,
				desc = "session find",
			},
			{
				"<leader>S",
				function()
					local session_name = vim.fn.input("(name) ")
					if (session_name or "") ~= "" then
						require("possession").save(session_name)
					end
				end,
				desc = "session save",
			},
		},
		config = function()
			vim.o.sessionoptions = "buffers,curdir"
			local possession = require("possession")
			possession.setup({
				autosave = {
					current = true,
					on_load = true,
					on_quit = true,
				},
				plugins = {
					delete_hidden_buffers = false,
					nvim_tree = false,
					neo_tree = false,
					symbols_outline = false,
					tabby = false,
					dap = false,
					dapui = false,
					neotest = false,
					delete_buffers = false,
				},
				telescope = {
					previewer = {
						enabled = true,
						previewer = "pretty",
						wrap_lines = true,
						include_empty_plugin_data = false,
						cwd_colors = {
							cwd = "Comment",
						},
					},
					list = {
						default_action = "load",
						mappings = {
							delete = { n = "<c-x>", i = "<c-x>" },
							load = { n = "<cr>", i = "<cr>" },
							save = { n = "<c-s>", i = "<c-s>" },
							rename = { n = "<c-r>", i = "<c-r>" },
						},
					},
				},
			})
		end,
	},
}
