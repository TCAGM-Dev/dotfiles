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
	vim.keymap.set({"n", "i"}, "<C-Return>", vim.lsp.buf.definition)
	vim.keymap.set({"n", "i"}, "<CA-Return>", vim.lsp.buf.references)

	vim.keymap.set({"n", "i"}, "<S-Up>", "10-")
	vim.keymap.set({"n"}, "<S-K>", "10-")
	vim.keymap.set({"n", "i"}, "<S-Down>", "10<CR>")
	vim.keymap.set({"n"}, "<S-J>", "10<CR>")

	vim.api.nvim_create_autocmd({"BufAdd", "VimEnter"}, {callback = function(event) -- Buffer-local logic for 
		local lastLineMoveEditPosition = nil ---@type number|nil

		local lastEditWasMe = false
		local function a(cmds)
			return function()
				if vim.fn.getpos(".")[2] == lastLineMoveEditPosition then vim.cmd("undojoin") end
				for i, cmd in ipairs(cmds) do
					if i > 1 then vim.cmd("undojoin") end
					vim.cmd(cmd)
				end
				lastLineMoveEditPosition = vim.fn.getpos(".")[2]
				lastEditWasMe = true -- Signal to "TextChanged" autocmd below
			end
		end

		local opts = {buf = event.buf}
		vim.keymap.set("v", "<A-j>", a({"m '>+1", "normal! gv=gv"}), opts)
		vim.keymap.set("v", "<A-k>", a({"m '<-2", "normal! gv=gv"}), opts)
		vim.keymap.set("n", "<A-j>", a({"m .+1",  "normal! =="}),    opts)
		vim.keymap.set("n", "<A-k>", a({"m .-2",  "normal! =="}),    opts)

		vim.api.nvim_create_autocmd("TextChanged", {buf = event.buf, callback = function()
			if not lastEditWasMe then lastLineMoveEditPosition = nil end -- Clear `lastLineMoveEditPosition` on any other edit
			lastEditWasMe = false -- Reset
		end})
	end})

	vim.keymap.set("n", "gq", "<Cmd>Format<CR>")
end}