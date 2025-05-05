local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local placedATM = false
local bankElement = false

local panelState = false
local panelFont = false

local panelWidth = respc(500)
local panelHeight = respc(240)

local panelPosX = screenX / 2 - panelWidth / 2
local panelPosY = screenY / 2 - panelHeight / 2

local activeButton = false
local buttons = {
	["withdraw"] = {
		panelPosX + respc(5),
		panelPosY + panelHeight - respc(80),
		panelWidth / 2 - respc(10),
		respc(30)
	},
	["deposit"] = {
		panelPosX + panelWidth / 2 + respc(5),
		panelPosY + panelHeight - respc(80),
		panelWidth / 2 - respc(10),
		respc(30)
	},
	["exit"] = {
		panelPosX + respc(5),
		panelPosY + panelHeight - respc(40),
		panelWidth - respc(10),
		respc(30)
	}
}

local currentMoney = 0
local currentBalance = 0
local selectedAmount = ""

local cursorState = false
local cursorStateChange = 0
local clickTick = 0

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if getElementData(localPlayer, "openingMoneyCasette") then
			setElementData(localPlayer, "openingMoneyCasette", false)
		end
	end
)

addCommandHandler("createatm",
	function (commandName)
		if getElementData(localPlayer, "acc.adminLevel") >= 9 then
			if not placedATM then
				if isElement(placedATM) then
					destroyElement(placedATM)
				end

				placedATM = createObject(2942, 0, 0, 0)

				setElementCollisionsEnabled(placedATM, false)
				setElementAlpha(placedATM, 175)
				setElementInterior(placedATM, getElementInterior(localPlayer))
				setElementDimension(placedATM, getElementDimension(localPlayer))

				addEventHandler("onClientRender", getRootElement(), renderATMPlacement)
			else
				removeEventHandler("onClientRender", getRootElement(), renderATMPlacement)

				if isElement(placedATM) then
					destroyElement(placedATM)
				end

				placedATM = nil
			end
		end
	end
)

addCommandHandler("nearbyatm",
	function (commandName)
		if getElementData(localPlayer, "acc.adminLevel") >= 9 then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local objectsTable = getElementsByType("object", getRootElement(), true)

			outputChatBox("#3d7abc------[Közeledben lévő ATM-ek]------", 255, 255, 255, true)

			for i = 1, #objectsTable do
				local objectElement = objectsTable[i]

				if isElement(objectElement) then
					if getElementModel(objectElement) == 2942 then
						local bankId = getElementData(objectElement, "bankId")

						if bankId then
							local objectX, objectY, objectZ = getElementPosition(objectElement)
							local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, objectX, objectY, objectZ)

							outputChatBox("  #" .. bankId .. " Távolság:#32b3ef " .. math.floor(distance * 1000) / 1000, 255, 255, 255, true)
						end
					end
				end
			end
		end
	end
)

function renderATMPlacement()
	if placedATM then
		local currentX, currentY, currentZ = getElementPosition(localPlayer)
		local currentRotation = select(3, getElementRotation(localPlayer))

		currentZ = currentZ - 0.35
		currentRotation = math.floor(currentRotation / 5) * 5

		setElementPosition(placedATM, currentX, currentY, currentZ)
		setElementRotation(placedATM, 0, 0, currentRotation)

		if getKeyState("lalt") then
			local currentInterior = getElementInterior(placedATM)
			local currentDimension = getElementDimension(placedATM)

			triggerServerEvent("placeATM", localPlayer, {currentX, currentY, currentZ, currentRotation, currentInterior, currentDimension})

			if isElement(placedATM) then
				destroyElement(placedATM)
			end

			placedATM = nil

			removeEventHandler("onClientRender", getRootElement(), renderATMPlacement)
		end
	end
end

addEventHandler("onClientObjectBreak", getRootElement(),
	function ()
		if getElementModel(source) == 2942 then
			cancelEvent()
		elseif getElementModel(source) == 2943 then
			cancelEvent()
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, absX, absY, worldX, worldY, worldZ, clickedElement)
		if not panelState then
			if button == "right" then
				if state == "up" then
					if isElement(clickedElement) then
						if getElementData(clickedElement, "bankId") then
							local playerX, playerY, playerZ = getElementPosition(localPlayer)
							local targetX, targetY, targetZ = getElementPosition(clickedElement)

							if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 5 then
								if not isPedInVehicle(localPlayer) then
									local elementType = getElementType(clickedElement)

									bankElement = clickedElement

									if elementType == "ped" then
										--togglePanel(true, false)
									elseif elementType == "object" then
										if getElementModel(clickedElement) ~= 2943 then
											if not getElementData(clickedElement, "isRobbed") then
												clickOnAtm()
												--togglePanel(true, true)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		else
			if button == "left" then
				if state == "up" then
					if activeButton == "exit" then
						togglePanel(false)
					else
						if getTickCount() >= clickTick + 5000 then
							if isElement(bankElement) then
								local playerX, playerY, playerZ = getElementPosition(localPlayer)
								local targetX, targetY, targetZ = getElementPosition(bankElement)

								if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 5 then
									if not isPedInVehicle(localPlayer) then
										local amount = tonumber(selectedAmount)

										if amount then
											amount = math.floor(amount)

											if amount > 0 then
												if activeButton == "withdraw" then
													if amount <= currentBalance then
														triggerServerEvent("withdrawMoney", localPlayer, amount)
													else
														exports.sm_accounts:showInfo("e", "Nincs ennyi pénz a bankszámládon!")
													end
												elseif activeButton == "deposit" then
													if amount <= currentMoney then
														triggerServerEvent("depositMoney", localPlayer, amount)
													else
														exports.sm_accounts:showInfo("e", "Nincs ennyi pénz nálad!")
													end
												end
											else
												exports.sm_accounts:showInfo("e", "Inkább maradjunk az egész, nullánál nagyobb számoknál!")
											end
										else
											exports.sm_accounts:showInfo("e", "Nem gondolod, hogy meg kellene adnod valamilyen számot?")
										end
									else
										exports.sm_accounts:showInfo("e", "Azért ennyire ne legyél vagány, hogy járműből akard használni a panelt!")
									end
								else
									exports.sm_accounts:showInfo("e", "Na, na! Ott használd ahol megnyitottad a panelt!")
								end
							end

							clickTick = getTickCount()
						else
							exports.sm_accounts:showInfo("e", "Csak 5 másodpercenként használhatod ezt a funkciót!")
						end
					end
				end
			end
		end
	end
)

function processDataChange(dataName)
	if dataName == "char.bankMoney" then
		currentBalance = getElementData(localPlayer, dataName) or 0
	elseif dataName == "char.Money" then
		currentMoney = getElementData(localPlayer, dataName) or 0
	end
end

function processInputCharacter(character)
	if utfLen(selectedAmount) < 10 then
		if string.find(character, "[0-9]") then
			selectedAmount = selectedAmount .. character
		end
	end
end

function processInputKey(key, press)
	if press then
		if key == "backspace" then
			if utfLen(selectedAmount) >= 1 then
				selectedAmount = utfSub(selectedAmount, 1, -2)
			end
		elseif key ~= "escape" then
			cancelEvent()
		end
	end
end

function formatNumber(amount, stepper)
	amount = tonumber(amount)

	if not amount then
		return ""
	end

	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

local robbedATMs = {}

addEventHandler("onClientElementStreamIn", getResourceRootElement(),
	function ()
		if getElementData(source, "isRobbed") then
			robbedATMs[source] = true
		end
	end
)

addEventHandler("onClientElementStreamOut", getResourceRootElement(),
	function ()
		robbedATMs[source] = nil
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "isRobbed" then
			if isElementStreamedIn(source) then
				if getElementData(source, "isRobbed") then
					robbedATMs[source] = true
				else
					robbedATMs[source] = nil
				end
			end
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		local cameraX, cameraY, cameraZ = getCameraMatrix()

		for k in pairs(robbedATMs) do
			local objectX, objectY, objectZ = getElementPosition(k)
			local distance = getDistanceBetweenPoints3D(objectX, objectY, objectZ + 1.5, cameraX, cameraY, cameraZ)

			if distance < 20 then
				local sightClear = isLineOfSightClear(cameraX, cameraY, cameraZ, objectX, objectY, objectZ + 1.5, true, false, false, true, false, true, false)

				if sightClear then
					local guiX, guiY = getScreenFromWorldPosition(objectX, objectY, objectZ + 1.5)

					if guiX and guiY then
						local scaleFactor = 1 - distance / 25
						local alphaFactor = 1 - distance / 20

						local imageWidth = 128 * scaleFactor * 0.75
						local imageHeight = 256 * scaleFactor * 0.75

						dxDrawImage(guiX - imageWidth / 2, guiY - imageHeight / 2, imageWidth, imageHeight, "files/outoforder.png", 0, 0, 0, tocolor(215, 89, 89, 255 * alphaFactor))
					end
				end
			end
		end
	end
)

local currentATM = false
local currentATMObject = false
local currentATMPosition = false

local minimumOfficer = 1
local animControls = false

local atmDefaultHealth = 1000

local grindingState = false
local grindingATMObject = false
local grindingATMHealth = 0
local grindingProgress = 0
local grindingTick = 0
local grindingPlayers = {}
local grindingStarted = {}

local sparkEffects = {}
local sparkSounds = {}

addEventHandler("onClientPlayerQuit", getRootElement(),
	function ()
		if isElement(sparkEffects[source]) then
			destroyElement(sparkEffects[source])
		end

		sparkEffects[source] = nil

		if isElement(sparkSounds[source]) then
			destroyElement(sparkSounds[source])
		end

		sparkSounds[source] = nil

		grindingPlayers[source] = nil
		grindingStarted[source] = nil
	end
)

function setGrinding(newState)
	if newState then
		if getTickCount() - clickTick < 1000 then
			exports.sm_hud:showInfobox("e", "Várj egy kicsit!")
			return
		end

		clickTick = getTickCount()
	end

	if newState ~= grindingState then
		local streamedPlayers = getElementsByType("player", getRootElement(), true)

		triggerServerEvent("startATMGrinding", localPlayer, streamedPlayers, newState, currentATMObject, grindingProgress)

		if newState then
			exports.sm_chat:localActionC(localPlayer, "elkezdett flexelni.")
		else
			exports.sm_chat:localActionC(localPlayer, "befejezte a flexelést.")
		end

		grindingState = newState
	end
end

function atmRobKeyHandler(key, press)
	if not isCursorShowing() then
		if getElementModel(currentATMObject) == 2943 then
			if key == "mouse1" then
				if press then
					triggerServerEvent("requestATMCompartments", localPlayer, currentATMObject)
					cancelEvent()
				end
			end
		else
			if getElementData(localPlayer, "usingGrinder") then
				if key == "mouse1" then
					cancelEvent()

					if press then
						local playersTable = getElementsByType("player")
						local officerCount = 0

						for i = 1, #playersTable do
							local playerElement = playersTable[i]

							if isElement(playerElement) then
								if exports.sm_groups:isPlayerInGroup(playerElement, {1, 12, 13, 26}) then
									officerCount = officerCount + 1

									if officerCount >= minimumOfficer then
										break
									end
								end
							end
						end

						if officerCount < minimumOfficer then
							exports.sm_hud:showInfobox("e", "Minimum " .. minimumOfficer .. " darab online rendvédelmis szükséges a rabláshoz.")
							return
						end

						if not exports.sm_groups:isPlayerHavePermission(localPlayer, "canRobATM") then
							exports.sm_hud:showInfobox("e", "Csak illegális frakciók tagjai tudják kirabolni az ATM-et.")
							return
						end
					end

					setGrinding(press)
				end
			end
		end
	end
end

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (enterPlayer, sameDimension)
		if enterPlayer == localPlayer then
			if sameDimension then
				if isElement(source) then
					local atmRobID = getElementData(source, "atmRobID")

					if atmRobID then
						if not isPedInVehicle(localPlayer) then
							if not currentATM then
								currentATM = atmRobID
								currentATMObject = getElementData(source, "atmRobObject")
								currentATMPosition = {getElementPosition(source)}

								addEventHandler("onClientKey", getRootElement(), atmRobKeyHandler)
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (leftPlayer, sameDimension)
		if leftPlayer == localPlayer then
			if sameDimension then
				if isElement(source) then
					local atmRobID = getElementData(source, "atmRobID")

					if atmRobID then
						if currentATM then
							setGrinding(false)
							currentATM = false

							removeEventHandler("onClientKey", getRootElement(), atmRobKeyHandler)

							if animControls then
								exports.sm_controls:toggleControl({"fire", "jump", "crouch", "sprint", "aim_weapon", "enter_exit"}, true)

								removeEventHandler("onClientRender", getRootElement(), robATMGuiRender)
								removeEventHandler("onClientClick", getRootElement(), clickATMRobGui)

								setElementFrozen(localPlayer, false)
								animControls = false
							end
						end
					end
				end
			end
		end
	end
)

function robStartATMRender()
	grindingProgress = math.floor(grindingATMHealth - (getTickCount() - grindingTick) / 10)

	if grindingProgress < 0 then
		grindingProgress = 0

		if animControls then
			removeEventHandler("onClientRender", getRootElement(), robStartATMRender)

			exports.sm_controls:toggleControl({"fire", "jump", "crouch", "sprint", "aim_weapon", "enter_exit"}, true)

			animControls = false
		end

		setGrinding(false)
	end

	if getElementHealth(localPlayer) <= 0 or isPedInVehicle(localPlayer) then
		setGrinding(false)
	end

	local guiX, guiY = getScreenFromWorldPosition(currentATMPosition[1], currentATMPosition[2], currentATMPosition[3] + 0.5)

	if guiX and guiY then
		dxDrawRectangle(guiX - 80 - 4, guiY - 4, 168, 18, tocolor(0, 0, 0, 150))
		dxDrawRectangle(guiX - 80, guiY, 160, 10, tocolor(0, 0, 0, 150))
		dxDrawRectangle(guiX - 80, guiY, 160 * (grindingProgress / atmDefaultHealth), 10, tocolor(124, 197, 118))
	end
end

addEvent("syncSpark", true)
addEventHandler("syncSpark", getRootElement(),
	function (state, objectElement, healthLevel)
		if source == localPlayer then
			if not healthLevel then
				healthLevel = atmDefaultHealth
			end

			grindingProgress = atmDefaultHealth
			grindingATMObject = objectElement
			grindingATMHealth = healthLevel
			grindingTick = getTickCount()

			if state then
				if not animControls then
					addEventHandler("onClientRender", getRootElement(), robStartATMRender)

					exports.sm_controls:toggleControl({"fire", "jump", "crouch", "sprint", "aim_weapon", "enter_exit"}, false)

					animControls = true
				end
			else
				if animControls then
					removeEventHandler("onClientRender", getRootElement(), robStartATMRender)

					exports.sm_controls:toggleControl({"fire", "jump", "crouch", "sprint", "aim_weapon", "enter_exit"}, true)

					animControls = false
				end
			end
		end

		grindingPlayers[source] = state

		if state then
			local currentX, currentY, currentZ = getElementPosition(source)

			playSound3D("files/grinder_start.mp3", currentX, currentY, currentZ)
			grindingStarted[source] = true

			setTimer(
				function (sourcePlayer, playerX, playerY, playerZ)
					if grindingStarted[sourcePlayer] then
						local boneX, boneY, boneZ = getPedBonePosition(sourcePlayer, 25)
						local playerRotation = select(3, getElementRotation(sourcePlayer))
						local effectX, effectY = rotateAround(45 + playerRotation, 0.1, 0.1, boneX, boneY)

						sparkSounds[sourcePlayer] = playSound3D("files/grinder.mp3", boneX, boneY, boneZ, true)
						sparkEffects[sourcePlayer] = createEffect("prt_spark", effectX, effectY, boneZ + 0.2, 0, 0, -playerRotation + 180 - 60)
					end
				end,
			450, 1, source, currentX, currentY, currentZ)
		else
			if isElement(sparkEffects[source]) then
				local currentX, currentY, currentZ = getElementPosition(source)

				playSound3D("files/grinder_stop.mp3", currentX, currentY, currentZ)
				destroyElement(sparkEffects[source])

				if isElement(sparkSounds[source]) then
					setTimer(stopSound, 250, 1, sparkSounds[source])
					setTimer(
						function (sourcePlayer)
							grindingPlayers[sourcePlayer] = nil
							setPedAnimation(sourcePlayer, false)
						end,
					300, 1, source)
				end

				grindingStarted[source] = nil
				sparkEffects[source] = nil
			else
				grindingStarted[source] = nil
				setPedAnimation(source, false)
			end
		end
	end
)

function rotateAround(angle, x1, y1, x2, y2)
	angle = math.rad(angle)

	local rotatedX = x1 * math.cos(angle) - y1 * math.sin(angle)
	local rotatedY = x1 * math.sin(angle) + y1 * math.cos(angle)

	return rotatedX + (x2 or 0), rotatedY + (y2 or 0)
end

local atmRobCompartments = {}

addEvent("showRobGui", true)
addEventHandler("showRobGui", getRootElement(),
	function (compartments)
		atmRobCompartments = compartments

		if not animControls then
			exports.sm_controls:toggleControl({"fire", "jump", "crouch", "sprint", "aim_weapon", "enter_exit"}, false)

			addEventHandler("onClientRender", getRootElement(), robATMGuiRender)
			addEventHandler("onClientClick", getRootElement(), clickATMRobGui)

			setElementFrozen(localPlayer, true)
			animControls = true
		end
	end
)

addEvent("atmCompartmentSound", true)
addEventHandler("atmCompartmentSound", getRootElement(),
	function (objectElement, compartmentId)
		local playerX, playerY, playerZ = getElementPosition(source)

		playSound3D("files/rob.mp3", playerX, playerY, playerZ)

		if source == localPlayer then
			if objectElement == currentATMObject then
				atmRobCompartments[compartmentId] = true
			end
		end
	end
)

function clickATMRobGui(button, state, absX, absY)
	if state == "up" then
		local x = math.floor(screenX / 2 - 510 / 2)
		local y = math.floor(screenY / 2 - 203 / 2)

		if exports.sm_core:isInSlot(x + 510 - 20, y, 20, 20) then
			if animControls then
				exports.sm_controls:toggleControl({"fire", "jump", "crouch", "sprint", "aim_weapon", "enter_exit"}, true)

				removeEventHandler("onClientRender", getRootElement(), robATMGuiRender)
				removeEventHandler("onClientClick", getRootElement(), clickATMRobGui)

				setElementFrozen(localPlayer, false)
				animControls = false
			end
		end

		if getTickCount() - clickTick > 2000 then
			local playersTable = getElementsByType("player", getRootElement(), true)
			
			if not atmRobCompartments[1] and exports.sm_core:isInSlot(x + 6, y + 38, 242 - 4, 71 - 4) then
				triggerServerEvent("openATMCompartment", localPlayer, playersTable, currentATMObject, 1)
				exports.sm_chat:localActionC(localPlayer, "kivesz egy pénzkazettát az ATM-ből.")
			end

			if not atmRobCompartments[2] and exports.sm_core:isInSlot(x + 6, y + 122, 242 - 4, 79 - 4) then
				triggerServerEvent("openATMCompartment", localPlayer, playersTable, currentATMObject, 2)
				exports.sm_chat:localActionC(localPlayer, "kivesz egy pénzkazettát az ATM-ből.")
			end

			if not atmRobCompartments[3] and exports.sm_core:isInSlot(x + 264, y + 38, 242 - 4, 71 - 4) then
				triggerServerEvent("openATMCompartment", localPlayer, playersTable, currentATMObject, 3)
				exports.sm_chat:localActionC(localPlayer, "kivesz egy pénzkazettát az ATM-ből.")

			end

			if not atmRobCompartments[4] and exports.sm_core:isInSlot(x + 264, y + 122, 242 - 4, 79 - 4) then
				triggerServerEvent("openATMCompartment", localPlayer, playersTable, currentATMObject, 4)
				exports.sm_chat:localActionC(localPlayer, "kivesz egy pénzkazettát az ATM-ből.")
			end

			clickTick = getTickCount()
		end
	end
end

function robATMGuiRender()
	local x = math.floor(screenX / 2 - 510 / 2)
	local y = math.floor(screenY / 2 - 203 / 2)

	dxDrawImage(x, y, 510, 203, "files/atm_rob.png")

	if not atmRobCompartments[1] then
		dxDrawImage(x + 6, y + 38, 242 - 4, 71 - 4, "files/atm_rob2.png")
	end

	if not atmRobCompartments[2] then
		dxDrawImage(x + 6, y + 122, 242 - 4, 79 - 4, "files/atm_rob2.png")
	end

	if not atmRobCompartments[3] then
		dxDrawImage(x + 264, y + 38, 242 - 4, 71 - 4, "files/atm_rob2.png")
	end

	if not atmRobCompartments[4] then
		dxDrawImage(x + 264, y + 122, 242 - 4, 79 - 4, "files/atm_rob2.png")
	end
end

local balance = {}

addEvent("startMoneyCasetteOpen", true)
addEventHandler("startMoneyCasetteOpen", getRootElement(),
	function ()
		setMinigameState(true)
		exports.sm_chat:localActionC(localPlayer, "elkezd felfeszíteni egy pénzkazettát.")
	end
)

function setMinigameState(state)
	if balance.state ~= state then
		balance.state = state

		setElementData(localPlayer, "openingMoneyCasette", state)

		if state then
			balance.startTime = getTickCount()
			balance.endTime = balance.startTime + 20000
			balance.direction = false
			balance.keyType = false
			balance.rotation = math.random(0, 1) == 0 and -15 or 15
			balance.acceleration = math.random(0, 1) == 0 and -0.3 or 0.3
			balance.accelerationMultipler = 30

			toggleControl("left", false)
			toggleControl("right", false)

			bindKey("a", "both", minigameMoveHandler)
			bindKey("arrow_l", "both", minigameMoveHandler)

			bindKey("d", "both", minigameMoveHandler)
			bindKey("arrow_r", "both", minigameMoveHandler)

			addEventHandler("onClientRender", getRootElement(), renderBalanceMinigame)
			addEventHandler("onClientPreRender", getRootElement(), balanceMovementRender)
		else
			removeEventHandler("onClientRender", getRootElement(), renderBalanceMinigame)
			removeEventHandler("onClientPreRender", getRootElement(), balanceMovementRender)

			toggleControl("left", true)
			toggleControl("right", true)

			unbindKey("a", "both", minigameMoveHandler)
			unbindKey("arrow_l", "both", minigameMoveHandler)

			unbindKey("d", "both", minigameMoveHandler)
			unbindKey("arrow_r", "both", minigameMoveHandler)
		end
	end
end

function minigameMoveHandler(button, state)
	if state == "down" then
		if not balance.direction then
			local rand = math.random(9, 10) / 10

			balance.keyType = button

			if button == "a" or button == "arrow_l" then
				balance.direction = -0.175 * balance.accelerationMultipler * rand
			elseif button == "d" or button == "arrow_r" then
				balance.direction = 0.175 * balance.accelerationMultipler * rand
			end

			balance.accelerationMultipler = balance.accelerationMultipler + 0.2
		end
	elseif state == "up" then
		if balance.direction then
			if balance.keyType == button then
				balance.direction = nil
				balance.keyType = nil
			end
		end
	end
end

function renderBalanceMinigame()
	if balance.state then
		local theX = screenX / 2
		local theY = screenY / 2

		dxDrawImage(theX - 256, 294, 512, 512, "files/arch.png")
		dxDrawImage(theX - 256, 294, 512, 512, "files/pointer.png", balance.rotation)

		local elapsedTime = getTickCount() - balance.startTime
		local duration = balance.endTime - balance.startTime
		local progress = elapsedTime / duration

		local r, g, b = interpolateBetween(215, 89, 89, 97, 149, 49, progress, "Linear")

		if progress > 1 then
			progress = 1

			balanceMinigameSuccess()
		end

		dxDrawRectangle(theX - 150 - 2, 485 - 2, 300 + 4, 25 + 4, tocolor(25, 25, 25))
		dxDrawRectangle(theX - 150, 485, 300, 25, tocolor(25, 25, 25))
		dxDrawRectangle(theX - 150, 485, 300 * progress, 25, tocolor(r, g, b))
	end
end

function balanceMovementRender(deltaTime)
	if balance.state then
		if getTickCount() - balance.startTime > 1000 then
			if math.abs(balance.rotation) < 50 then
				if balance.direction then
					balance.acceleration = balance.acceleration + balance.direction * 0.5
				end

				balance.acceleration = balance.acceleration + balance.rotation / 780
				balance.rotation = balance.rotation + balance.acceleration * deltaTime / 100

				if balance.rotation == 0 then
					balance.rotation = math.random(0, 1) == 0 and -1 or 1
				end
			else
				balanceMinigameFail()
			end
		end
	end
end

function balanceMinigameFail()
	setMinigameState(false)

	triggerEvent("addGreenSplatter", localPlayer, math.random(11, 16))

	setElementFrozen(localPlayer, false)
	setElementData(localPlayer, "paintOnPlayerFace", {true})

	exports.sm_chat:sendLocalDoC(localPlayer, "A pénzkazetta felrobbant.")

	outputChatBox("#d75959[StrongMTA - ATM]: #ffffffNem sikerült kinyitni a kazettát, ezért #d75959felrobbant a festékpatron#ffffff.", 255, 255, 255, true)
	outputChatBox("#d75959[StrongMTA - ATM]: #ffffffA #bfff00festék#ffffff 3 órán át látható lesz az arcodon.", 255, 255, 255, true)
end

function balanceMinigameSuccess()
	setMinigameState(false)
	setElementFrozen(localPlayer, false)

	local casetteMoney = math.random(500, 1500)

	if math.random(1, 4) == 2 then
		casetteMoney = 0
	end

	if casetteMoney == 0 then
		outputChatBox("#3d7abc[StrongMTA - ATM]: #ffffffKinyitottad a kazettát, de sajnos #d75959üres#ffffff volt.", 255, 255, 255, true)
	else
		outputChatBox("#3d7abc[StrongMTA - ATM]: #ffffffKinyitottad a kazettát, és #3d7abc" .. casetteMoney .. " $#ffffff volt benne.", 255, 255, 255, true)
	end

	exports.sm_chat:sendLocalDoC(localPlayer, "A pénzkazetta kinyílt.")

	triggerServerEvent("giveCasetteMoney", localPlayer, casetteMoney)
end
