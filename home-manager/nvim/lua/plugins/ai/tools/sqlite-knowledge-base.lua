return {
	description = "Answer questions using sqlite database",
	---@class CodeCompanion.Tool.Calculator
	---@field name string The name of the tool
	---@field args table The arguments sent over by the LLM when making the function call
	---@field cmds table The commands to execute
	---@field function_call table The function call from the LLM
	---@field schema table The schema that the LLM must use in its response to execute a tool
	---@field system_prompt string | fun(schema: table): string The system prompt to the LLM explaining the tool and the schema
	---@field opts? table The options for the tool
	---@field env? fun(schema: table): table|nil Any environment variables that can be used in the *_cmd fields. Receives the parsed schema from the LLM
	---@field handlers table Functions which handle the execution of a tool
	---@field handlers.setup? fun(self: CodeCompanion.Agent.Tool, agent: CodeCompanion.Agent): any Function used to setup the tool. Called before any commands
	---@field handlers.on_exit? fun(self: CodeCompanion.Agent.Tool, agent: CodeCompanion.Agent): any Function to call at the end of a group of commands or functions
	---@field output? table Functions which handle the output after every execution of a tool
	---@field output.prompt fun(self: CodeCompanion.Agent.Tool, agent: CodeCompanion.Agent): string The message which is shared with the user when asking for their approval
	---@field output.rejected? fun(self: CodeCompanion.Agent.Tool, agent: CodeCompanion.Agent, cmd: table): any Function to call if the user rejects running a command
	---@field output.error? fun(self: CodeCompanion.Agent.Tool, agent: CodeCompanion.Agent, cmd: table, stderr: table, stdout?: table): any The function to call if an error occurs
	---@field output.success? fun(self: CodeCompanion.Agent.Tool, agent: CodeCompanion.Agent, cmd: table, stdout: table): any Function to call if the tool is successful
	callback = {
		name = "knowledge",
		cmds = {
			---@param args table The arguments from the LLM's tool call
			---@param input? any The output from the previous function call
			---@return nil|{ status: "success"|"error", data: string }
			function(self, args, input)
				local path = args.path
				local query = args.query

				local response = vim.json.decode(require("plenary.curl").post("http://localhose:11434/api/embed", {
					body = vim.json.encode({
						model = "mxbai-embed-large",
						input = query,
					}),
				}).body)

				vim.notify(response.embeddings[0])

				if error then
					return {
						status = "error",
						data = "Invalid operation: must be add, subtract, multiply, or divide",
					}
				end

				return { status = "success", data = result }
			end,
		},
		system_prompt = [[## Calculator Tool (`calculator`)

## CONTEXT
- You have access to a calculator tool running within CodeCompanion, in Neovim.
- You can use it to add, subtract, multiply or divide two numbers.

### OBJECTIVE
- Do a mathematical operation on two numbers when the user asks

### RESPONSE
- Always use the structure above for consistency.
]],

		schema = {
			type = "function",
			["function"] = {
				name = "knowledge",
				description = "Search knowledge base",
				parameters = {
					type = "object",
					properties = {
						path = {
							type = "string",
							description = "The path to the database",
						},
						query = {
							type = "string",
							description = "The question to answer",
						},
					},
					required = {
						"path",
						"query",
					},
					additionalProperties = false,
				},
				strict = true,
			},
		},
		handlers = {
			---@param self CodeCompanion.Tool.Calculator
			---@param agent CodeCompanion.Agent The tool object
			setup = function(self, agent)
				return vim.notify("setup function called", vim.log.levels.INFO)
			end,
			---@param self CodeCompanion.Tool.Calculator
			---@param agent CodeCompanion.Agent
			on_exit = function(self, agent)
				return vim.notify("on_exit function called", vim.log.levels.INFO)
			end,
		},
		output = {
			---@param self CodeCompanion.Tool.Calculator
			---@param agent CodeCompanion.Agent
			---@param cmd table The command that was executed
			---@param stdout table
			success = function(self, agent, cmd, stdout)
				local chat = agent.chat
				return chat:add_tool_output(self, tostring(stdout[1]))
			end,
			---@param self CodeCompanion.Tool.Calculator
			---@param agent CodeCompanion.Agent
			---@param cmd table
			---@param stderr table The error output from the command
			---@param stdout? table The output from the command
			error = function(self, agent, cmd, stderr, stdout)
				return vim.notify("An error occurred", vim.log.levels.ERROR)
			end,
		},
	},
}
