return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		cmd = {
			"CopilotChat",
			"CopilotChatOpen",
			"CopilotChatClose",
			"CopilotChatToggle",
			"CopilotChatReset",
			"CopilotChatExplain",
			"CopilotChatFix",
			"CopilotChatTests",
			"CopilotChatRefactor",
		},
		keys = {
			{
				"<F8>",
				function()
					require("CopilotChat").toggle()
				end,
				mode = { "n", "i", "t" },
				desc = "Copilot Chat Toggle",
			},
			{
				"<leader>ac",
				function()
					require("CopilotChat").close()
				end,
				mode = "n",
				desc = "Copilot Chat Close",
			},
			{
				"<leader>ar",
				function()
					require("CopilotChat").reset()
				end,
				mode = "n",
				desc = "Copilot Chat Reset",
			},
			{ "<leader>ae", "<cmd>CopilotChatExplain<CR>", mode = "x", desc = "AI Explain" },
			{ "<leader>af", "<cmd>CopilotChatFix<CR>", mode = "x", desc = "AI Fix" },
			{ "<leader>at", "<cmd>CopilotChatTests<CR>", mode = "x", desc = "AI Tests" },
			{ "<leader>aR", "<cmd>CopilotChatRefactor<CR>", mode = "x", desc = "AI Refactor" },
		},
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
			debug = false,
			window = {
				layout = "vertical",
				width = 0.4,
			},
			auto_insert_mode = false,
			clear_chat_on_new_prompt = false,
			highlight_selection = true,
			highlight_headers = true,
			question_header = "## User ",
			answer_header = "## Copilot ",
			error_header = "## Error ",
			prompts = {
				Refactor = {
					prompt = "/COPILOT_GENERATE Refactor this code to make it cleaner and more maintainable.",
				},
				Fix = {
					prompt = "/COPILOT_GENERATE Fix issues in this code and keep behavior unchanged.",
				},
				Tests = {
					prompt = "/COPILOT_GENERATE Generate tests for this code.",
				},
				Explain = {
					prompt = "/COPILOT_EXPLAIN Explain the selected code clearly and briefly.",
				},
			},
		},
		config = function(_, opts)
			require("CopilotChat").setup(opts)
		end,
	},
}
