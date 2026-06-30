return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{ "catppuccin/nvim", name = "catppuccin" },
		},
		keys = {
			{ "<S-h>",    "<cmd>BufferLineCyclePrev<cr>",                                         desc = "Prev buffer" },
			{ "<S-l>",    "<cmd>BufferLineCycleNext<cr>",                                         desc = "Next buffer" },
			{ "[b",       "<cmd>BufferLineCyclePrev<cr>",                                         desc = "Prev buffer" },
			{ "]b",       "<cmd>BufferLineCycleNext<cr>",                                         desc = "Next buffer" },
			{ "<A-w>",    "<cmd>lua require('bufdelete').bufdelete(0, false)<cr>",                desc = "Close buffer" },
			{ "<leader>bc","<cmd>lua require('bufdelete').bufdelete(0, false)<cr>",               desc = "Close buffer" },
			{ "<leader>bC","<cmd>lua require('bufdelete').bufdelete(0, true)<cr>",                desc = "Force close buffer" },
			{ "<leader>bo","<cmd>BufferLineCloseOthers<cr>",                                      desc = "Close others" },
			{ "<leader>bp","<cmd>BufferLineTogglePin<cr>",                                        desc = "Toggle pin" },
			{ "<leader>bP","<cmd>BufferLineGroupClose ungrouped<cr>",                             desc = "Delete non-pinned" },
			{ "<leader>bb","<cmd>BufferLinePick<cr>",                                             desc = "Pick buffer" },
			{ "<A-S-h>",  "<cmd>BufferLineMoveNext<cr>",                                          desc = "Move buffer right" },
			{ "<A-S-l>",  "<cmd>BufferLineMovePrev<cr>",                                          desc = "Move buffer left" },
		},
		opts = {
			options = {
				mode                     = "buffers",
				numbers                  = "none",
				close_command            = "lua require('bufdelete').bufdelete(%d, false)",
				right_mouse_command      = "lua require('bufdelete').bufdelete(%d, false)",
				left_mouse_command       = "buffer %d",
				middle_mouse_command     = nil,
				indicator                = { icon = "▎", style = "icon" },
				buffer_close_icon        = "󰅖",
				modified_icon            = "●",
				close_icon               = "",
				left_trunc_marker        = "",
				right_trunc_marker       = "",
				max_name_length          = 18,
				max_prefix_length        = 13,
				truncate_names           = true,
				tab_size                 = 18,
				diagnostics              = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator    = function(_, _, diag)
					local t = {}
					if diag.error   then table.insert(t, " " .. diag.error)   end
					if diag.warning then table.insert(t, " " .. diag.warning) end
					return table.concat(t, " ")
				end,
				offsets = {
					{
						filetype   = "neo-tree",
						text       = " Explorer",
						highlight  = "Directory",
						text_align = "left",
						separator  = true,
					},
				},
				color_icons              = true,
				show_buffer_icons        = true,
				show_buffer_close_icons  = true,
				show_close_icon          = false,
				show_tab_indicators      = true,
				show_duplicate_prefix    = true,
				persist_buffer_sort      = true,
				separator_style          = "thin",
				enforce_regular_tabs     = false,
				always_show_bufferline   = true,
				hover                    = { enabled = true, delay = 150, reveal = { "close" } },
				sort_by                  = "insert_after_current",
			},
		},
		config = function(_, opts)
			local ok, ctp_bl = pcall(require, "catppuccin.groups.integrations.bufferline")
			if ok then opts.highlights = ctp_bl.get() end
			require("bufferline").setup(opts)
			-- re-apply catppuccin highlights whenever the colorscheme reloads
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					local ok2, ctp_bl2 = pcall(require, "catppuccin.groups.integrations.bufferline")
					if ok2 then opts.highlights = ctp_bl2.get() end
					pcall(require("bufferline").setup, opts)
				end,
			})
		end,
	},

	-- Proper buffer deletion that doesn't destroy window layout
	{
		"famiu/bufdelete.nvim",
		lazy = true,
	},
}
