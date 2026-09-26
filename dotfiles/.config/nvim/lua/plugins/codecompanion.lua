return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	cmd = {
		"CodeCompanion",
		"CodeCompanionChat",
		"CodeCompanionCLI",
		"CodeCompanionActions",
	},
	keys = {
		{ "<leader>ac", "<cmd>CodeCompanionChat<cr>", desc = "Toggle CodeCompanion Chat" },
		{ "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", mode = { "n", "v" } },
		{ "<leader>af", "<cmd>CodeCompanionChat adapter=claude_code_fast<cr>"},
		{ "<leader>ao", "<cmd>CodeCompanionChat adapter=openwebui<cr>"},
	},
	opts = {
		display = {
			chat = {
				window = {
					layout = "vertical",
					position = "right",
					width = 0.25,
				},
			},
		},
		interactions = {
			chat = {
				adapter = "claude_code",
			},
		},
		adapters = {
			acp = {
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						env = {
							CLAUDE_CODE_OAUTH_TOKEN = vim.env.CLAUDE_CODE_TOKEN,
						},
					})
				end,
				claude_code_fast = function()
					return require("codecompanion.adapters").extend("claude_code", {
						env = {
							CLAUDE_CODE_OAUTH_TOKEN = vim.env.CLAUDE_CODE_TOKEN,
						},
						defaults = {
							session_config_options = {
								model = "haiku",
							},
						},
					})
				end,
			},
			http = {
				openwebui = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						name = "openwebui",
						formatted_name = "Open WebUI",

						env = {
							api_key = vim.env.OPENWEBUI_API_KEY,
							url = "http://localhost:8080",
							chat_url = "/api/chat/completions",
							models_endpoint = "/api/models",
						},

						schema = {
							model = {
								default = "qwen3.5:9b",
							},
						},
					})
				end,
			},
		},
	},
}
