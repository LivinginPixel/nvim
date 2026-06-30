return {
	{
		"stevearc/conform.nvim",
		enabled = vim.fn.has("nvim-0.10") == 1,
		event   = { "BufWritePre" },
		cmd     = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
			{
				"<leader>cF",
				function() require("conform").format({ formatters = { "injected" } }) end,
				mode = { "n", "v" },
				desc = "Format injected language",
			},
		},
		opts = {
			formatters_by_ft = {
				lua              = { "stylua" },
				python           = { "isort", "black" },
				javascript       = { { "prettierd", "prettier" } },
				typescript       = { { "prettierd", "prettier" } },
				javascriptreact  = { { "prettierd", "prettier" } },
				typescriptreact  = { { "prettierd", "prettier" } },
				json             = { { "prettierd", "prettier" } },
				html             = { { "prettierd", "prettier" } },
				css              = { { "prettierd", "prettier" } },
				scss             = { { "prettierd", "prettier" } },
				markdown         = { { "prettierd", "prettier" } },
				yaml             = { { "prettierd", "prettier" } },
				sh               = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
				shfmt    = { prepend_args = { "-i", "2" } },
			},
		},
	},
}
