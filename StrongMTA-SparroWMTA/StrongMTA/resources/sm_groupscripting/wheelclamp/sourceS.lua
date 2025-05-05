function registerEvent(event, element, func)
    addEvent(event, true)
    addEventHandler(event, element, func)
end

function addWheelClamp(vehicle)
    if isElement(vehicle) and getElementType(vehicle) == "vehicle" then
        setElementData(vehicle, "vehicle.wheelClamp", true)
    end
end


function removeWheelClamp(vehicle)
    if isElement(vehicle) and getElementType(vehicle) == "vehicle" then
        setElementData(vehicle, "vehicle.wheelClamp", false)
    end
end

registerEvent("wheelclampSapplyAnimation", root, function(state)
    if state then
        setPedAnimation(source, "bomber", "bom_plant_loop", -1, true, false)
    else
        setPedAnimation(source)
    end
end)