local util = require("util")

---@alias Src string

---@class PluginSpec
---@field src Src[]|Src Plugin source
---@field config? fun(): nil Called after installation, should call setup() or equivalent

local module = {}

---@param plugins PluginSpec[]
---@param deleteInactive? boolean Clear files of plugins deemed "inactive" by vim.pack, defaults to `true`
function module.load(plugins, deleteInactive)
	local sources = {} ---@type Src[]

	for _, plugin in ipairs(plugins) do
		local src = plugin.src
		if type(src) == "string" then
			table.insert(sources, src)
		else
			util.insertAll(sources, src)
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