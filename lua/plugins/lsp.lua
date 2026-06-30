-- lsp lua configuration

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			{ "williamboman/mason-lspconfig.nvim" },
			{
				"hrsh7th/cmp-nvim-lsp",
				cond = function()
					return require("utils").has("nvim-cmp")
				end,
			},
		},
		config = function()
			local Util = require("utils")

			-- setup autoformat
			Util.format.register(Util.lsp.formatter())

			-- setup keymaps
			Util.lsp.on_attach(function(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			-- diagnostics
			local icons = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for name, icon in pairs(icons) do
				local hl = "DiagnosticSign" .. name
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = function(diagnostic)
						local icons2 = { [1] = " ", [2] = " ", [3] = " ", [4] = " " }
						return icons2[diagnostic.severity] or "● "
					end,
				},
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
				severity_sort = true,
				signs = true,
			})

			-- global capabilities for all servers
			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)
			vim.lsp.config("*", { capabilities = capabilities })

			-- per-server settings
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
							hint = { enable = true },
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								diagnosticMode = "workspace",
								inlayHints = {
									variableTypes = true,
									functionReturnTypes = true,
								},
							},
						},
					},
				},
				ts_ls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				html = {},
				cssls = {},
				jsonls = {},
				yamlls = {},
				marksman = {},
				tailwindcss = {},
				clangd = {},
			}

			-- apply per-server configs via vim.lsp.config (Neovim 0.11+)
			for server, opts in pairs(servers) do
				if opts and next(opts) then
					vim.lsp.config(server, opts)
				end
			end

			-- install servers and auto-enable them
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_enable = true,
			})

			-- disable ts_ls in Deno projects
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end
					local root = client.root_dir or vim.fn.getcwd()
					local is_deno = vim.fs.find({ "deno.json", "deno.jsonc" }, { path = root, upward = true })[1]
					if client.name == "ts_ls" and is_deno then
						client.stop()
					elseif client.name == "denols" and not is_deno then
						client.stop()
					end
				end,
			})
		end,
	},
}
