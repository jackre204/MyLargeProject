local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local panelState = false

local titleHeight = respc(40)

local panelWidth = respc(350)
local panelHeight = respc(500) + titleHeight

local panelPosX = (screenX / 2) - (panelWidth / 2)
local panelPosY = (screenY / 2) - (panelHeight / 2)

local panelFont = false
local activeButton = false

local visibleItem = 0

local panelIsMoving = false
local moveDifferenceX = 0
local moveDifferenceY = 0

local availableAnimations = {
	-- név, anim block, anim name, kategória, loop
	{"Beszélgetés 1", "GANGS", "prtial_gngtlkA", "Beszéd", true},
	{"Beszélgetés 2", "GANGS", "prtial_gngtlkB", "Beszéd", true},
	{"Beszélgetés 3", "GANGS", "prtial_gngtlkC", "Beszéd", true},
	{"Beszélgetés 4", "GANGS", "prtial_gngtlkD", "Beszéd", true},
	{"Beszélgetés 5", "GANGS", "prtial_gngtlkE", "Beszéd", true},
	{"Beszélgetés 6", "GANGS", "prtial_gngtlkF", "Beszéd", true},
	{"Beszélgetés 7", "GANGS", "prtial_gngtlkG", "Beszéd", true},
	{"Beszélgetés 8", "GANGS", "prtial_gngtlkH", "Beszéd", true},
	{"Beállás ütésre", "BASEBALL", "Bat_IDLE", "Verekedés", true},
	{"Beállás karddal", "SWORD", "sword_IDLE", "Verekedés", true},
	{"Ütést kap 1", "BASEBALL", "Bat_Hit_1", "Verekedés", false},
	{"Ütést kap 2", "BASEBALL", "Bat_Hit_2", "Verekedés", false},
	{"Ütést kap 3", "BASEBALL", "Bat_Hit_3", "Verekedés", false},
	{"Ütést kap 4", "ped", "handscower", "Verekedés", false},
	{"Feszítés", "benchpress", "gym_bp_celebrate", "Keménykedés", true},
	{"Árnyékozás", "GYMNASIUM", "GYMshadowbox", "Keménykedés", true},
	{"Kurva pofozás", "MISC", "bitchslap", "Keménykedés", true},
	{"Rugás", "POLICE", "Door_Kick", "Keménykedés", false},
	{"Célzás jobb kézzel", "SHOP", "ROB_Loop", "Keménykedés", true},
	{"Célzás nagykaliberrel", "SHOP", "SHP_Gun_Aim", "Keménykedés", true},
	{"Cigizés falnál 1", "BD_FIRE", "M_smklean_loop", "Cigizés", true},
	{"Cigizés falnál 2", "LOWRIDER", "F_smklean_loop", "Cigizés", true},
	{"Cigizés állva 1", "GANGS", "smkcig_prtl", "Cigizés", true},
	{"Cigizés állva 2", "GANGS", "smkcig_prtl_F", "Cigizés", true},
	{"Cigizés állva 3", "LOWRIDER", "M_smkstnd_loop", "Cigizés", true},
	{"Cigizés állva 4", "SMOKING", "M_smk_drag", "Cigizés", true},
	{"Cigi begyújt", "SMOKING", "M_smk_in", "Cigizés", true},
	{"Cigi eldob", "SMOKING", "M_smk_out", "Cigizés", true},
	{"Cigi hamuzás", "SMOKING", "M_smk_tap", "Cigizés", true},
	{"Kártya emelés", "CASINO", "cards_raise", "Casino", false},
	{"Kártya nézés", "CASINO", "cards_loop", "Casino", true},
	{"Kártya veszít", "CASINO", "cards_lose", "Casino", false},
	{"Kártya nyer", "CASINO", "cards_win", "Casino", false},
	{"Rouletthez állás", "CASINO", "Roulette_in", "Casino", false},
	{"Roulett nézés", "CASINO", "Roulette_loop", "Casino", true},
	{"Roulett veszítés", "CASINO", "Roulette_lose", "Casino", false},
	{"Roulett nyerés", "CASINO", "Roulette_win", "Casino", false},
	{"Kalap megnézés", "CLOTHES", "CLO_Pose_Hat", "Ruhák megtekintése", true},
	{"Nadrág megnézés", "CLOTHES", "CLO_Pose_Legs", "Ruhák megtekintése", true},
	{"Cipő megnézés", "CLOTHES", "CLO_Pose_Shoes", "Ruhák megtekintése", true},
	{"Kar megnézés", "CLOTHES", "CLO_Pose_Torso", "Ruhák megtekintése", true},
	{"Óra megnézés", "CLOTHES", "CLO_Pose_Watch", "Ruhák megtekintése", true},
	{"Halál 1", "CRACK", "crckdeth1", "Haldoklás", false},
	{"Halál 2", "CRACK", "crckdeth2", "Haldoklás", false},
	{"Halál 3", "CRACK", "crckdeth3", "Haldoklás", false},
	{"Halál ülve előre", "FOOD", "FF_Die_Fwd", "Haldoklás", false},
	{"Halál ülve jobbra", "FOOD", "FF_Die_Right", "Haldoklás", false},
	{"Halál ülve balra", "FOOD", "FF_Die_Left", "Haldoklás", false},
	{"Haldoklás 1", "CRACK", "crckidle1", "Haldoklás", true},
	{"Haldoklás 2", "CRACK", "crckidle3", "Haldoklás", true},
	{"Haldoklás 3", "CRACK", "crckidle4", "Haldoklás", true},
	{"Tánc 1", "DANCING", "dance_loop", "Tánc", true},
	{"Tánc 2", "DANCING", "DAN_Down_A", "Tánc", true},
	{"Tánc 3", "DANCING", "DAN_Left_A", "Tánc", true},
	{"Tánc 4", "DANCING", "DAN_Loop_A", "Tánc", true},
	{"Tánc 5", "DANCING", "DAN_Right_A", "Tánc", true},
	{"Tánc 6", "DANCING", "DAN_Up_A", "Tánc", true},
	{"Tánc 7", "DANCING", "dnce_M_a", "Tánc", true},
	{"Tánc 8", "DANCING", "dnce_M_b", "Tánc", true},
	{"Tánc 9", "DANCING", "dnce_M_c", "Tánc", true},
	{"Tánc 10", "DANCING", "dnce_M_d", "Tánc", true},
	{"Tánc 11", "DANCING", "dnce_M_e", "Tánc", true},
	{"Bandás 1", "GANGS", "hndshkaa", "Köszönés", true},
	{"Bandás 2", "GANGS", "hndshkba", "Köszönés", true},
	{"Bandás 3", "GANGS", "hndshkca", "Köszönés", true},
	{"Bandás 4", "GANGS", "hndshkcb", "Köszönés", true},
	{"Bandás 5", "GANGS", "hndshkda", "Köszönés", true},
	{"Bandás 6", "GANGS", "hndshkea", "Köszönés", true},
	{"Bandás 7", "GANGS", "hndshkfa", "Köszönés", true},
	{"Kézrázás", "GANGS", "prtial_hndshk_biz_01", "Köszönés", true},
	{"Integetés", "GHANDS", "gsign5LH", "Köszönés", true},
	{"Integetés női", "KISSING", "gfwave2", "Köszönés", true},
	{"Csók 1", "KISSING", "Playa_Kiss_01", "Csók", true},
	{"Csók 2", "KISSING", "Playa_Kiss_02", "Csók", true},
	{"Csók 3", "KISSING", "Playa_Kiss_03", "Csók", true},
	{"Csók női 1", "KISSING", "Grlfrd_Kiss_01", "Csók", true},
	{"Csók női 2", "KISSING", "Grlfrd_Kiss_02", "Csók", true},
	{"Csók női 3", "KISSING", "Grlfrd_Kiss_03", "Csók", true},
	{"Laza leülés", "Attractors", "Stepsit_in", "Ülés", false},
	{"Laza felállás", "Attractors", "Stepsit_out", "Ülés", false},
	{"Napozás", "BEACH", "bather", "Ülés", true},
	{"Háton fekvés", "BEACH", "Lay_Bac_Loop", "Ülés", true},
	{"Háton fekvés női", "BEACH", "SitnWait_loop_W", "Ülés", true},
	{"Földön ülés", "BEACH", "ParkSit_M_loop", "Ülés", true},
	{"Földön ülés női", "BEACH", "ParkSit_W_loop", "Ülés", true},
	{"Laza ülés", "int_house", "lou_loop", "Ülés", true},
	{"Asztalon támaszkodás", "int_office", "off_sit_bored_loop", "Ülés", true},
	{"Görnyedt ülés", "misc", "seat_lr", "Ülés", true},
	{"Társalgás ülés közben 1", "misc", "seat_talk_01", "Ülés", true},
	{"Társalgás ülés közben 2", "misc", "seat_talk_02", "Ülés", true},
	{"Matatás", "BOMBER", "BOM_Plant_Loop", "Általános", true},
	{"Felvesz", "CARRY", "liftup", "Általános", false},
	{"Letesz", "CARRY", "putdwn", "Általános", false},
	{"Gyere", "CAMERA", "camstnd_cmon", "Általános", true},
	{"Gyere guggolva", "CAMERA", "camcrch_cmon", "Általános", true},
	{"Guggolás", "CAMERA", "camcrch_idleloop", "Általános", false},
	{"Szurkol", "CASINO", "manwind", "Általános", true},
	{"Óra megnézése", "COP_AMBIENT", "Coplook_watch", "Általános", false},
	{"Bólintás", "COP_AMBIENT", "Coplook_think", "Általános", true},
	{"Fejrázás", "COP_AMBIENT", "Coplook_shake", "Általános", true},
	{"Fizetés", "DEALER", "shop_pay", "Általános", false},
	{"Hamburger evés", "FOOD", "EAT_Burger", "Általános", true},
	{"Csirke evés", "FOOD", "EAT_Chicken", "Általános", true},
	{"Pizza evés", "FOOD", "EAT_Pizza", "Általános", true},
	{"Állás 1", "DEALER", "DEALER_IDLE", "Általános", true},
	{"Állás 2", "GANGS", "leanIDLE", "Általános", true},
	{"Megnézés", "GRAFFITI", "graffiti_Chkout", "Általános", false},
	{"Védekezés", "ped", "cower", "Általános", true},
	{"Kézfelrakás 1", "ped", "handsup", "Általános", false},
	{"Kézfelrakás 2", "SHOP", "SHP_Rob_React", "Általános", false},
	{"Újra éleszt", "MEDIC", "CPR", "Általános", false},
	{"Orrba szívás", "CRACK", "Bbalbat_Idle_02", "Általános", true},
	{"Ivás", "gangs", "drnkbr_prtl", "Általános", true},
	{"Telefonálás", "ped", "phone_talk", "Általános", true},
}

local availableCategories = {}
local expandedCategories = {}

local favoriteAnimations = {}
local favoritesList = {}

local clickTick = 0
local favoritesNum = 0
local segmentNum = 0

function spairs(t, order)
	local keys = {}

	for k in pairs(t) do
		keys[#keys+1] = k
	end

	if order then
		table.sort(keys,
			function (a, b)
				return order(t, a, b)
			end
		)
	else
		table.sort(keys)
	end

	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

function processCategories()
	local initializedCategories = {}
	local categoryCount = 2
	local favoritesCount = 3

	availableCategories = {}
	favoritesList = {}

	--availableCategories[1] = {"Animáció leállítása", "stopanim"}
	availableCategories[2] = {"Kedvencek", false}
	--availableCategories[2] = {"Animáció leállítása", "stopanim"}

	local function sortFunction(t, a, b)
		return a < b
	end

	for k, v in spairs(favoriteAnimations, sortFunction) do
		if expandedCategories["Kedvencek"] then
			availableCategories[favoritesCount] = availableAnimations[k]
			availableCategories[favoritesCount][6] = k
			availableCategories[favoritesCount][7] = true

			favoritesCount = favoritesCount + 1
			categoryCount = categoryCount + 1
		end

		table.insert(favoritesList, availableAnimations[k])
	end

	favoritesNum = #favoritesList
	segmentNum = math.pi * 2 / favoritesNum

	if #favoritesList == 0 then
		if expandedCategories["Kedvencek"] then
			availableCategories[3] = {"Nincs kedvenc animációd!", "custom_text"}
			categoryCount = 3
		end
	end

	for i = 1, #availableAnimations do
		if not favoriteAnimations[i] then
			local categoryName = availableAnimations[i][4]

			if not initializedCategories[categoryName] then
				initializedCategories[categoryName] = true

				categoryCount = categoryCount + 1

				availableCategories[categoryCount] = {categoryName, false}
			end

			if expandedCategories[categoryName] then
				categoryCount = categoryCount + 1

				availableCategories[categoryCount] = availableAnimations[i]
				availableCategories[categoryCount][6] = i
				availableCategories[categoryCount][7] = false
			end
		end
	end

	if #availableCategories > 15 then
		if visibleItem > #availableCategories - 15 then
			visibleItem = #availableCategories - 15
		end
	else
		visibleItem = 0
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if fileExists("favorites.json") then
			local jsonFile = fileOpen("favorites.json")

			if jsonFile then
				local fileContent = fileRead(jsonFile, fileGetSize(jsonFile))
				local jsonData = fromJSON(fileContent)

				fileClose(jsonFile)

				if jsonData then
					favoriteAnimations = {}

					for k, v in pairs(jsonData) do
						favoriteAnimations[tonumber(k)] = true
					end
				end
			end
		end

		processCategories()
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if fileExists("favorites.json") then
			fileDelete("favorites.json")
		end

		local jsonFile = fileCreate("favorites.json")

		if jsonFile then
			fileWrite(jsonFile, toJSON(favoriteAnimations, true))
			fileFlush(jsonFile)
			fileClose(jsonFile)
		end
	end
)

addCommandHandler("animpanel",
	function ()
		panelState = not panelState

		if panelState then
			panelFont = dxCreateFont("files/Roboto.ttf", respc(18), false, "antialiased")

			addEventHandler("onClientRender", getRootElement(), renderThePanel)
			addEventHandler("onClientClick", getRootElement(), clickOnPanel)
			addEventHandler("onClientKey", getRootElement(), scrollInPanel)

		else
			removeEventHandler("onClientRender", getRootElement(), renderThePanel)
			removeEventHandler("onClientClick", getRootElement(), clickOnPanel)
			removeEventHandler("onClientKey", getRootElement(), scrollInPanel)

			if isElement(panelFont) then
				destroyElement(panelFont)
			end

			panelFont = nil

		end
	end
)

function scrollInPanel(key, press)
	local relX, relY = getCursorPosition()

	if tonumber(relX) and tonumber(relY) then
		if key == "mouse_wheel_up" then
			if visibleItem > 0 then
				visibleItem = visibleItem - 1
			end
		elseif key == "mouse_wheel_down" then
			if visibleItem < #availableCategories - 14 then
				visibleItem = visibleItem + 1
			end
		end
	end
end

function clickOnPanel(button, state, absX, absY)
	if button == "left" then
		if state == "down" then
			if absX >= panelPosX and absX <= panelPosX + panelWidth - respc(28) - respc(5) and absY >= panelPosY and absY <= panelPosY + titleHeight then
				panelIsMoving = true
				moveDifferenceX = absX - panelPosX
				moveDifferenceY = absY - panelPosY
			else
				if renderDataDraw.activeButton then
					if renderDataDraw.activeButton == "stopAnimation" then
						if getTickCount() - clickTick >= 1000 then
							triggerServerEvent("stopThePanelAnimation", localPlayer)

							clickTick = getTickCount()

							playSound("files/select.mp3", false)
						end
					end
				end

				if activeButton then
					if activeButton == "exit" then
						panelState = false

						removeEventHandler("onClientRender", getRootElement(), renderThePanel)
						removeEventHandler("onClientClick", getRootElement(), clickOnPanel)
						removeEventHandler("onClientKey", getRootElement(), scrollInPanel)

						if isElement(panelFont) then
							destroyElement(panelFont)
						end

						panelFont = nil

						return
					elseif activeButton == "stopAnimation" then --wardis
						if getTickCount() - clickTick >= 1000 then
							triggerServerEvent("stopThePanelAnimation", localPlayer)

							clickTick = getTickCount()

							playSound("files/select.mp3", false)
						end
					else
						local selected = split(activeButton, "_")

						if selected[1] == "collapseCategory" then
							local categoryName = selected[2]

							if categoryName then
								expandedCategories[categoryName] = not expandedCategories[categoryName]

								processCategories()

								playSound("files/category.mp3", false)
							end
						elseif selected[1] == "addToFavorites" then
							local animationId = tonumber(selected[2])

							if animationId then
								favoriteAnimations[animationId] = true

								processCategories()

								playSound("files/select.mp3", false)
							end
						elseif selected[1] == "removeFromFavorites" then
							local animationId = tonumber(selected[2])

							if animationId then
								favoriteAnimations[animationId] = nil

								processCategories()

								playSound("files/select.mp3", false)
							end
						elseif selected[1] == "playAnimation" then
							local animationId = tonumber(selected[2])

							if animationId then
								if getTickCount() - clickTick >= 1000 then
									triggerServerEvent("setPedAnimationPanel", localPlayer, availableAnimations[animationId][2], availableAnimations[animationId][3], availableAnimations[animationId][5])

									clickTick = getTickCount()

									playSound("files/select.mp3", false)
								end
							end
						end
					end
				end
			end
		else
			if state == "up" then
				panelIsMoving = false
				moveDifferenceX = 0
				moveDifferenceY = 0
			end
		end
	end
end

function renderThePanel()

	renderDataDraw.buttons = {}

	dxDrawRectangle(panelPosX, panelPosY, panelWidth, panelHeight - 3 + respc(50), tocolor(25, 25, 25))

	--dxDrawRectangle(panelPosX + 4, panelPosY + panelHeight + respc(50) - 3 - respc(50) + 4, panelWidth - 8, respc(50) - 8, tocolor(255, 25, 25))

	drawButton("stopAnimation", "Animáció leállitása",panelPosX + 4, panelPosY + panelHeight + respc(50) - 3 - respc(50) + 4, panelWidth - 8, respc(50) - 8, {200, 45, 33})

	dxDrawRectangle(panelPosX + 3, panelPosY + 3, panelWidth - 6, titleHeight - 6, tocolor(40, 40, 40, 200))
	dxDrawText("#3d7abcStrong#ffffffMTA", panelPosX + respc(7), panelPosY, panelPosX + panelWidth, panelPosY + titleHeight, tocolor(255, 255, 255), 0.8, panelFont, "left", "center", false, false, false, true)

	-- ** Content
	local buttons = {}

	buttons.exit = {panelPosX + panelWidth - respc(28) - respc(5), panelPosY + titleHeight / 2 - respc(14), respc(28), respc(28)}

	if activeButton == "exit" then
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/close.png", 0, 0, 0, tocolor(215, 89, 89))
	else
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/close.png", 0, 0, 0, tocolor(255, 255, 255))
	end

	local oneButtonHeight = (panelHeight - titleHeight) / 13

	for i = 2, 14 do
		local v = availableCategories[i + visibleItem]
		local y = panelPosY + titleHeight + oneButtonHeight * (i - 1) - oneButtonHeight

		if i % 2 ~= visibleItem % 2 then
			dxDrawRectangle(panelPosX + 4, y, panelWidth - 8, oneButtonHeight - 2, tocolor(45, 45, 45, 125))
		else
			dxDrawRectangle(panelPosX + 4, y, panelWidth - 8, oneButtonHeight - 2, tocolor(55, 55, 55, 150))
		end

		if v then
			if v[2] == "custom_text" then
				dxDrawText(v[1], panelPosX + respc(15), y, panelPosX + panelWidth, y + oneButtonHeight, tocolor(215, 89, 89), 0.65, panelFont, "left", "center", true)
			elseif v[2] then
				if v[2] == "stopanim" then
					buttons.stopAnimation = {panelPosX, y, panelWidth, oneButtonHeight}

					if activeButton == "stopAnimation" then
						dxDrawRectangle(panelPosX, y, panelWidth, oneButtonHeight, tocolor(0, 0, 0, 100))
					end

					dxDrawText(v[1], panelPosX + respc(5), y, panelPosX + panelWidth, y + oneButtonHeight, tocolor(215, 89, 89), 0.65, panelFont, "left", "center", true)
				else
					buttons["playAnimation_" .. v[6]] = {panelPosX, y, panelWidth - oneButtonHeight - respc(3), oneButtonHeight}

					if activeButton == "playAnimation_" .. v[6] then
						dxDrawRectangle(panelPosX, y, panelWidth, oneButtonHeight, tocolor(0, 0, 0, 100))
					end

					dxDrawText(v[1], panelPosX + respc(15), y, panelPosX + panelWidth, y + oneButtonHeight, tocolor(200, 200, 200, 200), 0.65, panelFont, "left", "center", true)

					if v[7] then
						local buttonName = "removeFromFavorites_" .. v[6]
						local buttonColor = tocolor(61, 122, 188, 200)

						buttons[buttonName] = {math.floor(panelPosX + panelWidth - oneButtonHeight + respc(2)), math.floor(y + respc(5)), oneButtonHeight - respc(10), oneButtonHeight - respc(10)}

						if activeButton == buttonName then
							buttonColor = tocolor(61, 122, 188, 150)
						end

						dxDrawImage(buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], "files/starfull.png", 0, 0, 0, buttonColor)
					else
						local buttonName = "addToFavorites_" .. v[6]
						local buttonColor = tocolor(255, 255, 255, 150)

						buttons[buttonName] = {math.floor(panelPosX + panelWidth - oneButtonHeight + respc(2)), math.floor(y + respc(5)), oneButtonHeight - respc(10), oneButtonHeight - respc(10)}

						if activeButton == buttonName then
							buttonColor = tocolor(61, 122, 188, 250)
						end

						dxDrawImage(buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], "files/star.png", 0, 0, 0, buttonColor)
					end
				end
			else
				buttons["collapseCategory_" .. v[1]] = {panelPosX, y, panelWidth, oneButtonHeight}

				if activeButton == "collapseCategory_" .. v[1] then
					dxDrawRectangle(panelPosX, y, panelWidth, oneButtonHeight, tocolor(0, 0, 0, 100))
				end

				if expandedCategories[v[1]] then
					dxDrawImage(panelPosX + respc(5), y + oneButtonHeight / 2 - oneButtonHeight / 4, oneButtonHeight / 2, oneButtonHeight / 2, "files/arrow.png", 90, 0, 0, tocolor(61, 122, 188))
				else
					dxDrawImage(panelPosX + respc(5), y + oneButtonHeight / 2 - oneButtonHeight / 4, oneButtonHeight / 2, oneButtonHeight / 2, "files/arrow.png", 0, 0, 0, tocolor(61, 122, 188))
				end

				dxDrawText(v[1], panelPosX + respc(7) + oneButtonHeight / 2, y, panelPosX + panelWidth, y + oneButtonHeight, tocolor(61, 122, 188, 200), 0.65, panelFont, "left", "center", true)
			end
		end
	end

	if #availableCategories > 14 then
		local contentRatio = (oneButtonHeight * 13) / #availableCategories

		dxDrawRectangle(panelPosX + panelWidth - respc(3), panelPosY + titleHeight + visibleItem * contentRatio, respc(3), contentRatio * 14, tocolor(61, 122, 188, 150))
	end

	-- ** Button handler
	activeButton = false

	if isCursorShowing() then
		local relX, relY = getCursorPosition()
		local absX, absY = relX * screenX, relY * screenY

		if panelIsMoving then
			panelPosX = absX - moveDifferenceX
			panelPosY = absY - moveDifferenceY
		else
			for k, v in pairs(buttons) do
				if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
					activeButton = k
					break
				end
			end
		end
	end

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

local circleSize = 100
local arrowSize = circleSize * 0.9
local circleDist = screenY / 2 * 0.5

local hoverFavAnim = 0
local circleRoboto = false

function renderCircle()
	if favoritesNum > 0 then
		local blockName, animationName = getPedAnimation(localPlayer)
		local cursorX, cursorY = getCursorPosition()

		if cursorX and cursorY then
			cursorX = cursorX * screenX
			cursorY = cursorY * screenY
		else
			cursorX = 0
			cursorY = 0
		end

		local theX = screenX / 2
		local theY = screenY / 2
		local lastHover = hoverFavAnim

		if getDistanceBetweenPoints2D(cursorX, cursorY, theX, theY) > circleSize / 2 then
			local angle = math.atan2(cursorY - theY, cursorX - theX) - math.pi / 2 + segmentNum / 2

			if angle > math.pi then
				angle = angle - 2 * math.pi
			elseif angle < -math.pi then
				angle = angle + 2 * math.pi
			end

			angle = angle + math.pi
			hoverFavAnim = math.floor(angle / segmentNum) + 1

			local rotation = math.deg(math.floor(angle / segmentNum) * segmentNum)
			local centerY = arrowSize / 2 + circleSize / 2

			dxDrawImage(theX - arrowSize / 4 / 2, theY - arrowSize - circleSize / 2, arrowSize / 4, arrowSize, "files/tri.png", rotation, 0, centerY, tocolor(50, 50, 50, 200))
			dxDrawImage(theX - circleSize * 0.75 / 2, theY - circleSize * 0.75 / 2, circleSize * 0.75, circleSize * 0.75, "files/circle.png", 0, 0, 0, tocolor(25, 25, 25, 200))
			dxDrawImage(theX - circleSize * 0.5 / 2, theY - circleSize * 0.5 / 2, circleSize * 0.5, circleSize * 0.5, "files/stop.png", 0, 0, 0, tocolor(200, 200, 200, 200))
		else
			hoverFavAnim = 0

			dxDrawImage(theX - circleSize / 2, theY - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(25, 25, 25, 200))
			dxDrawImage(theX - circleSize * 0.75 / 2, theY - circleSize * 0.75 / 2, circleSize * 0.75, circleSize * 0.75, "files/stop.png", 0, 0, 0, tocolor(215, 89, 89, 200))
		end

		for i = 1, favoritesNum do
			local v = favoritesList[i]
			local active = false

			if blockName and animationName and string.lower(blockName) == string.lower(v[2]) and string.lower(animationName) == string.lower(v[3]) then
				active = true
			end

			local angle = math.rad(-90) + segmentNum * (i - 1)
			local x = theX + math.cos(angle) * circleDist
			local y = theY + math.sin(angle) * circleDist

			if active then
				if hoverFavAnim == i then
					dxDrawImage(x - circleSize / 2, y - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(61, 122, 188, 200))
				else
					dxDrawImage(x - circleSize / 2, y - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(61, 122, 188, 100))
				end
			elseif hoverFavAnim == i then
				dxDrawImage(x - circleSize / 2, y - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(25, 25, 25, 250))
			else
				dxDrawImage(x - circleSize / 2, y - circleSize / 2, circleSize, circleSize, "files/circle.png", 0, 0, 0, tocolor(25, 25, 25, 150))
			end

			if active then
				dxDrawText(v[1], x - circleSize / 2 * 0.9, y - circleSize / 2 * 0.9, x + circleSize / 2 * 0.9, y + circleSize / 2 * 0.9, tocolor(200, 200, 200, 200), 0.8, circleRoboto, "center", "center", false, true)
			else
				dxDrawText(v[1], x - circleSize / 2 * 0.9, y - circleSize / 2 * 0.9, x + circleSize / 2 * 0.9, y + circleSize / 2 * 0.9, tocolor(200, 200, 200, 200), 0.8, circleRoboto, "center", "center", false, true)
			end
		end

		if lastHover ~= hoverFavAnim then
			playSound("files/hover.mp3")
		end
	end
end

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if key == "mouse3" then
			if not isPedInVehicle(localPlayer) then
				if not getElementData(localPlayer, "editingInterior") then
					favoritesNum = #favoritesList
					segmentNum = math.pi * 2 / favoritesNum

					if favoritesNum == 0 then
						if press then
							exports.sm_hud:showInfobox("e", "Előbb adj hozzá animációt a kedvenceidhez! (/animpanel)")
						end
					else
						if press then
							if getTickCount() - clickTick > 100 then
								local blockName, animationName = getPedAnimation(localPlayer)

								circleRoboto = dxCreateFont("files/Roboto.ttf", 14, false, "antialiased")
								addEventHandler("onClientRender", getRootElement(), renderCircle)

								showCursor(true)
								setCursorPosition(screenX / 2, screenY / 2)

								for i = 1, favoritesNum do
									local v = favoritesList[i]

									if blockName and animationName and string.lower(blockName) == string.lower(v[2]) and string.lower(animationName) == string.lower(v[3]) then
										local angle = math.rad(-90) + segmentNum * (i - 1)

										local x = screenX / 2 + math.cos(angle) * circleDist
										local y = screenY / 2 + math.sin(angle) * circleDist

										setCursorPosition(x, y)

										break
									end
								end

								clickTick = getTickCount()
								hoverFavAnim = 0
							end
						else
							removeEventHandler("onClientRender", getRootElement(), renderCircle)
							showCursor(false)

							if isElement(circleRoboto) then
								destroyElement(circleRoboto)
							end

							circleRoboto = nil

							if hoverFavAnim == 0 then
								triggerServerEvent("stopThePanelAnimation", localPlayer)
							else
								local blockName, animationName = getPedAnimation(localPlayer)
								local animation = favoritesList[hoverFavAnim]

								if not blockName or not animationName or string.lower(blockName) ~= string.lower(animation[2]) or string.lower(animationName) ~= string.lower(animation[3]) then
									triggerServerEvent("setPedAnimationPanel", localPlayer, animation[2], animation[3], animation[5])
								end
							end
						end
					end

					cancelEvent()
				end
			end
		end
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

function drawButton(key, label, x, y, w, h, activeColor, postGui, theFont)
	local buttonColor
	if renderDataDraw.activeButton == key then
		buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], 175})}
	else
		buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], 125})}
	end

	local alphaDifference = 175 - buttonColor[4]

	dxDrawRectangle(x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 175 - alphaDifference), postGui)
	dxDrawInnerBorder(2, x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 125 + alphaDifference), postGui)

	labelFont = theFont or panelFont
	postGui = postGui or false
	labelScale = 0.85
	
	dxDrawText(label, x, y, x + w, y + h, tocolor(200, 200, 200, 200), labelScale, labelFont, "center", "center", false, false, postGui, true)

	renderDataDraw.buttons[key] = {x, y, w, h}
end

function dxDrawInnerBorder(thickness, x, y, w, h, color, postGUI)
	thickness = thickness or 1
	dxDrawRectangle(x, y, w, thickness, color, postGUI)
	dxDrawRectangle(x, y + h - thickness, w, thickness, color, postGUI)
	dxDrawRectangle(x, y, thickness, h, color, postGUI)
	dxDrawRectangle(x + w - thickness, y, thickness, h, color, postGUI)
end

addCommandHandler("cdance",
	function(cmd, dance)
		if dance then
			if dance == "1" then
				setPedAnimation (localPlayer, "dance", "handscower", -1, true, true, false, false)
			elseif dance == "2" then
				setPedAnimation (localPlayer, "dance2", "Bbalbat_Idle_02", -1, true, true, false, false)
			elseif dance == "3" then
				setPedAnimation (localPlayer, "dance2", "crckidle2", -1, true, true, false, false)
			elseif dance == "4" then
				setPedAnimation (localPlayer, "dance2", "crckdeth1", -1, true, true, false, false)
			elseif dance == "5" then
				setPedAnimation (localPlayer, "dance2", "crckdeth2", -1, true, true, false, false)
			elseif dance == "6" then
				setPedAnimation (localPlayer, "dance2", "crckdeth3", -1, true, true, false, false)
			elseif dance == "7" then
				setPedAnimation (localPlayer, "dance3", "dance_loop", -1, true, true, false, false)
			end
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function ( startedRes )
        customIfp = engineLoadIFP ("files/custom/dance.ifp", "dance")
		customIfp2 = engineLoadIFP ("files/custom/dance2.ifp", "dance2")
		customIfp3 = engineLoadIFP ("files/custom/dance3.ifp", "dance3")
       -- if customIfp then 
         --   outputChatBox ("parkour.ifp Loaded successfully")
        --else
          --  outputChatBox ("Failed to load parkour.ifp")
        --end
    end
)