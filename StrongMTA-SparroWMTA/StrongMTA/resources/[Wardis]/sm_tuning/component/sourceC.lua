vehicleComponents = {
    [526] = {
        ["FrontBump"] = {1, 2, 3, 4, 5, 6},
        ["RearBump"] = {1, 2, 3, 4},
        ["Spoilers"] = {1, 2, 3, 4, 5, 6, 7},
        ["SideSkirts"] = {1, 2, 3, 4, 5},
        ["FrontFends"] = {1, 2, 3, 4},
        ["RearFends"] = {1, 2,},
        ["FrontLights"] = {1, 2, 3},
        ["Bonnets"] = {1, 2, 3, 4, 5},
        ["Acces"] = {1, 2, 3, 4, 5, 6, 7}
    },

    [402] = {
        ["Bonnets"] = {1, 2, 3, 4},
        ["Spoilers"] = {1, 2},
        ["FrontFends"] = {1, 2},
        ["RearFends"] = {1, 2,},
        ["Roof"] = {1},
        ["FrontBump"] = {1, 2,},
        ["SideSkirts"] = {1, 2},
    },

    [540] = {
        ["SideSkirts"] = {1},
        ["FrontBump"] = {1},
        ["RearBump"] = {1},
    },

    [507] = {
        ["FrontBump"] = {1, 2, 3},
        ["RearBump"] = {1, 2, 3},
        ["Spoilers"] = {1},
        ["SideSkirts"] = {1, 2},
        ["FrontFends"] = {1},
        ["RearFends"] = {1},
        ["Bonnets"] = {1},
        ["Acces"] = {1, 2},
        ["Roof"] = {1}
    },

    [426] = {
        ["FrontBump"] = {1, 2},
        ["Spoilers"] = {1, 2},
        ["SideSkirts"] = {1},
        ["Acces"] = {1},
        ["FrontLights"] = {1},
    },

    [439] = {
        ["FrontBump"] = {1, 2, 3, 4, 5},
        ["Spoilers"] = {1, 2},
        ["RearBump"] = {1, 2, 3, 4},
        ["Spoilers"] = {1, 2, 3},
        ["SideSkirts"] = {1, 2, 3, 4, 5},
        ["FrontFends"] = {1},
        ["RearFends"] = {1},
        ["FrontLights"] = {1, 2, 3, 4, 5},
        ["RearLights"] = {1, 2, 3, 4},
        ["Exhaust"] = {1, 2, 3, 4},
        ["Bonnets"] = {1},
        ["Acces"] = {1}
    },

    [438] = {
        ["FrontBump"] = {1, 2},
        ["Spoilers"] = {1, 2},
        ["RearBump"] = {1, 2},
        ["Spoilers"] = {1, 2, 3},
        ["SideSkirts"] = {1, 2},

        ["Exhaust"] = {1, 2},
    },

    [491] = {
        ["FrontBump"] = {1, 2, 3},
        ["Spoilers"] = {1, 2},
        ["RearBump"] = {1, 2, 3, 4},
        ["AllFends"] = {1, 2, 3},
        ["FrontFends"] = {1, 2},
        ["RearFends"] = {1},
        ["Bonnets"] = {1, 2, 3, 4},
        ["SideSkirts"] = {1, 2, 3, 4},
    },

    [475] = {
        ["FrontBump"] = {1, 2},
        ["Spoilers"] = {1, 2},
        ["RearBump"] = {1},
        ["FrontFends"] = {1},
        ["RearFends"] = {1},
        ["Bonnets"] = {1},
        ["SideSkirts"] = {1},
        ["Acces"] = {1, 2, 3},
    },

    [587] = {
        ["Spoilers"] = {1, 2},
        ["Exhaust"] = {1, 2},
        ["Splitter"] = {1, 2},
        ["FrontDef"] = {1, 2},
        ["SideSkirts"] = {1},
        ["Acces"] = {1, 2},
    },

    [566] = {
        ["Spoilers"] = {1, 2, 3, 4, 5},
        ["FrontFends"] = {1, 2, 3},
        ["Splitter"] = {1, 2, 3, 4, 5},
        ["Exhaust"] = {1, 2, 3, 4, 5, 6},
        ["Roof"] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
        ["Acces"] = {1, 2},
    }

    
}

upgradesFromData = {
	["Spoilers"] = {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164}
}

function updateVehicleTuningComponent(vehicle, componentName, forceId)
    if not isElement(vehicle) then return false end
    if not vehicle then return end
    if not getElementModel(vehicle) then return end
    local i = 0
    while i <= 20 do
        local name = componentName .. tostring(i)       
        setVehicleComponentVisible(vehicle, name, false)
        setVehicleComponentVisible(vehicle, componentName .. "Glass" .. tostring(i), false)
        if i > 0 and not getVehicleComponentPosition(vehicle, name) then
            break
        end
        i = i + 1
    end
    local id = 0
    if componentName == "Spoilers" then
        updateVehicleTuningUpgrade(vehicle, "Spoilers")
    end
    if type(forceId) == "number" then
        id = componentName..forceId
    elseif not forceId then
        id = getElementData(vehicle, componentName)
    else
        id = forceId
    end
    if not getElementData(vehicle, componentName)  then
        setTimer(function()
            if not getElementData(vehicle, componentName) then
                setElementData(vehicle, componentName, componentName.."0")
                id = getElementData(vehicle, componentName)
            end
            if getElementData(vehicle, componentName) then
                glass = string.gsub(getElementData(vehicle, componentName), componentName, "")
                setVehicleComponentVisible(vehicle, getElementData(vehicle, componentName) , true)
                setVehicleComponentVisible(vehicle, componentName .. "Glass" .. tonumber(glass), true)
            end
        end,500,1)
        return
    end
    glass = string.gsub(id, componentName, "")
    setVehicleComponentVisible(vehicle, id, true)
    setVehicleComponentVisible(vehicle, componentName .. "Glass" .. tonumber(glass), true)
end

function updateVehicleTuningUpgrade(vehicle, upgradeName)
    if not isElement(vehicle) then return false end
    if type(upgradeName) ~= "string" or not upgradesFromData[upgradeName] then 
        return false 
    end

    for i, id in ipairs(upgradesFromData[upgradeName]) do
        removeVehicleUpgrade(vehicle, id)
    end

    local index = tonumber(getElementData(vehicle, upgradeName))

    if not index then
        return false
    end
    if upgradeName == "Spoilers" then
        if index > #upgradesFromData[upgradeName] then
            return updateVehicleTuningComponent(vehicle, upgradeName, index - #upgradesFromData[upgradeName])
        elseif index == 0 then
            return updateVehicleTuningComponent(vehicle, upgradeName, 0)
        else
            updateVehicleTuningComponent(vehicle, upgradeName, -1)
        end
    end
    local id = upgradesFromData[upgradeName][index]         
    if id then
        return addVehicleUpgrade(vehicle, id)
    end 
end

local function updateVehicleTuning(sourceVehicle)
    if not isElement(sourceVehicle) then
        return false
    end

    for name in pairs(componentsFromData) do
        if not getElementData(sourceVehicle, name) then 
            break 
        end

        updateVehicleTuningComponent(sourceVehicle, name)
    end

    for name in pairs(upgradesFromData) do
        if not getElementData(sourceVehicle, name) then break end
        updateVehicleTuningUpgrade(sourceVehicle, name)
    end 

    return true
end

addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
            for name, comp in pairs(componentsFromData) do
                updateVehicleTuningComponent(v, name)
            end

            updateVehicleTuning(v)
        end
    end
)

addEventHandler("onClientElementStreamIn", getRootElement(), 
    function()
        if getElementType( source ) == "vehicle" then
            for name, comp in pairs(componentsFromData) do
                updateVehicleTuningComponent(source, name)
            end

            updateVehicleTuning(source)
        end
    end
)

addEventHandler("onClientElementDataChange", getRootElement(), 
    function (nameData, oldVaue)
        if getElementType(source) == "vehicle" then
            for name in pairs(componentsFromData) do
                if name == nameData then
                    updateVehicleTuning(source)
                end
            end
        end
    end
)