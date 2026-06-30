-- lua/plugins/testing.lua
-- Neotest: run pytest, jest, and vitest inline with gutter indicators

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- adapters
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
		},
		keys = {
			-- <leader>T = test namespace (avoids clash with <leader>t = terminal)
			{ "<leader>Tr", function() require("neotest").run.run() end,                             desc = "Run Nearest Test" },
			{ "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end,           desc = "Run File" },
			{ "<leader>Ta", function() require("neotest").run.run(vim.fn.getcwd()) end,              desc = "Run All Tests" },
			{ "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end,         desc = "Debug Test" },
			{ "<leader>Ts", function() require("neotest").summary.toggle() end,                      desc = "Toggle Summary" },
			{ "<leader>To", function() require("neotest").output.open({ enter = true }) end,          desc = "Show Output" },
			{ "<leader>TO", function() require("neotest").output_panel.toggle() end,                 desc = "Toggle Output Panel" },
			{ "<leader>Tx", function() require("neotest").run.stop() end,                            desc = "Stop Test" },
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap            = { justMyCode = false },
						runner         = "pytest",
						python         = function()
							-- respect active venv if venv-selector is in use
							local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV")
							if venv then
								return venv .. "/bin/python"
							end
							return "python"
						end,
					}),
					require("neotest-jest")({
						-- works for both CRA and Next.js jest setups
						jestCommand = function(path)
							local root = vim.fn.fnamemodify(
								vim.fn.finddir("node_modules", path .. ";"),
								":h"
							)
							local local_jest = root .. "/node_modules/.bin/jest"
							if vim.fn.executable(local_jest) == 1 then
								return local_jest
							end
							return "npx jest"
						end,
						env      = { CI = true },
						cwd      = function() return vim.fn.getcwd() end,
					}),
					require("neotest-vitest"),
				},

				icons = {
					expanded         = "",
					child_prefix     = "├",
					child_indent     = "│",
					final_child_prefix = "└",
					non_collapsible  = "─",
					collapsed        = "",
					passed           = "",
					failed           = "",
					running          = "",
					skipped          = "",
					unknown          = "",
					watching         = "",
				},

				status = {
					virtual_text = true,
					signs        = true,
				},

				output = {
					open_on_run = "short",
				},

				summary = {
					open       = "botright vsplit | vertical resize 50",
					animated   = true,
				},

				quickfix = {
					open = false,
				},
			})
		end,
	},
}
