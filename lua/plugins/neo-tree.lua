return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		keys = {
			{ "<C-n>",    "<cmd>Neotree toggle<cr>",  desc = "Toggle explorer" },
			{ "<leader>e","<cmd>Neotree toggle<cr>",  desc = "Toggle explorer" },
			{ "<leader>E","<cmd>Neotree reveal<cr>",  desc = "Reveal file in explorer" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		deactivate = function() vim.cmd("Neotree close") end,
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.uv.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then require("neo-tree") end
			end
		end,
		opts = {
			sources = { "filesystem", "buffers", "git_status" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },

			-- global defaults shared by all sources
			default_component_configs = {
				container = { enable_character_fade = true },
				indent = {
					indent_size        = 2,
					padding            = 1,
					with_markers       = true,
					indent_marker      = "│",
					last_indent_marker = "└",
					highlight          = "NeoTreeIndentMarker",
					with_expanders     = true,
					expander_collapsed = "",
					expander_expanded  = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed   = "",
					folder_open     = "",
					folder_empty    = "󰜌",
					folder_empty_open = "󰜌",
					default         = "󰈚",
					highlight       = "NeoTreeFileIcon",
				},
				modified = {
					symbol    = "●",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						added     = "",
						modified  = "",
						deleted   = "󰆴",
						renamed   = "󰁕",
						untracked = "",
						ignored   = "",
						unstaged  = "󰄱",
						staged    = "",
						conflict  = "",
					},
					align = "right",
				},
				file_size    = { enabled = false },
				type         = { enabled = false },
				last_modified= { enabled = false },
				created      = { enabled = false },
				symlink_target = { enabled = false },
			},

			window = {
				position = "left",
				width    = 30,
				mapping_options = { noremap = true, nowait = true },
				mappings = {
					["<space>"] = "none",
					["<CR>"]    = "open",
					["l"]       = "open",
					["h"]       = "close_node",
					["K"]       = "navigate_up",
					["a"]       = "add",
					["A"]       = "add_directory",
					["d"]       = "delete",
					["r"]       = "rename",
					["R"]       = "refresh",
					["x"]       = "cut_to_clipboard",
					["c"]       = "copy_to_clipboard",
					["p"]       = "paste_from_clipboard",
					["y"]       = "copy_to_clipboard",
					["?"]       = "show_help",
					["q"]       = "close_window",
					["<Tab>"]   = "toggle_preview",
				},
			},

			filesystem = {
				bind_to_cwd   = false,
				follow_current_file    = { enabled = true, leave_dirs_open = false },
				use_libuv_file_watcher = true,
				filtered_items = {
					visible          = false,
					hide_dotfiles    = false,
					hide_gitignored  = true,
					hide_by_name     = { ".DS_Store", "thumbs.db" },
					never_show       = { ".git" },
				},
			},

			buffers = {
				follow_current_file = { enabled = true },
				group_empty_dirs    = true,
				show_unloaded       = true,
				window = {
					mappings = {
						["d"] = "buffer_delete",
					},
				},
			},

			git_status = {
				window = {
					mappings = {
						["A"]  = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
					},
				},
			},
		},

		config = function(_, opts)
			require("neo-tree").setup(opts)

			vim.api.nvim_create_autocmd("TermClose", {
				pattern  = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},
}
