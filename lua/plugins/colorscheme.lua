return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			background = { light = "latte", dark = "mocha" },
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = true,
			dim_inactive = {
				enabled = true,
				shade = "dark",
				percentage = 0.15,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments    = { "italic" },
				conditionals = { "italic" },
				keywords    = { "italic" },
				booleans    = { "italic" },
				functions   = {},
				strings     = {},
				variables   = {},
				numbers     = {},
				types       = {},
				operators   = {},
				loops       = {},
				properties  = {},
			},
			integrations = {
				bufferline        = true,
				cmp               = true,
				gitsigns          = true,
				indent_blankline  = { enabled = true, scope_color = "lavender" },
				lsp_trouble       = true,
				mason             = true,
				mini              = { enabled = true, indentscope_color = "lavender" },
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors      = { "italic" },
						hints       = { "italic" },
						warnings    = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors      = { "undercurl" },
						hints       = { "undercurl" },
						warnings    = { "undercurl" },
						information = { "undercurl" },
					},
					inlay_hints = { background = true },
				},
				neotree           = true,
				noice             = true,
				notify            = true,
				telescope         = { enabled = true },
				treesitter        = true,
				treesitter_context = true,
				which_key         = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")

			vim.keymap.set("n", "<leader>uT", function()
				local current = vim.g.colors_name or ""
				if current:find("latte") then
					vim.cmd.colorscheme("catppuccin-mocha")
					vim.notify("catppuccin mocha", vim.log.levels.INFO, { title = "Theme" })
				else
					vim.cmd.colorscheme("catppuccin-latte")
					vim.notify("catppuccin latte", vim.log.levels.INFO, { title = "Theme" })
				end
			end, { desc = "Toggle Theme (Dark/Light)" })
		end,
	},
}
