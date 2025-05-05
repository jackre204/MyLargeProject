local screenX, screenY = guiGetScreenSize()

local Roboto = dxCreateFont("files/Roboto.ttf", 13)
local LCDFont = dxCreateFont("files/LCD.ttf", 15)

fadeCamera(true, 0.3, 200, 200, 200)
setElementData(localPlayer, "speedCameras", 0)
setElementData(localPlayer, "usingSpeedCamera", false)

local clickTick = 0

setCameraTarget(localPlayer)

local staticTempObject = false

local playerUseSpeedCam = false

local nearbyCustomSpeedCam = nil

function replaceModels()
    engineReplaceCOL(engineLoadCOL("files/traffi.col"), 951)
    engineImportTXD(engineLoadTXD("files/traffi.txd"), 951)
    engineReplaceModel(engineLoadDFF("files/traffi.dff"), 951)
end

replaceModels()

function canAutoCamCapture()

end

function setSpeedCamRender()
    if staticTempObject then
        local posX, posY, posZ = getPositionFromElementOffset(localPlayer, 0, 1, 0)
        local rotZ = select(3, getElementRotation(localPlayer))

        setElementPosition(staticTempObject, posX, posY, posZ - 1)
        setElementRotation(staticTempObject, 0, 0, math.ceil(math.floor(rotZ * 5) / 5))


        dxDrawRectangle(screenX / 2 - 250, screenY - 75 - 10, 500, 10, tocolor(124, 197, 118, 240))
        dxDrawRectangle(screenX / 2 - 250, screenY - 75, 500, 75, tocolor(44, 44, 44, 240))
        dxDrawText("Az E betű megnyomásával lerakhatod a traffipaxot.", screenX / 2 - 250, screenY - 75, screenX / 2 + 250, screenY, tocolor(255, 255, 255, 200), 1, Roboto, "center", "center")
   
        if getKeyState("e") then
            triggerServerEvent("syncSpeedCameras", resourceRoot, localPlayer, posX, posY, posZ, rotZ)
            removeEventHandler("onClientRender", getRootElement(), setSpeedCamRender)

            destroyElement(staticTempObject)
            staticTempObject = false
            toggleControl("enter_exit", true)

            setElementData(localPlayer, "speedCameras", 1)
        elseif getKeyState("backspace") then
            removeEventHandler("onClientRender", getRootElement(), setSpeedCamRender)

            toggleControl("enter_exit", true)
            destroyElement(staticTempObject)
            staticTempObject = false
        end
    end
end

addCommandHandler("traffi", 
    function()
        if not isPedInVehicle(localPlayer) and getElementHealth(localPlayer) > 0 then
            if not staticTempObject and isOfficer() then
                if (getElementData(localPlayer, "speedCameras") or 0) < 1 then
                    staticTempObject = createObject(951, getElementPosition(localPlayer))
                    setElementCollisionsEnabled(staticTempObject, false)
                    addEventHandler("onClientRender", getRootElement(), setSpeedCamRender)
                    setElementAlpha(staticTempObject, 155)
                    toggleControl("enter_exit", false)
                end
            end
        end
    end
)

function reMap(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end


addEventHandler("onClientRender", getRootElement(), 
    function()
        if playerUseSpeedCam then
            dxDrawImage(screenX / 2 - 25, screenY / 2 - 25, 50, 50, "files/speedcam-pointer.png")
            dxDrawRectangle(0, screenY - 75, screenX, 75, tocolor(44, 44, 44, 240))

            local cursorX, cursorY = getCursorPosition()
            local posX, posY, posZ = getElementPosition(playerUseSpeedCam)
	        local rotX, rotY, rotZ = getElementRotation(playerUseSpeedCam)

            if cursorX and cursorY then
                targetX, targetZ = reMap(cursorX, 0, 1, 80, -80), reMap(cursorY, 0, 1, posZ + 10, posZ - 10)
                
                local angle = math.rad(rotZ + 45)
                local cornerX, cornerY = posX, posY
	            local pointX, pointY = cornerX + 10, cornerY + 10

                local rotatedX = math.cos(angle + math.rad(targetX)) * (pointX - cornerX) - math.sin(angle + math.rad(targetX)) * (pointY - cornerY) + cornerX
	            local rotatedY = math.sin(angle + math.rad(targetX)) * (pointX - cornerX) + math.cos(angle + math.rad(targetX)) * (pointY - cornerY) + cornerY

                local cornerX2, cornerY2 = posX, posY
	            local pointX2, pointY2 = cornerX2 + 0.3, cornerY2 + 0.3

                local rotatedX2 = math.cos(angle) * (pointX2 - cornerX2) - math.sin(angle) * (pointY2 - cornerY2) + cornerX2
	            local rotatedY2 = math.sin(angle) * (pointX2 - cornerX2) + math.cos(angle) * (pointY2 - cornerY2) + cornerY2
	
	            setCameraMatrix(rotatedX2, rotatedY2, posZ + 1.5, rotatedX, rotatedY, targetZ)
                
                local x2, y2, z2 = getWorldFromScreenPosition(screenX / 2, screenY / 2, 20)
                dxDrawLine3D(rotatedX2, rotatedY2, posZ + 1.5, x2, y2, z2)

                local hitState, hitX, hitY, hitZ, hitElement = processLineOfSight(rotatedX2, rotatedY2, posZ + 1.5, x2, y2, z2, true, true, true, true)
                if hitElement and getElementType(hitElement) == "vehicle" then
                    targetVehicle = hitElement
                else
                    targetVehicle = false
                end

                dxDrawRectangle(screenX / 2 - 200, screenY / 2 + 35, 400, 75, tocolor(44, 44, 44, 240))

                if targetVehicle then
                    targetText = getVehicleSpeed(targetVehicle) .. "KM/h "
                else
                    targetText = "NO TARGET"
                end

                dxDrawText(targetText, screenX / 2 - 200, screenY / 2 + 60, screenX / 2 + 200, screenY / 2 + 75, tocolor(255, 255, 255), 1, LCDFont, "center", "center")
                dxDrawText("[ÖV] " .. "Limit: " .. "30" .. "KM/h " .. 1900 + getRealTime().year .. "." .. getRealTime().month .. "." .. getRealTime().monthday .. " " .. getRealTime().hour .. ":" .. getRealTime().minute .. ":" .. getRealTime().second, screenX / 2 - 200, screenY - 75, screenX / 2 + 200, screenY, tocolor(255, 255, 255), 1, LCDFont, "center", "center")
            end

            if getKeyState("backspace") then
                setElementData(playerUseSpeedCam, "inUse", false)
                setElementData(localPlayer, "usingSpeedCamera", false)

                setCameraTarget(localPlayer)
                showCursor(false)
                setCursorAlpha(255)

                playerUseSpeedCam = nil
            end
        end
    end
)

function isOfficer()
    return true
end

addEventHandler("onClientRender", getRootElement(), 
    function()
        if nearbyCustomSpeedCam then
            if getElementData(localPlayer, "usingSpeedCamera") then
                return
            end

            dxDrawRectangle(screenX / 2 - 250, screenY - 75 - 10, 500, 10, tocolor(124, 197, 118, 240))
            dxDrawRectangle(screenX / 2 - 250, screenY - 75, 500, 75, tocolor(44, 44, 44, 240))
            dxDrawText("Az E betű megnyomásával felveheted a traffipaxot.\nAz /settraffi paranccsal beállíthatod a traffipaxot.\nJobbklikk a traffipaxra a használathoz.", screenX / 2 - 250, screenY - 75, screenX / 2 + 250, screenY, tocolor(255, 255, 255, 200), 1, Roboto, "center", "center")
        end
    end
)

function speedCameraClick(sourceKey, keyState, absX, absY, worldX, worldY, worldZ, clickedElement)
    if sourceKey == "right" and keyState == "up" and clickedElement and getElementData(clickedElement, "isCustomSpeedCam") and isOfficer() then
        if getElementData(clickedElement, "inUse") then
            outputChatBox("#1496DC[Traffipax]:#FFFFFF Valaki már használja!", 255, 255, 255, true)
            return
        end

        if not isElementWithinColShape(localPlayer, (getElementData(clickedElement, "speedCameraCol"))) then
            return
        end

        if getElementData(clickedElement, "limit") then

            playerUseSpeedCam = clickedElement

            setElementData(clickedElement, "inUse", true)
            setElementData(localPlayer, "usingSpeedCamera", clickedElement)

            showCursor(true)
            setCursorAlpha(0)

            speedCamLimit = getElementData(clickedElement, "limit")
            nearbyCustomSpeedCam = false
        else
            outputChatBox("#1496DC[Traffipax]:#FFFFFF Ez a traffipax nincs beállítva!", 255, 255, 255, true)
        end
    end

    if sourceKey == "left" and keyState == "down" then
        if playerUseSpeedCam and targetVehicle then
            local vehicleController = getVehicleController(targetVehicle)

            if vehicleController then
                if clickTick + 3000 > getTickCount() then 
                    return
                end

                clickTick = getTickCount() 

                local occupantCount = 0

                for seat, player in pairs(getVehicleOccupants(targetVehicle)) do
                    if not getElementData(player, serverDatas.belt) then
                        occupantCount = occupantCount + 1
                    end
                end

                playSound("files/shutter.mp3")

                if getElementData(playerUseSpeedCam, "seatbelt") >= 1 and occupantCount > 0 then
                    triggerServerEvent("speedCameraFine", localPlayer, vehicleController, getVehicleSpeed(targetVehicle), getElementData(playerUseSpeedCam, "limit"), occupantCount)
                else
                    triggerServerEvent("speedCameraFine", localPlayer, vehicleController, getVehicleSpeed(targetVehicle), getElementData(playerUseSpeedCam, "limit"))
                end
                
                fadeCamera(false, 0.3, 200, 200, 200)

                setTimer(function()
                    fadeCamera(true, 0.3, 200, 200, 200)
                end, 200, 1)
            end
        end
    end
end
addEventHandler("onClientClick", getRootElement(), speedCameraClick)

addEvent("speedAlertFromServer", true)
addEventHandler("speedAlertFromServer", getRootElement(), 
    function(vehSpeed, speedLimit, speedTicket, beltInfo)
        if vehSpeed and speedLimit and speedTicket then
            playSound("files/shutter.mp3")

            outputChatBox("#7cc576[LatasMTA - Traffipax]: #FFFFFFBemértek! Büntetésed: #d75959" .. speedTicket .. "$", 0, 0, 0, true)
            outputChatBox("#7cc576[LatasMTA - Traffipax]: #FFFFFFSebességed: #7cc576" .. vehSpeed .. " KM/h#FFFFFF, Limit: #7cc576" .. speedLimit .. "KM/h", 0, 0, 0, true)
            
            if beltInfo then
                outputChatBox("#7cc576[LatasMTA - Traffipax]: #FFFFFFNem volt bekötve " .. beltInfo .. " személy az öve a járművedben. Büntetés: #d75959" .. (beltInfo * 50) .. "$", 0, 0, 0, true)
            end

            fadeCamera(false, 0.3, 200, 200, 200)

            setTimer(function()
                fadeCamera(true, 0.3, 200, 200, 200)
            end, 200, 1)
        end
    end
)
 

addEventHandler("onClientColShapeHit", getRootElement(), 
    function(hitElement)
        if isElement(hitElement) and isElement(source) then
            if hitElement == localPlayer and getElementData(source, "speedCamera") then
                if not nearbyCustomSpeedCam then
                   nearbyCustomSpeedCam = getElementData(source, "speedCamera")
                end
            end
        end
    end
)

addEventHandler("onClientColShapeLeave", getRootElement(), 
    function(hitElement)
        if hitElement == localPlayer and getElementData(source, "speedCamera") then
            nearbyCustomSpeedCam = nil
        end
    end
)


bindKey("e", "down", 
    function()
        if nearbyCustomSpeedCam and not getElementData(localPlayer, "usingSpeedCamera") and isOfficer() then
            if not getElementData(nearbyCustomSpeedCam, "inUse") then
                if isElement(nearbyCustomSpeedCam, "player") then
                    setElementData(getElementData(nearbyCustomSpeedCam, "player"), "speedCameras", 0)
                end

                triggerServerEvent("removeCamera", resourceRoot, localPlayer, nearbyCustomSpeedCam)
                nearbyCustomSpeedCam = nil
            end
        end
    end
)

addCommandHandler("settraffi",
    function(cmd, speedLimit, seatBelt)
        if nearbyCustomSpeedCam and not getElementData(localPlayer, "usingSpeedCamera") and isOfficer() then
            speedLimit = tonumber(speedLimit)
            seatBelt = tonumber(seatBelt)

            if not seatBelt then
                seatBelt = 0
            end

            if not speedLimit or speedLimit < 30 or speedLimit > 130 or seatBelt > 1 then
                return outputChatBox("#1496DC[Traffipax]:#FFFFFF Használat: /" .. cmd .. " [limit 30-130khm/h] [Öv ki: 0 be: 1]", 255, 255, 255, true)
            end

            setElementData(nearbyCustomSpeedCam, "limit", speedLimit)
            setElementData(nearbyCustomSpeedCam, "seatbelt", seatBelt)

            playSound("files/set.mp3")
            outputChatBox("#1496DC[Traffipax]:#FFFFFF Beállítva.", 255, 255, 255, true)
        end
    end
)

function getVehicleSpeed(vehicle)
	if isElement(vehicle) then
		local vx, vy, vz = getElementVelocity(vehicle)
		return math.sqrt(vx*vx + vy*vy + vz*vz) * 187.5
	end
end