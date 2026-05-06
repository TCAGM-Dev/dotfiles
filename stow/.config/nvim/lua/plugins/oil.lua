return {
	src = "https://github.com/stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			view_options = {
				is_hidden_file = function(name, bufnr)
					return name == "./"
				end
			}
		})
	end
}