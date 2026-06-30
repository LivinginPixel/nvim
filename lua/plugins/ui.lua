-- lua/plugins/ui.lua
return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = { char = "│", tab_char = "│" },
			scope  = { enabled = false },
			exclude = {
				filetypes = {
					"help", "alpha", "dashboard", "neo-tree",
					"Trouble", "trouble", "lazy", "mason",
					"notify", "toggleterm", "lazyterm",
				},
			},
		},
		main = "ibl",
	},

	-- Scrollbar with diagnostics + git marks
	{
		"petertriho/nvim-scrollbar",
		event = "BufReadPost",
		opts = {
			handle = { color = "#3e4452" },
			marks = {
				Search = { color = "#fab387" },
				Error  = { color = "#f38ba8" },
				Warn   = { color = "#f9e2af" },
				Info   = { color = "#89dceb" },
				Hint   = { color = "#a6e3a1" },
				Misc   = { color = "#cba6f7" },
			},
			handlers = {
				cursor     = true,
				diagnostic = true,
				gitsigns   = true,
				handle     = true,
				search     = true,
			},
		},
	},

	-- Keybinding popup
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
			win     = { border = "rounded", padding = { 1, 2 } },
			spec = {
				{ "g",          group = "+goto",             mode = { "n", "v" } },
				{ "gp",         group = "+peek" },
				{ "gz",         group = "+surround",         mode = { "n", "v" } },
				{ "]",          group = "+next",             mode = { "n", "v" } },
				{ "[",          group = "+prev",             mode = { "n", "v" } },
				{ "<leader>b",  group = "+buffer" },
				{ "<leader>c",  group = "+code" },
				{ "<leader>d",  group = "+debug" },
				{ "<leader>D",  group = "+database" },
				{ "<leader>f",  group = "+find" },
				{ "<leader>g",  group = "+git" },
				{ "<leader>gh", group = "+git hunks" },
				{ "<leader>gt", group = "+git stash" },
				{ "<leader>h",  group = "+hunks" },
				{ "<leader>p",  group = "+python" },
				{ "<leader>q",  group = "+quit/session" },
				{ "<leader>s",  group = "+search" },
				{ "<leader>t",  group = "+toggle/terminal" },
				{ "<leader>td", group = "+todo-insert" },
				{ "<leader>T",  group = "+test" },
				{ "<leader>u",  group = "+ui" },
				{ "<leader>uT", desc  = "Toggle Theme" },
				{ "<leader>ui", desc  = "Toggle Inlay Hints" },
				{ "<leader>w",  group = "+windows" },
				{ "<leader>x",  group = "+diagnostics/trouble" },
				{ "<leader>z",  group = "+fold" },
			},
		},
		config = function(_, opts)
			require("which-key").setup(opts)
		end,
	},
}
