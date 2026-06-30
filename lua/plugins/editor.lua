-- lua/plugins/editor.lua
-- Editor enhancements for a modern VS Code-like experience

return {

	-- 🧠 Smart commenting with gcc, gc, etc.
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		opts = {
			padding = true,
			sticky = true,
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			extra = {
				above = "gcO",
				below = "gco",
				eol = "gcA",
			},
			mappings = {
				basic = true,
				extra = true,
			},
			pre_hook = nil,
			post_hook = nil,
		},
	},

	-- 🔄 Surround text objects effortlessly like in VS Code
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "BufReadPost",
		-- v4: keymaps declared as keys specs, not via setup()
		keys = {
			{ "<C-g>s", mode = "i",          desc = "Surround: insert" },
			{ "<C-g>S", mode = "i",          desc = "Surround: insert line" },
			{ "ys",     mode = "n",          desc = "Surround: add" },
			{ "yss",    mode = "n",          desc = "Surround: add line" },
			{ "yS",     mode = "n",          desc = "Surround: add line (whole)" },
			{ "ySS",    mode = "n",          desc = "Surround: add line cur" },
			{ "S",      mode = "v",          desc = "Surround: visual" },
			{ "gS",     mode = "v",          desc = "Surround: visual line" },
			{ "ds",     mode = "n",          desc = "Surround: delete" },
			{ "cs",     mode = "n",          desc = "Surround: change" },
		},
		opts = {},
	},

	-- ⚡ Autopairs like a beast + Treesitter-aware
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%)%>%]%)%}%,]]=],
				offset = 0,
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			npairs.setup(opts)

			-- Integrate with nvim-cmp if installed
			local has_cmp, cmp = pcall(require, "cmp")
			if has_cmp then
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end,
	},

}
