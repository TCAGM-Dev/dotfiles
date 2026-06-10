-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.o.updatetime = 750

-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:h 'clipboard'`
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		vim.o.clipboard = "unnamedplus"
	end,
})

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command("GitBlameLine", function()
	local line_number = vim.fn.line(".") -- Get the current line number. See `:h line()`
	local filename = vim.api.nvim_buf_get_name(0)
	print(vim.system({"git", "blame", "-L", line_number .. ",+1", filename}):wait().stdout)
end, {desc = "Print the git blame for the current line"})

vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format()
end, {desc = "Format the open buffer using the applicable LSP"})

-- OPTIONS
--
-- See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:h option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)
for key, value in pairs(require("options")) do
	vim.opt[key] = value
end

-- PLUGINS
--
-- See `:h :packadd`, `:h vim.pack`

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd("packadd! nohlsearch")

require("plugins").load({
	require("plugins/transparent"),
	require("plugins/gitsigns"),
	require("plugins/barbar"),
	require("plugins/log-highlight"),
	require("plugins/colorizer"),
	require("plugins/fzf"),
	require("plugins/mini-completion"),
	require("plugins/quicker"),
	require("plugins/lspconfig")({
		qmlls = {cmd = {"qmlls6"}},
		ts_ls = {},
		lua_ls = {},
		bashls = {},
		html = {},
		cssls = {},
		jsonls = {},
		docker_language_server = {},
		sqlls = {},
		basedpyright = {},
	}),
	require("plugins/oil"),
	require("plugins/image"),
	require("plugins/autopairs"),
	require("plugins/galaxyline"),
})

require("keymap").bind()

vim.cmd("colorscheme foolmoonnight")