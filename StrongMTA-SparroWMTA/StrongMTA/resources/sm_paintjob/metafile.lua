function get_script_path()
	local info = debug.getinfo(1, "S")
	local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
	return script_path
end

local dir = get_script_path() .. "/textures"
local files = {}

for file in io.popen('dir "' .. dir .. '" /b'):lines() do
	for file2 in io.popen('dir "' .. dir .. '/' .. file .. '" /b'):lines() do
		table.insert(files, file .. "/" .. file2)
	end
end

local sorted = {}

for i = 1, #files do
	table.insert(sorted, files[i])
end

table.sort(sorted, function(a, b)
	return a < b
end)

for i = 1, #sorted do
	print("<file src=\"textures/" .. sorted[i] .. "\" />")
end