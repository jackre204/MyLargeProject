function getPositionFromElementOffset(element, x, y, z)
    if element then
        m = getElementMatrix(element)
        return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1], x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2], x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
    end
end

farmMarkerColor = {197, 172, 119, 100}

farmRentMarkerColor = {124, 197, 118, 100}


defaultRentTime = 60000*60*24*7

worldX, worldY = -25.6328125, -364.9140625 -- # DO NOT TOUCH IT!
farmInteriorPosition = {-23.140625, -367.431640625, 5005.4296875} -- # DO NOT TOUCH IT!

function getPositionInfrontOfElement(x,y,z, rot, meters)
    local meters = (type(meters) == "number" and meters) or 3
    local posX, posY, posZ = x,y,z
    posX = posX - math.sin(math.rad(rot)) * meters
    posY = posY + math.cos(math.rad(rot)) * meters
    rot = rot + math.cos(math.rad(rot))
    return posX, posY, posZ , rot
end

permissionMenu = {"Szerszámhasználat", "Fejés és tojásgyűjtés", "Farm nyitás/zárás", "Állatgondozás", "Nagyker vásárlás", "Állat eladás"}

products = {
    [1] = {
        name = "Tojás",
        price = 100,
    },
    [2] = {
        name = "Tej",
        price = 500,
    }
}
