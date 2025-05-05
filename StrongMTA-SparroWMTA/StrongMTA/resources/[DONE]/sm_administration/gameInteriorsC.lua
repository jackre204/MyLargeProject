local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = 1

pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local gameInteriors = {}
local interiorList = {}
local visibleItem = 0

local panelState = false
local activeButton = false

local activeSearchInput = false
local searchInputText = ""

local cursorStateChange = 0
local cursorState = true
local clickTick = 0

local Roboto = false

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedResource)
		if getResourceName(startedResource) == "sm_hud" then
			responsiveMultipler = exports.sm_hud:getResponsiveMultipler()
		elseif getResourceName(startedResource) == "sm_interiors" then
			gameInteriors = exports.sm_interiors:getGameInteriors()
		elseif startedResource == getThisResource() then
			local sm_hud = getResourceFromName("sm_hud")

			if sm_hud and getResourceState(sm_hud) == "running" then
				responsiveMultipler = exports.sm_hud:getResponsiveMultipler()
			end

			local sm_interiors = getResourceFromName("sm_interiors")

			if sm_interiors and getResourceState(sm_interiors) == "running" then
				gameInteriors = exports.sm_interiors:getGameInteriors()
			end
		end
	end
)

function createFonts()
	destroyFonts()

	Roboto = dxCreateFont("files/Roboto.ttf", respc(18), false, "antialiased")
end

function destroyFonts()
	if isElement(Roboto) then
		destroyElement(Roboto)
	end

	Roboto = nil
end

addCommandHandler("gameinteriors",
	function ()
		if getElementData(localPlayer, "acc.adminLevel") >= 6 then
			panelState = not panelState

			if panelState then
				searchProcess()
				createFonts()

				addEventHandler("onClientRender", getRootElement(), renderThePanel)
				addEventHandler("onClientClick", getRootElement(), clickOnPanel)
				addEventHandler("onClientKey", getRootElement(), scrollInPanel)
				addEventHandler("onClientCharacter", getRootElement(), searchInList)

				playSound("files/open.mp3", false)
			else
				removeEventHandler("onClientRender", getRootElement(), renderThePanel)
				removeEventHandler("onClientClick", getRootElement(), clickOnPanel)
				removeEventHandler("onClientKey", getRootElement(), scrollInPanel)
				removeEventHandler("onClientCharacter", getRootElement(), searchInList)

				destroyFonts()

				playSound("files/close.mp3", false)
			end
		end
	end
)

function searchProcess()
	interiorList = {}

	if utf8.len(searchInputText) < 1 then
		for k, v in pairs(gameInteriors) do
			if k ~= "e" then
				table.insert(interiorList, {k, v})
			end
		end
	elseif tonumber(searchInputText) then
		searchInputText = tonumber(searchInputText)

		if gameInteriors[searchInputText] then
			table.insert(interiorList, {searchInputText, gameInteriors[searchInputText]})
		end
	else
		for k, v in pairs(gameInteriors) do
			if k ~= "e" then
				if utf8.find(utf8.lower(v.name), utf8.lower(searchInputText)) then
					table.insert(interiorList, {k, v})
				end
			end
		end
	end

	if visibleItem < 0 then
		visibleItem = 0
	end

	if #interiorList > 15 then
		if visibleItem > #interiorList - 15 then
			visibleItem = #interiorList - 15
		end
	else
		visibleItem = 0
	end
end

function searchInList(character)
	if activeSearchInput then
		searchInputText = searchInputText .. character
		searchProcess()
		cancelEvent()
	end
end

function scrollInPanel(key, press)
	local relX, relY = getCursorPosition()

	if tonumber(relX) and tonumber(relY) then
		if key == "mouse_wheel_up" then
			if visibleItem > 0 then
				visibleItem = visibleItem - 15

				if visibleItem < 0 then
					visibleItem = 0
				end
			end
		elseif key == "mouse_wheel_down" then
			visibleItem = visibleItem + 15

			if #interiorList > 15 then
				if visibleItem > #interiorList - 15 then
					visibleItem = #interiorList - 15
				end
			else
				visibleItem = 0
			end
		end
	end

	if activeSearchInput then
		if key == "backspace" then
			if press then
				searchInputText = utf8.sub(searchInputText, 1, utf8.len(searchInputText) - 1)
				searchProcess()
			end
		end

		if key ~= "escape" then
			cancelEvent()
		end
	end
end

function clickOnPanel(button, state, absX, absY)
	if button == "left" then
		if state == "up" then
			if activeButton then
				if activeButton == "exit" then
					executeCommandHandler("gameinteriors")
				elseif activeButton == "searchInput" then
					if not activeSearchInput then
						activeSearchInput = true

						cursorStateChange = getTickCount()
						cursorState = true

						playSound("files/select.mp3", false)
					end
				else
					local selected = split(activeButton, "_")

					if selected[1] == "view" then
						local id = tonumber(selected[2])

						if id then
							if getTickCount() - clickTick >= 1000 then
								if not isPedInVehicle(localPlayer) then
									if gameInteriors[id] then
										executeCommandHandler("gameinteriors")

										triggerServerEvent("warpToGameInterior", localPlayer, id, gameInteriors[id])

										clickTick = getTickCount()

										playSound("files/select.mp3", false)
									else
										exports.sm_hud:showInfobox("e", "Nem létező interior!")
									end
								else
									exports.sm_hud:showInfobox("e", "Előbb szállj ki a járműből!")
								end
							else
								exports.sm_hud:showInfobox("e", "Ne ilyen gyorsan!")
							end
						end
					end
				end
			end
		elseif state == "down" then
			if activeButton ~= "searchInput" then
				if activeSearchInput then
					activeSearchInput = false
				end
			end
		end
	end
end

function renderThePanel()
	local sx = respc(600)
	local sy = respc(40 + 600 + 40)

	local x = math.floor(screenX / 2 - sx / 2)
	local y = math.floor(screenY / 2 - sy / 2)

	-- ** Háttér
	dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))
		
	-- ** Cím
	dxDrawRectangle(x + 3, y + 3, sx - 6, respc(40) - 6, tocolor(45, 45, 45, 160))
	dxDrawText("#3d7abcStrong#ffffffMTA #ffffff- Interior belsők", x + respc(7), y, x + sx, y + respc(40), tocolor(200, 200, 200, 200), 0.8, Roboto, "left", "center", false, false, false, true)
		
	-- ** Content
	local buttons = {}
	buttonsC = {}

	buttons.exit = {x + sx - respc(28) - respc(5), y + respc(40) / 2 - respc(14), respc(28), respc(28)}

	if activeButton == "exit" then
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/close.png", 0, 0, 0, tocolor(215, 89, 89))
	else
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/close.png", 0, 0, 0, tocolor(255, 255, 255))
	end

	-- Lista
	local oneButtonHeight = (sy - respc(40) - respc(40)) / 15

	for i = 1, 15 do
		local y2 = y + respc(40) + oneButtonHeight * (i - 1)

		if i % 2 ~= visibleItem % 2 then
			dxDrawRectangle(x, y2, sx, oneButtonHeight, tocolor(35, 35, 35, 125))
		else
			dxDrawRectangle(x, y2, sx, oneButtonHeight, tocolor(45, 45, 45, 150))
		end

		local v = interiorList[i + visibleItem]

		if v then
			dxDrawText("#3d7abc[" .. v[1] .. "] #ffffff" .. v[2].name, x + respc(5), y2, x + sx, y2 + oneButtonHeight, tocolor(200, 200, 200, 200), 0.65, Roboto, "left", "center", false, true, false, true)
			
			local btnSizeX = dxGetTextWidth("Megtekint", 1, Roboto) + respc(2.5) + respc(20)
			local btnSizeY = dxGetFontHeight(1, Roboto) + respc(5)
			local btnName = "view_" .. v[1]

			buttons[btnName] = {x + sx - btnSizeX - respc(15), y2 + oneButtonHeight / 2 - btnSizeY / 2, btnSizeX, btnSizeY}

			drawButton(btnName, "Megtekint", buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], {61, 122, 188}, false, Roboto, true)
		end
	end

	if #interiorList > 15 then
		local contentRatio = (oneButtonHeight * 15) / #interiorList

		dxDrawRectangle(x + sx - respc(5), y + respc(40), respc(5), oneButtonHeight * 15, tocolor(0, 0, 0, 120))
		dxDrawRectangle(x + sx - respc(5), y + respc(40) + visibleItem * contentRatio, respc(5), contentRatio * 15, tocolor(61, 122, 188, 150))
	end

	-- Kereső mező
	dxDrawRectangle(x, y + sy - respc(40), sx, respc(40), tocolor(25, 25, 25))
	
	buttons.searchInput = {x + respc(5), y + sy - respc(40) + respc(5), sx - respc(10), respc(40) - respc(10)}

	dxDrawRectangle(buttons.searchInput[1], buttons.searchInput[2], buttons.searchInput[3], buttons.searchInput[4], tocolor(100, 100, 100, 50))

	if utf8.len(searchInputText) < 1 and not activeSearchInput then
		dxDrawText("Keresés...", buttons.searchInput[1] + respc(5), buttons.searchInput[2], buttons.searchInput[1] + buttons.searchInput[3] - respc(5), buttons.searchInput[2] + buttons.searchInput[4], tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center", true)
	else
		if activeSearchInput and cursorState then
			dxDrawText(searchInputText .. "|", buttons.searchInput[1] + respc(5), buttons.searchInput[2], buttons.searchInput[1] + buttons.searchInput[3] - respc(5), buttons.searchInput[2] + buttons.searchInput[4], tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center", true)
		else
			dxDrawText(searchInputText, buttons.searchInput[1] + respc(5), buttons.searchInput[2], buttons.searchInput[1] + buttons.searchInput[3] - respc(5), buttons.searchInput[2] + buttons.searchInput[4], tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center", true)
		end
	end

	if activeSearchInput then
		if getTickCount() - cursorStateChange >= 500 then
			cursorStateChange = getTickCount()
			cursorState = not cursorState
		end
	end

	-- ** Button handler
	activeButton = false
	activeButtonC = false

	if isCursorShowing() then
		local relX, relY = getCursorPosition()
		local absX, absY = relX * screenX, relY * screenY

		for k, v in pairs(buttons) do
			if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
				activeButton = k
				activeButtonC = k
				break
			end
		end
	end
end