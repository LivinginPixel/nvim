-- lua/plugins/lsp/keymaps.lua
-- LSP keymaps for a VS Code-like experience

local M = {}

function M.on_attach(client, buffer)
	local self = M.new(client, buffer)

	-- Enable inlay hints for this buffer if the server supports them
	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
	end

	-- Navigation
	self:map("gd", function()
		vim.lsp.buf.definition()
	end, { desc = "Goto Definition" })
	self:map("gr", function()
		vim.lsp.buf.references()
	end, { desc = "References" })
	self:map("gD", function()
		vim.lsp.buf.declaration()
	end, { desc = "Goto Declaration" })
	self:map("gI", function()
		vim.lsp.buf.implementation()
	end, { desc = "Goto Implementation" })
	self:map("gt", function()
		vim.lsp.buf.type_definition()
	end, { desc = "Goto Type Definition" })

	-- Documentation
	self:map("K", function()
		vim.lsp.buf.hover()
	end, { desc = "Hover" })
	self:map("gK", function()
		vim.lsp.buf.signature_help()
	end, { desc = "Signature Help" })
	self:map("<C-k>", function()
		vim.lsp.buf.signature_help()
	end, { mode = "i", desc = "Signature Help" })

	-- Code Actions
	self:map("<leader>ca", function()
		vim.lsp.buf.code_action()
	end, { desc = "Code Action", mode = { "n", "v" } })

	-- Rename: F2 and <leader>cr use inc-rename for live preview
	self:map("<F2>", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true, desc = "Rename Symbol" })
	self:map("<leader>cr", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true, desc = "Rename Symbol" })

	-- Toggle inlay hints for this buffer
	self:map("<leader>ui", function()
		local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
		vim.lsp.inlay_hint.enable(not enabled, { bufnr = buffer })
		vim.notify(
			"Inlay hints " .. (enabled and "disabled" or "enabled"),
			vim.log.levels.INFO,
			{ title = "LSP" }
		)
	end, { desc = "Toggle Inlay Hints" })

	-- Diagnostics
	self:map("<leader>cd", function()
		vim.diagnostic.open_float()
	end, { desc = "Line Diagnostics" })
	self:map("]d", function()
		vim.diagnostic.goto_next()
	end, { desc = "Next Diagnostic" })
	self:map("[d", function()
		vim.diagnostic.goto_prev()
	end, { desc = "Prev Diagnostic" })
	self:map("]e", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, { desc = "Next Error" })
	self:map("[e", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, { desc = "Prev Error" })
	self:map("]w", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
	end, { desc = "Next Warning" })
	self:map("[w", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
	end, { desc = "Prev Warning" })

	-- Workspace
	self:map("<leader>wa", function()
		vim.lsp.buf.add_workspace_folder()
	end, { desc = "Add Folder" })
	self:map("<leader>wr", function()
		vim.lsp.buf.remove_workspace_folder()
	end, { desc = "Remove Folder" })
	self:map("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, { desc = "List Folders" })
end

function M.new(client, buffer)
	return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
	return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
	opts = opts or {}
	if opts.has and not self:has(opts.has) then
		return
	end
	vim.keymap.set(
		opts.mode or "n",
		lhs,
		type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
		---@diagnostic disable-next-line: no-unknown
		{ silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
	)
end

return M
