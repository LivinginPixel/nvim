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
			-- noctis palette
			local c = {
				bg      = "#141414",   -- Normal bg
				bg_dark = "#0c0c0c",   -- StatusLine / darker panel bg
				fg      = "#f2f4f8",   -- NormalNC fg (light)
				fg_dim  = "#7b7c7e",   -- LineNr
				blue    = "#33b1ff",   -- Identifier
				purple  = "#be95ff",   -- Statement
				cyan    = "#5ae0df",   -- Constant
				green   = "#66ffbf",   -- String / Normal fg
				red     = "#ee5396",   -- ErrorMsg
				pink    = "#ff91c1",   -- PreProc
				teal    = "#08bdba",   -- Type
			}

			local hl = function(group, val) vim.api.nvim_set_hl(0, group, val) end

			local function apply_hl()
				-- panel background
				hl("NeoTreeNormal",           { fg = c.fg,     bg = c.bg_dark })
				hl("NeoTreeNormalNC",         { fg = c.fg,     bg = c.bg_dark })
				hl("NeoTreeEndOfBuffer",      { fg = c.bg_dark,bg = c.bg_dark })
				hl("NeoTreeWinSeparator",     { fg = c.bg,     bg = c.bg_dark })
				hl("NeoTreeStatusLine",       { fg = c.bg_dark,bg = c.bg_dark })
				hl("NeoTreeStatusLineNC",     { fg = c.bg_dark,bg = c.bg_dark })

				-- header / title
				hl("NeoTreeRootName",         { fg = c.blue,   bold = true })
				hl("NeoTreeTitleBar",         { fg = c.fg,     bg = c.bg_dark, bold = true })

				-- files and directories — monochromatic, not rainbow
				hl("NeoTreeFileName",         { fg = c.fg })
				hl("NeoTreeFileIcon",         { fg = c.fg_dim })
				hl("NeoTreeDirectoryIcon",    { fg = c.blue })
				hl("NeoTreeDirectoryName",    { fg = c.blue })
				hl("NeoTreeSymbolicLinkTarget",{ fg = c.cyan })

				-- modified dot
				hl("NeoTreeModified",         { fg = c.pink })

				-- dim items
				hl("NeoTreeDimText",          { fg = c.fg_dim })
				hl("NeoTreeIndentMarker",     { fg = c.fg_dim })
				hl("NeoTreeExpander",         { fg = c.fg_dim })

				-- git status symbols — single accent colour each, not per-file name tinting
				hl("NeoTreeGitAdded",         { fg = c.green })
				hl("NeoTreeGitModified",      { fg = c.pink })
				hl("NeoTreeGitDeleted",       { fg = c.red })
				hl("NeoTreeGitRenamed",       { fg = c.cyan })
				hl("NeoTreeGitUntracked",     { fg = c.fg_dim })
				hl("NeoTreeGitIgnored",       { fg = c.fg_dim })
				hl("NeoTreeGitUnstaged",      { fg = c.pink })
				hl("NeoTreeGitStaged",        { fg = c.green })
				hl("NeoTreeGitConflict",      { fg = c.red, bold = true })

				-- selection / cursor
				hl("NeoTreeCursorLine",       { bg = "#222222" })  -- noctis CursorLine
				hl("NeoTreeFloatBorder",      { fg = c.blue,  bg = c.bg_dark })
				hl("NeoTreeFloatTitle",       { fg = c.purple,bg = c.bg_dark, bold = true })

				-- tab headers (buffers/git_status source tabs)
				hl("NeoTreeTabActive",        { fg = c.fg,    bg = c.bg_dark, bold = true })
				hl("NeoTreeTabInactive",      { fg = c.fg_dim,bg = c.bg_dark })
				hl("NeoTreeTabSeparatorActive",  { fg = c.blue, bg = c.bg_dark })
				hl("NeoTreeTabSeparatorInactive",{ fg = c.bg_dark, bg = c.bg_dark })
			end

			apply_hl()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_hl })

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
