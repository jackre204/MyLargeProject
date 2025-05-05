local screenX, screenY = guiGetScreenSize()

pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local currentMarkerType = false
local currentMarkerId = false
local inColShape = false
local panelState = false
local panelFont = false
local panelMargin = 3

local selectedSkin = 1
local skinsTable = false
local previewPed = false
local lastDimension = false

local cameraZ = 0
local cameraZoom = 3

local buySkinTick = 0

function createFonts()
	destroyFonts()
	panelFont = dxCreateFont("files/Roboto.ttf", 12, false, "antialiased")
end

function destroyFonts()
	if isElement(panelFont) then
		destroyElement(panelFont)
	end
	panelFont = nil
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for k, v in pairs(availableShops) do
			if v[1] and v[2] and v[3] and v[4] then
				local markerElement = createMarker(v[1], v[2], v[3], "cylinder", 2, 61, 122, 188, 155)

				if isElement(markerElement) then
					local colShapeElement = createColSphere(v[1], v[2], v[3] + 1, 1.5)

					if isElement(colShapeElement) then
						setElementData(colShapeElement, "marker.type", v[7], false)
						setElementData(colShapeElement, "marker.shopId", k, false)
						setElementData(markerElement, "3DText", v[7] .. " ruhák")

						setElementInterior(markerElement, v[5])
						setElementDimension(markerElement, v[6])
						setElementInterior(colShapeElement, v[5])
						setElementDimension(colShapeElement, v[6])
					end
				end
			end
		end
	end
)

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if matchingDimension then
			if hitElement == localPlayer then
				if not isPedInVehicle(localPlayer) then
					currentMarkerType = getElementData(source, "marker.type")
					if currentMarkerType then
						local markerShopId = getElementData(source, "marker.shopId")
						if markerShopId then
							if availableShops[markerShopId] then
								currentMarkerId = markerShopId
								exports.sm_hud:showInfobox("i", "Nyomj [E] gombot a kínálat megtekintéséhez.")
								inColShape = true
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if isElement(hitElement) then
			if matchingDimension then
				if getElementType(hitElement) == "player" then
					if hitElement == localPlayer then
						currentMarkerType = false
						currentMarkerId = false
						inColShape = false
					end
				end
			end
		end
	end
)

function closePanel()
	if panelState then
		panelState = false
		destroyFonts()
		showCursor(false)

		setElementFrozen(localPlayer, false)
		triggerServerEvent("setPlayerDimensionForBinco", localPlayer, lastDimension or 0)
		setCameraTarget(localPlayer)
		setElementAlpha(localPlayer, 255)

		if isElement(previewPed) then
			destroyElement(previewPed)
		end
		previewPed = nil
	end
end

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if key == "e" and not press then
			if not panelState and inColShape then
				local selectedShop = availableShops[currentMarkerId]

				selectedSkin = 1
				skinsTable = getSkinsByType(currentMarkerType)

				if skinsTable and skinsTable[selectedSkin] and skinsTable[selectedSkin][1] then
					previewPed = createPed(skinsTable[selectedSkin][1], selectedShop[1], selectedShop[2], selectedShop[3] + 1, selectedShop[4], false)
					
					if isElement(previewPed) then
						local newDimension = getElementData(localPlayer, "playerID") + 3000

						setElementDimension(previewPed, newDimension)
						setElementInterior(previewPed, getElementInterior(localPlayer))

						lastDimension = getElementDimension(localPlayer)

						triggerServerEvent("setPlayerDimensionForBinco", localPlayer, newDimension)
						setElementAlpha(localPlayer, 0)
						setElementFrozen(localPlayer, true)

						showCursor(true)
						createFonts()
						panelState = true
					end
				end
			end
		elseif key == "backspace" and not press then
			closePanel()
		elseif press then
			if key == "mouse_wheel_up" then
				if panelState then
					if cameraZoom - 0.1 > 1 then
						cameraZoom = cameraZoom - 0.1
					end
				end
			elseif key == "mouse_wheel_down" then
				if panelState then
					if cameraZoom + 0.1 < 6 then
						cameraZoom = cameraZoom + 0.1
					end
				end
			end
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if panelState then
			buttonsC = {}

			local absX, absY = 0, 0
			if isCursorShowing() then
				local relX, relY = getCursorPosition()

				absX = screenX * relX
				absY = screenY * relY
			end

			local buttonWidth, buttonHeight = 150, 50
			local buttonPosX = screenX / 2 - 400
			local buttonPosY = screenY / 2 - 25

			-- Előző skin
			local buttonColor = tocolor(0, 0, 0, 200)
			local textColor = tocolor(255, 255, 255)
			if absX >= buttonPosX and absY >= buttonPosY and absX <= buttonPosX + buttonWidth and absY <= buttonPosY + buttonHeight then
				buttonColor = tocolor(124, 197, 118, 200)
				textColor = tocolor(0, 0, 0)
			end

			dxDrawRectangle(buttonPosX, buttonPosY, buttonWidth, buttonHeight, tocolor(25, 25, 25)) -- háttér
			drawButton("elozo", "Előző", buttonPosX + 4, buttonPosY + 4, buttonWidth - 8, buttonHeight - 8, {61, 122, 188}, false, panelFont, true)

			buttonPosX = screenX / 2 + 250

			-- Következő skin
			local buttonColor = tocolor(0, 0, 0, 200)
			local textColor = tocolor(255, 255, 255)
			if absX >= buttonPosX and absY >= buttonPosY and absX <= buttonPosX + buttonWidth and absY <= buttonPosY + buttonHeight then
				buttonColor = tocolor(124, 197, 118, 200)
				textColor = tocolor(0, 0, 0)
			end
			dxDrawRectangle(buttonPosX, buttonPosY, buttonWidth, buttonHeight, tocolor(25, 25, 25)) -- háttér
			drawButton("kovetkezo", "Következő", buttonPosX + 4, buttonPosY + 4, buttonWidth - 8, buttonHeight - 8, {61, 122, 188}, false, panelFont, true)

			--dxDrawText("Következő", buttonPosX, buttonPosY, buttonPosX + buttonWidth, buttonPosY + buttonHeight, textColor, 1, panelFont, "center", "center")

			buttonWidth, buttonHeight = 200, 50
			buttonPosX = screenX / 2 - 100
			buttonPosY = screenY - 175

			-- Megvétel
			local buttonColor = tocolor(0, 0, 0, 200)
			local textColor = tocolor(255, 255, 255)
			local buttonText = "Vásárlás"
			if absX >= buttonPosX and absY >= buttonPosY and absX <= buttonPosX + buttonWidth and absY <= buttonPosY + buttonHeight then
				buttonColor = tocolor(124, 197, 118, 200)
				textColor = tocolor(0, 0, 0)
				buttonText = "Ár: " .. skinsTable[selectedSkin][2] .. "$"
			end
			dxDrawRectangle(buttonPosX, buttonPosY, buttonWidth, buttonHeight, tocolor(25, 25, 25)) -- háttér
			drawButton("buy", buttonText, buttonPosX + 4, buttonPosY + 4, buttonWidth - 8, buttonHeight - 8, {61, 122, 188}, false, panelFont, true)
			--dxDrawText(buttonText, buttonPosX, buttonPosY, buttonPosX + buttonWidth, buttonPosY + buttonHeight, textColor, 1, panelFont, "center", "center")

			-- Bezárás
			dxDrawText("A kilépéshez nyomd meg a 'backspace' gombot. Forgatás: ⬌. Kamera: ⬍", 0 + 1, screenY - 200 + 1, screenX + 1, screenY + 1, tocolor(0, 0, 0), 1, panelFont, "center", "center")
			dxDrawText("A kilépéshez nyomd meg a 'backspace' gombot. Forgatás: ⬌. Kamera: ⬍", 0, screenY - 200, screenX, screenY, tocolor(255, 255, 255), 1, panelFont, "center", "center")

			-- Ped forgatása
			if isElement(previewPed) then
				local pedRotX, pedRotY, pedRotZ = getElementRotation(previewPed)

				if getKeyState("arrow_l") then
					pedRotZ = pedRotZ + 2
					setElementRotation(previewPed, pedRotX, pedRotY, pedRotZ)
				end

				if getKeyState("arrow_r") then
					pedRotZ = pedRotZ - 2
					setElementRotation(previewPed, pedRotX, pedRotY, pedRotZ)
				end

				if getKeyState("arrow_u") then
					if cameraZ + 0.05 < 1.5 then
						cameraZ = cameraZ + 0.05
					end
				end

				if getKeyState("arrow_d") then
					if cameraZ - 0.05 > -1.5 then
						cameraZ = cameraZ - 0.05
					end
				end
			end

			local pedPosX, pedPosY, pedPosZ = getElementPosition(previewPed)
			local selectedShop = availableShops[currentMarkerId]

			setCameraMatrix(
				pedPosX + math.cos(math.rad(selectedShop[4] + 90)) * cameraZoom,
				pedPosY + math.sin(math.rad(selectedShop[4] + 90)) * cameraZoom,
				pedPosZ + 1.5,
				pedPosX,
				pedPosY,
				pedPosZ + cameraZ
			)

			local cx, cy = getCursorPosition()

			activeButton = false
			activeButtonC = false
		
			if cx then
				cx = cx * screenX
				cy = cy * screenY
		
		
				for k, v in pairs(buttonsC) do
					if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
						activeButtonC = k
						break
					end
				end
			end	
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, absoluteX, absoluteY)
		if panelState then
			if button == "left" then
				if state == "up" then
					if absoluteX >= screenX / 2 - 405 and absoluteX <= screenX / 2 - 245 and absoluteY >= screenY / 2 - 30 and absoluteY <= screenY / 2 + 30 then
						if skinsTable[selectedSkin - 1] then
							selectedSkin = selectedSkin - 1
							setElementModel(previewPed, skinsTable[selectedSkin][1])
							playSound("files/bincoselect.mp3", false)
						end
					elseif absoluteX >= screenX / 2 + 245 and absoluteX <= screenX / 2 + 405 and absoluteY >= screenY / 2 - 30 and absoluteY <= screenY / 2 + 30 then
						if skinsTable[selectedSkin + 1] then
							selectedSkin = selectedSkin + 1
							setElementModel(previewPed, skinsTable[selectedSkin][1])
							playSound("files/bincoselect.mp3", false)
						end
					elseif absoluteX >= screenX / 2 - 105 and absoluteX <= screenX / 2 + 105 and absoluteY >= screenY - 180 and absoluteY <= screenY - 120 then
						if skinsTable[selectedSkin] then
							if buySkinTick + 1000 <= getTickCount() then
								if skinsTable[selectedSkin][1] and skinsTable[selectedSkin][2] then
									triggerServerEvent("bincoBuy", localPlayer, skinsTable[selectedSkin][2], skinsTable[selectedSkin][1])
									buySkinTick = getTickCount()
								end
							else
								outputChatBox("#d75959[StrongMTA]: #ffffffMásodpercenként csak egyszer.", 0, 0, 0, true)
							end
						end
					end
				end
			end
		end
	end
)

addEvent("bincoBuy", true)
addEventHandler("bincoBuy", getRootElement(),
	function (skinID)
		outputChatBox("#3d7abc[StrongMTA]: #ffffffVettél egy új ruhát." .. " Skin ID: #3d7abc".. skinID, 0, 0, 0, true)
		closePanel()
	end
)