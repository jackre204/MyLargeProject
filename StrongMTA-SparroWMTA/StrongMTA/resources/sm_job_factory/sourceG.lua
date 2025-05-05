shelfPositions = {
	{1427.6, 2353.4, -3, 270},
	{1419.2, 2353.4, -3, 270},
	{1419.2, 2368.5, -3, 270},
	{1427.9, 2368.5, -3, 270}
}

function rotateAround(angle, x1, y1, x2, y2)
	angle = math.rad(angle)

	local rotatedX = x1 * math.cos(angle) - y1 * math.sin(angle)
	local rotatedY = x1 * math.sin(angle) + y1 * math.cos(angle)

	return rotatedX + (x2 or 0), rotatedY + (y2 or 0)
end

itemIds = {98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111}

itemNames = {
	[98] = exports.sm_items:getItemName(98),
	[99] = exports.sm_items:getItemName(99),
	[100] = exports.sm_items:getItemName(100),
	[101] = exports.sm_items:getItemName(101),
	[102] = exports.sm_items:getItemName(102),
	[103] = exports.sm_items:getItemName(103),
	[104] = exports.sm_items:getItemName(104),
	[105] = exports.sm_items:getItemName(105),
	[106] = exports.sm_items:getItemName(106),
	[107] = exports.sm_items:getItemName(107),
	[108] = exports.sm_items:getItemName(108),
	[109] = exports.sm_items:getItemName(109),
	[110] = exports.sm_items:getItemName(110),
	[111] = exports.sm_items:getItemName(111)
}