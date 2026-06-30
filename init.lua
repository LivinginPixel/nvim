-- init.lua
-- Entry point for Neovim configuration

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Compatibility shim: some plugin versions pass { create = false } to
-- nvim_get_hl(), but older Neovim builds reject that key.
do
	local get_hl = vim.api.nvim_get_hl
	if get_hl then
		local supports_create = pcall(get_hl, 0, { name = "Normal", link = false, create = false })
		if not supports_create then
			vim.api.nvim_get_hl = function(ns_id, opts)
				if type(opts) == "table" and opts.create ~= nil then
					local clean_opts = {}
					for k, v in pairs(opts) do
						if k ~= "create" then
							clean_opts[k] = v
						end
					end
					opts = clean_opts
				end
				return get_hl(ns_id, opts)
			end
		end
	end
end

-- Basic Neovim settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Setup lazy.nvim
require("config.lazy")
