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
			attach_navic = true,
			show_dirname = false,
			show_basename = true,
			show_modified = true,
			modified_indicator = "●",
			ellipsis = "…",
			separator = "  ",
			theme = {
				normal        = { bg = "#141414", fg = "#7b7c7e" },
				ellipsis      = { fg = "#525253" },
				separator     = { fg = "#525253" },
				modified      = { fg = "#ff91c1" },
				dirname       = { fg = "#7b7c7e" },
				basename      = { fg = "#f2f4f8", bold = true },
				context_file          = { fg = "#33b1ff" },
				context_module        = { fg = "#c8a5ff", italic = true },
				context_namespace     = { fg = "#c8a5ff", italic = true },
				context_package       = { fg = "#5ae0df" },
				context_class         = { fg = "#08bdba", bold = true },
				context_method        = { fg = "#00b4cc" },
				context_property      = { fg = "#8cb6ff" },
				context_field         = { fg = "#8cb6ff" },
				context_constructor   = { fg = "#3ddbd9" },
				context_enum          = { fg = "#5ae0df" },
				context_interface     = { fg = "#08bdba" },
				context_function      = { fg = "#00b4cc" },
				context_variable      = { fg = "#c8d3f5" },
				context_constant      = { fg = "#ff91c1" },
				context_type_parameter= { fg = "#78dcca" },
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
					before_open = function(results, open, jump, method)
						-- jump directly if there's only one result
						if #results == 1 then
							jump(results[1])
						else
							open(results)
						end
					end,
				},
			})
			-- tint glance windows to noctis palette
			local hl = function(g, v) vim.api.nvim_set_hl(0, g, v) end
			hl("GlanceWinBarTitle",     { fg = "#33b1ff", bold = true, bg = "#1a1a1a" })
			hl("GlanceWinBarFilename",  { fg = "#f2f4f8", bg = "#1a1a1a" })
			hl("GlancePreviewNormal",   { bg = "#141414" })
			hl("GlanceListNormal",      { bg = "#0c0c0c" })
			hl("GlanceBorderTop",       { fg = "#33b1ff" })
			hl("GlanceListBorderBottom",{ fg = "#33b1ff" })
		end,
	},
}
