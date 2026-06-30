-- lua/plugins/vscode-ux.lua
-- VS Code UX features: breadcrumbs, live rename, auto-tags, lightbulb, peek

return {
	-- Breadcrumbs bar at the top of every window (VS Code context bar)
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		event = "BufReadPost",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			attach_navic       = true,
			show_dirname       = false,
			show_basename      = true,
			show_modified      = true,
			modified_indicator = "●",
			ellipsis           = "…",
			separator          = "  ",
			-- catppuccin mocha palette
			theme = {
				normal       = { bg = "#1e1e2e", fg = "#6c7086" },
				ellipsis     = { fg = "#45475a" },
				separator    = { fg = "#45475a" },
				modified     = { fg = "#f9e2af" },
				dirname      = { fg = "#6c7086" },
				basename     = { fg = "#cdd6f4", bold = true },
				context_file             = { fg = "#89b4fa" },
				context_module           = { fg = "#cba6f7", italic = true },
				context_namespace        = { fg = "#cba6f7", italic = true },
				context_package          = { fg = "#94e2d5" },
				context_class            = { fg = "#f9e2af", bold = true },
				context_method           = { fg = "#89b4fa" },
				context_property         = { fg = "#94e2d5" },
				context_field            = { fg = "#94e2d5" },
				context_constructor      = { fg = "#74c7ec" },
				context_enum             = { fg = "#a6e3a1" },
				context_interface        = { fg = "#89dceb" },
				context_function         = { fg = "#89b4fa" },
				context_variable         = { fg = "#cdd6f4" },
				context_constant         = { fg = "#fab387" },
				context_type_parameter   = { fg = "#74c7ec" },
			},
		},
	},

	-- Live rename with cmdline preview (VS Code F2)
	-- Keymaps are set in lsp/keymaps.lua on LspAttach
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		opts = {},
	},

	-- Auto-close and auto-rename HTML / JSX / TSX tags
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	-- Lightbulb in sign column when LSP code actions are available
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = {
			autocmd = { enabled = true },
			sign = {
				enabled = true,
				text = "",     -- nf-cod-lightbulb
				hl = "DiagnosticWarn",
			},
			virtual_text = { enabled = false },
			float = { enabled = false },
		},
	},

	-- Inline peek window for definitions / references (VS Code Alt+F12)
	{
		"dnlhc/glance.nvim",
		cmd = "Glance",
		keys = {
			{ "gpd", "<cmd>Glance definitions<cr>",      desc = "Peek Definition" },
			{ "gpr", "<cmd>Glance references<cr>",       desc = "Peek References" },
			{ "gpi", "<cmd>Glance implementations<cr>",  desc = "Peek Implementations" },
			{ "gpt", "<cmd>Glance type_definitions<cr>", desc = "Peek Type Definition" },
		},
		config = function()
			local glance = require("glance")
			glance.setup({
				border = { enable = true, top_char = "─", bottom_char = "─" },
				theme  = { enable = true, mode = "darken" },
				hooks  = {
					before_open = function(results, open, jump, _)
						if #results == 1 then
							jump(results[1])
						else
							open(results)
						end
					end,
				},
			})
			-- catppuccin mocha palette
			local hl = function(g, v) vim.api.nvim_set_hl(0, g, v) end
			hl("GlanceWinBarTitle",      { fg = "#89b4fa", bold = true, bg = "#181825" })
			hl("GlanceWinBarFilename",   { fg = "#cdd6f4", bg = "#181825" })
			hl("GlancePreviewNormal",    { bg = "#1e1e2e" })
			hl("GlanceListNormal",       { bg = "#181825" })
			hl("GlanceBorderTop",        { fg = "#89b4fa" })
			hl("GlanceListBorderBottom", { fg = "#89b4fa" })

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					hl("GlanceWinBarTitle",      { fg = "#89b4fa", bold = true, bg = "#181825" })
					hl("GlanceWinBarFilename",   { fg = "#cdd6f4", bg = "#181825" })
					hl("GlancePreviewNormal",    { bg = "#1e1e2e" })
					hl("GlanceListNormal",       { bg = "#181825" })
					hl("GlanceBorderTop",        { fg = "#89b4fa" })
					hl("GlanceListBorderBottom", { fg = "#89b4fa" })
				end,
			})
		end,
	},
}
