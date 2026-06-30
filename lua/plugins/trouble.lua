return {
	{
		"folke/trouble.nvim",
		cmd  = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>",                        desc = "Toggle Trouble Panel" },
			{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",   desc = "Document Diagnostics" },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",  desc = "Workspace Diagnostics" },
			{ "<leader>xl", "<cmd>TroubleToggle loclist<cr>",                desc = "Location List" },
			{ "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",               desc = "Quickfix List" },
			-- ]T / [T for trouble items (]t / [t is reserved for todo-comments)
			{
				"[T",
				function()
					if require("trouble").is_open() then
						require("trouble").previous({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then vim.notify(err, vim.log.levels.ERROR) end
					end
				end,
				desc = "Previous Trouble Item",
			},
			{
				"]T",
				function()
					local trouble = require("trouble")
					if trouble.is_open() then
						local node = trouble.view:get_selected() or {}
						trouble.next({ skip_groups = true, jump = true }, { item = {}, node = node, opts = {} })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then vim.notify(err, vim.log.levels.ERROR) end
					end
				end,
				desc = "Next Trouble Item",
			},
		},
	},
}
