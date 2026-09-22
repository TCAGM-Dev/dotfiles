---@type PluginSpec
return {
	src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	config = function()
		vim.diagnostic.config({virtual_text = false})

		require("tiny-inline-diagnostic").setup({
			hi = {
				mixing_color = "StatusLine", -- Using fully transparent `Normal` (default) highlight
			},
			signs = {
				left = "",
				right = "",
			},
			blend = {
				factor = 0.17,
			},
		})
	end,
}