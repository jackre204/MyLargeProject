local wheelClamps = {}

function createWheelClamp(vehicle)
    if isElement(vehicle) and not wheelClamps[vehicle] then
        local x, y, z = getVehicleComponentPosition(vehicle, "wheel_lf_dummy", "world")
        wheelClamps[vehicle] = createObject(8283, x, y, z, 0, 0, 180)
        setElementCollisionsEnabled(wheelClamps[vehicle], false)
    end
end

function removeWheelClamp(vehicle)
    if isElement(vehicle) and wheelClamps[vehicle] then
        destroyElement(wheelClamps[vehicle])
        wheelClamps[vehicle] = nil
    end
end

addEventHandler("onClientPreRender", root, function()
    for vehicle, object in pairs(wheelClamps) do
        if isElement(vehicle) and isElement(object) then
            local x, y, z = getVehicleComponentPosition(vehicle, "wheel_lf_dummy", "world")
            local rx, ry, rz = getVehicleComponentRotation(vehicle, "wheel_lf_dummy", "world")
            setElementPosition(object, x, y, z)
            setElementRotation(object, 0, 0, rz)
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    local txd = engineLoadTXD("files/mods/wheelclamp.txd")
    if txd then
        local dff = engineLoadDFF("files/mods/wheelclamp.dff")
        if dff then
            engineImportTXD(txd, 8283)
            engineReplaceModel(dff, 8283)
        end
    end

    for k, v in pairs(getElementsByType("vehicle", root, true)) do
        if getElementData(v, "vehicle.wheelClamp") then
            createWheelClamp(v)
        end 
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "vehicle" then
        if getElementData(source, "vehicle.wheelClamp") then
            createWheelClamp(source)
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "vehicle" then
        removeWheelClamp(source)
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if getElementType(source) == "vehicle" then
        removeWheelClamp(source)
    end
end)

addEventHandler("onClientElementDataChange", root, function(key, oldValue, newValue)
    if getElementType(source) == "vehicle" then
        if key == "vehicle.wheelClamp" then
            if newValue == true then
                if isElementStreamedIn(source) then
                    createWheelClamp(source)
                end
            elseif newValue == false then
                removeWheelClamp(source)
            end
        end
    end
end)

local screenX, screenY = guiGetScreenSize()

local barW, barH = 251, 20
local barX, barY = (screenX - barW) / 2, screenY - 5 - 46 - barH - 5

local clampTime = 5
local startTick = nil 
local currentAction = true

local clampSound = nil

function startWheelClampingAnimation(action)
    startTick = getTickCount()
    addEventHandler("onClientRender", root, renderWheelClamping)
    triggerServerEvent("wheelclampSapplyAnimation", localPlayer, true)
    currentAction = action
    if isElement(clampSound) then
        stopSound(clampSound)
        destroyElement(clampSound)
    end
    clampSound = playSound("clamp/clamp.mp3")
end
addEvent("startWheelClampingAnimation", true)
addEventHandler("startWheelClampingAnimation", getRootElement(), startWheelClampingAnimation)

function renderWheelClamping()
    if startTick then
        dxDrawRectangle(barX, barY, barW, barH, tocolor(25, 25, 25))
        local text = "leszerelése"
        
        if currentAction then
            text = "felszerelése"
        end
        
        dxDrawText("Kerékbilincs " .. text .. "...", barX + barW / 2, barY - dxGetFontHeight(1, RalewayS), nil, barY + 2,tocolor(200, 200, 200), 1, RalewayS, "center")

        local currentTick = getTickCount()
        local elapsedTick = currentTick - startTick
        local endTick = startTick + clampTime * 1000
        local duration = endTick - startTick
        local barProgress = elapsedTick / duration
        local barFill = interpolateBetween(
            0, 0, 0,
            1, 0, 0,
            barProgress, "Linear"
        )

        dxDrawRectangle(barX + 2 - (barW - 4) * barFill / 2 + (barW - 4) / 2, barY + 2, (barW - 4) * barFill, barH - 4, tocolor(61, 122, 188, 200))  

        if barProgress >= 1 then
            removeEventHandler("onClientRender", root, renderWheelClamping)
            triggerServerEvent("wheelclampSapplyAnimation", localPlayer, false)
            if isElement(clampSound) then
                stopSound(clampSound)
                destroyElement(clampSound)
            end
        end
    end
end


addEventHandler("onClientKey",getRootElement(),
    function(sourceKey, keyState)
        if currentClampedVeh then
            if isElement(currentClampedVeh) then
                local pedveh = currentClampedVeh

                if pedveh then
                    if getElementData(pedveh, "vehicle.wheelClamp") then
                        local playerBoundKeys = {}

                        for k, v in pairs(getBoundKeys("accelerate")) do
                            table.insert(playerBoundKeys, k)
                        end

                        for k, v in pairs(getBoundKeys("brake_reverse")) do
                            table.insert(playerBoundKeys, k)
                        end

                        for k, v in pairs(playerBoundKeys) do
                            if v == sourceKey then
                                cancelEvent()

                                if keyState then
                                    outputChatBox("Kerékbilincs van a kocsin!")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)

addEventHandler("onClientVehicleStartEnter",getRootElement(),
    function (player)
        if player == localPlayer then
            if getElementData(source, "vehicle.wheelClamp") then
                currentClampedVeh = source
            end
        end
    end
)

addEventHandler("onClientVehicleExit",getRootElement(),
    function (player)
        if player == localPlayer then
            currentClampedVeh = false
        end
    end
)