return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<S-h>",     "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
			{ "<S-l>",     "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
			{ "[b",        "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
			{ "]b",        "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
			{ "<A-w>",     "<cmd>lua require('bufdelete').bufdelete(0, false)<cr>", desc = "Close buffer" },
			{ "<leader>bc","<cmd>lua require('bufdelete').bufdelete(0, false)<cr>", desc = "Close buffer" },
			{ "<leader>bC","<cmd>lua require('bufdelete').bufdelete(0, true)<cr>",  desc = "Force close buffer" },
			{ "<leader>bo","<cmd>BufferLineCloseOthers<cr>",          desc = "Close others" },
			{ "<leader>bp","<cmd>BufferLineTogglePin<cr>",            desc = "Toggle pin" },
			{ "<leader>bP","<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned" },
			-- pick a specific buffer
			{ "<leader>bb","<cmd>BufferLinePick<cr>",                 desc = "Pick buffer" },
			-- move tabs
			{ "<A-S-h>",   "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer right" },
			{ "<A-S-l>",   "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer left" },
		},
		opts = function()
			-- noctis palette
			local c = {
				bg_bar   = "#1b1f27",   -- background
				bg_dark  = "#13161d",   -- darker bg
				bg_sel   = "#232836",   -- surface / active
				fg_dim   = "#4d5566",   -- comments / dim
				fg_vis   = "#7a8fa6",   -- subtext
				fg_sel   = "#aabacf",   -- foreground
				blue     = "#5eccfa",   -- blue
				purple   = "#e16bdf",   -- pink / purple
				red      = "#f0564e",   -- red
				yellow   = "#efbc7e",   -- yellow
				green    = "#84ce90",   -- green
				cyan     = "#49b8d5",   -- cyan
			}

			return {
				options = {
					mode = "buffers",
					numbers = "none",
					close_command       = "lua require('bufdelete').bufdelete(%d, false)",
					right_mouse_command = "lua require('bufdelete').bufdelete(%d, false)",
					left_mouse_command  = "buffer %d",
					middle_mouse_command = nil,
					indicator = { icon = "▎", style = "icon" },
					buffer_close_icon   = "󰅖",
					modified_icon       = "●",
					close_icon          = "",
					left_trunc_marker   = "",
					right_trunc_marker  = "",
					max_name_length     = 18,
					max_prefix_length   = 13,
					truncate_names      = true,
					tab_size            = 18,
					diagnostics         = "nvim_lsp",
					diagnostics_update_in_insert = false,
					diagnostics_indicator = function(_, _, diag)
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
					hover = { enabled = true, delay = 150, reveal = { "close" } },
					sort_by                  = "insert_after_current",
				},
				highlights = {
					-- the gutter / empty area
					fill = { bg = c.bg_dark },

					-- background tabs (not selected, not visible)
					background        = { fg = c.fg_dim, bg = c.bg_bar },
					tab               = { fg = c.fg_dim, bg = c.bg_bar },
					tab_close         = { fg = c.red,    bg = c.bg_bar },

					-- separators between inactive tabs
					separator         = { fg = c.bg_dark, bg = c.bg_bar },
					separator_visible = { fg = c.bg_dark, bg = c.bg_bar },
					separator_selected= { fg = c.bg_dark, bg = c.bg_sel },

					-- the active (selected) tab
					buffer_selected   = { fg = c.fg_sel, bg = c.bg_sel, bold = true, italic = false },
					tab_selected      = { fg = c.fg_sel, bg = c.bg_sel, bold = true },
					indicator_selected= { fg = c.blue,   bg = c.bg_sel },

					-- visible but not focused (split in another window)
					buffer_visible    = { fg = c.fg_vis, bg = c.bg_bar },
					indicator_visible = { fg = c.bg_bar, bg = c.bg_bar },

					-- close button states
					close_button             = { fg = c.fg_dim, bg = c.bg_bar },
					close_button_visible     = { fg = c.fg_vis, bg = c.bg_bar },
					close_button_selected    = { fg = c.red,    bg = c.bg_sel },

					-- modified (unsaved) dot
					modified          = { fg = c.yellow, bg = c.bg_bar },
					modified_visible  = { fg = c.yellow, bg = c.bg_bar },
					modified_selected = { fg = c.yellow, bg = c.bg_sel },

					-- pinned tab
					duplicate          = { fg = c.fg_dim,  bg = c.bg_bar, italic = true },
					duplicate_visible  = { fg = c.fg_dim,  bg = c.bg_bar, italic = true },
					duplicate_selected = { fg = c.fg_sel,  bg = c.bg_sel, italic = true },

					-- pick overlay (BufferLinePick)
					pick          = { fg = c.red,    bg = c.bg_bar, bold = true, italic = false },
					pick_visible  = { fg = c.red,    bg = c.bg_bar, bold = true, italic = false },
					pick_selected = { fg = c.red,    bg = c.bg_sel, bold = true, italic = false },

					-- diagnostics in tabs
					error             = { fg = c.red,    bg = c.bg_bar },
					error_visible     = { fg = c.red,    bg = c.bg_bar },
					error_selected    = { fg = c.red,    bg = c.bg_sel, bold = true },
					warning           = { fg = c.yellow, bg = c.bg_bar },
					warning_visible   = { fg = c.yellow, bg = c.bg_bar },
					warning_selected  = { fg = c.yellow, bg = c.bg_sel, bold = true },
					info              = { fg = c.cyan,   bg = c.bg_bar },
					info_selected     = { fg = c.cyan,   bg = c.bg_sel, bold = true },
					hint              = { fg = c.green,  bg = c.bg_bar },
					hint_selected     = { fg = c.green,  bg = c.bg_sel, bold = true },

					-- numbers
					numbers          = { fg = c.fg_dim, bg = c.bg_bar },
					numbers_selected = { fg = c.blue,   bg = c.bg_sel, bold = true },
				},
			}
		end,
		config = function(_, opts)
			require("bufferline").setup(opts)
			-- fix bufferline after lazy loads colorscheme
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function() pcall(require("bufferline").setup, opts) end,
			})
		end,
	},

	-- Proper buffer deletion that doesn't destroy window layout
	{
		"famiu/bufdelete.nvim",
		lazy = true,
	},
}
