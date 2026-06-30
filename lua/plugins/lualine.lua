return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- noctis palette
			local c = {
				bg       = "#1b1f27",   -- background
				bg_dark  = "#13161d",   -- darker bg
				bg_float = "#232836",   -- surface / active line
				fg       = "#aabacf",   -- foreground
				fg_dim   = "#4d5566",   -- comments / dim
				blue     = "#5eccfa",   -- blue / keywords
				blue2    = "#49b8d5",   -- teal / cyan
				purple   = "#e16bdf",   -- pink / purple
				cyan     = "#49b8d5",   -- cyan
				green    = "#84ce90",   -- green / strings
				red      = "#f0564e",   -- red / errors
				yellow   = "#efbc7e",   -- yellow / warnings
				orange   = "#ef8f1b",   -- orange / numbers
				magenta  = "#e16bdf",   -- magenta
			}

			local mode_color = {
				n      = c.blue,
				i      = c.green,
				v      = c.purple,
				V      = c.purple,
				["\22"]= c.purple,
				c      = c.yellow,
				R      = c.red,
				t      = c.cyan,
				s      = c.magenta,
				S      = c.magenta,
			}

			-- Rotating keymap tip — cycles every 45 s so it's noticeable but not distracting
			local function keymap_tip()
				local tips = {
					-- ── Macros (built-in vim — best for repetitive edits) ──
					"q{a-z} → start recording macro to register",
					"q → stop recording macro",
					"@{a-z} → play macro from register",
					"@@ → replay the last macro",
					"{n}@{a-z} → run macro n times (e.g. 10@q)",
					"{n}@@ → repeat last macro n times",

					-- ── Folding ──
					"za → toggle fold under cursor",
					"zc → close fold",
					"zo → open fold",
					"zM → close ALL folds in file",
					"zR → open ALL folds in file",
					"zj / zk → jump to next / prev fold",
					"<leader>oaf → open all folds (ufo)",
					"<leader>cof → close all folds (ufo)",
					"<leader>zp → peek inside fold without opening",

					-- ── DAP Debugging (VS Code keys) ──
					"F5  → debug: start / continue",
					"F9  → debug: toggle breakpoint",
					"F10 → debug: step over",
					"F11 → debug: step into",
					"F12 → debug: step out",
					"F7  → debug: toggle UI panels",
					"<leader>dB → conditional breakpoint",
					"<leader>dC → run to cursor",
					"<leader>dp → pause execution",
					"<leader>dr → toggle debug REPL",
					"<leader>dt → terminate session",
					"<leader>du → toggle DAP UI",
					"<leader>dw → hover variable value",
					"<leader>dl → rerun last debug session",

					-- ── LSP / Code ──
					"gd → go to definition",
					"gpd → peek definition (inline float)",
					"gr → references",
					"gpr → peek references (inline float)",
					"gI → go to implementation",
					"gpi → peek implementations",
					"gt → go to type definition",
					"K → hover documentation",
					"gK → signature help",
					"F2 → rename symbol (live preview)",
					"<leader>ca → code actions",
					"<leader>cf → format document",
					"<leader>cd → line diagnostics float",
					"]d / [d → next / prev diagnostic",
					"]e / [e → next / prev error",
					"]w / [w → next / prev warning",
					"<leader>ui → toggle inlay hints",

					-- ── Treesitter motions ──
					"]f / [f → next / prev function start",
					"]F / [F → next / prev function end",
					"]o / [o → next / prev class start",
					"]a / [a → next / prev parameter",
					"<leader>sp → swap param with next",
					"<leader>sP → swap param with previous",

					-- ── Trouble / Diagnostics ──
					"<leader>xx → toggle Trouble panel",
					"<leader>xd → document diagnostics",
					"<leader>xw → workspace diagnostics",
					"<leader>xl → location list",
					"<leader>xq → quickfix list",
					"]T / [T → next / prev Trouble item",

					-- ── Todo Comments ──
					"]t / [t → next / prev TODO comment",
					"<leader>ft → find all TODOs (telescope)",
					"<leader>fT → find TODO/FIX/FIXME (telescope)",
					"<leader>xt → all TODOs in Trouble",
					"<leader>xT → TODO/FIX/FIXME in Trouble",
					"<leader>tda → insert TODO comment below",
					"<leader>tdf → insert FIX comment below",

					-- ── Multi-cursor ──
					"<M-n> → select next occurrence",
					"<M-a> → select ALL occurrences",
					"<M-x> → skip current, go to next match",
					"<M-j/k> → add cursor down / up",
					"<M-f> → multi-cursor regex search",

					-- ── Testing ──
					"<leader>Tr → run nearest test",
					"<leader>Tf → run all tests in file",
					"<leader>Ta → run entire test suite",
					"<leader>Ts → toggle test summary panel",
					"<leader>To → show test output",
					"<leader>TO → toggle output panel",
					"<leader>Tx → stop running test",
					"<leader>Td → debug nearest test via DAP",

					-- ── Database ──
					"<leader>Db → toggle DB UI panel",
					"<leader>Da → add a DB connection",
					"<leader>Df → find open DB buffer",

					-- ── Git ──
					"]h / [h → next / prev git hunk",
					"<leader>hs → stage hunk",
					"<leader>hr → reset hunk",
					"<leader>hS → stage entire buffer",
					"<leader>hu → undo last staged hunk",
					"<leader>hp → preview hunk inline",
					"<leader>hb → blame line (full message)",
					"<leader>tb → toggle inline git blame",
					"<leader>hd → diff this vs HEAD",
					"<leader>td → toggle deleted lines (git)",

					-- ── Telescope ──
					"<leader>ff → find files",
					"<leader>fg → live grep across project",
					"<leader>fb → find open buffers",
					"<leader>fr → recent files",
					"<leader>fs → document symbols",
					"<leader>fS → workspace symbols",
					"<leader>fk → browse ALL keymaps",
					"<leader>fd → diagnostics in telescope",
					"<leader>fc → command palette",

					-- ── Editor ──
					"gcc → toggle line comment",
					"gc{motion} → comment a motion",
					"ys{motion}{c} → surround motion with char",
					"cs{old}{new} → change surround char",
					"ds{c} → delete surround char",
					"S (visual) → surround selection",
					"<A-j/k> → move line / selection up / down",
					"<M-e> → fast wrap (autopairs)",
					"< / > (visual) → indent and keep selection",

					-- ── Terminal ──
					"<C-`> → toggle terminal",
					"<leader>tf → floating terminal",
					"<leader>th → horizontal terminal",
					"<leader>tv → vertical terminal",

					-- ── Windows ──
					"<leader>wv → vertical split",
					"<leader>wh → horizontal split",
					"<C-h/j/k/l> → move between windows",
					"<A-arrows> → resize current window",

					-- ── Python ──
					"<leader>pv → pick Python virtualenv",
					"<leader>pc → reuse last selected venv",

					-- ── Misc ──
					"<C-n> → toggle file explorer",
					"<C-a> → select all",
					"<leader>/ → clear search highlight",
					"<leader>uT → toggle dark / light theme",
					"<leader>qs → restore session",
					"<leader>qS → pick a saved session",
					"<M-l> → accept Copilot suggestion",
					"<M-]> / <M-[> → next / prev Copilot suggestion",
					"<leader>fk → see ALL keymaps in telescope",
				}
				local idx = math.floor(vim.uv.hrtime() / 45e9) % #tips + 1
				return " " .. tips[idx]
			end

			-- Creepy rotating quote
			local function creepy_quote()
				local quotes = {
					"ᚠᚢᚦᚨᚱᚲ: the old runes whisper",
					"echo $DOOM",
					"alias vim='neovim.exe'",
					"rm -rf ~/.sanity",
					":wq and pray",
					"Watch your back",
					"spell doom backwards",
					"0xDEAD 0xBEEF",
					"Another day, another curse",
					"crush it down",
					"Death is just the beginning",
					"whisper DOOM to summon the darkness",
					"The void stares back at you",
					"sudo rm -rf /hope",
					"Memory leak detected in soul.exe",
					"404: Happiness not found",
					"Segfault in reality",
					"Undefined behavior ahead",
					"Stack overflow in dreams",
					"NULL pointer to happiness",
					"Buffer overflow in emotions",
					"Race condition with destiny",
					"Deadlock in life.thread",
					"Exception: SanityNotFoundException",
				}
				local idx = math.floor(vim.uv.hrtime() / 3e9) % #quotes + 1
				return quotes[idx]
			end

			-- Cached git dirty check (async, no blocking)
			local _dirty = false
			local _dirty_ts = 0
			local function commit_sins()
				local now = vim.uv.hrtime() / 1e9
				if now - _dirty_ts > 5 then
					_dirty_ts = now
					vim.system({ "git", "status", "--porcelain" }, { text = true }, function(r)
						_dirty = r.code == 0 and r.stdout ~= ""
					end)
				end
				if _dirty then
					return "commit your sins"
				end
				return "You have no sins, you have been forgiven"
			end

			-- Cached count of commits ahead of upstream
			local _ahead = 0
			local _ahead_ts = 0
			local function git_ahead()
				local now = vim.uv.hrtime() / 1e9
				if now - _ahead_ts > 10 then
					_ahead_ts = now
					vim.system(
						{ "git", "rev-list", "--count", "@{upstream}..HEAD" },
						{ text = true },
						function(r)
							if r.code == 0 then
								_ahead = tonumber((r.stdout:gsub("%s+", ""))) or 0
							else
								_ahead = 0
							end
						end
					)
				end
				if _ahead > 0 then return "↑" .. _ahead end
				return ""
			end

			local function cursed_mode()
				local labels = {
					n      = "☠ NORMAL",
					i      = "👻 INSERT",
					v      = "🔪 VISUAL",
					V      = "🔪 V·LINE",
					["\22"]= "🔪 V·BLOCK",
					c      = "💀 COMMAND",
					R      = "🔁 REPLACE",
					t      = "🧪 TERMINAL",
					s      = "🐍 SELECT",
					S      = "🐍 S·LINE",
				}
				return labels[vim.fn.mode()] or "👀 UNKNOWN"
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
				return "⏺ rec @" .. reg
			end

			local function python_env()
				local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
				if venv then return "🐍 " .. vim.fn.fnamemodify(venv, ":t") end
				return ""
			end

			local function diag_counts()
				local E = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				local W = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				local I = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				local H = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				if E + W + I + H == 0 then return "✨ clean" end
				local parts = {}
				if E > 0 then table.insert(parts, " " .. E) end
				if W > 0 then table.insert(parts, " " .. W) end
				if I > 0 then table.insert(parts, " " .. I) end
				if H > 0 then table.insert(parts, "󰌶 " .. H) end
				return table.concat(parts, "  ")
			end

			-- custom theme — all sections share the same dark bg so the bar is seamless
			local theme = {
				normal   = {
					a = { fg = c.bg_dark, bg = c.blue,   gui = "bold" },
					b = { fg = c.fg,      bg = c.bg_float },
					c = { fg = c.fg_dim,  bg = c.bg },
				},
				insert   = { a = { fg = c.bg_dark, bg = c.green,   gui = "bold" } },
				visual   = { a = { fg = c.bg_dark, bg = c.purple,  gui = "bold" } },
				command  = { a = { fg = c.bg_dark, bg = c.yellow,  gui = "bold" } },
				replace  = { a = { fg = c.bg_dark, bg = c.red,     gui = "bold" } },
				terminal = { a = { fg = c.bg_dark, bg = c.cyan,    gui = "bold" } },
				inactive = {
					a = { fg = c.fg_dim, bg = c.bg },
					b = { fg = c.fg_dim, bg = c.bg },
					c = { fg = c.fg_dim, bg = c.bg },
				},
			}

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
							cursed_mode,
							color = function()
								return { fg = c.bg_dark, bg = mode_color[vim.fn.mode()] or c.blue, gui = "bold" }
							end,
							separator = { left = "", right = "" },
							padding   = { left = 1, right = 1 },
						},
					},
					lualine_b = {
						{
							"branch",
							icon  = "",
							color = { fg = c.bg_dark, bg = c.magenta, gui = "bold" },
							separator = { left = "", right = "" },
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
							diff_color = {
								added    = { fg = c.green },
								modified = { fg = c.yellow },
								removed  = { fg = c.red },
							},
							color = { bg = c.bg_float },
						},
						{
							git_ahead,
							color = { fg = c.blue, bg = c.bg_float, gui = "bold" },
							padding = { left = 1, right = 1 },
						},
					},
					lualine_c = {
						{
							"filename",
							path    = 1,
							symbols = { modified = " ●", readonly = " ", unnamed = "󰡯", newfile = " " },
							color   = { fg = c.fg, bg = c.bg, gui = "bold" },
						},
						{
							keymap_tip,
							color   = { fg = c.blue2, gui = "italic" },
							padding = { left = 2, right = 1 },
						},
						{
							commit_sins,
							color   = { fg = c.fg_dim, gui = "italic" },
							padding = { left = 2, right = 1 },
						},
					},
					lualine_x = {
						{ macro_rec,    color = { fg = c.red,    gui = "bold" } },
						{ python_env,   color = { fg = c.green,  gui = "italic" } },
						{
							"filetype",
							colored  = true,
							icon_only = false,
							color    = { fg = c.fg, bg = c.bg_float },
							separator = { left = "", right = "" },
						},
					},
					lualine_y = {
						{
							diag_counts,
							color = { fg = c.fg, bg = c.bg_float },
							separator = { left = "", right = "" },
						},
						{
							"location",
							icon  = "󰆤",
							color = { fg = c.bg_dark, bg = c.blue2, gui = "bold" },
							separator = { left = "", right = "" },
						},
					},
					lualine_z = {
						{
							function() return "󱑎 " .. os.date("%H:%M") end,
							color = { fg = c.bg_dark, bg = c.purple, gui = "bold" },
							separator = { left = "", right = "" },
						},
						{
							lsp_status,
							color = { fg = c.bg_dark, bg = c.blue, gui = "bold" },
							separator = { left = "", right = "" },
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1, color = { fg = c.fg_dim } } },
					lualine_x = { { "location", color = { fg = c.fg_dim } } },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "lazy", "neo-tree", "quickfix", "toggleterm", "man", "trouble", "fzf" },
			})
		end,
	},
}
