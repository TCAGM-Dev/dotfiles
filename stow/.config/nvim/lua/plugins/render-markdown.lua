---@type PluginSpec
return {
	src = {
		"https://github.com/MeanderingProgrammer/render-markdown.nvim",

		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("render-markdown").setup({
			completions = {lsp = {enabled = true}},
		})
	end,
}