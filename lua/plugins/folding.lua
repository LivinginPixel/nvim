return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		event = "BufReadPost",
		opts = {
			provider_selector = function(_, _, _)
				return { "lsp", "indent" }
			end,
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix    = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth  = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth  = 0
				for _, chunk in ipairs(virtText) do
					local chunkText  = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText  = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end,
		},
		keys = {
			{ "<leader>oaf", function() require("ufo").openAllFolds() end,          desc = "Open All Folds" },
			{ "<leader>cof", function() require("ufo").closeAllFolds() end,         desc = "Close All Folds" },
			{ "<leader>ofk", function() require("ufo").openFoldsExceptKinds() end,  desc = "Open Folds Except Kinds" },
			{ "<leader>ofw", function() require("ufo").closeFoldsWith() end,        desc = "Close Folds With" },
			-- <leader>z* — fold utilities (z is vim's native fold prefix)
			{ "<leader>zp",  function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek Fold Content" },
			{ "<leader>zP",  function() vim.cmd("normal! zP") end,                  desc = "Toggle Fold Preview" },
			-- za / zc / zo / zM / zR are standard vim keys — no <leader> needed
		},
	},
}
