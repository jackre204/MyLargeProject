trashPositions = {
    {2407.1042480469, -1725.8686523438, 13.613626480103}
}

function getPositionFromElementOffset(element, x, y, z)
	local m = false

	if not isElementStreamedIn(element) then
		local rx, ry, rz = getElementRotation(element, "ZXY")

		rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
		m = {}

		m[1] = {}
		m[1][1] = math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry)
		m[1][2] = math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry)
		m[1][3] = -math.cos(rx) * math.sin(ry)
		m[1][4] = 1

		m[2] = {}
		m[2][1] = -math.cos(rx) * math.sin(rz)
		m[2][2] = math.cos(rz) * math.cos(rx)
		m[2][3] = math.sin(rx)
		m[2][4] = 1

		m[3] = {}
		m[3][1] = math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx)
		m[3][2] = math.sin(rz) * math.sin(ry) - math.cos(rz) * math.cos(ry) * math.sin(rx)
		m[3][3] = math.cos(rx) * math.cos(ry)
		m[3][4] = 1

		m[4] = {}
		m[4][1], m[4][2], m[4][3] = getElementPosition(element)
		m[4][4] = 1
	else
		m = getElementMatrix(element)
	end

	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
		   x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
		   x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end