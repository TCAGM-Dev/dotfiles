return {bind = function()
	-- KEYMAPS
	--
	-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

	-- Use <Esc> to exit terminal mode
	vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

	-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
	vim.keymap.set({"t", "i"}, "<A-h>", "<C-\\><C-n><C-w>h")
	vim.keymap.set({"t", "i"}, "<A-j>", "<C-\\><C-n><C-w>j")
	vim.keymap.set({"t", "i"}, "<A-k>", "<C-\\><C-n><C-w>k")
	vim.keymap.set({"t", "i"}, "<A-l>", "<C-\\><C-n><C-w>l")
	vim.keymap.set({"n"}, "<A-h>", "<C-w>h")
	vim.keymap.set({"n"}, "<A-j>", "<C-w>j")
	vim.keymap.set({"n"}, "<A-k>", "<C-w>k")
	vim.keymap.set({"n"}, "<A-l>", "<C-w>l")

	vim.keymap.set({"n"}, "<C-`>", "<Cmd>terminal<CR>")

	vim.keymap.set({"n", "i"}, "<A-Return>", vim.lsp.buf.signature_help)
	vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
		callback = function()
			vim.diagnostic.open_float(nil, {focus = false})
		end
	})
	vim.keymap.set({"n", "i"}, "<C-Return>", vim.lsp.buf.definition)
	vim.keymap.set({"n", "i"}, "<CA-Return>", vim.lsp.buf.references)

	vim.keymap.set({"n", "i"}, "<S-Up>", "10-")
	vim.keymap.set({"n"}, "<S-K>", "10-")
	vim.keymap.set({"n", "i"}, "<S-Down>", "10<CR>")
	vim.keymap.set({"n"}, "<S-J>", "10<CR>")

	vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
	vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
	vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
	vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
end}