return {
	src = "https://github.com/romgrk/barbar.nvim",
	dependencies = {
		"https://github.com/nvim-tree/nvim-web-devicons",
		"https://github.com/lewis6991/gitsigns.nvim",
	},
	config = function()
		require("barbar").setup({})

		vim.keymap.set({ "n" }, "<C-L>", "<Cmd>BufferNext<CR>")
		vim.keymap.set({ "n" }, "<C-H>", "<Cmd>BufferPrevious<CR>")
		vim.keymap.set({ "n" }, "<CS-L>", "<Cmd>BufferMoveNext<CR>")
		vim.keymap.set({ "n" }, "<CS-H>", "<Cmd>BufferMovePrevious<CR>")
		vim.keymap.set({ "n" }, "<C-W>", "<Cmd>BufferClose<CR>")
	end
}
