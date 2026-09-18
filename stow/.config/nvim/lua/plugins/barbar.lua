---@type PluginSpec
return {
	src = {
		"https://github.com/romgrk/barbar.nvim",

		"https://github.com/nvim-tree/nvim-web-devicons",
		"https://github.com/lewis6991/gitsigns.nvim",
	},
	config = function()
		require("barbar").setup({})

		vim.keymap.set({"n"}, "<A-]>",  "<Cmd>BufferNext<CR>")
		vim.keymap.set({"n"}, "<A-[>",  "<Cmd>BufferPrevious<CR>")
		vim.keymap.set({"n"}, "<AS-]>", "<Cmd>BufferMoveNext<CR>")
		vim.keymap.set({"n"}, "<AS-[>", "<Cmd>BufferMovePrevious<CR>")
	end
}