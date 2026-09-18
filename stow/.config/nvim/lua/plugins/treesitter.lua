---@type PluginSpec
return {
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter").setup({
			highlight = {
				enable = true,
			},
		})
	end,
}