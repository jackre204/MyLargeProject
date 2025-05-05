addCommandHandler("vá",
	function (sourcePlayer, commandName, partialNick, ...)
		local myAdminLevel = getElementData(sourcePlayer, "acc.adminLevel") or 0
		local myHelperLevel = getElementData(sourcePlayer, "acc.helperLevel") or 0

		if myAdminLevel > 0 or myHelperLevel > 0 then
			if not partialNick or not (...) then
				outputChatBox("#3d7abc[Használat]: #ffffff/" .. commandName .. " [Név / ID] [Üzenet]", sourcePlayer, 0, 0, 0, true)
			else
				local targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, partialNick)

				if isElement(targetPlayer) then
					local message = table.concat({...}, " "):gsub("#%x%x%x%x%x%x", "")

					if message then
						local myName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
						local myPlayerID = getElementData(sourcePlayer, "playerID") or "N/A"
						local targetPlayerID = getElementData(targetPlayer, "playerID") or "N/A"

						if myHelperLevel > 0 then
							outputChatBox(string.format("#3d7abc[Válasz]: #ffffff%s (%d): #3d7abc%s", targetName, targetPlayerID, message), sourcePlayer, 0, 0, 0, true)
							outputChatBox(string.format("#3d7abc[Segítség]: #ffffff%s (%d): #3d7abc%s", myName, myPlayerID, message), targetPlayer, 0, 0, 0, true)

							triggerClientEvent("onAdminMSGVa", resourceRoot, string.format("Adminsegéd %s válaszolt neki: %s", myName, targetName))
							triggerClientEvent("onAdminMSGVa", resourceRoot, string.format("Üzenet: %s", message))
						elseif myAdminLevel > 0 then
							local adminName = getElementData(sourcePlayer, "acc.adminNick")
							local adminRank = getPlayerAdminTitle(sourcePlayer)

							outputChatBox(string.format("#3d7abc[Válasz]: #ffffff%s (%d): #3d7abc%s", targetName, targetPlayerID, message), sourcePlayer, 0, 0, 0, true)
							outputChatBox(string.format("#3d7abc[Segítség]: #ffffff%s %s (%d): #3d7abc%s", adminRank, adminName, myPlayerID, message), targetPlayer, 0, 0, 0, true)

							triggerClientEvent("onAdminMSGVa", resourceRoot, string.format("%s %s válaszolt neki: %s", adminRank, adminName, targetName))
							triggerClientEvent("onAdminMSGVa", resourceRoot, string.format("Üzenet: %s", message))
						end
					end
				end
			end
		end
	end)

addCommandHandler("pm",
	function (sourcePlayer, commandName, partialNick, ...)
		if getElementData(sourcePlayer, "loggedIn") then
			if not partialNick or not (...) then
				outputChatBox("#3d7abc[Használat]: #ffffff/" .. commandName .. " [Név / ID] [Üzenet]", sourcePlayer, 0, 0, 0, true)
			else
				local targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, partialNick)

				if isElement(targetPlayer) then
					local message = table.concat({...}, " "):gsub("#%x%x%x%x%x%x", "")

					if message then
						local myName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
						local myAdminLevel = getElementData(sourcePlayer, "acc.adminLevel") or 0
						local myPlayerID = getElementData(sourcePlayer, "playerID") or "N/A"

						if myAdminLevel == 0 or myAdminLevel >= 6 then
							local targetHelperLevel = getElementData(targetPlayer, "acc.helperLevel") or 0
							local targetPlayerID = getElementData(targetPlayer, "playerID") or "N/A"
							local targetInDuty = getElementData(targetPlayer, "adminDuty") or 0

							if targetInDuty == 1 or targetHelperLevel > 0 then
								outputChatBox(string.format("#3d7abc[Küldött PM]: #ffffff%s (%d): #3d7abc%s", targetName, targetPlayerID, message), sourcePlayer, 0, 0, 0, true)
								outputChatBox(string.format("#3d7abc[Fogadott PM]: #ffffff%s (%d): #3d7abc%s", myName, myPlayerID, message), targetPlayer, 0, 0, 0, true)
							else
								outputChatBox("#3d7abc[StrongMTA]: #ffffffCsak szolgálatban lévő adminnak/adminsegédnek tudsz privát üzenetet írni!", sourcePlayer, 0, 0, 0, true)
							end
						else
							outputChatBox("#3d7abc[StrongMTA]: #ffffffNincs jogosultságod privát üzenetet írni. Használd a #3d7abc/vá #ffffffparancsot.", sourcePlayer, 0, 0, 0, true)
						end
					end
				end
			end
		end
	end)

addCommandHandler("a",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not (...) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Üzenet]", 255, 150, 0)
			else
				local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				if #msg > 0 and utf8.len(msg) > 0 then
					if utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminRank = getPlayerAdminTitle(sourcePlayer)

						showMessageForAdmins("[AdminChat]: #3d7abc" .. adminRank .. " " .. adminName .. ": #ffffff" .. msg, 89, 142, 215)
					end
				end
			end
		end
	end)

addCommandHandler("as",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 3 or getElementData(sourcePlayer, "acc.helperLevel") >= 1 or getElementData(sourcePlayer, "acc.rpGuard") then
			if not (...) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Üzenet]", 255, 150, 0)
			else
				local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				if #msg > 0 and utf8.len(msg) > 0 then
					if utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
						local adminName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
						local adminRank = getPlayerAdminTitle(sourcePlayer)

						if not adminRank then
							if getElementData(sourcePlayer, "acc.helperLevel") == 1 then
								adminRank = "AdminSegéd"
							elseif getElementData(sourcePlayer, "acc.helperLevel") == 2 then
								adminRank = "S.G.H."
							end
						end

						for k, v in pairs(getElementsByType("player")) do
							if getElementData(v, "acc.adminLevel") >= 1 or getElementData(v, "acc.helperLevel") >= 1 then
								outputChatBox("[HelperChat]: #3d7abc" .. adminRank .. " " .. adminName .. ": #ffffff" .. msg, v, 215, 89, 89, true)
							end
						end
					end
				end
			end
		end
	end)

addCommandHandler("unban",
	function (sourcePlayer, commandName, targetData)
		if not targetData then
			showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Account ID / Serial]", 255, 150, 0)
		else
			local adminNick = getElementData(sourcePlayer, "acc.adminNick")
			local unbanType = "playerAccountId"

			if tonumber(targetData) then
				targetData = tonumber(targetData)
			elseif string.len(targetData) == 32 then
				unbanType = "serial"
			else
				return false
			end

			local currTimestamp = getRealTime().timestamp

			dbQuery(
				function (qh, adminPlayer)
					local result, rows = dbPoll(qh, 0)

					if rows > 0 and result then
						local accountId = false

						for k, v in ipairs(result) do
							if not accountId then
								accountId = v.playerAccountId
							end

							dbExec(connection, "UPDATE bans SET deactivated = 'Yes', deactivatedBy = ?, deactivateTimestamp = ? WHERE banId = ?", v.banId, adminNick, currTimestamp)
						end

						dbExec(connection, "UPDATE accounts SET suspended = 0 WHERE accountId = ?", accountId)
						exports.sm_logs:logCommand(adminPlayer, commandName, {targetData})

						if isElement(adminPlayer) then
							showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffSikeresen feloldottad a kiválasztott játékos tiltását.", 61, 122, 188)
						end
					elseif isElement(adminPlayer) then
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott játékos nincs kitiltva.", 215, 89, 89)
					end
				end,
			{sourcePlayer}, connection, "SELECT * FROM bans WHERE ?? = ? AND deactivated = 'No' AND expireTimestamp < ?", unbanType, targetData, currTimestamp)
		end
	end)

function banFunction(datas)
	local adminNick = datas.adminNick
	local adminAccountId = datas.adminAccountId

	if isElement(datas.sourcePlayer) then
		adminNick = getElementData(datas.sourcePlayer, "acc.adminNick")
		adminAccountId = getElementData(datas.sourcePlayer, "char.accID")
	end

	local targetName = datas.targetName
	local accountName, playerAccountId = datas.accountName, datas.playerAccountId
	local duration = datas.duration

	if isElement(datas.targetPlayer) then
		targetName = getElementData(datas.targetPlayer, "visibleName"):gsub("_", " ")
		accountName = getElementData(datas.targetPlayer, "acc.Name")
		playerAccountId = getElementData(datas.targetPlayer, "char.accID")
	end

	local currentTime = getRealTime().timestamp
	local expireTime = currentTime

	if duration == 0 then
		expireTime = currentTime + 31536000 * 100
	else
		expireTime = currentTime + duration * 3600
	end

	if isElement(datas.targetPlayer) then
		kickPlayer(datas.targetPlayer, adminNick, datas.reason)
	end

	if targetName then
		triggerClientEvent(getElementsByType("player"), "addKickbox", getRandomPlayer(), "ban", adminNick, targetName, datas.reason, tostring(duration))
	end

	dbExec(connection, [[
		INSERT INTO bans
		(serial, playerName, playerAccountId, adminName, adminAccountId, banReason, banTimestamp, expireTimestamp)
		VALUES (?,?,?,?,?,?,?,?)
	]], datas.serial, accountName, playerAccountId, adminNick, adminAccountId, reason, currentTime, expireTime)

	dbExec(connection, "UPDATE accounts SET suspended = 1 WHERE accountId = ?", playerAccountId)

	return "ok"
end

addCommandHandler("ban",
	function (sourcePlayer, commandName, targetPlayer, duration, ...)
		duration = tonumber(duration)

		if getElementData(sourcePlayer, "acc.adminLevel") >= 2 then
			if not (targetPlayer and duration and (...)) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Óra < 0 = örök >] [Indok]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					banFunction({
						sourcePlayer = sourcePlayer,
						targetPlayer = targetPlayer,
						reason = table.concat({...}, " "),
						duration = math.floor(math.abs(duration)),
						serial = getPlayerSerial(targetPlayer)
					})
				end
			end
		end
	end)

addCommandHandler("kick",
	function (sourcePlayer, commandName, targetPlayer, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not (targetPlayer and (...)) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Indok]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local reason = table.concat({...}, " ")

					triggerClientEvent(getElementsByType("player"), "addKickbox", sourcePlayer, "kick", adminName, targetName, reason)
					kickPlayer(targetPlayer, adminName, reason)

					exports.sm_logs:logCommand(adminName, commandName, {targetName, reason})
				end
			end
		end
	end)

addCommandHandler("crash",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					triggerClientEvent(targetPlayer, "onPlayerCrashFromServer", targetPlayer)
				end
			end
		end
	end
)

addCommandHandler("takemoney",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			value = tonumber(value)

			if not (targetPlayer and value and value > 0) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Összeg]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					value = math.floor(value)
					exports.sm_core:takeMoney(targetPlayer, value, "admintake")

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffelvett tőled #3d7abc" .. formatNumber(value) .. " #ffffffdollárt.", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffElvettél #3d7abc" .. targetName .. " #ffffffjátékostól #3d7abc" .. formatNumber(value) .. " #ffffffdollárt.", 61, 122, 188)
				end
			end
		end
	end)

addCommandHandler("givemoney",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			value = tonumber(value)

			if not (targetPlayer and value and value > 0) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Összeg]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					value = math.floor(value)
					exports.sm_core:giveMoney(targetPlayer, value, "admingive")

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffadott neked #3d7abc" .. formatNumber(value) .. " #ffffffdollárt.", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffAdtál #3d7abc" .. targetName .. " #ffffffjátékosnak #3d7abc" .. formatNumber(value) .. " #ffffffdollárt.", 61, 122, 188)
				end
			end
		end
	end)

addCommandHandler("setpp",
	function (sourcePlayer, commandName, targetPlayer, state, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 9 then
			state = tonumber(state)
			value = tonumber(value)

			if not (targetPlayer and state and state >= 0 and state <= 1 and value and value > 0) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [0 = levonás | 1 = hozzáadás] [Összeg]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local currentPP = getElementData(targetPlayer, "acc.premiumPoints") or 0
					local newPP = currentPP

					value = math.floor(value)

					if state == 0 then
						newPP = currentPP - value

						if newPP < 0 then
							newPP = 0
						end
					elseif state == 1 then
						newPP = currentPP + value
					end

					setElementData(targetPlayer, "acc.premiumPoints", newPP)

					dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", newPP, getElementData(targetPlayer, "char.accID"))

					if state == 0 then
						showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #fffffflevont tőled #3d7abc" .. formatNumber(value) .. " #ffffffPP-t.", 61, 122, 188)
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffLevontál #3d7abc" .. targetName .. " #ffffffjátékostól #3d7abc" .. formatNumber(value) .. " #ffffffPP-t.", 61, 122, 188)
					elseif state == 1 then
						showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffadott neked #3d7abc" .. formatNumber(value) .. " #ffffffPP-t.", 61, 122, 188)
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffAdtál #3d7abc" .. targetName .. " #ffffffjátékosnak #3d7abc" .. formatNumber(value) .. " #ffffffPP-t.", 61, 122, 188)
					end
				end
			end
		end
	end)

addCommandHandler("setskin",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Skin ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					setElementModel(targetPlayer, value)
					setElementData(targetPlayer, "char.Skin", value)

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffmegváltoztatta a kinézeted. #3d7abc(" .. value .. ")", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffSikeresen megváltoztattad #3d7abc" .. targetName .. " #ffffffkinézetét. #3d7abc(" .. value .. ")", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("unfreeze",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local pedveh = getPedOccupiedVehicle(targetPlayer)

					if pedveh then
						setElementFrozen(pedveh, false)
					end

					setElementFrozen(targetPlayer, false)
					exports.sm_controls:toggleControl(targetPlayer, "all", true)

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffkiolvasztott téged.", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffKiolvasztottad #3d7abc" .. targetName .. " #ffffffjátékost.", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("freeze",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local pedveh = getPedOccupiedVehicle(targetPlayer)

					if pedveh then
						setElementFrozen(pedveh, true)
					end

					setElementFrozen(targetPlayer, true)
					exports.sm_controls:toggleControl(targetPlayer, "all", false)

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #fffffflefagyasztott téged.", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffLefagyasztottad #3d7abc" .. targetName .. " #ffffffjátékost.", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("setthirst",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 100 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Szomjúság < 0 - 100 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					setElementData(targetPlayer, "char.Thirst", value)

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffmegváltoztatta a szomjúságszinted. #3d7abc(" .. value .. ")", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffMegváltoztattad #3d7abc" .. targetName .. " #ffffffjátékos szomjúságszintjét. #3d7abc(" .. value .. ")", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("sethunger",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 100 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Éhség < 0 - 100 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					setElementData(targetPlayer, "char.Hunger", value)

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffmegváltoztatta az éhségszinted. #3d7abc(" .. value .. ")", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffMegváltoztattad #3d7abc" .. targetName .. " #ffffffjátékos éhségszintjét. #3d7abc(" .. value .. ")", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("setarmor",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 100 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Páncélzat < 0 - 100 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local adminRank = getPlayerAdminTitle(sourcePlayer)

					setPedArmor(targetPlayer, value)

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffmegváltoztatta a páncélzatodat. #3d7abc(" .. value .. ")", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffMegváltoztattad #3d7abc" .. targetName .. " #ffffffjátékos páncélzatát. #3d7abc(" .. value .. ")", 61, 122, 188)
					showAdminLog(adminRank .. " " .. adminName .. " átállította #3d7abc" .. targetName .. " #ffffffpáncélzatát. #3d7abc(" .. value .. ")")

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("sethp",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 100 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Életerő < 0 - 100 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local adminRank = getPlayerAdminTitle(sourcePlayer)

					setElementHealth(targetPlayer, value)

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffmegváltoztatta az életerődet. #3d7abc(" .. value .. ")", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffMegváltoztattad #3d7abc" .. targetName .. " #ffffffjátékos életerejét. #3d7abc(" .. value .. ")", 61, 122, 188)
					showAdminLog(adminRank .. " " .. adminName .. " átállította #3d7abc" .. targetName .. " #fffffféleterejét. #3d7abc(" .. value .. ")")

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("vhspawn",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then
						removePedFromVehicle(targetPlayer)
					end

					setElementPosition(targetPlayer, 1471.2080078125, -1749.4388427734, 14.519086837769)
					setElementInterior(targetPlayer, 0)
					setElementDimension(targetPlayer, 0)

					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffelteleportált téged a városházára.", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffSikeresen elteleportáltad a kiválasztott játékost a városházára. #3d7abc(" .. targetName .. ")", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("gethere",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local x, y, z = getElementPosition(sourcePlayer)
					local int = getElementInterior(sourcePlayer)
					local dim = getElementDimension(sourcePlayer)
					local rot = getPedRotation(sourcePlayer)

					x = x + math.cos(math.rad(rot)) * 2
					y = y + math.sin(math.rad(rot)) * 2

					local customInterior = getElementData(sourcePlayer, "currentCustomInterior") or 0
					if customInterior > 0 then
						exports.sm_interioredit:loadInterior(targetPlayer, customInterior)
					end

					if isPedInVehicle(targetPlayer) then
						local pedveh = getPedOccupiedVehicle(targetPlayer)

						setVehicleTurnVelocity(pedveh, 0, 0, 0)
						setElementInterior(pedveh, int)
						setElementDimension(pedveh, dim)
						setElementPosition(pedveh, x, y, z + 1)

						setTimer(setVehicleTurnVelocity, 50, 20, pedveh, 0, 0, 0)
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, int)
						setElementDimension(targetPlayer, dim)
					end

					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffmagához teleportált.", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffMagadhoz teleportáltad #3d7abc" .. targetName .. " #ffffffjátékost.", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("goto",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local x, y, z = getElementPosition(targetPlayer)
					local int = getElementInterior(targetPlayer)
					local dim = getElementDimension(targetPlayer)
					local rot = getPedRotation(targetPlayer)

					x = x + math.cos(math.rad(rot)) * 2
					y = y + math.sin(math.rad(rot)) * 2

					local customInterior = getElementData(targetPlayer, "currentCustomInterior") or 0
					if customInterior > 0 then
						local editingInterior = getElementData(targetPlayer, "editingInterior") or 0
						if editingInterior == 0 then
							exports.sm_interioredit:loadInterior(sourcePlayer, customInterior)
						else
							showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott játékos interior szerkesztő módban van.", 61, 122, 188)
							return
						end
					end

					if isPedInVehicle(sourcePlayer) then
						local pedveh = getPedOccupiedVehicle(sourcePlayer)

						setVehicleTurnVelocity(pedveh, 0, 0, 0)
						setElementInterior(pedveh, int)
						setElementDimension(pedveh, dim)
						setElementPosition(pedveh, x, y, z + 1)

						setElementInterior(sourcePlayer, int)
						setElementDimension(sourcePlayer, dim)
						setCameraInterior(sourcePlayer, int)

						warpPedIntoVehicle(sourcePlayer, pedveh)
						setTimer(setVehicleTurnVelocity, 50, 20, pedveh, 0, 0, 0)
					else
						setElementPosition(sourcePlayer, x, y, z)
						setElementInterior(sourcePlayer, int)
						setElementDimension(sourcePlayer, dim)
						setCameraInterior(sourcePlayer, int)
					end

					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffhozzád teleportált.", 61, 122, 188)
					showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffElteleportáltál #3d7abc" .. targetName .. " #ffffffjátékoshoz.", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("vanish",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			local vanished = getElementData(sourcePlayer, "player.Vanished")
			local newState = not vanished

			setElementData(sourcePlayer, "player.Vanished", newState)
			setElementAlpha(sourcePlayer, newState and 0 or 255)

			if newState then
				showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffLáthatatlanná tetted magad.", 61, 122, 188)
			else
				showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffLáthatóvá tetted magad.", 61, 122, 188)
			end
		end
	end)

addCommandHandler("aduty",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			local adminDutyState = getElementData(sourcePlayer, "adminDuty") or 0
			local adminName = getElementData(sourcePlayer, "acc.adminNick")

			if adminDutyState == 0 then
				setPlayerName(sourcePlayer, adminName)
				setElementData(sourcePlayer, "visibleName", adminName)
				setElementData(sourcePlayer, "adminDuty", 1)
				setElementData(sourcePlayer, "invulnerable", true)

				exports.sm_hud:showInfobox(root, "i", adminName .. " adminszolgálatba lépett.")
				showMessageForAdmins("[AdminDuty]: #3d7abc" .. adminName .. " #ffffffadminszolgálatba lépett.", 89, 142, 215)
			else
				local characterName = getElementData(sourcePlayer, "char.Name")

				setPlayerName(sourcePlayer, characterName)
				setElementData(sourcePlayer, "visibleName", characterName)
				setElementData(sourcePlayer, "adminDuty", 0)
				setElementData(sourcePlayer, "invulnerable", false)

				exports.sm_hud:showInfobox(root, "i", adminName .. " kilépett az adminszolgálatból.")
				showMessageForAdmins("[AdminDuty]: #3d7abc" .. adminName .. " #ffffffkilépett az adminszolgálatból.", 89, 142, 215)
			end
		end
	end)

addCommandHandler("aduty2",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			local adminDutyState = getElementData(sourcePlayer, "adminDuty") or 0
			local adminName = getElementData(sourcePlayer, "acc.adminNick")

			if adminDutyState ~= 2 then
				local characterName = getElementData(sourcePlayer, "char.Name")

				setPlayerName(sourcePlayer, characterName)
				setElementData(sourcePlayer, "visibleName", characterName)
				setElementData(sourcePlayer, "adminDuty", 2)
				setElementData(sourcePlayer, "invulnerable", true)

				showAdminMessageFor(sourcePlayer, "[AdminDuty - Hidden]: #ffffffRejtett adminszolgálatba léptél.", 89, 142, 215)
			else
				local characterName = getElementData(sourcePlayer, "char.Name")

				setPlayerName(sourcePlayer, characterName)
				setElementData(sourcePlayer, "visibleName", characterName)
				setElementData(sourcePlayer, "adminDuty", 0)
				setElementData(sourcePlayer, "invulnerable", false)

				showAdminMessageFor(sourcePlayer, "[AdminDuty - Hidden]: #ffffffKiléptél az adminszolgálatból..", 89, 142, 215)
			end
		end
	end)

addCommandHandler("changename",
	function (sourcePlayer, commandName, partialNick, newName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 5 then
			if not (partialNick and newName) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Név / ID] [Új név]", 255, 150, 0)
			else
				local targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, partialNick)

				if isElement(targetPlayer) then
					local accountId = getElementData(targetPlayer, "char.accID")
					local fixedName = utf8.gsub(newName, " ", "_")
					local currentName = getElementData(targetPlayer, "char.Name"):gsub("_", " ")

					dbQuery(
						function (queryHandle)
							local result, numRows = dbPoll(queryHandle, 0)

							if numRows == 0 then
								dbExec(connection, "UPDATE characters SET name = ? WHERE characterId = ?", fixedName, accountId)

								if isElement(targetPlayer) then
									local adminName = getElementData(sourcePlayer, "acc.adminNick")

									setPlayerName(targetPlayer, fixedName)
									setElementData(targetPlayer, "char.Name", fixedName)

									if getElementData(targetPlayer, "adminDuty") ~= 1 then
										setElementData(targetPlayer, "visibleName", fixedName)
									end

									showAdminMessageFor(targetPlayer, "[StrongMTA]: #3d7abc" .. adminName .. " #ffffffátállította a karakterneved. #3d7abc(" .. fixedName:gsub("_", " ") .. ")", 61, 122, 188)
								end

								if isElement(sourcePlayer) then
									showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffÁtállítottad #3d7abc" .. currentName .. " #ffffffjátékos karakternevét. #3d7abc(" .. fixedName:gsub("_", " ") .. ")", 61, 122, 188)
								end
							else
								showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott karakternév foglalt!", 215, 89, 89)
							end
						end,
					connection, "SELECT name FROM characters WHERE name = ? LIMIT 1", fixedName)
				end
			end
		end
	end
)

addCommandHandler("setadminnick",
	function (sourcePlayer, commandName, targetPlayer, newName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			if not targetPlayer or not newName then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Új név]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					setElementData(targetPlayer, "acc.adminNick", newName)

					if getElementData(targetPlayer, "adminDuty") == 1 then
						setElementData(targetPlayer, "visibleName", newName)
					end

					dbExec(connection, "UPDATE accounts SET adminNick = ? WHERE accountId = ?", newName, getElementData(targetPlayer, "char.accID"))

					showAdminMessage("[StrongMTA]: #3d7abc" .. adminName .. " #ffffffmegváltoztatta #3d7abc" .. targetName .. " #ffffffadminisztrátori nevét. #3d7abc(" .. newName .. ")", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName, newName})
				end
			end
		end
	end)

addCommandHandler("setadminlevel",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 7 or getPlayerSerial(sourcePlayer) == "6506960425D3D38103C9D76F43AC2B44" then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 11 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Szint < 0 - 11 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local currentAdminLevel = getElementData(targetPlayer, "acc.adminLevel") or 0

					if value == currentAdminLevel then
						showAdminMessageFor(sourcePlayer, "[StrongMTA]: #ffffffA kiválasztott játékos már a megadott szinten van.", 215, 89, 89)
						return
					end

					if value == 0 then
						setElementData(targetPlayer, "adminDuty", 0)
						setElementData(targetPlayer, "visibleName", getElementData(targetPlayer, "char.Name"):gsub(" ", "_"))
					end

					setElementData(targetPlayer, "acc.adminLevel", value)

					dbExec(connection, "UPDATE accounts SET adminLevel = ? WHERE accountId = ?", value, getElementData(targetPlayer, "char.accID"))

					showAdminMessage("[StrongMTA]: #3d7abc" .. adminName .. " #ffffffmegváltoztatta #3d7abc" .. targetName .. " #ffffffadminisztrátori szintjét. #3d7abc(" .. currentAdminLevel .. " >> " .. value .. ")", 61, 122, 188)

					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)
