return {
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function() require("notify").dismiss({ silent = true, pending = true }) end,
				desc = "Dismiss all notifications",
			},
		},
		opts = {
			timeout   = 3000,
			render    = "wrapped-compact",
			stages    = "fade",
			top_down  = false,
			max_height = function() return math.floor(vim.o.lines * 0.25) end,
			max_width  = function() return math.floor(vim.o.columns * 0.35) end,
			on_open   = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 50 })
			end,
		},
		init = function()
			vim.notify = require("notify")
		end,
	},
}
