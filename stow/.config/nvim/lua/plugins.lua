local util = require("util")

---@alias Src string

---@class Spec
---@field src Src Plugin source
---@field config? fun(): nil Called after installation, should call setup() or equivalent
---@field dependencies? Src[] List of dependency plugins that should be added

local module = {}

---@param plugins Spec[]
function module.load(plugins)
	local sources = {} ---@type Src[]

	for _, plugin in ipairs(plugins) do
		table.insert(sources, plugin.src)
		if plugin.dependencies ~= nil then
			util.insertAll(sources, plugin.dependencies)
		end
	end

	vim.pack.add(sources)

	for _, plugin in ipairs(plugins) do
		if plugin.config ~= nil then
			plugin.config()
		end
	end
end

return module