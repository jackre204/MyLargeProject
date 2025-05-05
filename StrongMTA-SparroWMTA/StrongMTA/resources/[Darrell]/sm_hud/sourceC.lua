local pressingHudKey = false
local currentSmoothTick = false

renderData = {}
renderData.hudDisableNumber = 0
renderData.lastBarValue = {}
renderData.interpolationStartValue = {}
renderData.barInterpolation = {}
renderData.scrollX = 0

renderData.chatType = 1
renderData.chatBGAlpha = 0
renderData.chatFontBGAlpha = 255
renderData.chatFontSize = 100

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

screenX, screenY = guiGetScreenSize()
responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

function getResponsiveMultipler()
	return responsiveMultipler
end

function getHudCursorPos()
	if pressingHudKey then
		return getCursorPosition()
	else
		return false
	end
end

function loadFonts()
	Roboto = exports.sm_core:loadFont("Raleway.ttf", respc(12), false, "antialiased")
	RobotoB = exports.sm_core:loadFont("Raleway.ttf", respc(24), false, "antialiased")
	Raleway = exports.sm_core:loadFont("Raleway.ttf", respc(30), false, "antialiased")
	RalewayB = exports.sm_core:loadFont("Raleway.ttf", respc(12), false, "antialiased")
	RalewayS = exports.sm_core:loadFont("Raleway.ttf", respc(10), false, "antialiased")
	RalewayC = exports.sm_core:loadFont("Raleway.ttf", respc(15), false, "antialiased")
	strongFont = exports.sm_core:loadFont("Raleway.ttf", respc(40), false, "antialiased")
	
end

local moneyFont = dxCreateFont("files/moneyFont.ttf", respc(20))

loadFonts()

addEventHandler("onAssetsLoaded", getRootElement(),
	function ()
		loadFonts()
	end
)

plateFont = dxCreateFont("files/fonts/MANDATOR.ttf", resp(25), false, "antialiased")
plateTexture = dxCreateTexture("files/images/plate.bmp")
plateBlackTexture = dxCreateTexture("files/images/plate2.bmp")
plateWhiteTexture = dxCreateTexture("files/images/plate3.bmp")
plateLibertyTexture = dxCreateTexture("files/images/plate4.bmp")

local roundtexture = dxCreateTexture("files/images/round.png", "argb", true, "clamp")

function dxDrawRoundedRectangle(x, y, sx, sy, color, postGUI, subPixelPositioning)
	dxDrawImage(x, y, 5, 5, roundtexture, 0, 0, 0, color, postGUI)
	dxDrawRectangle(x, y + 5, 5, sy - 5 * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x, y + sy - 5, 5, 5, roundtexture, 270, 0, 0, color, postGUI)
	dxDrawRectangle(x + 5, y, sx - 5 * 2, sy, color, postGUI, subPixelPositioning)
	dxDrawImage(x + sx - 5, y, 5, 5, roundtexture, 90, 0, 0, color, postGUI)
	dxDrawRectangle(x + sx - 5, y + 5, 5, sy - 5 * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x + sx - 5, y + sy - 5, 5, 5, roundtexture, 180, 0, 0, color, postGUI)
end


-- STAMINA

local currentStamina = 100

local jumped = false
local canMove = true

local adminDuty = 0
local drugStaminaOff = false
local glueState = false

local increase = 0.0075
local decrease = 0.00375

addEventHandler("onClientResourceStart", getResourceRootElement(),function()
	adminDuty = getElementData(localPlayer, "adminDuty") or 0
	drugStaminaOff = getElementData(localPlayer, "drugStaminaOff")
	glueState = getElementData(localPlayer, "playerGlueState")
end)
	
addEventHandler("onClientElementDataChange", localPlayer,function(dataName)
	if dataName == "adminDuty" then
		adminDuty = getElementData(localPlayer, dataName)
	end
		
	if dataName == "drugStaminaOff" then
		drugStaminaOff = getElementData(localPlayer, dataName)
	end
		
	if dataName == "playerGlueState" then
		glueState = getElementData(localPlayer, dataName)
	end
end)

addEventHandler("onClientPreRender", getRootElement(),function(timeSlice)
	setPedControlState("walk", true)
end)


function dxDrawSeeBar2(x, y, sx, sy, margin, progresscolor, progresscolor2, value, value2, key, key2, bgcolor, bordercolor)
	sx, sy = math.ceil(sx), math.ceil(sy)

	if value > 100 then
		value = 100
	end

	local lerpval = false

	if key then
		if renderData.lastBarValue[key] then
			if renderData.lastBarValue[key] ~= value then
				renderData.barInterpolation[key] = getTickCount()
				renderData.interpolationStartValue[key] = renderData.lastBarValue[key]
				renderData.lastBarValue[key] = value
			end
		else
			renderData.lastBarValue[key] = value
		end

		if renderData.barInterpolation[key] then
			lerpval = interpolateBetween(renderData.interpolationStartValue[key], 0, 0, value, 0, 0, (getTickCount() - renderData.barInterpolation[key]) / 250, "Linear")
		end
	end

	if lerpval then
		value = lerpval
	end

	local lerpval2 = false

	if key2 then
		if renderData.lastBarValue[key2] then
			if renderData.lastBarValue[key2] ~= value2 then
				renderData.barInterpolation[key2] = getTickCount()
				renderData.interpolationStartValue[key2] = renderData.lastBarValue[key2]
				renderData.lastBarValue[key2] = value2
			end
		else
			renderData.lastBarValue[key2] = value2
		end

		if renderData.barInterpolation[key2] then
			lerpval2 = interpolateBetween(renderData.interpolationStartValue[key2], 0, 0, value2, 0, 0, (getTickCount() - renderData.barInterpolation[key2]) / 250, "Linear")
		end
	end

	if lerpval2 then
		value2 = lerpval2
	end

	bordercolor = bordercolor or tocolor(0, 0, 0, 200)

	value = value / 2
	value2 = value2 / 2

	dxDrawRectangle(x, y, sx, margin, bordercolor) -- felső
	dxDrawRectangle(x, y + sy - margin, sx, margin, bordercolor) -- alsó
	dxDrawRectangle(x, y + margin, margin, sy - margin * 2, bordercolor) -- bal
	dxDrawRectangle(x + sx - margin, y + margin, margin, sy - margin * 2, bordercolor) -- jobb
	dxDrawRectangle(x + margin, y + margin, sx - margin * 2, sy - margin * 2, bgcolor or tocolor(0, 0, 0, 155)) -- háttér

	dxDrawRectangle(x + margin, y + margin, (sx - margin * 2) * (value / 100), sy - margin * 2, progresscolor) -- állapot 1

	dxDrawRectangle(x + margin + (sx - margin * 2) * 0.5, y + margin, (sx - margin * 2) * (value2 / 100), sy - margin * 2, progresscolor2) -- állapot 2

	dxDrawRectangle(x + margin + (sx - margin * 2) * 0.5 - 1, y + margin, 2, sy - margin * 2, tocolor(0, 0, 0, 200)) -- elválasztó
end

function dxDrawSeeBar(x, y, sx, sy, margin, colorOfProgress, value, key, bgcolor, bordercolor)
	sx, sy = math.ceil(sx), math.ceil(sy)

	if value > 100 then
		value = 100
	end

	local interpolatedValue = false

	if key then
		if renderData.lastBarValue[key] then
			if renderData.lastBarValue[key] ~= value then
				renderData.barInterpolation[key] = getTickCount()
				renderData.interpolationStartValue[key] = renderData.lastBarValue[key]
				renderData.lastBarValue[key] = value
			end
		else
			renderData.lastBarValue[key] = value
		end

		if renderData.barInterpolation[key] then
			interpolatedValue = interpolateBetween(renderData.interpolationStartValue[key], 0, 0, value, 0, 0, (getTickCount() - renderData.barInterpolation[key]) / 250, "Linear")
		end
	end

	if interpolatedValue then
		value = interpolatedValue
	end

	bordercolor = bordercolor or tocolor(0, 0, 0, 200)

	dxDrawRectangle(x, y, sx, margin, bordercolor) -- felső
	dxDrawRectangle(x, y + sy - margin, sx, margin, bordercolor) -- alsó
	dxDrawRectangle(x, y + margin, margin, sy - margin * 2, bordercolor) -- bal
	dxDrawRectangle(x + sx - margin, y + margin, margin, sy - margin * 2, bordercolor) -- jobb

	dxDrawRectangle(x + margin, y + margin, sx - margin * 2, sy - margin * 2, bgcolor or tocolor(0, 0, 0, 155)) -- háttér
	dxDrawRectangle(x + margin, y + margin, (sx - margin * 2) * (value / 100), sy - margin * 2, colorOfProgress) -- állapot
end

local bordercolor = tocolor(0, 0, 0, 200)

function dxDrawImageSectionBorder(x, y, w, h, ux, uy, uw, uh, image, r, rx, ry, color, postGUI)
	dxDrawImageSection(x - 1, y - 1, w, h, ux, uy, uw, uh, image, r, ry, rz, bordercolor, postGUI)
	dxDrawImageSection(x - 1, y + 1, w, h, ux, uy, uw, uh, image, r, ry, rz, bordercolor, postGUI)
	dxDrawImageSection(x + 1, y - 1, w, h, ux, uy, uw, uh, image, r, ry, rz, bordercolor, postGUI)
	dxDrawImageSection(x + 1, y + 1, w, h, ux, uy, uw, uh, image, r, ry, rz, bordercolor, postGUI)
	dxDrawImageSection(x, y, w, h, ux, uy, uw, uh, image, r, ry, rz, color, postGUI)
end

bordercolor = tocolor(0, 0, 0)

function dxDrawBorderText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	local text2 = string.gsub(text, "#......", "")
	dxDrawText(text2, x + 1, y + 1, w + 1, h + 1, bordercolor, scale, font, alignX, alignY, clip, wordBreak, postGUI, false, true)
	dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
end

local nextMoneySound = 0

local currentWeaponDbID = false
local fireDisabled = false
local weaponItems = {}
local lastFireTick = {}
local overheated = {}
local currentHeat = {}
local heatIncreaseValue = {
	[22] = 7.5,
	[23] = 7.5,
	[24] = 16,
	[25] = 19,
	[26] = 16.25,
	[27] = 13.75,
	[28] = 3,
	[29] = 3,
	[30] = 3,
	[31] = 2.5,
	[32] = 4,
	[33] = 10,
	[34] = 10
}
local heatDecreaseValue = {
	[22] = 0.0098039215686275,
	[23] = 0.011764705882353,
	[24] = 0.007843137254902,
	[25] = 0.0049019607843137,
	[26] = 0.0073529411764706,
	[27] = 0.007843137254902,
	[28] = 0.0088235294117647,
	[29] = 0.011764705882353,
	[30] = 0.0098039215686275,
	[31] = 0.0093137254901961,
	[32] = 0.0088235294117647,
	[33] = 0.0088235294117647,
	[34] = 0.0088235294117647
}

local injureLeftFoot = false
local injureRightFoot = false
local injureLeftArm = false
local injureRightArm = false

local licenseExpire = {}

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			licenseExpire[source] = getElementData(source, "licenseExpire")
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
			licenseExpire[v] = getElementData(source, "licenseExpire")
		end
	end
)

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName, oldVal)
		if dataName == "licenseExpire" then
			if isElementStreamedIn(source) then
				licenseExpire[source] = getElementData(source, "licenseExpire")
				--print(licenseExpire[source])
			end
		end

		if dataName == "loggedIn" then
			if getElementData(localPlayer, "loggedIn") then
				renderData.loggedIn = true
				renderData.currentMoney = getElementData(localPlayer, "char.Money") or 0
				renderData.currentSlotcoin = getElementData(localPlayer, "char.slotCoins") or 0
				setTimer(loadChatSettings, 2000, 1)
			end
		end

		if dataName == "char.injureLeftFoot" then
			injureLeftFoot = getElementData(localPlayer, "char.injureLeftFoot")
		end

		if dataName == "char.injureRightFoot" then
			injureRightFoot = getElementData(localPlayer, "char.injureRightFoot")
		end

		if dataName == "char.injureLeftArm" then
			injureLeftArm = getElementData(localPlayer, "char.injureLeftArm")
		end

		if dataName == "char.injureRightArm" then
			injureRightArm = getElementData(localPlayer, "char.injureRightArm")
		end

		if dataName == "char.Hunger" then
			renderData.currentHunger = getElementData(localPlayer, "char.Hunger") or 100
		end

		if dataName == "char.Thirst" then
			renderData.currentThirst = getElementData(localPlayer, "char.Thirst") or 100
		end

		if dataName == "bloodLevel" then
			renderData.bloodLevel = getElementData(localPlayer, "bloodLevel") or 100
		end

		if dataName == "drugHunger" then
			renderData.drugHunger = getElementData(localPlayer, "drugHunger") or 0
		end

		if dataName == "tazerState" then
			renderData.tazerState = getElementData(localPlayer, "tazerState")
		end

		if dataName == "tazerReloadNeeded" then
			renderData.tazerReloadNeeded = getElementData(localPlayer, "tazerReloadNeeded")
		end

		if dataName == "char.slotCoins" then
			renderData.currentSlotcoin = getElementData(localPlayer, "char.slotCoins") or 0
		end

		if dataName == "char.Money" then
			local currentMoney = getElementData(localPlayer, "char.Money")

			if currentMoney then
				renderData.currentMoney = currentMoney

				if oldVal then
					local changeValue = false

					if oldVal < currentMoney then
						changeValue = currentMoney - oldVal
					elseif currentMoney < oldVal then
						changeValue = (oldVal - currentMoney) * -1
					end

					if renderData.moneyChangeTick and getTickCount() >= renderData.moneyChangeTick and getTickCount() <= renderData.moneyChangeTick + 5000 then
						renderData.moneyChangeValue = renderData.moneyChangeValue + changeValue
					else
						renderData.moneyChangeValue = changeValue
					end

					if getTickCount() - nextMoneySound >= 1000 then
						playSound("files/sounds/moneychange.mp3")
						nextMoneySound = getTickCount()
					end
				end

				renderData.moneyChangeTick = getTickCount()
			end
		end

		if dataName == "currentWeaponDbID" then
			currentWeaponDbID = getElementData(localPlayer, "currentWeaponDbID")[1]
			weaponItems[currentWeaponDbID] = getElementData(localPlayer, "currentWeaponDbID")[2]

			if not overheated[currentWeaponDbID] and fireDisabled then
				fireDisabled = false
				exports.sm_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
			end
		end

		if dataName == "char.Name" then
			renderData.characterName = getElementData(localPlayer, dataName)
		end

		if dataName == "playerID" then
			renderData.playerID = getElementData(localPlayer, dataName)
		end

		if dataName == "char.playedMinutes" then
			renderData.playedMinutes = getElementData(localPlayer, dataName) or 0
			renderData.currentLevel = exports.sm_core:getLevel(false, renderData.playedMinutes)
		end
	end)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if screenX < 1024 then
			triggerServerEvent("kickPlayerCuzScreenSize", localPlayer)
		end

		guiSetInputMode("no_binds_when_editing")
		resetHudElement("all")

		renderData.loggedIn = getElementData(localPlayer, "loggedIn")
		renderData.currentMoney = getElementData(localPlayer, "char.Money") or 0
		renderData.currentHunger = getElementData(localPlayer, "char.Hunger") or 100
		renderData.currentThirst = getElementData(localPlayer, "char.Thirst") or 100
		renderData.currentSlotcoin = getElementData(localPlayer, "char.slotCoins") or 0
		renderData.characterName = getElementData(localPlayer, "char.Name")
		renderData.playerID = getElementData(localPlayer, "playerID") or 0
		renderData.playedMinutes = getElementData(localPlayer, "char.playedMinutes") or 0
		renderData.currentLevel = exports.sm_core:getLevel(false, renderData.playedMinutes)
		renderData.bloodLevel = getElementData(localPlayer, "bloodLevel") or 100
		renderData.drugHunger = getElementData(localPlayer, "drugHunger") or 0
		renderData.tazerState = getElementData(localPlayer, "tazerState")
		renderData.tazerReloadNeeded = getElementData(localPlayer, "tazerReloadNeeded")

		local currentWeapon = getElementData(localPlayer, "currentWeaponDbID")
		
		if getElementData(localPlayer, "currentWeaponDbID") then
			currentWeaponDbID = currentWeapon[1]
			weaponItems[currentWeaponDbID] = currentWeapon[2]
		end

		injureLeftFoot = getElementData(localPlayer, "char.injureLeftFoot")
		injureRightFoot = getElementData(localPlayer, "char.injureRightFoot")
		injureLeftArm = getElementData(localPlayer, "char.injureLeftArm")
		injureRightArm = getElementData(localPlayer, "char.injureRightArm")

		bindKey("r", "down", "reloadmyweapon")

		setPlayerHudComponentVisible("all", true)
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)

		loadHUD()
	end)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		saveHUD()
	end)

local lastReloadTime = 0
local blockedTasks = {
	TASK_SIMPLE_IN_AIR = true,
	TASK_SIMPLE_JUMP = true,
	TASK_SIMPLE_LAND = true,
	TASK_SIMPLE_GO_TO_POINT = true,
	TASK_SIMPLE_NAMED_ANIM = true,
	TASK_SIMPLE_CAR_OPEN_DOOR_FROM_OUTSIDE = true,
	TASK_SIMPLE_CAR_GET_IN = true,
	TASK_SIMPLE_CLIMB = true,
	TASK_SIMPLE_SWIM = true,
	TASK_SIMPLE_HIT_HEAD = true,
	TASK_SIMPLE_FALL = true,
	TASK_SIMPLE_GET_UP = true
}

addCommandHandler("reloadmyweapon",
	function ()
		if getElementData(localPlayer, "loggedIn") then
			if getPedTask(localPlayer, "secondary", 0) ~= "TASK_SIMPLE_USE_GUN" then
				if not blockedTasks[getPedSimplestTask(localPlayer)] then
					if getTickCount() - lastReloadTime >= 500 then
						triggerServerEvent("reloadPlayerWeapon", localPlayer)
						lastReloadTime = getTickCount()

						if getElementData(localPlayer, "tazerReloadNeeded") then
							exports.sm_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
							setElementData(localPlayer, "tazerReloadNeeded", false)
						end
					end
				end
			end
		end
	end)

renderData.moving = {}
renderData.resizing = false
renderData.selectedHUD = {}
renderData.move = {}
renderData.pos = {}
renderData.inTrash = {}
renderData.resizable = {}
renderData.size = {}
renderData.resizingLimitMin = {}
renderData.resizingLimitMax = {}
renderData.placeholder = {}

function resetHudElement(element, toTrash)
	renderData.moving = {}
	renderData.resizing = false
	renderData.selectedHUD = {}

	if element == "hp" or element == "all" then
		if not toTrash then
			renderData.pos.hpX, renderData.pos.hpY = screenX - resp(205) - math.ceil(resp(12)), math.ceil(resp(12))
			renderData.inTrash.hp = false
			renderData.resizable.hp = false
		end

		renderData.size.hpX, renderData.size.hpY = respc(65), respc(65)
	end

	if element == "arm" or element == "all" then
		if not toTrash then
			renderData.pos.armX, renderData.pos.armY = screenX - resp(170) - math.ceil(resp(12)), math.ceil(resp(12))
			renderData.inTrash.arm = false
			renderData.resizable.arm = false
			--renderData.resizingLimitMin.hpX, renderData.resizingLimitMax.hpX, renderData.resizingLimitMin.hpY, renderData.resizingLimitMax.hpY = respc(65), respc(65), 0, 0
		end

		renderData.size.armX, renderData.size.armY = respc(65), respc(65)
	end
	if element == "hunger" or element == "all" then
		if not toTrash then
			renderData.pos.hungerX, renderData.pos.hungerY = screenX - resp(135) - math.ceil(resp(12)), math.ceil(resp(12))
			renderData.inTrash.hunger = false
			renderData.resizable.hunger = false
			--renderData.resizingLimitMin.hpX, renderData.resizingLimitMax.hpX, renderData.resizingLimitMin.hpY, renderData.resizingLimitMax.hpY = respc(65), respc(65), 0, 0
		end
	
		renderData.size.hungerX, renderData.size.hungerY = respc(65), respc(65)
	end
	if element == "drink" or element == "all" then
		if not toTrash then
			renderData.pos.drinkX, renderData.pos.drinkY = screenX - resp(100) - math.ceil(resp(12)), math.ceil(resp(12))
			renderData.inTrash.drink = false
			renderData.resizable.drink = false
			--renderData.resizingLimitMin.hpX, renderData.resizingLimitMax.hpX, renderData.resizingLimitMin.hpY, renderData.resizingLimitMax.hpY = respc(65), respc(65), 0, 0
		end
	
		renderData.size.drinkX, renderData.size.drinkY = respc(65), respc(65)
	end
	if element == "stamina" or element == "all" then
		if not toTrash then
			renderData.pos.staminaX, renderData.pos.staminaY = screenX - resp(65) - math.ceil(resp(12)), math.ceil(resp(12))
			renderData.inTrash.stamina = false
			renderData.resizable.stamina = false
			--renderData.resizingLimitMin.hpX, renderData.resizingLimitMax.hpX, renderData.resizingLimitMin.hpY, renderData.resizingLimitMax.hpY = respc(65), respc(65), 0, 0
		end
	
		renderData.size.staminaX, renderData.size.staminaY = respc(65), respc(65)
	end

	if element == "bone" or element == "all" then
		if not toTrash then
			renderData.inTrash.bone = false
			renderData.pos.boneX, renderData.pos.boneY = screenX - resp(370) - math.ceil(resp(12)) - resp(23), resp(14.5)
		end
	end

	if element == "money" or element == "all" then
		if not toTrash then
			renderData.pos.moneyX, renderData.pos.moneyY = screenX - resp(250) - math.ceil(resp(12)) + resp(50), math.ceil(resp(12)) + resp(12) * 3 + 21
			renderData.inTrash.money = false
			renderData.resizingLimitMin.moneyX, renderData.resizingLimitMax.moneyX, renderData.resizingLimitMin.moneyY, renderData.resizingLimitMax.moneyY = respc(100), respc(350), 0, 0
			renderData.resizable.money = true
		end

		renderData.size.moneyX, renderData.size.moneyY = respc(200), 0
	end

	if element == "infobox" or element == "all" then
		if not toTrash then
			renderData.inTrash.infobox = false
			renderData.pos.infoboxX, renderData.pos.infoboxY = screenX / 2 - respc(256), respc(10)
			renderData.placeholder.infobox = "INFOBOX"
		end
	end

	if element == "kickbox" or element == "all" then
		if not toTrash then
			renderData.inTrash.kickbox = false
			renderData.pos.kickboxX, renderData.pos.kickboxY = resp(12), screenY - respc(225) - resp(17) - respc(45) * 5
			renderData.placeholder.kickbox = "KICK/BAN"
		end
	end

	if element == "chat" or element == "all" then
		if not toTrash then
			renderData.inTrash.chat = false
			renderData.pos.chatX, renderData.pos.chatY = resp(12), resp(12)
			renderData.resizable.chat = true
			renderData.resizingLimitMin.chatX, renderData.resizingLimitMax.chatX, renderData.resizingLimitMin.chatY, renderData.resizingLimitMax.chatY = respc(300), respc(1000), respc(200), respc(600)
			renderData.placeholder.chat = "CHAT"
		end

		renderData.size.chatX, renderData.size.chatY = respc(600), respc(350)
	end

	if element == "oocchat" or element == "all" then
		if not toTrash then
			renderData.inTrash.oocchat = false
			renderData.pos.oocchatX, renderData.pos.oocchatY = resp(12), resp(24) + respc(350)
			renderData.resizable.oocchat = true
			renderData.resizingLimitMin.oocchatX, renderData.resizingLimitMax.oocchatX, renderData.resizingLimitMin.oocchatY, renderData.resizingLimitMax.oocchatY = respc(300), respc(1000), respc(200), respc(600)
			renderData.placeholder.oocchat = "OOC CHAT"
		end

		renderData.size.oocchatX, renderData.size.oocchatY = respc(400), respc(200)
	end

	if element == "actionbar" or element == "all" then
		if not toTrash then
			renderData.inTrash.actionbar = false
			renderData.pos.actionbarX, renderData.pos.actionbarY = screenX / 2 - resp(125.5), screenY - resp(46) - resp(5)
		end
	end

	if element == "slotcoin" or element == "all" then
		if not toTrash then
			renderData.inTrash.slotcoin = true
			renderData.pos.slotcoinX, renderData.pos.slotcoinY = 0, 0
			renderData.resizingLimitMin.slotcoinX, renderData.resizingLimitMax.slotcoinX, renderData.resizingLimitMin.slotcoinY, renderData.resizingLimitMax.slotcoinY = respc(100), respc(350), 0, 0
			renderData.resizable.slotcoin = true
		end

		renderData.size.slotcoinX, renderData.size.slotcoinY = respc(192.5), 0
	end

	if (element == "weapons" or element == "all") and not toTrash then
		renderData.inTrash.weapons = false
		renderData.pos.weaponsX, renderData.pos.weaponsY = screenX - resp(250) - math.ceil(resp(12)), math.ceil(resp(12)) + resp(12) * 3 + 21 + resp(40)
	end

	if (element == "fps" or element == "all") and not toTrash then
		renderData.inTrash.fps = true
		renderData.pos.fpsX, renderData.pos.fpsY = 0, 0
	end

	if (element == "clock" or element == "all") and not toTrash then
		renderData.inTrash.clock = true
		renderData.pos.clockX, renderData.pos.clockY = 0, 0
	end

	if (element == "vstats" or element == "all") and not toTrash then
		renderData.inTrash.vstats = true
		renderData.pos.vstatsX, renderData.pos.vstatsY = 0, 0
	end

	if (element == "ping" or element == "all") and not toTrash then
		renderData.inTrash.ping = true
		renderData.pos.pingX, renderData.pos.pingY = 0, 0
	end

	if (element == "stats" or element == "all") and not toTrash then
		renderData.inTrash.stats = true
		renderData.pos.statsX, renderData.pos.statsY = 0, 0
	end

	if element == "minimap" or element == "all" then
		if not toTrash then
			renderData.inTrash.minimap = false
			renderData.resizingLimitMin.minimapX, renderData.resizingLimitMin.minimapY = respc(200), respc(110)
			renderData.resizingLimitMax.minimapX, renderData.resizingLimitMax.minimapY = respc(625), respc(495)
			renderData.resizable.minimap = true
			renderData.pos.minimapX, renderData.pos.minimapY = resp(12), screenY - respc(200) - resp(12)
			renderData.placeholder.minimap = "MINIMAP"
		end

		renderData.size.minimapX, renderData.size.minimapY = respc(320), respc(200)
	end

	if (element == "speedo" or element == "all") and not toTrash then
		renderData.inTrash.speedo = false
		renderData.pos.speedoX, renderData.pos.speedoY = screenX - resp(5) - respc(256), screenY - resp(5) - respc(256)
		renderData.placeholder.speedo = "KILÓMÉTERÓRA"
	end

	if (element == "fuel" or element == "all") and not toTrash then
		renderData.inTrash.fuel = false
		renderData.pos.fuelX, renderData.pos.fuelY = screenX - resp(5) - respc(256) - respc(256) + respc(80), screenY - resp(5) - respc(256) + respc(64)
		renderData.placeholder.fuel = "ÜZEMANYAG"
	end

	if (element == "carname" or element == "all") and not toTrash then
		renderData.inTrash.carname = false
		renderData.pos.carnameX, renderData.pos.carnameY = screenX - resp(5) - respc(256), screenY - resp(5) - respc(291)
		renderData.placeholder.carname = "JÁRMŰNÉV"
	end

	if (element == "nos" or element == "all") and not toTrash then
		renderData.inTrash.nos = false
		renderData.pos.nosX, renderData.pos.nosY = screenX - resp(5) - respc(25), screenY - resp(5) - respc(256) + respc(5)
		renderData.placeholder.nos = "NOS"
	end

	if element == "mobile" or element == "all" then
		if not toTrash then
			renderData.inTrash.mobile = false
			renderData.pos.mobileX, renderData.pos.mobileY = screenX - respc(250) - resp(12), screenY / 2 - respc(500) / 2
			renderData.placeholder.mobile = "mobile"
		end

		renderData.size.mobileX, renderData.size.mobileY = respc(250), respc(500)
	end
end

function resetHudElements()
	resetHudElement("all")
end
addCommandHandler("resethud", resetHudElements)

render = {}

local hudElements = {
	"chat",
	"oocchat",
	"hp",
	"arm",
	"hunger",
	"drink",
	"stamina",
	"money",
	"infobox",
	"kickbox",
	"actionbar",
	"slotcoin",
	"weapons",
	"fps",
	"clock",
	"vstats",
	"ping",
	"stats",
	"minimap",
	"speedo",
	"fuel",
	"nos",
	"carname",
	"bone",
	"mobile"
}
local lastActionBarX = 9999
local lastActionBarY = 9999
local actionBarState = true

function processActionBarShowHide(state)
	if actionBarState ~= state then
		actionBarState = state
		exports.sm_items:processActionBarShowHide(state)
	end
end

function drawBorder(x, y, sx, sy, borderWidth, borderColor)
	if not borderColor then
		borderColor = tocolor(20, 20, 20, 255)
	end

	dxDrawRectangle(x - borderWidth, y, borderWidth, sy, borderColor) -- bal
	dxDrawRectangle(x + sx, y, borderWidth, sy, borderColor) -- jobb
	dxDrawRectangle(x - borderWidth, y - borderWidth, sx + 2, borderWidth, borderColor) -- felső
	dxDrawRectangle(x - borderWidth, y + sy, sx + 2, borderWidth, borderColor) -- alsó
end 

local lifeRing = dxCreateTexture("files/images/life-ring.png")

render.actionbar = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["actionbar"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["actionbar"] and smoothMove < resp(224) then
		return
	end
	local sx, sy = resp(251), resp(46)

	x, y = x + resp(5), y + resp(5)

	dxDrawRectangle(x - resp(5), y - resp(5), sx, sy, tocolor(30, 30, 30, 255))
	drawBorder(x - resp(5), y - resp(5), sx, sy, 1, tocolor(20, 20, 20, 230))


	if lastActionBarX ~= x or lastActionBarY ~= y then
		lastActionBarX = x
		lastActionBarY = y
		exports.sm_items:changeItemStartPos(x, y)
	end

	x, y = x - resp(5), y - resp(5)

	local oxygenLevel = getPedOxygenLevel(localPlayer) / 10

	if math.ceil(oxygenLevel) < 100 then
		local r, g, b = 97, 226, 252

		if oxygenLevel < 35 then
			local progress = 1-oxygenLevel / 35

			r, g, b = interpolateBetween(97, 226, 252, 215, 89, 89, progress, "Linear")
		end

		dxDrawSeeBar(x + respc(14) + respc(7), y - respc(12) - respc(5), sx - respc(32) + respc(7), respc(12), 2, tocolor(r, g, b, 200), getPedOxygenLevel(localPlayer) / 10, "o2")
		dxDrawImage(math.floor(x - respc(7)), math.floor(y - respc(12) - respc(5) - respc(8) - 1), respc(32), respc(32), lifeRing, 0, 0, 0, tocolor(r, g, b))
	end

	return true
end

addEvent("requestChangeItemStartPos", true)
addEventHandler("requestChangeItemStartPos", localPlayer,
	function()
		lastActionBarX, lastActionBarY = 9999, 9999
	end
)

local boneTexture = dxCreateTexture("files/images/bone.png")
local injureRightArmTextre = dxCreateTexture("files/images/injureRightArm.png")
local injureLeftArmTextre = dxCreateTexture("files/images/injureLeftArm.png")
local injureRightFootTextre = dxCreateTexture("files/images/injureRightFoot.png")
local injureLeftFootTextre = dxCreateTexture("files/images/injureLeftFoot.png")

render.bone = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["bone"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["bone"] and  smoothMove < resp(224) then
		return
	end
	x, y = math.floor(x), math.floor(y)

	dxDrawImage(x, y, respc(50), respc(50), boneTexture, 0, 0, 0, tocolor(200, 200, 200, 200))

	if injureRightArm then
		dxDrawImage(x, y, respc(50), respc(50), injureRightArmTextre, 0, 0, 0)
	end

	if injureLeftArm then
		dxDrawImage(x, y, respc(50), respc(50), injureLeftArmTextre, 0, 0, 0)
	end

	if injureRightFoot then
		dxDrawImage(x, y, respc(50), respc(50), injureRightFootTextre, 0, 0, 0)
	end

	if injureLeftFoot then
		dxDrawImage(x, y, respc(50), respc(50), injureLeftFootTextre, 0, 0, 0)
	end
end

local moveHealth = 0
local moveArmor = 0
local moveHunger = 0
local moveDrink = 0
local moveStamina = 0

addEventHandler("onClientElementDataChange", localPlayer,
	function(theKey,oldValue,newValue)
		if (theKey == "loggedIn") then  
			moveHealth = 0
			moveArmor = 0
			moveHunger = 0
			moveDrink = 0
			moveStamina = 0
		end  
	end
) 

--[[
local hud1 = svgCreate(resp(40), resp(40), heartPath)
local hud2 = svgCreate(resp(40), resp(40), armorPath)
local hud3 = svgCreate(resp(40), resp(40), foodPath)
local hud4 = svgCreate(resp(40), resp(40), drinkPath)
local hud5 = svgCreate(resp(40), resp(40), boltPath)
]]

local hud1 = dxCreateTexture("files/images/heart.png")
local hud2 = dxCreateTexture("files/images/shield.png")
local hud3 = dxCreateTexture("files/images/cutlery.png")
local hud4 = dxCreateTexture("files/images/thirst.png")
local hud5 = dxCreateTexture("files/images/bolt.png")

local hudLines = svgCreate(512, 512, "files/images/hudLines.svg")
local hudBack = svgCreate(512, 512, "files/images/hudBack.svg")

local hudLines2 = svgCreate(512, 512, "files/images/hudLines2.svg")
local hudBack2 = svgCreate(512, 512, "files/images/hudBack2.svg")

render.hp = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["hp"] then
		return
	end

	if renderData.showTrashTray and renderData.inTrash["hp"] and  smoothMove < resp(224) then
		return
	end

	local y = y - resp(7)
	local multiValue = 8
	local hs = resp(512 - (moveHealth * 5.12))
	dxDrawImage(x-resp(3), y-resp(3), resp(64)+resp(6), resp(64)+resp(6), hudBack, 180, 0, 0, tocolor(55, 55, 55, 205))
	dxDrawImage(x-resp(3), y-resp(3), resp(64)+resp(6), resp(64)+resp(6), hudLines, 180 ,0, 0, tocolor(0, 0, 0, 200))

	dxDrawImageSection(x, y+hs/multiValue, resp(64), resp(64)-hs/multiValue, 0, 0, 512, moveHealth * 5.12, hudLines, 180, 0, 0, tocolor(203, 98, 96, 200))
	dxDrawImage(x-resp(40)/2+resp(64)/2, y-resp(40)/2+resp(64)/2, resp(40), resp(40), hud1, 0 ,0, 0, tocolor(212, 52, 52, 150))
	
	if moveHealth > getElementHealth(localPlayer) then
		moveHealth = moveHealth-1
	  end
	if moveHealth < getElementHealth(localPlayer) then
		moveHealth = moveHealth+1
	end
end

render.arm = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["arm"] then
		return
	end

	if renderData.showTrashTray and renderData.inTrash["arm"] and  smoothMove < resp(224) then
		return
	end

	local y = y - resp(7)
	local multiValue = 8
	local hs = resp(512 - (moveArmor * 5.12))

	dxDrawImage(x-resp(3), y - resp(3), resp(64) + resp(6), resp(64) + resp(6), hudBack2, 180, 0, 0, tocolor(55, 55, 55, 205))
	dxDrawImage(x-resp(3), y - resp(3), resp(64) + resp(6), resp(64) + resp(6), hudLines2, 180 ,0, 0, tocolor(0, 0, 0, 200))

	dxDrawImageSection(x, y + hs / multiValue, resp(64), resp(64) - hs / multiValue, 0, 0, 512, moveArmor * 5.12, hudLines2, 180, 0, 0, tocolor(77, 134, 197, 200))
	dxDrawImage(x-resp(40)/2+resp(64)/2, y-resp(40)/2+resp(64)/2, resp(40), resp(40), hud2, 0 ,0, 0, tocolor(42, 85, 130, 150))
	
	if moveArmor > getPlayerArmor(localPlayer) then
		moveArmor = moveArmor-1
	  end
	if moveArmor < getPlayerArmor(localPlayer) then
		moveArmor = moveArmor+1
	end
end

render.hunger = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["hunger"] then
		return
	end

	if renderData.showTrashTray and renderData.inTrash["hunger"] and  smoothMove < resp(224) then
		return
	end

	local y = y-resp(7)
	local multiValue = 8
	local hs = resp(512-(moveHunger*5.12))
	dxDrawImage(x-resp(3), y - resp(3), resp(64) + resp(6), resp(64) + resp(6), hudBack, 180, 0, 0, tocolor(55, 55, 55, 205))
	dxDrawImage(x-resp(3), y - resp(3), resp(64) + resp(6), resp(64) + resp(6), hudLines, 180 ,0, 0, tocolor(0, 0, 0, 200))
	dxDrawImageSection(x, y+hs/multiValue, resp(64), resp(64)-hs/multiValue, 0, 0, 512, moveHunger*5.12, hudLines, 180, 0, 0, tocolor(203, 179, 96, 200))
	dxDrawImage(x-resp(40)/2+resp(64)/2, y-resp(40)/2+resp(64)/2, resp(40), resp(40), hud3, 0 ,0, 0, tocolor(129, 130, 42, 150))
	
	if moveHunger > getElementData(localPlayer,"char.Hunger") then
        moveHunger = moveHunger - 1
    end
    if moveHunger < getElementData(localPlayer,"char.Hunger") then
        moveHunger = moveHunger + 1
    end
end

render.drink = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["drink"] then
		return
	end

	if renderData.showTrashTray and renderData.inTrash["drink"] and  smoothMove < resp(224) then
		return
	end

	local y = y-resp(7)
	local multiValue = 8
	local hs = resp(512-(moveDrink*5.12))
	dxDrawImage(x-resp(3), y - resp(3), resp(64) + resp(6), resp(64) + resp(6), hudBack2, 180, 0, 0, tocolor(55, 55, 55, 205))
	dxDrawImage(x-resp(3), y - resp(3), resp(64) + resp(6), resp(64) + resp(6), hudLines2, 180 ,0, 0, tocolor(0, 0, 0, 200))
	dxDrawImageSection(x, y+hs/multiValue, resp(64), resp(64)-hs/multiValue, 0, 0, 512, moveDrink*5.12, hudLines2, 180, 0, 0, tocolor(	77, 194, 197, 200))
	dxDrawImage(x-resp(40)/2+resp(64)/2, y-resp(40)/2+resp(64)/2, resp(40), resp(40), hud4, 0 ,0, 0, tocolor(42, 129, 130, 150))
	
	if moveDrink > getElementData(localPlayer,"char.Thirst") then
        moveDrink = moveDrink - 1
    end
    if moveDrink < getElementData(localPlayer,"char.Thirst") then
        moveDrink = moveDrink + 1
    end
end

render.stamina = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["stamina"] then
		return
	end

	if renderData.showTrashTray and renderData.inTrash["stamina"] and  smoothMove < resp(224) then
		return
	end

	local y = y-resp(7)
	local multiValue = 8
	local hs = resp(512-(currentStamina*5.12))
	r, g, b = 200, 200, 200
	if currentStamina < 25 then
		r, g, b = interpolateBetween(255, 255, 255, 215, 89, 89, 1-currentStamina / 25, "Linear")
	end
	dxDrawImage(x-resp(3), y-resp(3), resp(64)+resp(6), resp(64)+resp(6), hudLines, 180 ,0, 0, tocolor(59, 59, 59, 200))
	dxDrawImage(x-resp(3), y-resp(3), resp(64)+resp(6), resp(64)+resp(6), hudBack, 180, 0, 0, tocolor(25, 25, 25, 180))
	dxDrawImageSection(x, y+hs/multiValue, resp(64), resp(64)-hs/multiValue, 0, 0, 512, currentStamina*5.12, hudLines, 180, 0, 0, tocolor(r, g, b, 150))
	dxDrawImage(x-resp(40)/2+resp(64)/2, y-resp(40)/2+resp(64)/2, resp(40), resp(40), hud5, 0 ,0, 0, tocolor(r, g, b , 150))
end



render.money = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["money"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["money"] and  smoothMove < resp(224) then
		return
	end
	local currentVal = renderData.currentMoney
	local str = ""
	local textWidth = 0
	local now = getTickCount()

	if tonumber(renderData.currentMoney) < 0 then
		textWidth = dxGetTextWidth("- " .. renderData.currentMoney .. " $", 0.5, moneyFont)
	else
		textWidth = dxGetTextWidth(renderData.currentMoney .. " $", 0.5, moneyFont)
	end

	if renderData.moneyChangeTick and now >= renderData.moneyChangeTick and now <= renderData.moneyChangeTick + 5000 then
		currentVal = renderData.moneyChangeValue or 0

		if tonumber(currentVal) < 0 then
			currentVal = "#d75959- " .. math.abs(currentVal)
		elseif tonumber(currentVal) > 0 then
			currentVal = "#3d7abc+ " .. currentVal
		else
			currentVal = 0
		end

		str = currentVal
	else
		renderData.resizingLimitMin.moneyX = textWidth

		if renderData.resizingLimitMin.moneyX < 100 then
			renderData.resizingLimitMin.moneyX = 100
		end

		if renderData.size.moneyX < renderData.resizingLimitMin.moneyX then
			renderData.size.moneyX = renderData.resizingLimitMin.moneyX
		end

		for i = 1, math.floor((renderData.size.moneyX - textWidth) / dxGetTextWidth("0", 0.5, moneyFont)) + string.len(renderData.currentMoney) - utfLen(currentVal) do
			str = str .. "#c8c8c80"
		end

		if tonumber(currentVal) < 0 then
			currentVal = "#d75959" .. math.abs(currentVal)
		elseif tonumber(currentVal) > 0 then
			currentVal = "#3d7abc" .. math.abs(currentVal)
		else
			currentVal = 0
		end

		str = str .. currentVal

		if tonumber(renderData.currentMoney) < 0 then
			str = "- " .. str
		end

		str = str .. "#c8c8c8"
	end

	dxDrawBorderText(str .. " $", x, y, x + renderData.size.moneyX, y + resp(65), tocolor(255, 255, 255), 0.5, moneyFont, "right", "center", false, false, false, true)
end

render.slotcoin = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["slotcoin"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["slotcoin"] and  smoothMove < resp(224) then
		return
	end
	local currentVal = renderData.currentSlotcoin
	local str = ""
	local textWidth = 0

	if tonumber(renderData.currentSlotcoin) < 0 then
		textWidth = dxGetTextWidth("- " .. renderData.currentSlotcoin .. " Coin", 0.5, moneyFont)
	else
		textWidth = dxGetTextWidth(renderData.currentSlotcoin .. " Coin", 0.5, moneyFont)
	end

	renderData.resizingLimitMin.slotcoinX = textWidth

	if renderData.resizingLimitMin.slotcoinX < 100 then
		renderData.resizingLimitMin.slotcoinX = 100
	end

	if renderData.size.slotcoinX < renderData.resizingLimitMin.slotcoinX then
		renderData.size.slotcoinX = renderData.resizingLimitMin.slotcoinX
	end

	for i = 1, math.floor((renderData.size.slotcoinX - textWidth) / dxGetTextWidth("0", 0.5, moneyFont)) + string.len(renderData.currentSlotcoin) - utfLen(currentVal) do
		str = str .. "#c8c8c80"
	end

	if tonumber(currentVal) < 0 then
		currentVal = "#d75959" .. math.abs(currentVal)
	elseif tonumber(currentVal) > 0 then
		currentVal = "#598ed7" .. math.abs(currentVal)
	else
		currentVal = 0
	end

	str = str .. currentVal

	if tonumber(renderData.currentSlotcoin) < 0 then
		str = "- " .. str
	end

	str = str .. "#c8c8c8"

	dxDrawBorderText(str .. " Coin", x, y, x + renderData.size.slotcoinX, y + resp(65), tocolor(255, 255, 255), 0.5, moneyFont, "right", "center", false, false, false, true)
end

addEvent("weaponOverheatSound", true)
addEventHandler("weaponOverheatSound", getRootElement(),
	function ()
		if source ~= localPlayer then
			local x, y, z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			local soundElement = playSound3D("files/sounds/overheat.mp3", x, y, z)

			if isElement(soundElement) then
				setElementInterior(soundElement, int)
				setElementDimension(soundElement, dim)
				attachElements(soundElement, source)
			end
		end
	end)

addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function (weaponId)
		if heatIncreaseValue[weaponId] and currentWeaponDbID and not getElementData(localPlayer, "tazerState") then
			if not currentHeat[currentWeaponDbID] then
				currentHeat[currentWeaponDbID] = 0
			end
			
			currentHeat[currentWeaponDbID] = currentHeat[currentWeaponDbID] + heatIncreaseValue[weaponId]
			
			if currentHeat[currentWeaponDbID] >= 100 then
				currentHeat[currentWeaponDbID] = 100
				
				if not fireDisabled then
					triggerServerEvent("weaponOverheat", localPlayer, getElementsByType("player", getRootElement(), true), currentWeaponDbID)

					playSound("files/sounds/overheat.mp3")
					
					fireDisabled = true
					exports.sm_controls:toggleControl({"fire", "vehicle_fire", "action"}, false)
				
					overheated[currentWeaponDbID] = true
					showInfobox("w", "Túlmelegedett a fegyvered!")

					exports.sm_chat:sendLocalDoC(localPlayer, "Túlmelegedett a fegyvere")
				end
			end
			
			lastFireTick[currentWeaponDbID] = getTickCount()
		end
	end)

addEventHandler("onClientPreRender", getRootElement(),
	function (timeSlice)
		for k, v in pairs(lastFireTick) do
			if getTickCount() - v >= 500 then
				if currentHeat[k] >= 75 then
					currentHeat[k] = currentHeat[k] - heatDecreaseValue[weaponItems[k]] * 0.5 * timeSlice
				else
					currentHeat[k] = currentHeat[k] - heatDecreaseValue[weaponItems[k]] * timeSlice
				end
				
				if overheated[k] and currentWeaponDbID == k and not fireDisabled then
					fireDisabled = true
					exports.sm_controls:toggleControl({"fire", "vehicle_fire", "action"}, false)
				end
				
				if currentHeat[k] < 75 and currentWeaponDbID == k and fireDisabled then
					fireDisabled = false
					overheated[k] = false
					exports.sm_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
				end
				
				if currentHeat[k] < 0 then
					currentHeat[k] = 0
					lastFireTick[k] = nil
				end
			end
		end
	end)

render.weapons = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["weapons"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["weapons"] and  smoothMove < resp(224) then
		return
	end
	local weap = getPedWeapon(localPlayer)
	if weap == 0 then
		return
	end

	if renderData.tazerState then
		dxDrawImage(x, y, resp(100), resp(100), "files/images/weapons/tazer.png")

		if renderData.tazerReloadNeeded then
			dxDrawBorderText("--", x-resp(75), y + resp(74), x-resp(75) + resp(250), y + resp(74) + resp(65), tocolor(255, 255, 255), 0.5, strongFont, "center", "center")
		else
			dxDrawBorderText("OK", x-resp(75), y + resp(74), x-resp(75) + resp(250), y + resp(74) + resp(65), tocolor(255, 255, 255), 0.5, strongFont, "center", "center")
		end
	else
		dxDrawImage(x, y, resp(100), resp(100), "files/images/weapons/" .. weap .. ".png")

		if heatIncreaseValue[weap] or weap == 41 then
			dxDrawBorderText("#c8c8c8" ..getPedAmmoInClip(localPlayer) .. " | " .. getPedTotalAmmo(localPlayer) - 1, x-resp(75), y + resp(74), x-resp(75) + resp(250), y + resp(74) + resp(65), tocolor(255, 255, 255), 0.5, strongFont, "center", "center", false, false, false, true)
			
			if heatIncreaseValue[weap] then
				dxDrawSeeBar(x-resp(200) + resp(200), y + resp(129), resp(100), resp(12), 2, tocolor(215, 89, 89, 200), currentHeat[currentWeaponDbID] or 0, "weaponHeat")
			end
		end
	end
end

renderData.countedFrames = 0

render.fps = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["fps"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["fps"] and  smoothMove < resp(224) then
		return
	end
	if renderData.fps then
		if renderData.fps > 20 and renderData.fps < 50 then
			dxDrawBorderText((renderData.fps or 0) .. " FPS", x, y, x + resp(100), y + resp(25), tocolor(223, 181, 81), 0.5, strongFont, "center", "center")
		elseif renderData.fps >= 50 then
			dxDrawBorderText((renderData.fps or 0) .. " FPS", x, y, x + resp(100), y + resp(25), tocolor(61, 122, 188), 0.5, strongFont, "center", "center")
		else
			dxDrawBorderText((renderData.fps or 0) .. " FPS", x, y, x + resp(100), y + resp(25), tocolor(215, 89, 89), 0.5, strongFont, "center", "center")
		end
	else
		dxDrawBorderText("...", x, y, x + resp(100), y + resp(25), tocolor(255, 255, 255), 0.5, strongFont, "center", "center")
	end
end

render.clock = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["clock"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["clock"] and  smoothMove < resp(224) then
		return
	end
	local time = getRealTime()

	dxDrawBorderText(string.format("%02d:%02d", time.hour, time.minute), x, y, x + resp(100), y + resp(25), tocolor(255, 255, 255), 0.5, strongFont, "center", "center")
end

local vstatsFormat = "#3d7abc%s#ffffff\n"
vstatsFormat = vstatsFormat .. "VRAM: %d/%d MB, FONT: %d MB,\n"
vstatsFormat = vstatsFormat .. "TEXTURE: %d MB, RTARGET: %d MB,\n"
vstatsFormat = vstatsFormat .. "RATIO: %s, SIZE: %dx%dx%d"

render.vstats = function (x, y)
	local dx = dxGetStatus()
	if renderData.showTrashTray and not renderData.inTrash["vstats"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["vstats"] and  smoothMove < resp(224) then
		return
	end
	if getPlayerSerial(localPlayer) == "6506960425D3D38103C9D76F43AC2B44" then
		dxDrawBorderText(string.format(vstatsFormat,
		dx.VideoCardName,
		dx.VideoCardRAM - dx.VideoMemoryFreeForMTA, "24576", dx.VideoMemoryUsedByFonts,
		dx.VideoMemoryUsedByTextures, dx.VideoMemoryUsedByRenderTargets,
		dx.SettingAspectRatio, screenX, screenY,  (dx.Setting32BitColor and 32 or 16)),
		x + resp(5), y, x + resp(300), y + resp(100), tocolor(255, 255, 255), 1, RalewayB, "left", "center", false, false, false, true)
	else
		dxDrawBorderText(string.format(vstatsFormat,
		dx.VideoCardName,
		dx.VideoCardRAM - dx.VideoMemoryFreeForMTA, dx.VideoCardRAM, dx.VideoMemoryUsedByFonts,
		dx.VideoMemoryUsedByTextures, dx.VideoMemoryUsedByRenderTargets,
		dx.SettingAspectRatio, screenX, screenY,  (dx.Setting32BitColor and 32 or 16)),
		x + resp(5), y, x + resp(300), y + resp(100), tocolor(255, 255, 255), 1, RalewayB, "left", "center", false, false, false, true)
	end
	
end

render.ping = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["ping"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["ping"] and  smoothMove < resp(224) then
		return
	end
	local ping = getPlayerPing(localPlayer)

	if ping > 50 and ping < 125 then
		dxDrawBorderText("PING: #dfb551" .. ping .. " ms", x, y, x + resp(150), y + resp(25), tocolor(255, 255, 255), 1, RalewayB, "center", "center", false, false, false, true)
	elseif getPlayerPing(localPlayer) < 50 then
		dxDrawBorderText("PING: #3d7abc" .. ping .. " ms", x, y, x + resp(150), y + resp(25), tocolor(255, 255, 255), 1, RalewayB, "center", "center", false, false, false, true)
	else
		dxDrawBorderText("PING: #d75959" .. ping .. " ms", x, y, x + resp(150), y + resp(25), tocolor(255, 255, 255), 1, RalewayB, "center", "center", false, false, false, true)
	end
end

render.stats = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["stats"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["stats"] and  smoothMove < resp(224) then
		return
	end
	dxDrawBorderText((renderData.characterName:gsub("_", " ") or "") .. " #3d7abc(" .. (renderData.playerID or 0) .. ") #ffffffSzint: #3d7abc" .. renderData.currentLevel, x, y, x + resp(350), y + resp(25), tocolor(255, 255, 255), 0.50, Raleway, "center", "center", false, false, false, true)
end

function setChatType(typ)
	renderData.chatType = typ

	if renderData.chatType == -1 then
		showChat(false)
	elseif renderData.chatType == 0 then
		if renderData.hudDisableNumber < 1 then
			showChat(true)
		else
			showChat(false)
		end
	elseif renderData.chatType == 1 then
		showChat(false)
	end
end

function toggleChat()
	if renderData.chatType == 1 then
		renderData.chatType = 0

		if renderData.hudDisableNumber < 1 then
			showChat(true)
		else
			showChat(false)
		end

		return 0
	elseif renderData.chatType == 0 then
		renderData.chatType = -1
		return -1
	elseif renderData.chatType == -1 then
		renderData.chatType = 1
		return 1
	end
end

function getChatType()
	return renderData.chatType
end

local serverLogo = exports.sm_core:getServerLogo()

addEventHandler("onClientHUDRender", getRootElement(),
	function ()
		if renderData.hudDisableNumber < 1 then
			if pressingHudKey then
				if not renderData.screenSrc then
					renderData.screenSrc = dxCreateScreenSource(screenX, screenY)
					renderData.urmasound = playSound("files/sounds/urmasound.mp3", true)
					renderData.screenShader = dxCreateShader("files/shaders/monochrome.fx")

					dxSetShaderValue(renderData.screenShader, "screenSource", renderData.screenSrc)
					dxSetShaderValue(renderData.screenShader, "alpha", 1)
				end
				
				dxUpdateScreenSource(renderData.screenSrc)

				if renderData.screenShader then
					dxDrawImage(0, 0, screenX, screenY, renderData.screenShader, 0, 0, 0, tocolor(150, 150, 255))
				else
					dxDrawImage(0, 0, screenX, screenY, renderData.screenSrc, 0, 0, 0, tocolor(150, 150, 255))
				end
				dxDrawImage(screenX/2-resp(100)/2, screenY/2-resp(130), resp(100), resp(100), serverLogo, 0, 0, 0, tocolor(150, 150, 255))
				dxDrawBorderText("Interface szerkesztés", 0, 0, screenX, screenY, tocolor(255, 255, 255, 200), 0.75, RobotoB, "center", "center")
			else
				if renderData.screenShader then
					destroyElement(renderData.screenShader)
				end
				renderData.screenShader = nil

				if renderData.screenSrc then
					destroyElement(renderData.screenSrc)
				end
				renderData.screenSrc = nil

				if renderData.urmasound then
					destroyElement(renderData.urmasound)
				end
				renderData.urmasound = nil
			end

			local cx, cy = getHudCursorPos()

			if tonumber(cx) then
				cx, cy = cx * screenX, cy * screenY

				if (cy > screenY - 5 or renderData.showTrashTray) and #renderData.moving < 1 and not renderData.resizing then
					if not renderData.showTrashTray and not currentSmoothTick then
						renderData.showTrashTray = true
						currentSmoothTick = getTickCount()
						polateBool1 = 0
						polateBool2 = resp(225)
					end
					smoothMoveProgress = (getTickCount()-currentSmoothTick)/350
					smoothMove = interpolateBetween(polateBool1, 0, 0, polateBool2, 0, 0, smoothMoveProgress, "Linear")
					dxDrawRectangle(0, screenY-smoothMove, screenX, resp(225), tocolor(25, 25, 25))
				end

				if cy < screenY - resp(225) and renderData.showTrashTray then
					--currentSmoothTick = getTickCount()
					--renderData.showTrashTray = false
					if smoothMove > resp(224) then
						currentSmoothTick = getTickCount()
						polateBool1 = resp(224)
						polateBool2 = 0
					end

					if smoothMove == 0 then
						currentSmoothTick = false
						renderData.showTrashTray = false
					end
					--conClientHUDRender
				end
			elseif renderData.showTrashTray then
				renderData.showTrashTray = false
				currentSmoothTick = false
			end
		end
	end)

function spairs(t, order)
	local keys = {}

	for k in pairs(t) do
		keys[#keys + 1] = k
	end

	if order then
		table.sort(keys, function (a, b)
			return order(t, a, b)
		end)
	else
		table.sort(keys)
	end

	local i = 0

	return function ()
		i = i + 1

		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

spairs(hudElements)

function setPokerMode(state)
	renderData.pokerChat = state

	if state then
		renderData.oldTalk = getElementData(localPlayer, "talkingAnim")
		setElementData(localPlayer, "talkingAnim", -1)
	else
		setElementData(localPlayer, "talkingAnim", renderData.oldTalk)
	end
end

--local font = dxCreateFont("files/fonts/plateFont.ttf", 45, true)
--local infoFont = dxCreateFont("files/fonts/plateFont.ttf", 20, true)

--local tex_plates = {}
--local raw_shader = [[
--    texture plate;
--    technique TexReplace {
--        pass P0 {
--            Texture[0] = plate;
--        }
--    }
--]]
--[[
local vehiclePlatePixels = {}
local vehiclePlateTexture = {}

function getPlateShader(vehicle)
    if tex_plates[vehicle] then
        if isElement(tex_plates[vehicle]) then
            destroyElement(tex_plates[vehicle])
        end
        tex_plates[vehicle] = nil
    end

	if vehiclePlateTexture[vehicle] then
		vehiclePlateTexture[vehicle] = nil
	end

	if vehiclePlateTexture[vehicle] then
		if isElement(vehiclePlateTexture[vehicle]) then
			destroyElement(vehiclePlateTexture[vehicle])
		end
	end

    local rt = dxCreateRenderTarget(512, 256)

	local plateText = getVehiclePlateText(vehicle)

		local plateSections = {}
		plateText = split(plateText, "-")

		for i = 1, #plateText do
			if utf8.len(plateText[i]) > 0 then
				table.insert(plateSections, plateText[i])
			end
		end

    dxSetRenderTarget(rt)
		if getElementData(vehicle, "veh.plateBlack") == "black" then
			drawedTexture = plateBlackTexture 
			plateColor = "#FFCD58"
		elseif getElementData(vehicle, "veh.plateBlack") == "white" then
			drawedTexture = plateWhiteTexture 
			plateColor = "#000000"
		elseif getElementData(vehicle, "veh.plateBlack") == "liberty" then
			drawedTexture = plateLibertyTexture 
			plateColor = "#191919"
		else
			drawedTexture = plateTexture 
			plateColor = "#ffffff"
		end

		dxDrawImage(0, 0, 512, 256, drawedTexture)
        dxDrawText(plateColor .. table.concat(plateSections, "-") or "", 0, 50, 512, 256, tocolor(200, 200, 200, 200), 1, font, "center", "center", false, false, false, true)
		dxDrawText(plateColor .. "2021\n09\n23", 512 - 20, 256 / 2 + 10, nil, nil, tocolor(200, 200, 200, 200), 1, infoFont, "right", "center", false, false, false, true)
    dxSetRenderTarget()
	
	vehiclePlatePixels[vehicle] = dxGetTexturePixels(rt)

	vehiclePlateTexture[vehicle] = dxCreateTexture(vehiclePlatePixels[vehicle])
	 
    
    tex_plates[vehicle] = dxCreateShader(raw_shader)
    dxSetShaderValue(tex_plates[vehicle], "plate", vehiclePlateTexture[vehicle])

    return tex_plates[vehicle]
end

function onStreamIn(vehicle)
	local shader = getPlateShader(vehicle)
    engineApplyShaderToWorldTexture(shader, "plate", vehicle)
end

addEventHandler("onClientElementDataChange", getRootElement(),
	function(dataKey)
		if dataKey == "veh.plateBlack" then
			onStreamIn(source)
		end
	end
)

function onStreamOut(vehicle)
    if tex_plates[vehicle] then
        engineRemoveShaderFromWorldTexture(tex_plates[vehicle], "plate", vehicle)

        if isElement(tex_plates[vehicle]) then
            destroyElement(tex_plates[vehicle])
        end

		if vehiclePlateTexture[vehicle] then
			if isElement(vehiclePlateTexture[vehicle]) then
				destroyElement(vehiclePlateTexture[vehicle])
			end
		end

		if vehiclePlateTexture[vehicle] then
			vehiclePlateTexture[vehicle] = nil
		end

        tex_plates[vehicle] = nil
    end
end

addEventHandler("onClientElementStreamIn", root, 
	function()
		if getElementType(source) == "vehicle" then
			onStreamIn(source)
		end
	end
)

addEventHandler("onClientElementStreamOut", root, 
	function()
		if getElementType(source) == "vehicle" then
			onStreamOut(source)
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		local vehicles = getElementsByType("vehicle", getRootElement(), true)
		for i = 1, #vehicles do
			onStreamIn(vehicles[i])
		end
	end
)

addEventHandler("onClientRestore", root, 
	function(cleared)
		--if cleared then
			for vehicle in pairs(tex_plates) do
				tex_plates[vehicle] = getPlateShader(vehicle)
				engineApplyShaderToWorldTexture(tex_plates[vehicle], "plate", vehicle)
			end
		--end
	end
)
]]
addEventHandler("onClientHUDRender", getRootElement(),
	function ()
		if renderData.pokerChat then
			showChat(true)
		end

		if renderData.hudDisableNumber < 1 then
			if renderData.loggedIn then
				local now = getTickCount()

				if isCursorShowing() then
					pressingHudKey = getKeyState("lctrl")
					if not pressingHudKey then
						currentSmoothTick = false
					end
				elseif pressingHudKey then
					pressingHudKey = false
					currentSmoothTick = false
				end

				renderData.countedFrames = renderData.countedFrames + 1

				if not renderData.lastFPSReset then
					renderData.lastFPSReset = now
				end

				if now - renderData.lastFPSReset >= 1000 then
					renderData.fps = renderData.countedFrames
					renderData.countedFrames = 0
					renderData.lastFPSReset = now
				end

				local cx, cy = getHudCursorPos()

				if tonumber(cx) then
					cx = cx * screenX
					cy = cy * screenY

					if renderData.resizing then
						local hud = renderData.resizing[1]

						renderData.size[hud .. "X"] = renderData.resizing[4] + (cx - renderData.resizing[2])
						renderData.size[hud .. "Y"] = renderData.resizing[5] + (cy - renderData.resizing[3])

						if renderData.size[hud .. "X"] >= renderData.resizingLimitMax[hud .. "X"] then
							renderData.size[hud .. "X"] = renderData.resizingLimitMax[hud .. "X"]
						end

						if renderData.size[hud .. "Y"] >= renderData.resizingLimitMax[hud .. "Y"] then
							renderData.size[hud .. "Y"] = renderData.resizingLimitMax[hud .. "Y"]
						end

						if renderData.size[hud .. "X"] <= renderData.resizingLimitMin[hud .. "X"] then
							renderData.size[hud .. "X"] = renderData.resizingLimitMin[hud .. "X"]
						end

						if renderData.size[hud .. "Y"] <= renderData.resizingLimitMin[hud .. "Y"] then
							renderData.size[hud .. "Y"] = renderData.resizingLimitMin[hud .. "Y"]
						end

						renderData.moving = {}
					end

					if renderData.select then
						dxDrawRectangle(renderData.select[1], renderData.select[2], cx - renderData.select[1], cy - renderData.select[2], tocolor(124, 197, 118, 150))
					elseif renderData.moving then
						for i = 1, #renderData.moving do
							if not renderData.moving[i][4] or not renderData.moving[i][5] then
								renderData.moving[i][4] = renderData.pos[renderData.moving[i][1] .. "X"]
								renderData.moving[i][5] = renderData.pos[renderData.moving[i][1] .. "Y"]
							else
								renderData.pos[renderData.moving[i][1] .. "X"] = renderData.moving[i][4] + (cx - renderData.moving[i][2])
								renderData.pos[renderData.moving[i][1] .. "Y"] = renderData.moving[i][5] + (cy - renderData.moving[i][3])
							end
						end
					end
				else
					renderData.moving = {}
					renderData.resizing = false
					renderData.selectedHUD = {}
				end

				if renderData.showTrashTray then
					local x = 50 - renderData.scrollX
					local y = screenY-resp(225)+resp(225) / 2

					for k, v in pairs(renderData.inTrash) do
						if v then
							local rendering = render[k]

							if rendering then
								rendering = rendering(x, y - (renderData.move[k][4] - renderData.move[k][2]) / 2)

								if k == "actionbar" and not renderData.showTrashTray then
									processActionBarShowHide(rendering)
								end

								if not rendering and renderData.placeholder[k] and isCursorShowing() and pressingHudKey then
									dxDrawBorderText(renderData.placeholder[k], renderData.move[k][1], renderData.move[k][2], renderData.move[k][3], renderData.move[k][4], tocolor(255, 255, 255), 1, Roboto, "center", "center")
								end
							end

							renderData.pos[k .. "X"] = x
							renderData.pos[k .. "Y"] = y - (renderData.move[k][4] - renderData.move[k][2]) / 2

							x = x + 50 + (renderData.move[k][3] - renderData.move[k][1])
						end
					end

					if cx and cy then
						dxDrawRectangle(0, screenY-smoothMove, resp(50), resp(225), tocolor(0, 0, 0, 100))
						dxDrawRectangle(screenX - respc(50), screenY-smoothMove, resp(50), resp(225), tocolor(0, 0, 0, 100))
						
						if isMouseInPosition(0, screenY-resp(225), resp(50), resp(225)) then
							dxDrawRectangle(0, screenY-resp(225), resp(50), resp(225), tocolor(0, 0, 0, 100))

							if getKeyState("mouse1") and renderData.scrollX > 0 then
								renderData.scrollX = renderData.scrollX - 5
							end

							dxDrawImage(0 + resp(50) / 2 - resp(32) / 2, screenY-smoothMove + resp(225) / 2 - resp(32) / 2, resp(32), resp(32), "files/images/a.png", 0, 0, 0)
						else
							dxDrawImage(0 + resp(50) / 2 - resp(26) / 2, screenY-smoothMove + resp(225) / 2 - resp(26) / 2, resp(26), resp(26), "files/images/a.png", 0, 0, 0)
						end
						
						if isMouseInPosition(screenX - respc(50), screenY-resp(225), resp(50), resp(225)) then
							dxDrawRectangle(screenX - respc(50), screenY-smoothMove, resp(50), resp(225), tocolor(0, 0, 0, 100))

							if getKeyState("mouse1") then
								renderData.scrollX = renderData.scrollX + 5
							end

							dxDrawImage(screenX - respc(50) + resp(50) / 2 - resp(32) / 2, screenY-smoothMove + resp(225) / 2 - resp(32) / 2, resp(32), resp(32), "files/images/a.png", 180, 0, 0)
						else
							dxDrawImage(screenX - respc(50) + resp(50) / 2 - resp(26) / 2, screenY-smoothMove + resp(225) / 2 - resp(26) / 2, resp(26), resp(26), "files/images/a.png", 180, 0, 0)
						end
					end
				end

				if renderData.pokerChat then
					showChat(true)
				elseif renderData.chatType == 1 or renderData.chatType == -1 then
					showChat(false)
				elseif renderData.chatType == 0 then
					showChat(true)
				end

				renderData.move.hp = {
					renderData.pos.hpX - respc(5),
					renderData.pos.hpY - respc(5),
					renderData.pos.hpX + renderData.size.hpX + respc(5),
					renderData.pos.hpY + respc(12) * 3 + respc(7) * 2 + respc(5)
				}
				renderData.move.arm = {
					renderData.pos.armX - respc(5),
					renderData.pos.armY - respc(5),
					renderData.pos.armX + renderData.size.armX + respc(5),
					renderData.pos.armY + respc(12) * 3 + respc(7) * 2 + respc(5)
				}
				renderData.move.hunger = {
					renderData.pos.hungerX - respc(5),
					renderData.pos.hungerY - respc(5),
					renderData.pos.hungerX + renderData.size.hungerX + respc(5),
					renderData.pos.hungerY + respc(12) * 3 + respc(7) * 2 + respc(5)
				}
				renderData.move.drink = {
					renderData.pos.drinkX - respc(5),
					renderData.pos.drinkY - respc(5),
					renderData.pos.drinkX + renderData.size.drinkX + respc(5),
					renderData.pos.drinkY + respc(12) * 3 + respc(7) * 2 + respc(5)
				}
				renderData.move.stamina = {
					renderData.pos.staminaX - respc(5),
					renderData.pos.staminaY - respc(5),
					renderData.pos.staminaX + renderData.size.staminaX + respc(5),
					renderData.pos.staminaY + respc(12) * 3 + respc(7) * 2 + respc(5)
				}
				renderData.move.money = {
					renderData.pos.moneyX - respc(5),
					renderData.pos.moneyY + resp(20),
					renderData.pos.moneyX + renderData.size.moneyX + respc(5),
					renderData.pos.moneyY + resp(50)
				}
				renderData.move.infobox = {
					renderData.pos.infoboxX,
					renderData.pos.infoboxY,
					renderData.pos.infoboxX + respc(512),
					renderData.pos.infoboxY + respc(32)
				}
				renderData.move.kickbox = {
					renderData.pos.kickboxX - 5,
					renderData.pos.kickboxY - 5,
					renderData.pos.kickboxX + respc(320) + 5,
					renderData.pos.kickboxY + respc(45) * 5 + 5
				}
				renderData.move.actionbar = {
					renderData.pos.actionbarX - resp(10),
					renderData.pos.actionbarY - resp(10),
					renderData.pos.actionbarX + resp(251),
					renderData.pos.actionbarY + resp(46)
				}
				renderData.move.slotcoin = {
					renderData.pos.slotcoinX - respc(5),
					renderData.pos.slotcoinY + resp(20),
					renderData.pos.slotcoinX + renderData.size.slotcoinX + respc(5),
					renderData.pos.slotcoinY + resp(50)
				}
				renderData.move.weapons = {
					renderData.pos.weaponsX-resp(10),
					renderData.pos.weaponsY-resp(10),
					renderData.pos.weaponsX + resp(120),
					renderData.pos.weaponsY + resp(120)
				}
				renderData.move.fps = {
					renderData.pos.fpsX,
					renderData.pos.fpsY,
					renderData.pos.fpsX + resp(100),
					renderData.pos.fpsY + resp(25)
				}
				renderData.move.clock = {
					renderData.pos.clockX,
					renderData.pos.clockY,
					renderData.pos.clockX + resp(100),
					renderData.pos.clockY + resp(25)
				}
				renderData.move.vstats = {
					renderData.pos.vstatsX,
					renderData.pos.vstatsY,
					renderData.pos.vstatsX + resp(300),
					renderData.pos.vstatsY + resp(100)
				}
				renderData.move.ping = {
					renderData.pos.pingX,
					renderData.pos.pingY,
					renderData.pos.pingX + resp(150),
					renderData.pos.pingY + resp(25)
				}
				renderData.move.stats = {
					renderData.pos.statsX,
					renderData.pos.statsY,
					renderData.pos.statsX + resp(350),
					renderData.pos.statsY + resp(25)
				}
				renderData.move.minimap = {
					renderData.pos.minimapX - 5,
					renderData.pos.minimapY - 5,
					renderData.pos.minimapX + renderData.size.minimapX + 5,
					renderData.pos.minimapY + renderData.size.minimapY + 5
				}
				renderData.move.speedo = {
					renderData.pos.speedoX,
					renderData.pos.speedoY,
					renderData.pos.speedoX + respc(256),
					renderData.pos.speedoY + respc(256)
				}
				renderData.move.carname = {
					renderData.pos.carnameX,
					renderData.pos.carnameY,
					renderData.pos.carnameX + respc(256),
					renderData.pos.carnameY + respc(34)
				}
				renderData.move.fuel = {
					renderData.pos.fuelX + respc(74),
					renderData.pos.fuelY + respc(74),
					renderData.pos.fuelX + respc(256) - respc(74),
					renderData.pos.fuelY + respc(256) - respc(74)
				}
				renderData.move.nos = {
					renderData.pos.nosX,
					renderData.pos.nosY,
					renderData.pos.nosX + respc(24),
					renderData.pos.nosY + respc(56)
				}
				renderData.move.bone = {
					renderData.pos.boneX - 5,
					renderData.pos.boneY - 5,
					renderData.pos.boneX + respc(50) + 5,
					renderData.pos.boneY + respc(50) + 5
				}
				renderData.move.chat = {
					renderData.pos.chatX - 5,
					renderData.pos.chatY - 5,
					renderData.pos.chatX + renderData.size.chatX + 5,
					renderData.pos.chatY + renderData.size.chatY + 5
				}
				renderData.move.oocchat = {
					renderData.pos.oocchatX - 5,
					renderData.pos.oocchatY - 5,
					renderData.pos.oocchatX + renderData.size.oocchatX + 5,
					renderData.pos.oocchatY + renderData.size.oocchatY + 5
				}

				renderData.move.mobile = {
					renderData.pos.mobileX - 5,
					renderData.pos.mobileY - 5,
					renderData.pos.mobileX + renderData.size.mobileX + 5,
					renderData.pos.mobileY + renderData.size.mobileY + 5
				}

				for i = 1, #renderData.selectedHUD do
					local k = renderData.selectedHUD[i]

					dxDrawRoundedRectangle(renderData.move[k][1], renderData.move[k][2], renderData.move[k][3] - renderData.move[k][1], renderData.move[k][4] - renderData.move[k][2], tocolor(61, 122, 188, 100))
					
					if #renderData.selectedHUD < 2 and renderData.resizable[k] then
						local x = renderData.move[k][3] - respc(20) / 2
						local y = renderData.move[k][4] - respc(20) / 2

						dxDrawImage(math.floor(renderData.move[k][3]) - 16, math.floor(renderData.move[k][4]) - 16, respc(32), respc(32), "files/images/arrows-alt.png", 0, 0, 0, tocolor(194, 194, 194))

						renderData.resizePosition = {x, y, x + respc(20), y + respc(20)}
					end
				end

				for i = 1, #hudElements do
					local hud = hudElements[i]

					if hud and renderData.move[hud] then
						if not renderData.inTrash[hud] then
							local rendering = render[hud]

							if rendering then
								rendering = rendering(renderData.pos[hud .. "X"], renderData.pos[hud .. "Y"])

								if hud == "actionbar" then
									processActionBarShowHide(rendering)
								end

								if not rendering and renderData.placeholder[hud] and isCursorShowing() and pressingHudKey and renderData.inTrash[hud] then
									dxDrawBorderText(renderData.placeholder[hud], renderData.move[hud][1], renderData.move[hud][2], renderData.move[hud][3], renderData.move[hud][4], tocolor(255, 255, 255), 1, Roboto, "center", "center")
								end
							end
						else
							if hud == "actionbar" and not renderData.showTrashTray then
								processActionBarShowHide(false)
							end
						end
					end
				end

				if cx and cy and #renderData.moving > 0 then
					local trashColor = tocolor(255, 255, 255)
					local trashRotX = 0

					if cx >= screenX / 2 - resp(32) - resp(32) and cx <= screenX / 2 + resp(32) - resp(32) and cy >= screenY / 2 + respc(32) and cy <= screenY / 2 + respc(32)  + resp(64) then
						renderData.trashGetInverse = false

						if not renderData.trashGetRedStart then
							renderData.trashGetRedStart = now
						else
							local elapsedTime = now - renderData.trashGetRedStart
							local progress = elapsedTime / 250

							local r, g, b = interpolateBetween(255, 255, 255, 215, 89, 89, progress, "Linear")
							local rotation = interpolateBetween(0, 0, 0, -35, 0, 0, progress, "Linear")

							trashRotX = rotation
							trashColor = tocolor(r, g, b)
						end
					elseif renderData.trashGetRedStart then
						renderData.trashGetRedStart = false

						if not renderData.trashGetInverse then
							renderData.trashGetInverse = now
						end
					end

					if renderData.trashGetInverse then
						local elapsedTime = now - renderData.trashGetInverse
						local progress = elapsedTime / 250

						local r, g, b = interpolateBetween(215, 89, 89, 255, 255, 255, progress, "Linear")
						local rotation = interpolateBetween(-35, 0, 0, 0, 0, 0, progress, "Linear")

						trashRotX = rotation
						trashColor = tocolor(r, g, b)
					end

					dxDrawImage(screenX / 2 - respc(64), screenY / 2 + respc(32), respc(64), respc(64), "files/images/trashbody.png", 0, 0, 0, trashColor)
					dxDrawImage(screenX / 2 - respc(64), screenY / 2 + respc(32), respc(64), respc(64), "files/images/trashtop.png", trashRotX, -32, -10, trashColor)

					local refreshColor = tocolor(255, 255, 255)
					local refreshRotX = 0

					if cx >= screenX / 2 - resp(32) + resp(32) and cx <= screenX / 2 + resp(32) + resp(32) and cy >= screenY / 2 + respc(32)  and cy <= screenY / 2 + respc(32)  + resp(64) then
						renderData.refreshGetInverse = false

						if not renderData.refreshGetRedStart then
							renderData.refreshGetRedStart = now
						else
							local elapsedTime = now - renderData.refreshGetRedStart
							local progress = elapsedTime / 250

							local r, g, b = interpolateBetween(255, 255, 255, 89, 142, 215, progress, "Linear")
							local rotation = interpolateBetween(0, 0, 0, 180, 0, 0, progress, "Linear")

							refreshRotX = rotation
							refreshColor = tocolor(r, g, b)
						end
					elseif renderData.refreshGetRedStart then
						renderData.refreshGetRedStart = false

						if not renderData.refreshGetInverse then
							renderData.refreshGetInverse = now
						end
					end

					if renderData.refreshGetInverse then
						local elapsedTime = now - renderData.refreshGetInverse
						local progress = elapsedTime / 250

						local r, g, b = interpolateBetween(89, 142, 215, 255, 255, 255, progress, "Linear")
						local rotation = interpolateBetween(180, 0, 0, 0, 0, 0, progress, "Linear")

						refreshRotX = rotation
						refreshColor = tocolor(r, g, b)
					end

					dxDrawImage(screenX / 2 - respc(32) + respc(32), screenY / 2 + respc(32), respc(64), respc(64), "files/images/refresh.png", refreshRotX, 0, 0, refreshColor)
				end
			end
		else
			if not renderData.pokerChat then
				showChat(false)
			end
		end

		if renderData.showNumberPlates then
			local camX, camY, camZ = getCameraMatrix()
			local vehicles = getElementsWithinRange(camX, camY, camZ, 50, "vehicle", getElementDimension(localPlayer), getElementInterior(localPlayer))
			local currVeh = getPedOccupiedVehicle(localPlayer)

			for i = 1, #vehicles do
				local veh = vehicles[i]

				if isElement(veh) and veh ~= currVeh then
					local vehX, vehY, vehZ = getElementPosition(veh)

					if isLineOfSightClear(vehX, vehY, vehZ + 1, camX, camY, camZ, true, true, false, true, false, true, false, veh) then

						if vehiclePlateTexture and veh then
							if vehiclePlateTexture[veh] then
								local dist = getDistanceBetweenPoints3D(vehX, vehY, vehZ, camX, camY, camZ)
								local x, y = getScreenFromWorldPosition(vehX, vehY, vehZ + 1)

								if x and y and dist < 50 then
									local scale = 1 - dist / 100
									local alpha = 1 - dist / 50

									local sx = respc(100)
									local sy = respc(40)

									local sx2 = sx * scale * 0.25

									x = x - sx * scale / 2
									y = y - sy * scale / 2

									dxDrawImage(x, y, sx, sy , vehiclePlateTexture[veh], 0, 0, 0, tocolor(200, 200, 200, 200 * alpha))
								end
							end
						end
					end
				end
			end
		end
		chatRenderedOut = false
	end
)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if key == "F10" and press then
			if renderData.hudDisableNumber < 1 then
				renderData.showNumberPlates = not renderData.showNumberPlates
			end
		end
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if renderData.loggedIn and pressingHudKey and renderData.hudDisableNumber < 1 then
			if button == "left" and state == "down" then
				local cx, cy = getHudCursorPos()

				if tonumber(cx) then
					cx = cx * screenX
					cy = cy * screenY

					local resize = false

					if renderData.resizePosition and cx >= renderData.resizePosition[1] and cy >= renderData.resizePosition[2] and cx <= renderData.resizePosition[3] and cy <= renderData.resizePosition[4] then
						resize = {renderData.selectedHUD[1], cx, cy, renderData.size[renderData.selectedHUD[1] .. "X"], renderData.size[renderData.selectedHUD[1] .. "Y"]}
						renderData.resizing = resize
					end
					if not isMouseInPosition(0, screenY-resp(225), resp(50), resp(225)) or not isMouseInPosition(screenX - respc(50), screenY-resp(225), resp(50), resp(225)) then
						if isMouseInPosition(0, screenY-resp(225), resp(50), resp(225)) or isMouseInPosition(screenX - respc(50), screenY-resp(225), resp(50), resp(225)) then
							return
						end
						local movedhud = false

						for k, v in pairs(renderData.move) do
							if (not renderData.inTrash[k] or renderData.showTrashTray) and (renderData.showTrashTray and renderData.inTrash[k] or not renderData.showTrashTray) and cx >= v[1] and cy >= v[2] and cx <= v[3] and cy <= v[4] then
								renderData.showTrashTray = false
								currentSmoothTick = false
								renderData.inTrash[k] = false
								movedhud = k
								break
							end
						end

						local selected = false

						for i = 1, #renderData.selectedHUD do
							if renderData.selectedHUD[i] == movedhud then
								selected = true
								break
							end
						end

						if not selected then
							renderData.selectedHUD = {}

							if movedhud then
								table.insert(renderData.selectedHUD, movedhud)

								renderData.inTrash[movedhud] = false
								renderData.showTrashTray = false
								currentSmoothTick = false
							end
						end

						if #renderData.selectedHUD >= 1 and movedhud then
							for i = 1, #renderData.selectedHUD do
								table.insert(renderData.moving, {renderData.selectedHUD[i], cx, cy, false, false})
							end
						else
							if not renderData.showTrashTray then
								renderData.select = {cx, cy}
							end

							renderData.selectedHUD = {}
						end
					else
						print("asasdas")
					end
				end
			elseif button == "left" and state == "up" then
				if not renderData.showTrashTray then
					renderData.moving = {}
					renderData.resizing = false

					local cx, cy = getHudCursorPos()

					if tonumber(cx) then
						cx = cx * screenX
						cy = cy * screenY

						if cx >= screenX / 2 - resp(32) - resp(32) and cx <= screenX / 2 + resp(32) - resp(32) and cy >= screenY / 2 + respc(32) and cy <= screenY / 2 + respc(32) + resp(64) then
							for k, v in pairs(renderData.selectedHUD) do
								renderData.inTrash[v] = true
								resetHudElement(v, true)
							end

							renderData.trashGetInverse = false
							renderData.trashGetRedStart = false

							renderData.moving = {}
							renderData.resizing = false
							renderData.selectedHUD = {}
						end

						if cx >= screenX / 2 - resp(32) + resp(32) and cx <= screenX / 2 + resp(32) + resp(32) and cy >= screenY / 2 + respc(32) and cy <= screenY / 2 + respc(32) + resp(64) then
							for k, v in pairs(renderData.selectedHUD) do
								resetHudElement(v)
							end

							renderData.refreshGetInverse = false
							renderData.refreshGetRedStart = false

							renderData.moving = {}
							renderData.resizing = false
							renderData.selectedHUD = {}
						end

						if renderData.select then
							if math.floor(math.abs(cx - renderData.select[1]) + math.abs(cy - renderData.select[2])) > 2 then
								local minX = math.min(cx, renderData.select[1])
								local minY = math.min(cy, renderData.select[2])
								local maxX = math.max(cx, renderData.select[1])
								local maxY = math.max(cy, renderData.select[2])

								if renderData.select then
									for k, v in pairs(renderData.move) do
										if not renderData.inTrash[k] and minX < v[3] and maxX > v[1] and minY < v[4] and maxY > v[2] then
											table.insert(renderData.selectedHUD, k)
										end
									end
								end
							end

							renderData.select = false
						end
					end
				end
			end
		end
	end)

function hideHUD()
	renderData.hudDisableNumber = renderData.hudDisableNumber + 1
	processActionBarShowHide(false)
end

function showHUD()
	renderData.hudDisableNumber = renderData.hudDisableNumber - 1

	if renderData.hudDisableNumber < 0 then
		renderData.hudDisableNumber = 0
	end
end

local hudState = true

addCommandHandler("toghud",
	function ()
		if renderData.loggedIn then
			hudState = not hudState

			if hudState then
				showHUD()
			else
				hideHUD()
			end
		end
	end)

local walkingStyles = {
	[118] = true,
	[119] = true,
	[120] = true,
	[121] = true,
	[122] = true,
	[123] = true,
	[124] = true,
	[125] = true,
	[126] = true,
	[127] = true,
	[129] = true,
	[130] = true,
	[131] = true,
	[132] = true,
	[133] = true,
	[134] = true,
	[135] = true,
	[136] = true,
	[137] = true
}

local speakStyles = {
	["prtial_gngtlka"] = true,
	["prtial_gngtlkb"] = true,
	["prtial_gngtlkc"] = true,
	["prtial_gngtlkd"] = true,
	["prtial_gngtlke"] = true,
	["prtial_gngtlkf"] = true,
	["prtial_gngtlkg"] = true,
	["prtial_gngtlkh"] = true,
	["prtial_hndshk_01"] = true,
	["prtial_hndshk_biz_01"] = true,
	["false"] = true,
}

local fightingStyles = {
	[4] = true,
	[5] = true,
	[6] = true
}

function getMobilePosition()
	if not renderData.showTrashTray then
		return {
			x = tonumber(renderData.pos.mobileX), 
			y = tonumber(renderData.pos.mobileY)
		}
    end
end
function saveHUD()
	if renderData.loggedIn then
		if fileExists("hud.data") then
			fileDelete("hud.data")
		end

		local savedata = {
			pos = {},
			size = {},
			trash = {},
			settings = {}
		}

		for k, v in pairs(renderData.pos) do
			savedata.pos[k] = v
		end

		for k, v in pairs(renderData.size) do
			savedata.size[k] = v
		end

		for k, v in pairs(renderData.inTrash) do
			if v then
				savedata.trash[k] = "true"
			else
				savedata.trash[k] = "false"
			end
		end

		savedata.settings.screenRes = screenX .. "x" .. screenY

		savedata.settings.chatType = renderData.chatType
		savedata.settings.chatBGAlpha = renderData.chatBGAlpha
		savedata.settings.chatFontBGAlpha = renderData.chatFontBGAlpha
		savedata.settings.chatFontSize = renderData.chatFontSize
		savedata.settings.showNumberPlates = renderData.showNumberPlates

		local walkingstyle = getPedWalkingStyle(localPlayer)
		local fightingstyle = getPedFightingStyle(localPlayer)
		local speakStyle = getElementData(localPlayer, "talkingAnim")

		if not walkingStyles[walkingstyle] then
			walkingstyle = 118
		end

		if not speakStyles[speakStyle] then
			speakStyle = "prtial_gngtlka"
		end

		
		if not fightingStyles[fightingstyle] then
			fightingstyle = 4
		end

		savedata.settings.walkingStyle = walkingstyle
		savedata.settings.fightingStyle = fightingstyle
		savedata.settings.speakStyle = speakStyle

		savedata.settings.state3DBlip = state3DBlip
		savedata.settings.stateMarksBlip = stateMarksBlip

		local savefile = fileCreate("hud.data")
		fileWrite(savefile, encodeString("tea", toJSON(savedata, true), {key = "__DATAFILE__"}))
		fileClose(savefile)

		if fileExists("markers.pos") then
			fileDelete("markers.pos")
		end
		
		local markersfile = fileCreate("markers.pos")

		for i = 1, #createdBlips do
			local v = createdBlips[i]

			if v and v.blipId == "minimap/newblips/markblip.png" then
				fileWrite(markersfile, v.blipPosX .. "," .. v.blipPosY, "/")
			end
		end

		fileClose(markersfile)
	end
end

function loadHUD()
	if fileExists("hud.data") then
		local savefile = fileOpen("hud.data")

		if savefile then
			local savedata = fileRead(savefile, fileGetSize(savefile))

			if savedata then
				savedata = fromJSON(decodeString("tea", savedata, {key = "__DATAFILE__"}))
			end

			fileClose(savefile)

			if savedata then
				resetHudElement("all")

				for k, v in pairs(savedata.pos) do
					renderData.pos[k] = tonumber(v)
				end

				for k, v in pairs(savedata.size) do
					renderData.size[k] = tonumber(v)
				end

				for k, v in pairs(savedata.trash) do
					if v == "true" then
						renderData.inTrash[k] = true
					else
						renderData.inTrash[k] = false
					end
				end

				if savedata.settings.screenRes then
					local res = split(savedata.settings.screenRes, "x")

					if res[1] and res[2] and (tonumber(res[1]) ~= screenX or tonumber(res[2]) ~= screenY) then
						resetHudElement("all")
						outputChatBox("#d75959[StrongMTA - HUD]: #ffffffÚj képernyőfelbontás észlelve. A HUD visszaállításra került az alapértelmezett állapotába!", 255, 255, 255, true)
						saveHUD()
					end
				end

				renderData.chatType = tonumber(savedata.settings.chatType) or 0
				renderData.chatBGAlpha = tonumber(savedata.settings.chatBGAlpha) or 0
				renderData.chatFontBGAlpha = tonumber(savedata.settings.chatFontBGAlpha) or 255
				renderData.chatFontSize = tonumber(savedata.settings.chatFontSize) or 100
				renderData.showNumberPlates = savedata.settings.showNumberPlates

				setTimer(loadChatSettings, 10000, 1)

				local walkingstyle = savedata.settings.walkingStyle
				local fightingstyle = savedata.settings.fightingStyle
				local speakStyle = savedata.settings.speakStyle

				if not tonumber(walkingstyle) or not speakStyles[speakStyle] then
					speakStyle = "prtial_gngtlka"
				end

				if not tonumber(speakStyle) or not walkingStyles[walkingstyle] then
					walkingstyle = 118
				end

				if not tonumber(fightingstyle) or not fightingStyles[fightingstyle] then
					fightingstyle = 4
				end

				triggerServerEvent("setPedWalkingStyle", localPlayer, walkingstyle)
				triggerServerEvent("setPedFightingStyle", localPlayer, fightingstyle)
				setElementData(localPlayer, "talkingAnim", speakStyle)

				state3DBlip = savedata.settings.state3DBlip
				stateMarksBlip = savedata.settings.stateMarksBlip

				if state3DBlip then
					addEventHandler("onClientHUDRender", getRootElement(), render3DBlips, true, "low-99999999")
				end

				if fileExists("markers.pos") then
					local markersfile = fileOpen("markers.pos")
					
					if markersfile then
						local buffer = ""
						
						while not fileIsEOF(markersfile) do
							buffer = buffer .. fileRead(markersfile, 500)
						end
						
						fileClose(markersfile)
						
						if buffer then
							local markers = split(buffer, "/")
							
							for i = 1, #markers do
								if markers[i] then
									local pos = split(markers[i], ",")

							--[[if pos[1] and pos[2] then
										table.insert(createdBlips, {
											blipPosX = tonumber(pos[1]),
											blipPosY = tonumber(pos[2]),
											blipPosZ = 0,
											blipId = "minimap/newblips/markblip.png",
											farShow = true,
											renderDistance = 9999,
											iconSize = 18,
											blipColor = tocolor(255, 255, 255)
										})

										table.insert(#createdBlips, markBlips)
									end]]
								end
							end
						end
					end
				end
			end
		end
	end
end

function loadChatSettings()
	setChatBackgroundAlpha(renderData.chatBGAlpha)
	setChatFontBackgroundAlpha(renderData.chatFontBGAlpha)
	setChatFontSize(renderData.chatFontSize)
end

local loadingStarted = false
local loadingStartTime = false
local loadingLogoGetStart = false
local loadingLogoGetInverse = false
local loadingTime = false
local currLoadingText = false
local loadingTexts = false
local logoMoveDifferenceX, logoMoveDifferenceY = 0, 0
local loadingSound = false
local loadingBackground = false

function showTheLoadScreen(loadTime, texts, music)
	local now = getTickCount()

	currLoadingText = 1
	loadingTexts = {}

	for i = 1, #texts do
		loadingTexts[i] = {
			texts[i],
			now + loadTime / #texts * (i - 1),
			now + loadTime / #texts * i
		}
	end

	loadingStarted = true
	loadingLogoGetStart = now + 750
	loadingLogoGetInverse = false
	loadingTime = loadTime
	loadingStartTime = now
	logoMoveDifferenceX, logoMoveDifferenceY = 0, 0

	if isElement(loadingSound) then
		destroyElement(loadingSound)
	end
	if music == 1 then
		loadingSound = playSound("files/sounds/loading1.mp3")
	else
		loadingSound = playSound("files/sounds/loading2.mp3")
	end
	setSoundVolume(loadingSound,1)
	loadingBackground = math.random(1, 6)

	addEventHandler("onClientRender", getRootElement(), renderTheLoadingScreen, true, "low")
end

addCommandHandler("loadingtest",function()
 	showTheLoadScreen(math.floor(10000, 15000), {"Adatok betöltése...", "Szinkronizációk folyamatban...", "Belépés Las Venturasba..."})
end)

--local bgPng = dxCreateTexture("files/images/5.png")


local sX,sY = guiGetScreenSize()

function renderTheLoadingScreen()
	if loadingStarted then
		local now = getTickCount()
		local progress = (now - loadingStartTime) / loadingTime

		dxDrawImage(0, 0, screenX * (1 + progress / 4), screenY * (1 + progress / 4), "files/images/" .. loadingBackground .. ".png")
		--dxDrawImage(0, 0, sX,sY, bgPng, 0, 0, 0, tocolor(255, 255, 255))

		if loadingLogoGetStart then
			local progress = (now - loadingLogoGetStart) / 400

			if progress < 0 then
				progress = 0
			end

			if progress >= 1 then
				loadingLogoGetInverse = now + 3000
				loadingLogoGetStart = false
			end

			logoMoveDifferenceX, logoMoveDifferenceY = interpolateBetween(respc(27), respc(13), 0, 0, 0, 0, progress, "OutQuad")
		end

		if loadingLogoGetInverse then
			local progress = (now - loadingLogoGetInverse) / 400

			if progress < 0 then
				progress = 0
			end

			if progress >= 1 then
				loadingLogoGetStart = now + 750
				loadingLogoGetInverse = false
			end

			logoMoveDifferenceX, logoMoveDifferenceY = interpolateBetween(0, 0, 0, respc(27), respc(13), 0, progress, "OutQuad")
		end

		local logoSize = respc(128)
		local x = screenX / 2 - logoSize / 2
		local y = screenY / 2 - logoSize

		dxDrawImage(x, y, logoSize, logoSize, "files/images/logo1.png")
		--dxDrawImage(x + logoMoveDifferenceX, y + logoMoveDifferenceY, logoSize, logoSize, ":sm_accounts/files/logo1.png")
		--dxDrawImage(x - logoMoveDifferenceX, y + logoMoveDifferenceY, logoSize, logoSize, ":sm_accounts/files/logo3.png")

		if loadingTexts[currLoadingText] then
			if now > loadingTexts[currLoadingText][3] then
				if loadingTexts[currLoadingText + 1] then
					currLoadingText = currLoadingText + 1
				end
			end

			local timediff = loadingTexts[currLoadingText][3] - loadingTexts[currLoadingText][2]
			local progress = loadingTexts[currLoadingText][2] + timediff / 2
			local alpha = 255

			if now >= progress then
				alpha = interpolateBetween(255, 0, 0, 0, 0, 0, (now - progress) / timediff * 2, "Linear")
			else
				alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (now - loadingTexts[currLoadingText][2]) / timediff * 2, "Linear")
			end

			dxDrawText(loadingTexts[currLoadingText][1], 0, y + logoSize, screenX, y + respc(160), tocolor(200, 200, 200, alpha), 1, Roboto, "center", "center")
		end

		if progress >= 1 then
			loadingStarted = false

			if isElement(loadingSound) then
				destroyElement(loadingSound)
			end

			removeEventHandler("onClientRender", getRootElement(), renderTheLoadingScreen)
		end

		dxDrawText("Betöltés...", 0, 0, screenX - respc(32) - 2, screenY - respc(32) - 2, tocolor(200, 200, 200, 200), 0.8, Roboto, "right", "bottom")

		local progress = interpolateBetween(0, 0, 0, 100, 0, 0, progress, "Linear")

		dxDrawSeeBar(respc(32), screenY - respc(32), screenX - respc(64), 8, 0, tocolor(61, 122, 188), progress, false, tocolor(25, 25, 25))
	end
end


function isMouseInPosition(x,y,width,height)
	if (not isCursorShowing()) then
		return false
	end
	local sx,sy = guiGetScreenSize()
	local cx,cy = getCursorPosition()
	local cx,cy = (cx*sx),(cy*sy)	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

local root = getRootElement()
local localPlayer = getLocalPlayer()
local PI = math.pi

local isEnabled = false
local wasInVehicle = isPedInVehicle(localPlayer)

local mouseSensitivity = 0.1
local rotX, rotY = 0,0
local mouseFrameDelay = 0
local idleTime = 2500
local fadeBack = false
local fadeBackFrames = 50
local executeCounter = 0
local recentlyMoved = false
local Xdiff,Ydiff
local radar = true

function toggleCockpitView ()
	if (not isEnabled) then
		isEnabled = true
		addEventHandler ("onClientPreRender", root, updateCamera)
		addEventHandler ("onClientCursorMove",root, freecamMouse)
		showPlayerHudComponent("radar", false)
		radar = false
	else 
		isEnabled = false
		setCameraTarget (localPlayer, localPlayer)
		removeEventHandler ("onClientPreRender", root, updateCamera)
		removeEventHandler ("onClientCursorMove", root, freecamMouse)
		showPlayerHudComponent("radar", false)
		radar = true
	end
end

addCommandHandler("fp", toggleCockpitView)

function updateCamera ()
	if (isEnabled) then
	
		local nowTick = getTickCount()

		if wasInVehicle and recentlyMoved and not fadeBack and startTick and nowTick - startTick > idleTime then
			recentlyMoved = false
			fadeBack = true
			if rotX > 0 then
				Xdiff = rotX / fadeBackFrames
			elseif rotX < 0 then
				Xdiff = rotX / -fadeBackFrames
			end
			if rotY > 0 then
				Ydiff = rotY / fadeBackFrames
			elseif rotY < 0 then
				Ydiff = rotY / -fadeBackFrames
			end
		end
		
		if fadeBack then
		
			executeCounter = executeCounter + 1
		
			if rotX > 0 then
				rotX = rotX - Xdiff
			elseif rotX < 0 then
				rotX = rotX + Xdiff
			end
		
			if rotY > 0 then
				rotY = rotY - Ydiff
			elseif rotY < 0 then
				rotY = rotY + Ydiff
			end
		
			if executeCounter >= fadeBackFrames then
				fadeBack = false
				executeCounter = 0
			end
		
		end
		
		local camPosXr, camPosYr, camPosZr = getPedBonePosition (localPlayer, 6)
		local camPosXl, camPosYl, camPosZl = getPedBonePosition (localPlayer, 7)
		local camPosX, camPosY, camPosZ = (camPosXr + camPosXl) / 2, (camPosYr + camPosYl) / 2, (camPosZr + camPosZl) / 2
		local roll = 0
		
		inVehicle = isPedInVehicle(localPlayer)
		
		-- note the vehicle rotation
		if inVehicle then
			local rx,ry,rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
			
			roll = -ry
			if rx > 90 and rx < 270 then
				roll = ry - 180
			end
			
			if not wasInVehicle then
				rotX = rotX + math.rad(rz) 
				if rotY > -PI/15 then 
					rotY = -PI/15 
				end
			end
			
			cameraAngleX = rotX - math.rad(rz)
			cameraAngleY = rotY + math.rad(rx)
			
			if getControlState("vehicle_look_behind") or ( getControlState("vehicle_look_right") and getControlState("vehicle_look_left") ) then
				cameraAngleX = cameraAngleX + math.rad(180)
				--cameraAngleY = cameraAngleY + math.rad(180)
			elseif getControlState("vehicle_look_left") then
				cameraAngleX = cameraAngleX - math.rad(90)
				--roll = rx doesn't work out well
			elseif getControlState("vehicle_look_right") then
				cameraAngleX = cameraAngleX + math.rad(90)  
				--roll = -rx
			end
		else
			local rx, ry, rz = getElementRotation(localPlayer)
			
			if wasInVehicle then
				rotX = rotX - math.rad(rz) --prevent camera from rotating when exiting a vehicle
			end
			cameraAngleX = rotX
			cameraAngleY = rotY
		end
		
		wasInVehicle = inVehicle
		
		--Taken from the freecam resource made by eAi
		
		-- work out an angle in radians based on the number of pixels the cursor has moved (ever)
		
		local freeModeAngleZ = math.sin(cameraAngleY)
		local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
		local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)

		-- calculate a target based on the current position and an offset based on the angle
		local camTargetX = camPosX + freeModeAngleX * 100
		local camTargetY = camPosY + freeModeAngleY * 100
		local camTargetZ = camPosZ + freeModeAngleZ * 100

		-- Work out the distance between the target and the camera (should be 100 units)
		local camAngleX = camPosX - camTargetX
		local camAngleY = camPosY - camTargetY
		local camAngleZ = 0 -- we ignore this otherwise our vertical angle affects how fast you can strafe

		-- Calulcate the length of the vector
		local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

		-- Normalize the vector, ignoring the Z axis, as the camera is stuck to the XY plane (it can't roll)
		local camNormalizedAngleX = camAngleX / angleLength
		local camNormalizedAngleY = camAngleY / angleLength
		local camNormalizedAngleZ = 0

		-- We use this as our rotation vector
		local normalAngleX = 0
		local normalAngleY = 0
		local normalAngleZ = 1

		-- Perform a cross product with the rotation vector and the normalzied angle
		local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
		local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
		local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)

		-- Update the target based on the new camera position (again, otherwise the camera kind of sways as the target is out by a frame)
		camTargetX = camPosX + freeModeAngleX * 100
		camTargetY = camPosY + freeModeAngleY * 100
		camTargetZ = camPosZ + freeModeAngleZ * 100

		-- Set the new camera position and target
		setCameraMatrix (camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, roll)
	end
end

function freecamMouse (cX,cY,aX,aY)
	if isCursorShowing() or isMTAWindowActive() then
		mouseFrameDelay = 5
		return
	elseif mouseFrameDelay > 0 then
		mouseFrameDelay = mouseFrameDelay - 1
		return
	end
	
	startTick = getTickCount()
	recentlyMoved = true
	
	-- check if the mouse is moved while fading back, if so abort the fading
	if fadeBack then
		fadeBack = false
		executeCounter = 0
	end
	
	-- how far have we moved the mouse from the screen center?
	local width, height = guiGetScreenSize()
	aX = aX - width / 2 
	aY = aY - height / 2
	
	rotX = rotX + aX * mouseSensitivity * 0.01745
	rotY = rotY - aY * mouseSensitivity * 0.01745

	local pRotX, pRotY, pRotZ = getElementRotation (localPlayer)
	pRotZ = math.rad(pRotZ)
	
	if rotX > PI then
		rotX = rotX - 2 * PI
	elseif rotX < -PI then
		rotX = rotX + 2 * PI
	end
	
	if rotY > PI then
		rotY = rotY - 2 * PI
	elseif rotY < -PI then
		rotY = rotY + 2 * PI
	end
	-- limit the camera to stop it going too far up or down
	if isPedInVehicle(localPlayer) then
		if rotY < -PI / 4 then
			rotY = -PI / 4
		elseif rotY > -PI/15 then
			rotY = -PI/15
		end
	else
		if rotY < -PI / 4 then
			rotY = -PI / 4
		elseif rotY > PI / 2.1 then
			rotY = PI / 2.1
		end
	end
end