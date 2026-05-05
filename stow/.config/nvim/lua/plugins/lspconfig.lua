return function(lsps) return {
	src = "https://github.com/neovim/nvim-lspconfig",
	config = function()
		for name, opts in pairs(lsps) do
			vim.lsp.config(name, opts)
			vim.lsp.enable(name)
		end
	end
} end
