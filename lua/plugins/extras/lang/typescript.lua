-- TypeScript/JavaScript: ESLint via its own language server.
-- ts_ls (TypeScript LSP) is configured in lsp.lua.
-- typescript-tools.nvim was removed — it conflicts with ts_ls (two competing servers).

return {
	{
		"MunifTanjim/eslint.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			bin = "eslint_d",
			code_actions = {
				enable    = true,
				apply_on_save = {
					enable = true,
					types  = { "directive", "problem", "suggestion", "layout" },
				},
				disable_rule_comment = {
					enable   = true,
					location = "separate_line",
				},
			},
			diagnostics = {
				enable                          = true,
				report_unused_disable_directives = false,
				run_on                          = "type",
			},
		},
	},
}
