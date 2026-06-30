return {
	-- VS Code-like Notifications with nvim-notify
	{
		"rcarriga/nvim-notify",
		-- Keybindings for dismissing notifications
		keys = {
			{
				"<leader>un", -- Trigger keybinding for dismissing all notifications
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss all notifications", -- Description for clarity
			},
			{
				"<leader>uN", -- Toggle notifications on/off
				function()
					local notify = require("notify")
					if notify._config.timeout == 0 then
						notify.setup({ timeout = 2000 }) -- Re-enable
						vim.notify("Notifications enabled", "info")
					else
						notify.setup({ timeout = 0 }) -- Disable
						vim.notify("Notifications disabled", "info")
					end
				end,
				desc = "Toggle notifications", -- Description for clarity
			},
		},

		-- Options for customizing notification behavior
		opts = {
			timeout = 2000, -- Reduced timeout for quicker dismissal
			max_height = function()
				return math.floor(vim.o.lines * 0.25) -- 25% of screen height
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.3) -- 30% of screen width
			end,
			on_open = function(win)
				-- Set zindex but make it less intrusive
				vim.api.nvim_win_set_config(win, { zindex = 50 })
			end,
			background_colour = "#1a1a1a", -- Darker background
			render = "compact", -- More compact rendering
			stages = "fade", -- Fade animation instead of slide
			top_down = false, -- Show from bottom up
		},

		-- Initialization for fallback when Noice is not available
		init = function()
			-- Use 'notify' for notifications in Neovim
			vim.notify = require("notify")
		end,
	},
}
