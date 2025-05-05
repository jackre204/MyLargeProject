local connection = false
local availableArrestPoints = {
	{2247.57935, 2444.57129, 19996.03516, 0, 0},
	{2244.96167, 2445.09619, 19996.03516, 0, 0},
	{2239.19800, 2444.98828, 19996.03516, 0, 0},
	{2239.38184, 2456.56738, 19996.03516, 0, 0},
	{2243.61719, 2456.81250, 19996.03516, 0, 0},
	{2247.70337, 2456.24609, 19996.03516, 0, 0},
}

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()
	end)

addEvent("getPlayerOutOfJail", true)
addEventHandler("getPlayerOutOfJail", getRootElement(),
	function ()
		if isElement(source) then
			local adminJail = getElementData(source, "acc.adminJail") or 0
			local charJail = getElementData(source, "char.jail") or 0

			if adminJail == 0 then
				dbExec(connection, "UPDATE accounts SET adminJail = 0, adminJailBy = '', adminJailTimestamp = 0, adminJailTime = 0, adminJailReason = '' WHERE accountId = ?", getElementData(source, "char.accID"))
			end

			if charJail == 0 then
				dbExec(connection, "UPDATE characters SET jail = 0, jailTime = 0, jailTimestamp = 0, jailReason = '' WHERE characterId = ?", getElementData(source, "char.ID"))
			end

			setElementInterior(source, 0)
	 		setElementDimension(source, 0)
			setElementPosition(source, 1514.8635253906, -1658.8701171875, 13.539175033569)
			setElementRotation(source, 0, 0, 270)
		end
	end)

addEvent("reSpawnInJail", true)
addEventHandler("reSpawnInJail", getRootElement(),
	function ()
		if isElement(source) then
			local accountId = getElementData(source, "char.accID")
			local adminJail = getElementData(source, "acc.adminJail") or 0
			local charJail = getElementData(source, "char.jail") or 0
			local skinId = getElementModel(source)

			if adminJail ~= 0 then
				spawnPlayer(source, -18.462890625, 2321.8916015625, 24.303373336792, 0, skinId, 0, accountId + math.random(100))
			elseif charJail ~= 0 then
				local arrestPoint = availableArrestPoints[math.random(1, #availableArrestPoints)]

				spawnPlayer(source, arrestPoint[1], arrestPoint[2], arrestPoint[3], 0, skinId, arrestPoint[4], arrestPoint[5])
			end

			setCameraTarget(source, source)
		end
	end)

function getNearbyArrestPoint(playerElement)
	local x, y, z = getElementPosition(playerElement)
	local interior = getElementInterior(playerElement)
	local dimension = getElementDimension(playerElement)

	local lastDistance = 5
	local nearbyArrestPoint = false

	for i = 1, #availableArrestPoints do
		local v = availableArrestPoints[i]

		if interior == v[4] and dimension == v[5] then
			local currentDistance = getDistanceBetweenPoints3D(x, y, z, v[1], v[2], v[3])

			if lastDistance >= currentDistance then
				lastDistance = currentDistance
				nearbyArrestPoint = i
			end
		end
	end

	return nearbyArrestPoint
end

addCommandHandler("jail",
	function (sourcePlayer, commandName, targetName, duration, fine, ...)
		local groupId = exports.sm_groups:isPlayerHavePermission(sourcePlayer, "jail")

		if groupId then
			duration = tonumber(duration)
			fine = tonumber(fine)

			if not (targetName and duration and duration >= 0 and fine and fine >= 0 and (...)) then
				outputChatBox("#3d7abc[Használat]: #ffffff/" .. commandName .. " [Név / ID] [Idő (perc)] [Bírság] [Indok]", sourcePlayer, 0, 0, 0, true)
			else
				local playerArrestPoint = getNearbyArrestPoint(sourcePlayer)
				if not playerArrestPoint then
					outputChatBox("#d75959[StrongMTA - Jail]: #ffffffNem vagy cella közelében!", sourcePlayer, 0, 0, 0, true)
					return
				end

				local targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetName)
				if not targetPlayer then
					return
				end

				if duration <= 0 or duration > 300 then
					outputChatBox("#d75959[StrongMTA - Jail]: #ffffffAz időtartam minimum #d759591 #ffffffés maximum #d75959300 #ffffffperc lehet.", sourcePlayer, 0, 0, 0, true)
					return
				end

				if fine < 0 or fine > 1000000 then
					outputChatBox("#d75959[StrongMTA - Jail]: #ffffffA bírság maximum #d759591,000,000 $ #fffffflehet.", sourcePlayer, 0, 0, 0, true)
					return
				end

				local targetArrestPoint = getNearbyArrestPoint(targetPlayer)
				if targetArrestPoint ~= playerArrestPoint then
					outputChatBox("#d75959[StrongMTA - Jail]: #ffffffA kiválasztott játékos nincs a cella közelében!", sourcePlayer, 0, 0, 0, true)
					return
				end

				local jailType = getElementData(targetPlayer, "char.jail") or 0
				if jailType ~= 0 then
					outputChatBox("#d75959[StrongMTA - Jail]: #ffffffA kiválasztott játékos már börtönben van.", sourcePlayer, 0, 0, 0, true)
					return
				end

				local arrestPoint = availableArrestPoints[targetArrestPoint]

				setElementData(targetPlayer, "cuffed", false)
				setElementData(targetPlayer, "cuffAnimation", false)
				setElementData(targetPlayer, "visz", false)

				local currTime = getRealTime().timestamp
				local reason = table.concat({...}, " ")

				setElementPosition(targetPlayer, arrestPoint[1], arrestPoint[2], arrestPoint[3])
				setElementRotation(targetPlayer, 0, 0, 0)
				setElementInterior(targetPlayer, arrestPoint[4])
				setElementDimension(targetPlayer, arrestPoint[5])

				setElementData(targetPlayer, "char.jail", 1)
				setElementData(targetPlayer, "char.jailTime", duration)
				setElementData(targetPlayer, "char.jailTimestamp", currTime, false)
				setElementData(targetPlayer, "char.jailReason", reason, false)

				if fine > 0 then
					exports.sm_core:takeMoney(targetPlayer, fine, "jailFine")
				end

				local playerName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
				local groupPrefix = exports.sm_groups:getGroupPrefix(groupId)
				local groupRankName = select(2, exports.sm_groups:getPlayerRank(sourcePlayer, groupId))
				local theOfficer = string.format("[%s] %s %s", groupPrefix, groupRankName, playerName)

				outputChatBox("#3d7abc[Börtön]: #ff9600" .. theOfficer .. " #ffffffbörtönbe helyezett téged.", targetPlayer, 0, 0, 0, true)
				outputChatBox("#3d7abc[Börtön]: #ffffffOka: #ff9600" .. reason, targetPlayer, 0, 0, 0, true)
				outputChatBox("#3d7abc[Börtön]: #ffffffIdő: #ff9600" .. duration .. " perc", targetPlayer, 0, 0, 0, true)

				exports.sm_groups:sendGroupMessage(groupId, {
					"#3d7abc[Börtön]: #ff9600" .. theOfficer .. " #ffffffbebörtönözte #ff9600" .. targetName .. " #ffffffjátékost.",
					"#3d7abc[Börtön]: #ffffffOka: #ff9600" .. reason,
					"#3d7abc[Börtön]: #ffffffIdő: #ff9600" .. duration .. " perc"
				})

				dbExec(connection, "UPDATE characters SET jail = 1, jailTime = ?, jailTimestamp = ?, jailReason = ? WHERE characterId = ?", duration, currTime, reason, getElementData(targetPlayer, "char.ID"))
			end
		end
	end)

addCommandHandler("ajail",
	function (sourcePlayer, commandName, targetPlayer, jailtype, duration, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			jailtype = tonumber(jailtype)
			duration = tonumber(duration)

			if not (targetPlayer and jailtype and jailtype >= 1 and jailtype <= 3 and duration and duration >= 1 and (...)) then
				outputChatBox("#3d7abc[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Típus (1: Sima, 2: Tanuló, 3: Szopató)] [Idő] [Indok]", sourcePlayer, 255, 255, 255, true)
			else
				local targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local reason = table.concat({...}, " ")
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local accountId = getElementData(targetPlayer, "char.accID")
					local currentTime = getRealTime().timestamp

					triggerClientEvent(targetPlayer, "loadingScreenOnAJ", targetPlayer)

					setElementData(targetPlayer, "cuffed", false)
					setElementData(targetPlayer, "cuffAnimation", false)
					setElementData(targetPlayer, "visz", false)

					removePedFromVehicle(targetPlayer)
					detachElements(targetPlayer)
	
					setElementPosition(targetPlayer, 153.76815795898, -1951.8623046875, 47.875)
					setElementInterior(targetPlayer, 0)
					setElementDimension(targetPlayer, accountId + math.random(1, 100))

					setElementData(targetPlayer, "acc.adminJail", jailtype)
					setElementData(targetPlayer, "acc.adminJailBy", adminName, false)
					setElementData(targetPlayer, "acc.adminJailTimestamp", currentTime, false)
					setElementData(targetPlayer, "acc.adminJailTime", duration)
					setElementData(targetPlayer, "acc.adminJailReason", reason, false)

					outputChatBox("#d75959[AdminJail]: #3d7abc" .. adminName .. " #ffffffbebörtönözte #3d7abc" .. targetName .. "#ffffff-t #3d7abc" .. duration .. " #ffffffpercre.", root, 255, 255, 255, true)
					outputChatBox("#d75959[AdminJail]: #3d7abcIndok: #ffffff" .. reason, root, 255, 255, 255, true)

					exports.sm_logs:addLogEntry("adminjail", {
						accountId = accountId,
						adminName = adminName,
						reason = reason,
						duration = duration
					})

					dbExec(connection, "UPDATE accounts SET adminJail = ?, adminJailBy = ?, adminJailTimestamp = ?, adminJailTime = ?, adminJailReason = ? WHERE accountId = ?", jailtype, adminName, currentTime, duration, reason, accountId)
				end
			end
		end
	end)

addCommandHandler("unjail",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				outputChatBox("#3d7abc[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
			else
				local targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminJail = getElementData(targetPlayer, "acc.adminJail") or 0

					if adminJail > 0 then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminRank = getPlayerAdminTitle(sourcePlayer)

						setElementData(targetPlayer, "acc.adminJail", 0)
						setElementData(targetPlayer, "acc.adminJailTime", 0)

						triggerEvent("getPlayerOutOfJail", targetPlayer)

						showMessageForAdmins("#3d7abc[StrongMTA]: #3d7abc" .. adminRank .. " " .. adminName .. " #ffffffunjailezte #3d7abc" .. targetName .. "#ffffff-t.")
					else
						outputChatBox("#d75959[StrongMTA - AdminJail]: #ffffffA kiválasztott játékos nincs börtönben.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end)

function jailInfoFunction(sourcePlayer)
	local adminJail = getElementData(sourcePlayer, "acc.adminJail") or 0
	local charJail = getElementData(sourcePlayer, "char.jail") or 0

	if adminJail > 0 then
		outputChatBox("#d75959[StrongMTA - AdminJail]: #ffffffJail információk:", sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Indok: #ffffff" .. getElementData(sourcePlayer, "acc.adminJailReason"), sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Hátralévő idő: #ffffff" .. getElementData(sourcePlayer, "acc.adminJailTime") .. " perc", sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Admin: #ffffff" .. getElementData(sourcePlayer, "acc.adminJailBy"), sourcePlayer, 255, 255, 255, true)
	elseif charJail > 0 then
		local jailTime = getRealTime(getElementData(sourcePlayer, "char.jailTimestamp"))

		jailTime = string.format("%04d/%02d/%02d %02d:%02d", jailTime.year + 1900, jailTime.month + 1, jailTime.monthday, jailTime.hour, jailTime.minute)

		outputChatBox("#d75959[StrongMTA - Jail]: #ffffffJail információk:", sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Indok: #ffffff" .. getElementData(sourcePlayer, "char.jailReason"), sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Hátralévő idő: #ffffff" .. getElementData(sourcePlayer, "char.jailTime") .. " perc", sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Időpont: #ffffff" .. jailTime, sourcePlayer, 255, 255, 255, true)
	else
		outputChatBox("#d75959[StrongMTA]: #ffffffNem vagy börtönben.", sourcePlayer, 255, 255, 255, true)
	end
end
addCommandHandler("jailinfo", jailInfoFunction)
addCommandHandler("bortoninfo", jailInfoFunction)
addCommandHandler("börtöninfó", jailInfoFunction)
addCommandHandler("börtönidő", jailInfoFunction)
addCommandHandler("bortonido", jailInfoFunction)
addCommandHandler("jailtime", jailInfoFunction)