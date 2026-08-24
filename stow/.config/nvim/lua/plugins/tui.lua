local util = require("util")

---@type Spec
return {
	src = "https://github.com/is0n/tui-nvim",
	config = function()
		local tui = require("tui-nvim")

		local temp = vim.fn.system("mktemp '/tmp/tui-nvim.XXXXXX'")

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
					local files = vim.fn.system("cat " .. temp)
					for _, file in ipairs(util.stringSplit(files, "\n")) do
						vim.fn.execute("edit " .. file)
					end
				end},
			})
		end)
	end,
}