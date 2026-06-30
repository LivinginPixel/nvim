-- Python: sniprun REPL, neotest adapter, conform formatters
-- LSP (pyright) is configured in lsp.lua.

return {
	-- Run code snippets inline without leaving nvim
	{
		"michaelb/sniprun",
		branch = "master",
		build  = "sh install.sh",
		cmd    = { "SnipRun", "SnipInfo", "SnipReset", "SnipTerminate" },
		keys = {
			{ "<leader>sr", "<cmd>SnipRun<cr>",        desc = "SnipRun" },
			{ "<leader>sr", "<Plug>SnipRun", mode = "v", desc = "SnipRun selection" },
		},
		opts = {
			display      = { "Classic", "VirtualTextOk", "VirtualTextErr" },
			live_display = { "VirtualTextOk" },
			display_options = {
				terminal_width       = 45,
				notification_timeout = 5,
			},
			interpreter_options = {
				Python3_original = {
					interpreter = "python",
					venv        = { "conda", "venv" },
				},
			},
		},
	},

	-- Extend neotest with the Python adapter
	{
		"nvim-neotest/neotest",
		dependencies = { "nvim-neotest/neotest-python" },
		opts = {
			adapters = {
				["neotest-python"] = { runner = "pytest", python = "python" },
			},
		},
	},

	-- Extend conform with Python formatters (isort before black)
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "isort", "black" },
			},
		},
	},
}
