local defaultX, defaultY, defaultZ = 1902.4825439453, -1816.3282470703, 13.539972305298

function createSuperChargers()
    for k = 1, 9 do
        local chargerObject = createObject(6929, defaultX , defaultY + (k - 1) * 2.5, defaultZ - 1, 0, 0, 269)
        local handChargerObject = createObject(7238, defaultX - 0.01, defaultY - 0.15 + (k - 1) * 2.5, defaultZ + 0.82, 0, 35, 269)
        
        setElementData(chargerObject, "fuelPumpObject", handChargerObject)
        setElementData(handChargerObject, "chargerObject", chargerObject)
        setElementData(handChargerObject, "defaultPos", {getElementPosition(handChargerObject)})

        setElementCollisionsEnabled(handChargerObject, false)
    end
end

addEventHandler("onResourceStart", resourceRoot,
    function()
        createSuperChargers()
    end
)

addEvent("attachPumpToPlayer", true)
addEventHandler("attachPumpToPlayer", getRootElement(),
    function(sourcePlayer, pumpElement, vehicle)
        if vehicle then
            removeElementData(vehicle, "pumpElement")
            removeElementData(vehicle, "vehicle.chargerState")
            detachElements(pumpElement)
        end

        exports.sm_boneattach:attachElementToBone(pumpElement, sourcePlayer, 12, 0.15, 0.05, 0.05, 90, - 90, 0)
        setElementData(sourcePlayer, "pumpElement", pumpElement)
   end
)

addEvent("setHandObjectDefaultPos", true)
addEventHandler("setHandObjectDefaultPos", getRootElement(),
    function(sourcePlayer, pumpObject)
        if isElement(sourcePlayer) and not pumpObject then
            pumpElement = getElementData(sourcePlayer, "pumpElement")
        else
            pumpElement = pumpObject
        end

        if pumpElement and isElement(pumpElement) then
            exports.sm_boneattach:detachElementFromBone(pumpElement)
            setElementCollisionsEnabled(pumpElement, false)

            removeElementData(sourcePlayer, "pumpElement")

            setElementData(getElementData(pumpElement, "chargerObject"), "pump.Use", false)

            local x, y, z = unpack(getElementData(pumpElement, "defaultPos"))
            setElementPosition(pumpElement, x, y, z)
            setElementRotation(pumpElement, 0, 35, 269)
        end
    end
)

addEvent("attachPumpToVehicle", true)
addEventHandler("attachPumpToVehicle", getRootElement(),
    function(sourceVehicle, pumpElement, sourcePlayer)
        exports.sm_boneattach:detachElementFromBone(pumpElement)
        setElementCollisionsEnabled(pumpElement, false)
        attachElements(pumpElement, sourceVehicle, - 1.14, - 1.9, 0.3, - 90, 90)

        setElementData(sourceVehicle, "vehicle.chargerState", true)

        setElementData(sourceVehicle, "pumpElement", pumpElement)
        
        removeElementData(sourcePlayer, "pumpElement")
    end
)

addEventHandler("onElementDestroy", getRootElement(),
    function()
        local pumpElement = getElementData(source, "pumpElement") or false

        if pumpElement then
            triggerEvent("setHandObjectDefaultPos", root, source, pumpElement)
        end
    end
)

addEventHandler("onClientPlayerQuit", getRootElement(),
    function()
        if getElementData(localPlayer, "pumpElement") then
            triggerEvent("setHandObjectDefaultPos", root, source)
        end        
    end
)

for k, v in ipairs(getElementsByType("vehicle")) do
    removeElementData(v, "vehicle.chargerState")
end

for k, v in ipairs(getElementsByType("player")) do
    removeElementData(v, "pumpElement")
end

local vehPanel = exports.sm_vehiclepanel

setTimer(
    function()
        for k, v in pairs(getElementsByType("vehicle", getRootElement())) do
            if getElementData(v, "vehicle.chargerState") then
                local currentElectric = getElementData(v, "vehicle.fuel") or 0
                
                if vehPanel:getTheFuelTankSizeOfVehicle(getElementModel(v)) >= currentElectric then
                    iprint(v)
                    setElementData(v, "vehicle.fuel", currentElectric + 0.1)
                end
            end
        end
    end, 1250, 0
)