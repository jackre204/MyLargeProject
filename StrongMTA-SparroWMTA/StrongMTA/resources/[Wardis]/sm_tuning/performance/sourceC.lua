pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local screenX, screenY = guiGetScreenSize()

local hudExport = exports.sm_hud

addEvent("togglePerformanceTuning", true)
addEventHandler("togglePerformanceTuning", getRootElement(),
	function ()
		if state then
			addEventHandler("onClientRender", getRootElement(), renderPerformacePanel)
		end
	end
)

local bgH = screenY / respc(50)

fineBlock = {
	[1] = {
		{"engineAcceleration", "maxVelocity"},
		{70, 1000}
	},

	[2] = {
		{"brakeBias", "brakeDeceleration"},
		{-10, 50}
	},

	[3] = {
		{nil, "engineAcceleration"},
		{10, 55}
	},

	[4] = {
		{"centerOfMass", "centerOfMass"},
		{-0.5, 0.5}
	},
}

function closePerformanceTuningPanel()
	playerMoney = nil
	playerPP = nil
	playerVehicle = nil
	vehiclePoints = nil
	vehicleName = nil
	vehicleMark = nil
	tuningTable = nil
	allTuningPoints = nil
	fineTuningState = nil

	removeEventHandler("onClientRender", getRootElement(), renderPerformacePanel)
	removeEventHandler("onClientClick", getRootElement(), clickOnPerformancePanel)
end

function openPerformanceTuningPanel()
	playerMoney = getElementData(localPlayer, "char.Money") or 0
	playerPP = getElementData(localPlayer, "acc.premiumPoints") or 0
	local playerVehicle = getPedOccupiedVehicle(localPlayer)

	if playerVehicle then
		vehiclePoints = getElementData(playerVehicle, "vehicle.tuning.Points") or 0

		vehicleName = exports.sm_mods_veh:getCustomVehicleNameFromVehicle(playerVehicle)
		vehicleMark = exports.sm_mods_veh:getCustomVehicleManufacturer(getElementModel(playerVehicle))

		local acceleration = getElementData(playerVehicle, "vehicle.tuning.Turbo") or 0
		local topSpeed = getElementData(playerVehicle, "vehicle.tuning.Engine") or 0
		local dhesion = getElementData(playerVehicle, "vehicle.tuning.Tires") or 0
		local brake = getElementData(playerVehicle, "vehicle.tuning.Brakes") or 0
		local wheelLock = 0

		tuningTable = {
			[1] = acceleration,
			[2] = topSpeed,
			[3] = dhesion,
			[4] = brake,
			[5] = wheelLock,
		}

		allTuningPoints = 0

		for k, v in ipairs(tuningTable) do
			allTuningPoints = v + allTuningPoints
		end

		fineTuningState = true --getElementData(playerVehicle, "vehicle.tuning.Fine")

		addEventHandler("onClientRender", getRootElement(), renderPerformacePanel)
		addEventHandler("onClientClick", getRootElement(), clickOnPerformancePanel)
		
	end
end

local fontH = dxGetFontHeight(1, Raleway)

local posX = 4 + 3 + respc(30)

local tuningPointPrice = 500
local tuningCalculate = 1.2
local ppTuningCalculate = 1.1
local ppTuning = 22
local tuningPremiumPrice = 200
local maxPoints = 30

local currentSet = 0

local fineTuning = {
	[1] = {"Gyorsulás", "Végsebesség", -1, 1, 0, "fasz", "Gyorsulás - Végsebesség"},
	[2] = {"Első fék", "Hátsó fék", -1, 1, 0, "pina", "Fékek"},
	[3] = {"Jobb fogyasztás", "Jobb gyorsulás", -1, 1, 0, "apad", " Jobb fogyasztás - Gyorsulás"},
	[4] = {"Előre", "Hátra", -1, 1, 0, "apad2", "Súlypont"},
}

local savedTable = {}

local sliderWidth = respc(600) / 1.5
local sliderHeight = screenY * 0.008

function renderPerformacePanel()
	buttonsC = {}

	dxDrawRectangle(4, 4, respc(600), screenY - 8, tocolor(25, 25, 25, 250))
	dxDrawRectangle(4 +3, 4 + 3, respc(600) - 6, screenY / 25 - 6, tocolor(55, 55, 55, 120))
	dxDrawText(vehicleName, 4 + 3 + (respc(600) - 6) / 2, 4 + 3 + (screenY / 25 - 6) / 2, nil, nil, tocolor(200, 200, 200), 1, Raleway, "center", "center")

	dxDrawImage(3 + respc(600) - respc(140) - respc(20), 4 + screenY / 25, respc(140), respc(140), "files/marks/" .. vehicleMark .. ".png")

	dxDrawText("Készpénz: " .. formatNumber(playerMoney) .. " $", 4 + 3 + respc(20), 4 + 3 + (screenY / 25 - 6) + screenY * 0.01, nil, nil, tocolor(200, 200, 200), 1, Raleway, "left", "top")
	dxDrawText("PP: " .. formatNumber(playerPP) .. " PP", 4 + 3 + respc(20), 4 + 3 + (screenY / 25 - 6) + screenY * 0.01 + fontH, nil, nil, tocolor(200, 200, 200), 1, Raleway, "left", "top")
	
	local buyPointText = "Pont vásárlás"

	dxDrawText("Tuning pontok: " .. vehiclePoints .. " (+" .. allTuningPoints .. ") / 30 TP", 4 + 3 + respc(20), 4 + 3 + (screenY / 25 - 6) + screenY * 0.01 + fontH * 2, nil, nil, tocolor(200, 200, 200), 1, Raleway, "left", "top")

	if activeButtonC == "buyTuningPoint" then
		if vehiclePoints == 0 then
			calculatePointPrice = tuningPointPrice
			priceType = "$"
		elseif vehiclePoints >= ppTuning then
			priceType = "PP"
			calculatePointPrice = tonumber(((tuningPremiumPrice) * (ppTuningCalculate * (vehiclePoints + 1 - ppTuning))))
		else
			calculatePointPrice = tuningPointPrice * (ppTuningCalculate * vehiclePoints)
			priceType = "$"
		end

		if vehiclePoints + allTuningPoints >= maxPoints then
			buyPointText = "Összes megvéve"
		else
			buyPointText = "Pont vásárlás: " .. formatNumber(calculatePointPrice) .. " " .. priceType
		end
	else
		if vehiclePoints + allTuningPoints >= maxPoints then
			buyPointText = "Összes megvéve"
		end
	end

	drawButton("buyTuningPoint", buyPointText, 4 + 3 + respc(20), 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3, respc(300) - 3, (screenY / 25 - 6), {61, 122, 188}, false, Raleway, true, 0.75)

	local buttonH = (respc(600) - respc(60) - 6 - 3 * (8 + 1)) / 8

	dxDrawText("Gyorsulás: ", posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) - 3, nil, nil, tocolor(200, 200, 200), 0.8, Raleway, "left", "bottom")
	dxDrawRectangle(posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030), respc(600) - respc(60) - 6, screenY * 0.03, tocolor(45, 45, 45, 200))
	dxDrawText("Végsebesség: ", posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03))  - 3, nil, nil, tocolor(200, 200, 200), 0.8, Raleway, "left", "bottom")
	dxDrawRectangle(posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) , respc(600) - respc(60) - 6, screenY * 0.03, tocolor(45, 45, 45, 200))
	dxDrawText("Tapadás: ", posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 2 - 3, nil, nil, tocolor(200, 200, 200), 0.8, Raleway, "left", "bottom")
	dxDrawRectangle(posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 2, respc(600) - respc(60) - 6, screenY * 0.03, tocolor(45, 45, 45, 200))
	dxDrawText("Fék: ", posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 3 - 3, nil, nil, tocolor(200, 200, 200), 0.8, Raleway, "left", "bottom")
	dxDrawRectangle(posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 3, respc(600) - respc(60) - 6, screenY * 0.03, tocolor(45, 45, 45, 200))
	dxDrawText("Kerékfordulás: ", posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 4 - 3, nil, nil, tocolor(200, 200, 200), 0.8, Raleway, "left", "bottom")
	dxDrawRectangle(posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 4, respc(600) - respc(60) - 6, screenY * 0.03, tocolor(45, 45, 45, 200))

	
	for mainI, v in pairs(tuningTable) do
		for i = 1, v do
			local buttonX = posX + ((i - 1) * buttonH + (i * 3))
			dxDrawRectangle(buttonX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + 3 + (mainI - 1) * (((screenY * 0.025) + (screenY * 0.03))), buttonH, screenY * 0.03 - 6, tocolor(61, 122, 188))
		end

		drawButton("addTuning" .. mainI, "+", 4 + 3 + respc(600) - screenY * 0.03, 4 + 3 + fontH * 3 + screenY / 25 - 6 + 3 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + (mainI - 1) * (((screenY * 0.025) + (screenY * 0.03))), screenY * 0.03 - 6, screenY * 0.03 - 6, {61, 122, 188}, false, Raleway, true, 0.75)

		for i = 1, 8 do
			local buttonX = posX + ((i - 1) * buttonH + (i * 3))
			if i ~= 1 then
				dxDrawRectangle(buttonX - 3, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + 3 + (mainI - 1) * (((screenY * 0.025) + (screenY * 0.03))), 3, screenY * 0.03 - 6, tocolor(60, 60, 60, 190))
			end
		end
	end

	--dxDrawRectangle(posX, 4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 4, respc(600) / 1.5, screenY * 0.008)

	local cursorX, cursorY = getCursorPosition()

	if tonumber(cursorX) and tonumber(cursorY) then
		cursorX = cursorX * screenX
		cursorY = cursorY * screenY
	end

	local fineColor = tocolor(188, 64, 61, 210)
	local fineText = "Nincs"

	if fineTuningState then
		fineColor = tocolor(61, 122, 188, 210)
		fineText = "Van"
	end

	dxDrawText("Finomhang: " .. fineText, 4 + respc(600) / 2, (4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 4) + (sliderHeight + screenY * 0.05) + screenY * 0.03, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "bottom")

	for i = 1, #fineTuning do
		set = fineTuning[i]
		--iprint(set)

		local lineY = (4 + 3 + fontH * 3 + screenY / 25 - 6 + screenY * 0.015 + 3 + screenY / 25 + (screenY * 0.030) + ((screenY * 0.025) + (screenY * 0.03)) * 4) + (sliderHeight + screenY * 0.05) * (i - 1) + screenY * 0.15

		sliderBaseX = 4 + respc(600) / 2 - sliderWidth / 2
		local sliderBaseY = lineY + (sliderHeight - respc(10)) / 2

		sliderX = sliderBaseX + reMap(tonumber(set[5]), -1, 1, 0, sliderWidth - respc(15))
		sliderY = lineY - sliderHeight / 2

		dxDrawText(set[7] .. " " .. math.ceil((set[5] * 100)) .. "%", sliderBaseX + respc(10), sliderBaseY - screenY * 0.002, nil, nil, tocolor(200, 200, 200, 200), 0.9, Raleway, "left", "bottom")

		dxDrawText(set[1], sliderBaseX - respc(3), sliderBaseY - screenY * 0.002 + (sliderHeight / 2), nil, nil, tocolor(200, 200, 200, 200), 0.7, Raleway, "right", "center")
		dxDrawText(set[2], sliderBaseX +sliderWidth + respc(3), sliderBaseY - screenY * 0.002 + (sliderHeight / 2), nil, nil, tocolor(200, 200, 200, 200), 0.65, Raleway, "left", "center")

		dxDrawRectangle(sliderBaseX, sliderBaseY, sliderWidth, sliderHeight, rgba(55, 55, 55, 200))
		dxDrawRectangle(sliderX, sliderBaseY, respc(15), sliderHeight, fineColor)

		if getKeyState("mouse1") and sliderMoveX then
			if activeSlider == set[6] then
				local sliderValue = (cursorX - sliderMoveX - sliderBaseX) / (sliderWidth - respc(15))

				if sliderValue < 0 then
					sliderValue = 0
				end

				if sliderValue > 1 then
					sliderValue = 1
				end

				set[5] = reMap(sliderValue, 0, 1, -1, 1)

				savedTable[i] = {set[5], fineBlock[i][1][1], fineBlock[i][1][2]}
			end
		else
			sliderMoveX = false
			activeSlider = false
		end

		if not sliderMoveX and activeButtonC == "setting_slider:" .. set[6] then
			sliderMoveX = cursorX - sliderX
			activeSlider = set[6] 
		end

		buttonsC["setting_slider:" .. set[6]] = {sliderX, sliderY, respc(15), sliderHeight}
	end

	if fineTuningState then
		drawButton("saveFine", "Finomhangolás mentése", 4 + 4,  screenY - screenY * 0.06 - screenY * 0.06 + 4, (respc(600) / 2) - 4 - 2, screenY * 0.06 - 8, {61, 122, 188}, false, Raleway, true, 0.75)
		drawButton("resetFine", "Finomhangolás alapértelmezése", 4 + 4 + (respc(600) / 2) - 2,  screenY - screenY * 0.06 - screenY * 0.06 + 4, (respc(600) / 2) - 4 - 2, screenY * 0.06 - 8, {61, 122, 188}, false, Raleway, true, 0.75)
	else
		drawButton("Finomhangolás", "Finomhangolás vásárlása", 4 + 4,  screenY - screenY * 0.06 - screenY * 0.06 + 4, respc(600) - 8, screenY * 0.06 - 8, {61, 122, 188}, false, Raleway, true, 0.75)
	end
	drawButton("Finomhangolás vásárlása", "Pontok újraoszása", 4 + 4,  screenY - screenY * 0.06, respc(600) - 8, screenY * 0.06 - 8, {61, 122, 188}, false, Raleway, true, 0.75)

	if tonumber(cursorX) and tonumber(cursorY) then
		activeButtonC = false
		
		if not buttonsC then
			return
		end
	
		for k, v in pairs(buttonsC) do
			if cursorX >= v[1] and cursorY >= v[2] and cursorX <= v[1] + v[3] and cursorY <= v[2] + v[4] then
				activeButtonC = k
				break
			end
		end
	else
		activeButtonC = false
	end
end

addCommandHandler("1",
	function()
		openPerformanceTuningPanel()
	end
)

addCommandHandler("2",
	function()
		closePerformanceTuningPanel()
	end
)

function clickOnPerformancePanel(sourceKey, keyState) 
	if sourceKey == "left" and keyState == "down" then
    	if activeButtonC then
   			if activeButtonC == "buyTuningPoint" then
      			if vehiclePoints + allTuningPoints  >= maxPoints then
                	print("Max " .. maxPoints .. " pont!")
            	else
                	if priceType == "$" then
             			if exports.sm_core:getMoney(localPlayer) >= calculatePointPrice then
                			exports.sm_core:takeMoney(localPlayer, calculatePointPrice, false)

                        	vehiclePoints = vehiclePoints + 1
							
							setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.Points", vehiclePoints)
                		else
            				print("Nincs elég pénzed!")
            			end
					else
                		local currentPP = getElementData(localPlayer, "acc.premiumPoints") or 0

            			if currentPP >= calculatePointPrice then
                   			setElementData(localPlayer, "acc.premiumPoints", currentPP - calculatePointPrice)

                   			vehiclePoints = vehiclePoints + 1
							setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.Points", vehiclePoints)
            			else
            				print("Nincs elég PP-d!")
                		end
            		end
    			end
			elseif activeButtonC == "saveFine" then
				--iprint(savedTable)
				setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tunining.fine", toJSON(savedTable))

				addTuningToVehicle(getPedOccupiedVehicle(localPlayer), savedTable, "fineTuning")
			elseif string.find(activeButtonC, "addTuning") then
				local buttonName = utf8.gsub(activeButtonC, "addTuning", "")

				local number = tonumber(buttonName)

				if vehiclePoints > 0 then
					if tuningTable[number] + 1 ~= 9 then
						if computeDifference(number, tuningTable[number] + 1) and (number ~= #tuningTable)  then
							tuningTable[number] = tuningTable[number] + 1
											
							vehiclePoints = vehiclePoints - 1
							setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.Points", vehiclePoints)

							addTuningToVehicle(getPedOccupiedVehicle(localPlayer), number, tuningTable[number])
						elseif number == #tuningTable then
							tuningTable[number] = tuningTable[number] + 1
									
							vehiclePoints = vehiclePoints - 1
							setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.Points", vehiclePoints)

							addTuningToVehicle(getPedOccupiedVehicle(localPlayer), number, tuningTable[number])
						else
							print("Max eltérés 3 lehet!")
						end
					end
				else
					print("Nincs pontod!")
				end
			end
		end
   	end
end

function addTuningToVehicle(currentVeh, tuningName, tuningPoint)
	if isElement(currentVeh) then
		if tuningName and tuningPoint then
			if tuningName == 1 then
				setElementData(currentVeh, "vehicle.tuning.Turbo", tuningPoint)
				setElementData(currentVeh, "vehicle.tuning.ECU", tuningPoint)
				setElementData(currentVeh, "vehicle.tuning.Transmission", tuningPoint)
			elseif tuningName == 2 then
				setElementData(currentVeh, "vehicle.tuning.Engine", tuningPoint)
			elseif tuningName == 3 then
				setElementData(currentVeh, "vehicle.tuning.Tires", tuningPoint)
			elseif tuningName == 4 then
				setElementData(currentVeh, "vehicle.tuning.Brakes", tuningPoint)
			elseif tuningName == 5 then
				setElementData(currentVeh, "vehicle.tuning.WeightReduction", tuningPoint)
			elseif tuningName == "fineTuning" then

			end
			
			if tuningName ~= "fineTuning" then
				allTuningPoints = allTuningPoints + 1
			end

			triggerServerEvent("makeTuningEvent", currentVeh)
		end
	end
end

function formatNumber(n) 
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$') 
	return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right 
end 

function computeDifference(wantedTuningName, wantedTuningLevel)
	for tuningName, tuningLevel in pairs(tuningTable) do
		if tuningName ~= #tuningTable then
			local levelDifference = wantedTuningLevel - tuningLevel

			if levelDifference >= 4 then
				--print(tuningName, levelDifference)
				return false
			end
		end
	end

	return true
end


addEventHandler("onClientElementDataChange", getRootElement(),
	function(dataKey, oldData, newData)
		if dataKey == "char.Money" then
			playerMoney = newData
		elseif dataKey == "acc.premiumPoints" then
			playerPP = newData
		end
    end
)

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end
--openPerformanceTuningPanel()
