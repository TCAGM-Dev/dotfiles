return {
	src = "https://github.com/brenton-leighton/multiple-cursors.nvim",
	config = function()
		require("multiple-cursors").setup({})

		vim.keymap.set({"n", "i"}, "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>")
		vim.keymap.set({"n", "i"}, "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>")
		vim.keymap.set({"n", "i"}, "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>")
		vim.keymap.set({"n", "i"}, "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>")
	end
}