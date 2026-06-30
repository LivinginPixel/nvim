-- lua/plugins/python-env.lua
-- Virtual environment selector: switch Python venvs without leaving nvim

return {
	{
		"linux-cultist/venv-selector.nvim",
		branch       = "regexp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
		},
		ft  = "python",
		cmd = "VenvSelect",
		keys = {
			{ "<leader>pv", "<cmd>VenvSelect<cr>",              desc = "Select Python Venv" },
			{ "<leader>pc", "<cmd>VenvSelectCached<cr>",        desc = "Use Cached Venv" },
		},
		opts = {
			settings = {
				search = {
					-- search from project root upward; picks up .venv, venv, conda envs
					venvs_path        = vim.fn.expand("~"),
				},
				options = {
					notify_user_on_venv_activation = true,
					-- after selecting a venv, restart pyright automatically
					on_venv_activate_callback = function(venv_path)
						local pyright_client = nil
						for _, client in ipairs(vim.lsp.get_clients()) do
							if client.name == "pyright" then
								pyright_client = client
								break
							end
						end
						if pyright_client then
							local python = venv_path .. "/bin/python"
							pyright_client.config.settings = vim.tbl_deep_extend(
								"force",
								pyright_client.config.settings or {},
								{ python = { pythonPath = python } }
							)
							pyright_client.notify(
								"workspace/didChangeConfiguration",
								{ settings = pyright_client.config.settings }
							)
						end
					end,
				},
			},
		},
	},
}
