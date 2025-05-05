local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = 1

local lastNavigate = 0
local lastInteraction = 0


function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local renderDataDraw = {
	buttons = {},
	activeButton = false
}

local shopEntrancePosition = {1368.8203125, -1766.2354736328, 13.60781288147}
local shopColShape = createColSphere(shopEntrancePosition[1], shopEntrancePosition[2], shopEntrancePosition[3], 0.75)
local shopMarker = false

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedres)
		if getResourceName(startedres) == "sm_hud" then
			responsiveMultipler = exports.sm_hud:getResponsiveMultipler()
		elseif getResourceName(startedres) == "sm_interiors" then
			if isElement(shopMarker) then
				destroyElement(shopMarker)
			end

			shopMarker = exports.sm_interiors:createCoolMarker(shopEntrancePosition[1], shopEntrancePosition[2], shopEntrancePosition[3], "business_active")
		else
			if source == getResourceRootElement() then
				local sm_hud = getResourceFromName("sm_hud")

				if sm_hud then
					if getResourceState(sm_hud) == "running" then
						responsiveMultipler = exports.sm_hud:getResponsiveMultipler()
					end
				end

				local sm_interiors = getResourceFromName("sm_interiors")

				if sm_interiors then
					if getResourceState(sm_interiors) == "running" then
						if isElement(shopMarker) then
							destroyElement(shopMarker)
						end

						shopMarker = exports.sm_interiors:createCoolMarker(shopEntrancePosition[1], shopEntrancePosition[2], shopEntrancePosition[3], "business_active")
					end
				end
			end
		end
	end)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if isElement(shopMarker) then
			destroyElement(shopMarker)
		end
	end)

local inColShape = false

addEventHandler("onClientColShapeHit", shopColShape,
	function (hitElement, matchingDimension)
		if hitElement == localPlayer then
			if matchingDimension then
				inColShape = true
				exports.sm_hud:showInteriorBox("Autószalon", "Nyomj [E] gombot a kereskedés megtekintéséhez.", false, "carshop")
			end
		end
	end)

addEventHandler("onClientColShapeLeave", shopColShape,
	function (hitElement, matchingDimension)
		if hitElement == localPlayer then
			if inColShape then
				inColShape = false
				exports.sm_hud:endInteriorBox()
			end
		end
	end)

local inTheShop = false
local pressTick = 0

bindKey("e", "up",
	function ()
		if inColShape and not inTheShop then
			if getTickCount() >= pressTick + 5000 then
				pressTick = getTickCount()

				fadeCamera(false, 2, 25, 25, 25)
				setTimer(enterShop, 2000, 1)

				inTheShop = true
				exports.sm_hud:endInteriorBox()
				setElementFrozen(localPlayer, true)
			else
				outputChatBox("#d75959[SeeMTA]:#ffffff Csak 5 másodpercenként használhatod a bejáratot.", 255, 255, 255, true)
			end
		end
	end)

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

local availableVehicles = {}
local availableColors = {
	{25, 25, 25},
	{255, 255, 255},
	{123, 188, 61},
	{186, 188, 61},
	{188, 63, 61},
	{61, 123, 188},
}

local showroomObject = false
local previewVehicle = false
local driverPed = false
local occupantPed = false

local RobotoFont = false
local mesmerizeFont = false

local bcgMusic = false

local currentMoney = ""
local currentPP = ""

local selectedVehicle = 1
local selectedColor = {unpack(availableColors[1])}

local vehicleName = ""
local vehicleManufacturer = ""
local vehicleManufacturerBack = ""
local vehicleManufacturerNext = ""
local vehiclePrice = 0
local vehiclePremium = 0
local vehicleLimit = 0
local isCarLimitFinish = false
local carModelCount = 0

local cinematicCamera = true
local freeLookCamera = false
local freeLook = {
	zoomInterpolation = false,
	zoom = 1,
	z = 0,
	r = 0,
	faceR = 0,
	faceZ = 0
}
local firstPersonCamera = false
local cameraInterpolation = false
local cameraStage = 1

local exitingProcessStarted = false
local components = {"bonnet_dummy", "boot_dummy", "door_lf_dummy", "door_rf_dummy", "door_lr_dummy", "door_rr_dummy"}

local promptActive = false
local promptWidth = 300
local promptHeight = 140
local promptPosX = screenX / 2 - promptWidth / 2
local promptPosY = screenY / 2 - promptHeight / 2

local buttons = {}
local activeButton = false

function exitShop()
	inTheShop = false

	removeEventHandler("onClientRender", getRootElement(), renderTheShowroom)
	removeEventHandler("onClientKey", getRootElement(), handleShowroomKeys)
	removeEventHandler("onClientElementDataChange", getRootElement(), handleDataChanges)
	removeEventHandler("onClientClick", getRootElement(), handlePromptClick)
	vehicleLimitFinal = false

	if isElement(showroomObject) then
		destroyElement(showroomObject)
	end

	if isElement(previewVehicle) then
		destroyElement(previewVehicle)
	end

	if isElement(driverPed) then
		destroyElement(driverPed)
	end
	
	if isElement(occupantPed) then
		destroyElement(occupantPed)
	end

	if isElement(RobotoFont) then
		destroyElement(RobotoFont)
	end

	if isElement(mesmerizeFont) then
		destroyElement(mesmerizeFont)
	end
	
	if isElement(bcgMusic) then
		destroyElement(bcgMusic)
	end

	showroomObject = nil
	previewVehicle = nil
	driverPed = nil
	occupantPed = nil
	RobotoFont = nil
	mesmerizeFont = nil
	bcgMusic = nil
	exitingProcessStarted = false

	setElementDimension(localPlayer, 0)
	setElementPosition(localPlayer, shopEntrancePosition[1], shopEntrancePosition[2], shopEntrancePosition[3])
	setElementRotation(localPlayer, 0, 0, 90)
	setElementFrozen(localPlayer, false)
	setCameraTarget(localPlayer)

	fadeCamera(true, 1, 25, 25, 25)
	showCursor(false)
	
	exports.sm_hud:showHUD()
end

function enterShop()
	availableVehicles = {}

	for i = 1, #vehiclesTable do
		local veh = vehiclesTable[i]

		if exports.sm_vehiclenames:getCustomVehicleName(veh.model) ~= getVehicleNameFromModel(veh.model) then
			table.insert(availableVehicles, veh)
		end
	end
	
	table.sort(availableVehicles,
		function (a, b)
			return utf8.lower(exports.sm_vehiclenames:getCustomVehicleName(b.model)) > utf8.lower(exports.sm_vehiclenames:getCustomVehicleName(a.model))
		end
	)
	
	local gtaVehicles = {}
	
	for i = 1, #vehiclesTable do
		local veh = vehiclesTable[i]

		if exports.sm_vehiclenames:getCustomVehicleName(veh.model) == getVehicleNameFromModel(veh.model) then
			table.insert(gtaVehicles, veh)
		end
	end
	
	table.sort(gtaVehicles,
		function (a, b)
			return utf8.lower(getVehicleNameFromModel(b.model)) > utf8.lower(getVehicleNameFromModel(a.model))
		end
	)
	
	for i = 1, #gtaVehicles do
		table.insert(availableVehicles, gtaVehicles[i])
	end

	local playerId = getElementData(localPlayer, "playerID")

	currentMoney = formatNumber(getElementData(localPlayer, "char.Money"))
	currentPP = formatNumber(getElementData(localPlayer, "acc.premiumPoints"))
	print(selectedVehicle)
	local veh = availableVehicles[selectedVehicle]
	if selectedVehicle == 1 then
		vehBack = availableVehicles[#availableVehicles]
	else
		vehBack = availableVehicles[selectedVehicle - 1]
		
	end
	if selectedVehicle == #availableVehicles then
		vehNext = availableVehicles[1]
	else
		vehNext = availableVehicles[selectedVehicle + 1]
	end
	
	local color = availableColors[math.random(1, #availableColors)]

	previewVehicle = createVehicle(veh.model, -2460.658203125, 2234.8549804688, 4.8422479629517 + 0.5)
	setVehicleOverrideLights(previewVehicle, 1)
	setVehicleColor(previewVehicle, color[1], color[2], color[3])
	setElementDimension(previewVehicle, playerId)
	selectedColor = {unpack(color)}

	exports.sm_tuning:applyHandling(previewVehicle)

	vehicleName = exports.sm_vehiclenames:getCustomVehicleName(veh.model)
	vehicleManufacturer = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(veh.model)):gsub(" ", "-")
	vehicleManufacturerBack = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(vehBack.model)):gsub(" ", "-")
	vehicleManufacturerNext = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(vehNext.model)):gsub(" ", "-")
	
	vehiclePrice = veh.price
	vehiclePremium = veh.premium
	vehicleLimit = veh.limit

	fuelType = getVehicleHandling(previewVehicle)["engineType"]
	driveType = getVehicleHandling(previewVehicle)["driveType"]
	tankCapacity = exports.sm_vehiclepanel:getTheFuelTankSizeOfVehicle(veh.model)
	bootCapacity = exports.sm_items:getWeightLimit("vehicle", previewVehicle)
	topSpeed = getVehicleHandling(previewVehicle)["maxVelocity"]
	tankEat = exports.sm_vehiclepanel:getTheConsumptionOfVehicle(getElementModel(previewVehicle))
	

	if fuelType == "petrol" then
		fuelType = "Benzin"
	elseif fuelType == "diesel" then
		fuelType = "Dízel"
	else
		fuelType = "Elektromos"
	end

	if driveType == "fwd" then
		driveType = "Elsőkerék"
	elseif driveType == "rwd" then
		driveType = "Hátsókerék"
	else
		driveType = "Összkerék"
	end

	fuelType = "#3d7abc" .. fuelType
	driveType = "#3d7abc" .. driveType
	tankCapacity = "#3d7abc" .. tankCapacity .. " l"
	bootCapacity = "#3d7abc" .. bootCapacity .. " kg"
	topSpeed = "#3d7abc" .. topSpeed .. " km/h"
	tankEat = "#3d7abc" .. tankEat * 10 .. " l/100 km"
	

	triggerServerEvent("countCarsByModel", localPlayer, veh.model)

	driverPed = createPed(0, 2137.8525390625, 3774.87109375, 1011.10000038147)
	setElementCollisionsEnabled(driverPed, false)
	warpPedIntoVehicle(driverPed, previewVehicle, 0)
	setElementAlpha(driverPed, 0)
	setElementDimension(driverPed, playerId)
	
	occupantPed = createPed(0, 2137.8525390625, 3774.87109375, 1011.100000381471)
	setElementCollisionsEnabled(occupantPed, false)
	warpPedIntoVehicle(occupantPed, previewVehicle, 1)
	setElementAlpha(occupantPed, 0)
	setElementDimension(occupantPed, playerId)
	setTimer(function()
		setVehicleEngineState(previewVehicle, false)
	end, 200, 1)
	

	cinematicCamera = true
	freeLookCamera = false
	firstPersonCamera = false

	cameraInterpolation = getTickCount()
	cameraStage = 1

	fadeCamera(true, 1, 25, 25, 25)
	setElementDimension(localPlayer, playerId)
	setElementPosition(localPlayer, 1686.8603515625, 1833.818359375, 14.814833641052)
	setElementFrozen(localPlayer, true)
	setElementRotation(localPlayer, 0, 0, 0)
	
	mesmerizeFont = dxCreateFont("files/fonts/mesmerize.ttf", resp(20), false, "antialiased")
	RobotoFont = dxCreateFont("files/fonts/Roboto.ttf", resp(12), false, "antialiased")

	bcgMusic = playSound("files/sounds/showroom.mp3", true)

	exports.sm_hud:hideHUD()
	showCursor(true)
	
	addEventHandler("onClientRender", getRootElement(), renderTheShowroom)
	addEventHandler("onClientKey", getRootElement(), handleShowroomKeys)
	addEventHandler("onClientElementDataChange", getRootElement(), handleDataChanges)
	addEventHandler("onClientClick", getRootElement(), handlePromptClick)
	vehicleLimitFinal = false
end

function rotateAround(angle, x1, y1, x2, y2)
	angle = math.rad(angle)

	local rotatedX = x1 * math.cos(angle) - y1 * math.sin(angle)
	local rotatedY = x1 * math.sin(angle) + y1 * math.cos(angle)

	return rotatedX + (x2 or 0), rotatedY + (y2 or 0)
end

renderDataDraw = {}
renderDataDraw.colorSwitches = {}
renderDataDraw.lastColorSwitches = {}
renderDataDraw.startColorSwitch = {}
renderDataDraw.lastColorConcat = {}

function processColorSwitchEffect(key, color, duration, type)
	if not renderDataDraw.colorSwitches[key] then
		if not color[4] then
			color[4] = 255
		end

		renderDataDraw.colorSwitches[key] = color
		renderDataDraw.lastColorSwitches[key] = color

		renderDataDraw.lastColorConcat[key] = table.concat(color)
	end

	duration = duration or 500
	type = type or "Linear"

	if renderDataDraw.lastColorConcat[key] ~= table.concat(color) then
		renderDataDraw.lastColorConcat[key] = table.concat(color)
		renderDataDraw.lastColorSwitches[key] = color
		renderDataDraw.startColorSwitch[key] = getTickCount()
	end

	if renderDataDraw.startColorSwitch[key] then
		local progress = (getTickCount() - renderDataDraw.startColorSwitch[key]) / duration

		local r, g, b = interpolateBetween(
				renderDataDraw.colorSwitches[key][1], renderDataDraw.colorSwitches[key][2], renderDataDraw.colorSwitches[key][3],
				color[1], color[2], color[3],
				progress, type
		)

		local a = interpolateBetween(renderDataDraw.colorSwitches[key][4], 0, 0, color[4], 0, 0, progress, type)

		renderDataDraw.colorSwitches[key][1] = r
		renderDataDraw.colorSwitches[key][2] = g
		renderDataDraw.colorSwitches[key][3] = b
		renderDataDraw.colorSwitches[key][4] = a

		if progress >= 1 then
			renderDataDraw.startColorSwitch[key] = false
		end
	end

	return renderDataDraw.colorSwitches[key][1], renderDataDraw.colorSwitches[key][2], renderDataDraw.colorSwitches[key][3], renderDataDraw.colorSwitches[key][4]
end

function drawButton(key, label, x, y, w, h, activeColor, postGui)
	local buttonColor
	if renderDataDraw.activeButton == key then
		buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], 175})}
	else
		buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], 125})}
	end

	local alphaDifference = 175 - buttonColor[4]

	dxDrawRectangle(x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 175 - alphaDifference), postGui)
	dxDrawInnerBorder(2, x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 125 + alphaDifference), postGui)

	labelFont = Roboto18L
	postGui = postGui or false
	labelScale =  0.85

	dxDrawText(label, x, y, x + w, y + h, tocolor(200, 200, 200, 200), labelScale, RobotoFont, "center", "center", false, false, postGui, true)

	renderDataDraw.buttons[key] = {x, y, w, h}
end

function dxDrawInnerBorder(thickness, x, y, w, h, color, postGUI)
	thickness = thickness or 2
	dxDrawLine(x, y, x + w, y, color, thickness, postGUI)
	dxDrawLine(x, y + h, x + w, y + h, color, thickness, postGUI)
	dxDrawLine(x, y, x, y + h, color, thickness, postGUI)
	dxDrawLine(x + w, y, x + w, y + h, color, thickness, postGUI)
end

function renderTheShowroom()
	local now = getTickCount()
	local vehX, vehY, vehZ = getElementPosition(previewVehicle)
	
	renderDataDraw.buttons = {}
	
	--setVehicleEngineState(previewVehicle, false)

	buttons = {}

	if freeLookCamera then
		if firstPersonCamera then
			local boneX, boneY, boneZ = getPedBonePosition(firstPersonCamera, 8)

			if getKeyState("d") or getKeyState("arrow_r") then
				if freeLook.faceR > -90 then
					freeLook.faceR = freeLook.faceR - 0.75
				end
			elseif getKeyState("a") or getKeyState("arrow_l") then
				if freeLook.faceR < 90 then
					freeLook.faceR = freeLook.faceR + 0.75
				end
			end

			if getKeyState("w") or getKeyState("arrow_u") then
				if freeLook.faceZ <= 0.5 then
					freeLook.faceZ = freeLook.faceZ + 0.01
				end
			elseif getKeyState("s") or getKeyState("arrow_d") then
				if freeLook.faceZ >= -1 then
					freeLook.faceZ = freeLook.faceZ - 0.01
				end
			end

			local rotatedX, rotatedY = rotateAround(freeLook.faceR, 0, 1)

			setCameraMatrix(boneX, boneY, boneZ, boneX + rotatedX, boneY + rotatedY, boneZ + freeLook.faceZ)

			dxDrawText("A #d75959visszalépéshez #ffffffnyomd meg az #3d7abc[E] #ffffffgombot.", 0, screenY - respc(120), screenX, 0, tocolor(255, 255, 255), 1, RobotoFont, "center", "top", false, false, true, true, true)
		else
			dxDrawRectangle(0, screenY - respc(50), screenX, respc(50), tocolor(25, 25, 25))
			-- Navigáció segédlet
			local fontHeight = dxGetFontHeight(1, RobotoFont) * 1.5

			local w1 = dxGetTextWidth("Cinematic kamera", 1, RobotoFont) + fontHeight
			local w2 = dxGetTextWidth("Kamera mozgatás", 1, RobotoFont) + fontHeight * 4
			local w3 = dxGetTextWidth("Interakció", 1, RobotoFont) + fontHeight
			local w4 = dxGetTextWidth("Lámpák", 1, RobotoFont) + fontHeight
			local w5 = dxGetTextWidth("Közelítés / Távolodás", 1, RobotoFont) + fontHeight
			local w6 = dxGetTextWidth("Jármű beindítása / leállítása", 1, RobotoFont) + fontHeight


			local lineWidth = w1 + w2 + w3 + w4 + w5 + w6 + respc(10) * 8
			local lineHeight = respc(48)
			
			local linePosX = screenX - lineWidth
			local linePosY = screenY - respc(50)

			dxDrawRectangle(linePosX, linePosY, lineWidth, lineHeight, tocolor(25, 25, 25))

			dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/q.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawText("Cinematic kamera", linePosX + fontHeight + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")

			linePosX = linePosX + w1 + respc(10)

			dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/w.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawImage(linePosX + respc(5) + fontHeight, linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/a.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawImage(linePosX + respc(5) + fontHeight * 2, linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/s.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawImage(linePosX + respc(5) + fontHeight * 3, linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/d.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawText("Kamera mozgatás", linePosX + fontHeight * 4 + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")

			linePosX = linePosX + w2 + respc(10)

			dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/e.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawText("Interakció", linePosX + fontHeight + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")
			
			linePosX = linePosX + w3 + respc(10)
			
			dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/l.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawText("Lámpák", linePosX + fontHeight + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")
			
			linePosX = linePosX + w4 + respc(10)
			
			dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/mouse.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawText("Közelítés / Távolodás", linePosX + fontHeight + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")
			
			linePosX = linePosX + w5 + respc(10)
			
			dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/i.png", 0, 0, 0, tocolor(200, 200, 200, 100))
			dxDrawText("Jármű beindítása / leállítása", linePosX + fontHeight + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")

			-- Kamera

			if getKeyState("w") or getKeyState("arrow_u") then
				if freeLook.z <= 6 then
					freeLook.z = freeLook.z + 0.05
				end
			elseif getKeyState("s") or getKeyState("arrow_d") then
				if freeLook.z >= 0 then
					freeLook.z = freeLook.z - 0.05
				end
			end

			if getKeyState("a") or getKeyState("arrow_l") then
				freeLook.r = freeLook.r - 0.55
				
			elseif getKeyState("d") or getKeyState("arrow_r") then
				freeLook.r = freeLook.r + 0.55
			end

			if freeLook.zoomInterpolation then
				local elapsedTime = now - freeLook.zoomInterpolation
				local progress = elapsedTime / 500

				if progress >= 1 then
					freeLook.zoomInterpolation = false
				end

				freeLook.zoom = interpolateBetween(0.75, 0, 0, 1, 0, 0, progress, "Linear")
			end

			local rotatedX, rotatedY = rotateAround(90 + freeLook.r, 5 / freeLook.zoom, 5 / freeLook.zoom)

			setCameraMatrix(vehX + rotatedX, vehY + rotatedY, vehZ + freeLook.z, vehX, vehY, vehZ)

			-- Interakció
			for i = 1, #components do
				local componentName = components[i]
				local componentX, componentY, componentZ = getVehicleComponentPosition(previewVehicle, componentName, "world")

				if componentX then
					local onScreenX, onScreenY = getScreenFromWorldPosition(componentX, componentY, componentZ + 0.15)

					if onScreenX and onScreenY then
						if onScreenX >= screenX / 2 - resp(23) and onScreenY >= screenY / 2 - resp(23) and onScreenX <= screenX / 2 - resp(23) + 48 and onScreenY <= screenY / 2 - resp(23) + 48 then
							dxDrawImage(onScreenX - resp(128) / 2, onScreenY - resp(128) / 2, resp(128), resp(128), "files/images/hover.png", 0, 0, 0, tocolor(200, 200, 200, 200))
						else
							dxDrawImage(onScreenX - resp(128) / 2, onScreenY - resp(128) / 2, resp(128), resp(128), "files/images/circle.png", 0, 0, 0, tocolor(200, 200, 200, 200))
						end
					end

					if componentName == "door_lf_dummy" or componentName == "door_rf_dummy" then
						local openratio = 0

						if componentName == "door_lf_dummy" then
							openratio = getVehicleDoorOpenRatio(previewVehicle, 2)
						else
							openratio = getVehicleDoorOpenRatio(previewVehicle, 3)
						end

						local onScreenX, onScreenY = getScreenFromWorldPosition(componentX, componentY - 0.5, componentZ + 0.15)

						if onScreenX and onScreenY and openratio == 1 then
							if onScreenX >= screenX / 2 - resp(23) and onScreenY >= screenY / 2 - resp(23) and onScreenX <= screenX / 2 - resp(23) + 48 and onScreenY <= screenY / 2 - resp(23) + 48 then
								dxDrawImage(onScreenX - resp(128) / 2, onScreenY - resp(128) / 2, resp(128), resp(128), "files/images/hover.png")
							else
								dxDrawImage(onScreenX - resp(128) / 2, onScreenY - resp(128) / 2, resp(128), resp(128), "files/images/circle.png", 0, 0, 0, tocolor(200, 200, 200, 200))
							end
						end
					end
				end
			end

			dxDrawImage(screenX / 2 - resp(128) / 2, screenY / 2 - resp(128) / 2, resp(128), resp(128), "files/images/arc.png")
		end

		return
	end
	
	local mesmerizeHeight = respc(100)

	dxDrawRectangle(0, 0, screenX, respc(50), tocolor(25, 25, 25))
	dxDrawRectangle(screenX - respc(405), respc(55), respc(400), respc(100), tocolor(25, 25, 25))
	
	drawButton("backVehicle", "<", screenX - respc(405) + 3, respc(55) + 3, respc(30), respc(100) - 6, {61, 122, 188}, true)
	drawButton("nextVehicle", ">", screenX - respc(35) - 3, respc(55) + 3, respc(30), respc(100) - 6, {61, 122, 188}, true)
	dxDrawImage(0, 0, respc(50), respc(50), exports.sm_core:getServerLogo())
	dxDrawText("#3d7abcStrong#ffffffMTA - Autókereskedés", respc(50), 0, screenX, respc(50), tocolor(200, 200, 200, 200), 1, mesmerizeFont, "left", "center", false, false, false, true)

	for i = 1, 3 do
		local oneSize = mesmerizeHeight
		local startX = (screenX - respc(205)) - (oneSize * 3) / 2
		local lineX = startX + (i - 1) * (oneSize + respc(5))
		if i == 1 then
			dxDrawImage(lineX - respc(5), respc(55), oneSize, oneSize, "files/images/logos/" .. vehicleManufacturerBack .. ".png")
		elseif i == 2 then
			dxDrawImage(lineX - respc(5), respc(55), oneSize, oneSize, "files/images/logos/" .. vehicleManufacturer .. ".png")
		elseif i == 3 then
			dxDrawImage(lineX - respc(5), respc(55), oneSize, oneSize, "files/images/logos/" .. vehicleManufacturerNext .. ".png")
		end
	end

	dxDrawRectangle(5, screenY / 2 - respc(200), respc(300), respc(280) + 24, tocolor(25, 25, 25))
	dxDrawRectangle(8, screenY / 2 - respc(200) + 3, respc(300) - 6, respc(40), tocolor(45, 45, 45))
	drawText(vehicleName, 8, screenY / 2 - respc(200) + 3, respc(300) - 6, respc(40), tocolor(200, 200, 200, 200), 0.8, mesmerizeFont)
	dxDrawRectangle(8, screenY / 2 - respc(200) + 6 + respc(40), respc(300) - 6, respc(40), tocolor(35, 35, 35))
	drawText("Üzemanyag típus: " .. fuelType, 8, screenY / 2 - respc(200) + 6 + respc(40), respc(300) - 6, respc(40), tocolor(200, 200, 200, 200), 0.8, mesmerizeFont)
	local startY = (screenY / 2 - respc(200) + 6 + respc(40)) + respc(40) + 3
	dxDrawRectangle(8, startY, respc(300) - 6, respc(40), tocolor(35, 35, 35))
	drawText("Tank méret: " .. tankCapacity, 8, startY, respc(300) - 6, respc(40), tocolor(200, 200, 200, 200), 0.8, mesmerizeFont)
	local startY = startY + 3 + respc(40)
	dxDrawRectangle(8, startY, respc(300) - 6, respc(40), tocolor(35, 35, 35))
	drawText("Végsebesség: " .. topSpeed, 8, startY, respc(300) - 6, respc(40), tocolor(200, 200, 200, 200), 0.8, mesmerizeFont)
	local startY = startY + 3 + respc(40)
	dxDrawRectangle(8, startY, respc(300) - 6, respc(40), tocolor(35, 35, 35))
	drawText("Fogyasztás: " .. tankEat, 8, startY, respc(300) - 6, respc(40), tocolor(200, 200, 200, 200), 0.8, mesmerizeFont)
	local startY = startY + 3 + respc(40)
	dxDrawRectangle(8, startY, respc(300) - 6, respc(40), tocolor(35, 35, 35))
	if vehicleLimit == -1 then
		drawText("Limit: Nincs", 8, startY, respc(300) - 6, respc(40), tocolor(200, 200, 200, 200), 0.8, mesmerizeFont)
	else
		drawText("Limit: " .. carModelCount .. "/" .. vehicleLimit, 8, startY, respc(300) - 6, respc(40), tocolor(200, 200, 200, 200), 0.8, mesmerizeFont)
	end
	local startY = startY + 3 + respc(40)
	dxDrawRectangle(8, startY, respc(300) - 6, respc(40), tocolor(35, 35, 35))

	dxDrawRectangle(0, screenY - respc(50), screenX, respc(50), tocolor(25, 25, 25))
	
	for i = 1, #availableColors do
		local x = ((8 + respc(150)) + (i * respc(48) - respc(48)) - (#availableColors * respc(48)) / 2) + 2
		local y = startY + respc(4)

		local sx = respc(48) - respc(16)
		local sy = respc(48) - respc(16)

		if activeButton == "selectcolor:" .. i then
			dxDrawRectangle(x, y, sx, sy, tocolor(availableColors[i][1], availableColors[i][2], availableColors[i][3], 200))
		else
			dxDrawRectangle(x, y, sx, sy, tocolor(availableColors[i][1], availableColors[i][2], availableColors[i][3], 255))
		end

		buttons["selectcolor:" .. i] = {x, y, sx, sy}
	end
	
	dxDrawText("Ár: " .. formatNumber(vehiclePrice) .. " $", respc(10), screenY - respc(50), screenX - respc(25), screenY - respc(50) + respc(50), tocolor(255, 255, 255), 1, RobotoFont, "left", "center", false, false, false, true)

	-- Navigációs segédlet
	local fontHeight = dxGetFontHeight(1, RobotoFont) * 1.5

	local w1 = dxGetTextWidth("Vásárlás", 1, RobotoFont) + fontHeight * 2
	local w2 = dxGetTextWidth("Szabad kamera", 1, RobotoFont) + fontHeight
	local w3 = dxGetTextWidth("Navigáció", 1, RobotoFont) + fontHeight * 2
	local w4 = dxGetTextWidth("Kilépés", 1, RobotoFont) + fontHeight * 2

	local lineWidth = w1 + w2 + w3 + w4 + respc(10) * 7
	local lineHeight = respc(48)
	
	local linePosX = screenX - lineWidth
	local linePosY = screenY - respc(50)

	
	--dxDrawRectangle(linePosX, linePosY, lineWidth, lineHeight, tocolor(0, 0, 0, 200))

	dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight * 4, fontHeight, "files/images/keys/enter.png", 0, 0, 0, tocolor(200, 200, 200, 100))
	dxDrawText("Vásárlás", linePosX + fontHeight * 2 + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")

	linePosX = linePosX + w1 + respc(10)

	dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/q.png", 0, 0, 0, tocolor(200, 200, 200, 100))
	dxDrawText("Szabad kamera", linePosX + fontHeight + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")

	linePosX = linePosX + w2 + respc(10)

	dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/left.png", 0, 0, 0, tocolor(200, 200, 200, 100))
	dxDrawImage(linePosX + respc(5) + fontHeight, linePosY + (lineHeight - fontHeight) / 2, fontHeight, fontHeight, "files/images/keys/right.png", 0, 0, 0, tocolor(200, 200, 200, 100))
	dxDrawText("Navigáció", linePosX + fontHeight * 2 + respc(10), linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")

	linePosX = linePosX + w3 + respc(10)

	dxDrawImage(linePosX + respc(5), linePosY + (lineHeight - fontHeight) / 2, fontHeight * 4, fontHeight, "files/images/keys/bcksp.png", 0, 0, 0, tocolor(200, 200, 200, 100))
	dxDrawText("Kilépés", linePosX + fontHeight * 3, linePosY, 0, linePosY + lineHeight, tocolor(200, 200, 200, 200), 1, RobotoFont, "left", "center")

	-- Megerősítő ablak
	if promptActive then
		if vehicleLimitFinal then
			dxDrawRectangle(promptPosX, promptPosY, promptWidth, promptHeight, tocolor(25, 25, 25))

			dxDrawRectangle(promptPosX + 2, promptPosY + 2, promptWidth - 4, 40, tocolor(35, 35, 35))

			drawText("Biztosan megszeretnéd vásárolni + 1000 PP-ért?", promptPosX, promptPosY, promptWidth, 40, tocolor(200, 200, 200, 200), 0.8, RobotoFont)

			drawButton("buyCarMoney", "Vásárlás", promptPosX + 4, promptPosY + 45 + 4, promptWidth - 8, 40, {61, 122, 188}, true)
			drawButton("cancelPrompt", "Mégsem", promptPosX + 4, promptPosY + 45 + 10 + 40, promptWidth - 8, 40, {215, 89, 89}, true)
		else
			dxDrawRectangle(promptPosX, promptPosY, promptWidth, promptHeight, tocolor(25, 25, 25))

			dxDrawRectangle(promptPosX + 2, promptPosY + 2, promptWidth - 4, 40, tocolor(35, 35, 35))

			drawText("Biztosan megszeretnéd vásárolni?", promptPosX, promptPosY, promptWidth, 40, tocolor(200, 200, 200, 200), 0.8, RobotoFont)

			drawButton("buyCarMoney", "Vásárlás", promptPosX + 4, promptPosY + 45 + 4, promptWidth - 8, 40, {61, 122, 188}, true)
			drawButton("cancelPrompt", "Mégsem", promptPosX + 4, promptPosY + 45 + 10 + 40, promptWidth - 8, 40, {215, 89, 89}, true)
		end
		
	end

	-- ** Egér

	local cx, cy = getCursorPosition()
	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

		renderDataDraw.activeButton = false
		if not renderDataDraw.buttons then
			return
		end
		for k,v in pairs(renderDataDraw.buttons) do
			if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
				renderDataDraw.activeButton = k
				break
			end
		end
	else
		renderDataDraw.activeButton = false
	end
	
	local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

		activeButton = false

		for k, v in pairs(buttons) do
			if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	else
		activeButton = false
	end

	-- Kamera
	if cameraInterpolation and now >= cameraInterpolation then
		local elapsedTime = now - cameraInterpolation

		if cameraStage == 1 then
			if elapsedTime >= 4000 and cinematicCamera then
				fadeCamera(false, 1, 25, 25, 25)
				setTimer(fadeCamera, 1000, 1, true, 1)
			end
			
			if elapsedTime >= 5000 and cinematicCamera then
				cameraStage = cameraStage + 1
				cameraInterpolation = now
			end
			
			local rot = interpolateBetween(
				10, 0, 0,
				20, 0, 0,
				elapsedTime / 5000, "OutQuad")

			local rotatedX, rotatedY = rotateAround(90 + rot, 5, 5)

			setCameraMatrix(vehX + rotatedX, vehY + rotatedY, vehZ + 0.55, vehX, vehY, vehZ)
		elseif cameraStage == 2 then
			local componentX, componentY, componentZ = getVehicleComponentPosition(previewVehicle, "boot_dummy", "world")
			
			if not componentX then
				cameraStage = cameraStage + 1
				cameraInterpolation = now
				return
			end
			
			if elapsedTime >= 6500 and cinematicCamera then
				fadeCamera(false, 1, 25, 25, 25)
				setTimer(fadeCamera, 1000, 1, true, 1)
			end
			
			if elapsedTime >= 7500 and cinematicCamera then
				cameraStage = cameraStage + 1
				cameraInterpolation = now
			end
			
			local pos = interpolateBetween(
				1.5, 0, 0,
				-2, 0, 0,
				elapsedTime / 7500, "Linear")
			
			setCameraMatrix(componentX, componentY + pos + 4, componentZ + 1.25, componentX, -componentY + pos + 4, 0)
		elseif cameraStage == 3 then
			if elapsedTime >= 9000 and cinematicCamera then
				fadeCamera(false, 1, 25, 25, 25)
				setTimer(fadeCamera, 1000, 1, true, 1)
			end
			
			if elapsedTime >= 10000 and cinematicCamera then
				cameraStage = cameraStage + 1
				cameraInterpolation = now
			end
			
			local pos = interpolateBetween(
				1, 0, 0,
				-3, 0, 0,
				elapsedTime / 10000, "Linear")
			
			setCameraMatrix(vehX, vehY + pos, vehZ + 4, vehX, vehY + pos, vehZ, 90)
		elseif cameraStage == 4 then
			if elapsedTime >= 9000 and cinematicCamera then
				fadeCamera(false, 1, 25, 25, 25)
				setTimer(fadeCamera, 1000, 1, true, 1)
			end
			
			if elapsedTime >= 10000 and cinematicCamera then
				cameraStage = cameraStage + 1
				cameraInterpolation = now
			end
			
			local rot, pos = interpolateBetween(
				0, 0, 0,
				20, 1.2, 0,
				elapsedTime / 10000, "Linear")

			local rotatedX, rotatedY = rotateAround(90 + rot, -5 + pos, -5 + pos)
			
			setCameraMatrix(vehX + rotatedX, vehY + rotatedY, vehZ + 0.55, vehX, vehY, vehZ)
		elseif cameraStage == 5 then
			if elapsedTime >= 9000 and cinematicCamera then
				fadeCamera(false, 1, 25, 25, 25)
				setTimer(fadeCamera, 1000, 1, true, 1)
			end
			
			if elapsedTime >= 10000 and cinematicCamera then
				cameraStage = cameraStage + 1
				cameraInterpolation = now
			end
			
			local pos = interpolateBetween(
				-3, 0, 0,
				1, 0, 0,
				elapsedTime / 10000, "Linear")
			
			setCameraMatrix(vehX + 2.5, vehY + 2.5 + pos, vehZ + 0.55, -vehX + 2.5, -vehY + 2.5, vehZ)
		elseif cameraStage == 6 then
			local componentX, componentY, componentZ
			
			if getVehicleComponentPosition(previewVehicle, "bump_front_dummy", "world") then
				componentX, componentY, componentZ = getVehicleComponentPosition(previewVehicle, "bump_front_dummy", "world")
			elseif getVehicleComponentPosition(previewVehicle, "bump_front_ok", "world") then
				componentX, componentY, componentZ = getVehicleComponentPosition(previewVehicle, "bump_front_ok", "world")
			end
			
			if not (componentX and componentY and componentZ) then
				cameraStage = cameraStage + 1
				cameraInterpolation = now
				return
			end
			
			if elapsedTime >= 6500 and cinematicCamera then
				fadeCamera(false, 1, 25, 25, 25)
				setTimer(fadeCamera, 1000, 1, true, 1)
			end
			
			if elapsedTime >= 7500 and cinematicCamera then
				cameraStage = cameraStage + 1
				cameraInterpolation = now
			end
			
			local rot = interpolateBetween(
				0, 0, 0,
				20, 0, 0,
				elapsedTime / 7500, "Linear")

			local rotatedX, rotatedY = rotateAround(90 + rot, 2, 1)

			setCameraMatrix(componentX + rotatedX, componentY + rotatedY, componentZ + 0.55, componentX, componentY, componentZ)
		elseif cameraStage == 7 then
			local componentX, componentY, componentZ = getVehicleComponentPosition(previewVehicle, "bump_rear_dummy", "world")
			
			if not (componentX and componentY and componentZ) then
				cameraStage = 1
				cameraInterpolation = now
				return
			end
			
			if elapsedTime >= 6500 and cinematicCamera then
				fadeCamera(false, 1, 25, 25, 25)
				setTimer(fadeCamera, 1000, 1, true, 1)
			end
			
			if elapsedTime >= 7500 and cinematicCamera then
				cameraStage = 1
				cameraInterpolation = now
			end
			
			local rot = interpolateBetween(
				0, 0, 0,
				20, 0, 0,
				elapsedTime / 7500, "Linear")

			local rotatedX, rotatedY = rotateAround(90 + rot, -2, -1)

			setCameraMatrix(componentX + rotatedX, componentY + rotatedY, componentZ + 0.55, componentX, componentY, componentZ)
		end
	end
end

addEvent("exitShop", true)
addEventHandler("exitShop", getRootElement(),
	function ()
		fadeCamera(false, 2, 25, 25, 25)
		setTimer(exitShop, 2000, 1)
		exitingProcessStarted = true
		cinematicCamera = false
		promptActive = false
	end)

addEvent("maxLimitVehConfirm", true)
addEventHandler("maxLimitVehConfirm", getRootElement(),
	function()
		vehicleLimitFinal = true
	end
)

renderDataDraw = {}
renderDataDraw.colorSwitches = {}
renderDataDraw.lastColorSwitches = {}
renderDataDraw.startColorSwitch = {}
renderDataDraw.lastColorConcat = {}

function processColorSwitchEffect(key, color, duration, type)
	if not renderDataDraw.colorSwitches[key] then
		if not color[4] then
			color[4] = 255
		end

		renderDataDraw.colorSwitches[key] = color
		renderDataDraw.lastColorSwitches[key] = color

		renderDataDraw.lastColorConcat[key] = table.concat(color)
	end

	duration = duration or 500
	type = type or "Linear"

	if renderDataDraw.lastColorConcat[key] ~= table.concat(color) then
		renderDataDraw.lastColorConcat[key] = table.concat(color)
		renderDataDraw.lastColorSwitches[key] = color
		renderDataDraw.startColorSwitch[key] = getTickCount()
	end

	if renderDataDraw.startColorSwitch[key] then
		local progress = (getTickCount() - renderDataDraw.startColorSwitch[key]) / duration

		local r, g, b = interpolateBetween(
				renderDataDraw.colorSwitches[key][1], renderDataDraw.colorSwitches[key][2], renderDataDraw.colorSwitches[key][3],
				color[1], color[2], color[3],
				progress, type
		)

		local a = interpolateBetween(renderDataDraw.colorSwitches[key][4], 0, 0, color[4], 0, 0, progress, type)

		renderDataDraw.colorSwitches[key][1] = r
		renderDataDraw.colorSwitches[key][2] = g
		renderDataDraw.colorSwitches[key][3] = b
		renderDataDraw.colorSwitches[key][4] = a

		if progress >= 1 then
			renderDataDraw.startColorSwitch[key] = false
		end
	end

	return renderDataDraw.colorSwitches[key][1], renderDataDraw.colorSwitches[key][2], renderDataDraw.colorSwitches[key][3], renderDataDraw.colorSwitches[key][4]
end

function dxDrawInnerBorder(thickness, x, y, w, h, color, postGUI)
	thickness = thickness or 2
	dxDrawLine(x, y, x + w, y, color, thickness, postGUI)
	dxDrawLine(x, y + h, x + w, y + h, color, thickness, postGUI)
	dxDrawLine(x, y, x, y + h, color, thickness, postGUI)
	dxDrawLine(x + w, y, x + w, y + h, color, thickness, postGUI)
end

function renderButtonProgress()
	local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

		renderDataDraw.activeButton = false
		if not renderDataDraw.buttons then
			return
		end
		for k,v in pairs(renderDataDraw.buttons) do
			if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
				renderDataDraw.activeButton = k
				break
			end
		end
	else
		renderDataDraw.activeButton = false
	end
end
addEventHandler("onClientRender", getRootElement(), renderButtonProgress)

function handlePromptClick(button, state, cx, cy)
	if button == "left" then
		if state == "down" then
			if renderDataDraw.activeButton == "backVehicle" then
				if not freeLookCamera and not promptActive and getTickCount() - lastNavigate >= 2000 then
					selectedVehicle = selectedVehicle - 1

					if selectedVehicle < 1 then
						selectedVehicle = #availableVehicles
					end
					fadeCamera(false, 1, 25, 25, 25)
					setTimer(fadeCamera, 1000, 1, true, 1)

					setTimer(
							function()
								cameraInterpolation = getTickCount()
								cameraStage = 1

								local veh = availableVehicles[selectedVehicle]
								if selectedVehicle == 1 then
									vehBack = availableVehicles[#availableVehicles]
								else
									vehBack = availableVehicles[selectedVehicle - 1]

								end
								if selectedVehicle == #availableVehicles then
									vehNext = availableVehicles[1]
								else
									vehNext = availableVehicles[selectedVehicle + 1]
								end
								local color = availableColors[math.random(1, #availableColors)]

								setElementModel(previewVehicle, veh.model)
								setElementPosition(previewVehicle, -2460.658203125, 2234.8549804688, 4.8422479629517 + 0.5)
								setElementRotation(previewVehicle, 0, 0, 0)
								setVehicleEngineState(previewVehicle, false)

								setVehicleColor(previewVehicle, color[1], color[2], color[3])
								selectedColor = {unpack(color)}

								exports.sm_tuning:applyHandling(previewVehicle)

								vehicleName = exports.sm_vehiclenames:getCustomVehicleName(veh.model)
								vehicleManufacturer = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(veh.model)):gsub(" ", "-")
								vehicleManufacturerBack = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(vehBack.model)):gsub(" ", "-")
								vehicleManufacturerNext = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(vehNext.model)):gsub(" ", "-")

								vehiclePrice = veh.price
								vehiclePremium = veh.premium
								vehicleLimit = veh.limit

								fuelType = getVehicleHandling(previewVehicle)["engineType"]
								driveType = getVehicleHandling(previewVehicle)["driveType"]
								tankCapacity = exports.sm_vehiclepanel:getTheFuelTankSizeOfVehicle(veh.model)
								bootCapacity = exports.sm_items:getWeightLimit("vehicle", previewVehicle)
								topSpeed = getVehicleHandling(previewVehicle)["maxVelocity"]
								tankEat = exports.sm_vehiclepanel:getTheConsumptionOfVehicle(getElementModel(previewVehicle))

								if fuelType == "petrol" then
									fuelType = "Benzin"
								elseif fuelType == "diesel" then
									fuelType = "Dízel"
								else
									fuelType = "Elektromos"
								end

								if driveType == "fwd" then
									driveType = "Elsőkerék"
								elseif driveType == "rwd" then
									driveType = "Hátsókerék"
								else
									driveType = "Összkerék"
								end

								fuelType = "#3d7abc" .. fuelType
								driveType = "#3d7abc" .. driveType
								tankCapacity = "#3d7abc" .. tankCapacity .. " liter"
								bootCapacity = "#3d7abc" .. bootCapacity .. " kg"
								topSpeed = "#3d7abc" .. topSpeed .. " km/h"
								tankEat = "#3d7abc" .. tankEat * 10 .. " l/100 km"

								triggerServerEvent("countCarsByModel", localPlayer, veh.model)
							end, 1000, 1)
					lastNavigate = getTickCount()
				end
			elseif renderDataDraw.activeButton == "nextVehicle" then
				if not freeLookCamera and not promptActive and getTickCount() - lastNavigate >= 2000 then
					selectedVehicle = selectedVehicle + 1

					if selectedVehicle > #availableVehicles then
						selectedVehicle = 1
					end

					fadeCamera(false, 1, 25, 25, 25)
					setTimer(fadeCamera, 1000, 1, true, 1)

					setTimer(
							function()
								cameraInterpolation = getTickCount()
								cameraStage = 1

								local veh = availableVehicles[selectedVehicle]
								if selectedVehicle == 1 then
									vehBack = availableVehicles[#availableVehicles]
								else
									vehBack = availableVehicles[selectedVehicle - 1]

								end
								if selectedVehicle == #availableVehicles then
									vehNext = availableVehicles[1]
								else
									vehNext = availableVehicles[selectedVehicle + 1]
								end
								local color = availableColors[math.random(1, #availableColors)]

								setElementModel(previewVehicle, veh.model)
								setElementPosition(previewVehicle, -2460.658203125, 2234.8549804688, 4.8422479629517 + 0.5)
								setElementRotation(previewVehicle, 0, 0, 0)
								setVehicleEngineState(previewVehicle, false)

								setVehicleColor(previewVehicle, color[1], color[2], color[3])
								selectedColor = {unpack(color)}

								exports.sm_tuning:applyHandling(previewVehicle)

								vehicleName = exports.sm_vehiclenames:getCustomVehicleName(veh.model)
								vehicleManufacturer = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(veh.model)):gsub(" ", "-")
								vehicleManufacturerBack = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(vehBack.model)):gsub(" ", "-")
								vehicleManufacturerNext = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(vehNext.model)):gsub(" ", "-")

								vehiclePrice = veh.price
								vehiclePremium = veh.premium
								vehicleLimit = veh.limit

								fuelType = getVehicleHandling(previewVehicle)["engineType"]
								driveType = getVehicleHandling(previewVehicle)["driveType"]
								tankCapacity = exports.sm_vehiclepanel:getTheFuelTankSizeOfVehicle(veh.model)
								bootCapacity = exports.sm_items:getWeightLimit("vehicle", previewVehicle)
								topSpeed = getVehicleHandling(previewVehicle)["maxVelocity"]
								tankEat = exports.sm_vehiclepanel:getTheConsumptionOfVehicle(getElementModel(previewVehicle))

								if fuelType == "petrol" then
									fuelType = "Benzin"
								elseif fuelType == "diesel" then
									fuelType = "Dízel"
								else
									fuelType = "Elektromos"
								end

								if driveType == "fwd" then
									driveType = "Elsőkerék"
								elseif driveType == "rwd" then
									driveType = "Hátsókerék"
								else
									driveType = "Összkerék"
								end

								fuelType = "#3d7abc" .. fuelType
								driveType = "#3d7abc" .. driveType
								tankCapacity = "#3d7abc" .. tankCapacity .. " liter"
								bootCapacity = "#3d7abc" .. bootCapacity .. " kg"
								topSpeed = "#3d7abc" .. topSpeed .. " km/h"
								tankEat = "#3d7abc" .. tankEat * 10 .. " l/100 km"

								triggerServerEvent("countCarsByModel", localPlayer, veh.model)
							end, 1000, 1)
					lastNavigate = getTickCount()
				end
			end
			if promptActive then
				if renderDataDraw.activeButton == "buyCarMoney" then
					if selectedVehicle then
						if vehicleLimitFinal then
							triggerServerEvent("buyTheCurrentCar", localPlayer, availableVehicles[selectedVehicle], "pp", selectedColor[1], selectedColor[2], selectedColor[3])
						else	
							triggerServerEvent("buyTheCurrentCar", localPlayer, availableVehicles[selectedVehicle], "money", selectedColor[1], selectedColor[2], selectedColor[3])
						end
					end
				elseif renderDataDraw.activeButton == "cancelPrompt" then
					promptActive = false
					vehicleLimitFinal = false
				end
			end
			if activeButton then
				if string.find(activeButton, "selectcolor:") then
					local selected = tonumber(gettok(activeButton, 2, ":"))

					setVehicleColor(previewVehicle, availableColors[selected][1], availableColors[selected][2], availableColors[selected][3])

					selectedColor = {unpack(availableColors[selected])}
				end
			end
		end
	end
end

function handleShowroomKeys(key, press)
	if inTheShop and not exitingProcessStarted then
		if key == "backspace" then
			if press then
				if not freeLookCamera and not promptActive then
					fadeCamera(false, 2, 25, 25, 25)
					setTimer(exitShop, 2000, 1)
					exitingProcessStarted = true
					cinematicCamera = false
					promptActive = false
				end
			end
		end

		if key == "enter" then
			if press then
				if not freeLookCamera and not promptActive then
					promptActive = true
				end
			end
		end

		if key == "e" then
			if press then
				if freeLookCamera and not promptActive then
					if getTickCount() - lastInteraction >= 1000 then
						if not firstPersonCamera then
							for i = 1, #components do
								local componentName = components[i]
								local componentX, componentY, componentZ = getVehicleComponentPosition(previewVehicle, componentName, "world")

								if componentX then
									local onScreenX, onScreenY = getScreenFromWorldPosition(componentX, componentY, componentZ + 0.15)

									if onScreenX and onScreenY then
										if onScreenX >= screenX / 2 - 24 and onScreenY >= screenY / 2 - 24 and onScreenX <= screenX / 2 - 24 + 48 and onScreenY <= screenY / 2 - 24 + 48 then
											if getVehicleDoorOpenRatio(previewVehicle, i - 1) > 0 then
												setVehicleDoorOpenRatio(previewVehicle, i - 1, 0, 250)
												setTimer(playSound, 250, 1, exports.sm_vehiclepanel:getDoorCloseSound(getElementModel(previewVehicle)))
											else
												setVehicleDoorOpenRatio(previewVehicle, i - 1, 1, 500)
												playSound(exports.sm_vehiclepanel:getDoorOpenSound(getElementModel(previewVehicle)))
											end
										end
									end

									if componentName == "door_lf_dummy" or componentName == "door_rf_dummy" then
										local openratio = 0

										if componentName == "door_lf_dummy" then
											openratio = getVehicleDoorOpenRatio(previewVehicle, 2)
										else
											openratio = getVehicleDoorOpenRatio(previewVehicle, 3)
										end

										local onScreenX, onScreenY = getScreenFromWorldPosition(componentX, componentY - 0.5, componentZ + 0.15)

										if onScreenX and onScreenY and openratio == 1 then
											if onScreenX >= screenX / 2 - 24 and onScreenY >= screenY / 2 - 24 and onScreenX <= screenX / 2 - 24 + 48 and onScreenY <= screenY / 2 - 24 + 48 then
												lastInteraction = getTickCount()

												fadeCamera(false, 1, 25, 25, 25)
												setTimer(fadeCamera, 1000, 1, true, 1)
												setTimer(playSound, 750, 1, "files/sounds/sitin.mp3")

												setTimer(
													function ()
														if componentName == "door_lf_dummy" then
															firstPersonCamera = driverPed
														else
															firstPersonCamera = occupantPed
														end
													end,
												1000, 1)
											end
										end
									end
								end
							end
						else
							lastInteraction = getTickCount()

							fadeCamera(false, 1, 25, 25, 25)
							setTimer(fadeCamera, 1000, 1, true, 1)
							setTimer(playSound, 750, 1, "files/sounds/sitin.mp3")

							setTimer(
								function ()
									firstPersonCamera = false
								end,
							1000, 1)
						end
					end
				end
			end
		end

		if key == "q" then
			if press then
				if not promptActive then
					if firstPersonCamera then
						exports.sm_accounts:showInfo("e", "Előbb lépj ki a belsőnézetből! (E)")
						return
					end

					freeLookCamera = not freeLookCamera

					if freeLookCamera then
						fadeCamera(true, 0, 25, 25, 25)
					else
						cameraInterpolation = getTickCount()
						cameraStage = 1
					end

					for i = 0, 5 do
						setVehicleDoorOpenRatio(previewVehicle, i, 0, 0)
					end

					freeLook.zoomInterpolation = getTickCount()
					freeLook.zoom = 1

					playSound("files/sounds/cammove.mp3")
				end
			end
		end

		if key == "l" then
			if freeLookCamera then
				if press then
					if not promptActive then
						if getVehicleOverrideLights(previewVehicle) == 2 then
							setVehicleOverrideLights(previewVehicle, 1)
							playSound(":sm_vehiclepanel/files/headlightoff.mp3")
						else
							setVehicleOverrideLights(previewVehicle, 2)
							playSound(":sm_vehiclepanel/files/headlighton.mp3")
						end
					end
				end
			end
		end

		if key == "i" then
			if freeLookCamera then
				if press then
					if not promptActive then
						local state = getVehicleEngineState(previewVehicle)
						if state then
							playSound(":sm_vehiclepanel/files/key.mp3")
							setVehicleEngineState(previewVehicle, false)
						else
							playSound(":sm_vehiclepanel/files/starter.mp3")
							setTimer(function()
								setVehicleEngineState(previewVehicle, true)
							end,1000, 1)
							
						end
					end
				end
			end
		end

		if key == "arrow_r" or key == "arrow_l" then
			if press then
				if not freeLookCamera and not promptActive and getTickCount() - lastNavigate >= 2000 then
					if key == "arrow_r" then
						selectedVehicle = selectedVehicle + 1
						
						if selectedVehicle > #availableVehicles then
							selectedVehicle = 1
						end
					else
						selectedVehicle = selectedVehicle - 1
						
						if selectedVehicle < 1 then
							selectedVehicle = #availableVehicles
						end
					end
					
					fadeCamera(false, 1, 25, 25, 25)
					setTimer(fadeCamera, 1000, 1, true, 1)

					setTimer(
						function()
							cameraInterpolation = getTickCount()
							cameraStage = 1

							local veh = availableVehicles[selectedVehicle]
							if selectedVehicle == 1 then
								vehBack = availableVehicles[#availableVehicles]
							else
								vehBack = availableVehicles[selectedVehicle - 1]

							end
							if selectedVehicle == #availableVehicles then
								vehNext = availableVehicles[1]
							else
								vehNext = availableVehicles[selectedVehicle + 1]
							end
							local color = availableColors[math.random(1, #availableColors)]

							setElementModel(previewVehicle, veh.model)
							setElementPosition(previewVehicle, -2460.658203125, 2234.8549804688, 4.8422479629517 + 0.5)
							setElementRotation(previewVehicle, 0, 0, 0)
							setVehicleEngineState(previewVehicle, false)

							setVehicleColor(previewVehicle, color[1], color[2], color[3])
							selectedColor = {unpack(color)}

							exports.sm_tuning:applyHandling(previewVehicle)

							vehicleName = exports.sm_vehiclenames:getCustomVehicleName(veh.model)
							vehicleManufacturer = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(veh.model)):gsub(" ", "-")
							vehicleManufacturerBack = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(vehBack.model)):gsub(" ", "-")
							vehicleManufacturerNext = utf8.lower(exports.sm_vehiclenames:getCustomVehicleManufacturer(vehNext.model)):gsub(" ", "-")
							
							vehiclePrice = veh.price
							vehiclePremium = veh.premium
							vehicleLimit = veh.limit

							fuelType = getVehicleHandling(previewVehicle)["engineType"]
							driveType = getVehicleHandling(previewVehicle)["driveType"]
							tankCapacity = exports.sm_vehiclepanel:getTheFuelTankSizeOfVehicle(veh.model)
							bootCapacity = exports.sm_items:getWeightLimit("vehicle", previewVehicle)
							topSpeed = getVehicleHandling(previewVehicle)["maxVelocity"]
							tankEat = exports.sm_vehiclepanel:getTheConsumptionOfVehicle(getElementModel(previewVehicle))

							if fuelType == "petrol" then
								fuelType = "Benzin"
							elseif fuelType == "diesel" then
								fuelType = "Dízel"
							else
								fuelType = "Elektromos"
							end

							if driveType == "fwd" then
								driveType = "Elsőkerék"
							elseif driveType == "rwd" then
								driveType = "Hátsókerék"
							else
								driveType = "Összkerék"
							end

							fuelType = "#3d7abc" .. fuelType
							driveType = "#3d7abc" .. driveType
							tankCapacity = "#3d7abc" .. tankCapacity .. " liter"
							bootCapacity = "#3d7abc" .. bootCapacity .. " kg"
							topSpeed = "#3d7abc" .. topSpeed .. " km/h"
							tankEat = "#3d7abc" .. tankEat * 10 .. " l/100 km"

							triggerServerEvent("countCarsByModel", localPlayer, veh.model)
						end,
					1000, 1)
					
					lastNavigate = getTickCount()
				end
			end
		end

		if freeLookCamera and press and not freeLook.zoomInterpolation and not promptActive then
			if key == "mouse_wheel_up" then
				if freeLook.zoom <= 2 then
					freeLook.zoom = freeLook.zoom + 0.1
				end
			elseif key == "mouse_wheel_down" then
				if freeLook.zoom >= 1 then
					freeLook.zoom = freeLook.zoom - 0.1
				end
			end
		end

		if key ~= "esc" then
			cancelEvent()
		end
	end
end

function handleDataChanges(dataName, oldValue)
	if source == localPlayer then
		if dataName == "char.Money" then
			currentMoney = formatNumber(getElementData(localPlayer, "char.Money"))
		elseif dataName == "acc.premiumPoints" then
			currentPP = formatNumber(getElementData(localPlayer, "acc.premiumPoints"))
		end
	end
end

addEvent("countCarsByModel", true)
addEventHandler("countCarsByModel", getRootElement(),
	function (count)
		carModelCount = count
	end)

function drawText(text, x, y, w, h, color, size, font, left)
	if left then
		dxDrawText(text, x+20, y+h/2, x+20, y+h/2, color, size, font, "left", "center", false, false, false, true)
	else
		dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, size, font, "center", "center", false, false, false, true)
	end
end