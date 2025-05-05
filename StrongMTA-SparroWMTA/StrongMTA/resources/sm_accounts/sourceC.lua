local screenSizeX, screenSizeY = guiGetScreenSize()
local screenSizeX2, screenSizeY2 = screenSizeX / 2, screenSizeY / 2
local musicMaxVolume = 0.5
local registerActive = false
local characterMakingActive = false

local buttons = {}
local activeButton = false
local rememberMe = false
local accessToken = false

local fakeInputValue = {}
local activeFakeInput = false
local repeatTimer = false
local repeatStartTimer = false
local canUseFakeInputs = false
local inputDisabled = false

local RobotoFont = dxCreateFont("files/Raleway.ttf", 17.5, false, "antialiased")
local RobotoLight = dxCreateFont("files/Raleway.ttf", 12, false, "antialiased")
local logoAnimStart = false

local loaderActive = false
local loaderAnimStart = false

local loginMusic = false

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		if not (getElementData(localPlayer, "loggedIn") or false) then
			fadeCamera(false)
			
			setElementInterior(localPlayer, 0)
			setCameraInterior(0)

			showChat(false)
		end

		triggerServerEvent("checkPlayerBanState", localPlayer, localPlayer)
	end --, true, "low-99999"
)

addEvent("checkPlayerBanState", true)
addEventHandler("checkPlayerBanState", getRootElement(),
	function (ban)
		if ban.state then
			fadeCamera(true)
			outputChatBox("fadeCamera")
		elseif (getElementData(localPlayer, "loggedIn") or false) then
			outputChatBox("killTimer")
			if isTimer(autoSaveTimer) then
				killTimer(autoSaveTimer)
			end
			
			if isTimer(minuteTimer) then
				killTimer(minuteTimer)
			end

			autoSaveTimer = setTimer(triggerServerEvent, 1800000, 0, "autoSavePlayer", localPlayer)
			minuteTimer = setTimer(processMinuteTimer, 60000, 0)
		else
			outputChatBox("showLogin")
			showLogin()
			setElementPosition(localPlayer, 0, 0, 1500)
			setElementFrozen(localPlayer, true)
			fadeCamera(true)
		end
	end
)

local availableSkins = {}
local skinsByType = {}

addEvent("checkForAnExistingAccount", true)
addEventHandler("checkForAnExistingAccount", localPlayer,
	function (hasAccount)
		if hasAccount then
			showInfo("e", "Már létezik account ehhez a géphez társítva")
			showInfo("e", "Várj 10 másodpercet az újrapróbálkozáshoz!")
			
			setTimer(setInputDisabled, 10000, 1, false)
		else
			startCharacterMaking()
		end
	end
)

function reMap(value, low1, high1, low2, high2)
	return (value - low1) * (high2 - low2) / (high1 - low1) + low2
end

local responsiveMultipler = reMap(screenSizeX, 1024, 1920, 0.75, 1)

function resp(x)
	return x * responsiveMultipler
end

local planePosition = {1469.3023681641, -1736.2127685547, 13.3828125}
local pedPlanePosition = {1479.6512451172, -1773.8591308594, 18.7421875}
local airportScene = {
	{3971, 1533.90002, -4683.7998, 3454.3999, 0, 0, 0},
	{3970, 1538.09998, -4694.8999, 3453, 0, 0, 0.25},
	{3969, 1526.59998, -4674.1001, 3452.80005, 0, 0, 0},
	{1572, 1549, -4687.7002, 3452.3999, 0, 0, 299.498},
	{1572, 1529.80005, -4687.2002, 3452.3999, 0, 0, 39.498},
	{1572, 1549.80005, -4677.7002, 3452.3999, 0, 0, 151.246},
	{1572, 1519.30005, -4681.8999, 3452.3999, 0, 0, 251.243},
	{2775, 1533, -4690.1001, 3456, 0, 0, 180.5},
	{2775, 1549.19995, -4690.2998, 3455.6001, 0, 0, 180.5},
	{8240, 1558, -4732.5, 3460.1001, 0, 0, 179.747},
	{2921, 1530.40002, -4690.7998, 3454.6001, 0, 0, 171},
	{2886, 1526.09998, -4694.7002, 3453.3999, 0, 0, 90},
	{2886, 1530.19995, -4695.2998, 3453.69995, 0, 0, 268},
	{2412, 1533.80005, -4695.1001, 3451.8999, 0, 0, 0},
	{2412, 1531.09998, -4695, 3451.8999, 0, 0, 0},
	{2412, 1545.80005, -4690.5, 3451.8999, 0, 0, 0},
	{2412, 1542.5, -4690.3999, 3451.8999, 0, 0, 0},
	{1533, 1544.30005, -4697.6001, 3451.80005, 0, 0, 179.75},
	{1533, 1545.80005, -4697.6001, 3451.80005, 0, 0, 179.747},
	{1892, 1537.80005, -4669, 3451.8999, 0, 0, 0},
	{1998, 1529.40002, -4694.3999, 3452.1001, 0, 0, 181.75},
	{1792, 1528.30005, -4690.6001, 3454, 14.249, 359.226, 20.19},
	{1792, 1530.69995, -4697.5, 3454.3999, 14.244, 359.225, 138.937},
	{4889, 1529.90002, -4692.5, 3447.19995, 0, 0, 0}
}
local realAirportScene = {}
local cutsceneAirPlane = false
local myPed = false

local passportPed = false
local passportColShape = false
local passportWidth = resp(481)
local passportHeight = resp(277)
local passportPosX = screenSizeX / 2 - passportWidth / 2
local passportPosY = screenSizeY / 2 - passportHeight / 2
local talkAnims = {"prtial_gngtlkA", "prtial_gngtlkB", "prtial_gngtlkC", "prtial_gngtlkD", "prtial_gngtlkE", "prtial_gngtlkF", "prtial_gngtlkG", "prtial_gngtlkH"}

local renderData = {}
renderData.fadeAlpha = 255
renderData.fade2Alpha = 0
renderData.fadeTextAlpha = 0
renderData.selectedGender = true
renderData.selectedGenderForDraw = "férfi"
renderData.currentSkin = 1
renderData.selectedSkin = false

addEvent("checkCharacterName", true)
addEventHandler("checkCharacterName", localPlayer,
	function (characterExists, characterName)
		if characterExists then
			showInfo("e", "Már van ilyen nevű karakter a szerveren!\nKérlek válassz másikat.")
		else
			fakeInputValue["characterName"] = characterName:gsub("_", " ")
			
			renderData.ageInputPreStart = getTickCount()
			renderData.ageInputStart = renderData.ageInputPreStart + 1000
		end

		inputDisabled = false
		activeFakeInput = false
		loaderActive = false
	end
)

addEvent("onPlayerCharacterMade", true)
addEventHandler("onPlayerCharacterMade", localPlayer,
	function (characters)
		if characters and type(characters) == "table" then
			showInfo("s", "Sikeres karakter létrehozás!")
			showCharacterSelector(characters)
		else
			showInfo("s", "Sikeres regisztráció! Mostmár bejelentkezhetsz.")

			registerActive = false
			inputDisabled = false
			canUseFakeInputs = true
		end

		loaderActive = false
	end
)

function startCharacterMaking(haveAccount)
	if not characterMakingActive then
		characterMakingActive = true

		local binco = getResourceFromName("sm_binco")

		if binco and getResourceState(binco) == "running" then
			local males = exports.sm_binco:getSkinsByType("Férfi")
			local females = exports.sm_binco:getSkinsByType("Női")

			availableSkins = {}

			for k, v in pairs(males) do
				table.insert(availableSkins, v[1])
			end

			for k, v in pairs(females) do
				table.insert(availableSkins, v[1])
			end

			skinsByType = {
				["férfi"] = males,
				["nő"] = females
			}
		end

		activeButton = false
		activeFakeInput = false
		inputDisabled = false
		canUseFakeInputs = true
		buttons = {}

		local dim = getElementDimension(localPlayer)

		passportPed = createPed(76, 1478.8426513672, -1822.1674804688, 14.667524337769, 0)
		setElementDimension(passportPed, dim)
		--1480.7109375, -1781.1949462891, 18.25 col
					--1480.8459472656, -1772.7822265625, 18.734375 ped
		passportColShape = createColSphere(1479.7465820312, -1781.3813476562, 18.7421875, 0.5)
		setElementDimension(passportColShape, dim)

		for k, v in ipairs(airportScene) do
			local obj = createObject(unpack(v))
			setElementDimension(obj, dim)
			table.insert(realAirportScene, obj)
		end

		local skinId = availableSkins[math.random(1, #availableSkins)]

		skinId = 1

		local ped = createPed(skinId, pedPlanePosition[1], pedPlanePosition[2], pedPlanePosition[3], 0)

		myPed = ped

		setElementDimension(ped, dim)

		renderData.selectedSkin = skinsByType["férfi"][renderData.currentSkin][1]
		setElementModel(myPed, renderData.selectedSkin)
		
		cutsceneAirPlane = createVehicle(431, planePosition[1], planePosition[2], planePosition[3])
		busPed = createPed(2, planePosition[1], planePosition[2], planePosition[3])
		setElementDimension(cutsceneAirPlane, dim)
		setElementDimension(busPed, dim)
		warpPedIntoVehicle(busPed, cutsceneAirPlane)
		--setElementFrozen(cutsceneAirPlane, true)
		setVehicleColor(cutsceneAirPlane, 255, 255, 255, 255, 255, 255)

		renderData.fade1Start = getTickCount() + 2000
		renderData.fade2Start = renderData.fade1Start + 1500
		renderData.fade3Start = renderData.fade2Start + 2500
		renderData.nameInputStart = renderData.fade3Start + 1000

		renderData.RobotoBold = dxCreateFont("files/Raleway.ttf", resp(55), false, "antialiased")
		renderData.Roboto = dxCreateFont("files/Raleway.ttf", resp(22), false, "antialiased")
		renderData.Lunabar = dxCreateFont("files/lunabar.ttf", resp(22), false, "antialiased")

		renderData.alreadyHaveAccount = haveAccount

		addEventHandler("onClientPreRender", getRootElement(), characterMakeRender)
		addEventHandler("onClientColShapeHit", passportColShape, showPassport)
	end
end

addCommandHandler("apad",
	function()
		showPassport(localPlayer)
	end
)

function showPassport(hitElement)
	if characterMakingActive then
		if renderData.airportSceneStart then
			setPedControlState(myPed, "forwards", false)
			setPedControlState(myPed, "walk", false)

			setTimer(
				function()
					setPedAnimation(myPed, "GANGS", talkAnims[math.random(#talkAnims)], -1, true, false, false)
					setPedAnimation(passportPed, "GANGS", talkAnims[math.random(#talkAnims)], -1, true, false, false)
				
					setTimer(
						function()
							setPedAnimation(myPed, "DEALER", "shop_pay", -1, false, true, false, true)
							setPedAnimation(passportPed)
					
							setTimer(
								function()
									renderData.showPassport = true
									renderData.giveWeight = true
								end,
							5000, 1)
						end,
					5000, 1)
				end,
			500, 1)
		end
	end
end

function characterMakeRender()
	local now = getTickCount()
	local alpha = 255

	if now >= renderData.fade1Start and now < renderData.fade2Start then
		renderData.fadeAlpha = interpolateBetween(255, 0, 0, 0, 0, 0, (now - renderData.fade1Start) / 1000, "Linear")
	end

	if now >= renderData.fade2Start and now < renderData.fade3Start then
		renderData.fadeAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, (now - renderData.fade2Start) / 1000, "Linear")
	end

	if now >= renderData.fade3Start and now < renderData.nameInputStart then
		renderData.fadeAlpha = interpolateBetween(255, 0, 0, 0, 0, 0, (now - renderData.fade3Start) / 1000, "Linear")
		alpha = renderData.fadeAlpha
	elseif now >= renderData.fade3Start then
		alpha = 0
	end

	if renderData.landingPreStart and now >= renderData.landingPreStart and now < renderData.landingStart then
		renderData.fade2Alpha, renderData.fadeTextAlpha, alpha = interpolateBetween(255, 255, 0, 0, 0, 255, (now - renderData.landingPreStart) / 1000, "Linear")
	end

	if renderData.finalFadeStart then
		if now >= renderData.finalFadeStart then
			local progress = (now - renderData.finalFadeStart) / 1000

			alpha, renderData.fade2Alpha, renderData.fadeTextAlpha = interpolateBetween(0, 255, 255, 255, 0, 0, progress, "Linear")

			if progress >= 1 then
				removeEventHandler("onClientPreRender", getRootElement(), characterMakeRender)

				destroyElement(myPed)
				destroyElement(passportPed)

				for k, v in pairs(realAirportScene) do
					if isElement(v) then
						destroyElement(v)
					end
				end

				destroyElement(renderData.RobotoBold)
				destroyElement(renderData.Roboto)

				characterMakingActive = false
				fakeInputValue["username"] = ""
				fakeInputValue["password"] = ""
				fakeInputValue["email"] = ""

				if renderData.alreadyHaveAccount then
					tryToCreateAccount()
				else
					registerActive = true
				end
			end
		end
	elseif renderData.landingStart then
		if now >= renderData.landingStart - 1000 then
			local progress = (now - (renderData.landingStart - 1000)) / 1000

			if progress >= 1 then
				for k, v in pairs(realAirportScene) do
					if isElement(v) and getElementType(v) == "ped" then
						destroyElement(v)
					end
				end

				setElementPosition(cutsceneAirPlane, 1469.3023681641, -1736.2127685547, 13.3828125)
				setElementDimension(cutsceneAirPlane, getElementDimension(localPlayer))
			end
		end

		if now >= renderData.landingStart then
			local elapsedTime = now - renderData.landingStart

			alpha, renderData.fade2Alpha, renderData.fadeTextAlpha = interpolateBetween(255, 0, 0, 0, 255, 255, elapsedTime / 1000, "Linear")

			elapsedTime = elapsedTime - 3500

			if elapsedTime >= 0 then
				renderData.fadeTextAlpha = interpolateBetween(255, 0, 0, 0, 0, 0, elapsedTime / 1000, "Linear")
			end

			local x, y, z = interpolateBetween(1469.3023681641, -1736.2127685547+1, 13.4828125, 1475.9735107422, -1736.3006591797+1, 13.4828125, elapsedTime / 5000, "OutQuad")
			local rx = interpolateBetween(10, 0, 0, 0, 0, 0, elapsedTime / 5000, "Linear")

			setCameraMatrix(1486.7728271484, -1738.2509765625, 15.252599716187, x, y, z)
			setElementPosition(cutsceneAirPlane, x, y, z)
			setElementRotation(cutsceneAirPlane, 0, 0, 270)

			elapsedTime = elapsedTime - 2500

			if elapsedTime >= 0 then
				local progress = elapsedTime / 10000

				alpha, renderData.fade2Alpha = interpolateBetween(0, 255, 0, 255, 0, 0, progress, "Linear")

				if progress >= 1 then
					renderData.landingPreStart = false
					renderData.landingStart = false
					renderData.airportSceneStart = now

					setElementPosition(myPed, 1478.5740966797, -1799.3692626953, 14.526899337769)
					setElementRotation(myPed, 0, 0, 180)
					setPedAnimation(myPed, false)
					setPedControlState(myPed, "walk", true)
					setPedControlState(myPed, "forwards", true)
				end
			end
		end
	elseif renderData.airportSceneStart then
		if now >= renderData.airportSceneStart then
			local elapsedTime = now - renderData.airportSceneStart

			alpha, renderData.fade2Alpha, renderData.fadeTextAlpha = interpolateBetween(255, 0, 0, 0, 255, 255, elapsedTime / 1000, "Linear")

			elapsedTime = elapsedTime - 3500

			if elapsedTime >= 0 then
				renderData.fadeTextAlpha = interpolateBetween(255, 0, 0, 0, 0, 0, elapsedTime / 1000, "Linear")
			end
			setCameraMatrix(1470.1013183594, -1774.1030273438, 20.043199539185, 1470.8677978516, -1774.6492919922, 19.705585479736)

			if renderData.showPassport then
			--[[	local skinId = getElementModel(myPed)

				dxDrawImage(passportPosX, passportPosY, passportWidth, passportHeight, "files/passport.png")
				--dxDrawRectangle(passportPosX, passportPosY, passportWidth, passportHeight,tocolor(25,25,25,2))

				if fileExists(":sm_binco/files/skins/" .. skinId .. ".png") then
					dxDrawImage(passportPosX + resp(20), passportPosY + resp(43), resp(121), resp(121), ":sm_binco/files/skins/" .. skinId .. ".png")
				end

				local nameParts = split(fakeInputValue["characterName"], " ")

				dxDrawText(nameParts[#nameParts], passportPosX + resp(265), passportPosY + resp(45), 0, passportPosY + resp(60), tocolor(30, 30, 30), 0.5, renderData.Roboto, "left", "center")
				dxDrawText(nameParts[1], passportPosX + resp(265), passportPosY + resp(65), 0, passportPosY + resp(80), tocolor(30, 30, 30), 0.5, renderData.Roboto, "left", "center")
				
				dxDrawText(fakeInputValue["characterAge"] .. " év", passportPosX + resp(265), passportPosY + resp(85), 0, passportPosY + resp(100), tocolor(30, 30, 30), 0.5, renderData.Roboto, "left", "center")
				
				dxDrawText(renderData.selectedGenderForDraw, passportPosX + resp(265), passportPosY + resp(105), 0, passportPosY + resp(120), tocolor(30, 30, 30), 0.5, renderData.Roboto, "left", "center")
					
				--drawFakeInputText2("characterWeight", "num-only|3", "%s kg", passportPosX + resp(265), passportPosY + resp(125), 0, resp(15), tocolor(30, 30, 30), 0.5, renderData.Roboto, "left", "center")
				
				--drawFakeInputText2("characterHeight", "num-only|3", "%s cm", passportPosX + resp(265), passportPosY + resp(145), 0, resp(15), tocolor(30, 30, 30), 0.5, renderData.Roboto, "left", "center")
				
				dxDrawText(fakeInputValue["characterName"], 0, passportPosY + resp(225), passportPosX + resp(470), passportPosY + resp(260), tocolor(0, 0, 0), 1, renderData.Lunabar, "right", "center")
				
				--drawFakeInputText2("visualDescription", "-|100", "%s", passportPosX + resp(20), passportPosY + resp(185), resp(260), 0, tocolor(0, 0, 0), 0.5, renderData.Roboto, "left", "top", false, true)]]
			end
		end
	end

	dxDrawRectangle(0, 0, screenSizeX, screenSizeY, tocolor(25, 25, 25, alpha))

	if now < renderData.fade2Start then
		dxDrawText("Regisztráció betöltése...", 0, 0, screenSizeX, screenSizeY, tocolor(255, 255, 255, renderData.fadeAlpha), 1, renderData.RobotoBold, "center", "center")
	elseif now >= renderData.fade2Start and now < renderData.nameInputStart then
		dxDrawText("Világ szinkronizálása...", 0, 0, screenSizeX, screenSizeY, tocolor(255, 255, 255, renderData.fadeAlpha), 1, renderData.RobotoBold, "center", "center")
	end

	if now >= renderData.fade2Start and not renderData.landingStart and not renderData.airportSceneStart then
		if not renderData.camX then
			renderData.camX, renderData.camY, renderData.camZ = 191.79400634766, -1738.7685546875, 5.6498999595642
		end
		
		setCameraMatrix(renderData.camX, renderData.camY, renderData.camZ, pedPlanePosition[1], pedPlanePosition[2], pedPlanePosition[3])
	end

	if now >= renderData.nameInputStart and not renderData.ageInputPreStart then
		renderData.fade2Alpha, renderData.fadeTextAlpha = interpolateBetween(0, 0, 0, 255, 255, 0, (now - renderData.nameInputStart) / 1000, "Linear")
	end

	if renderData.ageInputPreStart and now >= renderData.ageInputPreStart and now < renderData.ageInputStart then
		local progress = (now - renderData.ageInputPreStart) / 1000

		renderData.fadeTextAlpha = interpolateBetween(255, 0, 0, 0, 0, 0, progress, "Linear")
		renderData.camX, renderData.camY, renderData.camZ = interpolateBetween(191.79400634766, -1738.7685546875, 5.6498999595642, 191.79400634766, -1738.7685546875, 5.6498999595642, progress, "OutQuad")
	end

	if renderData.ageInputStart and now >= renderData.ageInputStart and not renderData.goalSelectPreStart then
		renderData.fadeTextAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, (now - renderData.ageInputStart) / 1000, "Linear")
	end

	if renderData.goalSelectPreStart and now >= renderData.goalSelectPreStart and now < renderData.goalSelectStart then
		renderData.fadeTextAlpha = interpolateBetween(255, 0, 0, 0, 0, 0, (now - renderData.goalSelectPreStart) / 1000, "Linear")
	end

	if renderData.goalSelectStart and now >= renderData.goalSelectStart and not renderData.skinSelectPreStart then
		local progress = (now - renderData.goalSelectStart) / 1000

		renderData.fadeTextAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, progress, "Linear")
		renderData.camX, renderData.camY, renderData.camZ = interpolateBetween(191.79400634766, -1738.7685546875, 5.6498999595642, 191.79400634766, -1738.7685546875, 5.6498999595642, progress, "OutQuad")
	end

	if renderData.skinSelectPreStart and now >= renderData.skinSelectPreStart and now < renderData.skinSelectStart then
		local progress = (now - renderData.skinSelectPreStart) / 1000

		renderData.fadeTextAlpha = interpolateBetween(255, 0, 0, 0, 0, 0, progress, "Linear")
		renderData.camX, renderData.camY, renderData.camZ = interpolateBetween(191.79400634766, -1738.7685546875, 5.6498999595642, 191.79400634766, -1738.7685546875, 5.6498999595642, progress, "OutQuad")
	end

	if renderData.skinSelectStart and now >= renderData.skinSelectStart and not renderData.landingPreStart and not renderData.airportSceneStart then
		renderData.fadeTextAlpha = interpolateBetween(0, 0, 0, 255, 0, 0, (now - renderData.skinSelectStart) / 1000, "Linear")
	end
	dxDrawRectangle(0, 0, screenSizeX, screenSizeY / 7, tocolor(25, 25, 25, 240 * renderData.fade2Alpha / 255))
	dxDrawRectangle(0, screenSizeY - screenSizeY / 7, screenSizeX, screenSizeY / 7, tocolor(25, 25, 25, 240 * renderData.fade2Alpha / 255))
	dxDrawImage(0, 0, screenSizeY / 7, screenSizeY / 7, exports.sm_core:getServerLogo(),0, 0, 0, tocolor(255, 255, 255, 240 * renderData.fade2Alpha / 255))
	local x, y, w, h = screenSizeY / 8, 0, screenSizeX, screenSizeY / 7
	if isElement(renderData.RobotoBold) then
		dxDrawText("#3d7abcStrong#ffffffMTA", x + 20, y + h / 2, x + 20, y + h / 2, tocolor(200, 200, 200, 240 * renderData.fade2Alpha / 255), 1, renderData.RobotoBold, "left", "center", false, false, false, true)
	end

	if renderData.airportSceneStart and now >= renderData.airportSceneStart then
		if not renderData.finalFadeStart then
			if not getPedControlState(myPed, "forwards") and not renderData.showPassport then
				dxDrawText("#598ed7"..fakeInputValue["characterName"]..":#ffffff Üdvözlöm hölgyem! Iratokat szeretnék csináltatni!", 0, screenSizeY - screenSizeY / 7, screenSizeX, screenSizeY, tocolor(200, 200, 200), 0.55, renderData.RobotoBold, "center", "center", false, false, false, true)
			end
		end

		if renderData.showPassport then
			if renderData.giveWeight then
				
				activeFakeInput = "characterWeight|num-only|3"
				--drawFakeInputText2("characterWeight", "num-only|3", "%s kg", 0, screenSizeY - screenSizeY / 7, screenSizeX, screenSizeY, tocolor(200, 200, 200), 0.55, renderData.RobotoBold, "center", "center", false, false, false, true)
				--drawFakeInputText2("characterWeight", "num-only|3", "%s kg", 0, screenSizeY - screenSizeY / 7, screenSizeX, screenSizeY, tocolor(200, 200, 200), 0.55, renderData.RobotoBold, "center", "center", false, false, false, true)
				--drawFakeInputText2("characterWeight", "num-only|3", "%s kg",0, passportPosY + resp(125), 0, resp(200), tocolor(30, 30, 30), 0.5, renderData.RobotoBold, "left", "center")
				drawFakeInputText2("characterWeight", "num-only|3", "Súly: %s kg", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, 200), 0.65, renderData.RobotoBold, "center", "top", false, false, false, true)
				--dxDrawText("Add meg a karaktered testsúlyát, majd nyomd meg az ENTERT.", 0, screenSizeY - screenSizeY / 7, screenSizeX, screenSizeY, tocolor(200, 200, 200), 0.55, renderData.RobotoBold, "center", "center", false, false, false, true)
			elseif renderData.giveHeight then
				activeFakeInput = "characterHeight|num-only|3"
				drawFakeInputText2("characterHeight", "num-only|3", "Magasság: %s cm", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, 200), 0.65, renderData.RobotoBold, "center", "top", false, false, false, true)
				--dxDrawText("Add meg a karaktered magasságát, majd nyomd meg az ENTERT.", 0, screenSizeY - screenSizeY / 7, screenSizeX, screenSizeY, tocolor(200, 200, 200), 0.55, renderData.RobotoBold, "center", "center", false, false, false, true)
			elseif renderData.giveVisualDescription then
				activeFakeInput = "visualDescription|-|25"
				
				drawFakeInputText2("visualDescription", "-|25", "Tulajdonságaid: %s", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, 200), 0.65, renderData.RobotoBold, "center", "top", false, false, false, true)
				--dxDrawText("Add meg a karaktered vizuális leírását, majd nyomd meg az ENTERT.", 0, screenSizeY - screenSizeY / 7, screenSizeX, screenSizeY, tocolor(200, 200, 200), 0.55, renderData.RobotoBold, "center", "center", false, false, false, true)
			end
		end
	elseif renderData.landingStart and now >= renderData.landingStart then
		dxDrawText("1 óra múlva...", 0, screenSizeY - screenSizeY / 7, screenSizeX - resp(20), screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.65, renderData.RobotoBold, "right", "center")
	elseif renderData.skinSelectStart and now >= renderData.skinSelectStart then
		dxDrawText("Skined: "..getElementModel(myPed), 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.65, renderData.RobotoBold, "center", "top", false, false, false, true)
		dxDrawText("\n\n\n(Válaszd ki a skinedet a jobbra-balra nyilakkal, majd nyomd meg az ENTERT)", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.6, renderData.Roboto, "center", "top", false, false, false, true)
	elseif renderData.goalSelectStart and now >= renderData.goalSelectStart then
		activeFakeInput = "characterGoal|-|55"
		drawFakeInputText2("characterGoal", "-|55", "... és azért jöttem ide, #BDBDBD%s#ffffff.", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.65, renderData.RobotoBold, "center", "top", false, false, false, true)
		dxDrawText("\n\n\n(Írd be a karaktered rövid célját, majd nyomd meg az ENTERT)", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.6, renderData.Roboto, "center", "top", false, false, false, true)
	elseif renderData.ageInputStart and now >= renderData.ageInputStart then
		if renderData.genderInput then
			dxDrawText("Nemed: #BDBDBD" .. renderData.selectedGenderForDraw, 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.65, renderData.RobotoBold, "center", "top", false, false, false, true)
			dxDrawText("\n\n\n(Válaszd ki a karaktered nemét a jobbra-balra nyilakkal, majd nyomd meg az ENTERT)", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.6, renderData.Roboto, "center", "top", false, false, false, true)
		else
			activeFakeInput = "characterAge|num-only|2"
			drawFakeInputText2("characterAge", "num-only|2", "Életkorod: #BDBDBD%s#ffffff", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.65, renderData.RobotoBold, "center", "top", false, false, false, true)
			dxDrawText("\n\n\n(Írd be a karaktered életkorát, majd nyomd meg az ENTERT)", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.6, renderData.Roboto, "center", "top", false, false, false, true)
		end
	elseif now > renderData.nameInputStart then
		activeFakeInput = "characterName|-|32"
		drawFakeInputText2("characterName", "-|32", "Neved: #BDBDBD%s#ffffff", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.65, renderData.RobotoBold, "center", "top", false, false, false, true)
		dxDrawText("\n\n\n(Írd be a karaktered nevét szóközzel elválasztva, majd nyomd meg az ENTERT)", 0, screenSizeY - screenSizeY / 7 + resp(20), screenSizeX, screenSizeY, tocolor(200, 200, 200, renderData.fadeTextAlpha), 0.6, renderData.Roboto, "center", "top", false, false, false, true)

	end
end

function getInputRealName(input)
	if input == "username" then
		return "username|-|32"
	elseif input == "password" then
		return "password|hash|32"
	elseif input == "email" then
		return "email|-|48"
	end
end

function showLogin()
	local txd = engineLoadTXD("files/at400.txd")
	if txd then
		engineImportTXD(txd, 577)

		local dff = engineLoadDFF("files/at400.dff")
		if dff then
			engineReplaceModel(dff, 577)
		end
	end

	if isElement(loginMusic) then
		destroyElement(loginMusic)
	end

	loginMusic = playSound("files/loginMusic.mp3", true)
	setSoundVolume(loginMusic,musicMaxVolume)

	addEventHandler("onClientRender", getRootElement(), loginRender)
	addEventHandler("onClientRender", getRootElement(), setSound)
	addEventHandler("onClientClick", getRootElement(), loginClickHandler)
	addEventHandler("onClientKey", getRootElement(), loginKeyHandler)
	addEventHandler("onClientCharacter", getRootElement(), processFakeInput)

	showCursor(true)

	canUseFakeInputs = true
	activeFakeInput = getInputRealName("username")

	loadLoginFiles()

	logoAnimStart = getTickCount()
end

function loginKeyHandler(key, press)
	local inputname = getActiveFakeInput()

	if inputname and key ~= "escape" then
		cancelEvent()
	end

	if press then
		if inputname and key == "backspace" then
			processFakeInput("backspace")
		end

		if key == "tab" and canUseFakeInputs and not inputDisabled then
			if activeFakeInput == getInputRealName("username") then
				activeFakeInput = getInputRealName("password")
			elseif activeFakeInput == getInputRealName("password") then
				if not registerActive then
					activeFakeInput = getInputRealName("username")
				else
					activeFakeInput = getInputRealName("email")
				end
			else
				activeFakeInput = getInputRealName("username")
			end
		end

		if characterMakingActive then
			local now = getTickCount()

			if key == "enter" then
				if renderData.airportSceneStart and now > renderData.airportSceneStart then
					if not inputDisabled and renderData.showPassport then
						if renderData.giveWeight then
							local weight = tonumber(fakeInputValue["characterWeight"] or "")

							if weight then
								if weight >= 40 and weight <= 180 then
									renderData.giveWeight = false
									renderData.giveHeight = true
								else
									showInfo("w", "A karaktered testsúlya nem megfelelő! (40-180kg)")
								end
							else
								showInfo("w", "Add meg a karaktered testsúlyát! (40-180kg)")
							end
						elseif renderData.giveHeight then
							local height = tonumber(fakeInputValue["characterHeight"] or "")

							if height then
								if height >= 120 and height <= 230 then
									renderData.giveHeight = false
									renderData.giveVisualDescription = true
								else
									showInfo("w", "A karaktered magassága nem megfelelő! (120-230cm)")
								end
							else
								showInfo("w", "Add meg a karaktered magasságát! (120-230cm)")
							end
						elseif renderData.giveVisualDescription then
							local description = fakeInputValue["visualDescription"] or ""

							if utfLen(description) >= 10 then
								renderData.giveVisualDescription = false
								renderData.showPassport = false
								renderData.finalFadeStart = now

								removeEventHandler("onClientColShapeHit", passportColShape, showPassport)

								destroyElement(renderData.Lunabar)
								destroyElement(cutsceneAirPlane)
								destroyElement(busPed)
								destroyElement(passportColShape)
							else
								showInfo("w", "Add meg a karaktered leírását! (minimum 10 karakter)")
							end
						end
					end
				elseif renderData.skinSelectStart and now > renderData.skinSelectStart and not renderData.landingStart then
					if not inputDisabled then
						renderData.landingPreStart = now
						renderData.landingStart = renderData.landingPreStart + 2000
					end
				elseif renderData.goalSelectStart and now > renderData.goalSelectStart and not renderData.skinSelectStart then
					if not inputDisabled then
						local characterGoal = fakeInputValue["characterGoal"] or ""

						if utfLen(characterGoal) >= 10 then
							renderData.skinSelectPreStart = now
							renderData.skinSelectStart = renderData.skinSelectPreStart + 1000
						else
							showInfo("w", "Add meg a karaktered célját! (minimum 10 karakter)")
						end
					end
				elseif renderData.ageInputStart and now > renderData.ageInputStart and not renderData.goalSelectStart then
					if not inputDisabled then
						if renderData.genderInput then
							characterGoal = "_____________________________________________________"
							renderData.skinSelectPreStart = now
							renderData.skinSelectStart = renderData.skinSelectPreStart + 1000
						else
							local selectedAge = tonumber(fakeInputValue["characterAge"] or "")

							if selectedAge then
								if selectedAge >= 12 and selectedAge <= 90 then
									renderData.genderInput = true
								else
									showInfo("w", "A karaktered kora nem megfelelő! (12-90)")
								end
							else
								showInfo("w", "A karaktered kora nem megfelelő! (12-90)")
							end
						end
					end
				elseif now > renderData.nameInputStart and not renderData.ageInputStart then
					if not inputDisabled then
						local characterName = fakeInputValue["characterName"] or ""
						local sections = split(characterName, " ")

						if #sections >= 2 and #sections <= 3 then
							if utf8.sub(characterName, utf8.len(characterName), utf8.len(characterName)) == " " then
								characterName = utf8.sub(characterName, 1, -2)
								fakeInputValue["characterName"] = characterName
							end

							triggerServerEvent("checkCharacterName", resourceRoot, characterName:gsub(" ", "_"))
							inputDisabled = true
						else
							showInfo("w", "A név nem megfelelő!")
						end
					end
				end
			elseif (key == "arrow_r" or key == "arrow_l") and renderData.genderInput and not renderData.goalSelectStart and not renderData.skinSelectStart  then
				renderData.selectedGender = not renderData.selectedGender

				if renderData.selectedGender then
					renderData.selectedGenderForDraw = "férfi"
				else
					renderData.selectedGenderForDraw = "nő"
				end

				renderData.currentSkin = 1
				renderData.selectedSkin = skinsByType[renderData.selectedGenderForDraw][renderData.currentSkin][1]

				setElementModel(myPed, renderData.selectedSkin)
			elseif (key == "arrow_r" or key == "arrow_l") and renderData.skinSelectStart and now > renderData.skinSelectStart and not renderData.landingStart and not renderData.airportSceneStart then
				if string.gsub(key, "arrow_", "") == "l" then
					renderData.currentSkin = renderData.currentSkin - 1
				else
					renderData.currentSkin = renderData.currentSkin + 1
				end
				
				if renderData.currentSkin < 1 then
					renderData.currentSkin = #skinsByType[renderData.selectedGenderForDraw]
				end
				
				if renderData.currentSkin > #skinsByType[renderData.selectedGenderForDraw] then
					renderData.currentSkin = 1
				end

				renderData.selectedSkin = skinsByType[renderData.selectedGenderForDraw][renderData.currentSkin][1]
				
				setElementModel(myPed, renderData.selectedSkin)
			end
		else
			if key == "enter" then
				if not registerActive then
					loginFunction()
				else
					registerFunction()
				end
			end
		end
	else
		if isTimer(repeatStartTimer) then
			killTimer(repeatStartTimer)
		end

		if isTimer(repeatTimer) then
			killTimer(repeatTimer)
		end
	end
end

function setInputDisabled(state)
	inputDisabled = state
end

function checkPassword(pw)
	if utf8.len(pw) >= 6 and utf8.len(pw) <= 32 then
		return utf8.find(pw, "%d") and utf8.find(pw, "%u") and utf8.find(pw, "%l")
	end

	return false
end

function tryToCreateAccount(username, password, email)
	local characterDetails = {
		fakeInputValue["characterName"]:gsub(" ", "_"),
		tonumber(fakeInputValue["characterAge"]),
		tonumber(fakeInputValue["characterWeight"]),
		tonumber(fakeInputValue["characterHeight"]),
		renderData.selectedGender and 0 or 1,
		fakeInputValue["visualDescription"],
		tonumber(renderData.selectedSkin)
	}

	if renderData.alreadyHaveAccount then
		triggerServerEvent("tryToCreateCharacter", resourceRoot, characterDetails)
	else
		triggerServerEvent("tryToCreateAccount", resourceRoot, username, password, email, characterDetails)
	end
end

function registerFunction()
	if not inputDisabled then
		local username = fakeInputValue["username"] or ""
		local password = fakeInputValue["password"] or ""
		local email = fakeInputValue["email"] or ""

		if utfLen(username) >= 3 and utfLen(username) <= 32 then
			if utfLen(password) >= 6 and utfLen(password) <= 32 then
				if checkPassword(password) then
					if utfLen(email) > 0 and utf8.find(email, "@") and utf8.find(email, ".") then
						loaderActive = true
						inputDisabled = true
						tryToCreateAccount(username, password, email)
						setTimer(setInputDisabled, 5000, 1, false)
					else
						showInfo("e", "Adj meg egy valós email címet!")
					end
				else
					showInfo("e", "A jelszó az alábbiakat kell, hogy tartalmazza:\nKis-és Nagybetű és legalább egy numerikus karakter (szám 0-9)")
				end
			else
				showInfo("e", "A jelszónak minimum 6, maximum 32 karakterből kell állnia!")
			end
		else
			showInfo("e", "A felhasználónevednek minimum 3, maximum 32 karakterből kell állnia!")
		end
	end
end

function loginFunction()
	if not inputDisabled then
		local username = fakeInputValue["username"] or ""
		local password = fakeInputValue["password"] or ""

		if utfLen(username) >= 3 and utfLen(username) <= 32 then
			if utfLen(password) >= 6 and utfLen(password) <= 32 then
				loaderActive = true

				if rememberMe and accessToken and utfLen(accessToken) > 0 then
					triggerServerEvent("onLoginRequestWithToken", resourceRoot, username, accessToken)
				else
					triggerServerEvent("onLoginRequest", resourceRoot, username, password, rememberMe)
				end

				setTimer(setInputDisabled, 10000, 1, false)
				inputDisabled = true
			else
				showInfo("e", "A jelszónak minimum 6, maximum 32 karakterből kell állnia!")
			end
		else
			showInfo("e", "A felhasználónévnek minimum 3, maximum 32 karakterből kell állnia!")
		end
	end
end

function loginClickHandler(button, state)
	if button == "left" then
		if activeButton then
			local buttonDetails = split(activeButton, ":")

			if state == "down" then
				activeFakeInput = false

				if buttonDetails[1] == "fakeInput" then
					if canUseFakeInputs and not inputDisabled then
						activeFakeInput = buttonDetails[2]
					end
				elseif activeButton == "login" then
					loginFunction()
				elseif activeButton == "register" then
					if not registerActive then
						if not inputDisabled then
							triggerServerEvent("checkForAnExistingAccount", resourceRoot)
							inputDisabled = true
						end
					else
						registerFunction()
					end
				elseif activeButton == "rememberMe" then
					rememberMe = not rememberMe
					playSound("files/bubble.mp3")
				end
			end
		else
			if state == "down" then
				activeFakeInput = false
			end
		end
	end
end

function renderStrongLogo()
	local now = getTickCount()
	local elapsedTime = now - logoAnimStart
	local x, y, s = 0, 0, 1

	elapsedTime = elapsedTime - 1000

	if elapsedTime > 0 then
		s = interpolateBetween(1, 0, 0, 0.85, 0, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 500

	if elapsedTime > 0 then
		s = interpolateBetween(0.85, 0, 0, 1, 0, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 500

	if elapsedTime > 0 then
		x, y = interpolateBetween(0, 0, 0, 50, 24, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 500

	if elapsedTime > 0 then
		s = interpolateBetween(1, 0, 0, 0.85, 0, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 500

	if elapsedTime > 0 then
		s = interpolateBetween(0.85, 0, 0, 1, 0, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 8000

	if elapsedTime > 0 then
		s = interpolateBetween(1, 0, 0, 0.85, 0, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 500

	if elapsedTime > 0 then
		s = interpolateBetween(0.85, 0, 0, 1, 0, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 500

	if elapsedTime > 0 then
		x, y = interpolateBetween(50, 24, 0, 0, 0, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 500

	if elapsedTime > 0 then
		s = interpolateBetween(1, 0, 0, 0.85, 0, 0, elapsedTime / 500, "OutQuad")
	end

	elapsedTime = elapsedTime - 500

	if elapsedTime > 0 then
		local progress = elapsedTime / 500

		s = interpolateBetween(0.85, 0, 0, 1, 0, 0, progress, "OutQuad")

		if progress >= 1 then
			logoAnimStart = now + 4000
		end
	end
	
	dxDrawImage(screenSizeX2 - 512 * s / 2, screenSizeY2 - 512 * s / 2 - 87 * (1 - s), 512 * s, 512 * s, "files/logo.png")
end

function renderLoader()
	if loaderActive then
		dxDrawRectangle(0, 0, screenSizeX, screenSizeY, tocolor(0, 0, 0, 200))

		local now = getTickCount()
		local angle = 0
		local angle2 = 0

		if not loaderAnimStart then
			loaderAnimStart = now
		end

		if now - loaderAnimStart > 0 then
			local elapsedTime = now - loaderAnimStart

			if elapsedTime > 0 then
				angle = interpolateBetween(0, 0, 0, 360, 0, 0, elapsedTime / 1000, "InOutQuad")
			end

			elapsedTime = elapsedTime - 1000

			if elapsedTime > 0 then
				local progress = elapsedTime / 1000

				angle2 = interpolateBetween(0, 0, 0, 360, 0, 0, progress, "InOutQuad")

				if progress >= 1 then
					loaderAnimStart = now + 250
				end
			end
		end

		local thickness = 12 * (angle - angle2) / 360

		for i = -90 + angle2, -90 + angle do
			local theta = math.rad(i)
			local x1 = math.cos(theta) * (100 - thickness)
			local y1 = math.sin(theta) * (100 - thickness)
			local x2 = math.cos(theta) * (100 + thickness)
			local y2 = math.sin(theta) * (100 + thickness)

			dxDrawLine(screenSizeX2 + x1, screenSizeY2 + y1, screenSizeX2 + x2, screenSizeY2 + y2, tocolor(124, 197, 118), thickness)
		end

		local alpha = 255 * (angle - angle2) / 360

		dxDrawText("Feldolgozás...", 0, 0, screenSizeX, screenSizeY, tocolor(255, 255, 255, alpha), 0.8, RobotoFont, "center", "center")
	end
end

function loginRender()
	buttons = {}

	if not characterMakingActive then
		setCameraMatrix(1965.7639160156, -1744.7449951172, 25.546875, 1941.5534667969, -1773.6271972656, 14.146897315979)
		dxDrawRectangle(0, 0, screenSizeX, screenSizeY, tocolor(10, 10, 10, 240))
		dxDrawRectangle(5, screenSizeY-respc(30)-5, screenSizeX-10, respc(30), tocolor(25, 25, 25))
		musicX, musicY = 5 + 4, screenSizeY-respc(30) - 5 + 4
		panelWidth = (screenSizeX - 18)
		local musicVolume = math.ceil(panelWidth/panelWidth * getSoundVolume(loginMusic) / musicMaxVolume * 100)
		volumeColor = tocolor(61, 122, 188, 170)
		dxDrawRectangle(musicX, musicY, panelWidth * getSoundVolume(loginMusic) / musicMaxVolume, respc(30) - 8, volumeColor)
		dxDrawText(math.ceil(panelWidth/panelWidth * getSoundVolume(loginMusic) / musicMaxVolume * 100) .. " %", musicX + panelWidth / 2, musicY + respc(15) / 2, musicX + panelWidth / 2, musicY + respc(15) / 2, tocolor(200, 200, 200, 200), 1, RobotoFont, "center", "center", false, false, false, true)

		
	end

	if characterMakingActive then
	elseif registerActive then
		local x, y = screenSizeX2 - 256, screenSizeY2 - 256

		-- ** Háttér
		--dxDrawImage(0, 0, screenSizeX, screenSizeY, "files/lights.png", 0, 0, 0, tocolor(124, 197, 118, 255 * math.abs(getTickCount() % 2000 - 1000) / 1000))
		renderStrongLogo()

		if activeButton == "register" then
			dxDrawImage(x, y, 512, 512, "files/register_main_active.png")
		else
			dxDrawImage(x, y, 512, 512, "files/register_main.png")
		end
		buttons["register"] = {x + 108, y + 467, 300, 34}

		-- ** Mezők
		if activeFakeInput == getInputRealName("username") then
			dxDrawImage(x, y, 512, 512, "files/register_user_active.png")
		end
		drawFakeInputText("username", "-|32", "Felhasználónév", x + 140, y + 298, 260, 34, tocolor(255, 255, 255), 0.6, RobotoFont, "left", "center")

		if activeFakeInput == getInputRealName("password") then
			dxDrawImage(x, y, 512, 512, "files/register_pw_active.png")
		end
		drawFakeInputText("password", "hash|32", "Jelszó", x + 140, y + 354, 260, 34, tocolor(255, 255, 255), 0.6, RobotoFont, "left", "center")

		if activeFakeInput == getInputRealName("email") then
			dxDrawImage(x, y, 512, 512, "files/register_email_active.png")
		end
		drawFakeInputText("email", "-|48", "Valós e-mail címed", x + 140, y + 410, 260, 34, tocolor(255, 255, 255), 0.6, RobotoFont, "left", "center")

	--	renderLoader()
	else
		local x, y = screenSizeX2 - 256, screenSizeY2 - 256

		-- ** Háttér
		--dxDrawImage(0, 0, screenSizeX, screenSizeY, "files/lights.png", 0, 0, 0, tocolor(124, 197, 118, 255 * math.abs(getTickCount() % 2000 - 1000) / 1000))
		dxDrawImage(x, y, 512, 512, "files/main.png")
		renderStrongLogo()

		-- ** Mezők
		if activeFakeInput == getInputRealName("username") then
			dxDrawImage(x, y, 512, 512, "files/user_active.png")
		end
		drawFakeInputText("username", "-|32", "Felhasználónév", x + 140, y + 308, 260, 34, tocolor(255, 255, 255), 0.6, RobotoFont, "left", "center")

		if activeFakeInput == getInputRealName("password") then
			dxDrawImage(x, y, 512, 512, "files/pw_active.png")
		end
		drawFakeInputText("password", "hash|32", "Jelszó", x + 140, y + 364, 260, 34, tocolor(255, 255, 255), 0.6, RobotoFont, "left", "center")

		-- ** Jegyezzen meg
		if rememberMe then
			dxDrawImage(x, y, 512, 512, "files/remember_on.png")
		end
		buttons["rememberMe"] = {x + 123, y + 416, 115, 22}

		-- ** Gombok
		if activeButton == "register" then
			dxDrawImage(x, y, 512, 512, "files/register_active.png")
		else
			dxDrawImage(x, y, 512, 512, "files/register_inactive.png")
		end
		buttons["register"] = {x + 108, y + 458, 137, 34}

		if activeButton == "login" then
			dxDrawImage(x, y, 512, 512, "files/login_active.png")
		else
			dxDrawImage(x, y, 512, 512, "files/login_inactive.png")
		end
		buttons["login"] = {x + 270, y + 458, 137, 34}

		--renderLoader()
	end

	activeButton = false

	if isCursorShowing() then
		local cursorX, cursorY = getCursorPosition()

		cursorX = cursorX * screenSizeX
		cursorY = cursorY * screenSizeY

		for k, v in pairs(buttons) do
			if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end
end

function subFakeInputText(inputname, repeatTheTimer)
	if utf8.len(fakeInputValue[inputname]) > 0 then
		fakeInputValue[inputname] = utf8.sub(fakeInputValue[inputname], 1, -2)

		if repeatTheTimer then
			repeatTimer = setTimer(subFakeInputText, 50, 1, inputname, repeatTheTimer)
		else
			playSound("files/backspace.mp3")
		end
	end
end

--[[addEventHandler("onClientPaste", getRootElement(),
	function (text)
		if activeFakeInput and canUseFakeInputs and not inputDisabled then
			local inputname, numonly, maxchar = getActiveFakeInput()

			if inputname then
				if numonly and tonumber(text) then
					
				else

				end
			end
		end
	end)--]]

function processFakeInput(key)
	if not canUseFakeInputs or inputDisabled then
		return
	end

	local inputname, numonly, maxchar = getActiveFakeInput()

	if inputname then
		if not fakeInputValue[inputname] then
			fakeInputValue[inputname] = ""
		end

		if key == "backspace" then
			subFakeInputText(inputname)

			if getKeyState(key) then
				repeatStartTimer = setTimer(subFakeInputText, 500, 1, inputname, true)
			end
		else
			if maxchar > utf8.len(fakeInputValue[inputname]) then
				if numonly then
					if tonumber(key) then
						fakeInputValue[inputname] = fakeInputValue[inputname] .. key
						playSound("files/key" .. math.random(2) .. ".mp3")
					end
				else
					if inputname == "username" or inputname == "password" or inputname == "email" then
						if string.find(key, "[a-zA-Z0-9.-_@]") or key == "-" or key == "*" then
							fakeInputValue[inputname] = fakeInputValue[inputname] .. key
							playSound("files/key" .. math.random(2) .. ".mp3")
						end
					elseif inputname == "characterName" then
						if string.find(string.lower(key), "[a-z]") or key == " " then
							local sections = {}

							fakeInputValue[inputname] = string.lower(fakeInputValue[inputname] .. key)

							for name in string.gmatch(fakeInputValue[inputname], "%S+") do
								name = utf8.gsub(name, "^%l", string.upper)

								if utfLen(name) >= 1 and #sections <= 2 then -- vezetéknév + keresztnevek (max 2)
									table.insert(sections, name)
								end
							end

							fakeInputValue[inputname] = table.concat(sections, " ")

							local namelength = utfLen(fakeInputValue[inputname])

							if key == " " and utfSub(fakeInputValue[inputname], namelength - 1, namelength) ~= " " and #sections <= 2 then
								fakeInputValue[inputname] = fakeInputValue[inputname] .. " "
							end

							playSound("files/key" .. math.random(2) .. ".mp3")
						end
					else
						fakeInputValue[inputname] = fakeInputValue[inputname] .. key
						playSound("files/key" .. math.random(2) .. ".mp3")
					end
				end
			end
		end
	end
end

function getActiveFakeInput()
	local inputname = false
	local numonly = false
	local maxchar = 0

	if activeFakeInput then
		local details = split(activeFakeInput, "|")

		maxchar = tonumber(details[3])

		if details[2] == "num-only" then
			numonly = true
		end

		inputname = details[1]
	end

	return inputname, numonly, maxchar
end

function drawFakeInputText2(inputname, details, placeholder, x, y, sx, sy, ...)
	if not fakeInputValue[inputname] then
		fakeInputValue[inputname] = ""
	end

	dxDrawText(placeholder:format(fakeInputValue[inputname]), x, y, x + sx, y + sy, ...)

	buttons["fakeInput:" .. inputname .. "|" .. details] = {x, y, sx, sy}
end

function drawFakeInputText(inputname, details, placeholder, x, y, sx, sy, color, scale, font, ...)
	if not fakeInputValue[inputname] then
		fakeInputValue[inputname] = ""
	end

	local activename = getActiveFakeInput()
	local hash = false
	local length = utf8.len(fakeInputValue[inputname])

	if string.find(details, "hash") then
		if length > 0 then
			hash = string.rep("•", length)
		end
	end

	local text = hash or fakeInputValue[inputname]

	if activename == inputname then
		local progress = math.abs(getTickCount() % 750 - 375) / 375
			
		if length == 0 then
			if placeholder then
				dxDrawText(placeholder, x + 5, y, x + sx - 10, y + sy, tocolor(150, 150, 150), getFitFontScale(placeholder, scale, font, sx), font, ...)
			end
		end

		if progress > 0.5 then
			dxDrawText(text .. "|", x + 5, y, x + sx - 10, y + sy, color, getFitFontScale(text, scale, font, sx), font, ...)
		else
			dxDrawText(text, x + 5, y, x + sx - 10, y + sy, color, getFitFontScale(text, scale, font, sx), font, ...)
		end
	else
		if length > 0 then
			dxDrawText(text, x + 5, y, x + sx - 10, y + sy, color, getFitFontScale(text, scale, font, sx), font, ...)
		else
			if placeholder then
				dxDrawText(placeholder, x + 5, y, x + sx - 10, y + sy, tocolor(150, 150, 150), getFitFontScale(placeholder, scale, font, sx), font, ...)
			end
		end
	end

	buttons["fakeInput:" .. inputname .. "|" .. details] = {x, y, sx, sy}
end

function getFitFontScale(text, scale, font, maxwidth)
	local scaleex = scale

	while true do
		if dxGetTextWidth(text, scaleex, font) > maxwidth then
			scaleex = scaleex - 0.01
		else
			break
		end
	end

	return scaleex
end

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

local infobox = {}
local holderSize = 26
local iconSize = 18

function showInfo(typ, text, hideLoader)
	exports.sm_hud:showInfobox(typ, text)
	--[[infobox.interpolateStart = getTickCount()
	infobox.theType = typ
	infobox.alpha = 0
	infobox.offset = -holderSize
	infobox.lineCount = 0
	infobox.lines = {}

	if typ == "e" then
		infobox.recColor = {r = 188, g = 64, b = 61}
	elseif typ == "i" then

	elseif typ == "s" then
		infobox.recColor = {r = 124, g = 197, b = 118}
	elseif typ == "w" then

	end

	playSound("files/infobox/" .. typ .. ".mp3")

	for k, v in pairs(split(text, "\n")) do
		infobox.lineCount = infobox.lineCount + 1
		infobox.lines[infobox.lineCount] = v
	end

	if hideLoader then
		loaderActive = false
		loaderAnimStart = false
	end]]
end
addEvent("showAccountInfo", true)
addEventHandler("showAccountInfo", localPlayer, showInfo)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if tonumber(infobox.interpolateStart) then
			local now = getTickCount()

			if now > infobox.interpolateStart then
				local elapsedTime = now - infobox.interpolateStart

				if elapsedTime > 0 then
					infobox.alpha, infobox.offset = interpolateBetween(0, -holderSize, 0, 1, holderSize * 2, 0, elapsedTime / 500, "Linear")
				end

				elapsedTime = elapsedTime - 10000

				if elapsedTime > 0 then
					local progress = elapsedTime / 500

					infobox.alpha, infobox.offset = interpolateBetween(1, holderSize * 2, 0, 0, -holderSize, 0, progress, "Linear")

					if progress > 1 then
						infobox.interpolateStart = false
					end
				end

				if infobox.lineCount > 0 then
					for i = 1, infobox.lineCount do
						local sx = dxGetTextWidth(infobox.lines[i], 0.8, RobotoLight) + holderSize + 50

						if sx < 500 then
							sx = 500
						end

						local x = screenSizeX / 2 - sx / 2
						local y = infobox.offset + (i - 1) * (holderSize + 5)

						dxDrawRectangle(x - 3, y - 3, sx + 6, holderSize + 6, tocolor(45, 45, 45, 180 * infobox.alpha))
						dxDrawRectangle(x, y, sx, holderSize, tocolor(infobox.recColor.r, infobox.recColor.g, infobox.recColor.b, 120 * infobox.alpha))

						--dxDrawRoundedRectangle(x, y, sx, holderSize, tocolor(0, 0, 0, 175 * infobox.alpha))
						dxDrawImage(math.floor(x + (holderSize - iconSize) / 2), math.floor(y + (holderSize - iconSize) / 2), iconSize, iconSize, "files/infobox/" .. infobox.theType .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255 * infobox.alpha))
						dxDrawText(infobox.lines[i], x, y, x + sx, y + holderSize, tocolor(255, 255, 255, 255 * infobox.alpha), 0.8, RobotoLight, "center", "center")
					end
				end
			end
		end
	end, true, "low-999999"
)

local roundtexture = dxCreateTexture("files/infobox/round.png", "argb", true, "clamp")

function dxDrawRoundedRectangle(x, y, sx, sy, color, postGUI, subPixelPositioning)
	dxDrawImage(x, y, 5, 5, roundtexture, 0, 0, 0, color, postGUI)
	dxDrawRectangle(x, y + 5, 5, sy - 5 * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x, y + sy - 5, 5, 5, roundtexture, 270, 0, 0, color, postGUI)
	dxDrawRectangle(x + 5, y, sx - 5 * 2, sy, color, postGUI, subPixelPositioning)
	dxDrawImage(x + sx - 5, y, 5, 5, roundtexture, 90, 0, 0, color, postGUI)
	dxDrawRectangle(x + sx - 5, y + 5, 5, sy - 5 * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x + sx - 5, y + sy - 5, 5, 5, roundtexture, 180, 0, 0, color, postGUI)
end

function saveLoginFiles(username, token, remember)
	if fileExists("@sm_loginremember.xml") then
		fileDelete("@sm_loginremember.xml")
	end
	
	local loginRememberFile = xmlCreateFile("@sm_loginremember.xml", "logindatas")
	
	xmlNodeSetValue(xmlCreateChild(loginRememberFile, "username"), username)
	xmlNodeSetValue(xmlCreateChild(loginRememberFile, "token"), token)
	xmlNodeSetValue(xmlCreateChild(loginRememberFile, "remember"), remember)
	
	xmlSaveFile(loginRememberFile)
	xmlUnloadFile(loginRememberFile)
end

function loadLoginFiles()
	local loginRememberFile = xmlLoadFile("@sm_loginremember.xml")
	
	if loginRememberFile then
		fakeInputValue["username"] = xmlNodeGetValue(xmlFindChild(loginRememberFile, "username", 0))
		accessToken = xmlNodeGetValue(xmlFindChild(loginRememberFile, "token", 0))
		fakeInputValue["password"] = accessToken
		
		local rememberValue = xmlNodeGetValue(xmlFindChild(loginRememberFile, "remember", 0))

		if tonumber(rememberValue) and tonumber(rememberValue) == 1 then
			rememberMe = true
		else
			rememberMe = false
		end
		
		xmlUnloadFile(loginRememberFile)
	end
end

local maxCharacterNum = 1

addEvent("onSuccessLogin", true)
addEventHandler("onSuccessLogin", getRootElement(),
	function (characters, characterCount, newToken, maxCharacter)
		if characters then
			local loadingTime = math.random(4000, 6000)

			if isElement(loginMusic) then
				destroyElement(loginMusic)
			end

			showInfo("s", "Sikeresen bejelentkeztél!")

			exports.sm_hud:showTheLoadScreen(loadingTime, {"StrongMTA betöltése...", "Adatok ellenőrzése...", "Karaktered betöltése..."}, 1)

			if newToken then
				saveLoginFiles(fakeInputValue["username"], newToken, 1)
			elseif not rememberMe then
				saveLoginFiles("", "", 0)
			end

			loaderActive = false
			fakeInputValue["username"] = ""
			fakeInputValue["password"] = ""
			maxCharacterNum = maxCharacter or 1

			if characterCount > 0 then
				setTimer(showCharacterSelector, loadingTime - 1000, 1, characters)
			else
				setTimer(startCharacterMaking, loadingTime - 1000, 1, true)
			end
		end
	end
)

local selectedCharacter = false
local characterPeds = {}
local pedData = {}

local charCameraPosition = {}
local charCameraInterpolation = {}
local charGotInterpolation = false
local charSelectInterpolation = false
local charGotSelected = false

local arrowTexture = false
local squareTexture = false
local pedMarkerSize = 0.75

local RobotoBold = false
local RobotoFontHeight = false

function showCharacterSelector(characters)
	showCursor(false)

	if isElement(loginMusic) then
		destroyElement(loginMusic)
	end

	removeEventHandler("onClientRender", getRootElement(), loginRender)
	removeEventHandler("onClientRender", getRootElement(), setSound)
	removeEventHandler("onClientClick", getRootElement(), loginClickHandler)
	removeEventHandler("onClientKey", getRootElement(), loginKeyHandler)
	removeEventHandler("onClientCharacter", getRootElement(), processFakeInput)

	characterMakingActive = false
	registerActive = false

	selectedCharacter = 1
	pedData = characters

	for k, v in pairs(characterPeds) do
		if isElement(characterPeds[k]) then
			destroyElement(characterPeds[k])
		end

		characterPeds[k] = nil
	end

	local dim = getElementDimension(localPlayer)

	for k, v in ipairs(characters) do

		characterPeds[k] = createPed(v.skin, 1477.1883544922 + (k - 1) * 1.5, -1717.6820068359+1, 14.046875, 180)

		if isElement(characterPeds[k]) then
			setElementDimension(characterPeds[k], dim)
		end
	end

	--setPedAnimation(characterPeds[1], "ON_LOOKERS", "wave_loop", -1, true, false, false)

	arrowTexture = dxCreateTexture("files/arrow.png")
	squareTexture = dxCreateTexture("files/square.png")
	RobotoBold = dxCreateFont("files/Raleway.ttf", 32, false, "antialiased")
	RobotoFontHeight = dxGetFontHeight(1, RobotoFont)

	addEventHandler("onClientRender", getRootElement(), characterSelectRender)

	charGotInterpolation = getTickCount()
end

function characterSelectKey(key, press)
	if press and key ~= "esc" then
		cancelEvent()

		if not charSelectInterpolation then
			if (key == "arrow_l" or key == "arrow_r") and #pedData > 1 then
				local num = selectedCharacter

				if key == "arrow_l" then
					num = num - 1
				else
					num = num + 1
				end

				if num > #pedData then
					num = 1
				elseif num < 1 then
					num = #pedData
				end

				charCameraInterpolation[1] = 2289.5 + (selectedCharacter - 1) * 1.5
				charCameraInterpolation[2] = 2289.5 + (num - 1) * 1.5

				--setPedAnimation(characterPeds[selectedCharacter])
				--setPedAnimation(characterPeds[num], "ON_LOOKERS", "wave_loop", -1, true, false, false)

				selectedCharacter = num
				charSelectInterpolation = getTickCount()
			elseif key == "enter" then
				if not charGotSelected and selectedCharacter then
					charGotSelected = true

					if pedData[selectedCharacter]["characterId"] then
						local loadingTime = math.random(10000, 15000)

						exports.sm_hud:showTheLoadScreen(loadingTime, {"Fiók adatok szinkronizálása...", "Járművek és modellek betöltése...", "Belépés StrongCity városába..."})

						removeEventHandler("onClientRender", getRootElement(), characterSelectRender)
						removeEventHandler("onClientKey", getRootElement(), characterSelectKey)

						--triggerServerEvent("onCharacterSelect", resourceRoot, pedData[selectedCharacter]["characterId"], pedData[selectedCharacter])

						setTimer(triggerServerEvent, loadingTime, 1, "onCharacterSelect", resourceRoot, pedData[selectedCharacter]["characterId"], pedData[selectedCharacter])

						for k, v in pairs(characterPeds) do
							if isElement(characterPeds[k]) then
								destroyElement(characterPeds[k])
							end

							characterPeds[k] = nil
						end

						if isElement(arrowTexture) then
							destroyElement(arrowTexture)
						end

						if isElement(squareTexture) then
							destroyElement(squareTexture)
						end

						if isElement(RobotoBold) then
							destroyElement(RobotoBold)
						end

						RobotoBold = nil
						squareTexture = nil
						arrowTexture = nil

						engineRestoreModel(577)
					else
						charGotSelected = false
					end
				end
			elseif key == "space" then
				if not charGotSelected and maxCharacterNum > #pedData then
					removeEventHandler("onClientRender", getRootElement(), characterSelectRender)
					removeEventHandler("onClientKey", getRootElement(), characterSelectKey)

					for k, v in pairs(characterPeds) do
						if isElement(characterPeds[k]) then
							destroyElement(characterPeds[k])
						end

						characterPeds[k] = nil
					end

					canUseFakeInputs = true
					inputDisabled = false

					showCursor(true)

					addEventHandler("onClientRender", getRootElement(), loginRender)
					addEventHandler("onClientClick", getRootElement(), loginClickHandler)
					addEventHandler("onClientKey", getRootElement(), loginKeyHandler)
					addEventHandler("onClientCharacter", getRootElement(), processFakeInput)

					startCharacterMaking(true)
				end
			end
		end
	end
end

function characterSelectRender()
	local now = getTickCount()

	if charSelectInterpolation then
		local progress = (now - charSelectInterpolation) / 500

		charCameraPosition[1] = interpolateBetween(charCameraInterpolation[1], 0, 0, charCameraInterpolation[2], 0, 0, progress, "OutQuad")

		if progress >= 1 then
			charSelectInterpolation = false
		end
	end

	if charGotInterpolation and now >= charGotInterpolation then
		local progress = (now - charGotInterpolation) / 2000
		local pedX, pedY, pedZ = getElementPosition(characterPeds[1])

		charCameraPosition[1], charCameraPosition[2], charCameraPosition[3] = interpolateBetween(2289.5, 2150, 15, 2289.5, 2150, pedZ, progress, "OutQuad")
		charCameraPosition[4], charCameraPosition[5], charCameraPosition[6] = interpolateBetween(2289.5, 2150, 15, pedX, pedY, pedZ, progress, "OutQuad")

		if progress >= 1 then
			charGotInterpolation = false
			addEventHandler("onClientKey", getRootElement(), characterSelectKey)
		end
	end

	setCameraMatrix(1477.1906738281, -1720.4523925781, 15.470000267029, 1477.1898193359, -1719.4937744141, 15.18516254425)

	local x, y, z = getPedBonePosition(characterPeds[selectedCharacter], 6)

	if x and y and z then
		local z2 = math.sin(now * 0.0025) * 0.05

		z = z - 0.25

		dxDrawMaterialLine3D(x, y + pedMarkerSize / 8, z + pedMarkerSize - z2, x, y, z + pedMarkerSize / 1.75 - z2, arrowTexture, pedMarkerSize / 4, tocolor(61, 122, 188), x, y, z)
		dxDrawMaterialLine3D(x, y - pedMarkerSize / 8, z + pedMarkerSize - z2, x, y, z + pedMarkerSize / 1.75 - z2, arrowTexture, pedMarkerSize / 4, tocolor(61, 122, 188), x, y, z)

		dxDrawMaterialLine3D(x + pedMarkerSize / 8, y, z + pedMarkerSize - z2, x, y, z + pedMarkerSize / 1.75 - z2, arrowTexture, pedMarkerSize / 4, tocolor(61, 122, 188), x, y, z)
		dxDrawMaterialLine3D(x - pedMarkerSize / 8, y, z + pedMarkerSize - z2, x, y, z + pedMarkerSize / 1.75 - z2, arrowTexture, pedMarkerSize / 4, tocolor(61, 122, 188), x, y, z)

		dxDrawMaterialLine3D(x + pedMarkerSize / 8, y, z + pedMarkerSize * 0.995 - z2, x - pedMarkerSize / 8, y, z + pedMarkerSize * 0.995 - z2, squareTexture, pedMarkerSize / 4, tocolor(61, 122, 188), x, y, z)
	end

	local charName = string.gsub(pedData[selectedCharacter]["name"], "_", " ")
	local nameWidth = dxGetTextWidth(charName, 1, RobotoBold)

	dxDrawText(charName, 0, 0, screenSizeX, screenSizeY - 120, tocolor(255, 255, 255), 1, RobotoBold, "center", "bottom")
	dxDrawRectangle(screenSizeX / 2 - nameWidth / 2, screenSizeY - 120, nameWidth, 2, tocolor(255, 255, 255))

	if #pedData > 1 then
		dxDrawText("Nyomj ENTER-t a kiválasztáshoz.", 0, 0, screenSizeX, screenSizeY - 80, tocolor(255, 255, 255), 1, RobotoFont, "center", "bottom")

		local y = screenSizeY - 80 + RobotoFontHeight

		if maxCharacterNum > #pedData then
			dxDrawText("Nyomj SPACE-t egy új karakter létrehozásához.", 0, 0, screenSizeX, y, tocolor(255, 255, 255), 1, RobotoFont, "center", "bottom")
			y = y + RobotoFontHeight
		end

		dxDrawText("Használd a nyilakat a karakterválasztáshoz.", 0, 0, screenSizeX, y, tocolor(255, 255, 255), 1, RobotoFont, "center", "bottom")
	else
		dxDrawText("Nyomj ENTER-t a kiválasztáshoz.", 0, 0, screenSizeX, screenSizeY - 80, tocolor(255, 255, 255), 1, RobotoFont, "center", "bottom")

		if maxCharacterNum > #pedData then
			dxDrawText("Nyomj SPACE-t egy új karakter létrehozásához.", 0, 0, screenSizeX, screenSizeY - 80 + RobotoFontHeight, tocolor(255, 255, 255), 1, RobotoFont, "center", "bottom")
		end
	end
end

local spawnCameraPosition = {}
local spawnCameraStart = false
local spawnCameraState = 0

function renderTheSpawnCamera()
	local now = getTickCount()
	local depth, fov = 350, 85
	local elapsedTime = now - spawnCameraStart

	if elapsedTime >= 0 then
		local progress = elapsedTime / 2500

		depth, fov = interpolateBetween(350, 85, 0, 200, 80, 0, progress, "InQuad")

		if progress >= 1 and spawnCameraState == 0 then
			spawnCameraState = spawnCameraState + 1
			playSound("files/bong.mp3")
		end
	end

	elapsedTime = elapsedTime - 3500

	if elapsedTime >= 0 then
		local progress = elapsedTime / 2500

		depth, fov = interpolateBetween(200, 80, 0, 50, 75, 0, progress, "InQuad")

		if progress >= 1 and spawnCameraState == 1 then
			spawnCameraState = spawnCameraState + 1
			playSound("files/bong.mp3")
		end
	end

	elapsedTime = elapsedTime - 3500

	if elapsedTime >= 0 then
		local progress = elapsedTime / 2500

		depth, fov = interpolateBetween(50, 75, 0, 4.5, 70, 0, progress, "InQuad")

		if progress >= 1 and spawnCameraState == 2 then
			spawnCameraState = 3
		end
	end

	if spawnCameraState == 3 then
		setCameraTarget(localPlayer)
		toggleAllControls(true)
		setElementFrozen(localPlayer, false)
		removeEventHandler("onClientPreRender", getRootElement(), renderTheSpawnCamera)
	else
		setCameraMatrix(spawnCameraPosition[1], spawnCameraPosition[2], spawnCameraPosition[3] + depth, spawnCameraPosition[1], spawnCameraPosition[2], spawnCameraPosition[3], 0, fov)
	end
end

local autoSaveTimer = false
local minuteTimer = false

addEvent("onClientLoggedIn", true)
addEventHandler("onClientLoggedIn", localPlayer,
	function (spawnX, spawnY, spawnZ)
		if getElementInterior(localPlayer) < 1 and getElementDimension(localPlayer) < 1 then
			toggleAllControls(false)
			
			spawnCameraPosition = {spawnX, spawnY, spawnZ}
			spawnCameraStart = getTickCount() + 1000
			spawnCameraState = 0
			playSound("files/bong.mp3")

			addEventHandler("onClientPreRender", getRootElement(), renderTheSpawnCamera)
		end

		if isTimer(autoSaveTimer) then
			killTimer(autoSaveTimer)
		end
		
		if isTimer(minuteTimer) then
			killTimer(minuteTimer)
		end

		autoSaveTimer = setTimer(triggerServerEvent, 1800000, 0, "autoSavePlayer", localPlayer)
		minuteTimer = setTimer(processMinuteTimer, 60000, 0)
	end
)

local hungerWarningNoti = false
local hungerWarningNoti2 = false
local thirstWarningNoti = false
local thirstWarningNoti2 = false

setTimer(
	function ()
		if (getElementData(localPlayer, "acc.adminJail") or 0) ~= 0 then
			return
		end
	
		if (getElementData(localPlayer, "adminDuty") or 0) ~= 1 then
			return
		end

		if getElementData(localPlayer, "isPlayerDeath") then
			return
		end

		if getElementHealth(localPlayer) > 20 then
			local bulletDamages = getElementData(localPlayer, "bulletDamages") or {}
			local bloodLevel = getElementData(localPlayer, "bloodLevel") or 100
			local bloodLoss = 0

			for data, amount in pairs(bulletDamages) do
				local typ = gettok(data, 1, ";")

				if typ == "stitch-cut" then
				elseif typ == "stitch-hole" then
				elseif typ == "punch" then
				elseif typ == "hole" then
					bloodLoss = bloodLoss + math.random(7, 20) / 10
				elseif typ == "cut" then
					bloodLoss = bloodLoss + math.random(7, 20) / 10
				else
					local weapon = tonumber(typ)

					if weapon >= 25 and weapon <= 27 then
						bloodLoss = bloodLoss + math.random(7, 20) / 10
					else
						bloodLoss = bloodLoss + math.random(7, 20) / 10
					end
				end
			end

			if getElementData(localPlayer, "usingBandage") then
				bloodLoss = bloodLoss * 0.6
			end

			if bloodLoss > 0 then
				bloodLevel = bloodLevel - bloodLoss

				if bloodLevel <= 0 then
					--triggerServerEvent("customKillMessage", localPlayer, "elvérzett")
					setElementData(localPlayer, "customDeath", "elvérzett")
					setElementHealth(localPlayer, 0)
					bloodLevel = 0
				end

				setElementData(localPlayer, "bloodLevel", bloodLevel)
			elseif bloodLevel < 100 then
				setElementData(localPlayer, "bloodLevel", 100)
				setElementData(localPlayer, "usingBandage", false)
			end
		end
	end,
10000, 0)

function processMinuteTimer()
	if (getElementData(localPlayer, "acc.adminJail") or 0) >= 1 then
		return
	end

	local lastRespawn = getElementData(localPlayer, "lastRespawn") or 0

	if lastRespawn > 0 then
		setElementData(localPlayer, "lastRespawn", lastRespawn - 1)
	end

	local adminDuty = getElementData(localPlayer, "adminDuty") or 0

	if adminDuty == 0 then
		-- ** Éhség
		local drugHunger = getElementData(localPlayer, "drugHunger")
		local currentHunger = getElementData(localPlayer, "char.Hunger") or 100
		local hungerLoss = math.random(10, 20) / 100

		if drugHunger then
			drugHunger[1] = drugHunger - 1

			if drugHunger[1] <= 0 then
				drugHunger = false
			end

			setElementData(localPlayer, "drugHunger", drugHunger)
		end

		if drugHunger then
			hungerLoss = hungerLoss * drugHunger[2]
		end

		if currentHunger - hungerLoss >= 0 then
			currentHunger = currentHunger - hungerLoss
			setElementData(localPlayer, "char.Hunger", currentHunger)
		else
			currentHunger = 0
			setElementData(localPlayer, "char.Hunger", 0)
		end
		
		if not hungerWarningNoti then
			if currentHunger < 40 then
				hungerWarningNoti = true
				outputChatBox("#3d7abc[StrongMTA]:#ffffff Kezdesz éhes lenni, menj és #3d7abcegyél #ffffffvalamit.", 255, 255, 255, true)
				exports.sm_hud:showInfobox("w", "Éhségszinted alacsony, részletek a chatboxban.")
			end
		elseif currentHunger >= 40 then
			hungerWarningNoti = false
		end
		
		if not hungerWarningNoti2 then
			if currentHunger <= 20 then
				hungerWarningNoti2 = true
				outputChatBox("#3d7abc[StrongMTA]:#ffffff Olyan #3d7abcéhes vagy, #ffffffhogy ez már hatással van az egészségedre is. Menj és #3d7abcegyél #ffffffvalamit.", 255, 255, 255, true)
				exports.sm_hud:showInfobox("w", "Éhségszinted túl alacsony, részletek a chatboxban.")
			end
		elseif currentHunger > 20 then
			hungerWarningNoti2 = false
		end
		
		-- ** Szomjúság
		local currentThirst = getElementData(localPlayer, "char.Thirst") or 100
		local thirstLoss = math.random(20, 30) / 100

		if drugHunger then
			thirstLoss = thirstLoss * drugHunger[2]
		end
		
		if currentThirst - thirstLoss >= 0 then
			currentThirst = currentThirst - thirstLoss
			setElementData(localPlayer, "char.Thirst", currentThirst)
		else
			currentThirst = 0
			setElementData(localPlayer, "char.Thirst", 0)
		end
		
		if not thirstWarningNoti then
			if currentThirst < 40 then
				thirstWarningNoti = true
				outputChatBox("#3d7abc[StrongMTA]:#ffffff Kezdesz szomjas lenni, menj és #3d7abcigyál #ffffffvalamit.", 255, 255, 255, true)
				exports.sm_hud:showInfobox("w", "Szomjúságszinted alacsony, részletek a chatboxban.")
			end
		elseif currentThirst >= 40 then
			thirstWarningNoti = false
		end
		
		if not thirstWarningNoti2 then
			if currentThirst <= 20 then
				thirstWarningNoti2 = true
				outputChatBox("#3d7abc[StrongMTA]:#ffffff Olyan #3d7abcszomjas vagy, #ffffffhogy ez már hatással van az egészségedre is. Menj és #3d7abcigyál #ffffffvalamit.", 255, 255, 255, true)
				exports.sm_hud:showInfobox("w", "Szomjúságszinted túl alacsony, részletek a chatboxban.")
			end
		elseif currentThirst > 20 then
			thirstWarningNoti2 = false
		end
		
		-- ** Életerő csökkentése
		if currentHunger <= 20 then
			if getElementHealth(localPlayer) - 3 >= 0 then
				setElementData(localPlayer, "customDeath", "éhenhalt")
				setElementHealth(localPlayer, 0)
			else
				setElementHealth(localPlayer, getElementHealth(localPlayer) - 3)
			end
		end

		if currentThirst <= 20 then
			if getElementHealth(localPlayer) - 5 >= 0 then
				setElementData(localPlayer, "customDeath", "szomjanhalt")
				setElementHealth(localPlayer, 0)
			else
				setElementHealth(localPlayer, getElementHealth(localPlayer) - 5)
			end
		end
	end
	
	local playedMinutes = getElementData(localPlayer, "char.playedMinutes") or 0

	if playedMinutes then
		setElementData(localPlayer, "char.playedMinutes", playedMinutes + 1)
	end
	
	local paintOnPlayerTime = getElementData(localPlayer, "paintOnPlayerTime") or 0

	if paintOnPlayerTime > 0 then
		if playedMinutes + 1 - paintOnPlayerTime > 180 then
			setElementData(localPlayer, "paintVisibleOnPlayer", false)
		else
			setElementData(localPlayer, "paintVisibleOnPlayer", true)
		end
	end
end

function setSound()
    if isCursorHover(musicX, musicY, panelWidth - 8, respc(30) - 8) and getKeyState("mouse1") then  

		local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = screenSizeX * cursorX, screenSizeY * cursorY

        local maxX = ((musicX) + (panelWidth - 8))
        local percent = (maxX - cursorX)/(panelWidth - 8)

        setSoundVolume(loginMusic, musicMaxVolume * (1 - percent))
    end
end

function isCursorHover(x, y, w, h)
    if not isCursorShowing() then return false end
    local cX, cY = getCursorPosition();
    cX, cY = cX * screenSizeX, cY * screenSizeY
    return (x <= cX and x + w >= cX and y < cY and y + h >= cY) 
end

addEvent("startPayDayRender", true)
addEventHandler("startPayDayRender", getRootElement(),
	function(data)
		startTick = getTickCount()
		
		allMoney = (data.payment + data.interest) - (data.interiorTax + data.vehicleTax + data.paymentTax)
		
		payDayDatas = {
			"Bruttó bér: "..data.payment,
			"Jövedelemadó: "..data.paymentTax,
			"Jármű adó: "..data.vehicleTax,
			"Ingatlan adó: "..data.interiorTax,
			"Kamat: "..data.interest,
			"Összesen: ".. allMoney
		}
		
		addEventHandler("onClientRender", getRootElement(), renderPayDay)
		addEventHandler("onClientClick", getRootElement(), clickPayDay)

		alphaKey = 0

		recSize = 0
		
	end
)

function clickPayDay(key, state)
	if key == "left" and state == "down" then
		if renderDataDraw.activeButton == "closePayDay" then
			removeEventHandler("onClientRender", getRootElement(), renderPayDay)
			removeEventHandler("onClientClick", getRootElement(), clickPayDay)
			payDayDatas = nil
			allMoney = nil
		end
	end
end



function renderPayDay()
	local cx, cy = getCursorPosition()
	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenSizeX
		cy = cy * screenSizeY

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

	renderDataDraw.buttons = {}
	
	local sizeX, sizeY = respc(300), respc(210) + 24 + respc(30) + 5
	
	local progress = (getTickCount() - startTick) / ((startTick + 2000) - startTick)
	local polateSizeX, polateSizeY = interpolateBetween(0, 0, 0, sizeX, sizeY, 0, progress, "OutQuad")
	
	if progress >= 1 and progress <= 1.05 then
		startTick2 = getTickCount()
	end
	
	dxDrawRectangle(screenSizeX / 2 - sizeX / 2, screenSizeY / 2 - sizeY / 2, polateSizeX, polateSizeY, tocolor(25, 25, 25, 245))
	dxDrawRectangle(screenSizeX / 2 - sizeX / 2 + 3, screenSizeY / 2 - sizeY / 2 + 3, polateSizeX - 6, respc(30), tocolor(35, 35, 35))
	if polateSizeX >= sizeX then
		local progress2 = (getTickCount() - startTick2) / ((startTick2 + 1000) - startTick2)
		local recSize = interpolateBetween(0, 0, 0, 200, 0, 0, progress2, "OutQuad")

		if progress2 >= 1 and progress2 <= 1.05 then
			startTick3 = getTickCount()
		end
		
		if recSize == 200 then
			local progress3 = (getTickCount() - startTick3) / ((startTick3 + 1000) - startTick3)
			alphaKey = interpolateBetween(0, 0, 0, 200, 0, 0, progress3, "OutQuad")
			dxDrawText("#3d7abcStrong#ffffffMTA - Fizetés", screenSizeX / 2 - sizeX / 2 + 3 + respc(10), screenSizeY / 2 - sizeY / 2 + 3 + respc(15), nil, nil, tocolor(200, 200, 200, alphaKey), 0.9, RobotoFont, "left", "center", false, false, false, true)
		end
		
		for k, v in ipairs(payDayDatas) do
			dxDrawRectangle(screenSizeX / 2 - sizeX / 2 + 3, (screenSizeY / 2 - sizeY / 2 + 3) + k * (respc(30) + 3), (sizeX - 6) / 200 * recSize, respc(30), tocolor(45, 45, 45, recSize))
			if recSize == 200 then
				dxDrawText(v.." $", screenSizeX / 2 - sizeX / 2 + 3 + respc(10), (screenSizeY / 2 - sizeY / 2 + 3) + k * (respc(30) + 3) + respc(15), nil, nil, tocolor(200, 200, 200, alphaKey), 0.8, RobotoFont, "left", "center", false, false, false, true)
			end
		end
		drawButton("closePayDay", "Bezárás", screenSizeX / 2 - sizeX / 2 + 4, ((screenSizeY / 2 - sizeY / 2 + 3) + 7 * (respc(30) + 3)), (sizeX - 8) / 200 * recSize, respc(30), {188, 64, 61}, false)
	end
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
	dxDrawText(label, x, y, x + w, y + h, tocolor(200, 200, 200, alphaKey or 0), labelScale, RobotoFont, "center", "center", false, false, postGui, true)

	renderDataDraw.buttons[key] = {x, y, w, h}
end

function dxDrawInnerBorder(thickness, x, y, w, h, color, postGUI)
	thickness = thickness or 2
	dxDrawLine(x, y, x + w, y, color, thickness, postGUI)
	dxDrawLine(x, y + h, x + w, y + h, color, thickness, postGUI)
	dxDrawLine(x, y, x, y + h, color, thickness, postGUI)
	dxDrawLine(x + w, y, x + w, y + h, color, thickness, postGUI)
end