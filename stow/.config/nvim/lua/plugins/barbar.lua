return {
	src = "https://github.com/romgrk/barbar.nvim",
	dependencies = {
		"https://github.com/nvim-tree/nvim-web-devicons",
		"https://github.com/lewis6991/gitsigns.nvim",
	},
	config = function()
		require("barbar").setup({})
	end
}
