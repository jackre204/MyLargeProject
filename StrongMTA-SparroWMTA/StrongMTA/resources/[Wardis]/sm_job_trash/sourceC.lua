local screenX, screenY = guiGetScreenSize()

local Roboto = dxCreateFont("files/Roboto.ttf", 11)

function replaceObjects()
    engineReplaceCOL(engineLoadCOL("files/trash.col"), 1439)
    engineImportTXD(engineLoadTXD("files/trash.txd"), 1439)
    engineReplaceModel(engineLoadDFF("files/trash.dff"), 1439)
end

replaceObjects()

createMarker(2432.87109375, -2119.8564453125, 12.546875, "cylinder", 4, 124, 197, 118, 225)
createMarker(-2099.5380859375, 299.98828125, 34.263687133789, "cylinder", 4, 124, 197, 118, 225)

up1 = true

addEventHandler("onClientColShapeHit", getRootElement(), 
    function(hitElement, matchDim)
        if hitElement == localPlayer and matchDim and up1 then
            if source == up1 or source == up2 then
                local sourceVehicle = getPedOccupiedVehicle(localPlayer)

                if sourceVehicle and getPedOccupiedVehicleSeat(localPlayer) == 0 and getElementModel(sourceVehicle) == 408 then
                    if getElementData(sourceVehicle, "loadedTrashes") >= 25 then
                        setElementData(sourceVehicle, "trashAnimation", true)
                        setElementFrozen(sourceVehicle, true)
                        setVehicleDoorOpenRatio(sourceVehicle, 1, 0)
                        setVehicleDoorOpenRatio(sourceVehicle, 1, 0.85, 2000)
                    
                        setTimer(function()
                            if isElement(up0) then
                                setElementData(up0, "trashAnimation", false)
                                setElementFrozen(up0, false)
                                setVehicleDoorOpenRatio(up0, 1, 0, 2000)
                                outputChatBox("#acd373[SeeMTA - Kukás]: #ffffffSikeresen kiürítheted a kocsidat! Kerestél 60 000 forintot.", 255, 255, 255, true)
                                setElementData(up0, "loadedTrashes", 0)
                                --triggerServerEvent("payTheTrashJob", localPlayer)
                            end
                        end, 4000, 1)
                    end
                end
            end

            if getElementData(source, "trashColOf") and not elementHit then
                elementHit = getElementData(source, "trashColOf")
                addEventHandler("onClientRender", getRootElement(), renderTrashTooltip)
                bindKey("e", "down", attachTheTrash)
            end
        end
    end
)

addEventHandler("onClientColShapeLeave", getRootElement(), 
    function(hitElement, matchDim)
        if hitElement == localPlayer and matchDim and getElementData(source, "trashColOf") and elementHit == getElementData(source, "trashColOf") then
            elementHit = false
            removeEventHandler("onClientRender", getRootElement(), renderTrashTooltip)
            unbindKey("e", "down", attachTheTrash)
        end
    end
)

addEventHandler("onClientElementDestroy", getRootElement(), 
    function()
        if getElementData(source, "trashColOf") and up0 == getElementData(source, "trashColOf") then
            up0 = false
            removeEventHandler("onClientRender", getRootElement(), renderTrashTooltip)
            unbindKey("e", "down", attachTheTrash)
        end
    end
)


function renderTrashTooltip()
    drawTooltip("Az #598ed7[E] #ffffffgombot megnyomásával #acd373megfoghatod#ffffff a kukát.")
end

function drawTooltip(tipText)
    dxDrawRectangle(screenX / 2 - 250, screenY - 122, 500, 50, tocolor(0, 0, 0, 150))
    dxDrawRectangle(screenX / 2 - 250, screenY - 72, 500, 2, tocolor(124, 197, 118))
    dxDrawText(tipText, screenX / 2 - 250, screenY - 122, screenX / 2 - 250 + 500, screenY - 72, tocolor(255, 255, 255, 255), 1, Roboto, "center", "center", false, false, true, true, true)
end

addEventHandler("onClientElementDataChange", getRootElement(), 
    function(dataKey)
        if source == localPlayer and dataKey == "carryingTrash" and getElementData(localPlayer, "carryingTrash") then
            addEventHandler("onClientRender", getRootElement(), processTrashRemove)
            up0 = true
        end

        if source == localPlayer and dataKey == "attachedToTrashtruck" then
            if getElementData(localPlayer, "attachedToTrashtruck") then
                setCameraClip(true, false)
            else
                setCameraClip(true, true)
            end
        end

        if dataKey == "outOfTrash" then
            if getElementData(source, "outOfTrash") then
                up1[source] = tostring(getElementData(source, "outOfTrash"))
            else
                up1[source] = nil
            end
            processEffect(source)
        end

        if dataKey == "loadedTrashes" then
            up2[source] = getElementData(source, "loadedTrashes")

            if up2[source] >= 25 and source == getPedOccupiedVehicle(localPlayer) then
                print("infobox" .. "Tele van a kukásautód! Vidd el kiüríteni!")
            end
        end

        if dataKey == "insectPlayers" then
            if isElement(up3[source]) then
                destroyElement(up3[source])
            end

            if getElementData(source, dataKey) then
                up3[source] = createEffect("insects", 0, 0, 0)
                setEffectDensity(up3[source], 2)
            else
                up3[source] = nil
            end
        end

        if dataKey == "char.Job" and source == localPlayer then
            onJob()
        end
    end
)

addEventHandler("onClientRender", getRootElement(), 
    function()

    end
)

addEventHandler("onClientResourceStart", getResourceRootElement(), 
    function(res)

    end
)

function processEffect(_ARG_0_)

end

function renderTrashes()
    for k, v in ipairs(getElementsByType("object"), getResourceRootElement(), true) do
        if isElement(v) then
            if getElementModel(v) == 1439 then
                local trashX, trashY, trashZ = getElementPosition(v)

                if trashX and trashY and trashZ then
                    local distance = getDistanceBetweenPoints2D(trashX, trashY, getElementPosition(localPlayer))

                    if distance < 7 then
                        local posX, posY = getScreenFromWorldPosition(trashX, trashY, trashZ + 2)

                        if posX and posY then
                            local size = 150 / (distance / 2)
                            dxDrawImage(posX - size / 2, posY - size / 2, size, size, "files/trash.png")
                        end
                    end
                end
            end
        end
    end
end

function getVehicleSpeed(vehicle)
    if isElement(vehicle) then
        local vx, vy, vz = getElementVelocity(vehicle)
        return math.floor(math.sqrt(vx*vx + vy*vy + vz*vz) * 187.5)
    end
end

function checkWhenOnTrashVehBack()

end

function attachToTruck()

end

bindKey("e", "down", attachToTruck)
addEventHandler("onClientRender", getRootElement(), renderTrashes)
addEventHandler("onClientRender", getRootElement(), checkWhenOnTrashVehBack)

function onJob()

end

function getTrashAttached(_ARG_0_)

end

function processTrashRemove()

end

function attachTheTrash()
    if elementHit then -- and _UPVALUE1_
        triggerServerEvent("attachTheTrash", localPlayer, elementHit)
    end
end

addEvent("trashMechaSound", true)
addEventHandler("trashMechaSound", getRootElement(),
    function()

    end
)

addEventHandler("onClientElementDestroy", getRootElement(), 
    function()
        
    end
)

addEventHandler("onClientRender", getRootElement(),
    function()
     --   drawTooltip("Az #598ed7[E] #ffffffgombot megnyomásával #acd373megfoghatod#ffffff a kukát.")
    end
)
