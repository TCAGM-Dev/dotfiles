---@type Spec
return {
	src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	config = function()
		vim.diagnostic.config({virtual_text = false})

		require("tiny-inline-diagnostic").setup() -- TODO: Customize
	end,
}