function rotateAround(angle, x, y, x2, y2)
	local theta = math.rad(angle)
	local rotatedX = x * math.cos(theta) - y * math.sin(theta) + (x2 or 0)
	local rotatedY = x * math.sin(theta) + y * math.cos(theta) + (y2 or 0)
	return rotatedX, rotatedY
end

pedPositions = {
	{0.5, 1.85, 0.7},
	{-0.9, 2.75, 0.7},
	{-0.9, -2.2, 1},
	{-0.9, -5.1, 1},
	{-0.5, -5.1, 1},
	{-0.5, 1.85, 0.7},
	{0.5, -3.1, 1},
	{-0.5, -3.1, 1},
	{-0.9, -4.2, 1},
	{0.85, 1.85, 0.7},
	{-0.5, 0.95, 0.7},
	{-0.9, 1.85, 0.7},
	{-0.9, -3.1, 1},
	{0.5, 3.65, 0.7},
	{-0.9, 0.95, 0.7},
	{0.5, 2.75, 0.7},
	{0.85, 0.95, 0.7},
	{0.5, 0.95, 0.7},
	{0.5, -5.1, 1},
	{-0.5, -2.2, 1},
	{0.85, -2.2, 1},
	{0.85, -5.1, 1},
	{-0.5, 2.75, 0.7},
	{0.85, -3.1, 1},
	{0.5, -2.2, 1},
	{0.85, -4.2, 1},
	{-0.5, 3.65, 0.7},
	{-0.9, 3.65, 0.7},
	{0.85, 3.65, 0.7},
	{-0.5, -4.2, 1},
	{0.85, 2.75, 0.7},
	{0.5, -4.2, 1}
}

pedBasePositions = {
	{-1.5, -2},
	{-1.5, -1},
	{-1.5, 0},
	{-1.5, 1},
	{-1.5, 2}
}

busStops = {}

markerPoints = {
	normal = {},
	country = {}
}

pedPoints = {
	normal = {},
	country = {}
}

function initBusStop(lineType, baseX, baseY, baseZ, rotation)
	local markerX, markerY = rotateAround(rotation, -4, 0)
	--outputChatBox(markerX)
	table.insert(markerPoints[lineType], {baseX + markerX, baseY + markerY, baseZ})

	if setObjectBreakable then
		local objectElement = createObject(1257, baseX, baseY, baseZ + 0.15, 0, 0, rotation)

		if isElement(objectElement) then
			setObjectBreakable(objectElement, false)
			busStops[objectElement] = true
		end
	end

	local markerId = #markerPoints[lineType]

	pedPoints[lineType][markerId] = {}

	for i = 1, #pedBasePositions do
		local pedX, pedY = rotateAround(rotation, pedBasePositions[i][1], pedBasePositions[i][2])

		table.insert(pedPoints[lineType][markerId], {baseX + pedX, baseY + pedY, baseZ, rotation + 90})
	end
end
--palo
--2558.23046875, 48.434097290039, 26.484375
local busStopsTable = {
	{1598.8460693359, -1866.6883544922+0.4, 13.538970947266, 90},
	{1105.0649414062, -1845.0974121094-1.2, 13.553685188293, 90},
	{1230.2077636719, -2460.2141113281-0.2, 9.2858304977417, 252},
	{2269.0854492188, -2314.1853027344, 13.554687, -45},
	{2894.7385253906-0.5, -1138.8572998047, 11.107291221619, 0},
	{2338.0830078125-0.1, 171.05575561523-0.1, 26.484375, 180},
	{2185.2380371094, 47.922920227051, 26.467205047607, 90},
	{1369.5296630859, 220.82875061035-0.6, 19.5546875, 65},
	{817.97930908203, 341.62881469727+3, 20.042499542236, 196-90},
	{709.01110839844+0.5, 323.52151489258+0.4, 20.116222381592, 100},
	{-788.51171875, 753.06463623047, 18.23987197876, 30},
	{-1228.0736083984, 1798.185546875-0.3, 41.382453918457, -110},
	{-1393.7149658203-2, 2288.6782226562+0.5, 55.84582901001-0.5, 25},
	{-1509.3958740234, 2677.2414550781, 55.8359375, 89},
	{-1824.2994384766, 2152.9458007812, 7.5175275802612, 28},
	{-2495.2634277344, 2337.4643554688-0.5, 4.984375, 90},
	{-2492.0725097656, 2253.9921875+1.3, 4.984375, 265}
}

for k, v in ipairs(busStopsTable) do
	initBusStop("normal", v[1], v[2], v[3], v[4])
end

--initBusStop("normal", 1598.8460693359, -1866.6883544922+0.4, 13.538970947266, 90)