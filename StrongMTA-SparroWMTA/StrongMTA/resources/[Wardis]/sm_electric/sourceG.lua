electricVehicles = {
    [540] = true,
    [405] = true,
}

function checkElectricVehFromElement(vehicle, vehModeID) 
    local tempState = false
    if not vehModeID then
    	vehModeID = getElementModel(vehicle) or 400
    end

    if electricVehicles[vehModeID] then
        tempState = true
    end
    
    return tempState
end