return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<C-`>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
			{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
			{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal Float" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal Horizontal" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal Vertical" },
			{ "<leader>tn", function() require("toggleterm.terminal").Terminal:new({ direction = "tab" }):toggle() end, desc = "Terminal New Tab" },
			{ "<leader>ts", function() require("toggleterm.terminal").Terminal:new({ direction = "horizontal" }):toggle() end, desc = "Terminal New Split" },
			{ "<leader>tp", function() require("toggleterm.terminal").Terminal:new({ direction = "vertical" }):toggle() end, desc = "Terminal New VSplit" },
		},
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				elseif term.direction == "tab" then
					return vim.o.lines - 5
				end
			end,
			open_mapping = [[<C-`>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = false,
			shading_factor = 0,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			persist_mode = true,
			direction = "float",
			close_on_exit = false,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "FloatBorder",
					background = "Normal",
				},
			},
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			-- Set transparent background for toggleterm
			vim.api.nvim_set_hl(0, "ToggleTerm", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "ToggleTermBorder", { bg = "NONE" })

			-- Terminal navigation keymaps
			vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-N><C-w>h]], { noremap = true, silent = true })
			vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-N><C-w>j]], { noremap = true, silent = true })
			vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-N><C-w>k]], { noremap = true, silent = true })
			vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-N><C-w>l]], { noremap = true, silent = true })

			-- Clipboard integration (yank/paste)
			vim.api.nvim_set_keymap('t', '<C-S-v>', [[<C-\><C-N>"+pi]], { noremap = true, silent = true })
			vim.api.nvim_set_keymap('t', '<C-S-y>', [[<C-\\><C-N>"+yiw]], { noremap = true, silent = true })
		end,
		-- Optionally, add more terminal plugins or utilities here
		}
	}
