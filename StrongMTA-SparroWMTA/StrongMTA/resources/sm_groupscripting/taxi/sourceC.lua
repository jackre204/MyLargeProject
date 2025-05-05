pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local screenX, screenY = guiGetScreenSize()

local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(x)
    return x * responsiveMultipler
end

local taxiFactionID = 24

local currentSettingTab = 0
local maxSettingTab = 2

local taxiMeterSizeX, taxiMeterSizeY = respc(250), respc(120)

local taxiMeterPosX, taxiMeterPosY = screenX / 2 - taxiMeterSizeX / 2, screenY / 2 - taxiMeterSizeY / 2

local scrollOffsetY = 0

local windowOffsetX, windowOffsetY = 0, 0

local isPanelMove = false

local currentMiles = 0

local tripDistance = {}

function renderTaxiMeter(deltaTime)
    local sourceVehicle = getPedOccupiedVehicle(localPlayer)

    if sourceVehicle and isElement(sourceVehicle) then
        buttonsC = {}

        if isCursorShowing() then
            cursorX, cursorY = getCursorPosition()
            cursorX, cursorY = cursorX * screenX, cursorY * screenY
        end

        if isPanelMove then
			taxiMeterPosX, taxiMeterPosY = cursorX + windowOffsetX, cursorY + windowOffsetY
		end

        dxDrawRectangle(taxiMeterPosX, taxiMeterPosY, taxiMeterSizeX, taxiMeterSizeY, tocolor(25, 25, 25))
        dxDrawRectangle(taxiMeterPosX + 3, taxiMeterPosY + 3, taxiMeterSizeX - 6, respc(30) - 3, tocolor(45, 45, 45, 180))
        dxDrawText("StrongMTA - Taxi", taxiMeterPosX + 3 + respc(5), taxiMeterPosY + 3 + (respc(30) - 3) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, RalewayS, "left", "center")
            
        if checkTaxiLeader(localPlayer) then
            buttonsC["taxiSettings"] = {taxiMeterPosX + taxiMeterSizeX - respc(20) - 3, taxiMeterPosY + 3 + respc(5), respc(20) - 3, respc(20) - 3}
            dxDrawImage(taxiMeterPosX + taxiMeterSizeX - respc(20) - 3, taxiMeterPosY + 3 + respc(5), respc(20) - 3, respc(20) - 3, "files/images/settings.png", 0, 0, 0, tocolor(200, 200, 200, 200))
        end

        if settingsMenu then
            renderEditBoxes()

            if currentSettingTab == 0 then
                local taxiMeterPosY = scrollOffsetY + taxiMeterPosY
                local taxColor = {60, 60, 60, 40}

                if activeButtonC == "setVehicleTax" then
                    taxColor = {188, 64, 61, 140}
                end

                local minusColor = {60, 60, 60, 40}

                if activeButtonC == "minusCount" then
                    minusColor = {188, 64, 61, 140}
                end

                local plusColor = {60, 60, 60, 40}

                if activeButtonC == "plusCount" then
                    plusColor = {161, 210, 115}
                end

                if activeButtonC == "minusCount" then
                    if getKeyState("mouse1") then
                        if currentVehicleTax > 0 then
                            currentVehicleTax = currentVehicleTax - 1
                        end
                    end
                elseif activeButtonC == "plusCount" then
                    if getKeyState("mouse1") then
                        if currentVehicleTax < 100 then
                            currentVehicleTax = currentVehicleTax + 1
                        end
                    end
                end

                dxDrawRectangle(taxiMeterPosX + 5, taxiMeterPosY + respc(30) + respc(10), taxiMeterSizeX - 10, respc(30) + 6, tocolor(35, 35, 35, 200))
                dxDrawText(currentVehicleTax .. " %", taxiMeterPosX + 5 + 3 + (taxiMeterSizeX - 10) / 2, taxiMeterPosY + respc(30) + respc(10) + respc(30) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, RalewayS, "center", "center")

                drawButton("minusCount", "-", taxiMeterPosX + 5 + 3, taxiMeterPosY + respc(30) + 3 + respc(10), respc(30), respc(30), minusColor, false, RalewayS, true)
                drawButton("plusCount", "+", taxiMeterPosX + 5 + 3 + respc(30) + 3, taxiMeterPosY + respc(30) + 3 + respc(10), respc(30), respc(30), plusColor, false, RalewayS, true)

                drawButton("setVehicleTax", "Beállítás", taxiMeterPosX + 5, taxiMeterPosY + taxiMeterSizeY - 5 - respc(30), taxiMeterSizeX - 10, respc(30), taxColor, false, RalewayS, true)

            elseif currentSettingTab == 1 then
                dxSetEditPosition("payTax", taxiMeterPosX + 5, taxiMeterPosY + respc(30) + respc(10) + 3)
                dxDrawRectangle(taxiMeterPosX + 5, taxiMeterPosY + respc(30) + respc(10) + 3, taxiMeterSizeX - 10 - respc(60) - 10, respc(30), tocolor(35, 35, 35, 200))
                taxColor = {60, 60, 60, 40}

                if activeButtonC == "setVehicleKmTax" then
                    taxColor = {188, 64, 61, 140}
                end

                drawButton("setVehicleKmTax", "Beállítás", taxiMeterPosX + 5, taxiMeterPosY + taxiMeterSizeY - 5 - respc(30), taxiMeterSizeX - 10, respc(30), taxColor, false, RalewayS, true)
            elseif currentSettingTab == 2 then
                local allTraveledMeter = getElementData(sourceVehicle, "veh.TaxiClockMeter") or 0

                zeroColor = {60, 60, 60, 40}

                if activeButtonC == "clockMoneyZero" then
                    zeroColor = {188, 64, 61, 140}
                end
                
                drawButton("clockMoneyZero", "Óra nullázása", taxiMeterPosX + 5, taxiMeterPosY + respc(30) + respc(10) + 3, taxiMeterSizeX - 10 - respc(60) - 10, respc(30), zeroColor, false, RalewayS, true)

                dxDrawText("Órával megtett távolság: " ..  string.format("%.1f", allTraveledMeter) .. " km", taxiMeterPosX + 5, taxiMeterPosY + taxiMeterSizeY - 5 - respc(30), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayS)
            end

            local oldColor = {60, 60, 60, 40}

            if activeButtonC == "oldTab" then
                oldColor = {161, 210, 115}
            end

            local nextColor = {60, 60, 60, 40}

            if activeButtonC == "nextTab" then
                nextColor = {161, 210, 115}
            end

            drawButton("oldTab", "<", taxiMeterPosX + 5 + taxiMeterSizeX - 3 - 10 - respc(30) - respc(30) - 3, taxiMeterPosY + respc(30) + 3 + respc(10), respc(30), respc(30), oldColor, false, RalewayS, true)
            drawButton("nextTab", ">", taxiMeterPosX + 5 + taxiMeterSizeX - 3 - 10 - respc(30), taxiMeterPosY + respc(30) + 3 + respc(10), respc(30), respc(30), nextColor, false, RalewayS, true)
        else
            currentMiles = getElementData(sourceVehicle, "veh.traveledMeter") or 0

            if getElementData(sourceVehicle, "veh.TaxiClock") then
                handledDrawedText = "Leállítás"

                local vehicleSpeed = getVehicleSpeed(sourceVehicle)

                local vehicleDecimal = 1000 / deltaTime
                local currentDistance = vehicleSpeed / 3600 / vehicleDecimal

                if not tripDistance[sourceVehicle] then
                    tripDistance[sourceVehicle] = 0
                end

                tripDistance[sourceVehicle] = tripDistance[sourceVehicle] + currentDistance
            else
                handledDrawedText = "Indítás"
            end

            local taxiMeterPrice = math.ceil(currentMiles)

            textWidth = dxGetTextWidth(taxiMeterPrice .. " $", 0.5, LcdFont)

            local currentVal = taxiMeterPrice

            local str = ""

            for i = 1, math.floor((respc(100) - textWidth) / dxGetTextWidth("0", 0.5, LcdFont)) + string.len(taxiMeterPrice) - utfLen(currentVal) do
                str = str .. "#c8c8c80"
            end

            if tonumber(currentVal) < 0 then
                currentVal = "#d75959" .. math.abs(currentVal)
            elseif tonumber(currentVal) > 0 then
                currentVal = "#3d7abc" .. math.abs(currentVal)
            else
                currentVal = 0
            end

            str = str .. currentVal .. " $"

            dxDrawText(str, taxiMeterPosX + taxiMeterSizeX / 2, taxiMeterPosY + taxiMeterSizeY / 2, nil, nil, tocolor(200, 200, 200, 200), 1, LcdFont, "center", "center", false, false, false, true)
            
            if checkTaxi(localPlayer) then
                local stopColor = {60, 60, 60, 40}

                if activeButtonC == "meterStop" then
                    stopColor = {188, 64, 61, 140}
                end
                
                drawButton("meterStop", handledDrawedText, taxiMeterPosX + 5, taxiMeterPosY + taxiMeterSizeY - 5 - respc(30), (taxiMeterSizeX - 10) / 2 - 2.5, respc(30), stopColor, false, RalewayS, true)
            
                local stopColor = {60, 60, 60, 40}

                if activeButtonC == "meterDouble" then
                    stopColor = {61, 122, 188, 140}
                end
                
                drawButton("meterDouble", "Duplázás", taxiMeterPosX + 5 + (taxiMeterSizeX - 10) / 2 + 2.5, taxiMeterPosY + taxiMeterSizeY - 5 - respc(30), (taxiMeterSizeX - 10) / 2 - 2.5, respc(30), stopColor, false, RalewayS, true)
            else
                local payColor = {60, 60, 60, 40}

                if activeButtonC == "payTaxi" then
                    payColor = {188, 64, 61, 140}
                end

                drawButton("payTaxi", "Kifizetés", taxiMeterPosX + 5, taxiMeterPosY + taxiMeterSizeY - 5 - respc(30), taxiMeterSizeX - 10, respc(30), payColor, false, RalewayS, true)
            end
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
    else

    end 
end

function toogleTaxiMeter(currentState)
    if currentState then

        addEventHandler("onClientPreRender", getRootElement(), renderTaxiMeter)

        addEventHandler("onClientKey", getRootElement(), editBoxesKey)
        addEventHandler("onClientCharacter", getRootElement(), editBoxesCharacter)
    else
    
        removeEventHandler("onClientPreRender", getRootElement(), renderTaxiMeter)

        removeEventHandler("onClientKey", getRootElement(), editBoxesKey)
        removeEventHandler("onClientCharacter", getRootElement(), editBoxesCharacter)
    end
end

addEventHandler("onClientElementDataChange", getRootElement(),
    function(theKey, oldValue, newValue)
        if theKey == "isVehicleInObject" then
            local playerVehicle = getPedOccupiedVehicle(localPlayer)

            if playerVehicle and playerVehicle == source then 
                if newValue then
                    toogleTaxiMeter(true)
                else 
                    toogleTaxiMeter(false)
                end
            end
        end
    end
)

addEventHandler("onClientVehicleEnter", getRootElement(),
    function(sourcePlayer)
        if sourcePlayer == localPlayer then
            if getElementData(source, "isVehicleInObject") then
                toogleTaxiMeter(true)
            end
        end
    end
)

addEventHandler("onClientVehicleExit", getRootElement(),
    function(sourcePlayer)
        if sourcePlayer == localPlayer then
            if getElementData(source, "isVehicleInObject") then
                toogleTaxiMeter(false)
            end
        end
    end
)

local trafficMeterShowState = true

function clickOnTaxiMeter(sourceKey, keyState, absX, absY)
    if sourceKey == "left"then
        if trafficMeterShowState then
            if absX >= taxiMeterPosX + 3 and absX <= taxiMeterPosX + 3 + taxiMeterSizeX - 6 - respc(25) - 3 and absY >= taxiMeterPosY + 3 and absY <= taxiMeterPosY + 3 + respc(30) - 3 then
				if keyState == "down" then
                    windowOffsetX, windowOffsetY = (taxiMeterPosX) - absX, (taxiMeterPosY) - absY

                    isPanelMove = true
                elseif keyState == "up" then
                    isPanelMove = false
                end
            end
        end

        local sourceVehicle = getPedOccupiedVehicle(localPlayer)

        if activeButtonC and keyState == "down"  then
            if activeButtonC == "meterStop" then
                if checkTaxi(localPlayer) then
                    if getElementData(sourceVehicle, "veh.TaxiClock") then
                        triggerServerEvent("stopTaxiClock", localPlayer, localPlayer, sourceVehicle, tripDistance[sourceVehicle])
                        
                        tripDistance[sourceVehicle] = 0
                    else
                        if getElementData(sourceVehicle, "veh.PayTax") then
                            taxiMessage("Nincs kifizetve a fuvar díja!")
                        else
                            triggerServerEvent("resetTaxiClock", localPlayer, localPlayer, sourceVehicle)
                            triggerServerEvent("startTaxiClock", localPlayer, localPlayer, sourceVehicle)
                        end
                    end
                end
            elseif activeButtonC == "meterDouble" then
                if checkTaxi(localPlayer) then
                    if getElementData(sourceVehicle, "veh.TaxiClock") then
                        taxiMessage("Előbb állísd le az órát!")
                    else
                        if getElementData(sourceVehicle, "veh.TaxiClockDouble") then
                            taxiMessage("Már dupláztad ezt a fuvart!")
                        else
                            setElementData(sourceVehicle, "veh.TaxiClockDouble", true)

                            local vehDistance = getElementData(sourceVehicle, "veh.traveledMeter") or 0

                            if vehDistance > 0 then
                                setElementData(sourceVehicle, "veh.traveledMeter", math.ceil(vehDistance * 2))
                            end
                        end
                    end
                end
            elseif activeButtonC == "taxiSettings" then
                settingsMenu = not settingsMenu

                if settingsMenu then
                    currentVehicleTax = getElementData(getPedOccupiedVehicle(localPlayer), "veh.TaxiPayTax") or 0
                    oldVehicleTax = currentVehicleTax
                else
                    currentVehicleTax = false
                    oldVehicleTax = false
                end
            elseif activeButtonC == "payTaxi" then
                local vehicleDriver = getVehicleController(sourceVehicle)

                if vehicleDriver then
                    if checkTaxi(vehicleDriver) then
                        local meterTax = getElementData(sourceVehicle, "veh.traveledMeter") or 0

                        if tonumber(meterTax) and meterTax > 0 then
                            triggerServerEvent("payTaxiPrice", localPlayer, localPlayer, sourceVehicle, vehicleDriver, currentMiles)
                        else
                            taxiMessage("Nincs mit kifizetni!")
                        end
                    else
                        taxiMessage("A jármű vezetője nem taxis!")
                    end
                else
                    taxiMessage("Nincs sofőr a járműben!")
                end
            elseif activeButtonC == "setVehicleTax" then
                if currentVehicleTax then
                    if oldVehicleTax ~= currentVehicleTax then
                        if oldVehicleTax > currentVehicleTax then
                            settingMessage = "csökkentetted"
                        else
                            settingMessage = "megemelted"
                        end
                        taxiMessage("A sofőr részesedését " .. settingMessage .. " ebben a járműben.")
                        triggerServerEvent("setTaxiVehicleTax", localPlayer, localPlayer, sourceVehicle, currentVehicleTax)

                        settingsMenu = false
                        
                        currentVehicleTax = false
                        oldVehicleTax = false
                    else
                        taxiMessage("A szorzó ugyan annyi mint volt!")
                    end
                end
            elseif activeButtonC == "oldTab" then
                if currentSettingTab > 0 then
                    
                    dxDestroyEdit("payTax")

                    currentSettingTab = currentSettingTab - 1

                    if currentSettingTab == 1 then
                        dxCreateEdit("payTax", "", "$ / km", taxiMeterPosX + 5, taxiMeterPosY + respc(30) + respc(10) + 3, taxiMeterSizeX - 10 - respc(60) - 10, respc(30), 11, 2)
                    end
                end
            elseif activeButtonC == "nextTab" then
                if currentSettingTab == maxSettingTab then
                    return
                end

                currentSettingTab = currentSettingTab + 1

                dxDestroyEdit("payTax")


                if currentSettingTab == 1 then
                    dxCreateEdit("payTax", "", "$ / km", taxiMeterPosX + 5, taxiMeterPosY + respc(30) + respc(10) + 3, taxiMeterSizeX - 10 - respc(60) - 10, respc(30), 11, 2)
                end
            elseif activeButtonC == "setVehicleKmTax" then
                if dxGetEditText("payTax") and tonumber(dxGetEditText("payTax")) > 0 and tonumber(dxGetEditText("payTax")) < 1000 then
                    taxiMessage("Sikeresen beállítottad a " .. dxGetEditText("payTax") .. "$ / km vételdíjat!")
                    triggerServerEvent("setTaxiMultiplier", localPlayer, localPlayer, sourceVehicle, tonumber(dxGetEditText("payTax")))
                    settingsMenu = false
                else
                    taxiMessage("A vételdíj 0 és 1000 dollár közt lehet!")
                end
            elseif activeButtonC == "clockMoneyZero" then
                triggerServerEvent("resetTaxiClock", localPlayer, localPlayer, sourceVehicle)
            end
        end
    end
end
addEventHandler("onClientClick", getRootElement(), clickOnTaxiMeter)

addCommandHandler("paytaxi",
    function(sourceCommand)
        local currentVehicle = getPedOccupiedVehicle(localPlayer)

        if currentVehicle and isElement(currentVehicle) then
            if checkTaxi(localPlayer) then
                if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                    local meterTax = getElementData(currentVehicle, "veh.traveledMeter") or 0

                    if tonumber(meterTax) and meterTax > 0 then
                        triggerServerEvent("payTaxiPrice", localPlayer, localPlayer, currentVehicle, localPlayer, currentMiles)
                    end
                end
            end
        end
    end
)

function checkTaxi(sourcePlayer)
    if getPedOccupiedVehicleSeat(sourcePlayer) == 0 then
       return exports.sm_groups:isPlayerInGroup(sourcePlayer, taxiFactionID)
    end
end

function checkTaxiLeader(sourcePlayer)
    return exports.sm_groups:isPlayerLeaderInGroup(sourcePlayer, taxiFactionID) 
end

function taxiMessage(sourceMessage)
    outputChatBox("#DCA300[StrongMTA - Taxi]:#FFFFFF " .. sourceMessage, 255, 255, 255, true)
end