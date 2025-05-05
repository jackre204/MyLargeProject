addEvent("unauthorizedFunction", true)
addEventHandler("unauthorizedFunction", getRootElement(),
	function (resourceName, functionName, luaFilename, luaLineNumber, args)
		if isElement(source) then
			exports.sm_logs:logCommand(source, eventName, {
				"resource: " .. resourceName,
				"function: " .. functionName,
				"file: " .. (luaFilename or "N/A"),
				"line: " .. (luaLineNumber or "N/A"),
				"args: " .. (args and table.concat(args, "|") or "-")
			})
		end
	end)