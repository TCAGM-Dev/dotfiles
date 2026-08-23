vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "foolmoonnight"

local function hl(...)
	vim.api.nvim_set_hl(0, ...)
end

-----------------------------------

-- Editor interface

hl("Normal", {fg = "#ffffff"})
hl("CursorLine", {bg = "#373737"})
hl("CursorLineNr", {link = "CursorLine"})
hl("Visual", {bg = "#6e6e6e"})
hl("LineNr", {fg = "#777777", bg = "#171717"})
--hl("NonText", {})
hl("SpecialKey", {link = "NonText"})
hl("StatusLine", {bg = "#2c2e33"})
hl("StatusLineNC", {link = "StatusLine"})
hl("VertSplit", {bg = "#00ff00"})
hl("TabLine", {link = "StatusLineNC"})
hl("TabLineFill", {link = "TabLine"})
hl("TabLineSel", {bg = "#494949"})
hl("ColorColumn", {bg = "#171717"})
hl("SignColumn", {link = "LineNr"})
hl("FoldColumn", {bg = "#0000ff"})
hl("Folded", {bg = "#00ffff"})
hl("Pmenu", {bg = "#2a2a2a"}) -- Popup menus
hl("PmenuSbar", {link = "Pmenu"}) -- Scrollbar background in popup menus

-- Base syntax
hl("Boolean", {link = "Number"})
hl("Character", {link = "String"})
hl("Comment", {fg = "#5c6370", ctermfg = 59})
hl("Conditional", {fg = "#c678dd", ctermfg = 170})
hl("Constant", {fg = "#56b6c2", ctermfg = 38})
hl("Debug", {})
hl("Define", {fg = "#c678dd", ctermfg = 170})
hl("Delimiter", {})
hl("Error", {fg = "#e06c75", ctermfg = 204})
hl("Exception", {fg = "#c678dd", ctermfg = 170})
hl("Float", {link = "Number"})
hl("Function", {fg = "#61afef", ctermfg = 39})
hl("Number", {fg = "#d19a66", ctermfg = 173})
hl("Operator", {fg = "#c678dd", ctermfg = 170})
hl("Identifier", {fg = "#e06c75", ctermfg = 204})
hl("Include", {fg = "#61afef", ctermfg = 39})
hl("Keyword", {fg = "#c678dd", ctermfg = 170, bold = true})
hl("Label", {fg = "#c678dd", ctermfg = 170})
hl("Macro", {fg = "#c678dd", ctermfg = 170})
hl("PreCondit", {fg = "#e5c07b", ctermfg = 180})
hl("PreProc", {fg = "#e5c07b", ctermfg = 180})
hl("Repeat", {fg = "#c678dd", ctermfg = 170})
hl("Special", {fg = "#61afef", ctermfg = 39})
hl("SpecialChar", {fg = "#d19a66", ctermfg = 173})
hl("SpecialComment", {fg = "#5c6370", ctermfg = 59})
hl("Statement", {fg = "#c678dd", ctermfg = 170})
hl("StorageClass", {fg = "#e5c07b", ctermfg = 180})
hl("String", {fg = "#98e379", ctermfg = 114})
hl("Structure", {fg = "#e5c07b", ctermfg = 180})
hl("Todo", {fg = "#c678dd", ctermfg = 170})
hl("Type", {fg = "#e5c07b", ctermfg = 180})
hl("Typedef", {fg = "#e5c07b", ctermfg = 180})

-- Syntax: Lua
hl("@variable.member.lua", {link = "@property.lua"})

-- Syntax: Markdown
hl("@markup.raw.markdown_inline", {fg = "#dddddd", bg = "#2c2e33", italic = true})
do
	local headerStyle = {fg = "#ffffff", bg = "#171717", bold = true}
	for level = 1, 6 do
		hl("RenderMarkdownH" .. level, headerStyle)
		hl("RenderMarkdownH" .. level .. "Bg", {bg = headerStyle.bg})
	end
end

-- Syntax: HTML
hl("htmlEndTag", {link = "htmlTag"})