return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add          = { text = "" },
				change       = { text = "" },
				delete       = { text = "󰍵" },
				topdelete    = { text = "󰍵" },
				changedelete = { text = "󰏦" },
				untracked    = { text = "" },
			},
			signcolumn = true,
			numhl      = false,
			linehl     = false,
			word_diff  = false,
			watch_gitdir = { interval = 1000, follow_files = true },
			attach_to_untracked = true,
			current_line_blame  = false,
			current_line_blame_opts = {
				virt_text     = true,
				virt_text_pos = "eol",
				delay         = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = " <author> · <author_time:%Y-%m-%d> · <summary>",
			sign_priority    = 6,
			update_debounce  = 100,
			max_file_length  = 40000,
			preview_config   = {
				border   = "rounded",
				style    = "minimal",
				relative = "cursor",
				row = 0, col = 1,
			},
			yadm = { enable = false },

			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Hunk navigation
				map("n", "]h", function()
					if vim.wo.diff then return "]c" end
					vim.schedule(gs.next_hunk)
					return "<Ignore>"
				end, "Next hunk")
				map("n", "[h", function()
					if vim.wo.diff then return "[c" end
					vim.schedule(gs.prev_hunk)
					return "<Ignore>"
				end, "Prev hunk")
				-- keep ]c / [c for diffs
				map("n", "]c", function()
					if vim.wo.diff then return "]c" end
					vim.schedule(gs.next_hunk)
					return "<Ignore>"
				end, "Next hunk")
				map("n", "[c", function()
					if vim.wo.diff then return "[c" end
					vim.schedule(gs.prev_hunk)
					return "<Ignore>"
				end, "Prev hunk")

				-- Staging / resetting hunks
				map("n", "<leader>hs", gs.stage_hunk,  "Stage hunk")
				map("n", "<leader>hr", gs.reset_hunk,  "Reset hunk")
				map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
				map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
				map("n", "<leader>hS", gs.stage_buffer,     "Stage buffer")
				map("n", "<leader>hu", gs.undo_stage_hunk,  "Undo stage hunk")
				map("n", "<leader>hR", gs.reset_buffer,     "Reset buffer")
				map("n", "<leader>hp", gs.preview_hunk,     "Preview hunk")

				-- Blame
				map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
				map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle blame")

				-- Inline diff (<leader>gd is reserved for DiffviewOpen)
				map("n", "<leader>hd",  gs.diffthis,          "Diff this (HEAD)")
				map("n", "<leader>hD",  function() gs.diffthis("~") end, "Diff this (~)")
				map("n", "<leader>td",  gs.toggle_deleted,    "Toggle deleted")

				-- Hunk text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
			end,
		},
	},
}
