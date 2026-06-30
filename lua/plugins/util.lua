return {
	{ "dstein64/vim-startuptime", cmd = "StartupTime", config = function() vim.g.startuptime_tries = 10 end },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		config = true,
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
		},
	},
}
