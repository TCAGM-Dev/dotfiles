return {load = function(plugins)
	local sources = {}

	for _, plugin in ipairs(plugins) do
		table.insert(sources, plugin.src)
		if plugin.dependencies ~= nil then
			for _, dependency in ipairs(plugin.dependencies) do
				table.insert(sources, dependency)
			end
		end
	end

	vim.pack.add(sources)

	for _, plugin in ipairs(plugins) do
		if plugin.config ~= nil then
			plugin.config()
		end
	end
end}
