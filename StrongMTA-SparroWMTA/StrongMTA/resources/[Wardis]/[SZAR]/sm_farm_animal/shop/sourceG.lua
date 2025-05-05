deliveryPoints = {
    [1] = {
        dropPoint = {102.63758850098, -90.09553527832, 1.4385304450989, 263},
    }
    
}

function getPositionFromElementOffset(element, offsetX, offsetY, offsetZ)
	local m = getElementMatrix(element)
	return offsetX * m[1][1] + offsetY * m[2][1] + offsetZ * m[3][1] + m[4][1],
          offsetX * m[1][2] + offsetY * m[2][2] + offsetZ * m[3][2] + m[4][2],
          offsetX * m[1][3] + offsetY * m[2][3] + offsetZ * m[3][3] + m[4][3]
end

function getPositionFromOffset(m, offsetX, offsetY, offsetZ)
	return offsetX * m[1][1] + offsetY * m[2][1] + offsetZ * m[3][1] + m[4][1],
          offsetX * m[1][2] + offsetY * m[2][2] + offsetZ * m[3][2] + m[4][2],
          offsetX * m[1][3] + offsetY * m[2][3] + offsetZ * m[3][3] + m[4][3]
end

function rotateAround(angle, offsetX, offsetY, baseX, baseY)
	angle = math.rad(angle)

	offsetX = offsetX or 0
	offsetY = offsetY or 0

	baseX = baseX or 0
	baseY = baseY or 0

	return baseX + offsetX * math.cos(angle) - offsetY * math.sin(angle),
          baseY + offsetX * math.sin(angle) + offsetY * math.cos(angle)
end