---@type Spec
return {
	src = "https://github.com/ibhagwan/fzf-lua",
	dependencies = {"https://github.com/nvim-tree/nvim-web-devicons"},
	config = function()
		require("fzf-lua").setup({fzf_colors = true})

		vim.keymap.set({"n"}, "<C-o>", "<Cmd>FzfLua files<CR>")
	end
}