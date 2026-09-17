local util = require("util")

---@type Spec
return {
	src = "https://github.com/is0n/tui-nvim",
	config = function()
		local tui = require("tui-nvim")

		vim.keymap.set({"n"}, "<CA-O>", function()
			local path = vim.fn.expand("%:p:h")

			if util.startsWith(path, "term://") then
				path = vim.fn.getcwd()
			end

			local temp = vim.fn.system("mktemp '/tmp/tui-nvim.XXXXXX'"):sub(1, -2)

			tui:new({
				cmd = "command yazi --chooser-file=" .. temp .. " '" .. path .. "'",
				on_exit = {function()
					if not vim.uv.fs_stat(temp) then return end -- File doesn't exist; nothing was selected in yazi

					local dirs = {} ---@type string[]

					for filePath in io.lines(temp) do
						if filePath ~= nil then
							local stat = vim.uv.fs_stat(filePath)
							if stat ~= nil then
								if stat.type == "directory" then
									table.insert(dirs, filePath)
								else
									vim.fn.execute("edit " .. filePath)
								end
							else
								vim.notify("Recieved nonexistant file \"" .. filePath .. "\" to open", vim.log.levels.WARN)
							end
						end
					end

					if #dirs > 1 then
						vim.notify("Cannot cd to multiple directories", vim.log.levels.ERROR)
					elseif #dirs == 1 then
						vim.fn.chdir(dirs[1])
					end

					vim.fs.rm(temp)
				end},
			})
		end)
	end,
}
