pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

addEventHandler("onClientPedDamage", resourceRoot, function()
	cancelEvent() 
end)

local screenX, screenY = guiGetScreenSize()
local remainingTime = false
local coinMoving = 0
local coinSize = .025
local lastBetTick = 0
local rouletteObjects = {}
local activeSectorData = {}
local sectorsHovered = {}
local hoveredOwnedCoin = false
local minutesLeft, secondsLeft = 1, 0
local previousNumber = "-"

local tableCoinBets = {}
local ownCoinBets = {}

local rectangleTexture = dxCreateTexture("files/images/rectangle.png")
local robotoBoldFont12 = dxCreateFont("files/fonts/Roboto-Bold.ttf", resp(12))
--robotoBoldFont10 = dxCreateFont("files/fonts/Roboto-Bold.ttf", resp(10))
--robotoBoldFont9 = dxCreateFont("files/fonts/Roboto-Bold.ttf", resp(9))


local robotoBoldFont12 = exports.sm_core:loadFont("Raleway.ttf", resp(12), false)
robotoBoldFont10 = exports.sm_core:loadFont("Raleway.ttf", resp(10), false)
robotoBoldFont9 = exports.sm_core:loadFont("Raleway.ttf", resp(9), false)

renderData = {
	activeDirectX = "",
	previewObject = nil,
	previewRotation = 0,
	clickedRoulette = nil,
	rouletteState = false,
	rouletteBarW = respc(500),
	rouletteBarH = respc(100)
}

renderData.rouletteBarX = screenX / 2 - renderData.rouletteBarW / 2
renderData.rouletteBarY = screenY - respc(235)

local sectorPosition = {(284), (25), (692), (167)}
local sectorWidth = (sectorPosition[3] - sectorPosition[1]) / 12
local sectorHeight = (sectorPosition[4] - sectorPosition[2]) / 3

local sectorArray = {
	{"0", (250), sectorPosition[2], (32), (141)},
	{"1st12", sectorPosition[1], sectorPosition[4] + (1), (sectorWidth * 4)-(4), (45)},
	{"2nd12", (sectorPosition[1] + sectorWidth * 4), sectorPosition[4] + (1), (sectorWidth * 4)-(4), (45)},
	{"3rd12", sectorPosition[1] + sectorWidth * 8, sectorPosition[4] + (1), sectorWidth * 4, (45)},
	{"1-18", sectorPosition[1], sectorPosition[4] + (47), sectorWidth * 2, (47)},
	{"even", sectorPosition[1] + sectorWidth * 2, sectorPosition[4] + (47), sectorWidth * 2, (47)},
	{"red", sectorPosition[1] + sectorWidth * 4, sectorPosition[4] + (47), sectorWidth * 2, (47)},
	{"black", sectorPosition[1] + sectorWidth * 6, sectorPosition[4] + (47), sectorWidth * 2, (47)},
	{"odd", sectorPosition[1] + sectorWidth * 8, sectorPosition[4] + (47), sectorWidth * 2, (47)},
	{"19-36", sectorPosition[1] + sectorWidth * 10, sectorPosition[4] + (47), sectorWidth * 2, (47)},
	{"2to3", sectorPosition[3], sectorPosition[2], sectorWidth, sectorHeight},
	{"2to2", sectorPosition[3], sectorPosition[2] + sectorHeight, sectorWidth, sectorHeight},
	{"2to1", sectorPosition[3], sectorPosition[2] + sectorHeight * 2, sectorWidth, sectorHeight}
}

-- # Insert the number sectors to the array
for i = 0, 12 * 3 - 1 do
	local x = math.floor(i / 3)
	local y = i % 3

	table.insert(sectorArray, {tostring(x * 3 + (3 - y)), sectorPosition[1] + sectorWidth * x, sectorPosition[2] + sectorHeight * y, sectorWidth, sectorHeight})
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
	txd = engineLoadTXD("files/models/kbchips1.txd")
	engineImportTXD(txd, 1853)
	engineImportTXD(txd, 1854)
	engineImportTXD(txd, 1855)
	engineImportTXD(txd, 1856)
	engineImportTXD(txd, 1857)
	engineImportTXD(txd, 1858)
	
	engineSetModelLODDistance(3003, 15)
	engineSetModelLODDistance(1979, 15)
	
	for k, v in ipairs(getElementsByType("object", root, true)) do
		if getElementModel(v) == 1978 and getElementData(v, "casino:rouletteTable") then
			loadRouletteTable(v)
		end
	end
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
	if getElementModel(source) == 1978 and getElementData(source, "casino:rouletteTable") then
		loadRouletteTable(source)
	end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function ()
	if rouletteObjects[source] then
		for k, v in pairs(rouletteObjects[source]) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		rouletteObjects[source] = nil
	end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
	if rouletteObjects[source] then
		for k, v in pairs(rouletteObjects[source]) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		rouletteObjects[source] = nil
	end
end)

function syncRouletteRemainingTime(fieldBets, actions, roundTime, placeInTable)
	-- # Set the table's remaining time
	if not roundTime then
		remainingTime = false
	elseif not remainingTime then
		remainingTime = getTickCount() - roundTime
	end
	-- # Sync the already placed bets
	tableCoinBets = {}
	ownCoinBets = {}

	for i = #actions, 1, -1 do
		local dat = actions[i]

		if dat ~= "new" then
			if not tableCoinBets[dat[1]] then
				tableCoinBets[dat[1]] = dat[5] .. " tétje: #3d7abc" .. dat[3] .. " #ffffffCoin"
			else
				tableCoinBets[dat[1]] = tableCoinBets[dat[1]] .. "\n" .. dat[5] .. " tétje: #3d7abc" .. dat[3] .. " #ffffffCoin"
			end

			if tonumber(dat[4]) == tonumber(getElementData(localPlayer, "char.ID") or 0) then
				ownCoinBets[dat[1]] = dat[3]
				havePlacedBets = true
			end
		end
	end
end
addEvent("syncRouletteRemainingTime", true)
addEventHandler("syncRouletteRemainingTime", getRootElement(), syncRouletteRemainingTime)

addEvent("zoomCameraToBall", true)
addEventHandler("zoomCameraToBall", getRootElement(), function()
	if renderData.clickedRoulette then
		moveCamToObject(renderData.clickedRoulette, 3000, -1.0, 1.4, 2, -0.3, 1.4, 0)
		remainingTime = 0

		setTimer(function()
			moveCamToObject(renderData.clickedRoulette, 1000, -1.7, 0, 4, -0.2, 0, 0)
			minutesLeft, secondsLeft = 1, 0
			previousNumber = getElementData(renderData.clickedRoulette, "rouletteNumber")
		end, 13000, 1)
	end
end)

function renderRouletteTable()
	-- # Calculation for the cursor hit 3d
	if not isCursorShowing() then return end
  local relX, relY = getCursorPosition()
  local cursorX, cursorY = relX * screenX, relY * screenY
  local camX, camY, camZ = getCameraMatrix()
  local cursorWorldPosX, cursorWorldPosY, cursorWorldPosZ = getWorldFromScreenPosition(cursorX, cursorY, 1000)
  local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ = processLineOfSight(camX, camY, camZ, cursorWorldPosX, cursorWorldPosY, cursorWorldPosZ, true, true, false, true, true, true, false, true)
  local x, y, z = getElementPosition(renderData.clickedRoulette)

	-- # Calculate the individual sectors
	local activeFieldX, activeFieldY = 0, 0
  local activeFields = {}

  local fieldMinX, fieldMinY = 9999, 9999
  local fieldMaxX, fieldMaxY = -1, -1

  for i = 1, #sectorArray do
    local data = sectorArray[i]
		-- # Calculate the sector's min cordinates
    local minFieldX, minFieldY = data[2], data[3]
    minFieldX, minFieldY = getFieldRealCoord(minFieldX, minFieldY)

		-- # Calculate the sector's max cordinates
    local maxFieldX, maxFieldY = (data[2] + data[4]), (data[3] + data[5])
    maxFieldX, maxFieldY = getFieldRealCoord(maxFieldX, maxFieldY)

		-- # Check the intersection
    local rz = select(3, getElementRotation(renderData.clickedRoulette))
    local minX, minY = rotateAround(rz, minFieldY, minFieldX)
    local maxX, maxY = rotateAround(rz, maxFieldY, maxFieldX)

    local absMaxX, absMaxY, absMinX, absMinY = minX+x, minY+y, maxX+x, maxY+y
    local width, height = absMaxX - absMinX, absMaxY - absMinY

    if boxesIntersect(hitX, hitY, coinSize, coinSize, absMinX, absMinY, width, height) then
      table.insert(activeFields, data[1])
    end

    local field = data[1]
    local numField = tonumber(field)
    local drawHover = false

    if field ~= activeSectorData[3] then
      drawHover = true
    end

    if field == activeSectorData[3] then
      activeFieldX = math.floor(data[2] + data[4] / 2)
      activeFieldY = math.floor(data[3] + data[5] / 2)
    elseif activeSectorData[5] then
      if activeSectorData[5][numField] then
        if activeFieldX <= 0 and activeFieldY <= 0 then
          local startX = data[2]

          if numField == 0 then
            startX = respc(250)
          end

          if startX < fieldMinX then
            fieldMinX = startX
          end

          if fieldMaxX < data[2] + data[4] then
            fieldMaxX = data[2] + data[4]
          end

          if numField ~= 0 then
            if data[3] < fieldMinY then
              fieldMinY = data[3]
            end

            if fieldMaxY < data[3] + data[5] then
              fieldMaxY = data[3] + data[5]
            end
          end
        end

        drawHover = false
      end
    end
		-- # Draw rectangle on the hovered sectors
    if drawHover then
			if coinMoving > 0 then
	      if numField == 0 then
	        dxDrawMaterialLine3D(absMinX, absMinY+height/2, z- 0.17, absMinX+width, absMinY+height/2, z - 0.17, rectangleTexture, height, tocolor(0, 0, 0, 150), x, y, z+100000)
	      else
	        dxDrawMaterialLine3D(absMinX, absMinY+height/2, z- 0.17, absMinX+width, absMinY+height/2, z - 0.17, rectangleTexture, height, tocolor(0, 0, 0, 150), x, y, z+100000)
	      end
		end
    end
  end

  if activeFieldX <= 0 and activeFieldY <= 0 then
    activeFieldX = fieldMinX + (fieldMaxX - fieldMinX) / 2
    activeFieldY = fieldMinY + (fieldMaxY - fieldMinY) / 2

    if (activeSectorData[2] == "three line" or activeSectorData[2] == "six line" or activeSectorData[2] == "corner") and not tonumber(sectorsHovered[1]) then
      activeFieldY = fieldMinY + (fieldMaxY - fieldMinY)
    end
  end

  if #activeFields == 0 then
    sectorsHovered = {}
    activeSectorData = {}
  else
    for i = 1, #activeFields do
      local activeField = activeFields[i]
      local selectedField = sectorsHovered[i]

      if activeField == selectedField then
        activeField = #activeFields
        selectedField = #sectorsHovered
      end

      if activeField ~= selectedField then
        local fieldNumbers, fieldName, oneFieldName, priceMultipler = getDetailsFromName(activeFields)

        sectorsHovered = activeFields
        activeSectorData = {fieldNumbers, fieldName, oneFieldName, priceMultipler}
        activeSectorData[5] = {}

        for k = 1, #fieldNumbers do
          activeSectorData[5][tonumber(fieldNumbers[k])] = true
        end
        break
      end
    end
  end
	-- # Place a bet by releasing the left mouse while carrying a coin
	if not getKeyState("mouse1") then
		if #sectorsHovered > 0 and coinMoving > 0 and remainingTime ~= 0 and getTickCount() - lastBetTick > 1275 then
			-- # Check if it goes over the maximum bet
			local coinsWorth = 0
			for k, v in pairs(ownCoinBets) do
				coinsWorth = coinsWorth + v
			end
			if (coinsWorth + availableCoins[coinMoving].worth) > maximumBet then
				exports.ex_gui:showInfoBox("A maximum tét $500.000, amelyet nem léphetsz túl!", "error")
			else
				local field = activeFieldX .. "," .. activeFieldY

				activeSectorData[3] = nil
				activeSectorData[5] = nil
				activeSectorData[6] = availableCoins[coinMoving].worth
				activeSectorData[7] = coinMoving

				triggerServerEvent("makeNewBetServer", localPlayer, field, activeSectorData, getElementsByType("player", getRootElement(), false))

				activeSectorData = {}
				lastBetTick = getTickCount()
			end
		end
		coinMoving = 0
	end
	-- # Show information of the hovered bet coins on table
	hoveredOwnedCoin = false
	if #sectorsHovered > 0 and coinMoving == 0 then
		local field = activeFieldX .. "," .. activeFieldY

		if tableCoinBets[field] then
			renderBetInformation(cursorX, cursorY, "Fogadások", tableCoinBets[field])

			if not hoveredOwnedCoin and ownCoinBets[field] then
				hoveredOwnedCoin = field
			end
		end
	end
	-- # Remove the bet by clicking on a coin
	if getKeyState("mouse2") and hoveredOwnedCoin and remainingTime ~= 0 and coinMoving == 0 then
		if getTickCount() - lastBetTick > 500 and ownCoinBets[hoveredOwnedCoin] then
			print("client click")
			print("asd")
			triggerServerEvent("revokePlacedCoin", localPlayer, hoveredOwnedCoin)
		end
	end
end

function renderRouletteBar()
	buttonsC = {}

	renderData.activeDirectX = ""

	local secondsLeft, secondsLeft = 1, 0

	if remainingTime then
		local elapsedTime =  getTickCount() - remainingTime
		local progress = math.floor((interactionTime - elapsedTime) / 1000)

		if progress > 0 then
			minutesLeft, secondsLeft = math.floor(progress / 60), progress
			if progress <= 0 then
				remainingTime = 0
			end
		else
			minutesLeft, secondsLeft = 0, 0
			remainingTime = 0
			coinMoving = 0
		end
	end

	if string.len(secondsLeft) < 2 then
		secondsLeft = "0" .. secondsLeft
	end


	drawStrongPanelBottomExit(renderData.rouletteBarX, renderData.rouletteBarY, renderData.rouletteBarW, respc(200), robotoBoldFont10, 1)
	dxDrawText("Pörgetésig hátralévő idő: " .. minutesLeft .. ":" .. secondsLeft, renderData.rouletteBarX + renderData.rouletteBarW / 2, renderData.rouletteBarY + respc(45), nil, nil, tocolor(200, 200, 200, 200), 1, robotoBoldFont10, "center", "top", false, false, false, true)
	dxDrawText("Előző nyerőszám: " .. tostring(previousNumber), renderData.rouletteBarX + renderData.rouletteBarW / 2, renderData.rouletteBarY + respc(65), nil, nil, tocolor(200, 200, 200, 200), 1, robotoBoldFont10, "center", "top", false, false, false, true)

	for i = 1, 6 do
		dxDrawImage(renderData.rouletteBarX + respc(35) + (i - 1) * respc(40) - respc(35) + respc(275) / 2, renderData.rouletteBarY + respc(100), respc(30), respc(30), ":sm_casino/files/chips/" .. availableCoins[tonumber(i)].worth .. ".png")
		
		if isCursorInBox(renderData.rouletteBarX + respc(35) + (i - 1) * respc(40) - respc(35) + respc(275) / 2, renderData.rouletteBarY + respc(100), respc(30), respc(30)) then
			renderData.activeDirectX = "coin_" .. i
		end
	end

	if string.find(renderData.activeDirectX, "coin_") then
		local index = renderData.activeDirectX:gsub("coin_", "")
		local cx, cy = getCursorPosition()

		showTooltip(cx * screenX, cy * screenY, "#3d7abc" .. availableCoins[tonumber(index)].worth .. " #ffffffCoin")
	end
	-- # Draw a coin dummy after clicking
	if coinMoving > 0 then
		if isCursorShowing() then
			local cursorX, cursorY = getCursorPosition()
			local relX, relY = screenX * cursorX, screenY * cursorY
			dxDrawImage(relX-respc(35)/2, relY-respc(35)/2, respc(35), respc(35), ":sm_casino/files/chips/" .. availableCoins[tonumber(coinMoving)].worth .. ".png")
		end
	end

	local relX, relY = getCursorPosition()

	activeButtonC = false

	if relX and relY then
		relX = relX * screenX
		relY = relY * screenY

		for k, v in pairs(buttonsC) do
			if relX >= v[1] and relY >= v[2] and relX <= v[1] + v[3] and relY <= v[2] + v[4] then
				activeButtonC = k
				break
			end
		end
	end
end

function clickRoulettTable(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "right" and state == "down" then
		if clickedElement and getElementModel(clickedElement) == 1978 and getElementData(clickedElement, "casino:rouletteTable") and not isElement(renderData.clickedRoulette) then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local targetX, targetY, targetZ = getElementPosition(clickedElement)

			if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) < 2 then
				if math.abs(playerZ - targetZ) - 0.5 >= 0 then
					return
				end

				local playerRot = select(3, getElementRotation(localPlayer))
				local facingAngle = math.deg(math.atan2(targetY - playerY, targetX - playerX)) + 180 - playerRot

				if facingAngle < 0 then
					facingAngle = facingAngle + 360
				end

				if facingAngle < 180 then
					return
				end

				if not getElementData(clickedElement, "rouletteAnimating") then
					renderData.clickedRoulette = clickedElement
					previousNumber = (getElementData(clickedElement, "rouletteNumber") or "-")
					-- # Create the camera animation
					moveCamToObject(clickedElement, 1000, -1.7, 0, 4, -0.2, 0, 0)
					-- # Calculate the right position for the player to stand
					local tableX, tableY, tableZ = getElementPosition(clickedElement)
					local px, py, pz = getElementPosition(localPlayer)
					local distance = -1.4

					local tablePlayerPos = getOffsetFromXYZ(getElementMatrix(clickedElement), {getElementPosition(localPlayer)})

					local offY = tablePlayerPos[2]

					if offY < (-1.3) then
						offY = -1.3
						distance = -1
					end

					local offPosX, offPosY, offPosZ = getPositionFromElementOffset(clickedElement, -0.1, offY, 0)
					local newRot = getFacingRotation(localPlayer, offPosX, offPosY)

					local newX, newY, newZ = getPositionInfrontOfElement(offPosX, offPosY, offPosZ, newRot, distance)

					local offPosX, offPosY, offPosZ = getPositionFromElementOffset(localPlayer, 0, -0.15, 0)

					setElementPosition(localPlayer, offPosX, offPosY, offPosZ)
					setElementRotation(localPlayer, 0, 0, newRot)
					-- # Set the player's animation on server side
					triggerServerEvent("setPlayerTableState", localPlayer, localPlayer, clickedElement, "tableIn")
					setTimer(function()
						renderData.rouletteState = true
						addEventHandler("onClientRender", getRootElement(), renderRouletteBar)
						addEventHandler("onClientPreRender", getRootElement(), renderRouletteTable)
					end, 1200, 1)
				else
					exports.ex_gui:showInfoBox("A pörgetés már elkezdődőtt ennél az asztalnál. Várd meg, hogy csatlakozhass a játékhoz!", "error")
				end
			end
		end
	elseif button == "left" and state == "down" then
		if renderData.rouletteState then
			-- # Close roulette table
			if activeButtonC and activeButtonC == "exitFromPanel" then
				closeRouletteTable()
			end
			-- # Click on a coin
			if remainingTime ~= 0 then
				if string.find(renderData.activeDirectX, "coin_") then
					renderData.activeDirectX = string.gsub(renderData.activeDirectX, "coin_", "")
					coinMoving = tonumber(renderData.activeDirectX)
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickRoulettTable)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if renderData.rouletteState then
		setCameraTarget(localPlayer)
		setPedAnimation(localPlayer)
	end
end)

function closeRouletteTable()
	if table.empty(ownCoinBets) then
		moveCamToPlayer(localPlayer, 1000)
		removeEventHandler("onClientRender", getRootElement(), renderRouletteBar)
		removeEventHandler("onClientPreRender", getRootElement(), renderRouletteTable)
		setTimer(function()
			renderData.rouletteState = false
			renderData.clickedRoulette = nil
			triggerServerEvent("setPlayerTableState", localPlayer, localPlayer, renderData.clickedRoulette, "tableOut")
		end, 1200, 1)

		remainingTime = false
	else
		exports.ex_gui:showInfoBox("Várd meg a kör végét, vagy vedd le az eddig feltett téteidet, hogy kiszálhass!", "error")
	end
end

function forcedClosingByServer()
	ownCoinBets = {}
	tableCoinBets = {}
	moveCamToPlayer(source, 1000)
	removeEventHandler("onClientRender", getRootElement(), renderRouletteBar)
	removeEventHandler("onClientPreRender", getRootElement(), renderRouletteTable)
	renderData.rouletteState = false
	renderData.clickedRoulette = nil
	minutesLeft, secondsLeft = 1, 0
end
addEvent("forcedClosingByServer", true)
addEventHandler("forcedClosingByServer", getRootElement(), forcedClosingByServer)

function loadRouletteTable(element)
	local tableX, tableY, tableZ = getElementPosition(element)
	local tableRotation = select(3, getElementRotation(element))
	local tableInterior = getElementInterior(element)
	local tableDimension = getElementDimension(element)

	rouletteObjects[element] = {}

	-- # Create the npc standing in front of the table
	local x, y = rotateAround(tableRotation, 1.55, 1.5)
	rouletteObjects[element].ped = createPed(172, tableX + x, tableY + y, tableZ, tableRotation + 90)

	setElementInterior(rouletteObjects[element].ped, tableInterior)
	setElementDimension(rouletteObjects[element].ped, tableDimension)
	setElementCollidableWith(rouletteObjects[element].ped, element, false)
	setElementFrozen(rouletteObjects[element].ped, true)
	setPedAnimation(rouletteObjects[element].ped, "CASINO", "Roulette_loop", -1, true, false, false, false)

	-- # Create the wheel for the table
	local x, y = rotateAround(tableRotation, -0.195, 1.35)
	rouletteObjects[element].wheel = createObject(1979, tableX + x, tableY + y, tableZ - 0.025, 0, 0, tableRotation)

	setElementInterior(rouletteObjects[element].wheel, tableInterior)
	setElementDimension(rouletteObjects[element].wheel, tableDimension)
	setElementDoubleSided(rouletteObjects[element].wheel, true)

	-- # Create the ball for the table
	rouletteObjects[element].ball = createObject(3003, tableX + x, tableY + y, tableZ + 0.05, 0, 0, tableRotation)

	setElementInterior(rouletteObjects[element].ball, tableInterior)
	setElementDimension(rouletteObjects[element].ball, tableDimension)
	setObjectScale(rouletteObjects[element].ball, 0.4)
	setElementCollisionsEnabled(rouletteObjects[element].ball, false)

	-- # Load the state of the ball
	local rouletteNumber = getElementData(element, "rouletteNumber")

	if not rouletteNumber then
		rouletteNumber = 1
	end

	rouletteObjects[element].interpolation = {wheelNumbers[rouletteNumber] * numberDegree, rouletteNumber}
end

function renderBallMovingAnimation()
	if not table.empty(rouletteObjects) then
		local now = getTickCount()
		local rot = - now / 50

		for k, v in pairs(rouletteObjects) do
			setElementRotation(v.wheel, 0, 0, rot)

			if v.interpolation then
				local wheelX, wheelY, wheelZ = getElementPosition(v.wheel)
				local wheelRot = select(3, getElementRotation(v.wheel))

				wheelRot = wheelRot - 135

				local angle = 0
				local x, z = 0, 0

				if tonumber(v.interpolation[1]) then
					angle = wheelRot - v.interpolation[1]
				else
					local elapsedTime = now - v.interpolation[2]
					local progress = interpolateBetween(0, 0, 0, 1, 0, 0, elapsedTime / 10000, "InOutQuad")

					angle = interpolateBetween(wheelRot - v.interpolation[3], 0, 0, wheelRot - v.interpolation[4], 0, 0, progress, "OutBack", 0.3, 1, 2)

					local progress = (elapsedTime - 5000) / 3500
					local progress2 = 0

					if progress > 0 then
						progress2 = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "InOutQuad")
					end

					x, z = interpolateBetween(0.15, 0.075, 0, 0.025, 0.025, 0, progress2, "OutBack", 0.3, 1, 4)

					local progress = (elapsedTime - 8000) / 500
					if progress > 0 then
						x, z = interpolateBetween(0.025, 0.025, 0, 0, 0, 0, progress, "Linear")
					end

					if progress >= 5 then
						rouletteObjects[k].interpolation = {v.interpolation[4], v.interpolation[5]}
					end
				end

				local rotatedX, rotatedY = rotateAround(angle, -0.23 - x, 0)
				setElementPosition(v.ball, wheelX + rotatedX, wheelY + rotatedY, wheelZ - 0.055 + z)
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), renderBallMovingAnimation)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName)
	if dataName == "rouletteNumber" then
		if isElementStreamedIn(source) then
			local theNumber = getElementData(source, "rouletteNumber")
			local oldNumber = 0

			if rouletteObjects[source] and rouletteObjects[source].interpolation then
				oldNumber = rouletteObjects[source].interpolation[2] or 0
			end

			rouletteObjects[source].interpolation = {true, getTickCount(), wheelNumbers[oldNumber] * numberDegree, wheelNumbers[theNumber] * numberDegree - 1080, theNumber}
			
			local sound = playSound3D("files/sounds/spin.mp3", getElementPosition(source))
			setElementInterior(sound, getElementInterior(source))
			setElementDimension(sound, getElementDimension(source))
			setSoundVolume(sound, 0.75)
			setSoundSpeed(sound, 1.25)
		end
	elseif dataName == "casino:coinObject" then
		setElementStreamable(source, false)
	end
end)

-- ## Roulette Table Creation For Admins ## --

function createRouletteTable()
	if getElementData(localPlayer, "acc.adminLevel") > 6 then
		if not isElement(renderData.previewObject) then
			renderData.previewObject = createObject(1978, 0, 0, 0)
			setElementAlpha(renderData.previewObject, 175)
			setElementCollisionsEnabled(renderData.previewObject, false)
			setElementDimension(renderData.previewObject, getElementDimension(localPlayer))
			setElementInterior(renderData.previewObject, getElementInterior(localPlayer))
			showCursor(true)

			addEventHandler("onClientRender", getRootElement(), renderRoulettePreview)
			addEventHandler("onClientClick", getRootElement(), clickRoulettePreview)
		end
	end
end
addCommandHandler("creatertable", createRouletteTable)

function renderRoulettePreview()
	-- # Calculate the hit position of the cursor
	local relX, relY = getCursorPosition()
	local cursorX, cursorY = relX * screenX, relY * screenY
	local camX, camY, camZ = getCameraMatrix()
	local cursorWorldPosX, cursorWorldPosY, cursorWorldPosZ = getWorldFromScreenPosition(cursorX, cursorY, 1000)
	local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ = processLineOfSight(camX, camY, camZ, cursorWorldPosX, cursorWorldPosY, cursorWorldPosZ, true, true, false, true, true, true, false, true)
	-- # Give information to the admin
	dxDrawCorrectText("A rulett asztal lerakásához használd a kurzorod.\nForgatás: #0072ffGörgő #ffffff| Létrehozás: #0072ffBal klikk #ffffff| Visszavonás: #0072ffJobb klikk", 0, screenY-respc(200), screenX, 0, tocolor(255,255,255,255), 1, robotoBoldFont12, "center", "top", false, false, false, true)
	-- # Set the preview table to the hit position
	setElementPosition(renderData.previewObject, hitX, hitY, hitZ + 1)
end

function clickRoulettePreview(button, state)
	if button == "left" and state == "down" then
		if isElement(renderData.previewObject) then
			local objX, objY, objZ = getElementPosition(renderData.previewObject)
			local _, _, rotation = getElementRotation(renderData.previewObject)
			local time = getRealTime()
			local date = string.format("%04d/%02d/%02d", time.year + 1900, time.month + 1, time.monthday)
			local dimension, interior = getElementDimension(renderData.previewObject), getElementInterior(renderData.previewObject)
			-- # Collect the needed data into a proper array
			local data = {
				x = objX,
				y = objY,
				z = objZ,
				rot = rotation,
				creatorName = getElementData(localPlayer, "visibleName"),
				createdDate = date,
				dimensionID = dimension,
				interiorID = interior,
			}

			triggerServerEvent("createRouletteTableServer", localPlayer, data)
			showCursor(false)
			removeEventHandler("onClientRender", getRootElement(), renderRoulettePreview)
			removeEventHandler("onClientClick", getRootElement(), clickRoulettePreview)
			destroyElement(renderData.previewObject)
		end
	elseif button == "right" and state == "down" then
		if isElement(renderData.previewObject) then
			showCursor(false)
			removeEventHandler("onClientRender", getRootElement(), renderRoulettePreview)
			removeEventHandler("onClientClick", getRootElement(), clickRoulettePreview)
			destroyElement(renderData.previewObject)
		end
	end
end

bindKey("mouse_wheel_down", "down", function()
	if isElement(renderData.previewObject) then
		local rotation = select(3, getElementRotation(renderData.previewObject))
		local rotationSpeed = 90
		setElementRotation(renderData.previewObject, 0, 0, rotation - 1 * rotationSpeed)
	end
end)

bindKey("mouse_wheel_up", "down", function()
	if isElement(renderData.previewObject) then
		local rotation = select(3, getElementRotation(renderData.previewObject))
		local rotationSpeed = 90
		setElementRotation(renderData.previewObject, 0, 0, rotation + 1 * rotationSpeed)
	end
end)

function getNearbyRouletteTables()
  if exports.ex_admin:isSuperAdmin(localPlayer) then
    local found = false
    outputChatBox("Közeledben lévő rulettasztalok: ", 255,255,255, true)
    for k, v in pairs(getElementsByType("object", getRootElement(), true)) do
      local rouletteID = getElementData(v, "casino:rouletteTable")
      if rouletteID then
        if isObjectWithinDistance(localPlayer, v, 10) then
          found = true
          outputChatBox("- ID: "..rouletteID, 255,255,255, true)
        end
      end
    end
    if not found then
      outputChatBox("Nincs a közeledben rulettasztal.", 255,255,255, true)
    end
  end
end
addCommandHandler("nearbyroulette", getNearbyRouletteTables)

function showTooltip(x, y, text, text2)
	text = tostring(text)
	text2 = text2 and tostring(text2)

	if text == text2 then
		text2 = nil
	end

	local sx = dxGetTextWidth(text, 1, "clear", true) + 20
	
	if text2 then
		sx = math.max(sx, dxGetTextWidth(text2, 1, "clear", true) + 20)
		text = "#3d7abc" .. text .. "\n#ffffff" .. text2
	end

	local sy = 30

	if text2 then
		local lines = select(2, string.gsub(text2, "\n", "")) + 1
		sy = sy + 12 * lines
	end

	x = math.max(0, math.min(screenX - sx, x))
	y = math.max(0, math.min(screenY - sy, y))

	dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0, 190), true)
	dxDrawText(text, x, y, x + sx, y + sy, tocolor(200, 200, 200, 200), 0.5, robotoBoldFont12, "center", "center", false, false, true, true)
end