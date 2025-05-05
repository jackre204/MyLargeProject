gameTypes = {
	GOLD_RUSH = 1,
	GTA = 2,
	WESTERN = 3,
	STAR_WARS = 4
}

for k,v in pairs(gameTypes) do
	gameTypes[v] = k
end

machineModels = {
	GOLD_RUSH = 1515,
	GTA = 2618,
	WESTERN = 2640,
	STAR_WARS = 1948
}

gameResourceNames = {
	GOLD_RUSH = "sm_goldrush",
	GTA = "sm_gtaslot",
	WESTERN = "sm_westernslot",
	STAR_WARS = "sm_swslot"
}

function rotateAround(angle, offsetX, offsetY, originX, originY)
	angle = math.rad(angle)

	local cosAngle = math.cos(angle)
	local sinAngle = math.sin(angle)

	local rotatedX = offsetX * cosAngle - offsetY * sinAngle
	local rotatedY = offsetX * sinAngle + offsetY * cosAngle

	originX = originX or 0
	originY = originY or 0

	return originX + rotatedX, originY + rotatedY
end