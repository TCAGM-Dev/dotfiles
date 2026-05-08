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

		vim.keymap.set({"n"}, "<CA-O>", function()
			local path = vim.fn.expand("%:h")
			require("oil").open(path)
		end)
	end
}