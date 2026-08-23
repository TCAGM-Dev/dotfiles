---@type Spec
return {
	src = "https://github.com/f-person/git-blame.nvim",
	config = function()
		require("gitblame").setup({
			enabled = false,

			schedule_event = "CursorHold",
			clear_event = "CursorMovedI",
		})
	end,
}