local redNumbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36}
local blackNumbers = {2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35}
local blockPosition = {0.51, 0.425, -1.33, -0.299}
local blockSizeX = (blockPosition[3] - blockPosition[1]) / 12
local blockSizeY = (blockPosition[4] - blockPosition[2]) / 3

ROULETTE_TAX = 0.05 -- 5%

maximumBet = 500000 -- in dollars
interactionTime = 60000 -- in ms

availableCoins = { 
	[1] = {objID = 1853, worth = 1},
	[2] = {objID = 1854, worth = 5},
	[3] = {objID = 1855, worth = 25},
	[4] = {objID = 1856, worth = 50},
	[5] = {objID = 1857, worth = 100},
	[6] = {objID = 1858, worth = 500},
}

wheelNumbers = {
	[0] = 0,
	[32] = 1,
	[15] = 2,
	[19] = 3,
	[4] = 4,
	[21] = 5,
	[2] = 6,
	[25] = 7,
	[17] = 8,
	[34] = 9,
	[6] = 10,
	[27] = 11,
	[13] = 12,
	[36] = 13,
	[11] = 14,
	[30] = 15,
	[8] = 16,
	[23] = 17,
	[10] = 18,
	[5] = 19,
	[24] = 20,
	[16] = 21,
	[33] = 22,
	[1] = 23,
	[20] = 24,
	[14] = 25,
	[31] = 26,
	[9] = 27,
	[22] = 28,
	[18] = 29,
	[29] = 30,
	[7] = 31,
	[28] = 32,
	[12] = 33,
	[35] = 34,
	[3] = 35,
	[26] = 36
}

numberDegree = 360 / 37

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function getFieldRealCoord(x, y)
	return reMap(x, 301, 675, blockPosition[1] + blockSizeX / 2, blockPosition[3] - blockSizeX / 2),
		     reMap(y, 48, 143, blockPosition[2] + blockSizeY / 2, blockPosition[4] - blockSizeY / 2)
end

function rotateAround(angle, x, y, x2, y2)
	x2 = x2 or 0
	y2 = y2 or 0

	local theta = math.rad(angle)
	local rotatedX = x * math.cos(theta) - y * math.sin(theta) + x2
	local rotatedY = x * math.sin(theta) + y * math.cos(theta) + y2

	return rotatedX, rotatedY
end

function isObjectWithinDistance(object1, object2, meters)
  local x,y,z = getElementPosition(object1)
  local x2,y2,z2 = getElementPosition(object2)
  if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) <= meters then
    return true
  else
    return false
  end
end

function getDetailsFromName(name)
	local fieldNumbers = {}
	local fieldName = name
	local oneFieldName = name
	local priceMultipler = 1

	if type(name) == "table" then
		local nameLength = #name

		if nameLength == 1 then
			name = name[1]
			fieldName = name
			oneFieldName = name
		else
			if nameLength > 1 and nameLength <= 4 then
				local haveNumber = false

				for i = 1, #name do
					if not tonumber(name[i]) then
						haveNumber = true
						break
					end
				end

				if not haveNumber then
					if #name == 2 then
						fieldNumbers = name
						name = "split"
						fieldName = "split"
						oneFieldName = false
						priceMultipler = 17
					elseif #name == 3 then
						fieldNumbers = name
						name = "three line"
						fieldName = "three line"
						oneFieldName = false
						priceMultipler = 11
					elseif #name == 4 then
						fieldNumbers = name
						name = "corner"
						fieldName = "corner"
						oneFieldName = false
						priceMultipler = 8
					end
				end
			end

			if type(name) == "table" then
				if string.sub(name[1], 4, 5) == "12" and tonumber(name[2]) and tonumber(name[3]) then
					if tonumber(name[2]) > 0 then
						for i = tonumber(name[2]), tonumber(name[2]) + 2 do
							table.insert(fieldNumbers, i)
						end

						for i = tonumber(name[3]), tonumber(name[3]) + 2 do
							table.insert(fieldNumbers, i)
						end

						fieldName = "six line"
						priceMultipler = 5
						oneFieldName = false
					else
						table.insert(fieldNumbers, 0)

						for i = tonumber(name[3]), tonumber(name[3]) + 2 do
							table.insert(fieldNumbers, i)
						end

						fieldName = "corner"
						priceMultipler = 8
						oneFieldName = false
					end
				elseif string.sub(name[1], 4, 5) == "12" and tonumber(name[2]) then
					for i = tonumber(name[2]), tonumber(name[2]) + 2 do
						table.insert(fieldNumbers, i)
					end

					fieldName = "three line"
					priceMultipler = 11
					oneFieldName = false
				else
					name = name[1]
					fieldName = name
					oneFieldName = name
				end
			end
		end
	end

	if #fieldNumbers < 1 then
		if tonumber(name) then
			fieldName = "straight " .. name
			priceMultipler = 35
		elseif name == "red" then
			fieldNumbers = redNumbers
			priceMultipler = 1
		elseif name == "black" then
			fieldNumbers = blackNumbers
			priceMultipler = 1
		elseif name == "even" then
			for i = 2, 36, 2 do
				table.insert(fieldNumbers, i)
			end

			priceMultipler = 1
		elseif name == "odd" then
			for i = 1, 35, 2 do
				table.insert(fieldNumbers, i)
			end

			priceMultipler = 1
		elseif string.find(name, "-") then
			local nameSplit = split(name, "-")

			for i = nameSplit[1], nameSplit[2] do
				table.insert(fieldNumbers, i)
			end

			priceMultipler = 1
		elseif string.sub(name, 1, 3) == "2to" then
			local number = tonumber(string.sub(name, -1))

			for i = 0, 33, 3 do
				table.insert(fieldNumbers, i + number)
			end

			fieldName = "2to" .. string.sub(name, -1)
			priceMultipler = 2
		elseif string.sub(name, 4, 5) == "12" then
			local number = 12 * (tonumber(string.sub(name, 1, 1)) - 1)

			for i = 1 + number, 12 + number do
				table.insert(fieldNumbers, i)
			end

			fieldName = string.sub(name, 1, 3) .. " 12"
			priceMultipler = 2
		else
			return false
		end
	end

	return fieldNumbers, fieldName, oneFieldName, (priceMultipler*0.8)
end
