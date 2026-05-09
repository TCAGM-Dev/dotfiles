local util = {}

function util.stringifyDebug(...)
	local args = {...}
	if #args > 1 then
		local result = "("
		for i, v in ipairs(args) do
			if i > 1 then result = result .. ", " end
			result = result .. util.stringifyDebug(v)
		end
		return result .. ")"
	end

	local value = args[1]

	local typ = type(value)

	if typ == "string" then
		return "\"" .. string.gsub(value, "\"", "\\\"") .. "\""
	end

	if typ == "table" then
		local isArray = true
		for key, _ in pairs(value) do
			if type(key) ~= "number" then isArray = false; break end
		end
		if isArray then
			local result = "{"
			for i, v in ipairs(value) do
				if i > 1 then result = result .. ", " end
				result = result .. util.stringifyDebug(v)
			end
			return result .. "}"
		else
			local result = "{"
			local i = 1
			for k, v in pairs(value) do
				if i > 1 then result = result .. ", " end
				result = result .. "[" .. util.stringifyDebug(k) .. "] = " .. util.stringifyDebug(v)
				i = i + 1
			end
			return result .. "}"
		end
	end

	return tostring(value)
end

local ogPrint = print
function util.debugPrint(...)
	ogPrint(util.stringifyDebug(...))
end

function util.insertAll(destination, source)
	for _, v in ipairs(source) do table.insert(destination, v) end
end

function util.concatArray(...)
	local result = {}
	for _, arr in ipairs({...}) do
		util.insertAll(result, arr)
	end
	return result
end

return util