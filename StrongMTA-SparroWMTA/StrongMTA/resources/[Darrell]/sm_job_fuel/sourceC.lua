local screenX, screenY = guiGetScreenSize()

local jobStartElements = {}
local myActiveJob = false
local lastJobStart = 0

local depotTankObjects = {}
local stationTankObjects = {}

local loadingBays = {}
local downBays = {}
local currentPhase = 0
local ticks = {}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		local col, txd, dff

		col = engineLoadCOL("files/tank_depot.col")
		engineReplaceCOL(col, tankDepotModelId)
		txd = engineLoadTXD("files/tank_depot.txd")
		engineImportTXD(txd, tankDepotModelId)
		dff = engineLoadDFF("files/tank_depot.dff")
		engineReplaceModel(dff, tankDepotModelId)

		col = engineLoadCOL("files/tank_fuelstation.col")
		engineReplaceCOL(col, tankStationModelId)
		txd = engineLoadTXD("files/tank_fuelstation.txd")
		engineImportTXD(txd, tankStationModelId)
		dff = engineLoadDFF("files/tank_fuelstation.dff")
		engineReplaceModel(dff, tankStationModelId)

		for i, v in ipairs(startDestinations) do
			if v.tankPosition then
				depotTankObjects[i] = createObject(tankDepotModelId, v.tankPosition[1], v.tankPosition[2], v.tankPosition[3], 0, 0, v.tankRotation)

				setElementFrozen(depotTankObjects[i], true)
				setObjectBreakable(depotTankObjects[i], false)

				if not v.parkingDetails then
					local middleX, middleY = rotateAround(v.tankRotation, 7.5, 0, v.tankPosition[1], v.tankPosition[2])

					v.parkingDetails = {middleX, middleY, v.tankPosition[3], 11, 4}
					v.blipPosition = {v.parkingDetails[1], v.parkingDetails[2], v.tankPosition[3], "minimap/jobblips/oil.png", 48}
				end
			end
		end

		for i, v in ipairs(finalDestinations) do
			if v.tankPosition then
				stationTankObjects[i] = createObject(tankStationModelId, v.tankPosition[1], v.tankPosition[2], v.tankPosition[3], 0, 0, v.tankRotation)

				setElementFrozen(stationTankObjects[i], true)
				setObjectBreakable(stationTankObjects[i], false)

				if not v.parkingDetails then
					local middleX, middleY = rotateAround(v.tankRotation, 9.25, 0, v.tankPosition[1], v.tankPosition[2])

					v.parkingDetails = {middleX, middleY, v.tankPosition[3], 11, 4}
					v.blipPosition = {v.parkingDetails[1], v.parkingDetails[2], v.tankPosition[3], "minimap/jobblips/fuel.png", 22, true}
				end
			end
		end

		if getElementData(localPlayer, "char.Job") == jobId then
			endJob(true)
		end
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if myActiveJob then
			if isElement(myActiveJob.vehicle) then
				setElementData(myActiveJob.vehicle, "jobWithCar", false)
			end
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if source == localPlayer then
			if dataName == "char.Job" then
				for i = 1, #jobStartElements do
					if isElement(jobStartElements[i]) then
						destroyElement(jobStartElements[i])
					end
				end

				if getElementData(localPlayer, "char.Job") == jobId then
					endJob(true)
				end
			end
		end
	end
)

addEventHandler("onClientMarkerHit", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if matchingDimension then
			if hitElement == localPlayer then
				if getElementData(source, "jobStart") then
					startTheJob()
				end
			end
		end
	end
)

addEventHandler("onClientRestore", getRootElement(),
	function (didClearRenderTargets)
		if didClearRenderTargets then
			createLoadingBays()
		end
	end
)

addEvent("receiveFuelDeliveryJob", true)
addEventHandler("receiveFuelDeliveryJob", getRootElement(),
	function (activeJob)
		if activeJob then
			lastJobStart = getTickCount()

			myActiveJob = activeJob
			myActiveJob.vehicle = getPedOccupiedVehicle(localPlayer)

			if not myActiveJob.vehicle then
				myActiveJob = false
				return
			end

			for i = 1, #jobStartElements do
				if isElement(jobStartElements[i]) then
					destroyElement(jobStartElements[i])
				end
			end

			jobStartElements = {}

			local startDestination = startDestinations[myActiveJob.startDestinationId]
			local finalDestination = finalDestinations[myActiveJob.finalDestinationId]

			setElementData(myActiveJob.vehicle, "jobWithCar", localPlayer)

			if startDestination then
				if finalDestination then
					startBlip = createBlip(startDestination.blipPosition[1], startDestination.blipPosition[2], startDestination.blipPosition[3], 0, 2, 255,255,255)
					setElementData(startBlip, "blipTooltipText", "Berakodási pont")
					
					finalBlip = createBlip(finalDestination.blipPosition[1], finalDestination.blipPosition[2], finalDestination.blipPosition[3], 0, 2, 255,255,255)
					setElementData(finalBlip, "blipTooltipText", "Kirakodási pont")
					--exports.sm_hud:addJobBlips(startDestination.blipPosition)
					--exports.sm_hud:addJobBlips(finalDestination.blipPosition)

					table.insert(loadingBays, {
						destinationType = "start",
						basePosition = {startDestination.parkingDetails[1], startDestination.parkingDetails[2], startDestination.tankPosition[3]},
						baseRotation = startDestination.tankRotation,
						parkingSizes = {startDestination.parkingDetails[4], startDestination.parkingDetails[5]},
						parkingAngle = (startDestination.tankRotation + 270) % 360
					})

					table.insert(loadingBays, {
						destinationType = "final",
						basePosition = {finalDestination.parkingDetails[1], finalDestination.parkingDetails[2], finalDestination.tankPosition[3]},
						baseRotation = finalDestination.tankRotation,
						parkingSizes = {finalDestination.parkingDetails[4], finalDestination.parkingDetails[5]},
						parkingAngle = (finalDestination.tankRotation - 90) % 360
					})

					createLoadingBays()
				end
			end

			outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffElkezdted a munkát! Töltsd fel a tartályt a " .. startDestination.name .." telepen, majd vidd el a megjelölt helyre.", 255, 255, 255, true)
			--outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffJelenlegi úticél: #3d7abc" .. finalDestination.name, 255, 255, 255, true)
		end
	end
)

function startTheJob()
	if lastJobStart + 5000 > getTickCount() then
		return
	end

	if getElementData(localPlayer, "char.Job") ~= jobId then
		return
	end

	local theVehicle = getPedOccupiedVehicle(localPlayer)

	if not theVehicle then
		exports.sm_hud:showInfobox("e", "A munkát csak " .. exports.sm_vehiclenames:getCustomVehicleName(truckModelId) .. " típusú kocsival tudod elkezdeni.")
		return
	end

	if getElementModel(theVehicle) ~= truckModelId then
		exports.sm_hud:showInfobox("e", "A munkát csak " .. exports.sm_vehiclenames:getCustomVehicleName(truckModelId) .. " típusú kocsival tudod elkezdeni.")
		return
	end

	if getElementData(theVehicle, "jobWithCar") then
		exports.sm_hud:showInfobox("e", "Ezzel a kocsival már valaki dolgozik.")
		return
	end
	setElementData(localPlayer,"hasLine",false)
	setElementData(theVehicle,"fuelTank",0)
	endJob(true, true)
	triggerServerEvent("startFuelJob", localPlayer)
end

function endJob(isRestore, isStartRequest)
	exports.sm_hud:delJobBlips()

	for i = 1, #jobStartElements do
		if isElement(jobStartElements[i]) then
			destroyElement(jobStartElements[i])
		end
	end

	jobStartElements = {}

	if not isStartRequest then
		for i, v in ipairs(jobStartPositions) do
			local markerElement = createMarker(v[1], v[2], v[3], "checkpoint", 3, 124, 197, 118)
			local blipElement = createBlip(v[1], v[2], v[3], 0, 2, 124, 197, 118)

			table.insert(jobStartElements, markerElement)
			setElementData(markerElement, "jobStart", true, false)

			table.insert(jobStartElements, blipElement)
			setElementData(blipElement, "blipTooltipText", "Munkakezdés", false)
		end
	end

	for i = 1, #loadingBays do
		local v = loadingBays[i]

		if v then
			if isElement(v.colShape) then
				destroyElement(v.colShape)
			end

			if isElement(v.renderTarget) then
				destroyElement(v.renderTarget)
			end
		end
	end

	loadingBays = {}
	currentLoadingBay = false
	currentPhase = 0
end

function createLoadingBays()
	for i = 1, #loadingBays do
		local v = loadingBays[i]

		if v then
			local line_x1, line_y1 = rotateAround(v.baseRotation, 0, -v.parkingSizes[2] / 2)
			local line_x2, line_y2 = rotateAround(v.baseRotation, 0, v.parkingSizes[2] / 2)

			v.materialPosition = {
				v.basePosition[1] + line_x1,
				v.basePosition[2] + line_y1,
				v.basePosition[1] + line_x2,
				v.basePosition[2] + line_y2,
				v.basePosition[1],
				v.basePosition[2],
				v.basePosition[3]
			}

			if not isElement(v.colShape) then
				local rotated_x1, rotated_y1 = rotateAround(v.baseRotation, -v.parkingSizes[1] / 2, -v.parkingSizes[2] / 2)
				local rotated_x2, rotated_y2 = rotateAround(v.baseRotation, v.parkingSizes[1] / 2, -v.parkingSizes[2] / 2)
				local rotated_x3, rotated_y3 = rotateAround(v.baseRotation, v.parkingSizes[1] / 2, v.parkingSizes[2] / 2)
				local rotated_x4, rotated_y4 = rotateAround(v.baseRotation, -v.parkingSizes[1] / 2, v.parkingSizes[2] / 2)

				v.colShape = createColPolygon(
					v.basePosition[1],
					v.basePosition[2],
					v.basePosition[1] + rotated_x1,
					v.basePosition[2] + rotated_y1,
					v.basePosition[1] + rotated_x2,
					v.basePosition[2] + rotated_y2,
					v.basePosition[1] + rotated_x3,
					v.basePosition[2] + rotated_y3,
					v.basePosition[1] + rotated_x4,
					v.basePosition[2] + rotated_y4
				)

				v.colShapeBounds = {
					[1] = {v.basePosition[1] + rotated_x2, v.basePosition[2] + rotated_y2}, -- top right
					[2] = {v.basePosition[1] + rotated_x3, v.basePosition[2] + rotated_y3}, -- top left
					[3] = {v.basePosition[1] + rotated_x1, v.basePosition[2] + rotated_y1}, -- bottom right
					[4] = {v.basePosition[1] + rotated_x4, v.basePosition[2] + rotated_y4} -- bottom left
				}
			end

			local sizeX = v.parkingSizes[1] * 32
			local sizeY = v.parkingSizes[2] * 32

			local line_normal_size = 8
			local line_small_size = sizeY * 0.25

			if not isElement(v.renderTarget) then
				v.renderTarget = dxCreateRenderTarget(sizeX, sizeY, true)
			end

			dxSetRenderTarget(v.renderTarget, true)
			dxSetBlendMode("modulate_add")

			dxDrawRectangle(0, 0, line_normal_size, sizeY, tocolor(255, 255, 255, 200))
			dxDrawRectangle(sizeX - line_normal_size, 0, line_normal_size, sizeY, tocolor(255, 255, 255, 200))
			dxDrawRectangle(0, 0, sizeX, line_normal_size, tocolor(255, 255, 255, 200))
			dxDrawRectangle(0, sizeY - line_normal_size, sizeX, line_normal_size, tocolor(255, 255, 255, 200))

			dxDrawRectangle(0, 0, line_normal_size, line_small_size, tocolor(255, 255, 255))
			dxDrawRectangle(0, 0, line_small_size, line_normal_size, tocolor(255, 255, 255))

			dxDrawRectangle(sizeX - line_normal_size, 0, line_normal_size, line_small_size, tocolor(255, 255, 255))
			dxDrawRectangle(sizeX, 0, -line_small_size, line_normal_size, tocolor(255, 255, 255))

			dxDrawRectangle(0, sizeY - line_normal_size, line_small_size, line_normal_size, tocolor(255, 255, 255))
			dxDrawRectangle(0, sizeY, line_normal_size, -line_small_size, tocolor(255, 255, 255))

			dxDrawRectangle(sizeX - line_normal_size, sizeY, line_normal_size, -line_small_size, tocolor(255, 255, 255))
			dxDrawRectangle(sizeX, sizeY - line_normal_size, -line_small_size, line_normal_size, tocolor(255, 255, 255))

			dxSetBlendMode("blend")
			dxSetRenderTarget()
		end
	end
end

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (theElement, matchingDimension)
		if matchingDimension then
			if myActiveJob then
				if myActiveJob.vehicle then
					if theElement == myActiveJob.vehicle then
						for i = 1, #loadingBays do
							if source == loadingBays[i].colShape then
								currentLoadingBay = i
								break
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (theElement, matchingDimension)
		if matchingDimension then
			if myActiveJob then
				if myActiveJob.vehicle then
					if theElement == myActiveJob.vehicle then
						currentLoadingBay = false
					end
				else
					currentLoadingBay = false
				end
			else
				currentLoadingBay = false
			end
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" and getPedOccupiedVehicle(getLocalPlayer()) == source then
		if myActiveJob then
			if myActiveJob.vehicle == source then
				endJob(false, false)
				if isElement(finalBlip) then
					destroyElement(finalBlip)
				elseif isElement(startBlip) then
					destroyElement(startBlip)
				end
			end
		end
	end
end)

local desType
local handOBJ
addEventHandler("onClientRender", getRootElement(),
	function ()
		if myActiveJob then
			local boundingBoxCheck = false

			for i = 1, #loadingBays do
				local v = loadingBays[i]

				if v then
					v.materialPosition[7] = getGroundPosition(v.basePosition[1], v.basePosition[2], v.basePosition[3] + 1) + 0.025

					if v.renderTarget then
						local materialLineColor = tocolor(255, 255, 255)

						if currentLoadingBay == i then
							boundingBoxCheck = checkAABB(myActiveJob.vehicle, v.colShapeBounds, v.parkingAngle)
							
							if v.destinationType == "final" then
								if boundingBoxCheck then
									materialLineColor = tocolor(124, 197, 118, 150)
									desType = "final"
								end
							else
								if boundingBoxCheck then
									materialLineColor = tocolor(124, 197, 118, 150)	
									desType = "start"
								end
							end
						end


						dxDrawMaterialLine3D(
							v.materialPosition[1], v.materialPosition[2], v.materialPosition[7],
							v.materialPosition[3], v.materialPosition[4], v.materialPosition[7],
							v.renderTarget,
							v.parkingSizes[1],
							materialLineColor,
							v.materialPosition[5], v.materialPosition[6], v.materialPosition[7] + 25
						)
					end
				end
			end
			if getElementData(localPlayer,"hasLine") then
				if isElement(handOBJ) then
					local playerX, playerY, playerZ = getElementPosition(handOBJ)
					local offsetX, offsetY, offsetZ = getPositionFromElementOffset(myActiveJob.vehicle, 1.15, -5.95, 0.25)
					if getDistanceBetweenPoints3D(playerX, playerY, playerZ,offsetX, offsetY, offsetZ) > 10 then
						destroyElement(handOBJ)
						setElementData(localPlayer,"hasLine",false)
					end
					dxDrawLine3D(offsetX, offsetY, offsetZ, playerX, playerY, playerZ, tocolor(40, 40 ,40), 6, false)
				end
			end
			if currentLoadingBay then
				if not isPedInVehicle(localPlayer) then
					local playerX, playerY, playerZ = getElementPosition(localPlayer)

					if myActiveJob.vehicle then
						if isElementOnScreen(myActiveJob.vehicle) then
							local offsetX, offsetY, offsetZ = getPositionFromElementOffset(myActiveJob.vehicle, 1.15, -5.95, 0.25)

							if getDistanceBetweenPoints3D(playerX, playerY, playerZ, offsetX, offsetY, offsetZ) <= 1.15 then
								local guiX, guiY, guiDistance = getScreenFromWorldPosition(offsetX, offsetY, offsetZ)
								local vehScreenPosX, vehScreenPosY, vehScreenPosZ = getElementPosition(myActiveJob.vehicle)
								if guiX and guiY then
									local guiSize = 256 / math.max(guiDistance, math.pi)

									guiX = guiX - guiSize / 2
									guiY = guiY - guiSize / 2

									local guiIconColor = tocolor(255, 255, 255)

									if not boundingBoxCheck then
										local alp = 100
										if isInSlot(guiX, guiY, guiSize, guiSize) then
											alp = 150
										end
										guiIconColor = tocolor(215, 89, 89, alp)
									else
										local alp = 150
										if isInSlot(guiX, guiY, guiSize, guiSize) then
											alp = 200
										end
										guiIconColor = tocolor(200, 200, 200, alp)									
									end
									dxDrawRectangle(guiX, guiY, guiSize, guiSize, tocolor(25,25,25,255))
									dxDrawRectangle(guiX + 3, guiY + 3, guiSize - 6, guiSize - 6, tocolor(35,35,35,255))
									dxDrawImage(guiX, guiY, guiSize, guiSize, "files/pipedown.png", 0, 0, 0, guiIconColor)
									
									if isInSlot(guiX, guiY, guiSize, guiSize) and getKeyState("mouse1") then
										if ticks[localPlayer] and getTickCount() - ticks[localPlayer] < 500 then return end
										ticks[localPlayer] = getTickCount()
										if boundingBoxCheck then
											if getElementData(localPlayer,"hasLine") then
												if exports.sm_boneattach:isElementAttachedToBone(handOBJ) then
													setElementData(localPlayer,"hasLine", false)
													if isElement(handOBJ) then
														destroyElement(handOBJ)
													end
												else
													outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffAmíg töltődik a tartály, addig nem tudod visszarakni!", 255, 255, 255, true)
												end
											else
												handOBJ = createObject(4983, 0, 0, 0)
												setElementAlpha(handOBJ,0)
												exports.sm_boneattach:attachElementToBone(handOBJ, localPlayer, 12, -0.03, 0.02, 0.08, 0, 240, 0)
												setElementData(localPlayer,"hasLine", true)
											end
										else
											outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffNem vagy a kijelölt helyen, ezért nem tudod levenni a csövet.", 255, 255, 255, true)										
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

function playerClickToElement(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,element)
	if (element) then
		if button == "left" and state == "down" then
			if myActiveJob then
				if tostring(getElementType(element)) == "object" and getElementModel(element) == 3073 then
					local vehX,vehY,vehZ = getElementPosition(myActiveJob.vehicle)
					local playerX,playerY,playerZ = getElementPosition(localPlayer)
					if isElement(handOBJ) then
						if exports.sm_boneattach:isElementAttachedToBone(handOBJ) then
							if getElementData(myActiveJob.vehicle,"fuelTank") < 100 then
								exports.sm_boneattach:detachElementFromBone(handOBJ,localPlayer)
								attachElements(handOBJ,element,1.1,0,0.35)
								setTimer(function()
									if getElementData(myActiveJob.vehicle,"fuelTank") < 75 then
										tankLevel = getElementData(myActiveJob.vehicle,"fuelTank")
										setElementData(myActiveJob.vehicle,"fuelTank", tankLevel+25)
									else
										setElementData(myActiveJob.vehicle,"fuelTank",100)
										detachElements(handOBJ,myActiveJob.vehicle)
										exports.sm_boneattach:attachElementToBone(handOBJ, localPlayer, 12, -0.03, 0.02, 0.08, 0, 240, 0)
										outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffSikeresen feltöltötted a tartályt. Tedd vissza a csövet, majd vidd le a fuvart..", 255, 255, 255, true)
									end
								end,10000,4);
							else
								outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffA tartály már tele van.", 255, 255, 255, true)
							end
						end
					end
				elseif tostring(getElementType(element)) == "object" and getElementModel(element) == 2908 then
					if getElementData(localPlayer,"hasLine") then
						if isElement(handOBJ) and isElement(myActiveJob.vehicle) then
							if getElementData(myActiveJob.vehicle,"fuelTank") >= 25 then
								exports.sm_boneattach:detachElementFromBone(handOBJ,localPlayer)
								attachElements(handOBJ,element,3,-0.25,1.25)
								setElementData(myActiveJob.vehicle,"fuelTank",0)
									setTimer(function()
										detachElements(handOBJ,element)
										destroyElement(handOBJ)
										if isElement(finalBlip) then
											destroyElement(finalBlip)
										elseif isElement(startBlip) then
											destroyElement(startBlip)
										end
										local finalmoney = math.random(250,500)
										outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffSikeresen feltöltötted a tartályt. Jutalmad: '".. finalmoney .."$'", 255, 255, 255, true)
										exports.sm_core:giveMoney(localPlayer,finalmoney)
										endJob(false,false)
										outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffHa szeretnél még dolgozni, akkor menj vissza a telepre egy új fuvarért.", 255, 255, 255, true)
									end,45000,1);
							else
								outputChatBox("#3d7abc[StrongMTA - Üzemanyag szállító]: #ffffffNincs elég üzemanyag a tartályban.", 255, 255, 255, true)
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), playerClickToElement)

function checkAABB(vehicleElement, colshapeBounds, requiredRotation)
	if not isElement(vehicleElement) then
		return false
	end

	if getElementModel(vehicleElement) ~= truckModelId then
		return false
	end

	if requiredRotation then
		local vehicleRotation = select(3, getElementRotation(vehicleElement))

		if vehicleRotation < requiredRotation - 15 or vehicleRotation > requiredRotation + 15 then
			return false
		end
	end

	local vehicleMatrix = getElementMatrix(vehicleElement)
	local vehicleBounds = {
		[1] = {getPositionFromOffset(vehicleMatrix, 1.5, 4, 0)}, -- top right
		[2] = {getPositionFromOffset(vehicleMatrix, -1.5, 4, 0)}, -- top left
		[3] = {getPositionFromOffset(vehicleMatrix, 1.5, -6.5, 0)}, -- bottom right
		[4] = {getPositionFromOffset(vehicleMatrix, -1.5, -6.5, 0)} -- bottom left
	}

	local vehicleX = {vehicleBounds[1][1], vehicleBounds[2][1], vehicleBounds[3][1], vehicleBounds[4][1]}
	local vehicleY = {vehicleBounds[1][2], vehicleBounds[2][2], vehicleBounds[3][2], vehicleBounds[4][2]}

	local colshapeX = {colshapeBounds[1][1], colshapeBounds[2][1], colshapeBounds[3][1], colshapeBounds[4][1]}
	local colshapeY = {colshapeBounds[1][2], colshapeBounds[2][2], colshapeBounds[3][2], colshapeBounds[4][2]}

	local colMinX, colMinY = math.min(unpack(colshapeX)), math.min(unpack(colshapeY))
	local colMaxX, colMaxY = math.max(unpack(colshapeX)), math.max(unpack(colshapeY))

	local vehMinX, vehMinY = math.min(unpack(vehicleX)), math.min(unpack(vehicleY))
	local vehMaxX, vehMaxY = math.max(unpack(vehicleX)), math.max(unpack(vehicleY))

	if debugMode then
		-- ** Draw vehicle bounds
		dxDrawLine3D(
			vehicleBounds[1][1], vehicleBounds[1][2], vehicleBounds[1][3] - 10,
			vehicleBounds[1][1], vehicleBounds[1][2], vehicleBounds[1][3] + 10,
			tocolor(0, 170, 255, 150), 5
		)
		dxDrawLine3D(
			vehicleBounds[2][1], vehicleBounds[2][2], vehicleBounds[2][3] - 10,
			vehicleBounds[2][1], vehicleBounds[2][2], vehicleBounds[2][3] + 10,
			tocolor(0, 170, 255, 150), 5
		)
		dxDrawLine3D(
			vehicleBounds[3][1], vehicleBounds[3][2], vehicleBounds[3][3] - 10,
			vehicleBounds[3][1], vehicleBounds[3][2], vehicleBounds[3][3] + 10,
			tocolor(0, 170, 255, 150), 5
		)
		dxDrawLine3D(
			vehicleBounds[4][1], vehicleBounds[4][2], vehicleBounds[4][3] - 10,
			vehicleBounds[4][1], vehicleBounds[4][2], vehicleBounds[4][3] + 10,
			tocolor(0, 170, 255, 150), 5
		)

		-- ** Draw colshape bounds
		dxDrawLine3D(
			colshapeBounds[1][1], colshapeBounds[1][2], vehicleBounds[4][3] - 10,
			colshapeBounds[1][1], colshapeBounds[1][2], vehicleBounds[4][3] + 10,
			tocolor(255, 127, 0, 150), 5
		)
		dxDrawLine3D(
			colshapeBounds[2][1], colshapeBounds[2][2], vehicleBounds[4][3] - 10,
			colshapeBounds[2][1], colshapeBounds[2][2], vehicleBounds[4][3] + 10,
			tocolor(255, 127, 0, 150), 5
		)
		dxDrawLine3D(
			colshapeBounds[3][1], colshapeBounds[3][2], vehicleBounds[4][3] - 10,
			colshapeBounds[3][1], colshapeBounds[3][2], vehicleBounds[4][3] + 10,
			tocolor(255, 127, 0, 150), 5
		)
		dxDrawLine3D(
			colshapeBounds[4][1], colshapeBounds[4][2], vehicleBounds[4][3] - 10,
			colshapeBounds[4][1], colshapeBounds[4][2], vehicleBounds[4][3] + 10,
			tocolor(255, 127, 0, 150), 5
		)
	end

	if vehMinX > colMinX and vehMaxX < colMaxX then
		if vehMinY > colMinY and vehMaxY < colMaxY then
			return true
		end
	end

	return false
end

function isInSlot(posX, posY, sizeX, sizeY)
    return exports.sm_core:isInSlot(posX, posY, sizeX, sizeY)
end