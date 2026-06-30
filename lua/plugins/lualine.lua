return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Catppuccin Mocha palette — hardcoded so colors work even before first install
			local c = {
				rosewater = "#f5e0dc", flamingo = "#f2cdcd", pink    = "#f5c2e7",
				mauve     = "#cba6f7", red      = "#f38ba8", maroon  = "#eba0ac",
				peach     = "#fab387", yellow   = "#f9e2af", green   = "#a6e3a1",
				teal      = "#94e2d5", sky      = "#89dceb", sapphire= "#74c7ec",
				blue      = "#89b4fa", lavender = "#b4befe",
				text      = "#cdd6f4", subtext1 = "#bac2de", subtext0= "#a6adc8",
				overlay2  = "#9399b2", overlay1 = "#7f849c", overlay0= "#6c7086",
				surface2  = "#585b70", surface1 = "#45475a", surface0= "#313244",
				base      = "#1e1e2e", mantle   = "#181825", crust   = "#11111b",
			}

			-- Prefer the live palette so theme-toggle (mocha↔latte) propagates
			local ok, palette = pcall(require, "catppuccin.palettes")
			if ok then c = palette.get_palette() end

			local mode_labels = {
				n      = "NORMAL",   i  = "INSERT",   v  = "VISUAL",
				V      = "V-LINE",   c  = "COMMAND",  R  = "REPLACE",
				t      = "TERMINAL", s  = "SELECT",   S  = "S-LINE",
				no     = "OP-PEND",
				["\22"]= "V-BLOCK",
			}

			local function mode_label()
				return mode_labels[vim.fn.mode()] or vim.fn.mode()
			end

			-- Custom theme: a/z bookend in mode colour, b/y raised, c/x at base
			local theme = {
				normal   = { a={fg=c.crust,bg=c.blue,   gui="bold"}, b={fg=c.text,bg=c.surface0}, c={fg=c.subtext1,bg=c.mantle}, z={fg=c.crust,bg=c.blue,   gui="bold"} },
				insert   = { a={fg=c.crust,bg=c.green,  gui="bold"}, b={fg=c.text,bg=c.surface0}, c={fg=c.subtext1,bg=c.mantle}, z={fg=c.crust,bg=c.green,  gui="bold"} },
				visual   = { a={fg=c.crust,bg=c.mauve,  gui="bold"}, b={fg=c.text,bg=c.surface0}, c={fg=c.subtext1,bg=c.mantle}, z={fg=c.crust,bg=c.mauve,  gui="bold"} },
				command  = { a={fg=c.crust,bg=c.peach,  gui="bold"}, b={fg=c.text,bg=c.surface0}, c={fg=c.subtext1,bg=c.mantle}, z={fg=c.crust,bg=c.peach,  gui="bold"} },
				replace  = { a={fg=c.crust,bg=c.red,    gui="bold"}, b={fg=c.text,bg=c.surface0}, c={fg=c.subtext1,bg=c.mantle}, z={fg=c.crust,bg=c.red,    gui="bold"} },
				terminal = { a={fg=c.crust,bg=c.teal,   gui="bold"}, b={fg=c.text,bg=c.surface0}, c={fg=c.subtext1,bg=c.mantle}, z={fg=c.crust,bg=c.teal,   gui="bold"} },
				inactive = {
					a={fg=c.overlay0,bg=c.mantle}, b={fg=c.overlay0,bg=c.mantle},
					c={fg=c.overlay0,bg=c.mantle}, z={fg=c.overlay0,bg=c.mantle},
				},
			}

			-- ─── Tips ─────────────────────────────────────────────────────────────
			-- os.time() is wall-clock Unix epoch, so each session at a different
			-- time of day starts at a different tip instead of always tip #1.
			local tips = {
				"q{reg} → record macro   @{reg} → play",
				"{n}@@ → repeat last macro n times",
				"za → toggle fold   zM → close all   zR → open all",
				"<leader>zp → peek inside fold without opening",
				"gd → definition   gr → references   K → hover docs",
				"gpd → peek definition   gpr → peek references",
				"F2 → rename symbol   <leader>ca → code actions",
				"<leader>cf → format   <leader>cd → line diagnostics",
				"]d / [d → next/prev diagnostic   ]e / [e → next/prev error",
				"]f / [f → next/prev function   ]a / [a → next/prev param",
				"<leader>sp / <leader>sP → swap parameter next/prev",
				"<leader>xx → Trouble panel   <leader>xd → document diags",
				"]h / [h → next/prev hunk   <leader>hs → stage hunk",
				"<leader>hp → preview hunk   <leader>hb → blame line",
				"<leader>ff → find files   <leader>fg → live grep",
				"<leader>fb → open buffers   <leader>fr → recent files",
				"F5 → start/continue   F9 → breakpoint   F10 → step over",
				"<leader>Tr → run nearest   <leader>Tf → run file",
				"gcc → toggle comment   gc{motion} → comment motion",
				"ys{motion}{c} → surround   cs{old}{new} → change surround",
				"<C-`> → toggle terminal   <leader>tf → float terminal",
				"<C-h/j/k/l> → move between windows",
				"<M-n> → select next   <M-a> → select all occurrences",
				"<C-n> → file explorer   <leader>qs → restore session",
				"<M-l> → accept Copilot   <leader>fk → all keymaps",
			}

			local function keymap_tip()
				local idx = math.floor(os.time() / 10) % #tips + 1
				return "  " .. tips[idx]
			end

			-- ─── Components ───────────────────────────────────────────────────────
			local function lsp_status()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if not clients or #clients == 0 then return "󰅡 no lsp" end
				local names = {}
				for _, cl in ipairs(clients) do
					if cl.name ~= "null-ls" then table.insert(names, cl.name) end
				end
				return "󰒋 " .. table.concat(names, " · ")
			end

			local function macro_rec()
				local reg = vim.fn.reg_recording()
				if reg == "" then return "" end
				return "⏺ REC @" .. reg
			end

			local function python_env()
				local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
				if venv then return " " .. vim.fn.fnamemodify(venv, ":t") end
				return ""
			end

			-- Commits ahead of upstream (non-blocking, cached 10 s)
			local _ahead, _ahead_ts = 0, 0
			local function git_ahead()
				local now = vim.uv.hrtime() / 1e9
				if now - _ahead_ts > 10 then
					_ahead_ts = now
					vim.system({ "git", "rev-list", "--count", "@{upstream}..HEAD" }, { text = true }, function(r)
						_ahead = (r.code == 0) and (tonumber((r.stdout:gsub("%s+", ""))) or 0) or 0
					end)
				end
				return _ahead > 0 and ("↑" .. _ahead) or ""
			end

			-- Git dirty indicator (non-blocking, cached 5 s)
			local _dirty, _dirty_ts = false, 0
			local function commit_sins()
				local now = vim.uv.hrtime() / 1e9
				if now - _dirty_ts > 5 then
					_dirty_ts = now
					vim.system({ "git", "status", "--porcelain" }, { text = true }, function(r)
						_dirty = r.code == 0 and r.stdout ~= ""
					end)
				end
				if _dirty then return "commit your sins" end
				return "You have no sins, you have been forgiven"
			end

			-- ─── Setup ────────────────────────────────────────────────────────────
			require("lualine").setup({
				options = {
					theme                = theme,
					globalstatus         = true,
					icons_enabled        = true,
					component_separators = { left = "", right = "" },
					section_separators   = { left = "", right = "" },
					disabled_filetypes   = { statusline = { "alpha", "dashboard" } },
					refresh              = { statusline = 1000 },
				},
				sections = {
					lualine_a = {
						{
							mode_label,
							separator = { left = "", right = "" },
							padding   = { left = 1, right = 1 },
						},
					},

					lualine_b = {
						{ "branch",
							icon  = "",
							color = { fg = c.lavender, gui = "bold" },
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
							diff_color = {
								added    = { fg = c.green },
								modified = { fg = c.yellow },
								removed  = { fg = c.red },
							},
						},
						{ git_ahead, color = { fg = c.sapphire, gui = "bold" }, padding = { left = 1, right = 1 } },
					},

					lualine_c = {
						{
							"filename",
							path    = 1,
							symbols = { modified = " ●", readonly = " ", unnamed = "󰡯", newfile = " " },
							color   = { fg = c.text },
						},
						{
							commit_sins,
							color = function()
								return _dirty
									and { fg = c.peach, gui = "italic" }
									or  { fg = c.overlay1, gui = "italic" }
							end,
							padding = { left = 2, right = 1 },
						},
						{
							keymap_tip,
							color   = { fg = c.sky, gui = "italic" },
							padding = { left = 2, right = 1 },
						},
					},

					lualine_x = {
						{ macro_rec,  color = { fg = c.red, gui = "bold" },    padding = { left = 1, right = 1 } },
						{ python_env, color = { fg = c.green, gui = "italic" } },
						{
							"filetype",
							colored   = true,
							icon_only = false,
							color     = { fg = c.subtext1 },
						},
					},

					lualine_y = {
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
							diagnostics_color = {
								error = { fg = c.red },
								warn  = { fg = c.yellow },
								info  = { fg = c.sky },
								hint  = { fg = c.teal },
							},
						},
						{ "location", icon = "󰆤", color = { fg = c.sapphire } },
					},

					lualine_z = {
						{ lsp_status, padding = { left = 1, right = 1 } },
						{ function() return "󱑎 " .. os.date("%H:%M") end, padding = { left = 1, right = 1 } },
					},
				},

				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1, color = { fg = c.overlay1 } } },
					lualine_x = { { "location", color = { fg = c.overlay1 } } },
					lualine_y = {},
					lualine_z = {},
				},

				extensions = { "lazy", "neo-tree", "quickfix", "toggleterm", "man", "trouble", "fzf" },
			})
		end,
	},
}
