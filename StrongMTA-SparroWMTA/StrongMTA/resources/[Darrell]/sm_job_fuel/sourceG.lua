debugMode = false

tankDepotModelId = 3073
tankStationModelId = 2908
truckModelId = 573
jobId = 7

jobStartPositions = {
	{1753.8073730469, -2515.2937011719, 13.546875},
}

startDestinations = {
	[1] = {
		name = "Globe Oil, Tartály #1",
		tankPosition = {1708.5788574219, -2488, 13.5546875},
		tankRotation = 0
	},
	[2] = {
		name = "Globe Oil, Tartály #2",
		tankPosition = {1708.5788574219, -2495, 13.5546875},
		tankRotation = 0
	},
	[3] = {
		name = "Globe Oil, Tartály #3",
		tankPosition = {1732.0465087891, -2463.0346679688, 13.5546875},
		tankRotation = 0
	},
	[4] = {
		name = "Globe Oil, Tartály #4",
		tankPosition = {1734.857421875, -2469.6887207031, 13.5546875},
		tankRotation = 0
	}
}

finalDestinations = {
	[1] = {
		name = "Palomino Creek, Tartály #1",
		tankPosition = {2420, 85, 25.5},
		tankRotation = 180
	},
	[2] = {
		name = "Palomino Creek, Tartály #2",
		tankPosition = {2420, 89, 25.5},
		tankRotation = 180
	},
	[3] = {
		name = "Palomino Creek, Tartály #3",
		tankPosition = {2420, 93, 25.5},
		tankRotation = 180
	},
	[4] = {
		name = "Palomino Creek, Tartály #4",
		tankPosition = {2420, 97, 25.5},
		tankRotation = 180
	},
	[5] = {
		name = "Blueberry, Tartály #1",
		tankPosition = {314.7141418457, -36, 0.6},
		tankRotation = 0
	},
	[6] = {
		name = "Blueberry, Tartály #2",
		tankPosition = {314.7141418457, -32, 0.6},
		tankRotation = 0
	},
	[7] = {
		name = "Tierra Robada, Tartály #1",
		tankPosition = {-709, 976.56414794922, 11.5},
		tankRotation = -90
	},
	[8] = {
		name = "Tierra Robada, Tartály #2",
		tankPosition = {-705, 976.56414794922, 11.5},
		tankRotation = -90
	},
	[9] = {
		name = "Tierra Robada, Tartály #3",
		tankPosition = {-701, 976.56414794922, 11.5},
		tankRotation = -90
	},
	[10] = {
		name = "Tierra Robada, Tartály #4",
		tankPosition = {-697, 976.56414794922, 11.5},
		tankRotation = -90
	},
	[11] = {
		name = "Tierra Robada, Tartály #6",
		tankPosition = {-1497.2, 1868, 31.5},
		tankRotation = 0
	},
	[12] = {
		name = "Tierra Robada, Tartály #5",
		tankPosition = {-1497.2, 1864, 31.5},
		tankRotation = 0
	},
	[13] = {
		name = "Tierra Robada, Tartály #7",
		tankPosition = {-1497.2, 1872, 31.5},
		tankRotation = 0
	},
	[14] = {
		name = "Bayside, Tartály #1",
		tankPosition = {-2253, 2280, 3.95},
		tankRotation = 90
	},
	[15] = {
		name = "Bayside, Tartály #2",
		tankPosition = {-2257, 2280, 3.95},
		tankRotation = 90
	},
	[16] = {
		name = "Bayside, Tartály #3",
		tankPosition = {-2261, 2280, 3.95},
		tankRotation = 90
	},
	[17] = {
		name = "Bayside, Tartály #4",
		tankPosition = {-2265, 2280, 3.95},
		tankRotation = 90
	},
	[18] = {
		name = "Bayside, Tartály #4",
		tankPosition = {-2269, 2280, 3.95},
		tankRotation = 90
	},
	[19] = {
		name = "Los Santos, Tartály #1",
		tankPosition = {1018, -894.22583007812, 41.3},
		tankRotation = -90
	},
	[20] = {
		name = "Los Santos, Tartály #2",
		tankPosition = {1022, -894.22583007812, 41.3},
		tankRotation = -90
	},
	[21] = {
		name = "Los Santos, Tartály #3",
		tankPosition = {1026, -894.22583007812, 41.3},
		tankRotation = -90
	},
}

function rotateAround(angle, offsetX, offsetY, baseX, baseY)
	angle = math.rad(angle)

	offsetX = offsetX or 0
	offsetY = offsetY or 0

	baseX = baseX or 0
	baseY = baseY or 0

	return baseX + offsetX * math.cos(angle) - offsetY * math.sin(angle),
          baseY + offsetX * math.sin(angle) + offsetY * math.cos(angle)
end

function getPositionFromElementOffset(element, x, y, z)
	local m = getElementMatrix(element)
	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
          x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
          x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end

function getPositionFromOffset(m, x, y, z)
	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
          x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
          x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end
