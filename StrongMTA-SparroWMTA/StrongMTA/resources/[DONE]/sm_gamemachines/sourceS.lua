local databaseConnection = false
local gameMachineObjects = {}
local gameMachinesUsedBy = {}

addEventHandler("onDatabaseConnected", root,
	function (connectionElement)
		databaseConnection = connectionElement
	end
)

function saveGameMachines()
	if databaseConnection then
		for machineId, objectElement in pairs(gameMachineObjects) do
			if isElement(objectElement) then
				local machineCredit = getElementData(objectElement, "slotMachineCredit") or 0

				if machineCredit then
					dbExec(databaseConnection, "UPDATE gamemachines SET credit = ? WHERE dbId = ?", machineCredit, machineId)
				end
			end
		end
	end
end

addEventHandler("onResourceStop", root,
	function (stoppedResource)
		if stoppedResource == resource then
			saveGameMachines()
		else
			if gameMachinesUsedBy[stoppedResource] then
				for i = 1, #gameMachinesUsedBy[stoppedResource] do
					local machineId = gameMachinesUsedBy[stoppedResource][i]

					if machineId then
						local machineObject = gameMachineObjects[machineId]

						if machineObject then
							local machineUser = getElementData(machineObject, "slotMachineInUse")

							if isElement(machineUser) then
								removeElementData(machineUser, "slotMachineId")
							end

							setElementData(machineObject, "slotMachineInUse", false)
						end
					end
				end
				gameMachinesUsedBy[stoppedResource] = nil
			end
		end
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function ()
		databaseConnection = exports.sm_database:getConnection()

		if databaseConnection then
			dbQuery(
				function (queryHandle)
					local queryResult = dbPoll(queryHandle, 0)

					if queryResult then
						for rowIndex, rowInfo in ipairs(queryResult) do
							createGameMachine(rowInfo)
						end
					end
				end,
			databaseConnection, "SELECT * FROM gamemachines")
		end

		setTimer(saveGameMachines, 1000 * 60 * 30, 0)
	end
)

function createGameMachine(machineInfo, justNowCreated)
	if machineInfo then
		local machineId = machineInfo.dbId

		if machineId then
			gameMachineObjects[machineId] = createObject(machineModels[machineInfo.gameType], machineInfo.posX, machineInfo.posY, machineInfo.posZ, 0, 0, machineInfo.rotZ)

			if isElement(gameMachineObjects[machineId]) then
				setElementInterior(gameMachineObjects[machineId], machineInfo.interior)
				setElementDimension(gameMachineObjects[machineId], machineInfo.dimension)
				setElementData(gameMachineObjects[machineId], "slotMachineId", machineId)
				setElementData(gameMachineObjects[machineId], "slotMachineType", machineInfo.gameType, false)
				setElementData(gameMachineObjects[machineId], "slotMachineCredit", machineInfo.credit, false)
				setElementData(gameMachineObjects[machineId], "slotMachineInUse", false)
			end
		end
	end
end

addEvent("placeGameMachine", true)
addEventHandler("placeGameMachine", resourceRoot,
	function (dataTable)
		if isElement(client) then
			if type(dataTable) == "table" then
				local columnNames = {}
				local columnValues = {}

				for columnName, columnValue in pairs(dataTable) do
					table.insert(columnNames, columnName)
					table.insert(columnValues, columnValue)
				end

				dbQuery(
					function (queryHandle, sourcePlayer)
						local queryResult, numAffectedRows, lastInsertId = dbPoll(queryHandle, 0)

						if queryResult then
							lastInsertId = tonumber(lastInsertId)

							if lastInsertId then
								if isElement(sourcePlayer) then
									outputChatBox("#7cc576[SeeMTA]: #ffffffA játékgép sikeresen létrehozva. #32b3ef(ID: " .. lastInsertId .. ")", sourcePlayer, 255, 255, 255, true)
								end

								if not dataTable.dbId then
									dataTable.dbId = lastInsertId
								end

								if not dataTable.credit then
									dataTable.credit = 0
								end

								createGameMachine(dataTable, true)
							else
								if isElement(sourcePlayer) then
									outputChatBox("#d75959[SeeMTA]: #ffffffA játékgép létrehozása meghiúsult.", sourcePlayer, 255, 255, 255, true)
								end
							end
						else
							if isElement(sourcePlayer) then
								outputChatBox("#d75959[SeeMTA]: #ffffffA játékgép létrehozása meghiúsult.", sourcePlayer, 255, 255, 255, true)
							end
						end
					end,
				{client}, databaseConnection, "INSERT INTO gamemachines (" .. table.concat(columnNames, ",") .. ") VALUES (" .. string.sub(string.rep("?,", #columnNames), 1, -2) .. ")", unpack(columnValues))
			end
		end
	end
)

addCommandHandler("delgamemachine",
	function (sourcePlayer, commandName, machineId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 9 then
			machineId = tonumber(machineId)

			if not machineId then
				outputChatBox("#7cc576[Használat]: #FFFFFF/" .. commandName .. " [ID]", sourcePlayer, 255, 255, 255, true)
			else
				if gameMachineObjects[machineId] then
					local executionResult = dbExec(databaseConnection, "DELETE FROM gamemachines WHERE dbId = ?", machineId)

					if executionResult then
						outputChatBox("#7cc576[SeeMTA]: #ffffffA játékgép sikeresen törölve. #32b3ef(" .. machineId .. ")", sourcePlayer, 255, 255, 255, true)

						if isElement(gameMachineObjects[machineId]) then
							destroyElement(gameMachineObjects[machineId])
						end

						gameMachineObjects[machineId] = nil
					end
				else
					outputChatBox("#d75959[SeeMTA]: #ffffffA kiválasztott játékgép nem létezik.", sourcePlayer, 255, 255, 255, true)
				end
			end
		end
	end
)

addEvent("requestTransaction", true)
addEventHandler("requestTransaction", resourceRoot,
	function (machineId, actionType, creditAmount)
		if isElement(client) then
			if machineId then
				creditAmount = tonumber(creditAmount)

				if creditAmount then
					local machineObject = gameMachineObjects[machineId]

					if machineObject then
						local machineUser = getElementData(machineObject, "slotMachineInUse")

						if not isElement(machineUser) then
							local characterCoins = getElementData(client, "char.slotCoins") or 0
							local machineCredits = getElementData(machineObject, "slotMachineCredit") or 0

							if actionType == "deposit" then
								if characterCoins >= creditAmount then
									machineCredits = machineCredits + creditAmount
									characterCoins = characterCoins - creditAmount

									setElementData(machineObject, "slotMachineCredit", machineCredits, false)
									setElementData(client, "char.slotCoins", characterCoins, true)

									exports.sm_accounts:showInfo(client, "s", "Sikeres befizetés! Kellemes játékot :)")
									exports.sm_chat:localAction(client, "befizet egy összeget a játékgépbe.")
								else
									exports.sm_accounts:showInfo(client, "e", "Nincs ennyi SSC-d.")
								end
							elseif actionType == "withdraw" then
								if machineCredits >= creditAmount then
									machineCredits = machineCredits - creditAmount
									characterCoins = characterCoins + creditAmount

									setElementData(machineObject, "slotMachineCredit", machineCredits, false)
									setElementData(client, "char.slotCoins", characterCoins, true)

									exports.sm_accounts:showInfo(client, "s", "Sikeres kifizetés!")
									exports.sm_chat:localAction(client, "kifizet egy összeget a játékgépből.")
								else
									exports.sm_accounts:showInfo(client, "e", "Nincs ennyi SSC a játékgépben.")
								end
							end
						else
							exports.sm_accounts:showInfo(client, "e", "Ez a játékgép használatban van!")
						end
					end
				end
			end
		end
	end
)

addEvent("requestGameOpen", true)
addEventHandler("requestGameOpen", resourceRoot,
	function (machineId)
		if isElement(client) then
			if machineId then
				local machineObject = gameMachineObjects[machineId]

				if machineObject then
					local machineUser = getElementData(machineObject, "slotMachineInUse")

					if not isElement(machineUser) then
						local gameType = getElementData(machineObject, "slotMachineType")

						if gameType then
							local gameResourceName = gameResourceNames[gameType]
							local gameResource = getResourceFromName(gameResourceName)

							--if gameResource then
								local gameResourceRoot = getResourceRootElement(gameResource)

								--if gameResourceRoot then
									local currentCredit = getElementData(machineObject, "slotMachineCredit") or 0

									setElementData(machineObject, "slotMachineInUse", client)
									setElementData(client, "slotMachineId", machineId, false)

									if not gameMachinesUsedBy[gameResource] then
										gameMachinesUsedBy[gameResource] = {machineId}
									else
										table.insert(gameMachinesUsedBy[gameResource], machineId)
									end

									local machinePosX, machinePosY, machinePosZ = getElementPosition(machineObject)
									local machineRotX, machineRotY, machineRotZ = getElementRotation(machineObject)

									local playerPosX, playerPosY = rotateAround(machineRotZ + 180, 0, 0.65)
									local playerPosZ = 1

									playerPosX = machinePosX + playerPosX
									playerPosY = machinePosY + playerPosY
									playerPosZ = machinePosZ + playerPosZ

									setElementPosition(client, playerPosX, playerPosY, playerPosZ)
									setElementRotation(client, 0, 0, machineRotZ, "default", true)

									setElementFrozen(client, true)
									setPedAnimation(client, "CASINO", "Roulette_loop", -1, true, false, false, false)

									triggerClientEvent(client, "receiveGameOpen", gameResourceRoot, machineId, currentCredit)
								--else
									--exports.sm_accounts:showInfo(client, "e", "Ez a játékgép jelenleg nem üzemel!")
								--end
							--else
								--exports.sm_accounts:showInfo(client, "e", "Ez a játékgép jelenleg nem üzemel!")
							--end
						end
					else
						exports.sm_accounts:showInfo(client, "e", "Ez a játékgép használatban van!")
					end
				end
			end
		end
	end
)

addEvent("requestGameClose", true)
addEventHandler("requestGameClose", resourceRoot,
	function (machineId, machineCredit)
		if isElement(client) then
			if machineId then
				local machineObject = gameMachineObjects[machineId]

				if machineObject then
					local gameType = getElementData(machineObject, "slotMachineType")

					if gameType then
						local gameResourceName = gameResourceNames[gameType]
						local gameResource = getResourceFromName(gameResourceName)

						if gameResource then
							if gameMachinesUsedBy[gameResource] then
								for i = #gameMachinesUsedBy[gameResource], 1, -1 do
									if gameMachinesUsedBy[gameResource][i] == machineId then
										table.remove(gameMachinesUsedBy[gameResource], i)
										break
									end
								end

								if #gameMachinesUsedBy[gameResource] == 0 then
									gameMachinesUsedBy[gameResource] = nil
								end
							end
						end
					end

					setElementData(machineObject, "slotMachineCredit", machineCredit, false)
					setElementData(machineObject, "slotMachineInUse", false)

					setElementData(client, "slotMachineId", false, false)

					setElementFrozen(client, false)
					setPedAnimation(client, "CASINO", "Roulette_out", -1, false, false, false, false)
				end
			end
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function ()
		local slotMachineId = getElementData(source, "slotMachineId")

		if slotMachineId then
			local slotMachineObject = gameMachineObjects[slotMachineId]

			if isElement(slotMachineObject) then
				local slotMachineUser = getElementData(slotMachineObject, "slotMachineInUse")

				if slotMachineUser == source then
					setElementData(slotMachineObject, "slotMachineInUse", false)
				end
			end
		end
	end
)