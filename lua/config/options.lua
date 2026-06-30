-- lua/config/options.lua
-- General Neovim settings

local opt = vim.opt

-- UI
opt.guifont = "Cartograph CF:h13"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false
opt.conceallevel = 2
opt.list = true
vim.opt.listchars = "tab:» ,trail:·,nbsp:␣"
opt.pumblend = 0
opt.pumheight = 10
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.winblend = 0
opt.cmdheight = 0      -- hide cmdline when not in use (noice handles display)
opt.shortmess:append("c")
opt.shortmess:append("S") -- suppress search count, noice shows it

-- Fill characters: clean box-drawing at split corners, no ~ at end of buffer
opt.fillchars = {
	horiz      = "─",
	horizup    = "┴",
	horizdown  = "┬",
	vert       = "│",
	vertleft   = "┤",
	vertright  = "├",
	verthoriz  = "┼",
	eob        = " ",  -- hide end-of-buffer tilde
	fold       = " ",
	foldopen   = "▾",
	foldclose  = "▸",
	foldsep    = " ",
	diff       = "╱",
}

-- Neovide: zero padding so the editor fills the window edge to edge
if vim.g.neovide then
	vim.g.neovide_padding_top    = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right  = 0
	vim.g.neovide_padding_left   = 0
	vim.g.neovide_window_blurred = false
end

-- Behavior
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect" -- Better completion experience
opt.confirm = true -- confirm to save changes before exiting
opt.mouse = "a" -- enable mouse mode
opt.undofile = true -- save undo history
opt.undolevels = 10000 -- maximum number of changes that can be undone
opt.updatetime = 200 -- faster completion
opt.timeoutlen = 300 -- time to wait for a mapped sequence to complete
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.swapfile = false -- don't use swapfile

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for
opt.smartindent = true -- Insert indents automatically
opt.wrap = false -- Disable line wrap
opt.breakindent = true -- Enable break indent

-- Search
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.inccommand = "split" -- Preview substitutions live

-- Windows
opt.title = true -- Set the window title
opt.titlestring = "%<%F%=%l/%L - nvim" -- Format of the window title

-- Folding (using Treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true -- Disable folding by default
opt.foldlevel = 99

-- Global statusline
opt.laststatus = 3

-- Disable some built-in plugins
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
}

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end
