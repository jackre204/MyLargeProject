rouletteTables = {}

local chipModels = {
	[200] = 1853,
	[500] = 1854,
	[1000] = 1855,
	[5000] = 1856,
	[10000] = 1857,
	[20000] = 1858
}

addEventHandler("onDatabaseConnected", getRootElement(),
	function(db)
		connection = db
	end
)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()

		dbQuery(
			function (qh)
				local result = dbPoll(qh, 0)

				if result then
					for k, v in pairs(result) do
						loadRouletteTable(v.id, v)
					end
				end
			end,
		connection, "SELECT * FROM roulettes")
	end
)

addEvent("setPlayerTableState", true)
addEventHandler("setPlayerTableState", getRootElement(),
	function(player, element, state)
		if state == "tableIn" then
			local tableId = getElementData(element, "casino:rouletteTable")
			local rouletteTable = rouletteTables[tableId]
			
			setPedAnimation(player, "CASINO", "Roulette_loop", -1, true, false, false, false)
			setElementData(player, "rouletteAnimating", tableId)
			triggerRouletteEvent(tableId, "syncRouletteRemainingTime", rouletteTable.betsOnField, rouletteTable.betsHistory, getRoundTime(rouletteTable), false)
		elseif state == "tableOut" then
			setPedAnimation(player, "CASINO", "Roulette_out", -1, false, false, false, false)
			setElementData(player, "rouletteAnimating", false)
		end
	end
)

addEvent("createRouletteTableServer", true)
addEventHandler("createRouletteTableServer", getRootElement(),
	function(data)
		if isElement(source) then
			if data then
				dbExec(connection, "INSERT INTO roulettes (x, y, z, rz, interior, dimension) VALUES (?,?,?,?,?,?)", data.x, data.y, data.z, data.rot, data.dimensionID, data.interiorID)
				dbQuery(
					function (qh, sourcePlayer)
						local result = dbPoll(qh, 0)[1]

						if result then
							loadRouletteTable(result.id, result, true)
							exports.sm_accounts:showInfo(sourcePlayer, "s", "Rulett asztal sikeresen létrehozva! ID: " .. result.id)
						end
					end,
				{source}, connection, "SELECT * FROM roulettes WHERE id = LAST_INSERT_ID()")
			end
		end
	end
)

addEvent("makeNewBetServer", true)
addEventHandler("makeNewBetServer", getRootElement(),
	function(field, datas, players)
		if isElement(source) then
			local playerX, playerY, playerZ = getElementPosition(source)
			local tableId = getElementData(source, "rouletteAnimating")

			if tableId then
				print("asd")
				local fieldNumbers, fieldName, priceMultipler, betAmount = datas[1], datas[2], datas[4], datas[6]
				local rouletteTable = rouletteTables[tableId]	

				if rouletteTable then
					local myCharId = getElementData(source, "char.ID")
					local myCharName = getElementData(source, "char.Name"):gsub("_", " ")

					if rouletteTable.gameStage == 0 then
						rouletteTable.gameStage = 1
						rouletteTable.roundTimer = setTimer(pickWinningNumber, interactionTime, 1, tableId)
						rouletteTable.betsOnField = {}

						table.insert(rouletteTable.betsHistory, "new")
						table.insert(rouletteTable.roundHistory, 1, "#737373-- Új kör kezdődött --")
					end

					if not rouletteTable.betsOnField[field] then
						rouletteTable.betsOnField[field] = {}
					end

					table.insert(rouletteTable.betsOnField[field], {betAmount, source})

					local myLastBet = false

					for i = #rouletteTable.betsHistory, 1, -1 do
						local dat = rouletteTable.betsHistory[i]

						if dat ~= "new" then
							if dat[1] == field and dat[4] and dat[4] == myCharId then
								myLastBet = i
								break
							end
						end
					end

					local bet = betAmount

					if myLastBet then
						bet = bet + rouletteTable.betsHistory[myLastBet][3]
						table.remove(rouletteTable.betsHistory, myLastBet)
					end

					table.insert(rouletteTable.betsHistory, {field, fieldName, bet, myCharId, myCharName, fieldNumbers, priceMultipler + 1, source})

					local currentBalance = getElementData(source, "char.slotCoins") or 0

					if currentBalance - betAmount >= 0 then
						setElementData(source, "char.slotCoins", currentBalance - betAmount)
					else
						setElementData(source, "char.slotCoins", 0)
					end

					triggerRouletteEvent(tableId, "syncRouletteRemainingTime", rouletteTable.betsOnField, rouletteTable.betsHistory, getRoundTime(rouletteTable), false)
					triggerClientEvent(players, "chipSound", source, playerX, playerY, playerZ, math.random(3))

					setPedAnimation(source, "CASINO", "Roulette_bet", -1, false, false, false, false)
					setTimer(setPedAnimation, 1275, 1, source, "CASINO", "Roulette_loop", -1, true, false, false, false)

					createChip(tableId, field, betAmount, myCharId)
				end
			end
		end
	end
)

function pickWinningNumber(tableId)
	local rouletteTable = rouletteTables[tableId]

	if rouletteTable then
		rouletteTable.gameStage = 2

		local oldNum = getElementData(rouletteTable.element, "rouletteNumber") or getRealTime().monthday
		local newNum = wheelNumbers[math.random(0, 36)]

		setElementData(rouletteTable.element, "rouletteNumber", newNum)
		
		triggerRouletteEvent(tableId, "zoomCameraToBall")
		print("sdsdsd")

		--triggerClientEvent("onRouletteWheelSound", rouletteTable.element)

		rouletteTable.spinTimer = setTimer(finishTheRound, 10000, 1, tableId)
	end
end

function finishTheRound(tableId)
	local rouletteTable = rouletteTables[tableId]

	if rouletteTable then
		payoutTheWinners(tableId)

		rouletteTable.gameStage = 0
		rouletteTable.betsOnField = {}

		if isTimer(rouletteTable.roundTimer) then
			killTimer(rouletteTable.roundTimer)
		end

		rouletteTable.roundTimer = nil

		if isTimer(rouletteTable.spinTimer) then
			killTimer(rouletteTable.spinTimer)
		end

		rouletteTable.spinTimer = nil

		local temp = {}

		for i = #rouletteTable.roundHistory, 1, -1 do
			if i > #rouletteTable.roundHistory - 11 then
				table.insert(temp, 1, rouletteTable.roundHistory[i])
			end
		end

		rouletteTable.roundHistory = temp

		local temp = {}

		for i = #rouletteTable.betsHistory, 1, -1 do
			local dat = rouletteTable.betsHistory[i]

			if i > #rouletteTable.betsHistory - 11 then
				table.insert(temp, 1, dat)
			end
		end

		rouletteTable.betsHistory = temp

		triggerRouletteEvent(tableId, "syncRouletteRemainingTime", rouletteTable.betsOnField, rouletteTable.betsHistory, getRoundTime(rouletteTable), false)

		for field, data in pairs(rouletteTable.chipObjects) do
			for i = 1, #data do
				if isElement(data[i][1]) then
					destroyElement(data[i][1])
				end
			end

			rouletteTable.chipObjects[field] = nil
		end

		rouletteTable.chipObjects = {}
	end
end

function getRoundTime(rouletteTable)
	local time = false

	if isTimer(rouletteTable.roundTimer) then
		--time = getTimerDetails(rouletteTable.roundTimer) - interactionTime
		time = interactionTime - getTimerDetails(rouletteTable.roundTimer)
	end

	return time
end

function triggerRouletteEvent(id, eventName, ...)
	local rouletteTable = rouletteTables[id]

	if rouletteTable then
		local players = {}

		for k, v in pairs(getElementsByType("player")) do
			local tableId = getElementData(v, "rouletteAnimating")

			if id == tableId then
				table.insert(players, v)
			end
		end

		triggerClientEvent(players, eventName, resourceRoot, ...)

		return true
	end

	return false
end

addEvent("revokePlacedCoin", true)
addEventHandler("revokePlacedCoin", getRootElement(),
	function(field)
		if isElement(source) then

			local tableId = getElementData(source, "rouletteAnimating")

			if tableId then
				local rouletteTable = rouletteTables[tableId]

				if rouletteTable then
					local myCharId = getElementData(source, "char.ID")

					if not rouletteTable.spinTimer then
						local creditAll = 0

						if rouletteTable.betsOnField[field] then
							local temp = {}

							for i = 1, #rouletteTable.betsOnField[field] do
								local dat = rouletteTable.betsOnField[field][i]

								if dat[2] ~= source then
									table.insert(temp, 1, dat)
								else
									creditAll = creditAll + dat[1]
								end
							end

							rouletteTable.betsOnField[field] = temp
						end

						setElementData(source, "char.slotCoins", (getElementData(source, "char.slotCoins") or 0) + creditAll)

						local temp = {}

						for i = #rouletteTable.betsHistory, 1, -1 do
							local dat = rouletteTable.betsHistory[i]

							if dat ~= "new" then
								if dat[1] ~= field or dat[4] ~= myCharId then
									table.insert(temp, 1, dat)
								end
							else
								table.insert(temp, 1, dat)
							end
						end

						rouletteTable.betsHistory = temp
						--triggerRouletteEvent(tableId, "syncRouletteRemainingTime", rouletteTable.betsOnField, rouletteTable.betsHistory, getRoundTime(rouletteTable), false)
						triggerRouletteEvent(tableId, "syncRouletteRemainingTime", rouletteTable.betsOnField, temp, getRoundTime(rouletteTable), false)
						--triggerClientEvent(source, "onRouletteBetRemoved", source)

						if rouletteTable.chipObjects[field] then
							local temp = {}

							for i = 1, #rouletteTable.chipObjects[field] do
								local dat = rouletteTable.chipObjects[field][i]

								if dat[2] ~= myCharId then
									table.insert(temp, 1, dat)
								else
									if isElement(dat[1]) then
										destroyElement(dat[1])
									end
								end
							end

							local z = select(3, getElementPosition(rouletteTable.element))
						
							for i = 1, #temp do
								local obj = temp[i][1]
								local x, y = getElementPosition(obj)

								setElementPosition(obj, x, y, z - 0.175 + (i - 1) * 0.0105)
							end

							rouletteTable.chipObjects[field] = temp
						end
					end
				end
			end
		end
	end
)

function loadRouletteTable(id, data)
	local obj = createObject(1978, data.x, data.y, data.z, 0, 0, data.rz)

	setElementInterior(obj, data.interior)
	setElementDimension(obj, data.dimension)
	setElementData(obj, "casino:rouletteTable", id)
	setElementCollisionsEnabled(obj, false)

	rouletteTables[id] = {}
	rouletteTables[id].element = obj
	rouletteTables[id].betsOnField = {}
	rouletteTables[id].betsHistory = {}
	rouletteTables[id].roundHistory = {}
	rouletteTables[id].gameStage = 0
	rouletteTables[id].roundTimer = false
	rouletteTables[id].spinTimer = false
	rouletteTables[id].chipObjects = {}

	setElementCollisionsEnabled(obj, true)
end

function createChip(tableId, field, coin, charId)
	local rouletteTable = rouletteTables[tableId]

	if rouletteTable then
		local fieldX, fieldY = unpack(split(field, ","))

		fieldX = tonumber(fieldX)
		fieldY = tonumber(fieldY)

		if math.ceil(fieldX * 0.5) / 0.5 == 256 then
			fieldX = fieldX + 10
		end

		if math.ceil(fieldY * 0.5) / 0.5 == 222 then
			fieldY = fieldY + 15
		end

		fieldX, fieldY = getFieldRealCoord(fieldX, fieldY)

		if not rouletteTable.chipObjects[field] then
			rouletteTable.chipObjects[field] = {}
		end

		local id = #rouletteTable.chipObjects[field]

		local x, y, z = getElementPosition(rouletteTable.element)
		local rz = select(3, getElementRotation(rouletteTable.element))

		local x2, y2 = rotateAround(rz, fieldY, fieldX)
		local obj = createObject(chipModels[coin], x + x2, y + y2, z - 0.175 + id * 0.0105, 0, 0, math.random(360))

		setObjectScale(obj, 0.375)
		setElementInterior(obj, getElementInterior(rouletteTable.element))
		setElementDimension(obj, getElementDimension(rouletteTable.element))

		table.insert(rouletteTable.chipObjects[field], {obj, charId})
	end
end

function payoutTheWinners(tableId)
	local rouletteTable = rouletteTables[tableId]

	if rouletteTable then
		local winningNumber = getElementData(rouletteTable.element, "rouletteNumber")
		local winnersTable = {}
		local winners = 0

		for i = #rouletteTable.betsHistory, 1, -1 do
			local dat = rouletteTable.betsHistory[i]

			if dat ~= "new" and dat[4] then
				local field, credit, charId, fieldNumbers, priceMultipler = dat[2], dat[3], dat[4], dat[6], dat[7]
				local win = false
					
				if string.find(field, "straight") then
					if tonumber(string.sub(field, 10)) == winningNumber then
						win = true
					end
				else
					for i = 1, #fieldNumbers do
						if tonumber(fieldNumbers[i]) == winningNumber then
							win = true
							break
						end
					end
				end

				if not winnersTable[charId] then
					winnersTable[charId] = {0, dat[5], dat[8], 0}
				end

				if win then
					winnersTable[charId][1] = winnersTable[charId][1] + credit * priceMultipler
				else
					winnersTable[charId][4] = winnersTable[charId][4] + credit
				end

				dat[4] = nil
			end
		end

		for charId, data in pairs(winnersTable) do
			if data[1] > 0 then
				table.insert(rouletteTable.roundHistory, 1, "#D6D6D6" .. data[2] .. " nyereménye: " .. data[1] .. " Coin")
				winners = winners + 1
			end

			if isElement(data[3]) then
				setElementData(data[3], "char.slotCoins", (getElementData(data[3], "char.slotCoins") or 0) + data[1])

				if data[1] > data[4] then
					setPedAnimation(data[3], "CASINO", "Roulette_win", -1, false, false, false, false)
					setElementData(data[3], "playerIcons", {"plus", data[1]})
				else
					setPedAnimation(data[3], "CASINO", "Roulette_lose", -1, false, false, false, false)
					setElementData(data[3], "playerIcons", {"minus", data[4]})
				end

				setTimer(setPedAnimation, 2000, 1, data[3], "CASINO", "Roulette_loop", -1, true, false, false, false)
			end
		end

		if winners == 0 then
			table.insert(rouletteTable.roundHistory, 1, "#D6D6D6Ebben a körben nem nyert senki.")
		end
	end
end