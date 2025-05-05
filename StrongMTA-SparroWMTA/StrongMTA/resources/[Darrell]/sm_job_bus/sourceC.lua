pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",getRootElement(),function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function resp(value)
    return value * responsiveMultipler
end

function respc(value)
    return math.ceil(value * responsiveMultipler)
end

local screenX, screenY = guiGetScreenSize()

local screen = {}

--Az új geci localjai

local font = dxCreateFont("files/lunabar.ttf", respc(10))
local backmoney = 3
local state = 0
local utasok
local dollar = 0
local backmoney2 = math.random(1, 4)
local ped = {}
local drawstate = false


local moneytable = {
    [1] = {
        name = "Teljesárú menetjegy",
        price = 8
    },

    [2] = {
        name = "Kedvezményes 50%",
        price = 4
    },

    [3] = {
        name = "Kedvezményes 90%",
        price = 1
    },

    [4] = {
        name = "Havi bérlet",
        price = 102
    },
}

--Eddig

local currentPeds = {}
local currentMarker = false
local currentBlip = false

local busPeds = {}
local busPassengers = {}

local lineColor = {50, 179, 239}
local progressBar = false

local animControls = false

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

addEvent("createBusProgressbar", true)
addEventHandler("createBusProgressbar", getRootElement(), 
    function(timer,passengersCount)
		utasok = passengersCount - 1
        if not animControls then
            exports.sm_controls:toggleControl({"all"}, false)
            animControls = true
        end
        drawstate = true
        addEventHandler("onClientRender", getRootElement(), rebderBusStopPanel)

        if drawstate then
            backmoney = math.random(1, 4)
            backmoney = math.random(1, 4)
            if backmoney == 1 then
                random  = math.random(8, 14)
            elseif backmoney == 2 then
                random = math.random(4, 20)
            elseif backmoney == 3 then
                random = math.random(1, 10)
            else
                random = math.random(102, 162)
            end

            if not isTimer(timer) then
                timer = setTimer(function()
                    if state == 0 then
                        if not animControls then
                            exports.sm_controls:toggleControl({"all"}, false)
                            animControls = true
                        end
                        nowMoney = 0
                        nowTicket = 0
                        utas = 5
                    elseif state == 8 then
                        if isElement(getPedOccupiedVehicle(localPlayer) or false) then
                            timer = true
                            if random3 == 0 then
                                timer = false
                                state = 0
                                if animControls then
                                    exports.sm_controls:toggleControl({"all"}, true)
                                    animControls = false
                                end
                                if getElementHealth(getPedOccupiedVehicle(localPlayer) or false) or false then
                                end
                            end
                        end
                    end
                    state = state + 1
                end, 3750, 8)
            end
        end
	end
)

addEvent("nextBusStop", true)
addEventHandler("nextBusStop", localPlayer,
	function (lineType, markerId, skins)
		if isElement(currentMarker) then
			destroyElement(currentMarker)
		end

		if isElement(currentBlip) then
			destroyElement(currentBlip)
		end

		currentMarker = nil
		currentBlip = nil

		for i = 1, #currentPeds do
			if isElement(currentPeds[i]) then
				destroyElement(currentPeds[i])
			end
		end

		currentPeds = {}

		if lineType then
			lineColor = {50, 179, 239}

			local pedPosition = pedPoints[lineType][markerId]

			for i = 1, #skins do
				local pedElement = createPed(skins[i], pedPosition[i][1], pedPosition[i][2], pedPosition[i][3], pedPosition[i][4])

				if isElement(pedElement) then
					setElementFrozen(pedElement, true)
					table.insert(currentPeds, pedElement)
				end
			end

			local nextWaypoint = markerPoints[lineType][markerId]

			if nextWaypoint then
				local currentVeh = getPedOccupiedVehicle(localPlayer)
				local zoneName = getZoneName(nextWaypoint[1], nextWaypoint[2], nextWaypoint[3])

				setTimer(outputChatBox, 500, 1, "#3d7abc[StrongMTA - Buszsofőr]: #ffffffKövetkező megálló: #3d7abc" .. zoneName, 50, 179, 239, true)
				
				currentMarker = createMarker(nextWaypoint[1], nextWaypoint[2], nextWaypoint[3], "checkpoint", 3, lineColor[1], lineColor[2], lineColor[3])
				currentBlip = createBlip(nextWaypoint[1], nextWaypoint[2], nextWaypoint[3], 0, 2, lineColor[1], lineColor[2], lineColor[3])

				setElementData(currentBlip, "blipTooltipText", "Következő megálló (" .. zoneName .. ")")

				if currentVeh then
					setElementData(currentVeh, "gpsDestination", {nextWaypoint[1], nextWaypoint[2], tocolor(unpack(lineColor))})
				end
			end
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "busPassengers" then
			if source == getPedOccupiedVehicle(localPlayer) then
				local dataValue = getElementData(source, dataName)

				if dataValue then
					processPassengers(source, dataValue)
				end
			end
		elseif dataName == "char.Job" or dataName == "jobVehicle" then
			if source == localPlayer then
				local playerJob = getElementData(localPlayer, "char.Job")
				local jobVehicle = getElementData(localPlayer, "jobVehicle")

				if (playerJob ~= 5 and playerJob ~= 6) or not jobVehicle then
					if isElement(currentMarker) then
						destroyElement(currentMarker)
					end

					if isElement(currentBlip) then
						destroyElement(currentBlip)
					end

					currentMarker = nil
					currentBlip = nil

					for i = 1, #currentPeds do
						if isElement(currentPeds[i]) then
							destroyElement(currentPeds[i])
						end
					end

					currentPeds = {}
				end
			end
		end
	end
)

function processPassengers(busElement, passengers)
	if not busPeds[busElement] then
		busPeds[busElement] = {}
	end

	for i = 1, #busPeds[busElement] do
		local pedElement = busPeds[busElement][i]

		if isElement(pedElement) then
			destroyElement(pedElement)
			busPeds[busElement][i] = nil
		end
	end

	busPeds[busElement] = {}

	for k in pairs(passengers) do
		if passengers[k] then
			if pedPositions[k] then
				local pedElement = createPed(passengers[k], 0, 0, 0)

				if isElement(pedElement) then
					setElementCollisionsEnabled(pedElement, false)
					setPedAnimation(pedElement, "ped", "SEAT_idle", -1, true, false, false)
					attachElements(pedElement, busElement, pedPositions[k][1], pedPositions[k][2], pedPositions[k][3])
					
					for i = 1, #busPassengers + 1 do
						if not busPassengers[i] or not isElement(busPassengers[i][1]) then
							busPassengers[i] = {pedElement, busElement, pedPositions[k][4] or 0}
							break
						end
					end

					table.insert(busPeds[busElement], pedElement)
				end
			end
		end
	end

	local velX, velY, velZ = getElementVelocity(busElement)
	setElementVelocity(busElement, velX, velY, velZ + 0.01)
end

--INNEN


    function rebderBusStopPanel()
        if drawstate then
            buttonsC = {}

            screen.x = screenX / 2
            screen.y = screenY / 2

            dxDrawRectangle(screen.x - respc(500), screen.y - respc(230), respc(1000), respc(460), tocolor(25, 25, 25), false)
            dxDrawRectangle(screen.x - respc(500) + 3, screen.y - respc(230) + 3, respc(1000) - 6, respc(40) - 6, tocolor(45, 45, 45, 200), false)
            dxDrawText("#3d7abcStrong#ffffffMTA - Buszsofőr", screen.x - respc(500) + 3 + respc(10), screen.y - respc(230) + 3 + (respc(40) - 6) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, font, "left", "center", false, false, false, true)
            dxDrawImage(screen.x - respc(490), screen.y - respc(140), respc(470), respc(340), "files/imgs/jegyek.png", 0, 0, 0, tocolor(255, 255, 255, 200), false)
            dxDrawImage(screen.x + respc(20), screen.y - respc(140), respc(230), respc(100), "files/imgs/1.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
            dxDrawImage(screen.x + respc(260), screen.y - respc(140), respc(230), respc(100), "files/imgs/2.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
            dxDrawImage(screen.x + respc(20), screen.y - respc(30), respc(230), respc(100), "files/imgs/5.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
            dxDrawImage(screen.x + respc(260), screen.y - respc(30), respc(230), respc(100), "files/imgs/20.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
            dxDrawImage(screen.x + respc(20), screen.y + respc(80), respc(230), respc(100), "files/imgs/50.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
            dxDrawImage(screen.x + respc(260), screen.y + respc(80), respc(230), respc(100), "files/imgs/100.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
            dxDrawText("#3d7abcKért jegy: #c8c8c8" .. ({
                "Teljesárú menetjegy",
                "Kedvezményes 50%",
                "Kedvezményes 90%",
                "Havi bérlet"
            })[backmoney] .. "\n#3d7abcAdott összeg:#c8c8c8 $" ..random, screen.x - respc(490) + respc(240), screen.y - respc(145) , nil, nil, tocolor(255, 255, 255, 255), 1, font, "center", "bottom", false, false, false, true, false)
        
            dxDrawText("#3d7abcAdott jegy: #c8c8c8" .. ({
                "Teljesárú menetjegy",
                "Kedvezményes 50%",
                "Kedvezményes 90%",
                "Havi bérlet"
            })[backmoney2] .. "\n#3d7abcVisszaadott összeg:#c8c8c8 $" .. dollar, screen.x + respc(20) + respc(235), screen.y - respc(145), nil, nil, tocolor(255, 255, 255, 255), 1, font, "center", "bottom", false, false, false, true, false)
            
            local cursorX, cursorY = getCursorPosition()

            if cursorX and cursorY then
                cursorX, cursorY = cursorX * screenX, cursorY * screenY
            end

            drawButton("next", "Visszajáró átadása", screen.x + respc(20), screen.y + respc(190), respc(230), respc(30), {61, 122, 188}, false, font)

            drawButton("reset", "Visszajáró nullázása", screen.x + respc(260), screen.y + respc(190), respc(230), respc(30), {188, 64, 61}, false, font)

            local cx, cy = getCursorPosition()

			if tonumber(cx) then
				cx = cx * screenX
				cy = cy * screenY

				activeButtonC = false

				for k, v in pairs(buttonsC) do
					if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
						activeButtonC = k
						break
					end
				end
			else
				activeButtonC = false
			end
        
        end
    end


addEventHandler("onClientClick", getRootElement(), 
    function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
        if not drawstate then 
            return 
        end

        if absoluteX >= screen.x + respc(20) and absoluteX <= screen.x + respc(250) and absoluteY >= screen.y - respc(140) and absoluteY <= screen.y - respc(40) and state == "up" then
            dollar = dollar + 1
        end

        if absoluteX >= screen.x + respc(260) and absoluteX <= screen.x + respc(260) + respc(230) and absoluteY >= screen.y - respc(140) and absoluteY <= screen.y - respc(40) and state == "up" then
            dollar = dollar + 2
        end

        if absoluteX >= screen.x + respc(20) and absoluteX <= screen.x + respc(250) and absoluteY >= screen.y - respc(30) and absoluteY <= screen.y - respc(30) + respc(100) and state == "up" then
            dollar = dollar + 5
        end

        if absoluteX >= screen.x + respc(260) and absoluteX <= screen.x + respc(260) + respc(230) and absoluteY >= screen.y - respc(30) and absoluteY <= screen.y - respc(30) + respc(100) and state == "up" then
            dollar = dollar + 20
        end

        if absoluteX >= screen.x + respc(20) and absoluteX <= screen.x + respc(250) and absoluteY >= screen.y + respc(80) and absoluteY <= screen.y + respc(80) + respc(100) and state == "up" then
            dollar = dollar + 50
        end

        if absoluteX >= screen.x + respc(260) and absoluteX <= screen.x + respc(260) + respc(230) and absoluteY >= screen.y + respc(80) and absoluteY <= screen.y + respc(80) + respc(100) and state == "up" then
            dollar = dollar + 100
        end

        if absoluteX >= screen.x - respc(490) and absoluteX <= screen.x - respc(270) and absoluteY >= screen.y - respc(140) and absoluteY <= screen.y - respc(30) and state == "up" then
            backmoney2 = 1
        end

        if absoluteX >= screen.x - respc(490) and absoluteX <= screen.x - respc(270) and absoluteY >= screen.y + respc(30) and absoluteY <= screen.y + respc(200) and state == "up" then
            backmoney2 = 2
        end

        if absoluteX >= screen.x - respc(230) and absoluteX <= screen.x - respc(20) and absoluteY >= screen.y - respc(140) and absoluteY <= screen.y - respc(30) and state == "up" then
            backmoney2 = 3
        end

        if absoluteX >= screen.x - respc(230) and absoluteX <= screen.x - respc(20) and absoluteY >= screen.y + respc(30) and absoluteY <= screen.y + respc(200) and state == "up" then
            backmoney2 = 4
        end

        if activeButtonC == "reset" and state == "up" then
            dollar = 0
            randomup = 0
        end

        if activeButtonC == "next" and state == "up" then
            if moneytable[backmoney2]["price"] ~= random - dollar then
                return exports.sm_accounts:showInfo("e", "Nem jól adtál vissza!")
             end

             backmoney = math.random(1, 4)

            if backmoney == 1 then
                random  = math.random(8, 14)
            elseif backmoney == 2 then
                random = math.random(4, 20)
            elseif backmoney == 3 then
                random = math.random(1, 10)
            else
                random = math.random(102, 162)
            end
      
			local vehicle = getPedOccupiedVehicle(localPlayer)
			triggerServerEvent("insertPedToBus",localPlayer,localPlayer,vehicle,utasok)
			for i = 1, #currentPeds do
				if isElement(currentPeds[utasok]) then
					destroyElement(currentPeds[utasok])
				end
			end			
            utasok = utasok - 1 

            dollar = 0
            exports.sm_accounts:showInfo("s", "Sikeresen kiszolgáltad az utasokat!")

            if utasok == 0 then
                if isElement(getPedOccupiedVehicle(localPlayer) or false) then
                    utasok = 0

                    showCursor(false)
                    if animControls then
                        exports.sm_controls:toggleControl({"all"}, true)
                        animControls = false
                    end

                    removeEventHandler("onClientRender", getRootElement(), rebderBusStopPanel)

                    drawstate = false
                    dollar = 0
                    randomup = 0
                    backmoney = 0
                    random = 0

                    triggerServerEvent("nextPoint",localPlayer,localPlayer)
                    backmoney = math.random(1, 4)

					if backmoney == 1 then
						random  = math.random(8, 14)
					elseif backmoney == 2 then
						random = math.random(4, 20)
					elseif backmoney == 3 then
						random = math.random(1, 10)
					else
						random = math.random(102, 162)
					end
                    utasok = math.random(1,5)
                    if getElementHealth(getPedOccupiedVehicle(localPlayer) or false) or false then
                        backmoney = math.random(1, 4)

						if backmoney == 1 then
							random  = math.random(8, 14)
						elseif backmoney == 2 then
							random = math.random(4, 20)
						elseif backmoney == 3 then
							random = math.random(1, 10)
						else
							random = math.random(102, 162)
						end
                    end
                end
            end
        end
    end
)

function isInSlot(posX, posY, sizeX, sizeY)
	return exports.sm_core:isInSlot(posX, posY, sizeX, sizeY)
end

function math.round(number)
    return number - number % 1
end

function tableLength(table)
    for i, v in pairs(table) do
    end
    return 0 + 1
end

-- IDÁIG

addEventHandler("onClientRender", getRootElement(),
	function ()
		for i = 1, #busPassengers do
			local passenger = busPassengers[i]

			if passenger then
				if isElement(passenger[1]) and isElement(passenger[2]) then
					local busRotation = select(3, getElementRotation(passenger[2]))

					setElementRotation(passenger[1], 0, 0, busRotation + passenger[3])
				else
					if isElement(passenger[1]) then
						destroyElement(passenger[1])
					end

					busPassengers[i] = false
				end
			end
		end

		if progressBar then
			local currentTick = getTickCount()
			local progress = (currentTick - progressBar[1]) / progressBar[2]

			if progress > 1 then
				progress = 1
			end

			if currentTick > progressBar[1] + progressBar[2] then
				if animControls then
					exports.sm_controls:toggleControl({"all"}, true)
					animControls = false
				end

				progressBar = false
			end

			local sx, sy = 251, 8
			local x = screenX / 2 - sx / 2 - 5
			local y = screenY - 56 - sy - 5

			dxDrawRectangle(x - 2, y - 2, sx + 4, 2, tocolor(0, 0, 0, 200)) -- felső
			dxDrawRectangle(x - 2, y + sy, sx + 4, 2, tocolor(0, 0, 0, 200)) -- alsó
			dxDrawRectangle(x - 2, y, 2, sy, tocolor(0, 0, 0, 200)) -- bal
			dxDrawRectangle(x + sx, y, 2, sy, tocolor(0, 0, 0, 200)) -- jobb

			dxDrawRectangle(x, y, sx, sy, tocolor(50, 50, 50, 200)) -- háttér
			dxDrawRectangle(x, y, sx * progress, sy, tocolor(unpack(lineColor))) -- progress
		end
	end
)