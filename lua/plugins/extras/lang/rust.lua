-- Rust: crates.nvim for Cargo.toml intelligence.
-- rust-analyzer LSP is configured in lsp.lua.
-- rust-tools.nvim was removed (archived, conflicts with native lsp setup).

return {
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts  = {
			completion = { crates = { enabled = true } },
			lsp = {
				enabled     = true,
				actions     = true,
				completion  = true,
				hover       = true,
			},
			popup = { border = "rounded" },
		},
	},
}
