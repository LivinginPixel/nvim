return {
	{
		"folke/todo-comments.nvim",
		cmd   = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
		keys = {
			-- Jump between todos (]t / [t — no conflict after trouble moved to ]T/[T)
			{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
			{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo Comment" },

			-- Browse under <leader>f (find/telescope namespace)
			{ "<leader>ft", "<cmd>TodoTelescope<cr>",                                        desc = "All Todos" },
			{ "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",               desc = "Todos: TODO/FIX/FIXME" },

			-- Trouble list under <leader>x (diagnostics namespace)
			{ "<leader>xt", "<cmd>TodoTrouble<cr>",                                          desc = "All Todos (Trouble)" },
			{ "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",                 desc = "Todos: TODO/FIX/FIXME (Trouble)" },

			-- Insert comment tags (kept under <leader>td — td = todo)
			{ "<leader>tda", "oTODO: ",     desc = "Add TODO comment",     mode = "n" },
			{ "<leader>tdf", "oFIX: ",      desc = "Add FIX comment",      mode = "n" },
			{ "<leader>tdn", "oNOTE: ",     desc = "Add NOTE comment",      mode = "n" },
			{ "<leader>tdb", "oDEBUG: ",    desc = "Add DEBUG comment",    mode = "n" },
			{ "<leader>tdw", "oWARNING: ",  desc = "Add WARNING comment",  mode = "n" },
			{ "<leader>tdi", "oIMPORTANT: ",desc = "Add IMPORTANT comment",mode = "n" },
		},
	},
}
