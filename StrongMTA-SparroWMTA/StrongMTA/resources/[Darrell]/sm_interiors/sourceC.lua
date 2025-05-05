local screenX, screenY = guiGetScreenSize()

local interiorsLoaded = false
local standingMarker = false
local currentInteriorObject = false

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		setTimer(triggerServerEvent, 2000, 1, "requestInteriors", localPlayer)
	end
)

function requestInteriors(player)
	if isElement(player) then
		local characterId = getElementData(player, "char.ID")

		if characterId then
			local interiorsTable = {}

			for k, v in pairs(availableInteriors) do
				if v.ownerId == characterId then
					table.insert(interiorsTable, {
						interiorId = k,
						data = v
					})
				end
			end

			return interiorsTable
		end
	end

	return false
end

function createInterior(interiorId)
	local int = availableInteriors[interiorId]

	if int then
		if not int.ownerId then
			int.ownerId = 0
		end
		
		local state = "unSold"

		if int.ownerId > 0 then
			state = "sold"
		end
		
		int.enterPickup = createCoolMarker(int.entrance.position[1], int.entrance.position[2], int.entrance.position[3], int.type, state)
		
		if int.enterPickup then
			setCoolMarkerType(int.enterPickup, int.type, state)
			setElementInterior(int.enterPickup, int.entrance.interior)
			setElementDimension(int.enterPickup, int.entrance.dimension)
			setElementData(int.enterPickup, "interiorId", interiorId, false)
			setElementData(int.enterPickup, "colShapeType", "entrance", false)
		end
		
		int.exitPickup = createCoolMarker(int.exit.position[1], int.exit.position[2], int.exit.position[3], int.type, state)
		
		if int.exitPickup then
			setCoolMarkerType(int.exitPickup, int.type, state)
			setElementInterior(int.exitPickup, int.exit.interior)
			setElementDimension(int.exitPickup, int.exit.dimension)
			setElementData(int.exitPickup, "interiorId", interiorId, false)
			setElementData(int.exitPickup, "colShapeType", "exit", false)
		end
	end
end

function destroyInterior(interiorId)
	if interiorId then
		if availableInteriors[interiorId] then
			for k, v in pairs(availableInteriors[interiorId]) do
				if isElement(v) then
					destroyElement(v)
				end
			end
			
			deletedInteriors[interiorId] = true
			availableInteriors[interiorId] = nil

			if standingMarker and standingMarker[1] == interiorId then
				exports.sm_hud:endInteriorBox()
			end
		end
	end
end

addEvent("requestInteriors", true)
addEventHandler("requestInteriors", getRootElement(),
	function (interiors, deleted)
		for interiorId, data in pairs(interiors) do
			if not availableInteriors[interiorId] then
				availableInteriors[interiorId] = {}
			end

			for k, v in pairs(data) do
				parseInteriorData(interiorId, k, v)
			end
		end

		for interiorId in pairs(deleted) do
			if availableInteriors[interiorId] then
				deletedInteriors[interiorId] = true
				availableInteriors[interiorId] = nil
			end
		end
		
		for interiorId, data in pairs(availableInteriors) do
			createInterior(interiorId, data)
		end

		interiorsLoaded = true
	end)

addEvent("resetInterior", true)
addEventHandler("resetInterior", getRootElement(),
	function (interiorId)
		if interiorId then
			local int = availableInteriors[interiorId]
			
			if int then
				int.ownerId = 0

				if isElement(int.enterPickup) then
					setCoolMarkerType(int.enterPickup, int.type, "unSold")
				end
				
				if isElement(int.exitPickup) then
					setCoolMarkerType(int.exitPickup, int.type, "unSold")
				end
			end
		end
	end)

addEvent("changeInteriorOwner", true)
addEventHandler("changeInteriorOwner", getRootElement(),
	function (interiorId, ownerId)
		if interiorId and ownerId then
			local int = availableInteriors[interiorId]

			if int then
				int.ownerId = ownerId
			end
		end
	end)

addEvent("playInteriorSound", true)
addEventHandler("playInteriorSound", getRootElement(),
	function (soundType)
		if soundType then
			if soundType == "openclose" then
				playSound("files/sounds/openclose.mp3", false)
			elseif soundType == "locked" then
				playSound("files/sounds/locked.mp3", false)
			elseif soundType == "intenter" then
				playSound("files/sounds/intenter.mp3", false)
			elseif soundType == "intout" then
				playSound("files/sounds/intout.mp3", false)
			end
		end
	end)

addEventHandler("onClientMarkerHit", getResourceRootElement(),
	function (hitElement, dimensionMatch)
		if hitElement == localPlayer and dimensionMatch then
			local interiorId = getElementData(source, "interiorId")
			local colShapeType = getElementData(source, "colShapeType")

			if interiorId and colShapeType then
				local playerX, playerY, playerZ = getElementPosition(localPlayer)
				local targetX, targetY, targetZ = getElementPosition(source)
				
				if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) > 1.5 then
					return
				end
				
				local int = availableInteriors[interiorId]
				local showPreview = false

				standingMarker = {interiorId, colShapeType}

				if int.ownerId == 0 then
					if int.type ~= "building" and int.type ~= "building2" then
						if int.type == "rentable" then
							outputChatBox("#3d7abc[StrongMTA - Interior]: #ffffffEz az ingatlan kiadó! A bérléshez használd a #3d7abc/rent #ffffffparancsot!", 255, 255, 255, true)
							outputChatBox("#3d7abc[StrongMTA - Interior]: #ffffffBérleti díj: #3d7abc" .. formatNumber(int.price) .. " $/hét.#ffffff Kaució: #3d7abc" .. formatNumber(int.price * 4) .. " $", 255, 255, 255, true)
						else
							outputChatBox("#3d7abc[StrongMTA - Interior]: #ffffffEz az ingatlan eladó! A vásárláshoz használd a #3d7abc/buy #ffffffparancsot! Ár: #3d7abc" .. formatNumber(int.price) .. " $", 255, 255, 255, true)
						end

						showPreview = true
					end
				else
					if int.ownerId == tonumber(getElementData(localPlayer, "char.ID")) then
						if int.editable ~= "N" then
							if colShapeType == "entrance" then
								outputChatBox("#3d7abc[StrongMTA - Interior]: #ffffffEz az ingatlan szerkeszthető!", 255, 255, 255, true)
								outputChatBox("#3d7abc[StrongMTA - Interior]: #ffffffHasználd a #3d7abc[Z]#ffffff gombot vagy a '#3d7abc/edit#ffffff' parancsot a szerkesztéshez!", 255, 255, 255, true)
								exports.sm_hud:showInfobox("i", "Ez egy szerkeszthető interior! Részletek a chatboxban.")
							end
						end
					end
				end
				
				if colShapeType == "entrance" then
					--showInteriorInfo(int.dbID)
					exports.sm_hud:showInteriorBox("[" .. interiorId .. "] " .. int.name, "Nyomj [E] gombot a belépéshez.", int.locked, int.type, showPreview and int.gameInterior or false)
				elseif colShapeType == "exit" then
					exports.sm_hud:showInteriorBox("[" .. interiorId .. "] " .. int.name, "Nyomj [E] gombot a kilépéshez.", int.locked, int.type)
				end
			end
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		local now = getTickCount()

		if currentInteriorId then
			if currentInteriorId ~= getElementDimension(localPlayer) then
				currentInteriorId = false
				destroyCustomInterior()
			elseif not flyMode and currentInteriorData and gameInteriors[currentInteriorData["gameInterior"]]["customInterior"] then
				local playerVehicle = getPedOccupiedVehicle(localPlayer)

				if playerVehicle then
					local vehiclePosX, vehiclePosY, vehiclePosZ = getElementPosition(playerVehicle)
					local distanceFromMass = getElementDistanceFromCentreOfMassToBaseOfModel(playerVehicle)

					if isLineOfSightClear(vehiclePosX, vehiclePosY, vehiclePosZ, vehiclePosX, vehiclePosY, vehiclePosZ - distanceFromMass - 10, true, false, false, true, false, false, false) then
						setElementFrozen(playerVehicle, true)
					else
						setElementFrozen(playerVehicle, false)
					end
				else
					local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
					local distanceFromMass = getElementDistanceFromCentreOfMassToBaseOfModel(localPlayer)

					if isLineOfSightClear(playerPosX, playerPosY, playerPosZ, playerPosX, playerPosY, playerPosZ - distanceFromMass - 10, true, false, false, true, false, false, false) then
						setElementFrozen(localPlayer, true)
					else
						setElementFrozen(localPlayer, false)
					end
				end

				for k, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
					local vehiclePosX, vehiclePosY, vehiclePosZ = getElementPosition(v)
					local distanceFromMass = getElementDistanceFromCentreOfMassToBaseOfModel(v)

					if isLineOfSightClear(vehiclePosX, vehiclePosY, vehiclePosZ, vehiclePosX, vehiclePosY, vehiclePosZ - distanceFromMass - 10, true, false, false, true, false, false, false) then
						setElementFrozen(v, true)
					else
						setElementFrozen(v, false)
					end
				end
			end
		end

		-- ** Aktív marker
		buttons = {}

		if interiorInfo then
			local progress = 0

			if interiorInfo["startInterpolate"] and now >= interiorInfo["startInterpolate"] then
				local elapsedTime = now - interiorInfo["startInterpolate"]

				progress = interpolateBetween(0, 0, 0, 1, 0, 0, elapsedTime / 375, "OutQuad")

				if progress > 1 then
					progress = 1
				end
			elseif interiorInfo["stopInterpolate"] and now >= interiorInfo["stopInterpolate"] then
				local elapsedTime = now - interiorInfo["stopInterpolate"]

				progress = interpolateBetween(1, 0, 0, 0, 0, 0, elapsedTime / 375, "InQuad")

				if progress <= 0 then
					progress = 0
					interiorInfo = false
					return
				end
			end

			local interiorData = availableInteriors[interiorInfo["interiorId"]]

			if interiorData then
				-- ** Háttér
				local sx, sy = interiorInfo["panelSizeX"], respc(130)
				local x, y = (screenX - sx) / 2, screenY - 120 - sy * progress

				dxDrawRectangle(x, y, sx, sy, tocolor(47, 47, 47, 240 * progress))
				drawOutline(x, y, sx, sy, tocolor(75, 75, 75, 125 * progress))

				-- ** Ikon @ ID
				local interiorIcon = interiorIcons[interiorData["type"]]
				local fontHeight = dxGetFontHeight(0.75, Roboto)
				local r, g, b = getColorFromDecimal(interiorIcon["color"])

				dxDrawImage(math.floor(x + respc(10)), math.floor(y + (sy - respc(64) - fontHeight) / 2), respc(64), respc(64), interiorIcon["icon"], 0, 0, 0, tocolor(r, g, b, 225 * progress))
				dxDrawText("[" .. interiorInfo["interiorId"] .. "]", x + respc(10), math.floor(y + (sy - respc(64) - fontHeight) / 2) + respc(64), x + respc(74), 0, tocolor(r, g, b, 255 * progress), 0.75, Roboto, "center", "top")
				
				-- ** Információk
				dxDrawText(interiorData["name"], x + respc(58), y, x + interiorInfo["panelSizeX"], y + sy - fontHeight, tocolor(255, 255, 255, 255 * progress), 0.85, Roboto, "center", "center", true)
				dxDrawText(interiorInfo["infoText"], x + respc(58), y + fontHeight, x + interiorInfo["panelSizeX"], y + sy, tocolor(255, 255, 255, 255 * progress), 0.8, RobotoL, "center", "center", true)
			
				-- ** Kopogás @ Csengetés
				if interiorData["type"] == "house" or interiorData["type"] == "garage" or string.find(interiorData["type"], "rentable") then
					if getElementDimension(localPlayer) == 0 then
						drawButton("knock", "Kopogás", x, y + sy, sx / 2, respc(30), tocolor(0, 150, 255, 255 * progress), progress)
						drawButton("bell", "Csengetés", x + sx / 2, y + sy, sx / 2, respc(30), tocolor(0, 150, 255, 255 * progress), progress)
					else
						drawButton("knock", "Kopogás", x, y + sy, sx, respc(30), tocolor(0, 150, 255, 255 * progress), progress)
					end
				end
			end

			local relX, relY = getCursorPosition()

			activeButton = false

			if relX and relY then
				relX = relX * screenX
				relY = relY * screenY

				for k, v in pairs(buttons) do
					if relX >= v[1] and relX <= v[1] + v[3] and relY >= v[2] and relY <= v[2] + v[4] then
						activeButton = k
						break
					end
				end
			end
		end
	end
)


function refreshInteriorBox(interiorId)
	if standingMarker and standingMarker[1] == interiorId then
		local int = availableInteriors[interiorId]

		if int then
			local showPreview = false

			if int.ownerId == 0 then
				if int.type ~= "building" and int.type ~= "building2" then
					showPreview = true
				end
			else
				if int.ownerId == tonumber(getElementData(localPlayer, "char.ID")) then
					if int.editable ~= "N" then
						showPreview = true
					end
				end
			end
			
			if standingMarker[2] == "entrance" then
				exports.sm_hud:showInteriorBox("[" .. interiorId .. "] " .. int.name, "Nyomj [E] gombot a belépéshez.", int.locked, int.type, showPreview and int.gameInterior or false)
			else
				exports.sm_hud:showInteriorBox("[" .. interiorId .. "] " .. int.name, "Nyomj [E] gombot a kilépéshez.", int.locked, int.type)
			end
		else
			exports.sm_hud:endInteriorBox()
		end
	end
end

local lastInteriorBuy = 0

addCommandHandler("unrent",
	function ()
		if standingMarker then
			local interiorId = standingMarker[1]
			local int = availableInteriors[interiorId]

			if int then
				if int.type == "rentable" then
					local characterId = getElementData(localPlayer, "char.ID")

					if int.ownerId == characterId then
						if getTickCount() >= lastInteriorBuy + 5000 then
							triggerServerEvent("unRentInterior", localPlayer, interiorId)
							lastInteriorBuy = getTickCount()
						else
							outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak 5 másodpercenként használhatod ezt a parancsot.", 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[StrongMTA - Interior]: #ffffffEzt az ingatlant nem te bérled.", 255, 255, 255, true)
					end
				end
			end
		end
	end)

addCommandHandler("rent",
	function ()
		if standingMarker then
			local interiorId = standingMarker[1]
			local int = availableInteriors[interiorId]

			if int then
				if int.type == "rentable" then
					local characterId = getElementData(localPlayer, "char.ID")

					if int.ownerId == 0 then
						if exports.sm_core:getMoney(localPlayer) >= int.price * 5 then
							local interiorLimit = getElementData(localPlayer, "player.interiorLimit") or 5
							local interiorCount = 0

							for k, v in pairs(availableInteriors) do
								if v.ownerId == characterId then
									interiorCount = interiorCount + 1
								end
							end

							if interiorCount < interiorLimit then
								if getTickCount() >= lastInteriorBuy + 5000 then
									triggerServerEvent("buyInterior", localPlayer, interiorId)
									lastInteriorBuy = getTickCount()
								else
									outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak 5 másodpercenként használhatod ezt a parancsot.", 255, 255, 255, true)
								end
							else
								outputChatBox("#d75959[StrongMTA - Interior]: #ffffffNincs szabad ingatlan slotod.", 255, 255, 255, true)
							end
						else
							outputChatBox("#d75959[StrongMTA - Interior]: #ffffffNincs elég pénzed, hogy kifizesd a bérleti díjat és kauciót.", 255, 255, 255, true)
						end
					elseif int.ownerId == characterId then
						if exports.sm_core:getMoney(localPlayer) >= int.price then
							if getTickCount() >= lastInteriorBuy + 5000 then
								triggerServerEvent("tryToRenewalRent", localPlayer, interiorId)
								lastInteriorBuy = getTickCount()
							else
								outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak 5 másodpercenként használhatod ezt a parancsot.", 255, 255, 255, true)
							end
						else
							outputChatBox("#d75959[StrongMTA - Interior]: #ffffffNincs elég pénzed, hogy kifizesd a bérleti díjat.", 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[StrongMTA - Interior]: #ffffffEz a bérlakás nem kiadó.", 255, 255, 255, true)
					end
				else
					outputChatBox("#d75959[StrongMTA - Interior]: #ffffffEzt az ingatlant nem lehet kibérelni.", 255, 255, 255, true)
				end
			end
		end
	end)

addCommandHandler("buy",
	function ()
		if standingMarker then
			local interiorId = standingMarker[1]
			local int = availableInteriors[interiorId]

			if int then
				if int.type == "rentable" then
					outputChatBox("#d75959[StrongMTA - Interior]: #ffffffBérelhető lakást nem vásárolhatsz meg.", 255, 255, 255, true)
					outputChatBox("#d75959[StrongMTA - Interior]: #ffffffBérléshez használd a #598ed7/rent#ffffff parancsot.", 255, 255, 255, true)
					return
				end

				if int.type ~= "building" and int.type ~= "building2" then
					if int.ownerId == 0 then
						if exports.sm_core:getMoney(localPlayer) >= int.price then
							local interiorLimit = getElementData(localPlayer, "player.interiorLimit") or 5
							local interiorCount = 0

							for k, v in pairs(availableInteriors) do
								if v.ownerId == characterId then
									interiorCount = interiorCount + 1
								end
							end

							if interiorCount < interiorLimit then
								if getTickCount() >= lastInteriorBuy + 5000 then
									triggerServerEvent("buyInterior", localPlayer, interiorId)
									lastInteriorBuy = getTickCount()
								else
									outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak 5 másodpercenként használhatod ezt a parancsot.", 255, 255, 255, true)
								end
							else
								outputChatBox("#d75959[StrongMTA - Interior]: #ffffffNincs szabad ingatlan slotod.", 255, 255, 255, true)
							end
						else
							outputChatBox("#d75959[StrongMTA - Interior]: #ffffffNincs elég pénzed az ingatlan megvásárlásához. (#3d7abc" .. formatNumber(int.price) .. " $#ffffff)", 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[StrongMTA - Interior]: #ffffffEz az ingatlan nem eladó.", 255, 255, 255, true)
					end
				else
					outputChatBox("#d75959[StrongMTA - Interior]: #ffffffKözépületet nem vásárolhatsz meg.", 255, 255, 255, true)
				end
			end
		end
	end)

local lastInteriorLock = 0

addCommandHandler("lock/unlock-interior",
	function ()
		if standingMarker then
			local interiorId = standingMarker[1]
			local int = availableInteriors[interiorId]

			if int and int.type ~= "building" then
				local characterId = getElementData(localPlayer, "char.ID")

				if characterId then
					if getTickCount() >= lastInteriorLock + 5000 then
						triggerServerEvent("lockInterior", localPlayer, interiorId)
						lastInteriorLock = getTickCount()
					else
						outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak 5 másodpercenként #3d7abcnyithatod #ffffff/ #d75959zárhatod #ffffffaz ajtót.", 255, 255, 255, true)
					end
				end
			end
		end
	end)
bindKey("K", "up", "lock/unlock-interior")

addEvent("lockInterior", true)
addEventHandler("lockInterior", getRootElement(),
	function (interiorId, locked)
		if interiorId then
			local int = availableInteriors[interiorId]

			if int then
				int.locked = locked

				if standingMarker and standingMarker[1] == interiorId then
					exports.sm_hud:setInteriorDoorState(int.locked, int.type)
				end
			end
		end
	end)

addEvent("buyInterior", true)
addEventHandler("buyInterior", getRootElement(),
	function (interiorId, ownerId)
		if interiorId then
			local int = availableInteriors[interiorId]
			
			int.ownerId = ownerId
		
			if int.type ~= "building" then
				local state = "unSold"

				if int.ownerId > 0 then
					state = "sold"
				end

				if isElement(int.enterPickup) then
					setCoolMarkerType(int.enterPickup, int.type, state)
				end
				
				if isElement(int.exitPickup) then
					setCoolMarkerType(int.exitPickup, int.type, state)
				end
			end
		end
	end)

addEventHandler("onClientMarkerLeave", getResourceRootElement(),
	function (leaveElement)
		if leaveElement == localPlayer then
			if standingMarker then
				standingMarker = false
				exports.sm_hud:endInteriorBox()
			end
		end
	end)

local lastInteriorEnter = 0

function getCurrentStandingInterior()
	return standingMarker
end

bindKey("e", "up",
	function ()
		if standingMarker then
			if getElementData(localPlayer, "editingInterior") then
				exports.sm_accounts:showInfo("e", "Nem hagyhatod el az interiort szerkesztő módban.")
				return
			end

			local interiorId = tonumber(standingMarker[1])
			local colShapeType = tostring(standingMarker[2])

			if interiorId and colShapeType then
				local int = availableInteriors[interiorId]

				if int then
					if not int.dummy or int.dummy == "N" then
						if not getElementData(localPlayer, "cuffed") and not getElementData(localPlayer, "tazed") then
							if getTickCount() >= lastInteriorEnter + 3000 then
								local currentTask = getPedSimplestTask(localPlayer)

								if currentTask ~= "TASK_SIMPLE_CAR_DRIVE" and string.sub(currentTask, 0, 15) == "TASK_SIMPLE_CAR" then
									return
								end

								if currentTask == "TASK_SIMPLE_GO_TO_POINT" then
									return
								end

								local currentVehicle = getPedOccupiedVehicle(localPlayer)

								if isElement(currentVehicle) then
									setPedCanBeKnockedOffBike(localPlayer, false)
									setTimer(setPedCanBeKnockedOffBike, 1000, 1, localPlayer, true)

									if getVehicleOccupant(currentVehicle) == localPlayer then
										if int.type ~= "garage" then
											if not int.allowedVehicles then
												return
											elseif type(int.allowedVehicles) == "table" then
												local allowed = false
												
												for k, v in ipairs(int.allowedVehicles) do
													if getElementModel(currentVehicle) == v then
														allowed = true
														break
													end
												end
												
												if not allowed then
													return
												end
											end
										end
									else
										return
									end
								end

								lastInteriorEnter = getTickCount()

								if colShapeType == "entrance" then
									local warpData = {
										posX = int.exit.position[1],
										posY = int.exit.position[2],
										posZ = int.exit.position[3],
										rotX = int.exit.rotation[1],
										rotY = int.exit.rotation[2],
										rotZ = int.exit.rotation[3],
										interior = int.exit.interior,
										dimension = int.exit.dimension,
										editable = int.editable,
										id = interiorId
									}

									createInteriorObject(interiorId)
									warpAnimal(warpData)
									triggerServerEvent("warpPlayer", localPlayer, warpData, interiorId, "enter")
								elseif colShapeType == "exit" then
									local warpData = {
										posX = int.entrance.position[1],
										posY = int.entrance.position[2],
										posZ = int.entrance.position[3],
										rotX = int.entrance.rotation[1],
										rotY = int.entrance.rotation[2],
										rotZ = int.entrance.rotation[3],
										interior = int.entrance.interior,
										dimension = int.entrance.dimension,
										editable = int.editable,
										id = interiorId
									}

									warpAnimal(warpData)
									triggerServerEvent("warpPlayer", localPlayer, warpData, interiorId, "exit")

									if isElement(currentInteriorObject) then
										destroyElement(currentInteriorObject)
									end

									currentInteriorObject = nil
								end
							else
								outputChatBox("#d75959[StrongMTA - Interior]: #ffffffVárj egy kicsit, mielőtt újra használod az ajtót.", 255, 255, 255, true)
							end
						else
							outputChatBox("#d75959[StrongMTA - Interior]: #ffffffMegbilincselve/lesokkolva nem használhatod az ajtót.", 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[StrongMTA - Interior]: #ffffffEz az interior nem rendelkezik tényleges belső térrel.", 255, 255, 255, true)
					end
				end
			end
		end
	end)

function warpAnimal(warpData)
	local characterId = getElementData(localPlayer, "char.ID")
	if characterId then
		local animalElement = getElementByID("animal_" .. characterId)
		if isElement(animalElement) then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local animalX, animalY, animalZ = getElementPosition(animalElement)

			if getDistanceBetweenPoints3D(playerX, playerY, playerZ, animalX, animalY, animalZ) <= 10 then
				local playerInterior = getElementInterior(localPlayer)
				local animalInterior = getElementInterior(animalElement)

				if playerInterior == animalInterior then
					local playerDimension = getElementDimension(localPlayer)
					local animalDimension = getElementDimension(animalElement)

					if playerDimension == animalDimension then
						local currentTask = getElementData(animalElement, "ped.task.1")
						if currentTask then
							if currentTask[1] == "walkFollowElement" and currentTask[2] == localPlayer then
								triggerServerEvent("warpAnimal", localPlayer, warpData)
							end
						end
					end
				end
			end
		end
	end
end

function useDoorRammer()
	if exports.sm_groups:isPlayerHavePermission(localPlayer, "doorRammer") then
		if standingMarker then
			local interiorId = tonumber(standingMarker[1])

			if interiorId then
				local int = availableInteriors[interiorId]

				if int then
					if int.type ~= "building" then
						triggerServerEvent("useDoorRammer", localPlayer, interiorId)
					else
						outputChatBox("#d75959[StrongMTA - Interior]: #ffffffItt nem használhatod a faltörő kost.", 255, 255, 255, true)
					end
				end
			end
		else
			outputChatBox("#d75959[StrongMTA - Interior]: #ffffffItt nem használhatod a faltörő kost.", 255, 255, 255, true)
		end
	else
		outputChatBox("#d75959[StrongMTA - Interior]: #ffffffNem használhatod a faltörő kost.", 255, 255, 255, true)
	end
end

function knockOnDoorCommand()
	if standingMarker then
		local interiorId = tonumber(standingMarker[1])

		if interiorId then
			local int = availableInteriors[interiorId]

			if int then
				if int.type == "house" or int.type == "garage" or int.type == "rentable" then
					triggerServerEvent("useDoorKnocking", localPlayer, interiorId)
				else
					outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak házba vagy garázsba kopogtathatsz.", 255, 255, 255, true)
				end
			end
		end
	else
		outputChatBox("#d75959[StrongMTA - Interior]: #ffffffItt nem kopogtathatsz.", 255, 255, 255, true)
	end
end
addCommandHandler("kopogtat", knockOnDoorCommand)
addCommandHandler("kopog", knockOnDoorCommand)
addCommandHandler("kopogas", knockOnDoorCommand)
addCommandHandler("kopogás", knockOnDoorCommand)

function bellOnDoor()
	if standingMarker then
		local interiorId = tonumber(standingMarker[1])

		if interiorId then
			local int = availableInteriors[interiorId]

			if int then
				if int.type == "house" or int.type == "garage" or int.type == "rentable" then
					if getElementDimension(localPlayer) ~= 0 then
						outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak kintről csengethetsz be.", 255, 255, 255, true)
					else
						triggerServerEvent("useDoorBell", localPlayer, interiorId)
					end
				else
					outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak házba vagy garázsba csengethetsz.", 255, 255, 255, true)
				end
			end
		end
	else
		outputChatBox("#d75959[StrongMTA - Interior]: #ffffffItt nem csengethetsz.", 255, 255, 255, true)
	end
end
addCommandHandler("csenget", bellOnDoor)
addCommandHandler("csengetes", bellOnDoor)
addCommandHandler("csengetés", bellOnDoor)

addEvent("playRamSound", true)
addEventHandler("playRamSound", getRootElement(),
	function (interiorId)
		if interiorId then
			local int = availableInteriors[interiorId]

			if int then
				local soundElement = playSound3D("files/sounds/rammed.mp3", int.entrance.position[1], int.entrance.position[2], int.entrance.position[3])

				if isElement(soundElement) then
					setElementInterior(soundElement, int.entrance.interior)
					setElementDimension(soundElement, int.entrance.dimension)
					setSoundMaxDistance(soundElement, 200)
					setSoundVolume(soundElement, 1)
				end

				local soundElement = playSound3D("files/sounds/rammed.mp3", int.exit.position[1], int.exit.position[2], int.exit.position[3])

				if isElement(soundElement) then
					setElementInterior(soundElement, int.exit.interior)
					setElementDimension(soundElement, int.exit.dimension)
					setSoundMaxDistance(soundElement, 200)
					setSoundVolume(soundElement, 1)
				end

				if source == localPlayer then
					exports.sm_chat:localActionC(localPlayer, "betöri az ajtót.")
				end
			end
		end
	end)

addEvent("playKnocking", true)
addEventHandler("playKnocking", getRootElement(),
	function (interiorId)
		if interiorId then
			local int = availableInteriors[interiorId]

			if int then
				local soundElement = playSound3D("files/sounds/knock.mp3", int.entrance.position[1], int.entrance.position[2], int.entrance.position[3])

				if isElement(soundElement) then
					setElementInterior(soundElement, int.entrance.interior)
					setElementDimension(soundElement, int.entrance.dimension)
					setSoundMaxDistance(soundElement, 60)
					setSoundVolume(soundElement, 1)
				end

				local soundElement = playSound3D("files/sounds/knock.mp3", int.exit.position[1], int.exit.position[2], int.exit.position[3])

				if isElement(soundElement) then
					setElementInterior(soundElement, int.exit.interior)
					setElementDimension(soundElement, int.exit.dimension)
					setSoundMaxDistance(soundElement, 60)
					setSoundVolume(soundElement, 1)
				end
			end
		end
	end)

addEvent("playBell", true)
addEventHandler("playBell", getRootElement(),
	function (interiorId)
		if interiorId then
			local int = availableInteriors[interiorId]

			if int then
				local soundElement = playSound3D("files/sounds/bell.mp3", int.entrance.position[1], int.entrance.position[2], int.entrance.position[3])

				if isElement(soundElement) then
					setElementInterior(soundElement, int.entrance.interior)
					setElementDimension(soundElement, int.entrance.dimension)
					setSoundMaxDistance(soundElement, 160)
					setSoundVolume(soundElement, 1)
				end

				local soundElement = playSound3D("files/sounds/bell.mp3", int.exit.position[1], int.exit.position[2], int.exit.position[3])

				if isElement(soundElement) then
					setElementInterior(soundElement, int.exit.interior)
					setElementDimension(soundElement, int.exit.dimension)
					setSoundMaxDistance(soundElement, 160)
					setSoundVolume(soundElement, 1)
				end
			end
		end
	end)

function createInteriorObject(interiorId)
	if interiorId then
		local int = availableInteriors[interiorId]

		if int then
			if isElement(currentInteriorObject) then
				destroyElement(currentInteriorObject)
			end

			if int.gameInterior then
				local gameInterior = gameInteriors[int.gameInterior]

				if gameInterior and gameInterior.object then
					currentInteriorObject = createObject(gameInterior.object.objectId, gameInterior.object.position[1], gameInterior.object.position[2], gameInterior.object.position[3])

					if isElement(currentInteriorObject) then
						setElementInterior(currentInteriorObject, gameInterior.interior)
						setElementDimension(currentInteriorObject, int.exit.dimension)
					end
				end
			end
		end
	end
end

local iconPictures = {}

iconPictures.house = dxCreateTexture("files/icons/house.png")
iconPictures.houseforsale = dxCreateTexture("files/icons/houseforsale.png")
iconPictures.info = dxCreateTexture("files/icons/info.png")
iconPictures.info2 = dxCreateTexture("files/icons/info.png")
iconPictures.garage = dxCreateTexture("files/icons/garage.png")
iconPictures.garageforsale = dxCreateTexture("files/icons/garageforsale.png")
iconPictures.business = dxCreateTexture("files/icons/business.png")
iconPictures.rentabletolet = dxCreateTexture("files/icons/rentable.png")
iconPictures.rentable = dxCreateTexture("files/icons/rentable.png")
iconPictures.duty = dxCreateTexture("files/icons/duty.png")
iconPictures.barn = dxCreateTexture("files/icons/barn.png")
iconPictures.barn2 = dxCreateTexture("files/icons/barn2.png")

local iconColors = {}

iconColors.house = {89, 142, 215}
iconColors.houseforsale = {124, 197, 118}
iconColors.info = {220, 163, 0}
iconColors.garage = {89, 142, 215}
iconColors.garageforsale = {124, 197, 118}
iconColors.business = {220, 163, 0}
iconColors.info2 = {215, 89, 89}
iconColors.rentabletolet = {244, 184, 235}
iconColors.rentable = {99, 39, 90}
iconColors.duty = {60, 100, 70}
iconColors.barn = {124, 197, 118}
iconColors.barn2 = {197, 195, 118}

local coolMarkers = {}
local coolMarkersKeyed = {}
local nearbyMarkers = {}

function getIconByMarkerType(markerType)
	if iconPictures[markerType] then
		return iconPictures[markerType]
	end

	return iconPictures.house
end

function getInteriorMarkerType(markerType, state)
	local realType = ""

	if markerType == "business_passive" then
		realType = "business"
	elseif markerType == "business_active" then
		realType = "business"
	elseif markerType == "house" then
		if state == "sold" then
			realType = "house"
		else
			realType = "houseforsale"
		end
	elseif markerType == "building" then
		realType = "info"
	elseif markerType == "building2" then
		realType = "info2"
	elseif markerType == "garage" then
		if state == "sold" then
			realType = "garage"
		else
			realType = "garageforsale"
		end
	elseif markerType == "rentable" or "mechanicGarage" then
		if state == "sold" then
			realType = "rentable"
		else
			realType = "rentabletolet"
		end
	else
		return markerType
	end

	return realType
end

function createCoolMarker(posX, posY, posZ, markerType, state)
	markerType = getInteriorMarkerType(markerType, state)
	
	local markerId = #coolMarkers + 1
	local markerElement = createMarker(posX, posY, posZ - 1, "cylinder", 0.75, iconColors[markerType][1], iconColors[markerType][2], iconColors[markerType][3], 125)
	
	coolMarkers[markerId] = {markerElement, markerType}
	coolMarkersKeyed[markerElement] = markerId
	
	return markerElement
end

function setCoolMarkerType(markerElement, markerType, state)
	markerType = getInteriorMarkerType(markerType, state)

	local markerId = coolMarkersKeyed[markerElement]

	coolMarkers[markerId][2] = markerType

	setMarkerColor(coolMarkers[markerId][1], iconColors[markerType][1], iconColors[markerType][2], iconColors[markerType][3], 200)

	for i = 1, #nearbyMarkers do
		local marker = nearbyMarkers[i]

		if marker and (markerElement == marker[3] or marker == markerId) then
			marker[2] = markerType
			break
		end
	end

	return true
end

addEventHandler("onClientElementStreamIn", getResourceRootElement(),
	function ()
		if coolMarkersKeyed[source] then
			local markerId = coolMarkersKeyed[source]

			table.insert(nearbyMarkers, {markerId, coolMarkers[markerId][2], source})
		end
	end)

addEventHandler("onClientElementStreamOut", getResourceRootElement(),
	function ()
		if coolMarkersKeyed[source] then
			local markerId = coolMarkersKeyed[source]

			for i = 1, #nearbyMarkers do
				local marker = nearbyMarkers[i]

				if marker and (source == marker[3] or marker == markerId) then
					table.remove(nearbyMarkers, i)
					break
				end
			end
		end
	end)

addEventHandler("onClientElementDestroy", getResourceRootElement(),
	function ()
		if coolMarkersKeyed[source] then
			local markerId = coolMarkersKeyed[source]

			coolMarkers[markerId] = nil

			for i = 1, #nearbyMarkers do
				local marker = nearbyMarkers[i]

				if marker and (source == marker[3] or marker == markerId) then
					table.remove(nearbyMarkers, i)
					coolMarkersKeyed[source] = nil
					break
				end
			end
		end
	end)

addEventHandler("onClientRender", getRootElement(),
	function ()
		local cameraPosX, cameraPosY, cameraPosZ = getElementPosition(getCamera())
		local cameraInterior = getCameraInterior()
		local playerInterior = getElementInterior(localPlayer)

		if cameraInterior ~= playerInterior then
			setCameraInterior(playerInterior)
		end

		local size = 0.1 * getEasingValue(math.abs(getTickCount() % 5000 - 2500) / 2500, "SineCurve")

		for k = 1, #nearbyMarkers do
			local v = nearbyMarkers[k]

			if isElement(v[3]) then
				if getElementInterior(v[3]) == cameraInterior then
					local markerPosX, markerPosY, markerPosZ = getElementPosition(v[3])

					markerPosZ = markerPosZ + 1
					local typ = v[2]

					setMarkerSize(v[3], 1 + size)

					dxDrawMaterialLine3D(markerPosX, markerPosY, markerPosZ + 0.32 + size, markerPosX, markerPosY, markerPosZ - 0.32 + size, iconPictures[typ], 0.64, tocolor(iconColors[typ][1], iconColors[typ][2], iconColors[typ][3]))
				end
			end
		end
	end, true, "low-999"
)

local lastInteriorEdit = 0

addCommandHandler("edit",
	function ()
		if interiorsLoaded and standingMarker then
			local interiorId = tonumber(standingMarker[1])
			local colShapeType = tostring(standingMarker[2])

			if interiorId and colShapeType == "entrance" then
				local int = availableInteriors[interiorId]

				if int then
					if int.editable ~= "N" then
						local characterId = tonumber(getElementData(localPlayer, "char.ID"))

						if int.ownerId == characterId then
							if getTickCount() >= lastInteriorEdit + 5000 then
								triggerServerEvent("editInterior", localPlayer, interiorId)
								lastInteriorEdit = getTickCount()
							else
								outputChatBox("#d75959[StrongMTA - Interior]: #ffffffCsak 5 másodpercenként használhatod ezt a parancsot.", 255, 255, 255, true)
							end
						else
							outputChatBox("#d75959[StrongMTA - Interior]: #ffffffEz az ingatlan nem a te tulajdonod.", 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[StrongMTA - Interior]: #ffffffEz nem szerkeszthető interior.", 255, 255, 255, true)
					end
				end
			end
		end
	end)
bindKey("Z", "down", "edit")