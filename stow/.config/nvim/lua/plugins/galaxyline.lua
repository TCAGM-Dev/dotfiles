local colors = {
	bg = "#2d2c33",
	bg2 = "#494949",
	fg = "#ffffff",
}

return {
	src = "https://github.com/NTBBloodbath/galaxyline.nvim",
	dependencies = {"https://github.com/nvim-tree/nvim-web-devicons"},
	config = function()
		local gl = require("galaxyline")
		local gls = gl.section
		local condition = require("galaxyline.condition")

		table.insert(gls.left, {Git = {
			provider = "GitBranch",
			icon = " ",
			highlight = {colors.white, colors.bg2},
			condition = condition.check_git_workspace,
			separator = "",
			separator_highlight = {colors.bg2, nil},
		}})

		table.insert(gls.mid, {FileIcon = {
			provider = "FileIcon",
			condition = condition.buffer_not_empty,
		}})
		table.insert(gls.mid, {File = {
			provider = "FileName",
			condition = condition.buffer_not_empty,
		}})

		table.insert(gls.right, {CursorLocation = {
			provider = "LinePercent",
			highlight = {nil, "#494949"},
			separator = "",
			separator_highlight = {"#494949", nil},
		}})
	end
}