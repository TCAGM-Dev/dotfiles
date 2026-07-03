local util = require("util")

---@alias Src string

---@class Spec
---@field src Src Plugin source
---@field config? fun(): nil Called after installation, should call setup() or equivalent
---@field dependencies? Src[] List of dependency plugins that should be added

local module = {}

---@param plugins Spec[]
---@param deleteInactive? boolean Clear files of plugins deemed "inactive" by vim.pack, defaults to `true`
function module.load(plugins, deleteInactive)
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

	if deleteInactive == nil then deleteInactive = true end
	if deleteInactive then
		local installed = vim.pack.get()
		local deleteThese = util.arrayFilter(installed, function(p) return not p.active end)
		if #deleteThese > 0 then
			vim.pack.del(util.arrayMap(deleteThese, function(p) return p.spec.name end))
		end
	end
end

return module