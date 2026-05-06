return {
	src = "xiyaowong/transparent.nvim",
	config = function()
		require("transparent").setup({
			exclude_groups = {"LineNr", "StatusLine", "CursorLineNr"},
		})
	end
}