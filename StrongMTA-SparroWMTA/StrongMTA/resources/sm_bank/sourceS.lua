local connection = false
local atmDataTable = {}

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end
)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()

		if connection then
			dbQuery(loadATMs, connection, "SELECT * FROM atms")
		end

		setTimer(resetRobbedATMs, 1000 * 60 * 15, 0)
	end
)

addCommandHandler("deleteatm",
	function (sourcePlayer, commandName, databaseId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 9 then
			databaseId = tonumber(databaseId)

			if not databaseId then
				outputChatBox("#3d7abc[Használat]: #ffffff/" .. commandName .. " [ID]", sourcePlayer, 255, 255, 255, true)
			else
				local objectElement = false

				for k in pairs(atmDataTable) do
					local bankId = getElementData(k, "bankId")

					if bankId and databaseId == bankId then
						objectElement = k
						break
					end
				end

				if isElement(objectElement) then
					outputChatBox("#3d7abc[StrongMTA]: #ffffffSikeresen törölted a kiválasztott ATM-et. #32b3ef(" .. databaseId .. ")", sourcePlayer, 255, 255, 255, true)

					if isElement(atmDataTable[objectElement]["colShapeElement"]) then
						destroyElement(atmDataTable[objectElement]["colShapeElement"])
					end

					destroyElement(objectElement)
					atmDataTable[objectElement] = nil

					dbExec(connection, "DELETE FROM atms WHERE dbID = ?", databaseId)
				else
					outputChatBox("#d75959[StrongMTA]: #ffffffA kiválasztott ATM nem létezik.", sourcePlayer, 255, 255, 255, true)
				end
			end
		end
	end
)

addEvent("placeATM", true)
addEventHandler("placeATM", getRootElement(),
	function (positionsTable)
		if isElement(source) then
			if positionsTable then
				dbExec(connection, "INSERT INTO atms (posX, posY, posZ, rotZ, interior, dimension) VALUES (?,?,?,?,?,?)", unpack(positionsTable))
				dbQuery(placeATMCallback, {source}, connection, "SELECT * FROM atms WHERE dbID = LAST_INSERT_ID()")
			end
		end
	end
)

function placeATMCallback(queryHandle, sourcePlayer)
	local resultRows, numAffectedRows, lastInsertId = dbPoll(queryHandle, 0)

	if resultRows then
		local resultRow = resultRows[1]

		if resultRow then
			createATM(resultRow.dbID, resultRow, true)

			if isElement(sourcePlayer) then
				local currentX, currentY, currentZ = getElementPosition(sourcePlayer)

				setElementPosition(sourcePlayer, currentX, currentY, currentZ + 0.5)

				exports.sm_accounts:showInfo(sourcePlayer, "s", "ATM sikeresen létrehozva! ID: " .. resultRow.dbID)
			end
		end
	end
end

function loadATMs(queryHandle)
	local resultRows, numAffectedRows, lastInsertId = dbPoll(queryHandle, 0)

	if resultRows then
		for k, v in pairs(resultRows) do
			createATM(v.dbID, v)
		end
	end
end

function createATM(dbID, data)
	if dbID and data then
		local objectElement = createObject(2942, data.posX, data.posY, data.posZ, 0, 0, data.rotZ)

		if isElement(objectElement) then
			setElementFrozen(objectElement, true)
			setElementInterior(objectElement, data.interior)
			setElementDimension(objectElement, data.dimension)
			setElementData(objectElement, "bankId", dbID)
		end

		local colShapeElement = createColSphere(data.posX, data.posY, data.posZ + 0.35, 1.25)

		if isElement(colShapeElement) then
			setElementInterior(colShapeElement, data.interior)
			setElementDimension(colShapeElement, data.dimension)
			setElementData(colShapeElement, "atmRobID", dbID)
			setElementData(colShapeElement, "atmRobObject", objectElement)
		end

		atmDataTable[objectElement] = {}
		atmDataTable[objectElement]["colShapeElement"] = colShapeElement
		atmDataTable[objectElement]["robProgress"] = false
		atmDataTable[objectElement]["compartments"] = {}

		return true
	end

	return false
end

function resetRobbedATMs()
	for k in pairs(atmDataTable) do
		if getElementModel(k) == 2943 then
			setElementModel(k, 2942)

			atmDataTable[k]["robProgress"] = false
			atmDataTable[k]["compartments"] = {}

			setElementData(k, "isRobbed", false)
		end
	end
end

addEvent("startATMGrinding", true)
addEventHandler("startATMGrinding", getRootElement(),
	function (playersTable, grindingState, objectElement, grindingProgress)
		if isElement(source) then
			if atmDataTable[objectElement] then
				local currentProgress = atmDataTable[objectElement]["robProgress"]

				setElementData(objectElement, "isRobbed", true)

				if grindingState then
					setPedAnimation(source, "SWORD", "sword_IDLE")
				else
					currentProgress = grindingProgress
					atmDataTable[objectElement]["robProgress"] = currentProgress

					if grindingProgress <= 0 then
						setElementModel(objectElement, 2943)
					end
				end

				triggerClientEvent(playersTable, "syncSpark", source, grindingState, objectElement, currentProgress)
			end
		end
	end
)

addEvent("requestATMCompartments", true)
addEventHandler("requestATMCompartments", getRootElement(),
	function (objectElement)
		if isElement(source) then
			if atmDataTable[objectElement] then
				triggerClientEvent(source, "showRobGui", source, atmDataTable[objectElement]["compartments"])
			end
		end
	end
)

addEvent("openATMCompartment", true)
addEventHandler("openATMCompartment", getRootElement(),
	function (playersTable, objectElement, compartmentId)
		if isElement(source) then
			if atmDataTable[objectElement] then
				if exports.sm_items:hasSpaceForItem(source, 119, 1) then
					triggerClientEvent(playersTable, "atmCompartmentSound", source, objectElement, compartmentId)

					exports.sm_items:giveItem(source, 119, 1)
					atmDataTable[objectElement]["compartments"][compartmentId] = true

					setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)
					setTimer(setPedAnimation, 2000, 1, source, false)
				else
					exports.sm_accounts:showInfo(source, "e", "Nem fér el nálad a tárgy!")
				end
			end
		end
	end
)

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

addEvent("depositMoney", true)
addEventHandler("depositMoney", getRootElement(),
	function (amount)
		if isElement(source) then
			if amount then
				amount = tonumber(amount)

				if amount then
					amount = math.floor(amount)

					if amount then
						local chargeAmount = math.floor(amount * 0.01)
						local currentBalance = getElementData(source, "char.bankMoney") or 0
						local newBalance = currentBalance + amount - chargeAmount

						if exports.sm_core:takeMoneyEx(source, amount) then
							setElementData(source, "char.bankMoney", newBalance)

							outputChatBox("#3d7abc[StrongMTA]: #ffffffSikeresen befizettél #3d7abc" .. formatNumber(amount) .. " $-t #ffffffa számládra.", source, 255, 255, 255, true)
							outputChatBox("Új egyenleged: #3d7abc" .. formatNumber(newBalance) .. " $", source, 255, 255, 255, true)
							outputChatBox("Kezelési költség: #3d7abc" .. formatNumber(chargeAmount) .. " $", source, 255, 255, 255, true)

							exports.sm_accounts:showInfo(source, "s", "Sikeres tranzakció! Részletek a chatboxban!")
						end
					end
				end
			end
		end
	end
)

addEvent("withdrawMoney", true)
addEventHandler("withdrawMoney", getRootElement(),
	function (amount)
		if isElement(source) then
			if amount then
				amount = tonumber(amount)

				if amount then
					amount = math.floor(amount)

					if amount then
						local chargeAmount = math.floor(amount * 0.01)
						local currentBalance = getElementData(source, "char.bankMoney") or 0
						local newBalance = currentBalance - amount

						if exports.sm_core:giveMoney(source, amount - chargeAmount) then
							setElementData(source, "char.bankMoney", newBalance)

							outputChatBox("#3d7abc[StrongMTA]: #ffffffSikeresen kivettél #3d7abc" .. formatNumber(amount) .. " $-t #ffffffa számládról.", source, 255, 255, 255, true)
							outputChatBox("Új egyenleged: #3d7abc" .. formatNumber(newBalance) .. " $", source, 255, 255, 255, true)
							outputChatBox("Kezelési költség: #3d7abc" .. formatNumber(chargeAmount) .. " $", source, 255, 255, 255, true)

							exports.sm_accounts:showInfo(source, "s", "Sikeres tranzakció! Részletek a chatboxban!")
						end
					end
				end
			end
		end
	end
)
