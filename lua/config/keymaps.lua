local keymap = vim.keymap.set
local opts = function(desc) return { noremap = true, silent = true, desc = desc } end

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts("Move to left window"))
keymap("n", "<C-j>", "<C-w>j", opts("Move to bottom window"))
keymap("n", "<C-k>", "<C-w>k", opts("Move to top window"))
keymap("n", "<C-l>", "<C-w>l", opts("Move to right window"))

-- Window resize (Alt + arrow)
keymap("n", "<A-Up>",    ":resize +2<CR>",          opts("Resize window up"))
keymap("n", "<A-Down>",  ":resize -2<CR>",           opts("Resize window down"))
keymap("n", "<A-Left>",  ":vertical resize -2<CR>",  opts("Resize window left"))
keymap("n", "<A-Right>", ":vertical resize +2<CR>",  opts("Resize window right"))

-- Buffer navigation (also handled by bufferline <S-h>/<S-l>)
keymap("n", "<leader>bn", ":enew<CR>", opts("New buffer"))

-- Clear search highlights (<leader>/ is intuitive, <Esc> also clears)
keymap("n", "<leader>/", ":nohlsearch<CR>", opts("Clear highlights"))
keymap("n", "<Esc>",     ":nohlsearch<CR>", opts("Clear highlights"))

-- Quit
keymap("n", "<leader>qq", ":q<CR>",  opts("Quit"))
keymap("n", "<leader>qQ", ":qa!<CR>", opts("Force quit all"))

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", opts("Select all"))

-- Indentation keeps selection
keymap("v", "<", "<gv", opts("Indent left"))
keymap("v", ">", ">gv", opts("Indent right"))

-- Move lines
keymap("n", "<A-j>", ":m .+1<CR>==",        opts("Move line down"))
keymap("n", "<A-k>", ":m .-2<CR>==",        opts("Move line up"))
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv",   opts("Move selection down"))
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv",   opts("Move selection up"))

-- Center on scroll / search
keymap("n", "<C-d>", "<C-d>zz",   opts("Scroll down and center"))
keymap("n", "<C-u>", "<C-u>zz",   opts("Scroll up and center"))
keymap("n", "n",     "nzzzv",     opts("Next search result"))
keymap("n", "N",     "Nzzzv",     opts("Prev search result"))

-- Paste without overwriting register
keymap("v", "p", '"_dP', opts("Paste without copying"))

-- Delete without yanking
keymap("n", "d", '"_d', opts("Delete (no yank)"))
keymap("v", "d", '"_d', opts("Delete (no yank)"))

-- Yank to system clipboard
keymap("n", "y", '"+y', opts("Yank to clipboard"))
keymap("v", "y", '"+y', opts("Yank to clipboard"))
keymap("n", "Y", '"+Y', opts("Yank line to clipboard"))

-- Splits
keymap("n", "<leader>wv", ":vsplit<CR>", opts("Split vertical"))
keymap("n", "<leader>wh", ":split<CR>",  opts("Split horizontal"))
keymap("n", "<leader>wc", "<C-w>c",      opts("Close window"))
keymap("n", "<leader>wo", "<C-w>o",      opts("Close other windows"))
