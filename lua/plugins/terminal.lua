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
					return math.floor(vim.o.lines * 0.35)
				elseif term.direction == "vertical" then
					return math.floor(vim.o.columns * 0.42)
				end
			end,
			open_mapping = [[<C-`>]],
			hide_numbers = true,
			shade_terminals = false,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			persist_mode = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border   = "rounded",
				width    = math.floor(vim.o.columns * 0.88),
				height   = math.floor(vim.o.lines   * 0.82),
				winblend = 0,
				highlights = {
					border     = "FloatBorder",
					background = "Normal",
				},
			},
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			local map = function(mode, lhs, rhs)
				vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
			end

			-- Exit terminal mode with Esc (back to normal mode in the buffer)
			map("t", "<Esc>",   [[<C-\><C-N>]])
			-- Re-send actual Esc to the running program with Ctrl-Esc
			map("t", "<C-Esc>", [[<Esc>]])

			-- Window navigation from terminal mode
			map("t", "<C-h>", [[<C-\><C-N><C-w>h]])
			map("t", "<C-j>", [[<C-\><C-N><C-w>j]])
			map("t", "<C-k>", [[<C-\><C-N><C-w>k]])
			map("t", "<C-l>", [[<C-\><C-N><C-w>l]])

			-- Paste from system clipboard inside terminal
			map("t", "<C-S-v>", [[<C-\><C-N>"+pi]])
		end,
		-- Optionally, add more terminal plugins or utilities here
		}
	}
