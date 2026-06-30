-- lua/plugins/database.lua
-- vim-dadbod: full database client for PostgreSQL (and others) inside nvim

return {
	{ "tpope/vim-dadbod", lazy = true },

	{
		"kristijanhusak/vim-dadbod-completion",
		ft      = { "sql", "mysql", "plsql" },
		lazy    = true,
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
		cmd  = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>Db", "<cmd>DBUIToggle<cr>",       desc = "Toggle DB UI" },
			{ "<leader>Da", "<cmd>DBUIAddConnection<cr>",desc = "Add DB Connection" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>",   desc = "DB Find Buffer" },
		},
		init = function()
			vim.g.db_ui_save_location        = vim.fn.stdpath("data") .. "/dadbod_ui"
			vim.g.db_ui_use_nerd_fonts       = 1
			vim.g.db_ui_auto_execute_table_helpers = 1
			vim.g.db_ui_show_database_icon   = 1
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_win_position         = "left"
			vim.g.db_ui_winwidth             = 35
		end,
		config = function()
			-- Wire dadbod-completion into nvim-cmp for sql/plsql buffers
			vim.api.nvim_create_autocmd("FileType", {
				pattern  = { "sql", "mysql", "plsql" },
				callback = function()
					local ok, cmp = pcall(require, "cmp")
					if not ok then return end
					cmp.setup.buffer({
						sources = cmp.config.sources({
							{ name = "vim-dadbod-completion" },
							{ name = "buffer" },
						}),
					})
				end,
			})
		end,
	},
}
