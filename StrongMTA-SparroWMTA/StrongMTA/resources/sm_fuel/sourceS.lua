local fuelPrices = {}

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		math.randomseed(getTickCount() + math.random(getTickCount()))

		for k, v in pairs(availableStations) do
			v.syncColShape.element = createColSphere(unpack(v.syncColShape.details))

			if isElement(v.syncColShape.element) then
				setElementData(v.syncColShape.element, "syncStationId", k)
			end
		end

		generatePrices()
		setTimer(generatePrices, 600000, 0)
	end)

function generatePrices()
	fuelPrices = {}

	for k, v in pairs(availableStations) do
		fuelPrices[k] = math.random(5, 40)
	end

	setElementData(resourceRoot, "fuelPrices", fuelPrices)
end

addEvent("useCanister", true)
addEventHandler("useCanister", getRootElement(),
	function (vehicle)
		if isElement(source) then
			exports.sm_items:takeItem(source, "dbID", getElementData(source, "canisterInHand"))

			setElementFrozen(source, true)
			exports.sm_controls:toggleControl(source, {"all"}, false)
			setPedAnimation(source, "CASINO", "cards_win")

			setTimer(
				function (thePlayer)
					if isElement(thePlayer) then
						setPedAnimation(thePlayer, "SWORD", "sword_IDLE")

						setTimer(
							function (thePlayer)
								if isElement(thePlayer) then
									setElementFrozen(thePlayer, false)
									exports.sm_controls:toggleControl(thePlayer, {"all"}, true)

									setPedAnimation(thePlayer, false)
									removeElementData(thePlayer, "canisterInHand")
								end
							end,
						10000, 1, thePlayer)
					end
				end,
			2400, 1, source)

			local fuelLevel = getElementData(vehicle, "vehicle.fuel") or 0

			fuelLevel = fuelLevel + 25

			if fuelLevel > 100 then
				fuelLevel = 100
			end

			setElementData(vehicle, "vehicle.fuel", fuelLevel)
		end
	end)

addEvent("payFuel", true)
addEventHandler("payFuel", getRootElement(),
	function (stationId, positionId, buyPrice)
		if isElement(source) then
			if exports.sm_core:takeMoneyEx(source, buyPrice, "payFuel") then
				triggerClientEvent(getElementsByType("player"), "payFuel", source, true)

				setElementData(resourceRoot, "fuelStation_" .. stationId .. "_" .. positionId, false)
				
				triggerClientEvent(getElementsByType("player"), "resetFuelStation", resourceRoot, stationId, positionId)
			else
				triggerClientEvent(getElementsByType("player"), "payFuel", source, false)
			end
		end
	end)

addEvent("requestPumpPistol", true)
addEventHandler("requestPumpPistol", getRootElement(),
	function (stationId, positionId)
		if isElement(source)then
			local pistolHolder = getElementData(source, "pistolHolder") or {}

			if pistolHolder[1] and pistolHolder[2] then
				setElementData(source, "pistolHolder", false)
				triggerClientEvent(getElementsByType("player"), "resetFuelStation", resourceRoot, stationId, positionId)
			else
				setElementData(source, "fuelStation", {stationId, positionId})
				setElementData(source, "pistolHolder", {stationId, positionId})
			end
		end
	end)

addEvent("resetPumpPistol", true)
addEventHandler("resetPumpPistol", getRootElement(),
	function (stationId, positionId)
		if isElement(source) then
			setElementData(source, "pistolHolder", false)
			triggerClientEvent(getElementsByType("player"), "resetFuelStation", resourceRoot, stationId, positionId)
		end
	end)

addEvent("startFuelingProcess", true)
addEventHandler("startFuelingProcess", getRootElement(),
	function (stationId)
		if isElement(source) then
			local players = getElementsWithinColShape(availableStations[stationId].syncColShape.element, "player")
			
			triggerClientEvent(players, "startFuelingProcess", source, station)
		end
	end)

addEvent("doFuelingProcess", true)
addEventHandler("doFuelingProcess", getRootElement(),
	function (startFill, stationId, positionId, vehicleElement, endFill, isDead)
		if isElement(source) then
			local players = getElementsWithinColShape(availableStations[stationId].syncColShape.element, "player")

			triggerClientEvent(players, "doFuelingProcess", source, startFill, stationId, positionId, vehicleElement, endFill)

			if isDead then
				setElementData(resourceRoot, "fuelStation_" .. stationId .. "_" .. positionId, false)
				triggerClientEvent(getElementsByType("player"), "resetFuelStation", resourceRoot, stationId, positionId)
			end
		end
	end)