return {
	{
		"folke/noice.nvim",
		event = "VimEnter",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				progress = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = {
					enabled = true,
					silent = true,
					opts = {
						border = { style = "rounded" },
						position = { row = 2, col = 2 },
					},
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true,
						luasnip = true,
						throttle = 50,
					},
					opts = {
						border = { style = "rounded" },
						position = { row = 2, col = 2 },
					},
				},
			},
			routes = {
				{
					filter = { event = "lsp", kind = "progress" },
					opts = { skip = true },
				},
				{
					filter = { event = "msg_show", kind = "", find = "written" },
					opts = { skip = true },
				},
				{
					filter = { event = "msg_show", kind = "", find = "lines" },
					opts = { skip = true },
				},
				{
					filter = { event = "notify", find = "No information available" },
					opts = { skip = true },
				},
				{
					filter = { event = "notify", find = "Client.*quit" },
					opts = { skip = true },
				},
				{
					filter = { event = "msg_show", kind = "search_count" },
					opts = { skip = true },
				},
				-- route mode messages to mini (bottom-right, non-intrusive)
				{
					view = "mini",
					filter = { event = "msg_showmode" },
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
			views = {
				cmdline_popup = {
					position = { row = "40%", col = "50%" },
					size = { width = 60, height = "auto" },
					border = { style = "rounded" },
					win_options = { winblend = 0 },
				},
				mini = {
					position = { row = -2, col = "100%" },
					size = { width = "auto", height = "auto" },
					border = { style = "none" },
					win_options = { winblend = 0 },
				},
				hover = {
					border = { style = "rounded" },
					win_options = { winblend = 0 },
				},
			},
		},
	},
}
