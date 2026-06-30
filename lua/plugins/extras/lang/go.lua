-- Go: go.nvim tooling + neotest adapter
-- LSP (gopls) is configured by go.nvim itself when ft = go/gomod loads.

return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		ft    = { "go", "gomod" },
		event = "CmdlineEnter",
		build = ':lua require("go.install").update_all_sync()',
		opts = {
			lsp_gofumpt            = true,
			lsp_document_formatting = false,
			lsp_inlay_hints        = { enable = true },
			diagnostic = {
				hdlr         = true,
				underline    = true,
				virtual_text = { space = 0, prefix = "●" },
				signs        = true,
			},
			dap_debug     = true,
			dap_debug_gui = true,
			test_runner   = "go",
			lsp_on_attach = function(_, bufnr)
				local map = function(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
				end
				map("<leader>gi", function() require("go.impl").impl() end,            "Go: add interface stubs")
				map("<leader>gT", function() require("go.alternate").toggle() end,     "Go: toggle test file")
			end,
		},
		config = function(_, opts)
			require("go").setup(opts)
		end,
	},

	-- Extend neotest with the Go adapter
	{
		"nvim-neotest/neotest",
		dependencies = { "nvim-neotest/neotest-go" },
		opts = {
			adapters = {
				["neotest-go"] = { args = { "-count=1", "-timeout=60s" } },
			},
		},
	},
}
