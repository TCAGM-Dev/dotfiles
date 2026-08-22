-- mime-ext.yazi
local mimeExt = require("mime-ext.local")

mimeExt:setup({
	with_files = {},

	with_exts = {
		lua = "text/lua",
	},

	custom_only = true,

	fallback_file1 = true,
})