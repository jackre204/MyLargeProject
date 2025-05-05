local connection = false

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()
	end)

addEvent("countCarsByModel", true)
addEventHandler("countCarsByModel", getRootElement(),
	function(model)
		if model then
			dbQuery(
				function (qh, thePlayer)
					if isElement(thePlayer) then
						local result = dbPoll(qh, 0)

						triggerClientEvent(thePlayer, "countCarsByModel", thePlayer, result[1]["vehicleCount"])
					end
				end, {source},
			connection, "SELECT COUNT(vehicleId) AS vehicleCount FROM vehicles WHERE modelId = ? AND groupId = 0 AND ownerId > 0", model)
		end
	end)

addEvent("buyTheCurrentCar", true)
addEventHandler("buyTheCurrentCar", getRootElement(),
	function (veh, typ, r, g, b)
		if veh and typ then
			dbQuery(tryToBuyCar, {source, {veh, typ, r, g, b}}, connection, "SELECT characters.maxVehicles, COUNT(vehicles.vehicleId) AS ownedVehicles FROM characters JOIN vehicles ON vehicles.ownerId = ? WHERE characters.characterId = ? AND vehicles.groupId = 0", getElementData(source, "char.ID"), getElementData(source, "char.ID"))
		end
	end)

function tryToBuyCar(qh, thePlayer, datas)
	local result = dbPoll(qh, 0)
	local row = result[1]

	if isElement(thePlayer) then
		if row.maxVehicles <= row.ownedVehicles then
			setElementData(thePlayer, "char.maxVehicles", row.maxVehicles)
			exports.sm_accounts:showInfo(thePlayer, "e", "Nincs elég járműslotod!")
		else
			local currentPP = false

			if datas[2] == "money" then
				if datas[1].limit ~= -1 then
					local qh = dbQuery(connection, "SELECT COUNT(vehicleId) AS vehicleCount FROM vehicles WHERE modelId = ? AND groupId = 0 AND ownerId > 0", datas[1].model)
					local result = dbPoll(qh, 1000)

					if result and result[1].vehicleCount >= datas[1].limit then
						triggerClientEvent(thePlayer, "maxLimitVehConfirm", thePlayer)
						return
					end

					if not result then
						return
					end
				end

				if exports.sm_core:getMoney(thePlayer) - datas[1].price < 0 then
					exports.sm_accounts:showInfo(thePlayer, "e", "Nincs elég pénzed a jármű megvásárlásához.")
					return
				end
			else
				local qh = dbQuery(connection, "SELECT premiumPoints FROM accounts WHERE accountId = ?", getElementData(thePlayer, "char.accID"))
				local result = dbPoll(qh, 1000)

				if result then
					if result[1].premiumPoints - 1000 < 0 then
						exports.sm_accounts:showInfo(thePlayer, "e", "Nincs elég prémium pontod a jármű megvásárlásához.")
						return
					end

					currentPP = result[1].premiumPoints
				end

				if not result then
					return
				end
			end

			if not exports.sm_items:hasSpaceForItem(thePlayer, 1, 1) then
				exports.sm_accounts:showInfo(thePlayer, "e", "Nincs elég hely az inventorydban a kulcshoz.")
				return
			end

			if datas[2] == "money" then
				exports.sm_core:takeMoney(thePlayer, datas[1].price, "buyNewCar")
			elseif currentPP then
				setElementData(thePlayer, "acc.premiumPoints", currentPP - 1000)

				dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currentPP - 1000, getElementData(thePlayer, "char.accID"))
				
				exports.sm_core:takeMoney(thePlayer, datas[1].price, "buyNewCar")
				
				exports.sm_logs:addLogEntry("premiumshop", {
					accountId = getElementData(thePlayer, "char.accID"),
					characterId = getElementData(thePlayer, "char.ID"),
					itemId = "buynewcar",
					amount = 1,
					oldPP = currentPP,
					newPP = currentPP - 1000
				})
			else
				return
			end

			triggerClientEvent(thePlayer, "exitShop", thePlayer)

			setTimer(
				function()
					exports.sm_vehicles:createPermVehicle({
						modelId = datas[1].model,
						color1 = string.format("#%.2X%.2X%.2X", datas[3] or 255, datas[4] or 255, datas[5] or 255),
						color2 = string.format("#%.2X%.2X%.2X", datas[3] or 255, datas[4] or 255, datas[5] or 255),
						targetPlayer = thePlayer,
						posX = 1345.4825439453,
						posY = -1761.0729980469,
						posZ = 13.60781288147,
						rotX = 0,
						rotY = 0,
						rotZ = 359,
						interior = 0,
						dimension = 0
					})
				end,
			2100, 1)

			exports.sm_accounts:showInfo(thePlayer, "s", "Sikeres vásárlás!")
		end
	end
end