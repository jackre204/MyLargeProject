local screenW, screenH = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local lockCode = "yy-8LG#H@yRgKQ-UpxCSMWgzu@LpVbW#uDuVnc*qc9h+_EtR@Vw#mAsF6yzv5u3jJqupMs$"
local lockString = 655

local modelTable = {
	[603] = 2,
	[566] = 4,
	[402] = 1,
	[585] = 1,
	[491] = 2,
	--[426] = 2,
	--[402] = 1,
	--[479] = 2,
	[579] = 1,
	--[526] = 3,
	--[503] = 2,
	--[575] = 3,
	--[507] = 1
}

function getTuningVariantVehicles(model)
	if modelTable[model] then
		return true
	else
		return false
	end
end

addEventHandler("onClientElementStreamIn", getRootElement(),
	function()
		if getElementType(source) == "vehicle" then
			local maxVarriants = modelTable[getElementModel(source)]

			local var1, var2 = getVehicleVariant(source)

			if getElementModel(source) == 503 then
				if var1 == 1 then
					setVehicleComponentVisible(source, "extra2lokos", true)
				else
					setVehicleComponentVisible(source, "extra2lokos", false)
				end
			elseif getElementModel(source) == 479 then
				if var1 == 0 then
					setVehicleComponentVisible(source, "extra2lokos", false)
					setVehicleComponentVisible(source, "extra3logo", false)
				elseif var1 == 2 then
					setVehicleComponentVisible(source, "extra3logo", true)
					--setVehicleComponentVisible(source, "extra3logo", false)
					setVehicleComponentVisible(source, "extra2lokos", false)
				else
					setVehicleComponentVisible(source, "extra3logo", false)
					setVehicleComponentVisible(source, "extra2lokos", true)
				end
			elseif getElementModel(source) == 585 then
				if var1 == 1 then
					setVehicleComponentVisible(source, "extra_2csomag", true)
					setVehicleComponentVisible(source, "extra_1csomag", false)
					print("asasas")
				else
					setVehicleComponentVisible(source, "extra_2csomag", false)
					setVehicleComponentVisible(source, "extra_1csomag", true)
				end
			end

			if maxVarriants then
				for k = 1, maxVarriants + 1 do
					setVehicleComponentVisible(source, "extra_" .. k, false)
				end 

				if var1 > maxVarriants then
					setVehicleComponentVisible(source, "extra_1", true)
				else
					setVehicleComponentVisible(source, "extra_" .. var1 + 1, true)
				end
			end
		end
	end
)

local panelState = false
local panelWidth = 500
local panelHeight = 400
local panelPosX = (screenW - panelWidth) / 2
local panelPosY = (screenH - panelHeight) / 2
local Roboto = false

local toggables = {}

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

local mods = {}
local modsNum = 0
local vehiclesXML = xmlLoadFile("save.xml") or xmlCreateFile("save.xml", "vehicles")

local function registerVehicleMod(fileName, model, isNotToggable)
	model = model or fileName

	modsNum = #mods + 1
	mods[modsNum] = {}
	mods[modsNum].model = tonumber(model) or getVehicleModelFromName(model)
	mods[modsNum].path = fileName

	if isNotToggable then
		mods[modsNum].toggable = false
	else
		mods[modsNum].toggable = true
	end

	mods[modsNum].state = true
end

local loadingThread = false
local loadingInProgress = false
local threadTimer = false
local pendingLoading = 0

local function loadMod(id)
	if id then
		if mods and mods[id] and mods[id].state == true then
			if fileExists("mods/" .. mods[id].path .. ".txd") then
				local txd = engineLoadTXD("mods/" .. mods[id].path .. ".txd", true)

				if txd then
					engineImportTXD(txd, mods[id].model)
				end
			end

			if fileExists("mods/" .. mods[id].path .. ".col") then
				local col = engineLoadCOL("mods/" .. mods[id].path .. ".col")

				if col then
					engineReplaceCOL(col, mods[id].model)
				end
			end

			if fileExists("mods/" .. mods[id].path .. ".dff") and not fileExists("mods/" .. mods[id].path .. ".strong") then
				local dff = engineLoadDFF("mods/" .. mods[id].path .. ".dff", mods[id].model)

				if dff then
					engineReplaceModel(dff, mods[id].model)
				end
			elseif fileExists("mods/" .. mods[id].path .. ".strong") then
				local dff = engineLoadDFF(loadLockedFiles("mods/"..mods[id].path..".strong", lockCode), mods[id].model)

				if dff then
					engineReplaceModel(dff, mods[id].model)
				end
			end
		end
	end
end

local function preLoadMod(id)
	if id then
		if mods and mods[id] and mods[id].state == true then
			if isTimer(threadTimer) then
				killTimer(threadTimer)
			end

			threadTimer = setTimer(
				function ()
					pendingLoading = 0
				end,
			200, 1)

			if pendingLoading > 0 then
				setTimer(loadMod, pendingLoading * 250, 1, id)
				return
			end

			pendingLoading = pendingLoading + 1

			loadMod(id)
		end
	end
end

local function unloadMod(id)
	if id and mods and mods[id] then
		local xmlFile = xmlFindChild(vehiclesXML, mods[id].path, 0) or xmlCreateChild(vehiclesXML, mods[id].path)

		if xmlFile then
			mods[id].state = false
			xmlNodeSetValue(xmlFile, "0")
			xmlSaveFile(vehiclesXML)
		end

		engineRestoreCOL(mods[id].model)
		engineRestoreModel(mods[id].model)
	end
end

function dummyFunction()
	loadingInProgress = false
end

function toggleMod(id, state)
	if state then
		loadingInProgress = true

		preLoadMod(id)

		if isTimer(threadTimer) then
			killTimer(threadTimer)
		end

		threadTimer = setTimer(dummyFunction, 200, 1)
	else
		unloadMod(id)
	end
end

function loadMods()
	local nextLoadTime = 50

	for k in pairs(mods) do
		setTimer(toggleMod, nextLoadTime, 1, k, true)
		nextLoadTime = nextLoadTime + 50
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if vehiclesXML then
			for k, v in ipairs(mods) do
				local xmlFile = xmlFindChild(vehiclesXML, v.path, 0) or xmlCreateChild(vehiclesXML, v.path)

				if xmlNodeGetValue(xmlFile) and xmlNodeGetValue(xmlFile) ~= "" then
					if xmlNodeGetValue(xmlFile) == "0" then
						mods[k].state = false
					end
				else
					mods[k].state = true
					xmlNodeSetValue(xmlFile, "1")
					xmlSaveFile(vehiclesXML)
				end
			end
		end

		for modelID, modelData in pairs(vehicleDataTable) do
			registerVehicleMod(modelData.modelPatch, modelID)
		end

		loadingThread = coroutine.create(loadMods)
		coroutine.resume(loadingThread)
	end)

local function spairs(t, order)
	local keys = {}

	for k in pairs(t) do
		keys[#keys + 1] = k
	end

	if order then
		table.sort(keys, function(a, b)
			return order(t, a, b)
		end)
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

local function togglePanel(state)
	if state ~= panelState then
		if state then
			local switchable = {}

			if mods then
				for k, v in ipairs(mods) do
					if v.toggable then
						table.insert(switchable, {
							exports.sm_vehiclenames:getCustomVehicleName(v.model),
							getVehicleNameFromModel(v.model),
							v.state,
							k
						})
					end
				end
			end

			toggables = {}

			for _, v in spairs(switchable, function (t, a, b)
					return utf8.lower(t[b][1]) > utf8.lower(t[a][1])
			end) do
				table.insert(toggables, v)
			end

			panelState = true
			Roboto = dxCreateFont("files/Roboto.ttf", respc(12), false, "antialiased")

			addEventHandler("onClientRender", getRootElement(), renderTheModsPanel)
			addEventHandler("onClientKey", getRootElement(), onClientKey)
			addEventHandler("onClientClick", getRootElement(), onClientClick)
		else
			removeEventHandler("onClientKey", getRootElement(), onClientKey)
			removeEventHandler("onClientClick", getRootElement(), onClientClick)
			removeEventHandler("onClientRender", getRootElement(), renderTheModsPanel)

			panelState = false

			if isElement(Roboto) then
				destroyElement(Roboto)
			end

			Roboto = nil
		end
	end
end

addCommandHandler("modpanel",
	function ()
		togglePanel(not panelState)
	end)

local cursorX, cursorY = 0, 0
local activeButton = false
local buttons = {}
local currentPage = 0

function renderTheModsPanel()
	if panelState then
		cursorX, cursorY = 0, 0

		if isCursorShowing() then
			local relX, relY = getCursorPosition()
			cursorX, cursorY = relX * screenW, relY * screenH
		end

		panelWidth = respc(600)
		panelHeight = respc(400)
		panelPosX = (screenW - panelWidth) / 2
		panelPosY = (screenH - panelHeight) / 2

		buttons = {}
		buttonsC = {}

		dxDrawRectangle(panelPosX, panelPosY, panelWidth, panelHeight, tocolor(25, 25, 25))
		dxDrawRectangle(panelPosX + respc(5), panelPosY + respc(5), panelWidth - respc(10), respc(30) - respc(5), tocolor(45, 45, 45, 150))
		dxDrawText("#3d7abcStrong#ffffffMTA #ffffff- Jármű modok", panelPosX + respc(7.5) + respc(5), panelPosY, panelWidth - respc(10), panelPosY + respc(5) + respc(30), tocolor(200, 200, 200, 200), 0.9, Roboto, "left", "center", false, false, false, true)
		
		if activeButton == "close" then
			dxDrawText("X", panelPosX + respc(390), panelPosY + respc(5), panelPosX + panelWidth - respc(10), panelPosY + respc(5) - respc(5) + respc(280) / 10, tocolor(200, 200, 200, 200), 1, Roboto, "right", "center")
		else
			dxDrawText("X", panelPosX + respc(390), panelPosY + respc(5), panelPosX + panelWidth - respc(10), panelPosY + respc(5) - respc(5) + respc(280) / 10, tocolor(200, 200, 200, 200), 1, Roboto, "right", "center")
		end

		buttons.close = {panelPosX + respc(390), panelPosY + respc(5), panelPosX + panelWidth - respc(10), panelPosY - respc(5) + respc(280) / 10}

		--dxDrawRectangle(panelPosX + respc(5), panelPosY + respc(35), panelWidth - respc(10), respc(280) / 10, tocolor(35, 35, 35, 150))
		--dxDrawText("Jármű neve", panelPosX + respc(10), panelPosY + respc(35), panelWidth - respc(10), panelPosY + respc(35) + respc(280) / 10, tocolor(124, 197, 118), 0.8, Roboto, "left", "center")
		--dxDrawText("Eredeti jármű", panelPosX + respc(260), panelPosY + respc(35), panelWidth - respc(10), panelPosY + respc(35) + respc(280) / 10, tocolor(124, 197, 118), 0.8, Roboto, "left", "center")

		for i = 1, 9 do
			local currentModId = i + currentPage
			local modData = toggables[currentModId]
			if i % 2 == 0 then
				dxDrawRectangle(panelPosX + respc(5), panelPosY + respc(280) / 10 * i + respc(35), panelWidth - respc(10), respc(280) / 10, tocolor(55, 55, 55, 200))
			else
				dxDrawRectangle(panelPosX + respc(5), panelPosY + respc(280) / 10 * i + respc(35), panelWidth - respc(10), respc(280) / 10, tocolor(45, 45, 45, 200))
			end

			if modData then
				dxDrawText(modData[1], panelPosX + respc(10), panelPosY + respc(35) + respc(280) / 10 * i, panelWidth - respc(10), panelPosY + respc(35) + respc(280) / 10 * i + respc(280) / 10, tocolor(200, 200, 200, 200), 0.8, Roboto, "left", "center")
				dxDrawText(modData[2], panelPosX + respc(260), panelPosY + respc(35) + respc(280) / 10 * i, panelWidth - respc(10), panelPosY + respc(35) + respc(280) / 10 * i + respc(280) / 10, tocolor(200, 200, 200, 200), 0.8, Roboto, "left", "center")

				--[[if modData[3] then
					dxDrawRectangle(panelPosX + respc(385), panelPosY + respc(35) + respc(280) / 10 * i + respc(5), respc(100), respc(280) / 10 - respc(10), tocolor(215, 89, 89, (activeButton == ("toggleMod_" .. currentModId) and 255 or 225)))
					dxDrawText("Kikapcsolás", panelPosX + respc(385), panelPosY + respc(35) + respc(280) / 10 * i + respc(5), panelPosX + respc(385) + respc(100), panelPosY + respc(35) + respc(280) / 10 * i + respc(5) + respc(280) / 10 - respc(10), tocolor(0, 0, 0), 0.8, Roboto, "center", "center")
				else
					dxDrawRectangle(panelPosX + respc(385), panelPosY + respc(35) + respc(280) / 10 * i + respc(5), respc(100), respc(280) / 10 - respc(10), tocolor(124, 197, 118, (activeButton == ("toggleMod_" .. currentModId) and 255 or 225)))
					dxDrawText("Bekapcsolás", panelPosX + respc(385), panelPosY + respc(35) + respc(280) / 10 * i + respc(5), panelPosX + respc(385) + respc(100), panelPosY + respc(35) + respc(280) / 10 * i + respc(5) + respc(280) / 10 - respc(10), tocolor(0, 0, 0), 0.8, Roboto, "center", "center")
				end]]

				buttons["toggleMod_" .. currentModId] = {
					panelPosX + respc(385),
					panelPosY + respc(35) + respc(280) / 10 * i + respc(5),
					panelPosX + respc(385) + respc(100),
					panelPosY + respc(35) + respc(280) / 10 * i + respc(5) + respc(280) / 10 - respc(10)
				}
			end
		end

		if #toggables > 9 then
			dxDrawRectangle(panelPosX - respc(5) + respc(500) - respc(5), panelPosY + (respc(280) / 10 * 2 + respc(5)), respc(5), respc(280) / 10 * 9, tocolor(0, 0, 0, 200))
			dxDrawRectangle(panelPosX - respc(5) + respc(500) - respc(5), panelPosY + (respc(280) / 10 * 2 + respc(5)) + currentPage * (respc(280) / 10 * 9 / (#toggables - 9 + 1)), respc(5), respc(280) / 10 * 9 / (#toggables - 9 + 1), tocolor(124, 197, 118, 150))
		end
		buttons.allOn = {
			panelPosX - respc(5) + respc(5) + respc(5),
			panelPosY + (respc(280) / 10 * 2 + respc(5)) - (respc(280) / 10 * 2 + respc(5)) + respc(400) - respc(80),
			panelWidth - respc(10), 
			respc(35)
		}

		drawButton("allON", "Összes bekapcsolása", panelPosX - respc(5) + respc(5) + respc(5), panelPosY + (respc(280) / 10 * 2 + respc(5)) - (respc(280) / 10 * 2 + respc(5)) + respc(400) - respc(80), panelWidth - respc(10), respc(35), {61, 122, 188}, false, Roboto, true)
--[[
		dxDrawRectangle(panelPosX - respc(5) + respc(5) + respc(5), panelPosY + (respc(280) / 10 * 2 + respc(5)) - (respc(280) / 10 * 2 + respc(5)) + respc(400) - respc(40), panelWidth - respc(10), respc(35), tocolor(215, 89, 89, (activeButton == "allOff" and 255 or 225)))
		dxDrawText("Összes kikapcsolása", panelPosX - respc(5) + respc(5) + respc(5), panelPosY + (respc(280) / 10 * 2 + respc(5)) - (respc(280) / 10 * 2 + respc(5)) + respc(400) - respc(40), panelPosX - respc(5) + respc(5) + respc(5) + panelWidth - respc(10), panelPosY + (respc(280) / 10 * 2 + respc(5)) - (respc(280) / 10 * 2 + respc(5)) + respc(400) - respc(40) + respc(35), tocolor(0, 0, 0), 0.8, Roboto, "center", "center")
		buttons.allOff = {
			panelPosX - respc(5) + respc(5) + respc(5),
			panelPosY + (respc(280) / 10 * 2 + respc(5)) - (respc(280) / 10 * 2 + respc(5)) + respc(400) - respc(40),
			panelPosX - respc(5) + respc(5) + respc(5) + panelWidth - respc(10),
			panelPosY + (respc(280) / 10 * 2 + respc(5)) - (respc(280) / 10 * 2 + respc(5)) + respc(400) - respc(40) + respc(35)
		}]]

		activeButton = false
		activeButtonC = false

		if cursorX then
			for k, v in pairs(buttons) do
				if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
					activeButton = k
					
					activeButtonC = k

					print(activeButtonC)
					break
				end
			end
		end
	end
end

function onClientKey(key)
	if toggables and cursorX >= panelPosX and cursorX <= panelPosX + panelWidth and cursorY >= panelPosY and cursorY <= panelPosY + panelHeight then
		if key == "mouse_wheel_up" then
			if currentPage > 0 then
				currentPage = currentPage - 1
			end
		elseif key == "mouse_wheel_down" and currentPage < #toggables - 9 then
			currentPage = currentPage + 1
		end
	end
end

function onClientClick(button, state)
	if loadingInProgress then
		return
	end

	if toggables and activeButton and button == "left" and state == "up" then
		local pedveh = getPedOccupiedVehicle(localPlayer)
		local selected = split(activeButton, "_")

		if selected[1] == "toggleMod" then
			local id = toggables[tonumber(selected[2])][4]

			if mods and mods[id] then
				if isElement(pedveh) and mods[id].model == getElementModel(pedveh) then
					exports.sm_hud:showInfobox("e", "Éppen egy ilyen típusú járműben ülsz!")
					return
				end

				if mods[id].state == false then
					mods[id].state = true
					toggleMod(id, true)

					local xmlFile = xmlFindChild(vehiclesXML, mods[id].path, 0) or xmlCreateChild(vehiclesXML, mods[id].path)

					if xmlFile then
						xmlNodeSetValue(xmlFile, "1")
						xmlSaveFile(vehiclesXML)
					end
				else
					unloadMod(id)
					mods[id].state = false
				end

				toggables[tonumber(selected[2])][3] = mods[id].state
			end
		elseif activeButton == "allOff" then
			if isElement(pedveh) then
				exports.sm_hud:showInfobox("e", "Előbb szállj ki a járművedből!")
				return
			end

			for i = 1, #toggables do
				if toggables[i] and mods[toggables[i][4]].state then
					mods[toggables[i][4]].state = false
					unloadMod(toggables[i][4])
					toggables[i][3] = mods[toggables[i][4]].state
				end
			end
		elseif activeButton == "allOn" then
			if isElement(pedveh) then
				exports.sm_hud:showInfobox("e", "Előbb szállj ki a járművedből!")
				return
			end

			for i = 1, #toggables do
				if toggables[i] and not mods[toggables[i][4]].state then
					mods[toggables[i][4]].state = true
					toggables[i][3] = mods[toggables[i][4]].state

					local xmlFile = xmlFindChild(vehiclesXML, mods[toggables[i][4]].path, 0) or xmlCreateChild(vehiclesXML, mods[toggables[i][4]].path)

					if xmlFile then
						xmlNodeSetValue(xmlFile, "1")
						xmlSaveFile(vehiclesXML)
					end
				end
			end

			loadMods()
		elseif activeButton == "close" then
			togglePanel(false)
		end
	end
end

local componentTable = {}

function loadLockedFiles(path, key)
	local file = fileOpen(path)
	local size = fileGetSize(file)
	local FirstPart = fileRead(file, lockString+6)
	fileSetPos(file, lockString+6)
	local SecondPart = fileRead(file, size-(lockString+6))
	fileClose(file)
	return decodeString("tea", FirstPart, { key = key })..SecondPart
end
--[[
local modListPanelState = false

addCommandHandler("modlist",
	function()
		if modListPanelState then
			modListPanelState = false
			
		else
			modListPanelState = true
		end
	end
)

function renderModListPanel()
	dxDrawRectangle(screenW / 2 - respc(600) / 2, screenH / 2 - respc(400) / 2, respc(600), respc(400), tocolor(25, 25, 25))
	dxDrawRectangle(screenW / 2 - respc(600) / 2 + 3, screenH / 2 - respc(400) / 2 + 3, respc(600) - 6, respc(40) - 3, tocolor(45, 45, 45, 180))

	dxDrawRectangle(screenW / 2 - respc(600) / 2 + 3, screenH / 2 - respc(400) / 2 - 3 + respc(400) - respc(40), respc(600) - 6, respc(40), tocolor(35, 35, 35, 150))
	dxDrawText(guiGetText(searchGui), screenW / 2 - respc(600) / 2 + 3 + respc(5), screenH / 2 - respc(400) / 2 - 3 + respc(400) - respc(40) + respc(40) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Roboto, "left", "center")
end
addEventHandler("onClientRender", getRootElement(), renderModListPanel)

Roboto = dxCreateFont("files/Roboto.ttf", respc(12), false, "antialiased")
searchGui = guiCreateEdit(-1000, -1000, 10, 10, "", false)
guiSetAlpha(searchGui, 0)
guiEditSetMaxLength(searchGui, 42)
guiBringToFront(searchGui)
]]