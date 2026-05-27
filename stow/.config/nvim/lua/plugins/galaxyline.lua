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
			highlight = {colors.fg, colors.bg2},
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
		table.insert(gls.mid, {DiagnosticError = {
			provider = "DiagnosticError",
			icon = " ",
			highlight = {"#ff6060", nil},
		}})
		table.insert(gls.mid, {DiagnosticWarn = {
			provider = "DiagnosticWarn",
			icon = " ",
			highlight = {"#ffd040", nil},
		}})
		table.insert(gls.mid, {DiagnosticHint = {
			provider = "DiagnosticHint",
			icon = " ",
			highlight = {"#60b0ff", nil},
		}})

		table.insert(gls.right, {CursorLocation = {
			provider = "LinePercent",
			highlight = {nil, colors.bg2},
			separator = "",
			separator_highlight = {colors.bg2, nil},
		}})
	end
}