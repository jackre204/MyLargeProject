local tuningMarkers = {}
local performanceTuningMarkers = {}

connection = false

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end
)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()

		for k, v in ipairs(tuningPositions) do
			tuningMarkers[k] = createMarker(v[1], v[2], v[3] + 1, "cylinder", 3, 124, 197, 118, 100)

			if isElement(tuningMarkers[k]) then
				setElementData(tuningMarkers[k], "tuningPositionId", k, false)
			end
		end

		for k, v in ipairs(performacePositions) do
			performanceTuningMarkers[k] = createMarker(v[1], v[2], v[3] + 1, "cylinder", 3, 124, 197, 118, 100)

			if isElement(performanceTuningMarkers[k]) then
				setElementData(performanceTuningMarkers[k], "performanceTuningPositionId", k, false)
			end
		end
	end
)

addEventHandler("onMarkerHit", getResourceRootElement(),
	function (hitElement)
		local positionId = getElementData(source, "performanceTuningPositionId")

		if positionId then
			if getElementType(hitElement) == "vehicle" then
				local driver = getVehicleController(hitElement)

				if driver then
					if getElementAlpha(source) ~= 0 then
						setElementAlpha(source, 0)

						local vehX, vehY, vehZ = getElementPosition(hitElement)

						setElementFrozen(hitElement, true)
						setElementPosition(hitElement, performacePositions[positionId][1], performacePositions[positionId][2], vehZ)
						setElementRotation(hitElement, 0, 0, performacePositions[positionId][4])

						triggerClientEvent(driver, "tooglePerformanceTuning", driver, true)
						setElementData(driver, "activeTuningMarker", source, false)
					end
				end
			end
		end
	end
)

addEventHandler("onMarkerHit", getResourceRootElement(),
	function (hitElement)
		local positionId = getElementData(source, "tuningPositionId")

		if positionId then
			if getElementType(hitElement) == "vehicle" then
				local driver = getVehicleController(hitElement)

				if driver then
					if getElementAlpha(source) ~= 0 then
						setElementAlpha(source, 0)

						local vehX, vehY, vehZ = getElementPosition(hitElement)

						setElementFrozen(hitElement, true)
						setElementPosition(hitElement, tuningPositions[positionId][1], tuningPositions[positionId][2], vehZ)
						setElementRotation(hitElement, 0, 0, tuningPositions[positionId][4])

						triggerClientEvent(driver, "toggleTuning", driver, true)
						setElementData(driver, "activeTuningMarker", source, false)
					end
				end
			end
		end
	end
)

addEvent("exitTuning", true)
addEventHandler("exitTuning", getRootElement(),
	function ()
		if isElement(source) then
			local tuningMarker = getElementData(source, "activeTuningMarker")

			if isElement(tuningMarker) then
				triggerClientEvent(source, "toggleTuning", source, false)
				setElementFrozen(getPedOccupiedVehicle(source), false)
				setElementAlpha(tuningMarker, 100)
			end
		end
	end
)


addEvent("setVehicleHandling", true)
addEventHandler("setVehicleHandling", getRootElement(),
	function (property, value)
		if isElement(source) then
			if property then
				local vehicle = getPedOccupiedVehicle(source)

				if isElement(vehicle) then
					setVehicleHandling(vehicle, property, value)
				end
			end
		end
	end
)

addEvent("previewVariant", true)
addEventHandler("previewVariant", getRootElement(),
	function (variant)
		if isElement(source) then
			if not variant then
				variant = getElementData(source, "vehicle.variant") or 0
			end

			if variant == 0 then
				setVehicleVariant(source, 255, 255)
			else
				setVehicleVariant(source, variant - 1, 255)
			end
		end
	end
)

function canTuneVehicle(vehicle, player, notice)
	local ownerId = getElementData(vehicle, "vehicle.owner") or 0
	local groupId = getElementData(vehicle, "vehicle.group") or 0

	if ownerId == 0 and groupId == 0 then
		return true
	end

	if ownerId > 0 then
		if ownerId == getElementData(player, "char.ID") then
			return true
		end
	end

	if groupId > 0 then
		if exports.sm_groups:isPlayerInGroup(player, groupId) then
			return true
		end
	end

	if notice then
		exports.sm_accounts:showInfo(player, "e", "Nem te vagy a jármű tulajdonosa!")
	end

	return false
end

addEvent("buyVariantTuning", true)
addEventHandler("buyVariantTuning", getRootElement(),
	function (variant, price)
		if client == source and variant and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")
				local currVariant = getElementData(vehicle, "vehicle.variant") or 0
				local buyState = "failed"

				if currVariant ~= variant then
					if exports.sm_core:takeMoneyEx(client, price, eventName) then
						if variant == 0 then
							setVehicleVariant(vehicle, 255, 255)
							buyState = "successdown"
						else
							setVehicleVariant(vehicle, variant - 1, 255)
							buyState = "success"
						end

						setElementData(vehicle, "vehicle.variant", variant)

						if vehicleId then
							dbExec(connection, "UPDATE vehicles SET variant = ? WHERE vehicleId = ?", variant, vehicleId)
						end
					else
						exports.sm_accounts:showInfo(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
					end
				else
					exports.sm_accounts:showInfo(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyVariant", client, buyState)
			end
		end
	end
)

addEvent("buySpinnerTuning", true)
addEventHandler("buySpinnerTuning", getRootElement(),
	function (value, r, g, b, sx, sy, sz, tinted, price)
		if client == source and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")
				local currSpinner = getElementData(vehicle, "tuningSpinners")
				local newSpinner = {}
				local buyState = "failed"

				if value then
					if tinted then
						newSpinner = {value, sx, sy, sz, r, g, b}
					else
						newSpinner = {value, sx, sy, sz}
					end
				else
					newSpinner = {}
				end

				if currSpinner ~= value then
					local currPP = getElementData(client, "acc.premiumPoints") or 0

					currPP = currPP - price

					if currPP >= 0 then
						setElementData(client, "acc.premiumPoints", currPP)

						if value then
							setElementData(vehicle, "tuningSpinners", newSpinner)
							buyState = "success"
						else
							setElementData(vehicle, "tuningSpinners", false)
							buyState = "successdown"
						end

						if vehicleId then
							dbExec(connection, "UPDATE vehicles SET tuningSpinners = ? WHERE vehicleId = ?", table.concat(newSpinner, ","), vehicleId)
						end
					else
						exports.sm_accounts:showInfo(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
					end
				else
					if value then
						exports.sm_accounts:showInfo(client, "e", "A kiválasztott elem már fel van szerelve!")
					else
						exports.sm_accounts:showInfo(client, "e", "Mégis mit akarsz leszerelni?")
					end
				end

				if value then
					triggerClientEvent(client, "buySpinner", client, buyState, newSpinner)
				else
					triggerClientEvent(client, "buySpinner", client, buyState, false)
				end
			end
		end
	end
)

addEvent("buyOpticalTuning", true)
addEventHandler("buyOpticalTuning", getRootElement(),
	function (slot, value, priceType, price)
		if client == source and slot and value and priceType and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")
				--print(value)
				local currUpgrade = getElementData(vehicle, slot)
				local buyState = "failed"

				if currUpgrade ~= slot .. value then
					if value == 0 and ownerId ~= charId then
						exports.sm_accounts:showInfo(client, "e", "Csak a jármű tulajdonosa szerelhet le alkatrészt!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
							else
								exports.sm_core:takeMoney(client, price, eventName)
							end

							--[[local currUpgrades = getElementData(vehicle, "vehicle.tuning.Optical") or ""
							local currUpgradesTable = split(currUpgrades, ",")
							local changed = false

							for k, upgrade in pairs(currUpgradesTable) do
								if getVehicleUpgradeSlotName(slot) == getVehicleUpgradeSlotName(upgrade) then
									currUpgradesTable[k] = value
									changed = true
								end
							end

							if not changed then
								currUpgrades = currUpgrades .. tostring(value) .. ","
							else
								currUpgrades = table.concat(currUpgradesTable, ",") .. ","
							end

							if value == 0 then
								removeVehicleUpgrade(vehicle, currUpgrade)
							else
								addVehicleUpgrade(vehicle, value)
							end]]

							local tempTuningTable = {}

							setElementData(vehicle, slot, slot .. value)

							setElementData(vehicle, slot .. "_num", value)

							for k, v in pairs(componentsFromData) do
								local tuningValue = getElementData(vehicle, k .. "_num")

								if tuningValue then
									tempTuningTable[k] = tuningValue
								end
							end

							iprint(tempTuningTable)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningOptical = ? WHERE vehicleId = ?", toJSON(tempTuningTable), vehicleId)
							end

							tempTuningTable = nil
						else
							if priceType == "premium" then
								exports.sm_accounts:showInfo(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.sm_accounts:showInfo(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.sm_accounts:showInfo(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyOpticalTuning", client, buyState, value)
			end
		end
	end
)

addEvent("buyPaintjob", true)
addEventHandler("buyPaintjob", getRootElement(),
	function (value, priceType, price)
		if source == client and value and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local currPaintjob = getElementData(vehicle, "vehicle.tuning.Paintjob") or 0
				local buyState = "failed"

				if currPaintjob ~= value then
					if value == 0 and ownerId ~= charId then
						exports.sm_accounts:showInfo(client, "e", "Csak a jármű tulajdonosa cserélhet paintjobot!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
							else
								exports.sm_core:takeMoney(client, price, eventName)
							end

							setElementData(vehicle, "vehicle.tuning.Paintjob", value)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningPaintjob = ? WHERE vehicleId = ?", value, vehicleId)
							end
						else
							if priceType == "premium" then
								exports.sm_accounts:showInfo(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.sm_accounts:showInfo(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.sm_accounts:showInfo(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyPaintjob", client, buyState, value)
			end
		end
	end
)

addEvent("buyWheelPaintjob", true)
addEventHandler("buyWheelPaintjob", getRootElement(),
	function (value, priceType, price)
		if source == client and value and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local currPaintjob = getElementData(vehicle, "vehicle.tuning.WheelPaintjob") or 0
				local buyState = "failed"

				if currPaintjob ~= value then
					if value == 0 and ownerId ~= charId then
						exports.sm_accounts:showInfo(client, "e", "Csak a jármű tulajdonosa cserélhet kerék paintjobot!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
							else
								exports.sm_core:takeMoney(client, price, eventName)
							end

							setElementData(vehicle, "vehicle.tuning.WheelPaintjob", value)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningWheelPaintjob = ? WHERE vehicleId = ?", value, vehicleId)
							end
						else
							if priceType == "premium" then
								exports.sm_accounts:showInfo(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.sm_accounts:showInfo(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.sm_accounts:showInfo(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyWheelPaintjob", client, buyState, value)
			end
		end
	end
)

addEvent("buyHeadLight", true)
addEventHandler("buyHeadLight", getRootElement(),
	function (value, priceType, price)
		if source == client and value and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local currPaintjob = getElementData(vehicle, "vehicle.tuning.HeadLight") or 0
				local buyState = "failed"

				if currPaintjob ~= value then
					if value == 0 and ownerId ~= charId then
						exports.sm_accounts:showInfo(client, "e", "Csak a jármű tulajdonosa cserélhet fényszórót!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
							else
								exports.sm_core:takeMoney(client, price, eventName)
							end

							setElementData(vehicle, "vehicle.tuning.HeadLight", value)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningHeadLight = ? WHERE vehicleId = ?", value, vehicleId)
							end
						else
							if priceType == "premium" then
								exports.sm_accounts:showInfo(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.sm_accounts:showInfo(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.sm_accounts:showInfo(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyHeadLight", client, buyState, value)
			end
		end
	end
)

addEvent("buyColor", true)
addEventHandler("buyColor", getRootElement(),
	function (colorId, vehicleColor, vehicleLightColor, priceType, price)
		if source == client and colorId and priceType and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local buyState = "failed"
				local currBalance = 0

				if ownerId ~= charId then
					exports.sm_accounts:showInfo(client, "e", "Csak a jármű tulajdonosa festheti át a járművet!")
				else
					if priceType == "premium" then
						currBalance = getElementData(client, "acc.premiumPoints") or 0
					else
						currBalance = getElementData(client, "char.Money") or 0
					end

					currBalance = currBalance - price

					if currBalance >= 0 then
						buyState = "success"

						if priceType == "premium" then
							setElementData(client, "acc.premiumPoints", currBalance)
						else
							exports.sm_core:takeMoney(client, price, eventName)
						end

						if colorId <= 4 then
							local color1 = convertRGBToHEX(vehicleColor[1], vehicleColor[2], vehicleColor[3])
							local color2 = convertRGBToHEX(vehicleColor[4], vehicleColor[5], vehicleColor[6])
							local color3 = convertRGBToHEX(vehicleColor[7], vehicleColor[8], vehicleColor[9])
							local color4 = convertRGBToHEX(vehicleColor[10], vehicleColor[11], vehicleColor[12])

							setVehicleColor(vehicle, vehicleColor[1], vehicleColor[2], vehicleColor[3], vehicleColor[4], vehicleColor[5], vehicleColor[6], vehicleColor[7], vehicleColor[8], vehicleColor[9], vehicleColor[10], vehicleColor[11], vehicleColor[12])

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET color1 = ?, color2 = ?, color3 = ?, color4 = ? WHERE vehicleId = ?", color1, color2, color3, color4, vehicleId)
							end
						elseif colorId == 5 then
							local headLightColor = convertRGBToHEX(vehicleLightColor[1], vehicleLightColor[2], vehicleLightColor[3])

							setVehicleHeadLightColor(vehicle, vehicleLightColor[1], vehicleLightColor[2], vehicleLightColor[3])

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET headLightColor = ? WHERE vehicleId = ?", headLightColor, vehicleId)
							end
						elseif colorId >= 7 then
							triggerClientEvent(client, "buySpeedoColor", vehicle, colorId)
							buyState = "speedo"
						end
					else
						if priceType == "premium" then
							exports.sm_accounts:showInfo(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
						else
							exports.sm_accounts:showInfo(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
						end
					end
				end

				triggerClientEvent(client, "buyColor", client, buyState, vehicleColor, vehicleLightColor)
			end
		end
	end
)

function convertRGBToHEX(r, g, b, a)
	if (r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) or (a and (a < 0 or a > 255)) then
		return nil
	end

	if a then
		return string.format("#%.2X%.2X%.2X%.2X", r, g, b, a)
	else
		return string.format("#%.2X%.2X%.2X", r, g, b)
	end
end

addEvent("buyLicensePlate", true)
addEventHandler("buyLicensePlate", getRootElement(),
	function (value, plateText, priceType, price)
		if source == client and value and plateText and priceType and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")
				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				dbQuery(
					function (qh, thePlayer)
						local result = dbPoll(qh, 0)[1]
						local buyState = "failed"

						if value == "custom" and result.plateState == 1 then
							exports.sm_accounts:showInfo(thePlayer, "e", "A kiválasztott rendszám foglalt, kérlek válassz másikat!")
						else
							local currBalance = 0

							if value == "default" and ownerId ~= charId then
								exports.sm_accounts:showInfo(thePlayer, "e", "Csak a jármű tulajdonosa cserélheti le a rendszámot!")
							else
								if priceType == "premium" then
									currBalance = getElementData(thePlayer, "acc.premiumPoints") or 0
								else
									currBalance = getElementData(thePlayer, "char.Money") or 0
								end

								currBalance = currBalance - price

								if currBalance >= 0 then
									buyState = "success"

									if priceType == "premium" then
										setElementData(thePlayer, "acc.premiumPoints", currBalance)
									else
										exports.sm_core:takeMoney(thePlayer, price, eventName)
									end

									if value == "default" then
										if vehicleId then
											plateText = exports.sm_vehicles:encodeDatabaseId(vehicleId)
										else
											plateText = ""
										end
									end

									setVehiclePlateText(vehicle, plateText)

									if vehicleId then
										dbExec(connection, "UPDATE vehicles SET plateText = ? WHERE vehicleId = ?", plateText, vehicleId)
									end
								else
									if priceType == "premium" then
										exports.sm_accounts:showInfo(thePlayer, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
									else
										exports.sm_accounts:showInfo(thePlayer, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
									end
								end
							end
						end

						triggerClientEvent(thePlayer, "buyLicensePlate", thePlayer, buyState, plateText)
					end,
				{client}, connection, "SELECT COUNT(1) AS plateState FROM vehicles WHERE plateText = ? LIMIT 1", plateText)
			end
		end
	end
)

addEvent("buyTuning", true)
addEventHandler("buyTuning", getRootElement(),
	function (selectedMenu, selectedSubMenu, selectionLevel, isTheOriginal)
		if source == client then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local activeMenu = tuningContainer[selectedMenu].subMenu[selectedSubMenu]
				local priceType = activeMenu.subMenu[selectionLevel].priceType
				local price = activeMenu.subMenu[selectionLevel].price
				local value = activeMenu.subMenu[selectionLevel].value

				local buyState = "failed"
				local currBalance = 0

				if priceType == "premium" then
					currBalance = getElementData(client, "acc.premiumPoints") or 0
				else
					currBalance = getElementData(client, "char.Money") or 0
				end

				currBalance = currBalance - price

				if currBalance >= 0 then
					if isTheOriginal then
						exports.sm_accounts:showInfo(client, "e", "A kiválasztott elem már fel van szerelve!")
					else
						buyState = "success"

						if priceType == "premium" then
							setElementData(client, "acc.premiumPoints", currBalance)
						else
							exports.sm_core:takeMoney(client, price)
						end

						if activeMenu.serverFunction then
							activeMenu.serverFunction(vehicle, value)
						end

						if selectedMenu == 1 and selectedSubMenu == 8 then
							if value == 0 then
								exports.sm_accounts:showInfo(client, "s", "Sikeresen kiürítetted a nitrós palackod.")
							else
								exports.sm_accounts:showInfo(client, "s", "Sikeresen megvásároltad a kiválasztott elemet!")
							end
						elseif selectedMenu == 2 and selectedSubMenu == 11 then
							if value == 0 then
								exports.sm_accounts:showInfo(client, "s", "Sikeresen leszerelted a neont.")
							else
								exports.sm_accounts:showInfo(client, "s", "Sikeresen megvásároltad a kiválasztott neont! ('u' betűvel kapcsolod ki és be)")
							end
						elseif activeMenu.id == "handling" then
							value = getVehicleHandling(vehicle)["handlingFlags"]
						end
					end
				else
					if priceType == "premium" then
						exports.sm_accounts:showInfo(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
					else
						exports.sm_accounts:showInfo(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
					end
				end

				triggerClientEvent(client, "buyTuning", client, buyState, activeMenu.id, value)
			end
		end
	end
)

	
fineBlock = {
	[1] = {
		{"engineAcceleration", "maxVelocity"},
		{20, 20}
	},

	[2] = {
		{"brakeBias", "brakeDeceleration"},
		{-10, 50}
	},

	[3] = {
		{nil, "engineAcceleration"},
		{10, 55}
	},

	[4] = {
		{"centerOfMass", "centerOfMass"},
		{-0.5, 0.5}
	},
}
	
function makeTuning(vehicle)
	local model = getElementModel(vehicle)
	local originalHandling = getOriginalHandling(model)
	local tuningEffects = {}
	local monitoredDatas = {
		["vehicle.tuning.Engine"] = true,
		["vehicle.tuning.Turbo"] = true,
		["vehicle.tuning.ECU"] = true,
		["vehicle.tuning.Transmission"] = true,
		["vehicle.tuning.Suspension"] = true,
		["vehicle.tuning.Brakes"] = true,
		["vehicle.tuning.Tires"] = true,
		["vehicle.tuning.WeightReduction"] = true
	}

	for dataName in pairs(monitoredDatas) do
		local dataValue = getElementData(vehicle, dataName) or 0

		if dataValue > 0 then
			tuningEffects[gettok(dataName, 3, ".")] = dataValue
		end
	end

	local properties = {} -- exceptions

	for tuningName, tuningValue in pairs(tuningEffects) do
		for property, values in pairs(tuningEffect[tuningName]) do
			properties[property] = true
		end
	end

	for property, value in pairs(originalHandling) do
		if properties[property] then
			setVehicleHandling(vehicle, property, value)
		end
	end

	applyHandling(vehicle, properties)

	local effects = {}

	for tuningName, tuningValue in pairs(tuningEffects) do
		for property, values in pairs(tuningEffect[tuningName]) do
			effects[property] = (effects[property] or 0) + (values[tuningValue] or 0)
		end
	end

	local currentHandling = getVehicleHandling(vehicle)

	local vehicleTempFineTuning = getElementData(vehicle, "vehicle.tunining.fine")

	if vehicleTempFineTuning then
		--print("asd")

		vehicleFineTuningList = fromJSON(vehicleTempFineTuning)

		for property, values in pairs(vehicleFineTuningList) do
			if values and values[1] and values[2] then
				local effectValue, effectLeftName, effectRightName = values[1], values[2], values[3]

				if effectLeftName == "engineAcceleration" and effectRightName == "maxVelocity" then
					--print("true")
					effects["engineAcceleration"] = (effects["engineAcceleration"] or 0) + (effectValue * -1) * fineBlock[1][2][2]
					
					-- jobb
					effects["maxVelocity"] = (effects["maxVelocity"] or 0) + effectValue * fineBlock[1][2][1]

					iprint(effects)
				end
			end
		end
	end

	for property, value in pairs(effects) do
		if property == "maxVelocity" then
			value = value / 1
		elseif property == "dragCoeff" then
			value = value / 100
		elseif property == "engineAcceleration" then
			value = value / 10
			--print(value)
		elseif property == "suspensionDamping" then
			value = value / 1000
		elseif property == "brakeDeceleration" then
			value = value / 15
		elseif property == "tractionLoss" then
			value = value / 375
		elseif property == "tractionMultiplier" then
			value = value / 250
		elseif property == "mass" then
			value = value * 15
		end

		setVehicleHandling(vehicle, property, tonumber(currentHandling[property]) + value)

		print(property .. " : " .. tonumber(currentHandling[property]) + value)
		if doubleExhaust[model] then
			setVehicleHandling(vehicle, "modelFlags", 0x00002000)
		end
	end
end

addEvent("setAirRide", true)
addEventHandler("setAirRide", getRootElement(),
	function (vehicle, level, players)
		if client == source and isElement(vehicle) and level then
			local originalLimit = getHandlingProperty(vehicle, "suspensionLowerLimit")
			local newLimit = originalLimit + (level - 8) * 0.0175

			setVehicleHandling(vehicle, "suspensionLowerLimit", newLimit)
			setElementData(vehicle, "airRideLevel", level)

			local x, y, z = getElementPosition(vehicle)

			setElementPosition(vehicle, x, y, z + 0.01)
			setElementPosition(vehicle, x, y, z)

			triggerClientEvent(players or getElementsByType("player"), "playAirRideSound", source, vehicle)
		end
	end
)

addEvent("setDriveType", true)
addEventHandler("setDriveType", getRootElement(),
	function (driveType)
		if driveType and isElement(source) then
			setElementData(source, "activeDriveType", driveType)
			makeTuning(source)
		end
	end
)

addCommandHandler("tuningveh",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 9 then
			local currentVeh = getPedOccupiedVehicle(sourcePlayer)

			if currentVeh then
				setElementData(currentVeh, "vehicle.tuning.Engine", 4)
				setElementData(currentVeh, "vehicle.tuning.Turbo", 4)
				setElementData(currentVeh, "vehicle.tuning.ECU", 4)
				setElementData(currentVeh, "vehicle.tuning.Transmission", 4)
				setElementData(currentVeh, "vehicle.tuning.Suspension", 4)
				setElementData(currentVeh, "vehicle.tuning.Brakes", 4)
				setElementData(currentVeh, "vehicle.tuning.Tires", 4)
				setElementData(currentVeh, "vehicle.tuning.WeightReduction", 4)
				makeTuning(currentVeh)
				outputChatBox("Jármű kifullozva.", sourcePlayer)
			end
		end
	end
)

addEvent("makeTuningEvent", true)
addEventHandler("makeTuningEvent", getRootElement(),
	function()
		if isElement(source) then
			makeTuning(source)
		end
	end
)

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function setElementSpeed(element, unit, speed)
    local unit    = unit or 0
    local speed   = tonumber(speed) or 0
    local acSpeed = getElementSpeed(element, unit)
    if acSpeed and acSpeed~=0 then -- if true - element is valid, no need to check again
        local diff = speed/acSpeed
        if diff ~= diff then return false end -- if the number is a 'NaN' return false.
        local x, y, z = getElementVelocity(element)
        return setElementVelocity(element, x*diff, y*diff, z*diff)
    end
    return false
end