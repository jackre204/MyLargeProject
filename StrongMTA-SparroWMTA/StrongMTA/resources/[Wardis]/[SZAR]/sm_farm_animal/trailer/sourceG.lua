function getElementSpeed(theElement,unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function isMouseInPosition(x,y,width,height)
	if not isCursorShowing() then
		return false
	end
	local s = Vector2(
        guiGetScreenSize()
    )
	local cx,cy = getCursorPosition()
	local cx,cy = (cx*s.x),(cy*s.y)	
	return ( 
        (cx >= x 
        and cx <= x+width) 
        and (cy >= y 
        and cy <= y+height) 
    )
end

trailerTable = {
    [611] = true,
    [608] = true
}

compatibleVeh = {
    [400] = true,
    
    [489] = true
}

hookPos = {
    [404] = {
        0,-2.9,-0.35
    },
    [445] = {
        0,-2.9,-0.35
    }
}