pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local screenX, screenY = guiGetScreenSize()

local panelW, panelH = respc(500), respc(200)

local posX, posY = screenX / 2 - panelW / 2, screenY / 2 - panelH / 2

local Raleway = exports.sm_core:loadFont("Raleway.ttf", 13, false)

local radioState = "main"

local customRadio = false

local buttonM = 3

local radioButtons = {}

local showState = false

local streamebledRadioVehicles = {}

local vehicleBrowsers = {}
local vehicleLinks = {}
local vehicleElements = {}
local vehicleVolumes = {}

local serverLogo = exports.sm_core:getServerLogo()

function renderRadioPanel()
    local playerVehicle = getPedOccupiedVehicle(localPlayer)

    dxDrawRectangle(posX, posY, panelW, panelH, tocolor(25, 25, 25))
    dxDrawRectangle(posX + 3, posY + 3, panelW - 6, respc(30) - 3, tocolor(44, 44, 44, 200))

    dxDrawImage(posX + panelW / 2 - respc(150) / 2, posY + panelH / 2 - respc(150) / 2, respc(150), respc(150), serverLogo, 0, 0, 0, tocolor(200, 200, 200, 120))

    dxDrawText("#3d7abcStrong#ffffffMTA - Vehicle Rádió", posX + 3 + respc(5), posY + 3 + (respc(30) - 3) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
    
    local ytMusicName = getElementData(playerVehicle, "vehicle.ytMusicName")
    if ytMusicName and radioState == "yt" then
        dxDrawText(ytMusicName[1], posX + 3 + panelW / 2, posY + 3 + respc(30), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "top")
        dxDrawText(ytMusicName[2], posX + 3 + panelW / 2, posY + 3 + respc(30) + respc(30), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "top")
    end
    if isElement(streamebledRadioVehicles[playerVehicle]) and radioState == "main" then
        metaTag = getSoundMetaTags(streamebledRadioVehicles[playerVehicle]).stream_title
        currentTrack = getElementData(playerVehicle, "vehicle.RadioStation") or 1

        local soundFFT = getSoundFFTData(streamebledRadioVehicles[playerVehicle], 16384, 256)

        if soundFFT then
            for i = 0, respc(53) do
                dxDrawRectangle(posX + (respc(10) * i) + resp(2.5), posY + panelH - respc(40), respc(10), math.sqrt(soundFFT[i]) * - respc(100), tocolor(61, 122, 188, 100))
            end
        end

        dxDrawText(radioStations[currentTrack][2], posX + 3 + panelW / 2, posY + 3 + respc(30), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "top")


        if metaTag then
            dxDrawText(metaTag, posX + 3 + panelW / 2, posY + 3 + respc(30) + respc(30), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "top")
        end
    end
   
    buttonsC = {}

    local buttonH = (panelW - buttonM * (#radioButtons + 1)) / #radioButtons
    
    local buttonY = posY + panelH - respc(35)

    if radioState == "yt" then
        dxDrawRectangle(posX + 3, posY + panelH - respc(40), panelW - 6, respc(40) - 3, tocolor(44, 44, 44))
        buttonY = posY + panelH - respc(40) - respc(35)
    end

    for i, radioB in pairs(radioButtons) do
        local buttonX = posX + ((i - 1) * buttonH + (i * buttonM))

        drawButton(radioB.action, radioB.name, buttonX, buttonY, buttonH, respc(35) - 3, {61, 122, 188}, false, Raleway, true, 0.75)
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

function clickOnRadioPanel(sourceKey, keyState)
    if sourceKey == "left" and keyState == "down" then
        if activeButtonC then
            local playerVehicle = getPedOccupiedVehicle(localPlayer)

            if activeButtonC == "ytPanel" then
                panelChange("yt")
            elseif activeButtonC == "mainPanel" then
                panelChange("main")
            elseif activeButtonC == "toogleRadio" then
                if getElementData(playerVehicle, "vehice.RadioPower") then
                    radioButtons[1].name = "Bekapcsol"

                    setElementData(playerVehicle, "vehice.RadioPower", false)
                else
                    local lasRadioTrack = getElementData(playerVehicle, "vehicle.RadioStation")

                    if not lasRadioTrack then
                        setElementData(playerVehicle, "vehicle.RadioStation", 1)
                    end

                    radioButtons[1].name = "Kikapcsol"
                    setElementData(playerVehicle, "vehice.RadioPower", true)

                    triggerServerEvent("stopVehicleMovie", playerVehicle)
                end

                panelChange("main")
            elseif activeButtonC == "volumeMinus" then
                local currentVolume = getElementData(playerVehicle, "vehicle.RadioVolume") or 1

                if (math.ceil((currentVolume - 0.1) * 100) / 100) > 0 then
                    setElementData(playerVehicle, "vehicle.RadioVolume", math.ceil((currentVolume - 0.1) * 100) / 100)
                else
                    setElementData(playerVehicle, "vehicle.RadioVolume", 0)
                end
            elseif activeButtonC == "volumePlus" then
                local currentVolume = getElementData(playerVehicle, "vehicle.RadioVolume") or 1
                
                if (math.ceil((currentVolume + 0.1) * 100) / 100) < 1 then
                    setElementData(playerVehicle, "vehicle.RadioVolume", math.ceil((currentVolume + 0.1) * 100) / 100)
                else
                    setElementData(playerVehicle, "vehicle.RadioVolume", 1)
                end
            elseif activeButtonC == "findLink" then
                local musicURL = dxGetEditText("musicURL") or ""

                if musicURL and musicURL ~= "" then
                    setElementData(playerVehicle, "vehice.RadioPower", false)
                    triggerServerEvent("playVehicleMovie", playerVehicle, musicURL)
                end
            elseif activeButtonC == "songState" then
                setElementData(playerVehicle, "vehicle.RadioStop", not getElementData(playerVehicle, "vehicle.RadioStop"))
            elseif activeButtonC == "previousStation" then
                local currentStation = getElementData(playerVehicle, "vehicle.RadioStation") or 1

                if currentStation > 1 then
                    setElementData(playerVehicle, "vehicle.RadioStation", currentStation - 1)
                else
                    setElementData(playerVehicle, "vehicle.RadioStation", #radioStations)
                end
            elseif activeButtonC == "nextStation" then
                local currentStation = getElementData(playerVehicle, "vehicle.RadioStation") or 1

                if currentStation < #radioStations then
                    setElementData(playerVehicle, "vehicle.RadioStation", currentStation + 1)
                else
                    setElementData(playerVehicle, "vehicle.RadioStation", 1)
                end
            end
        end
    end
end

addEventHandler("onClientElementDataChange", getRootElement(),
    function(theKey, oldData, newData)
        if theKey == "vehice.RadioPower" then
            if isElementStreamedIn(source) then
                if newData == true then
                    local currentStation = getElementData(source, "vehicle.RadioStation") or 1

                    streamebledRadioVehicles[source] = playSound(radioStations[currentStation][1])

                    local currentVolume = getElementData(source, "vehicle.RadioVolume") or 1

                    if currentVolume then
                        setElementData(source, "vehicle.RadioVolume", currentVolume)
                    end
                elseif newData == false then
                    if isElement(streamebledRadioVehicles[source]) then
                        destroyElement(streamebledRadioVehicles[source])
                    end

                    streamebledRadioVehicles[source] = nil
                end
            end
        elseif theKey == "vehicle.RadioStop" then
            if isElementStreamedIn(source) then
                if streamebledRadioVehicles[source] then
                    setSoundPaused(streamebledRadioVehicles[source], newData)

                    local currentStation = getElementData(source, "vehicle.RadioStation") or 1

                    if newData == false then
                        if isElement(streamebledRadioVehicles[source]) then
                            destroyElement(streamebledRadioVehicles[source])
                        end
        
                        streamebledRadioVehicles[source] = playSound(radioStations[currentStation][1])
                    end
                end
            end
        elseif theKey == "vehicle.RadioStation" then
            if isElementStreamedIn(source) then
                if isElement(streamebledRadioVehicles[source]) then
                    destroyElement(streamebledRadioVehicles[source])
                end

                streamebledRadioVehicles[source] = playSound(radioStations[newData][1])
            end
        end
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        for k, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
            if getElementData(v, "vehice.RadioPower") then
                local currentStation = getElementData(v, "vehicle.RadioStation") or 1
                streamebledRadioVehicles[v] = playSound(radioStations[currentStation][1])

                if getElementData(v, "vehicle.RadioStop") then
                    setSoundPaused(streamebledRadioVehicles[v], true)
                end

                local currentVolume = getElementData(v, "vehicle.RadioVolume") or 1

                if currentVolume then
                    setElementData(v, "vehicle.RadioVolume", currentVolume)
                end
            end
        end
    end
)

addEventHandler("onClientRender", getRootElement(),
    function()
        local playerX, playerY, playerZ = getElementPosition(localPlayer)
        local playerVehicle = getPedOccupiedVehicle(localPlayer) or false

        for k, v in pairs(streamebledRadioVehicles) do
            local vehPosX, vehPosY, vehPosZ = getElementPosition(k)

			local dist = getDistanceBetweenPoints3D(playerX, playerY, playerZ, vehPosX, vehPosY, vehPosZ)

			local newVolume = (getElementData(k, "vehicle.RadioVolume") or 1) - dist / 30

			if newVolume > 1 then 
                newVolume = 1 
            end

			if newVolume < 0 then 
                newVolume = 0 
            end

            if playerVehicle and (getElementData(playerVehicle, "vehicle.windowState") and playerVehicle ~= k) then
                setSoundVolume(v, 0)
            elseif (getElementData(k, "vehicle.windowState") and playerVehicle ~= k) then
                setSoundVolume(v, 0)
            else
			    setSoundVolume(v, newVolume)
            end
        end

        local camx, camy, camz = getElementPosition(localPlayer)

		for i = 1, #vehicleElements do
            local obj = vehicleElements[i]
                
            if isElement(obj) and isElement(vehicleBrowsers[obj]) then
                local tx, ty, tz = getElementPosition(obj)
                local volume = (vehicleVolumes[obj] or 1) - getDistanceBetweenPoints3D(camx, camy, camz, tx, ty, tz) / 30
                    
                if volume < 0 then
                    volume = 0
                end

                if playerVehicle and (getElementData(playerVehicle, "vehicle.windowState") and playerVehicle ~= obj) then
                    setBrowserVolume(vehicleBrowsers[obj], 0)
                elseif (getElementData(obj, "vehicle.windowState") and playerVehicle ~= obj) then
                    setBrowserVolume(vehicleBrowsers[obj], 0)
                else
                    setBrowserVolume(vehicleBrowsers[obj], volume)
                end
            end
        end
    end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
    function()
        if getElementData(source, "vehice.RadioPower") and getElementType(source) == "vehicle" then
            if isElement(streamebledRadioVehicles[source]) then
                destroyElement(streamebledRadioVehicles[source])
            end

            streamebledRadioVehicles[source] = nil
            
            local currentStation = getElementData(source, "vehicle.RadioStation") or 1
            streamebledRadioVehicles[source] = playSound(radioStations[currentStation][1])

            if getElementData(source, "vehicle.RadioStop") then
                setSoundPaused(streamebledRadioVehicles[source], true)
            end

            local currentVolume = getElementData(source, "vehicle.RadioVolume") or 1

            if currentVolume then
                setElementData(source, "vehicle.RadioVolume", currentVolume)
            end
        end
    end
)

addEventHandler("onClientElementStreamOut", getRootElement(),
    function()
        if getElementData(source, "vehice.RadioPower") then
            if isElement(streamebledRadioVehicles[source]) then
                destroyElement(streamebledRadioVehicles[source])
            end

            streamebledRadioVehicles[source] = nil
        end
    end
)

addEventHandler("onClientElementDestroy", getRootElement(),
    function()
        if getElementData(source, "vehice.RadioPower") then
            if isElement(streamebledRadioVehicles[source]) then
                destroyElement(streamebledRadioVehicles[source])
            end

            streamebledRadioVehicles[source] = nil
        end
    end
)

function showRadioPanel()
    if showState then
        dxDestroyEdit("musicURL")
        removeEventHandler("onClientRender", getRootElement(), renderRadioPanel)
        removeEventHandler("onClientClick", getRootElement(), clickOnRadioPanel)

        removeEventHandler("onClientKey", getRootElement(), editBoxesKey)
        removeEventHandler("onClientCharacter", getRootElement(), editBoxesCharacter)
        removeEventHandler("onClientRender", getRootElement(), renderEditBoxes)

        showState = false
    else
    	radioState = "main"
    	
        panelChange(radioState)

        addEventHandler("onClientRender", getRootElement(), renderRadioPanel)
        addEventHandler("onClientClick", getRootElement(), clickOnRadioPanel)

        addEventHandler("onClientKey", getRootElement(), editBoxesKey)
        addEventHandler("onClientCharacter", getRootElement(), editBoxesCharacter)
        addEventHandler("onClientRender", getRootElement(), renderEditBoxes)

        showState = true
    end
end


bindKey("r", "down",
    function()
        local playerVehicle = getPedOccupiedVehicle(localPlayer)

        if playerVehicle and (getPedOccupiedVehicleSeat(localPlayer) == 0 or getPedOccupiedVehicleSeat(localPlayer) == 1) then
            showRadioPanel()
        end
    end
)

addEventHandler("onClientPaste", getRootElement(), 
    function(text)
        local activatedEditBox = dxGetActiveEditName()

        if activatedEditBox and activatedEditBox == "musicURL" then
            dxEditSetText(activatedEditBox, text)
        elseif activatedEditBox then
            dxEditSetText(activatedEditBox, dxGetEditText(activatedEditBox) .. text)
        end
    end
)


function panelChange(panelName)
    local playerVehicle = getPedOccupiedVehicle(localPlayer)

    local customRadio = getElementData(playerVehicle, "vehicle.YouTube") or false
    
    if getElementData(playerVehicle, "vehice.RadioPower") then
        radioPower = "Kikapcsol"
    else
        radioPower = "Bekapcsol"
    end

    if panelName == "yt" then
        radioButtons = {
            [1] = {
                name = "Keresés",
                action = "findLink"
            },

            [2] = {
                name = "Vol -",
                action = "volumeMinus"
            },

            [3] = {
                name = "Vol +",
                action = "volumePlus"
            },

            [4] = {
                name = "Rádió",
                action = "mainPanel"
            }
        }
        
        dxCreateEdit("musicURL","","YouTube Link", posX + 3, posY + panelH - respc(40), panelW - 6, respc(40) - 3, Raleway, 0)

        radioState = panelName
    elseif panelName == "main" then
        dxDestroyEdit("musicURL")
        radioButtons = {
            [1] = {
                name = radioPower,
                action = "toogleRadio"
            },
        }

        if getElementData(playerVehicle, "vehice.RadioPower") then
            table.insert(radioButtons, {
                name = "Vol -",
                action = "volumeMinus"
            })

            table.insert(radioButtons, {
                name = "Vol +",
                action = "volumePlus"
            })

            table.insert(radioButtons, {
                name = "Előző",
                action = "previousStation"
            })

            table.insert(radioButtons, {
                name = "Következő",
                action = "nextStation"
            })

            table.insert(radioButtons, {
                name = "Szünet",
                action = "songState"
            })
        end

        if customRadio then
            table.insert(radioButtons, {
                name = "YouTube",
                action = "ytPanel"
            })
        end


        radioState = panelName
    end
end

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
        if isElementStreamedIn(source) then
            if dataName == "vehicle.RadioVolume" then
                vehicleVolumes[source] = getElementData(source, "vehicle.RadioVolume") or 1
            elseif dataName == "vehicle.YouTube" then
                table.insert(vehicleElements, source)
                triggerServerEvent("requestVehicleMovie", source)
            end
        end
	end
)

addEventHandler("onClientBrowserCreated", getResourceRootElement(),
	function ()
		loadBrowserURL(source, getElementData(source, "URL"))

        vehicleVolumes[source] = getElementData(source, "vehicle.RadioVolume") or 1
	end
)

registerEvent("playVehicleMovie", getRootElement(),
	function (url, startTime)
        if not isElementStreamedIn(source) then
            return
        end
        
		if isElement(source) then
			if url then
				if not isElement(vehicleBrowsers[source]) then
                    if isElement(vehicleBrowsers[source]) then
					    destroyElement(vehicleBrowsers[source])
                    end

					vehicleBrowsers[source] = createBrowser(512, 256, false, true)
				end

				if startTime and tonumber(startTime) then
					startTime = "&start=" .. startTime
				else
					startTime = ""
				end

				local link = "https://www.youtube.com/embed/" .. url .. "?autoplay=1&controls=0&showinfo=0&autohide=1" .. startTime

				vehicleLinks[source] = url

				setElementData(vehicleBrowsers[source], "URL", link)
				loadBrowserURL(vehicleBrowsers[source], link)
                vehicleVolumes[source] = getElementData(source, "vehicle.RadioVolume") or 1
			else
                if isElement(vehicleBrowsers[source]) then
				    destroyElement(vehicleBrowsers[source])
                end

				vehicleBrowsers[source] = nil
				vehicleLinks[source] = nil
			end
		end
	end
)

function vehicleStreamOut()
	if getElementType(source) == "vehicle" and getElementData(source, "vehicle.YouTube") then
		for i = 1, #vehicleElements do
			if vehicleElements[i] == source then
				table.remove(vehicleElements, i)
				break
			end
		end

		destroyElement(vehicleBrowsers[source])

		vehicleBrowsers[source] = nil
		vehicleLinks[source] = nil
	end
end
addEventHandler("onClientElementDestroy", getRootElement(), vehicleStreamOut)
addEventHandler("onClientElementStreamOut", getRootElement(), vehicleStreamOut)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementData(source, "vehicle.YouTube") then
			table.insert(vehicleElements, source)
			triggerServerEvent("requestVehicleMovie", source)
		end
	end
) 

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for k, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
			if getElementData(v, "vehicle.YouTube") then
				table.insert(vehicleElements, v)
				triggerServerEvent("requestVehicleMovie", v)
			end
		end
	end
)