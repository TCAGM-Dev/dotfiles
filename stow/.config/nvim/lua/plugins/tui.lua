local util = require("util")

---@type Spec
return {
	src = "https://github.com/is0n/tui-nvim",
	config = function()
		local tui = require("tui-nvim")

		local temp = vim.fn.system("mktemp '/tmp/tui-nvim.XXXXXX'"):sub(1, -2)

		tui.setup({
			temp = temp,
		})

		vim.keymap.set({"n"}, "<CA-O>", function()
			local path = vim.fn.expand("%:p:h")

			if util.startsWith(path, "term://") then
				path = vim.fn.getcwd()
			end

			tui:new({
				cmd = "command yazi --chooser-file=" .. temp .. " '" .. path .. "'",
				on_exit = {function()
					for _, filePath in io.lines(temp) do
						if filePath ~= nil then
							vim.fn.execute("edit " .. filePath)
						end
					end
				end},
			})
		end)

		vim.api.nvim_create_autocmd("VimLeave", {callback = function()
			vim.fn.system("rm " .. temp)
		end})
	end,
}