---@type PluginSpec
return {
	src = "https://github.com/akinsho/git-conflict.nvim",
	config = function()
		local conflicts = require("git-conflict")

		conflicts.setup({
			default_mappings = false,
			highlight = {
				incoming = "DiffAdd",
				current = "DiffText",
			},
		})

		vim.api.nvim_create_autocmd("User", {pattern = "GitConflictDetected", callback = function(event) -- Buffer-local logic for 
			local mappingOptions = {buf = event.buf}

			local function resolveMapping(mapping, side)
				vim.keymap.set("n", "<leader>c" .. mapping, function()
					conflicts.choose(side)
				end, mappingOptions)
			end

			resolveMapping("c", "ours")
			resolveMapping("i", "theirs")
			resolveMapping("b", "both")
			resolveMapping("n", "none")
		end})
	end,
}