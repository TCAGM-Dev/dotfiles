local colors = {
	bg = "#2d2c33",
	bg2 = "#494949",
	fg = "#ffffff",
}

local modes = setmetatable({
	n      = {text = "NORMAL",       color = "#ffffff"},
	i      = {text = "INSERT",       color = "#b0ffb0"},
	v      = {text = "VISUAL",       color = "#80bcff"},
	V      = {text = "VISUAL-LINE",  color = "#80bcff"},
	[''] = {text = "VISUAL-BLOCK", color = "#80bcff"},
	t      = {text = "TERMINAL",     color = "#b0a0ff"},
	['!']  = {text = "SHELL",        color = "#b0a0ff"},
	R      = {text = "REPLACE",      color = "#ffa0e0"},
	c      = {text = "COMMAND",      color = "#ff7070"},
}, {__index = function(_, mode) return {text = "UNKNOWN MODE: " .. mode, color = "red"} end})

---@type Spec
return {
	src = "https://github.com/NTBBloodbath/galaxyline.nvim",
	dependencies = {"https://github.com/nvim-tree/nvim-web-devicons"},
	config = function()
		local gl = require("galaxyline")
		local gls = gl.section
		local condition = require("galaxyline.condition")

		table.insert(gls.left, {Mode = {
			provider = function()
				local m = vim.fn.mode()
				local mode = modes[m]
				vim.api.nvim_set_hl(0, "GalaxyLineMode", {fg = "black", bg = mode.color})
				vim.api.nvim_set_hl(0, "GalaxyLineModeSeo", {fg = mode.color, bg = nil})
				return mode.text
			end,
			highlight = "GalaxyLineMode",
			separator = "",
			separator_highlight = "GalaxyLineModeSep",
		}})
		table.insert(gls.left, {Cwd = {
			provider = function() return vim.fn.getcwd() end,
			icon = " ",
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

		table.insert(gls.right, {GitRemoved = {
			provider = "DiffRemove",
			icon = "-",
			highlight = {"#ffc0b9", nil},
			condition = condition.check_git_workspace,
		}})
		table.insert(gls.right, {GitModified = {
			provider = "DiffModified",
			icon = "~",
			highlight = {"#8cf7f6", nil},
			condition = condition.check_git_workspace,
		}})
		table.insert(gls.right, {GitAdded = {
			provider = "DiffAdd",
			icon = "+",
			highlight = {"#b3f6c0", nil},
			condition = condition.check_git_workspace,
		}})
		table.insert(gls.right, {Git = {
			provider = "GitBranch",
			icon = "  ",
			highlight = {nil, colors.bg2},
			condition = condition.check_git_workspace,
			separator = "",
			separator_highlight = {colors.bg2, nil},
		}})
	end
}