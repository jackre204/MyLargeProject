function getCompanyVehicles(id)
    local vehicles = {}
    for _,v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v,"company.companyID") then
            if tonumber(getElementData(v,"company.companyID")) == tonumber(id) then
                table.insert(vehicles,v)
            end
        end
    end
    return vehicles
end

function getEXPToNextLevel(level)
    local xp = 0
    if availableLevels[level] then
        xp = availableLevels[level]
    else
        if level > #availableLevels then
            xp = availableLevels[#availableLevels] + (10000*(level-#availableLevels))
        end
    end
    return xp
end

slotPrice = 250

unloadVehicleAfterQuit = 20 --5*60 -- Másodperc

availableLevels = {
    [1] = 1000,
    [2] = 1130,
    [3] = 1400,
    [4] = 1500,
    [5] = 1750,
    [6] = 1920,
    [7] = 2120,
    [8] = 2500,
    [9] = 2700,
    [10] = 2900,
    [11] = 3100,
    [12] = 3400,
    [13] = 3700,
    [14] = 4100,
    [15] = 4400,
    [16] = 4600,
    [17] = 4910,
    [18] = 5320,
    [19] = 5720,
    [20] = 6060,
    [21] = 6510,
    [22] = 6900,
    [23] = 7240,
    [24] = 7500,
    [25] = 7900,
    [26] = 8500,
    [27] = 9000,
}

taxesByRank = {
    [1] = 25000,
    [2] = 40000,
    [3] = 60000,
    [4] = 85000,
    [5] = 120000,
}

panels = {
    {id=1,text="Kezdőlap"},
    {id=2,text="Tagok"},
    {id=3,text="Rangok"},
    {id=4,text="Járművek"},
    {id=5,text="Tevékenységnapló"},
}

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second

    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second

    --timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end

    return timestamp
end

gWeekDays = { "Vasárnap", "Hétfő", "Kedd", "Szerda", "Csütörtök", "Péntek", "Szombat" }
gMonthNames = {"Január","Február","Március","Április","Május","Június","Július","Augusztus","Szeptember","Október","November","December"}
function formatDate(format, escaper, timestamp)
    escaper = (escaper or "'"):sub(1, 1)
    local time = getRealTime(tonumber(timestamp))
    local formattedDate = ""
    local escaped = false

    time.year = time.year + 1900
    time.month = time.month + 1

    local datetime = { d = ("%02d"):format(time.monthday), h = ("%02d"):format(time.hour), i = ("%02d"):format(time.minute), m = ("%02d"):format(time.month), s = ("%02d"):format(time.second), w = gWeekDays[time.weekday+1]:sub(1, 2), W = gWeekDays[time.weekday+1], y = tostring(time.year):sub(-2), Y = time.year }

    for char in format:gmatch(".") do
        if (char == escaper) then escaped = not escaped
        else formattedDate = formattedDate..(not escaped and datetime[char] or char) end
    end

    return formattedDate
end

function getVehicleNameFromShop(vehicle)
    return exports.sm_vehiclenames:getCustomVehicleName(getElementModel(vehicle))
end

function findVehicleByDBID(id)
	local vehicle = false
	for _,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v,"company.vehicleID") == id then
			vehicle = v
			break
		end
	end
	return vehicle
end

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

local characters = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}

function createRandomPlateText()
	local plate = ""

 	for i = 1, 3 do
    	plate = plate..characters[math.random(1, #characters)]
	end
	plate = plate.."-"
	for i = 1, 3 do
		plate = plate..math.random(1, 9)
	end
	
	return plate
end

function findPlayerToCompany(player, partialNick)
	if not partialNick and not isElement(player) and type(player) == "string" then
		partialNick = player
		player = nil
	end
	
	local candidates = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	local partialNick = string.lower(partialNick)
	
	if player and partialNick == "*" then
		return player, string.gsub(getPlayerName(player), "_", " ")
	elseif tonumber(partialNick) then
		for k, v in ipairs(getElementsByType("player")) do
			if getElementData(v, "loggedIn") and getElementData(v, "playerID") == tonumber(partialNick) then
				matchPlayer = v
				break
			end
		end
		candidates = {matchPlayer}
	else
		partialNick = string.gsub(partialNick, "-", "%%-")
		
		for k, v in ipairs(getElementsByType("player")) do
			if isElement(v) then
				local playerName = string.lower(string.gsub(getElementData(v, "visibleName") or getPlayerName(v), "_", " "))

				if playerName and string.find(playerName, tostring(partialNick)) then
					local posStart, posEnd = string.find(playerName, tostring(partialNick))
					
					if posEnd - posStart > matchNickAccuracy then
						matchNickAccuracy = posEnd - posStart
						matchNick = playerName
						matchPlayer = v
						candidates = {v}
					elseif posEnd - posStart == matchNickAccuracy then
						matchNick = nil
						matchPlayer = nil
						table.insert(candidates, v)
					end
				end
			end
		end
	end
	
	if not matchPlayer or not isElement(matchPlayer) then
		if isElement(player) then
			if #candidates == 0 then
				outputChatBox("A kiválasztott játékos #d75959nem található.", player, 255, 255, 255, true)
			else
				outputChatBox("A játékos található ezzel a névrészlettel:", player, 255, 255, 255, true)
			
				for k = 1, #candidates do
					local v = candidates[k]

					if isElement(v) then
						outputChatBox("#b7ff00(" .. tostring(getElementData(v, "playerID")) .. ") #fffffff" .. string.gsub(getPlayerName(v), "_", " "), player, 255, 255, 255, true)
					end
				end
			end
		end
		
		return false
	else
		if getElementData(matchPlayer, "loggedIn") then
			return matchPlayer, string.gsub(getElementData(matchPlayer, "visibleName") or getPlayerName(matchPlayer), "_", " ")
		else
			outputChatBox("A kiválasztott játékos #d75959nincs bejelentkezve.", player, 255, 255, 255, true)
			return false
		end
	end
end