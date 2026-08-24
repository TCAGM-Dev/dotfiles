local util = {}

---@param ... any
---@return string
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
---@param ... any
---@return nil
function util.debugPrint(...)
	ogPrint(util.stringifyDebug(...))
end

---@param destination any[]
---@param source any[]
---@return nil
function util.insertAll(destination, source)
	for _, v in ipairs(source) do table.insert(destination, v) end
end

---@param ... any[]
---@return any[]
function util.concatArray(...)
	local result = {}
	for _, arr in ipairs({...}) do
		util.insertAll(result, arr)
	end
	return result
end

---@generic From any
---@generic To any
---@param arr From[]
---@param transform fun(from: From): To
---@return To[]
function util.arrayMap(arr, transform)
	local result = {}
	for i, v in ipairs(arr) do
		result[i] = transform(v)
	end
	return result
end

---@generic T any
---@param arr T[]
---@param predicate fun(v: T): boolean
---@return T[]
function util.arrayFilter(arr, predicate)
	local result = {}
	for _, v in ipairs(arr) do
		if predicate(v) then table.insert(result, v) end
	end
	return result
end

---@generic T any
---@param arr T[]
---@param value T
---@return boolean
function util.arrayContains(arr, value)
	for _, v in ipairs(arr) do
		if v == value then return true end
	end
	return false
end

---@param haystack string
---@param needle string
---@return boolean
function util.startsWith(haystack, needle)
	return string.sub(haystack, 1, #needle) == needle
end
---@param haystack string
---@param needle string
---@return boolean
function util.endsWith(haystack, needle)
	return string.sub(haystack, -#needle) == needle
end

---@param inputStr string
---@param sep string
---@return string[]
function util.stringSplit(inputStr, sep)
	if sep == nil then sep = "%s" end
	local parts = {}
	for part in inputStr:gmatch("([^" .. sep .. "]+)") do
		table.insert(parts, part)
	end
	return parts
end

return util