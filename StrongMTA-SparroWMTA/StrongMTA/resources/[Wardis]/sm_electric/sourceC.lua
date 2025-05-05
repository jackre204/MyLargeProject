function replaceModels()
    engineImportTXD(engineLoadTXD("files/kezi.txd"), 7238)
    engineReplaceCOL(engineLoadCOL("files/kezi.col"), 7238)
    engineReplaceModel(engineLoadDFF("files/kezi.dff"), 7238)

    engineImportTXD(engineLoadTXD("files/tolto.txd"), 6929)
    engineReplaceCOL(engineLoadCOL("files/tolto.col"), 6929)
    engineReplaceModel(engineLoadDFF("files/tolto.dff"), 6929)
end

replaceModels()


function renderElectricFuel()
    for k, v in ipairs(getElementsByType("object", resourceRoot, true)) do
        if getElementModel(v) == 6929 then
            local handObject = getElementData(v, "fuelPumpObject") 

            if handObject then
                local startX, startY, startZ = getPositionFromElementOffset(v, - 0.25, 0.01, 2)
                local endX, endY, endZ = getPositionFromElementOffset(handObject, 0, 0.01, 0.03)
                dxDrawLine3D(startX, startY, startZ, endX, endY, endZ, tocolor(25, 25, 25, 255), 5)

                if getDistanceBetweenPoints3D(startX, startY, startZ, endX, endY, endZ) > 5 then
                    triggerServerEvent("setHandObjectDefaultPos", root, localPlayer)
                end
            end
        end
    end
end
addEventHandler("onClientRender", getRootElement(), renderElectricFuel)

addEventHandler("onClientClick", getRootElement(),
    function(sourceKey, keyState, absX, absY, worldX, worldY, worldZ, clickedElement)
        if sourceKey == "right" and keyState == "down" then
            if clickedElement then
                if getElementModel(clickedElement) == 6929 then
                    local handObject = getElementData(clickedElement, "fuelPumpObject") 

                    if getElementData(localPlayer, "pumpElement") then
                        if getElementData(getElementData(localPlayer, "pumpElement"), "chargerObject") == clickedElement then
                            triggerServerEvent("setHandObjectDefaultPos", root, localPlayer)
                        else
                            print("ez nem az te cigany")
                        end
                    else
                        if handObject then
                            if getElementData(handObject, "chargerObject") == clickedElement then
                                if getElementData(clickedElement, "pump.Use") then
                                    print("Használatban van!")
                                else       
                                    triggerServerEvent("attachPumpToPlayer", root, localPlayer, handObject)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)

function getPositionFromElementOffset(element, x, y, z)
    if element then
        m = getElementMatrix(element)
        return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1], x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2], x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
    end
end

setElementData(localPlayer, "pumpElement", false)

local soundTable = {
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [16] = true,
    [40] = true
}

addEventHandler("onClientWorldSound", getRootElement(), 
    function(group)
        if getElementType(source) == "vehicle" and electricVehicles[getElementModel(source)] then
            if soundTable[group] then
                cancelEvent()
            end
        end
    end
)