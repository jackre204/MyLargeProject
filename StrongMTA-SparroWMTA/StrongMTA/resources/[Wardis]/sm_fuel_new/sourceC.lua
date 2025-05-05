pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local debugMode = false

local cornerX, cornerY = 0, 0
local pointX, pointY = 0, 0

addCommandHandler("rect1",
	function()
		cornerX, cornerY = getElementPosition(localPlayer)
	end
)

addCommandHandler("rect2",
	function()
		pointX, pointY = getElementPosition(localPlayer)

		local minX = math.min(cornerX, pointX)
		local minY = math.min(cornerY, pointY)
		local maxX = math.max(cornerX, pointX)
		local maxY = math.max(cornerY, pointY)

		outputChatBox(minX .. ", " .. minY .. ", " .. maxX - minX .. ", " .. maxY - minY)
	end
)

local screenX, screenY = guiGetScreenSize()

local activeSyncedStation = false
local activeStation = false
local activePump = false

local fuelTankSize = {}
local vehicleFuelLeft = {}
local vehiclesFuelStartedAmount = {}
local vehicleAddFuel = {}

local lcdRTSize = 128

local circleTexture = dxCreateTexture("files/images/circle.png")
local windowGlassTexture = dxCreateTexture("files/images/glass.png")

local requestPistolTick = 0
local pistolTaken = false
local havePistol = false
local lastPistolData = false
local hitDetectCount = 0

local interactionTable = {}

local hoverVehicle = false
local selectedVehicle = false

local fillTimer = false

local counterSpeed = 0.75

local haveCanister = false

local lastPressTick = 0

function loadFonts()
	local fonts = {
		Raleway = exports.sm_core:loadFont("Raleway.ttf", 13, false, "antialiased"),
		CounterFont = exports.sm_core:loadFont("counter2.ttf", 45 * (lcdRTSize / 400), false, "antialiased"),
		CounterPriceFont = exports.sm_core:loadFont("counter.ttf", 24, false, "antialiased"),
		CounterPriceFont2 = exports.sm_core:loadFont("counter2.ttf", 24, false, "antialiased"),
		ThermalPrinter = exports.sm_core:loadFont("ThermalPrinter.ttf", 18, false, "antialiased")
	}

	for k,v in pairs(fonts) do
		_G[k] = v
		_G[k .. "H"] = dxGetFontHeight(1, _G[k])
	end
end

addEventHandler("onAssetsLoaded", getRootElement(),
	function ()
		loadFonts()
	end
)

function getNormalFromCoords(x1, y1, x2, y2)
	local x = x2 - x1
	local y = y2 - y1
	local len = math.sqrt(x * x + y * y)

	if len ~= 0 and len ~= 1 then
		x = x / len
		y = y / len
	end

	return x, y
end

function setPolygonsHeight()
	for i, v in ipairs (getElementsByType ("colshape")) do
		if (getColShapeType (v) == 4) then -- if it's a polygon colshape do it otherwise don't
			setColPolygonHeight (v, false, 50)
		end
	end
end

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedResource)
		if getResourceName(startedResource) == "sm_vehiclepanel" then
			fuelTankSize = exports.sm_vehiclepanel:getTheFuelTankTable()
		elseif source == getResourceRootElement() then
			local sm_vehiclepanel = getResourceFromName("sm_vehiclepanel")

			if sm_vehiclepanel and getResourceState(sm_vehiclepanel) == "running" then
				fuelTankSize = exports.sm_vehiclepanel:getTheFuelTankTable()
			end

			loadFonts()

			for k, v in ipairs(availableStations) do


				v.pedDetails.element = createPed(v.pedDetails.skin, v.pedDetails.position[1], v.pedDetails.position[2], v.pedDetails.position[3], v.pedDetails.rotation)

				if isElement(v.pedDetails.element) then
					setElementFrozen(v.pedDetails.element, true)
					setElementInterior(v.pedDetails.element, v.pedDetails.interior)
					setElementDimension(v.pedDetails.element, v.pedDetails.dimension)

					setElementData(v.pedDetails.element, "stationId", k)
					setElementData(v.pedDetails.element, "visibleName", v.pedDetails.name)
					setElementData(v.pedDetails.element, "pedNameType", "Benzinkút")
					setElementData(v.pedDetails.element, "invulnerable", true)
				end

				if k <= 2 then
					v.outerColShape.element = createColRectangle(unpack(v.outerColShape.details))
					v.innerColShape.element = createColRectangle(unpack(v.innerColShape.details))
				elseif k == 3 or k == 4 then
					v.outerColShape.element = createColSphere(unpack(v.outerColShape.details))
					v.innerColShape.element = createColSphere(unpack(v.innerColShape.details))
				else
					v.outerColShape.element = createColPolygon(unpack(v.outerColShape.details))
					v.innerColShape.element = createColPolygon(unpack(v.innerColShape.details))
				end


				if isElement(v.outerColShape.element) then
					setElementData(v.outerColShape.element, "outerStationId", k)
				end

				if isElement(v.innerColShape.element) then
					setElementData(v.innerColShape.element, "innerStationId", k)
				end

				for k2, v2 in ipairs(v.fuelPositions) do
					if not v2.pistolObjects then
						v2.pistolObjects = {}
					end

					for i = 1, #v2.pistolDetails do
						v2.pistolObjects[i] = createObject(unpack(v2.pistolDetails[i]))
					end

					v2.pistolColShape = createColSphere(unpack(v2.colShapeDetails))

					if isElement(v2.pistolColShape) then
						setElementData(v2.pistolColShape, "stationId", k)
						setElementData(v2.pistolColShape, "positionId", k2)
					end

					v2.currentAmount = 0
					v2.currentFuelAmount = 0
					v2.activeFuelType = 1
				end
			end

			if getElementData(localPlayer, "loggedIn") then
				initFuelSystem()
			end

			setElementData(localPlayer, "fuelStation", false)
			setElementData(localPlayer, "pistolHolder", false)
		end

		setPolygonsHeight()
		setElementData(localPlayer, "trashFuelTank", false)
	end
)

function initFuelSystem()
	for k, v in ipairs(availableStations) do
		v.fuelPrice = getElementData(resourceRoot, "fuelPrices")[k]

		for k2, v2 in ipairs(v.fuelPositions) do
			if k and k2 then
				v2.pistolHolder = {}

				local fuelStationData = getElementData(resourceRoot, "fuelStation_" .. k .. "_" .. k2) or {}

				v2.currentAmount = fuelStationData[1] or 0
				v2.currentFuelAmount = fuelStationData[2] or 0

				if v2.currentAmount == 0 then
					if isElement(v2.effectElement) then
						destroyElement(v2.effectElement)
						v2.effectElement = nil
					end

					if isElement(v2.soundElement) then
						destroyElement(v2.soundElement)
						v2.soundElement = nil
					end
				end
			end
		end
	end

	for k, v in ipairs(getElementsByType("player")) do
		local pistolHolder = getElementData(v, "pistolHolder")

		if pistolHolder then
			local stationId = pistolHolder[1]
			local positionId = pistolHolder[2]
			local fuelType = pistolHolder[3]

			if availableStations[stationId] then
				local fuelPos = availableStations[stationId].fuelPositions[positionId]

				if fuelPos then
					fuelPos.pistolHolder[fuelType] = v
					fuelPos.activeFuelType = fuelType

					if fuelPos.pistolObjects[fuelType] then
						exports.sm_boneattach:attachElementToBone(fuelPos.pistolObjects[fuelType], v, 12, 0.05, 0.05, 0.05, 180, 0, 0)

						if v == localPlayer then
							exports.sm_controls:toggleControl({"fire", "enter_exit", "aim_weapon"}, false)

							havePistol = pistolHolder
							pistolTaken = false
							hitDetectCount = 0
						end
					end
				end
			end
		end
	end
end

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == getResourceRootElement() then
			if dataName == "fuelPrices" then
				local fuelPrices = getElementData(source, "fuelPrices") or {}

				for k, v in pairs(fuelPrices) do
					availableStations[k].fuelPrice = v
				end

				generatePriceTable()
			elseif string.find(dataName, "fuelStation_") then
				local selected = split(dataName:gsub("fuelStation_", ""), "_")
				local stationId = tonumber(selected[1])
				local pumpId = tonumber(selected[2])
				local fuelStationData = getElementData(source, dataName) or {}

				if availableStations[stationId] then
					local fuelPos = availableStations[stationId].fuelPositions[pumpId]

					if fuelPos then
						fuelPos.currentAmount = fuelStationData[1] or 0
						fuelPos.currentFuelAmount = fuelStationData[2] or 0

						if fuelPos.currentAmount == 0 then
							if isElement(fuelPos.effectElement) then
								destroyElement(fuelPos.effectElement)
								fuelPos.effectElement = nil
							end

							if isElement(fuelPos.soundElement) then
								destroyElement(fuelPos.soundElement)
								fuelPos.soundElement = nil
							end
						end
					end
				end
			end
		elseif dataName == "pistolHolder" then
			local pistolHolder = getElementData(source, "pistolHolder")

			if pistolHolder then
				local stationId = pistolHolder[1]
				local positionId = pistolHolder[2]
				local fuelType = pistolHolder[3]

				if availableStations[stationId] then
					local fuelPos = availableStations[stationId].fuelPositions[positionId]

					if fuelPos then
						fuelPos.pistolHolder[fuelType] = source
						fuelPos.activeFuelType = fuelType

						if fuelPos.pistolObjects[fuelType] then
							exports.sm_boneattach:attachElementToBone(fuelPos.pistolObjects[fuelType], source, 12, 0.05, 0.05, 0.05, 180, 0, 0)

							if source == localPlayer then
								exports.sm_controls:toggleControl({"fire", "enter_exit", "aim_weapon"}, false)
								havePistol = pistolHolder
								pistolTaken = false
								hitDetectCount = 0
							end
						end
					end
				end
			elseif oldValue then
				local stationId = oldValue[1]
				local positionId = oldValue[2]
				local fuelType = oldValue[3]

				if availableStations[stationId] then
					local fuelPos = availableStations[stationId].fuelPositions[positionId]

					if fuelPos then
						fuelPos.pistolHolder = {}

						if isElement(fuelPos.effectElement) then
							destroyElement(fuelPos.effectElement)
						end

						if isElement(fuelPos.soundElement) then
							destroyElement(fuelPos.soundElement)
						end

						fuelPos.effectElement = nil
						fuelPos.soundElement = nil

						if fuelPos.pistolObjects[fuelType] then
							exports.sm_boneattach:detachElementFromBone(fuelPos.pistolObjects[fuelType])

							setElementPosition(fuelPos.pistolObjects[fuelType], fuelPos.pistolDetails[fuelType][2], fuelPos.pistolDetails[fuelType][3], fuelPos.pistolDetails[fuelType][4])
							setElementRotation(fuelPos.pistolObjects[fuelType], fuelPos.pistolDetails[fuelType][5], fuelPos.pistolDetails[fuelType][6], fuelPos.pistolDetails[fuelType][7])

							if source == localPlayer then
								exports.sm_controls:toggleControl({"fire", "enter_exit", "aim_weapon"}, true)
								lastPistolData = havePistol
								havePistol = false
							end
						end
					end
				end
			end

			if pistolHolder or oldValue then
				local playerPosX, playerPosY, playerPosZ = getElementPosition(source)

				playSound3D("files/sounds/pickup.mp3", playerPosX, playerPosY, playerPosZ)
			end
		elseif dataName == "loggedIn" and source == localPlayer then
			initFuelSystem()
		end
	end
)

addEvent("requestPumpPistol", true)
addEventHandler("requestPumpPistol", getRootElement(),
	function (sourceElement, selectedType)
		if activePump then
			local stationId = activePump[1]
			local positionId = activePump[2]

			if stationId and positionId then
				local pistolHolder = getElementData(localPlayer, "pistolHolder")

				if pistolHolder then
					if pistolHolder[1] ~= stationId or pistolHolder[2] ~= positionId then
						exports.sm_hud:showAlert("error", "Ezt a kutat jelenleg nem használhatod!")
						return
					end

					if availableStations[pistolHolder[1]].fuelPositions[pistolHolder[2]].fillingStarted then
						return
					end
				end

				if getTickCount() >= requestPistolTick + 1000 then
					triggerServerEvent("requestPumpPistol", localPlayer, stationId, positionId, selectedType)
					destroyStationPanel()
					requestPistolTick = getTickCount()
				end
			end
		end
	end
)

addEvent("resetPumpPistol", true)
addEventHandler("resetPumpPistol", getRootElement(),
	function (sourceElement)
		if activePump then
			local stationId = activePump[1]
			local positionId = activePump[2]

			if stationId and positionId then
				if getTickCount() >= requestPistolTick + 1000 then
					triggerServerEvent("resetPumpPistol", localPlayer)

					requestPistolTick = getTickCount()
				end
			end
		end
	end
)

function generatePriceTable()
	if activeSyncedStation and isElement(availableStations[activeSyncedStation].priceTable.renderTarget) then
		dxSetRenderTarget(availableStations[activeSyncedStation].priceTable.renderTarget)

		dxDrawImage(0, 0, 256, 256, "files/images/prices_uv.png")

		local fuelPrices = availableStations[activeSyncedStation].fuelPrice

		if not fuelPrices then
			fuelPrices = getElementData(resourceRoot, "fuelPrices")[activeSyncedStation]
		end

		local regular = fuelPrices[2]
		local diesel = fuelPrices[1]

		dxDrawText("$", 143, 121, 143 + 84, 121 + 35, tocolor(255, 240, 10, 225), 1, CounterPriceFont2, "right", "center")
		dxDrawText("$", 143, 189, 143 + 84, 189 + 35, tocolor(255, 240, 10, 225), 1, CounterPriceFont2, "right", "center")

		for i = 0, 1 do
			local x = 30 * i

			dxDrawText("8", 150 + x, 121, 150 + 64 + x, 121 + 40, tocolor(0, 0, 0, 150), 1, CounterPriceFont, "left", "center")
			
			local j = 2 - i
			if j <= utf8.len(regular) then
				dxDrawText(utf8.sub(regular, -1 * j, -1 * j), 150 + x, 121, 150 + 64 + x, 121 + 40, tocolor(255, 240, 10, 225), 1, CounterPriceFont, "left", "center")
			end

			dxDrawText("8", 150 + x, 189, 150 + 64 + x, 189 + 40, tocolor(0, 0, 0, 150), 1, CounterPriceFont, "left", "center")
			
			local j = 2 - i
			if j <= utf8.len(diesel) then
				dxDrawText(utf8.sub(diesel, -1 * j, -1 * j), 150 + x, 189, 150 + 64 + x, 189 + 40, tocolor(255, 240, 10, 225), 1, CounterPriceFont, "left", "center")
			end
		end

		dxSetRenderTarget()

		return true
	end

	return false
end
addEventHandler("onClientRestore", getRootElement(), generatePriceTable)

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (sourceElement)
		if sourceElement == localPlayer then
			local syncStationId = getElementData(source, "syncStationId")

			if syncStationId then
				activeSyncedStation = syncStationId

				addEventHandler("onClientRender", getRootElement(), onClientRender)

				local priceTable = availableStations[syncStationId].priceTable

				if priceTable then
					--priceTable.element = createObject(unpack(priceTable.details))

					if isElement(priceTable.element) then
						priceTable.renderTarget = dxCreateRenderTarget(256, 256)
						priceTable.shaderElement = dxCreateShader("files/texturechanger.fx")

						if priceTable.shaderElement and generatePriceTable() then
							dxSetShaderValue(priceTable.shaderElement, "gTexture", priceTable.renderTarget)
							engineApplyShaderToWorldTexture(priceTable.shaderElement, "prices_uv", priceTable.element)
						end
					end
				end

				for k, v in ipairs(availableStations[syncStationId].fuelPositions) do
					v.renderTarget = dxCreateRenderTarget(lcdRTSize, lcdRTSize, true)
				end
			end

			local outerStationId = getElementData(source, "outerStationId")

			if outerStationId then
				activeStation = outerStationId
			end

			local stationId = getElementData(source, "stationId")
			local positionId = getElementData(source, "positionId")

			if not activePump and stationId and positionId then
				activePump = {stationId, positionId}
				interactionTable = {}
			end

			if stationId and positionId then
				if activePump then
					local pistolHolder = getElementData(localPlayer, "pistolHolder")
					local interactive = true

					if pistolHolder then
						if pistolHolder[1] ~= stationId or pistolHolder[2] ~= positionId then
							interactive = false
						end
					end

					if positionId % 2 == 0 then
						positionId = positionId - 1
					end

					setElementData(availableStations[stationId].fuelPositions[positionId].element, "isInteractable", interactive, false)
					setElementData(availableStations[stationId].fuelPositions[positionId].element, "object.name", "Töltőállomás", false)

					if interactive then
						addEventHandler("onClientClick", getRootElement(), onClientClick, true, "high-9999")
					end
				end
			end
		end
	end
)

vehicleFuelType = {
	[402] = 1
}

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (sourceElement)
		if sourceElement == localPlayer then
			local syncStationId = getElementData(source, "syncStationId")

			if syncStationId and activeSyncedStation then
				removeEventHandler("onClientRender", getRootElement(), onClientRender)

				activeSyncedStation = false

				for k, v in ipairs(availableStations[syncStationId].fuelPositions) do
					if isElement(v.renderTarget) then
						destroyElement(v.renderTarget)
					end

					v.fillingStarted = nil
					v.renderTarget = nil
				end

				if isElement(availableStations[syncStationId].priceTable.element) then
					destroyElement(availableStations[syncStationId].priceTable.element)
					availableStations[syncStationId].priceTable.element = nil
				end

				if isElement(availableStations[syncStationId].priceTable.renderTarget) then
					destroyElement(availableStations[syncStationId].priceTable.renderTarget)
					availableStations[syncStationId].priceTable.renderTarget = nil
				end

				if isElement(availableStations[syncStationId].priceTable.shaderElement) then
					destroyElement(availableStations[syncStationId].priceTable.shaderElement)
					availableStations[syncStationId].priceTable.shaderElement = nil
				end
			end

			if getElementData(source, "outerStationId") then
				local fuelStation = getElementData(localPlayer, "fuelStation")
				
				if fuelStation then
					local fuelStationData = getElementData(resourceRoot, "fuelStation_" .. fuelStation[1] .. "_" .. fuelStation[2]) or {0, 0}

					setElementData(resourceRoot, "fuelStation_" .. fuelStation[1] .. "_" .. fuelStation[2], {0, 0})
					setElementData(localPlayer, "fuelStation", false)
					setElementData(localPlayer, "pistolHolder", false)

					local occupiedVehicle = getPedOccupiedVehicle(localPlayer)

					if occupiedVehicle then
						triggerServerEvent("reportFuelStealing", localPlayer, occupiedVehicle, fuelStationData[1], fuelStationData[2])
					end
				end

				activeStation = false
			end

			if activePump then
				local stationId = activePump[1]
				local positionId = activePump[2]

				if positionId % 2 == 0 then
					positionId = positionId - 1
				end

				setElementData(availableStations[stationId].fuelPositions[positionId].element, "isInteractable", false, false)
			end

			activePump = false

			removeEventHandler("onClientClick", getRootElement(), onClientClick)
		end
	end
)

addEventHandler("onClientElementStreamIn", localPlayer,
	function ()
		if activeStation then
			local fuelStation = getElementData(localPlayer, "fuelStation")
			
			if fuelStation then
				local fuelStationData = getElementData(resourceRoot, "fuelStation_" .. fuelStation[1] .. "_" .. fuelStation[2]) or {0, 0}

				setElementData(resourceRoot, "fuelStation_" .. fuelStation[1] .. "_" .. fuelStation[2], {0, 0})
				setElementData(localPlayer, "fuelStation", false)
				setElementData(localPlayer, "pistolHolder", false)

				local occupiedVehicle = getPedOccupiedVehicle(localPlayer)

				if occupiedVehicle then
					triggerServerEvent("reportFuelStealing", localPlayer, occupiedVehicle, fuelStationData[1], fuelStationData[2])
				end
			end

			activeStation = false
		end
	end
)

addEventHandler("onClientPlayerWasted", getRootElement(),
	function()
		if source == localPlayer then
			selectedVehicle = false
			pistolTaken = false

			if isTimer(fillTimer) then
				killTimer(fillTimer)
			end

			fillTimer = nil
		end
	end
)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if activeStation then
			if key == "mouse1" and havePistol and not activePump then
				if not press or getTickCount() - lastPressTick >= 1000 then
					if not press and not havePistol then
						return
					end

					cancelEvent()
					if press and hoverVehicle then
						if getElementData(hoverVehicle, "vehicle.engine") == 1 then
							exports.sm_hud:showAlert("error", "A jármű motorja jár!")
							return
						end

						if not vehicleFuelLeft[hoverVehicle] then
							vehicleFuelLeft[hoverVehicle] = getElementData(hoverVehicle, "vehicle.fuel") or 0
						end

						if not vehicleAddFuel[hoverVehicle] then
							vehicleAddFuel[hoverVehicle] = 0
						end

						if vehicleFuelLeft[hoverVehicle] + vehicleAddFuel[hoverVehicle] >= (fuelTankSize[getElementModel(hoverVehicle)] or 50) then
							exports.sm_hud:showAlert("error", "A jármű tankja tele van!")
							return
						end
					end

					if press then
						if hoverVehicle then
							triggerServerEvent("startFuelingProcess", localPlayer, activeStation)

							fillTimer = setTimer(
								function()
									triggerServerEvent("doFuelingProcess", localPlayer, activeStation, havePistol[1], havePistol[2], hoverVehicle)

									if vehicleFuelType[getElementModel] ~= havePistol[3] then
										setElementData(localPlayer, "trashFuelTank", true)
									end
								end,
							2400, 1)
						else
							triggerServerEvent("doFuelingProcess", localPlayer, press, havePistol[1], havePistol[2], hoverVehicle)
						end
					else
						if isTimer(fillTimer) then
							killTimer(fillTimer)
						end

						triggerServerEvent("doFuelingProcess", localPlayer, press, havePistol[1], havePistol[2], selectedVehicle)
					end

					lastPressTick = getTickCount()
				else
					cancelEvent()
					exports.sm_hud:showAlert("error", "Ne ilyen gyorsan!")
				end
			end
		end
	end
)

addEvent("startFuelingProcess", true)
addEventHandler("startFuelingProcess", getRootElement(),
	function ()
		if isElement(source) then
			setPedAnimation(source, "CASINO", "cards_win")
			playSound3D("files/sounds/start.mp3", getElementPosition(source))

			if source == localPlayer then
				pickupAnim = true
			end
		end
	end
)

addEvent("doFuelingProcess", true)
addEventHandler("doFuelingProcess", getRootElement(),
	function (startFill, stationId, positionId, vehicleElement, endFill)
		if isElement(source) and stationId and positionId then
			local playerPosX, playerPosY, playerPosZ = getElementPosition(source)

			if endFill then
				playSound3D("files/sounds/full.mp3", playerPosX, playerPosY, playerPosZ)
			end

			local fuelPos = availableStations[stationId].fuelPositions[positionId]

			if fuelPos then
				if isElement(fuelPos.effectElement) then
					destroyElement(fuelPos.effectElement)
				end

				if isElement(fuelPos.soundElement) then
					destroyElement(fuelPos.soundElement)
				end

				fuelPos.effectElement = nil
				fuelPos.soundElement = nil

				local pistolId = fuelPos.activeFuelType

				if startFill then
					setPedAnimation(source, "SWORD", "sword_IDLE")

					pickupAnim = false

					if not vehicleElement then
						local pistolPosX, pistolPosY, pistolPosZ = getElementPosition(fuelPos.pistolObjects[pistolId])
						local pistolRotX, pistolRotY, pistolRotZ = getElementRotation(fuelPos.pistolObjects[pistolId])

						local angle = math.rad(pistolRotZ + 90)
						local rotatedX = -math.sin(angle) * 0.3
						local rotatedY = math.cos(angle) * 0.3

						fuelPos.effectElement = createEffect("petrolcan", pistolPosX + rotatedX, pistolPosY + rotatedY, pistolPosZ, 120, 0, -pistolRotZ - 90)

	        			setEffectDensity(fuelPos.effectElement, 2)
					end

					fuelPos.soundElement = playSound3D("files/sounds/fill.mp3", playerPosX, playerPosY, playerPosZ, true)

					if source == localPlayer then
						selectedVehicle = vehicleElement
					end
				else
					if vehicleElement then
						setPedAnimation(source, "CASINO", "cards_win")

						playSound3D("files/sounds/over.mp3", playerPosX, playerPosY, playerPosZ)

						setTimer(
							function(sourceElement)
								setPedAnimation(sourceElement)

								pickupAnim = false
								selectedVehicle = false
							end,
						2400, 1, source)
					else
						setPedAnimation(source)
						pickupAnim = false
					end

					if isElement(fuelPos.effectElement) then
						destroyElement(fuelPos.effectElement)
					end

					if isElement(fuelPos.soundElement) then
						destroyElement(fuelPos.soundElement)
					end

					fuelPos.effectElement = nil
					fuelPos.soundElement = nil
				end

				fuelPos.fillingStarted = startFill

				if fuelPos.fillingStarted then
					fuelPos.fillingStarted = getTickCount()
					fuelPos.galStarted = fuelPos.currentAmount
					fuelPos.fuelStarted = fuelPos.currentFuelAmount

					for k, v in pairs(vehicleAddFuel) do
						vehiclesFuelStartedAmount[k] = v
					end
				elseif source == localPlayer then
					setElementData(resourceRoot, "fuelStation_" .. stationId .. "_" .. positionId, {fuelPos.currentAmount, fuelPos.currentFuelAmount})
				end
			end
		end
	end
)

addEvent("resetFuelStation", true)
addEventHandler("resetFuelStation", getRootElement(),
	function (stationId, positionId)
		if stationId and positionId then
			local fuelPos = availableStations[stationId].fuelPositions[positionId]

			if fuelPos then
				if isElement(fuelPos.effectElement) then
					destroyElement(fuelPos.effectElement)
				end

				if isElement(fuelPos.soundElement) then
					destroyElement(fuelPos.soundElement)
				end

				fuelPos.effectElement = nil
				fuelPos.soundElement = nil
				fuelPos.fillingStarted = nil
				fuelPos.galStarted = nil
				fuelPos.fuelStarted = nil
			end
		end
	end
)

addEvent("payFuel", true)
addEventHandler("payFuel", getRootElement(),
	function (success)
		if not success then
			exports.sm_hud:showAlert("error", "Nincs nálad elég pénz!")
		else
			for vehicleElement, tankedAmount in pairs(vehicleAddFuel) do
				if tonumber(tankedAmount) then
					local currentAmount = getElementData(vehicleElement, "vehicle.fuel") or 0

					currentAmount = currentAmount + tankedAmount

					if currentAmount >= (fuelTankSize[getElementModel(vehicleElement)] or 50) then
						currentAmount = fuelTankSize[getElementModel(vehicleElement)] or 50
					end

					setElementData(vehicleElement, "vehicle.fuel", math.floor(currentAmount * 10) / 10)

					if getElementData(localPlayer, "trashFuelTank") then
						setElementData(vehicleElement, "vehicle.wrongFuel", true)
					end
				end
			end

			vehicleAddFuel = {}

			exports.sm_hud:showAlert("success", "A tankolt üzemanyag sikeresen kifizetve.")
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, _, _, worldX, worldY, worldZ, clickedWorld)
		if clickedWorld and getElementType(clickedWorld) == "ped" and state == "down" and not showReciept and getElementData(clickedWorld, "stationId") and inDistance3D(clickedWorld, localPlayer, 2) then
			if lastPistolData and availableStations[lastPistolData[1]].fuelPositions[lastPistolData[2]].currentAmount > 0 then
				showReciept = true
				showCursor(true)
			end
		elseif showReciept and state == "down" and activeButtonC == "close" then
			showReciept = false
			showCursor(false)
			activeButtonC = false
			button = {}
		elseif showReciept and state == "down" and activeButtonC == "pay" then
			showReciept = false
			showCursor(false)
			iprint(availableStations)
			--iprint(lastPistolData[2])
			--iprint(lastPistolData[1])
			triggerServerEvent("payFuel", localPlayer, lastPistolData[1], lastPistolData[2], math.ceil(math.floor(availableStations[lastPistolData[1]].fuelPositions[lastPistolData[2]].currentFuelAmount * 10) / 10))
		end
	end
)

function getCurrentInteractionList(model)
	return interactionTable
end

local renderData = {}

function onClientClick(button, state, _, _, worldX, worldY, worldZ, clickedWorld)
	if button == "right" and state == "down" then
		local cameraX, cameraY, cameraZ = getCameraMatrix()

		worldX = (worldX - cameraX) * 6
		worldY = (worldY - cameraY) * 6
		worldZ = (worldZ - cameraZ) * 6

		local _, _, _, _, hitElement = processLineOfSight(cameraX, cameraY, cameraZ, worldX + cameraX, worldY + cameraY, worldZ + cameraZ, false, true, true, true, false, false, false, false, localPlayer)
		
		if hitElement then
			clickedWorld = hitElement
		end

		if isElement(clickedWorld) and getElementData(clickedWorld, "isFuelPump") and inDistance3D(clickedWorld, localPlayer, 3) then
			local pistolHolder = getElementData(localPlayer, "pistolHolder")
			local stationId = activePump[1]
			local positionId = activePump[2]

			if pistolHolder then
				if pistolHolder[1] == stationId and pistolHolder[2] == positionId then
					showStationPanel()
						renderData = {
							sourceElement = clickedWorld,
							posX = absX, 
							posY = absY,
							sizeX = respc(250),
							sizeY = respc(240),
						}
				else
					interactionTable = {}
					exports.sm_hud:showAlert("error", "Ezt a kutat jelenleg nem használhatod!")
				end
			else
				local canUse = true

				if availableStations[stationId].fuelPositions[positionId].fillingStarted then
					canUse = false
				end

				for k, v in pairs(availableStations[stationId].fuelPositions[positionId].pistolHolder) do
					if isElement(v) then
						canUse = false
						break
					end
				end

				if canUse then
					if renderData.sourceElement == clickedWorld then
						renderData.posX, renderData.posY = absX, absY
					end
					
					if not renderData.sourceElement then
						showStationPanel()

						effectOn = true
						createElementOutlineEffect(clickedWorld, true)

						renderData = {
							sourceElement = clickedWorld,
							posX = absX, 
							posY = absY,
							sizeX = respc(250),
							sizeY = respc(240),
						}
					end
				else
					interactionTable = {}
					exports.sm_hud:showAlert("error", "Ezt a kutat jelenleg nem használhatod!")
				end
			end
		end
	end
end

local enabledButtons = 0

function renderStationHover()
	if renderData.sourceElement and isElement(renderData.sourceElement) and activePump then
		local camX, camY, camZ = getCameraMatrix()
		local objX, objY, objZ = getElementPosition(renderData.sourceElement)

		if isLineOfSightClear(objX, objY, objZ, camX, camY, camZ, true, true, false, true, false, true, false, renderData.sourceElement) then
			local dist = getDistanceBetweenPoints3D(objX, objY, objZ, getElementPosition(localPlayer))
			local x, y = getScreenFromWorldPosition(objX, objY, objZ)

			if x and y then
				if dist < 5 then
					renderData.posX = x - renderData.sizeX / 2
					renderData.posY = y - renderData.sizeY

					if renderData.posX and renderData.posY then
						buttonsC = {}
						renderData.sizeY = enabledButtons * respc(35) + 4 + respc(30)
						enabledButtons = 0

						local now = getTickCount()
						local elapsedTime = now - currentTick
						local progress = elapsedTime / 500

						alpha = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "Linear")

						renderData.sizeX = respc(250) * alpha

						dxDrawRectangle(renderData.posX, renderData.posY, renderData.sizeX, renderData.sizeY, tocolor(25, 25, 25, 255 * alpha))
						dxDrawRectangle(renderData.posX + 4, renderData.posY + 4, renderData.sizeX - 8, respc(30) - 4, tocolor(45, 45, 45, 180 * alpha))
						dxDrawText("Üzemanyag pumpa", renderData.posX + 4 + respc(5), renderData.posY + 4 + (respc(30) - 4) / 2, nil, nil, tocolor(200, 200, 200, 200 * alpha), 0.9, Raleway, "left", "center", false, false, false, false, true)

						if activeButtonC == "close" then
							exitColor = tocolor(168, 71, 78, 200 * alpha)
						else
							exitColor = tocolor(200, 200, 200, 200 * alpha)
						end

						dxDrawText("X", renderData.posX + 4 + renderData.sizeX - 4 - respc(10), renderData.posY + 4 + (respc(30) - 4) / 2, nil, nil, exitColor, 0.9, Raleway, "right", "center", false, false, false, false, true)

						buttonsC["close"] = {
							renderData.posX + renderData.sizeX - respc(20),
							renderData.posY,
							respc(30),
							respc(30)
						}

						startY = renderData.posY + respc(30) + 4

						if getElementData(localPlayer, "pistolHolder") then
							drawButton("returnPistol", "Pisztoly visszarakása", renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, {61, 122, 188}, false, Raleway, true, 0.8)
							enabledButtons = enabledButtons + 1

							startY = startY + respc(35)
						else
							--{"\"Diesel\" pisztoly levétele", ":sarp_fuel/files/images/pickupPistol.png", "requestPumpPistol"},
							--{"\"Regular 87\" pisztoly levétele
							drawButton("dieselPump", "Diesel pisztoly levétele", renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, {61, 122, 188}, false, Raleway, true, 0.8)
							enabledButtons = enabledButtons + 1

							startY = startY + respc(35)

							drawButton("regularPump", "Benzin pisztoly levétele", renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, {61, 122, 188}, false, Raleway, true, 0.8)
							enabledButtons = enabledButtons + 1

							startY = startY + respc(35)
						end

						local cx, cy = getCursorPosition()

						if tonumber(cx) and tonumber(cy) then
							cx = cx * screenX
							cy = cy * screenY

							activeButtonC = false
							if not buttonsC then
								return
							end
							for k,v in pairs(buttonsC) do
								if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
									activeButtonC = k
									break
								end
							end
						else
							activeButtonC = false
						end
					end
				end
			end
		end
	else
		destroyStationPanel()
	end
end

function clickStationHover(sourceKey, keyState)
	if sourceKey == "left" and keyState == "down" then
		if renderData.sourceElement and isElement(renderData.sourceElement) then
			if activeButtonC then
				if activeButtonC == "close" then
					destroyStationPanel()
				elseif activeButtonC == "dieselPump" then
					triggerEvent("requestPumpPistol", localPlayer, renderData.sourceElement, 1)
				elseif activeButtonC == "regularPump" then
					triggerEvent("requestPumpPistol", localPlayer, renderData.sourceElement, 2)
				elseif activeButtonC == "returnPistol" then
					triggerServerEvent("resetPumpPistol", localPlayer)
				end
			end
		end
	end
end

function showStationPanel()
	currentTick = getTickCount()

	addEventHandler("onClientRender", getRootElement(), renderStationHover)
	addEventHandler("onClientClick", getRootElement(), clickStationHover)
end

function destroyStationPanel()
	removeEventHandler("onClientRender", getRootElement(), renderStationHover)
	removeEventHandler("onClientClick", getRootElement(), clickStationHover)

	destroyElementOutlineEffect(renderData.sourceElement)
	effectOn = false
	renderData = {}
end

function onClientRender()
	if activeSyncedStation then
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
		local playerRotX, playerRotY, playerRotZ = getElementRotation(localPlayer)

		if showReciept and activeStation then
			buttonsC = {}

			local sx, sy = 300, 370
			local x = (screenX - sx) / 2
			local y = (screenY - sy) / 2

			local stationId = lastPistolData[1]
			local positionId = lastPistolData[2]

			dxDrawRectangle(x, y, sx, sy - 70, tocolor(230, 230, 230))
			print("asd gec")

			dxDrawText("SRONG-FUEL NYUGTA\n---------------------", x, y, x + sx, y + 90, tocolor(0, 0, 0), 0.8, ThermalPrinter, "center", "center")

			dxDrawText("Üzemanyag:", x + 10, y + 110, 0, 0, tocolor(0, 0, 0), 0.6, ThermalPrinter, "left", "top")
			
			dxDrawText(math.floor(availableStations[stationId].fuelPositions[positionId].currentAmount * 10) / 10 .. " L", x, y + 110, x + sx - 10, 0, tocolor(0, 0, 0), 0.5, ThermalPrinter, "right", "top")
		
			dxDrawText("Gallon ár:", x + 10, y + 135, 0, 0, tocolor(0, 0, 0), 0.6, ThermalPrinter, "left", "top")
			
			dxDrawText("Regular - " .. availableStations[stationId].fuelPrice[2] .. " $", x, y + 135, x + sx - 10, 0, tocolor(0, 0, 0), 0.5, ThermalPrinter, "right", "top")
			
			dxDrawText("Diesel - " .. availableStations[stationId].fuelPrice[1] .. " $", x, y + 160, x + sx - 10, 0, tocolor(0, 0, 0), 0.5, ThermalPrinter, "right", "top")

			dxDrawText("---------------------", x, y + 220, x + sx, 0, tocolor(0, 0, 0), 0.8, ThermalPrinter, "center")

			dxDrawText("Fizetendő:", x + 10, y + 260, 0, 0, tocolor(0, 0, 0), 0.6, ThermalPrinter, "left", "top")
			
			dxDrawText(math.ceil(math.floor(availableStations[stationId].fuelPositions[positionId].currentFuelAmount * 10) / 10) .. " $", x, y + 260, x + sx - 10, 0, tocolor(0, 0, 0), 0.5, ThermalPrinter, "right", "top")

			sy = sy - 70

			drawButton("close", "Mégsem", x, y + sy, sx / 2, 35, {61, 122, 188}, false, Raleway, true, 0.8)

			drawButton("pay", "Kifizetés", x + sx / 2, y + sy, sx / 2, 35, {61, 122, 188}, false, Raleway, true, 0.8)

			local cx, cy = getCursorPosition()

			activeButtonC = false

			if tonumber(cx) and tonumber(cy) then
				cx = cx * screenX
				cy = cy * screenY

				for k,v in pairs(buttonsC) do
					if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
						activeButtonC = k
						break
					end
				end
			end
		end

		local fuelPositions = availableStations[activeSyncedStation].fuelPositions

		for k = 1, #fuelPositions do
			local v = fuelPositions[k]

			if v.pistolObjects and v.lineStart then
				for i = 1, #v.lineStart do
					if isElement(v.pistolObjects[i]) then
						if v.pistolHolder and isElement(v.pistolHolder[i]) or not activeStation then
							local pistolPosX, pistolPosY, pistolPosZ = getElementPosition(v.pistolObjects[i])

							local linePos = v.linePositions[i][1]
							local offsetX = (pistolPosX - linePos[1]) / 2
							local offsetY = (pistolPosY - linePos[2]) / 2

							local splinePositions = {
								{linePos[1], linePos[2], linePos[3]},
								{linePos[1] + offsetX / 2, linePos[2] + offsetY / 2, linePos[3]},
								{pistolPosX - offsetX / 2, pistolPosY - offsetY / 2, pistolPosZ - 0.3},
								{pistolPosX, pistolPosY, pistolPosZ}
							}

							local pistolSpline = createSpline(splinePositions)

							for j = 1, #pistolSpline do
								local k = j + 1

								if pistolSpline[k] then
									dxDrawLine3D(pistolSpline[j][1], pistolSpline[j][2], pistolSpline[j][3], pistolSpline[k][1], pistolSpline[k][2], pistolSpline[k][3], tocolor(5, 5, 5), 1.25)
								end
							end
						elseif v.linePositions and v.linePositions[i] then
							for j = 1, #v.linePositions[i] do
								local k = j + 1

								if v.linePositions[i][k] then
									dxDrawLine3D(v.linePositions[i][j][1], v.linePositions[i][j][2], v.linePositions[i][j][3], v.linePositions[i][k][1], v.linePositions[i][k][2], v.linePositions[i][k][3], tocolor(5, 5, 5), 1.25)
								end
							end
						end
					end
				end
			end

			if v.renderTarget then
				dxSetRenderTarget(v.renderTarget, true)

				dxDrawText(math.ceil(math.floor(v.currentFuelAmount * 10) / 10) .. " $", 0, 0, lcdRTSize, 30, tocolor(0, 0, 0, 200), 1, CounterFont, "right", "center")

				dxDrawText(math.floor(v.currentAmount * 10) / 10 .. " L", 0, 41, lcdRTSize, 42 + 30, tocolor(0, 0, 0, 200), 1, CounterFont, "right", "center")

				dxSetRenderTarget()

				if v.drawPosition then
					dxDrawMaterialLine3D(v.drawPosition[1], v.drawPosition[2], v.drawPosition[3] + 0.5, v.drawPosition[1], v.drawPosition[2], v.drawPosition[3], v.renderTarget, 0.525, -1, v.drawPosition[1] + v.drawPosition[4], v.drawPosition[2] + v.drawPosition[5], v.drawPosition[3] + v.drawPosition[6])
				end
			end

			if v.effectElement then
				for i = 1, #v.lineStart do
					if isElement(v.pistolObjects[i]) and isElement(v.pistolHolder[i]) then
						local pistolPosX, pistolPosY, pistolPosZ = getElementPosition(v.pistolObjects[i])
						local pistolRotX, pistolRotY, pistolRotZ = getElementRotation(v.pistolObjects[i])

						local angle = math.rad(pistolRotZ + 90)
						local rotatedX = -math.sin(angle) * 0.3
						local rotatedY = math.cos(angle) * 0.3

						setElementPosition(v.effectElement, pistolPosX + rotatedX, pistolPosY + rotatedY, pistolPosZ + 0.07)
						setElementRotation(v.effectElement, 120, 0, -pistolRotZ - 90)
					end
				end
			end

			if v.fillingStarted then
				local fuelPrice = availableStations[activeSyncedStation].fuelPrice[v.activeFuelType]
				local elapsedTime = getTickCount() - v.fillingStarted
				local fuelAmount = counterSpeed / 1000 * elapsedTime

				v.currentAmount = v.galStarted + fuelAmount
				v.currentFuelAmount = v.fuelStarted + fuelAmount * fuelPrice

				if havePistol and selectedVehicle and havePistol[1] == activeSyncedStation and havePistol[2] == k then
					vehicleAddFuel[selectedVehicle] = (vehiclesFuelStartedAmount[selectedVehicle] or 0) + math.floor(fuelAmount * 10) / 10

					if not vehicleFuelLeft[selectedVehicle] then
						vehicleFuelLeft[selectedVehicle] = getElementData(selectedVehicle, "vehicle.fuel") or 0
					end

					if vehicleFuelLeft[selectedVehicle] + vehicleAddFuel[selectedVehicle] >= (fuelTankSize[getElementModel(selectedVehicle)] or 50) then
						v.fillingStarted = false

						triggerServerEvent("doFuelingProcess", localPlayer, false, havePistol[1], havePistol[2], selectedVehicle, true)

						setElementData(resourceRoot, "fuelStation_" .. havePistol[1] .. "_" .. havePistol[2], {v.currentAmount, v.currentFuelAmount})

						exports.sm_hud:showAlert("info", "Teletankoltad a járművet.")
					end
				end
			end
		end


		local nearestVehicle = false
		hoverVehicle = false

		if (activeSyncedStation and havePistol or haveCanister) and not isPedInVehicle(localPlayer) then
			local vehiclesTable = false

			if haveCanister then
				vehiclesTable = getElementsByType("vehicle", getRootElement(), true)
			else
				vehiclesTable = getElementsWithinColShape(availableStations[activeSyncedStation].innerColShape.element, "vehicle")
			end

			local circleRotation = math.rad(getTickCount() * 0.1)
			local circleOffsetX = math.cos(circleRotation) * 0.5
			local circleOffsetY = math.sin(circleRotation) * 0.5
			local circleOffsetX2 = math.sin(circleRotation) * 0.25
			local circleOffsetY2 = math.cos(circleRotation) * 0.25

			for k = 1, #vehiclesTable do
				local v = vehiclesTable[k]
				local model = getElementModel(v)

				local x, y, z = 0, 0, 0
				if centerFilling[model] then
					x, y, z = getElementPosition(v)
				elseif fuelSides[model] then
					if type(fuelSides[model]) == "table" then
						local matrix = getElementMatrix(v)

						x, y, z = getPositionFromMatrixOffset(matrix, fuelSides[model][1], fuelSides[model][2], 0)
					else
						x, y, z = getVehicleComponentPosition(v, wheelSide[fuelSides[model]], "world")
					end
				else
					x, y, z = getVehicleComponentPosition(v, wheelSide[defaultFuelSide], "world")
				end

				if x and y and z then
					local velocityX, velocityY, velocityZ = getElementVelocity(v)
					local speed = math.floor(getDistanceBetweenPoints3D(0, 0, 0, velocityX, velocityY, velocityZ) * 187.5)

					if speed < 2 and math.abs(z - playerPosZ) <= 2.5 then
						local distance = getDistanceBetweenPoints2D(playerPosX, playerPosY, x, y)

						if distance <= 5 then
							local vehiclePosX, vehiclePosY, vehiclePosZ = getElementPosition(v)
							local angle = math.deg(math.atan2(vehiclePosY - playerPosY, vehiclePosX - playerPosX)) + 180 - playerRotZ
							
							if angle < 0 then
								angle = angle + 360
							end

							if debugMode then
								dxDrawText("angle: " .. angle, 500, 400)
							end

							if distance <= 0.75 and angle >= 200 and angle <= 280 then
								nearestVehicle = v
							end

							local groundPosition = getGroundPosition(x, y, z) + 0.05

							if nearestVehicle then
								dxDrawMaterialLine3D(x - circleOffsetX, y - circleOffsetY, groundPosition, x + circleOffsetX, y + circleOffsetY, groundPosition, circleTexture, 1, tocolor(50, 179, 239, 200), x, y, groundPosition + 0.25)
								dxDrawMaterialLine3D(x - circleOffsetX2, y - circleOffsetY2, groundPosition, x + circleOffsetX2, y + circleOffsetY2, groundPosition, circleTexture, 0.5, tocolor(50, 179, 239, 200), x, y, groundPosition + 0.25)
							else
								dxDrawMaterialLine3D(x - circleOffsetX, y - circleOffsetY, groundPosition, x + circleOffsetX, y + circleOffsetY, groundPosition, circleTexture, 1, tocolor(194, 194, 194, 200), x, y, groundPosition + 0.25)
								dxDrawMaterialLine3D(x - circleOffsetX2, y - circleOffsetY2, groundPosition, x + circleOffsetX2, y + circleOffsetY2, groundPosition, circleTexture, 0.5, tocolor(194, 194, 194, 200), x, y, groundPosition + 0.25)
							end
						end
					end
				end
			end
		end

		hoverVehicle = nearestVehicle

		if havePistol and not pistolTaken then
			local stationId = havePistol[1]
			local positionId = havePistol[2]
			local fuelType = havePistol[3]
			local fuelPos = availableStations[stationId].fuelPositions[positionId]

			if fuelPos then
				local pistolPosX, pistolPosY, pistolPosZ = getElementPosition(fuelPos.pistolObjects[fuelType])
				local lineStartX, lineStartY, lineStartZ = fuelPos.lineStart[fuelType][1], fuelPos.lineStart[fuelType][2], fuelPos.lineStart[fuelType][3]
				local angle = math.deg(math.atan2(lineStartY - pistolPosY, lineStartX - pistolPosX)) + 180

				if angle >= 360 then
					angle = angle - 360
				end

				if debugMode then
					dxDrawText("angle: " .. angle, 500, 500)

					if fuelPos.checkRotation(angle) then
						dxDrawLine3D(pistolPosX, pistolPosY, pistolPosZ, lineStartX, lineStartY, lineStartZ, tocolor(255, 0, 0), 3)
					else
						dxDrawLine3D(pistolPosX, pistolPosY, pistolPosZ, lineStartX, lineStartY, lineStartZ, tocolor(0, 255, 0), 3)
					end
				end

				if fuelPos.checkRotation(angle) then
					triggerServerEvent("resetPumpPistol", localPlayer)

					exports.sm_hud:showAlert("warning", "Itt nem tud átmenni a cső!")

					pistolTaken = true
					hitDetectCount = 0
					return
				end

				if getDistanceBetweenPoints3D(lineStartX, lineStartY, lineStartZ, playerPosX, playerPosY, playerPosZ) >= 3 then
					triggerServerEvent("resetPumpPistol", localPlayer)

					exports.sm_hud:showAlert("warning", "Túl messzire mentél a csővel!")

					pistolTaken = true
					hitDetectCount = 0
					return
				end

				local _, _, _, _, hitElement = processLineOfSight(pistolPosX, pistolPosY, pistolPosZ, lineStartX, lineStartY, lineStartZ, true, true, false, true, true, false, false, false, availableStations[stationId].fuelPositions[positionId].pistolObjects[fuelType])
				local _, _, _, _, hitElement2 = processLineOfSight(pistolPosX, pistolPosY, pistolPosZ, lineStartX, lineStartY, lineStartZ, true, true, false, true, true, false, false, false, localPlayer)

				if isElement(hitElement) and isElement(hitElement2) then
					local elementModel = getElementModel(hitElement)
					local elementModel2 = getElementModel(hitElement2)

					if elementModel ~= 1686 and elementModel ~= 330 and elementModel2 ~= 3465 and elementModel2 ~= 330 then
						hitDetectCount = hitDetectCount + 1

						if hitDetectCount >= 5 then
							triggerServerEvent("resetPumpPistol", localPlayer)
							
							exports.sm_hud:showAlert("warning", "Itt nem tud átmenni a cső!")

							pistolTaken = true
							hitDetectCount = 0
							return
						end
					else
						hitDetectCount = 0
					end
				else
					hitDetectCount = 0
				end
			end
		end
	end
end

function getPositionFromMatrixOffset(matrix, offsetX, offsetY, offsetZ)
	local positionX = offsetX * matrix[1][1] + offsetY * matrix[2][1] + offsetZ * matrix[3][1] + matrix[4][1]
	local positionY = offsetX * matrix[1][2] + offsetY * matrix[2][2] + offsetZ * matrix[3][2] + matrix[4][2]
	local positionZ = offsetX * matrix[1][3] + offsetY * matrix[2][3] + offsetZ * matrix[3][3] + matrix[4][3]

	return positionX, positionY, positionZ
end

function inDistance3D(element1, element2, distance)
	if isElement(element1) and isElement(element2) then
	    local x1, y1, z1 = getElementPosition(element1)
	    local x2, y2, z2 = getElementPosition(element2)
	    local distance2 = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)

	    if distance2 <= distance then
	        return true, distance2
	    end
	end

    return false, 99999
end