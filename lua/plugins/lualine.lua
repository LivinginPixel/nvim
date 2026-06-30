return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local mode_labels = {
				n      = "NORMAL",
				i      = "INSERT",
				v      = "VISUAL",
				V      = "V-LINE",
				["\22"]= "V-BLOCK",
				c      = "COMMAND",
				R      = "REPLACE",
				t      = "TERMINAL",
				s      = "SELECT",
				S      = "S-LINE",
				no     = "OP-PENDING",
			}

			local function mode_label()
				return mode_labels[vim.fn.mode()] or vim.fn.mode()
			end

			-- Rotating keymap tip — genuinely useful, cycles every 45 s
			local function keymap_tip()
				local tips = {
					-- Macros
					"q{reg} → record macro  @{reg} → play",
					"{n}@@ → repeat last macro n times",
					-- Folding
					"za → toggle fold   zM → close all   zR → open all",
					"<leader>zp → peek inside fold without opening",
					-- LSP
					"gd → definition   gr → references   K → hover docs",
					"gpd → peek definition   gpr → peek references",
					"F2 → rename symbol   <leader>ca → code actions",
					"<leader>cf → format   <leader>cd → line diagnostics",
					"]d / [d → next/prev diagnostic   ]e / [e → next/prev error",
					-- Treesitter
					"]f / [f → next/prev function   ]a / [a → next/prev param",
					"<leader>sp / <leader>sP → swap parameter next/prev",
					-- Trouble
					"<leader>xx → Trouble panel   <leader>xd → document diags",
					"]T / [T → next/prev Trouble item",
					-- Git
					"]h / [h → next/prev hunk   <leader>hs → stage hunk",
					"<leader>hp → preview hunk   <leader>hb → blame line",
					"<leader>td → toggle deleted lines",
					-- Telescope
					"<leader>ff → find files   <leader>fg → live grep",
					"<leader>fb → open buffers   <leader>fr → recent files",
					"<leader>fk → browse all keymaps",
					-- DAP
					"F5 → start/continue   F9 → breakpoint   F10 → step over",
					"F11 → step into   F12 → step out   <leader>du → DAP UI",
					-- Testing
					"<leader>Tr → run nearest   <leader>Tf → run file",
					"<leader>Ts → test summary   <leader>Td → debug test",
					-- Editor
					"gcc → toggle comment   gc{motion} → comment motion",
					"ys{motion}{c} → surround   cs{old}{new} → change surround",
					"<A-j/k> → move line/selection   <M-e> → fast wrap",
					-- Terminal
					"<C-`> → toggle terminal   <leader>tf → float terminal",
					-- Windows
					"<leader>wv → vsplit   <leader>wh → hsplit",
					"<C-h/j/k/l> → move between windows",
					"<A-arrows> → resize window",
					-- Multi-cursor
					"<M-n> → select next   <M-a> → select all occurrences",
					-- Misc
					"<C-n> → file explorer   <leader>qs → restore session",
					"<M-l> → accept Copilot   <leader>fk → all keymaps",
				}
				local idx = math.floor(vim.uv.hrtime() / 45e9) % #tips + 1
				return "  " .. tips[idx]
			end

			local function lsp_status()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if not clients or #clients == 0 then return "󰅡 no lsp" end
				local names = {}
				for _, cl in ipairs(clients) do
					if cl.name ~= "null-ls" then table.insert(names, cl.name) end
				end
				return "󰒋 " .. table.concat(names, " ")
			end

			local function macro_rec()
				local reg = vim.fn.reg_recording()
				if reg == "" then return "" end
				return " rec @" .. reg
			end

			local function python_env()
				local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
				if venv then return " " .. vim.fn.fnamemodify(venv, ":t") end
				return ""
			end

			-- Cached commits ahead of upstream + dirty file count (non-blocking)
			local _ahead, _ahead_ts = 0, 0
			local function git_ahead()
				local now = vim.uv.hrtime() / 1e9
				if now - _ahead_ts > 10 then
					_ahead_ts = now
					vim.system(
						{ "git", "rev-list", "--count", "@{upstream}..HEAD" },
						{ text = true },
						function(r)
							_ahead = (r.code == 0) and (tonumber((r.stdout:gsub("%s+", ""))) or 0) or 0
						end
					)
				end
				return _ahead > 0 and ("↑" .. _ahead) or ""
			end

			-- Cached git dirty check (non-blocking, cached 5 s)
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

			local function lualine_theme()
				local ok = pcall(require, "lualine.themes.catppuccin")
				return ok and "catppuccin" or "auto"
			end

			require("lualine").setup({
				options = {
					theme                = lualine_theme(),
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
						{ "branch", icon = "" },
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
						},
						{ git_ahead, padding = { left = 1, right = 1 } },
					},
					lualine_c = {
						{
							"filename",
							path    = 1,
							symbols = { modified = " ●", readonly = " ", unnamed = "󰡯", newfile = " " },
						},
						{
							commit_sins,
							color   = { gui = "italic" },
							padding = { left = 2, right = 1 },
						},
						{
							keymap_tip,
							color   = { gui = "italic" },
							padding = { left = 2, right = 1 },
						},
					},
					lualine_x = {
						{ macro_rec,  color = { gui = "bold" }, padding = { left = 1, right = 1 } },
						{ python_env, color = { gui = "italic" } },
						{
							"filetype",
							colored   = true,
							icon_only = false,
						},
					},
					lualine_y = {
						{
							"diagnostics",
							sources  = { "nvim_lsp" },
							symbols  = { error = " ", warn = " ", info = " ", hint = "󰌶 " },
						},
						{ "location", icon = "󰆤" },
					},
					lualine_z = {
						{ function() return "󱑎 " .. os.date("%H:%M") end },
						{
							lsp_status,
							separator = { left = "", right = "" },
							padding   = { left = 1, right = 1 },
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "lazy", "neo-tree", "quickfix", "toggleterm", "man", "trouble", "fzf" },
			})
		end,
	},
}
