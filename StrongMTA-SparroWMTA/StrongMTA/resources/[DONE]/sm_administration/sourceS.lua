local onlineAdmins = {}
connection = false

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()

		for k, v in pairs(getElementsByType("player")) do
			local adminLevel = getElementData(v, "acc.adminLevel") or 0
			if adminLevel > 0 then
				onlineAdmins[v] = adminLevel
			end
		end
	end)

addEventHandler("onElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "acc.adminLevel" or dataName == "adminDuty" then
			local adminLevel = getElementData(source, "acc.adminLevel") or 0
			if adminLevel > 0 then
				onlineAdmins[source] = adminLevel
			else
				onlineAdmins[source] = nil
			end
		end
	end)

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		if onlineAdmins[source] then
			onlineAdmins[source] = nil
		end
	end)

addEventHandler("onPlayerChangeNick", getRootElement(),
	function (oldNick, newNick, changedByUser)
		if changedByUser then
			cancelEvent()
		end
	end)

addEvent("warpToGameInterior", true)
addEventHandler("warpToGameInterior", getRootElement(),
	function (interiorId, gameInterior)
		if isElement(source) then
			if gameInterior then
				setElementPosition(source, gameInterior.position[1], gameInterior.position[2], gameInterior.position[3])
				setElementRotation(source, gameInterior.rotation[1], gameInterior.rotation[2], gameInterior.rotation[3])
				setElementInterior(source, gameInterior.interior)
				setElementDimension(source, 0)
				setCameraInterior(source, gameInterior.interior)
				outputChatBox("#3d7abc[StrongMTA]: #ffffffSikeresen elteleportáltál a kiválasztott interior belsőbe. #3d7abc([" .. interiorId .. "] " .. gameInterior.name .. ")", source, 255, 255, 255, true)
			end
		end
	end)

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function showAdminMessageFor(player, message, r, g, b)
	if r and g and b then
		return outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, player, r, g, b, true)
	else
		return outputChatBox(message, player, 255, 255, 255, true)
	end
end

function showAdminMessage(message, r, g, b)
	if r and g and b then
		return outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, root, r, g, b, true)
	else
		return outputChatBox(message, root, 255, 255, 255, true)
	end
end

function showMessageForAdmins(message, r, g, b)
	for playerElement, adminLevel in pairs(onlineAdmins) do
		if isElement(playerElement) then
			if r and g and b then
				outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, playerElement, r, g, b, true)
			else
				outputChatBox(message, playerElement, 255, 255, 255, true)
			end
		end
	end
end

function showAdminLog(message, level)
	level = level or 1

	for playerElement, adminLevel in pairs(onlineAdmins) do
		if isElement(playerElement) then
			if adminLevel >= level then
				outputChatBox("#3d7abc[StrongMTA - ALOG]: #ffffff" .. message, playerElement, 255, 255, 255, true)
			end
		end
	end
end

addCommandHandler("startres",
	function (sourcePlayer, commandName, resourceName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			if not resourceName then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Resource Név]", 255, 150, 0)
			else
				local res = getResourceFromName(resourceName)

				if res then
					local state = getResourceState(res)

					if state == "loaded" then
						if startResource(res) then
							showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffResource sikeresen elindítva. #3d7abc(" .. resourceName .. ")", 61, 122, 188)
						else
							showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource elindítása sikertelen.", 215, 89, 89)
						end
					elseif state == "running" then
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource már el van indítva.", 215, 89, 89)
					elseif state == "failed to load" then
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resourcet nem sikerült betölteni.", 215, 89, 89)
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffIndok: #d75959" .. getResourceLoadFailureReason(res), 215, 89, 89)
					else
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource éppen elindul vagy leáll.", 215, 89, 89)
					end
				else
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource nem található.", 215, 89, 89)
				end
			end
		end
	end)

addCommandHandler("stopres",
	function (sourcePlayer, commandName, resourceName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			if not resourceName then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Resource Név]", 255, 150, 0)
			else
				local res = getResourceFromName(resourceName)

				if res then
					local state = getResourceState(res)

					if state == "loaded" then
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource nincs elindítva.", 215, 89, 89)
					elseif state == "running" then
						if stopResource(res) then
							showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffResource sikeresen leállítva. #3d7abc(" .. resourceName .. ")", 61, 122, 188)
						else
							showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource leállítása sikertelen.", 215, 89, 89)
						end
					elseif state == "failed to load" then
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resourcet nem sikerült betölteni.", 215, 89, 89)
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffIndok: #d75959" .. getResourceLoadFailureReason(res), 215, 89, 89)
					else
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource éppen elindul vagy leáll.", 215, 89, 89)
					end
				else
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource nem található.", 215, 89, 89)
				end
			end
		end
	end)

addCommandHandler("restartres",
	function (sourcePlayer, commandName, resourceName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			if not resourceName then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Resource Név]", 255, 150, 0)
			else
				local res = getResourceFromName(resourceName)

				if res then
					local state = getResourceState(res)

					if state == "loaded" then
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource nincs elindítva.", 215, 89, 89)
					elseif state == "running" then
						if restartResource(res) then
							showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffResource sikeresen újraindítva. #3d7abc(" .. resourceName .. ")", 61, 122, 188)
						else
							showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource újraindítása sikertelen.", 215, 89, 89)
						end
					elseif state == "failed to load" then
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resourcet nem sikerült betölteni.", 215, 89, 89)
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffIndok: #d75959" .. getResourceLoadFailureReason(res), 215, 89, 89)
					else
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource éppen elindul vagy leáll.", 215, 89, 89)
					end
				else
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott resource nem található.", 215, 89, 89)
				end
			end
		end
	end)


addEvent("getTickSyncKillmsg", true)
addEventHandler("getTickSyncKillmsg", getRootElement(),
	function ()
		if isElement(source) then
			triggerClientEvent(source, "getTickSyncKillmsg", source, getRealTime().timestamp)
		end
	end
)

addCommandHandler("asay",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not (...) then
				outputChatBox("#ff9600[Használat]: #ffffff/" .. commandName .. " [Üzenet]", sourcePlayer, 255, 255, 255, true)
			else
				local msg = table.concat({...}, " ")

				if #msg > 0 and utfLen(msg) > 0 and utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
					local adminNick = getElementData(sourcePlayer, "acc.adminNick")
					local adminRank = getPlayerAdminTitle(sourcePlayer)

					outputChatBox(adminRank .. " " .. adminNick .. ": " .. msg, getRootElement(), 215, 89, 89, true)

					triggerClientEvent(getElementsByType("player"), "playNotification", sourcePlayer, "epanel")
				end
			end
		end
	end)