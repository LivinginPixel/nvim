return {
	"kartikp10/noctis.nvim",
	dependencies = { "rktjmp/lush.nvim" },
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("noctis")

		local function apply_overrides()
			local hl = function(group, val) vim.api.nvim_set_hl(0, group, val) end

			-- Visual selection: noctis ships with #2a2a2a which is nearly invisible
			-- on the #141414 background. Use a teal-tinted dark bg that reads clearly.
			hl("Visual",    { bg = "#1a3a30" })
			hl("VisualNOS", { bg = "#1a3a30" })

			-- Richer treesitter semantic tokens
			hl("@variable",           { fg = "#c8d3f5" })           -- plain vars: soft blue-white
			hl("@variable.builtin",   { fg = "#ff91c1", italic = true }) -- self/this: pink italic
			hl("@property",           { fg = "#8cb6ff" })           -- obj.prop: light blue
			hl("@field",              { fg = "#8cb6ff" })
			hl("@parameter",          { fg = "#78dcca" })           -- fn params: aqua
			hl("@namespace",          { fg = "#c8a5ff", italic = true })
			hl("@constructor",        { fg = "#3ddbd9" })
			hl("@punctuation.bracket",{ fg = "#be95ff" })           -- () [] {} : purple tint
			hl("@punctuation.delimiter",{ fg = "#7b7c7e" })        -- , ; : dim
			hl("@tag",                { fg = "#33b1ff" })
			hl("@tag.attribute",      { fg = "#08bdba" })
			hl("@tag.delimiter",      { fg = "#7b7c7e" })
			hl("@string.escape",      { fg = "#ff91c1", bold = true })
			hl("@constant.builtin",   { fg = "#ff91c1", italic = true })
			hl("@function.builtin",   { fg = "#00b4cc", italic = true })
			hl("@type.builtin",       { fg = "#5ae0df", italic = true })
		end

		apply_overrides()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_overrides })

		vim.keymap.set("n", "<leader>uT", function()
			if vim.o.background == "dark" then
				vim.o.background = "light"
				vim.cmd.colorscheme("noctis_lux")
			else
				vim.o.background = "dark"
				vim.cmd.colorscheme("noctis")
			end
			vim.notify("Switched to " .. vim.o.background .. " theme", "info", { title = "Theme Toggle" })
		end, { desc = "Toggle Theme Background (Dark/Light)" })
	end,
}
