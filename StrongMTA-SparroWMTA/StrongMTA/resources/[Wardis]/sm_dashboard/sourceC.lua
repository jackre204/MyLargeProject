pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

local effectImage = dxCreateTexture("files/images/effect.png")

local loaded_company = {}

local edits = {}

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

renderDataDraw = {
	buttons = {},
	activeButton = false
}

local companyOldDatas = {}
local companyCurrentDatas = {} 
local companyMembersOldDatas = {}
local companyMembersCurrentDatas = {} 

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

local panelState = false

local alpha = 1
local alphaAnim = false

local screenSource = false
local screenShader = false

local Roboto = false
local RobotoL = false
local RobotoB = false

local buttons = {}
local activeButton = false

local selectedTab = 1
local tabCaptions = {"Információ", "Vagyon", "Frakciók", "Adminok", "Háziállatok", "Vállalkozás", "Prémium", "Beállítások"}
local tabPictures = {
	"files/images/tabs/0.png",
	"files/images/tabs/1.png",
	"files/images/tabs/3.png",
	"files/images/tabs/4.png",
	"files/images/tabs/5.png",
	"files/images/tabs/7.png",
	"files/images/tabs/2.png",
	"files/images/tabs/6.png",
}

local playerVehicles = {}
local playerInteriors = {}
local playerGroups = {}
local playerGroupsKeyed = {}
local playerGroupsCount = 0

local groups = {}
local groupTypes = {}

local rankCount = {}

local groupMembers = {}
local meInGroup = {}

local groupVehicles = {}
local monitoredGroupVeh = {}

local myDatas = {}
local myMonitoredDatas = {
	["char.Name"] = true,
	["visibleName"] = true,
	--["char.Age"] = true,
	["char.Job"] = true,
	["char.accID"] = true,
	["char.ID"] = true,
	["char.Skin"] = true,
	["char.playedMinutes"] = true,
	["char.playTimeForPayday"] = true,
	["char.Money"] = true,
	["char.bankMoney"] = true,
	["char.slotCoins"] = true,
	["acc.premiumPoints"] = true,
	["acc.adminLevel"] = true,
	["char.maxVehicles"] = true,
	["char.interiorLimit"] = true,
	--["char.Description"] = true
}

local vehicleDatas = {}
local monitoredDatasForVehicle = {
	["vehicle.dbID"] = true,
	["vehicle.owner"] = true,
	["vehicle.group"] = true,
	["vehicle.maxFuel"] = true,
	["vehicle.fuel"] = true,
	["vehicle.distance"] = true,
	["vehicle.engine"] = true,
	["vehicle.locked"] = true,
	["vehicle.lights"] = true,
	["vehicle.nitroLevel"] = true,
	["vehicle.handBrake"] = true,
	["vehicle.tuning.Engine"] = true,
	["vehicle.tuning.Turbo"] = true,
	["vehicle.tuning.ECU"] = true,
	["vehicle.tuning.Transmission"] = true,
	["vehicle.tuning.Suspension"] = true,
	["vehicle.tuning.Brakes"] = true,
	["vehicle.tuning.Tires"] = true,
	["vehicle.tuning.WeightReduction"] = true,
	["vehicle.tuning.Optical"] = true,
	["vehicle.tuning.AirRide"] = true,
	["tuning.neon"] = true
}

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if panelState or alphaAnim then
			showCursor(false)
			showChat(true)
			exports.sm_hud:showHUD()
		end
	end)

local jobNames = {}

local selectedVeh = 1
local offsetVeh = 0
local tuningName = {"#3d7abcalap", "#3d7abcprofi", "#3d7abcverseny", "#3d7abcvenom", "#3d7abcvenom+sc."}
tuningName[0] = "#3d7abcgyári"

local selectedInt = 1
local offsetInt = 0
local interiorTypes = {
	business_passive = "Passzív Biznisz",
	business_active = "Aktív Biznisz",
	building = "Középület",
	garage = "Garázs",
	building2 = "Zárható Középület",
	rentable = "Bérlakás",
	house = "Ház"
}

local buyingVehicleSlot = false
local buyingInteriorSlot = false

local fakeInputText = ""
local activeFakeInput = false
local fakeInputError = false

local selectedGroup = 1
local offsetGroup = 0

local groupTabs = {"Tagok", "Rangok", "Járművek", "Egyéb"}
local selectedGroupTab = 1

local selectedMember = 1
local offsetMember = 0
local groupButtonCaptions = {"Előléptetés", "Lefokozás", "Kirúgás", "Új tag hozzáadása"}

local selectedRank = 1
local offsetRank = 0
local groupButtonCaptions2 = {"Átnevezés", "Fizetés módosítása"}

local memberFirePrompt = false
local fireErrorText = ""

local selectedGroupVeh = 1
local offsetGroupVeh = 0

local lastChangeCursorState = 0
local cursorState = true

local renderData = {}

renderData.openedTime = 0

renderData.loadedAnimals = {}
renderData.selectedAnimal = 1
renderData.spawnedAnimal = 0
renderData.offsetAnimal = 0
renderData.petDatas = {}

renderData.petNameTypes = {}
renderData.petTypes = {
	["Husky"] = 1,
	["Rottweiler"] = 2,
	["Doberman"] = 3,
	["Bull Terrier"] = 4,
	["Boxer"] = 5,
	["Francia Bulldog"] = 6,
	["Disznó"] = 7,
}

for k, v in pairs(renderData.petTypes) do
	renderData.petNameTypes[v] = k
end

renderData.petPrices = {9000, 6000, 8000, 9000, 7000, 10000}

function fetchAnimals()
	triggerServerEvent("requestAnimals", localPlayer, getElementData(localPlayer, "char.ID"))
end

addEvent("receiveAnimals", true)
addEventHandler("receiveAnimals", getRootElement(),
	function (datas)
		renderData.loadedAnimals = datas
	end)

function fetchGroups()
	playerGroups = exports.sm_groups:getPlayerGroups(localPlayer)
	playerGroupsKeyed = {}
	playerGroupsCount = 0

	if playerGroups then
		triggerServerEvent("requestGroupData", localPlayer, playerGroups)
	end

	for k, v in pairs(playerGroups) do
		playerGroupsCount = playerGroupsCount + 1
		playerGroupsKeyed[playerGroupsCount] = k

		if not playerGroups[selectedGroup] then
			selectedGroup = playerGroupsCount
		end

		groupVehicles[k] = {}
	end

	for k, v in ipairs(getElementsByType("vehicle")) do
		local groupId = getElementData(v, "vehicle.group")

		if groupVehicles[groupId] then
			table.insert(groupVehicles[groupId], v)
			table.insert(monitoredGroupVeh, v)

			vehicleDatas[v] = {}

			for k in pairs(monitoredDatasForVehicle) do
				vehicleDatas[v][k] = getElementData(v, k)
			end

			local vehicleType = getVehicleType(v)

			if vehicleType == "Train" or vehicleType == "Trailer" or vehicleType == "Monster Truck" then
				vehicleType = "Automobile"
			end

			vehicleDatas[v].vehicleType = vehicleType
			vehicleDatas[v].vehicleName = exports.sm_vehiclenames:getCustomVehicleName(getElementModel(v))
		end
	end
end

addEvent("receiveGroups", true)
addEventHandler("receiveGroups", getRootElement(),
	function (datas)
		groups = datas

		if selectedTab == 3 then
			fetchGroups()
		end
	end)

addEvent("receiveGroupMembers", true)
addEventHandler("receiveGroupMembers", getRootElement(),
	function (members, characterId, groupId)
		local onlinePlayers = {}

		for k, v in pairs(getElementsByType("player")) do
			local id = getElementData(v, "char.ID")

			if id then
				onlinePlayers[id] = v
			end
		end

		local me = getElementData(localPlayer, "char.ID")

		for k, v in pairs(members) do
			rankCount[k] = {}

			for k2, v2 in pairs(v) do
				local id = v2.id

				if id == me then
					meInGroup[k] = v2
				end

				if onlinePlayers[id] then
					if getElementData(onlinePlayers[id], "hideOnline") then
						members[k][k2].online = false
					else
						members[k][k2].online = onlinePlayers[id]
					end
				else
					members[k][k2].online = false
				end

				rankCount[k][v2.rank] = (rankCount[k][v2.rank] or 0) + 1
			end
		end

		groupMembers = members

		for k, v in pairs(groupMembers) do
			table.sort(v, function (a, b)
				return a.rank < b.rank
			end)

			for k2, v2 in pairs(v) do
				if k == groupId and v2.id == characterId then
					selectedMember = k2
				end
			end
		end
	end)

addEvent("modifyGroupData", true)
addEventHandler("modifyGroupData", getRootElement(),
	function (groupId, dataType, rankId, data)
		if groups[groupId] then
			if dataType == "rankName" then
				if groups[groupId].ranks[rankId] then
					groups[groupId].ranks[rankId].name = data
				end
			elseif dataType == "rankPayment" then
				if groups[groupId].ranks[rankId] then
					groups[groupId].ranks[rankId].pay = tonumber(data)
				end
			elseif dataType == "description" then
				groups[groupId].description = data
			elseif dataType == "balance" then
				groups[groupId].balance = tonumber(data)
			end
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (data)
		if source == localPlayer and myMonitoredDatas[data] then
			myDatas[data] = getElementData(localPlayer, data)
		end

		if panelState then
			if getElementType(source) == "vehicle" then
				local key = false

				for k, v in pairs(playerVehicles) do
					if v == source then
						key = k
						break
					end
				end

				if tonumber(key) and monitoredDatasForVehicle[data] then
					if getElementData(source, "vehicle.owner") == myDatas["char.ID"] or monitoredGroupVeh[source] then
						if not vehicleDatas[source] then
							vehicleDatas[source] = {}
						end

						vehicleDatas[source][data] = getElementData(source, data)
					else
						playerVehicles[key] = nil
					end
				end
			end
		end

		if getElementType(source) == "ped" then
			local animalId = getElementData(source, "animal.animalId")
			if animalId then
				local ownerId = getElementData(source, "animal.ownerId")
				if ownerId and ownerId == myDatas["char.ID"] then
					renderData.spawnedAnimal = animalId
					renderData.spawnedPetElement = source
					renderData.petDatas[data] = getElementData(source, data)
				end
			end
		end
	end)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if getElementType(source) == "ped" then
			local animalId = getElementData(source, "animal.animalId")
			if animalId then
				local ownerId = getElementData(source, "animal.ownerId")
				if ownerId and ownerId == myDatas["char.ID"] then
					renderData.spawnedAnimal = 0
					renderData.spawnedPetElement = false
					renderData.petDatas = {}
				end
			end
		end
	end)

renderData.clientSettings = {}
renderData.loadedSettings = {}
renderData.offsetSettings = 0

renderData.sayStyle = {"prtial_gngtlka", "prtial_gngtlkb", "prtial_gngtlkc", "prtial_gngtlkd", "prtial_gngtlke", "prtial_gngtlkf", "prtial_gngtlkg", "prtial_gngtlkh", "prtial_hndshk_01", "prtial_hndshk_biz_01", "false"}
renderData.sayStyleEx = {
	["prtial_gngtlka"] = 1,
	["prtial_gngtlkb"] = 2,
	["prtial_gngtlkc"] = 3,
	["prtial_gngtlkd"] = 4,
	["prtial_gngtlke"] = 5,
	["prtial_gngtlkf"] = 6,
	["prtial_gngtlkg"] = 7,
	["prtial_gngtlkh"] = 8,
	["prtial_hndshk_01"] = 9,
	["prtial_hndshk_biz_01"] = 10,
	["false"] = 11,
}

renderData.walkingStyles = {118, 119, 120, 121, 122, 123, 124, 126, 128, 129, 130, 131, 132, 133, 134, 135, 137}

renderData.walkingStylesEx = {
	[118] = 1,
	[119] = 2,
	[120] = 3,
	[121] = 4,
	[122] = 5,
	[123] = 6,
	[124] = 7,
	[126] = 8,
	[128] = 9,
	[129] = 10,
	[130] = 11,
	[131] = 12,
	[132] = 13,
	[133] = 14,
	[134] = 15,
	[135] = 16,
	[137] = 17
}

renderData.fightStyles = {4, 5, 6}
renderData.fightStylesEx = {
	[4] = 1,
	[5] = 2,
	[6] = 3
}

renderData.shaderRealNames = {
	shader_vehicle = {
		"Klasszikus",
		"Normál",
		"Csökkentett"
	},
	shader_water = {
		"Klasszikus",
		"Csökkentett"
	},
	chatType = {
		[-1] = "Kikapcsolva",
		[0] = "Alap",
		[1] = "Custom"
	}
}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if fileExists("config.json") then
			local config = fileOpen("config.json")
			if config then
				renderData.loadedSettings = fromJSON(fileRead(config, fileGetSize(config)))
				fileClose(config)
			end
		else
			local config = fileCreate("config.json")
			if config then
				fileWrite(config, toJSON({}))
				fileClose(config)
			end
		end

		if getElementData(localPlayer, "loggedIn") then
			for k, v in pairs(renderData.loadedSettings) do
				if k == "viewDistance" then
					setFarClipDistance(tonumber(v))
				elseif string.find(k, "shader") then
					if v then
						exports.sm_shader:setActiveShader(k:gsub("shader_", ""), v)
					else
						exports.sm_shader:setActiveShader(k:gsub("shader_", ""), false)
					end
				end
			end
		end
	end)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if fileExists("config.json") then
			fileDelete("config.json")
		end

		local config = fileCreate("config.json")
		if config then
			fileWrite(config, toJSON(renderData.loadedSettings))
			fileClose(config)
		end
	end)

addEventHandler("onClientPlayerSpawn", localPlayer,
	function ()
		for k, v in pairs(renderData.loadedSettings) do
			if k == "viewDistance" then
				setFarClipDistance(tonumber(v))
			elseif string.find(k, "shader") then
				if v then
					exports.sm_shader:setActiveShader(k:gsub("shader_", ""), v)
				else
					exports.sm_shader:setActiveShader(k:gsub("shader_", ""), false)
				end
			end
		end
	end)

function togglePanel()
	if not getElementData(localPlayer, "loggedIn") then
		return
	end

	if alphaAnim then
		return
	end

	if getTickCount() - renderData.openedTime <= 2000 and not panelState then
		outputChatBox("#3d7abc[StrongMTA]: #FFFFFFMaximum 2 másodpercenként nyithatod meg a dashboard-ot.", 0, 0, 0, true)
		playSound("files/sounds/promptdecline.mp3")
		return
	end

	panelState = not panelState

	if panelState then
		renderData.openedTime = getTickCount()

		for k, v in pairs(myMonitoredDatas) do
			myDatas[k] = getElementData(localPlayer, k)
		end

		playerVehicles = {}
		playerInteriors = exports.sm_interiors:requestInteriors(localPlayer)

		for k, veh in ipairs(getElementsByType("vehicle")) do
			if getElementData(veh, "vehicle.owner") == myDatas["char.ID"] then
				table.insert(playerVehicles, veh)

				vehicleDatas[veh] = {}

				for key in pairs(monitoredDatasForVehicle) do
					vehicleDatas[veh][key] = getElementData(veh, key)
				end

				local vehicleType = getVehicleType(veh)

				if vehicleType == "Train" or vehicleType == "Trailer" or vehicleType == "Monster Truck" then
					vehicleType = "Automobile"
				end

				vehicleDatas[veh].vehicleType = vehicleType
				vehicleDatas[veh].vehicleName = exports.sm_vehiclenames:getCustomVehicleName(getElementModel(veh))
			end
		end

		jobNames = exports.sm_jobhandler:getJobNames()
		groupTypes = exports.sm_groups:getGroupTypes()

		for k, v in pairs(playerInteriors) do
			v.data.iconPicture = exports.sm_interiors:getIconByMarkerType(v.data.type)
		end

		if selectedTab == 3 then
			triggerServerEvent("requestGroups", localPlayer)
		elseif selectedTab == 4 then
			getAdmins()
		elseif selectedTab == 5 then
			fetchAnimals()
		elseif selectedTab == 6 then --companyP
			--openCompanyTab()
		end

		activeFakeInput = false
		fakeInputText = ""
		fakeInputError = false
		
		memberFirePrompt = false
		fireErrorText = ""

		renderData.clientSettings = {}
		renderData.crosshairData = getElementData(localPlayer, "crosshairData") or {0, 200,200,200}

		table.insert(renderData.clientSettings, {"Célkereszt", renderData.crosshairData[1] or 0, "crosshair", "crosshair"})

		table.insert(renderData.clientSettings, {"Séta stílus", renderData.walkingStylesEx[getPedWalkingStyle(localPlayer)] or 1, "walkingStyle", true})
		table.insert(renderData.clientSettings, {"Harc stílus", renderData.fightStylesEx[getPedFightingStyle(localPlayer)] or 1, "fightingStyle", true})
		table.insert(renderData.clientSettings, {"Látótávolság", renderData.loadedSettings.viewDistance or getFarClipDistance(), "viewDistance", {100, 3000, "yard"}})

		table.insert(renderData.clientSettings, {"Paletta", renderData.loadedSettings.shader_palette, "shader_palette", true})
		table.insert(renderData.clientSettings, {"HDR Kontraszt", renderData.loadedSettings.shader_contrast, "shader_contrast"})
		table.insert(renderData.clientSettings, {"Bloom", renderData.loadedSettings.shader_bloom, "shader_bloom"})
		table.insert(renderData.clientSettings, {"Karosszéria tükröződés", renderData.loadedSettings.shader_vehicle, "shader_vehicle", true})
		table.insert(renderData.clientSettings, {"Valósághűbb víz", renderData.loadedSettings.shader_water, "shader_water", true})
		table.insert(renderData.clientSettings, {"Részletes HD textúrák", renderData.loadedSettings.shader_detail, "shader_detail"})
		table.insert(renderData.clientSettings, {"Mozgási elmosódás", renderData.loadedSettings.shader_radial, "shader_radial"})
		table.insert(renderData.clientSettings, {"Mélységélesség", renderData.loadedSettings.shader_dof, "shader_dof"})

		table.insert(renderData.clientSettings, {"Chat típus", exports.sm_hud:getChatType(), "chatType", true})
		table.insert(renderData.clientSettings, {"Custom chat háttér", reMap(exports.sm_hud:getChatBackgroundAlpha(), 0, 255, 0, 100), "chatBackgroundAlpha", {0, 100, "%"}})
		table.insert(renderData.clientSettings, {"Custom chat árnyék", reMap(exports.sm_hud:getChatFontBackgroundAlpha(), 0, 255, 0, 100), "chatFontBackgroundAlpha", {0, 100, "%"}})
		table.insert(renderData.clientSettings, {"Custom chat betűméret", exports.sm_hud:getChatFontSize(), "chatFontSize", {50, 135, "%"}})
		table.insert(renderData.clientSettings, {"Beszéd animáció", renderData.sayStyleEx[getElementData(localPlayer, "talkingAnim")], "sayStyle", true})

		renderData.chatInstance = exports.sm_hud:getChatInstance()

		if renderData.chatInstance then
			executeBrowserJavascript(renderData.chatInstance, "document.getElementById(\"preview\").style.visibility = \"visible\";")
			executeBrowserJavascript(renderData.chatInstance, "document.getElementById(\"actual\").style.visibility = \"hidden\";")
		end

		Roboto = dxCreateFont("files/fonts/Roboto.ttf", respc(17.5), false, "antialiased")
		RobotoL = dxCreateFont("files/fonts/RobotoL.ttf", respc(17.5), false, "antialiased")
		RobotoB = dxCreateFont("files/fonts/RobotoB.ttf", respc(26), false, "antialiased")
		RobotoB2 = dxCreateFont("files/fonts/RobotoB.ttf", respc(17.5), false, "antialiased")

		screenSource = dxCreateScreenSource(screenX, screenY)
		screenShader = dxCreateShader(":sm_hud/files/shaders/monochrome.fx")
		dxSetShaderValue(screenShader, "screenSource", screenSource)

		serverLogo = exports.sm_core:getServerLogo()

		addEventHandler("onClientRender", getRootElement(), onRenderHandler, true, "low-100000")
		addEventHandler("onClientKey", getRootElement(), editBoxesKey)
		addEventHandler("onClientCharacter", getRootElement(), editBoxesCharacter)
		addEventHandler("onClientClick", getRootElement(), onClickHandler)
		addEventHandler("onClientCharacter", getRootElement(), handleInputs)

		playSound("files/sounds/open.mp3")
		alphaAnim = {getTickCount(), 0, 1}
	else
		exports.sm_hud:setChatBackgroundAlpha(reMap(renderData.clientSettings[14][2], 0, 100, 0, 255))
		exports.sm_hud:setChatFontBackgroundAlpha(reMap(renderData.clientSettings[15][2], 0, 100, 0, 255))
		exports.sm_hud:setChatFontSize(renderData.clientSettings[16][2])
		if renderData.chatInstance then
			executeBrowserJavascript(renderData.chatInstance, "document.getElementById(\"preview\").style.visibility = \"hidden\";")
			executeBrowserJavascript(renderData.chatInstance, "document.getElementById(\"actual\").style.visibility = \"visible\";")
		end

		playSound("files/sounds/close.mp3")
		alphaAnim = {getTickCount(), 1, 0}
	end

	if selectedTab == 6 then --companyP
		buySlot = false
		selectedSlot = 1
		if panel then
			panel = false
			dxDestroyEdit("companyName")
			dxDestroyEdit("newPlayer")
			dxDestroyEdit("companyBalance")
			dxDestroyEdit("payTax")
			dxDestroyEdit("renameRank")
			dxDestroyEdit("reprecentRank")
			dxDestroyEdit("rewriteMessage")
			payTaxes = false
		end
	end
	showCursor(panelState)
	showChat(not panelState)

	if panelState then
		exports.sm_hud:hideHUD()
	else
		exports.sm_hud:showHUD()
	end

	buttons = {}
	activeButton = false
end

function getAdmins()
	local gotAdmins = {}

	gotAdmins["as1"] = {}
	gotAdmins["as2"] = {}

	for i = 1, 7 do
		gotAdmins[i] = {}
	end

	for k, v in ipairs(getElementsByType("player")) do
		if not getElementData(v, "hideOnline") then
			local level = getElementData(v, "acc.adminLevel") or 0

			if level > 0 and level <= 7 then
				table.insert(gotAdmins[level], v)
			else
				local level2 = getElementData(v, "acc.helperLevel") or 0

				if level2 > 0 then
					table.insert(gotAdmins["as" .. level2], v)
				end
			end
		end
	end

	renderData.adminSlots = {}

	table.insert(renderData.adminSlots, {"title", "Ideiglenes adminsegédek"})
	
	if #gotAdmins["as1"] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins["as1"]) do
			table.insert(renderData.adminSlots, {"as", "#f49ac1" .. getElementData(v, "char.Name"):gsub("_", " ") .. "#ffffff (" .. getElementData(v, "playerID") .. ")"})
		end
	end

	table.insert(renderData.adminSlots, {"title", "S.G.H. adminsegédek"})
	
	if #gotAdmins["as2"] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins["as2"]) do
			table.insert(renderData.adminSlots, {"as", "#f49ac1" .. getElementData(v, "char.Name"):gsub("_", " ") .. "#ffffff (" .. getElementData(v, "playerID") .. ")"})
		end
	end

	table.insert(renderData.adminSlots, {"title", "1-es adminok"})
	
	if #gotAdmins[1] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins[1]) do
			if getElementData(v, "adminDuty") == 1 then
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(1) .. getElementData(v, "acc.adminNick") .. "#ffffff (" .. getElementData(v, "playerID") .. ")", true})
			else
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(1) .. getElementData(v, "acc.adminNick"), false})
			end
		end
	end

	table.insert(renderData.adminSlots, {"title", "2-es adminok"})
	
	if #gotAdmins[2] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins[2]) do
			if getElementData(v, "adminDuty") == 1 then
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(2) .. getElementData(v, "acc.adminNick") .. "#ffffff (" .. getElementData(v, "playerID") .. ")", true})
			else
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(2) .. getElementData(v, "acc.adminNick"), false})
			end
		end
	end

	table.insert(renderData.adminSlots, {"title", "3-as adminok"})
	
	if #gotAdmins[3] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins[3]) do
			if getElementData(v, "adminDuty") == 1 then
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(3) .. getElementData(v, "acc.adminNick") .. "#ffffff (" .. getElementData(v, "playerID") .. ")", true})
			else
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(3) .. getElementData(v, "acc.adminNick"), false})
			end
		end
	end

	table.insert(renderData.adminSlots, {"title", "4-es adminok"})
	
	if #gotAdmins[4] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins[4]) do
			if getElementData(v, "adminDuty") == 1 then
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(4) .. getElementData(v, "acc.adminNick") .. "#ffffff (" .. getElementData(v, "playerID") .. ")", true})
			else
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(4) .. getElementData(v, "acc.adminNick"), false})
			end
		end
	end

	table.insert(renderData.adminSlots, {"title", "5-ös adminok"})
	
	if #gotAdmins[5] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins[5]) do
			if getElementData(v, "adminDuty") == 1 then
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(5) .. getElementData(v, "acc.adminNick") .. "#ffffff (" .. getElementData(v, "playerID") .. ")", true})
			else
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(5) .. getElementData(v, "acc.adminNick"), false})
			end
		end
	end

	table.insert(renderData.adminSlots, {"title", "Főadminok"})
	
	if #gotAdmins[6] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins[6]) do
			if getElementData(v, "adminDuty") == 1 then
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(6) .. getElementData(v, "acc.adminNick") .. "#ffffff (" .. getElementData(v, "playerID") .. ")", true})
			else
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(6) .. getElementData(v, "acc.adminNick"), false})
			end
		end
	end

	table.insert(renderData.adminSlots, {"title", "SuperAdminok"})
	
	if #gotAdmins[7] < 1 then
		table.insert(renderData.adminSlots, {"center", "Nincs online"})
	else
		for k, v in ipairs(gotAdmins[7]) do
			if getElementData(v, "adminDuty") == 1 then
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(7) .. getElementData(v, "acc.adminNick") .. "#ffffff (" .. getElementData(v, "playerID") .. ")", true})
			else
				table.insert(renderData.adminSlots, {"admin", exports.sm_administration:getAdminLevelColor(7) .. getElementData(v, "acc.adminNick"), false})
			end
		end
	end
end

function rgba(r, g, b, a)
	return tocolor(r, g, b, (a or 255) * alpha)
end

function handleInputs(character)
	if buyingVehicleSlot or buyingInteriorSlot or sellVehicleToCompanyPlayer then
		local newText = fakeInputText .. character

		if tonumber(newText) then
			if tonumber(newText) >= 1 and not string.find(newText, "e") and tonumber(newText) <= 1000 then
				fakeInputText = newText
			end
		end
	end

	if activeFakeInput == "inviting" then
		if string.len(fakeInputText) <= 20 then
			fakeInputText = fakeInputText .. character
		end
	elseif activeFakeInput == "setrankname" then
		if utf8.len(fakeInputText) <= 20 and not string.find(character, ",") then
			fakeInputText = fakeInputText .. character
		end
	elseif activeFakeInput == "setrankpay" then
		if string.len(fakeInputText) <= 20 and tonumber(character) then
			fakeInputText = fakeInputText .. character
		end
	elseif activeFakeInput == "groupdesc" then
		if utf8.len(fakeInputText) <= 300 then
			fakeInputText = fakeInputText .. character
		end
	elseif activeFakeInput == "groupbalance" then
		if string.len(fakeInputText) <= 20 and tonumber(character) then
			fakeInputText = fakeInputText .. character
		end
	end

	if tonumber(renderData.buyDogType) then
		if not tonumber(character) then
			if utf8.len((renderData.dogName or "")) <= 20 then
				renderData.dogName = (renderData.dogName or "") .. character
			end
		end
	end

	if renderData.renamingPet then
		if not tonumber(character) then
			if utf8.len((renderData.newDogName or "")) <= 20 then
				renderData.newDogName = (renderData.newDogName or "") .. character
			end
		end
	end
end

addEvent("buySlotOK", true)
addEventHandler("buySlotOK", getRootElement(),
	function ()
		buyingVehicleSlot = false
		sellVehicleToCompanyPlayer = false
		buyingInteriorSlot = false
		fakeInputText = ""
	end)

local findVehicleId = false
local locatorElements = {}

addEventHandler("onClientElementDestroy", getResourceRootElement(),
	function ()
		for i = 1, #locatorElements do
			local data = locatorElements[i]

			if data and source == data[3] then
				for j = 1, 2 do
					if isElement(data[j]) then
						destroyElement(data[j])
					end
				end
			end
		end
	end)

addEventHandler("onClientMarkerHit", getResourceRootElement(),
	function (hitPlayer, matchingDimension)
		if hitPlayer == localPlayer and matchingDimension then
			for i = 1, #locatorElements do
				local data = locatorElements[i]

				if data and source == data[2] then
					for j = 1, 2 do
						if isElement(data[j]) then
							destroyElement(data[j])
						end
					end

					exports.sm_hud:showInfobox("s", "Sikeresen megérkeztél a járművedhez!")
					break
				end
			end
		end
	end)

renderData.canSelectDutySkin = false
renderData.dutySkinMarker = false

local bincoColShape = createColSphere(207.306640625, -100.328125, 1005.2578125, 4)
setElementInterior(bincoColShape, 15)
setElementDimension(bincoColShape, 14)

addEventHandler("onClientColShapeHit", getRootElement(),
	function (hitElement, matchingDimension)
		if hitElement == localPlayer then
			if isElement(source) then
				if matchingDimension then
					if source == bincoColShape then
						renderData.canSelectDutySkin = true
						renderData.dutySkinMarker = false
					else
						local groupId = getElementData(source, "groupId")

						if groupId then
							renderData.canSelectDutySkin = true
							renderData.dutySkinMarker = groupId
						end
					end
				end
			end
		end
	end)

addEventHandler("onClientColShapeLeave", getRootElement(),
	function (hitElement, matchingDimension)
		if hitElement == localPlayer then
			if isElement(source) then
				if source == bincoColShape or getElementData(source, "groupId") then
					renderData.canSelectDutySkin = false
					renderData.dutySkinMarker = false
				end
			end
		end
	end)

local bankCols = {
	createColSphere(2474.9501953125, 1029.6218261719, -1.5933448076248, 10),
	createColSphere(-178.04180908203, 1133.0228271484, 13.118314743042, 10)
}

addEvent("setInputError", true)
addEventHandler("setInputError", getRootElement(),
	function (msg)
		if panelState and selectedTab == 3 and selectedGroupTab == 4 then
			fakeInputError = msg
		end
	end)

addEvent("buyDogNoPP", true)
addEventHandler("buyDogNoPP", getRootElement(),
	function ()
		renderData.buyDogProcessing = false
		playSound("files/sounds/notification.mp3")
	end)

addEvent("buyDogOK", true)
addEventHandler("buyDogOK", getRootElement(),
	function ()
		renderData.buyingPet = false
		renderData.dogName = ""
		renderData.buyDogType = false
		renderData.buyDogProcessing = false
		renderData.renamingPet = false

		playSound("files/sounds/notification.mp3")

		if panelState then
			togglePanel()
		end
	end)

addEvent("toggleDashboardOff", true)
addEventHandler("toggleDashboardOff", getRootElement(),
	function ()
		if panelState then
			togglePanel()
		end
	end)

addEvent("buyPetReviveNoPP", true)
addEventHandler("buyPetReviveNoPP", getRootElement(),
	function ()
		renderData.buyReviveProcessing = false
		playSound("files/sounds/notification.mp3")
	end)

addEvent("buyPetReviveOK", true)
addEventHandler("buyPetReviveOK", getRootElement(),
	function ()
		renderData.buyReviveProcessing = false
		renderData.buyingPetRevive = false
		playSound("files/sounds/notification.mp3")
	end)

addEvent("gpsLocalizeCar", true)
addEventHandler("gpsLocalizeCar", getRootElement(),
	function ()
		for i = 1, #locatorElements do
			local data = locatorElements[i]

			if data and source == data[3] then
				for j = 1, 2 do
					if isElement(data[j]) then
						destroyElement(data[j])
					end
				end
			end
		end

		local x, y, z = getElementPosition(source)
		local blip = createBlip(x, y, z, _, _, 255, 125, 0)

		attachElements(blip, source)
		setElementData(blip, "blipTooltipText", "Járműved (#" .. getElementData(source, "vehicle.dbID") .. ")", false)

		local marker = createMarker(x, y, z, "checkpoint", 4, 255, 125, 0, 100)
		attachElements(marker, source)

		table.insert(locatorElements, {blip, marker, source})
	end)

function onClickHandler(button, state)
	if button == "right" and state == "up" then
		if activeButton then
			if string.find(activeButton, "selectVehicle") then
				findVehicleId = tonumber(gettok(activeButton, 2, ":"))

				if isElement(playerVehicles[findVehicleId]) then
					triggerEvent("gpsLocalizeCar", playerVehicles[findVehicleId])
					exports.sm_accounts:showInfo("s", "Járműved lokalizálva! Keresd a NARANCSSÁRGA jelzésnél.")
				end
			end
		end
	end
	--wardis button
	maxLine = maxLine or 0
	if button == "left" then
		if state == "down" then
			if page == 2 or page == 3 or page == 4 then
				local companyVehicles = getCompanyVehicles(loaded_company["id"])
				for i = 1, maxLine do
					if localPlayerBoxButtom then
						local player = loaded_company["membersCount"][localPlayerBoxButtom + scroll]
						local vehicle = companyVehicles[i + scroll]
						local rank = loaded_company["ranks"][tostring(i + scroll)]
						if player and page == 2 then
							if selected ~= localPlayerBoxButtom + scroll then
								outputChatBox(localPlayerBoxButtom)
								selected = localPlayerBoxButtom + scroll
								dxDestroyEdit("payTax")
								payTaxes = false
							end
						elseif rank and page == 3 then
							if selected ~= localPlayerBoxButtom + scroll then
								outputChatBox(localPlayerBoxButtom)
								selected = localPlayerBoxButtom + scroll
								payTaxes = false
							end	
						elseif vehicle and page == 4 then
							if selected ~= localPlayerBoxButtom + scroll then
								outputChatBox(localPlayerBoxButtom)
								selected = localPlayerBoxButtom + scroll
								payTaxes = false
							end
						end
					end
				end
			end
			if activeButtonC == "plusSlot" then
				selectedSlot = selectedSlot + 1
			elseif activeButtonC == "minusSlot" then
				if selectedSlot >= 2 then
					selectedSlot = selectedSlot - 1
				end
			elseif activeButtonC == "sellVehicle" then	
				local companyVehicles = getCompanyVehicles(loaded_company["id"])
				if playerHavePermission() then
					if getElementData(companyVehicles[selected],"company.rent") <= 0 then
						triggerServerEvent("sellVehicleToShop",resourceRoot,localPlayer,getElementData(companyVehicles[selected],"company.vehicleID"))
						scroll = 0
						selected = 0
						outputChatBox("Sikeresen eladtad a kiválasztott járművet!")
					else
						outputChatBox("Bérelt járművet nem adhatsz el!")
					end
				end	
			elseif activeButtonC == "buyTheSlots" then
				triggerServerEvent("tryBuySlot", resourceRoot, localPlayer, loaded_company["id"], buySlot, selectedSlot)
				buySlot = false
				triggerServerEvent("getCompanyDatas", resourceRoot, localPlayer, loaded_company["id"], false)
			elseif activeButtonC == "addMemberToCompany" then
				local text = dxGetEditText("newPlayer")
                local player = findPlayerToCompany(text)
                if player then
                    if tonumber(getElementData(player,"char.CompanyID")) > 0 then
						outputChatBox("A játékos már egy vállalkozás tagja.")
                    else
                        if #loaded_company["membersCount"] < loaded_company["memberSlot"] then
                            outputChatBox("Sikeresen felvetted '" .. getElementData(player,"char.Name"):gsub("_"," ") .. "' nevű játékost a vállalkozásodba!")
                            triggerServerEvent("inviteToCompany",resourceRoot,localPlayer,player,loaded_company["id"],loaded_company["name"])
                            triggerServerEvent("insertTransaction",resourceRoot,loaded_company["id"],getElementData(localPlayer,"char.Name"):gsub("_"," ") .. " felvette '" .. getElementData(player,"char.Name"):gsub("_"," ") .. "' nevű tagot a vállalkozásba!")
                        else
                            outputChatBox("Nincs több hely a vállalkozásodban!")
                        end
                    end
                end
			elseif activeButtonC == "buyLevel" then		
				buySlot = "level"
			elseif activeButtonC == "buyVehSlot" then
				buySlot = "vehicle"
			elseif activeButtonC == "payPlayerTransEnter" then
				local player = loaded_company["membersCount"][selected]
				local playerRankNum = tonumber((player.rank))
				local online_player = findPlayerByName(player.name)
				local text = dxGetEditText("payTax")
				if tonumber(text) then
					text = tonumber(text)
					if text <= 31 then
						local price = taxesByRank[player.rank] * text
						if loaded_company["balance"] >= price then
							if player.taxPayed < getTimestamp() then
								loaded_company["balance"] = loaded_company["balance"] - price
								triggerServerEvent("editBalance",resourceRoot,loaded_company["id"],loaded_company["balance"])
								outputChatBox("Sikeresen befizetted a járulékot '" .. player.name:gsub("_"," ") .. "' nevű játékos után " .. text .. " napra!")

								if online_player then
									triggerServerEvent("payTaxesForPlayer",resourceRoot,localPlayer,online_player,text,getElementData(online_player,"char.CompanyTaxPayed"))
								else
									triggerServerEvent("payTaxesForPlayer",resourceRoot,localPlayer,player.dbid,text)
								end

								triggerServerEvent("insertTransaction",resourceRoot,loaded_company["id"],getElementData(localPlayer,"char.Name"):gsub("_"," ") .. " befizette a járulékokat '" .. player.name:gsub("_"," ") .. "' nevű tag után, " .. text .. " napra!")

								payTaxes = false
								dxDestroyEdit("payTax")
							else
								outputChatBox("Ennél a tagnál már be van fizetve a járulék. Ameddig nem jár le nem fizethetsz be újat!")
							end
						else
							outputChatBox("Nincs elegendő egyenleg a vállalkozás számláján!")
						end
					else
						outputChatBox("Egy évnél többet előre nem fizethetsz!")
					end
				else
					outputChatBox("Hibás összeg lett megadva.")
				end
			elseif activeButtonC == "payPlayerTrans" then
				if not payTaxes then
					payTaxes = true
					dxCreateEdit("payTax","","Írd be hány napig fizeted be..", posTableFromRender[1], posTableFromRender[2], posTableFromRender[3], posTableFromRender[4], 11)
				else
					payTaxes = false
					dxDestroyEdit("payTax")
				end
			elseif activeButtonC == "kickPlayer" then
				local player = loaded_company["membersCount"][selected]
				local playerRankNum = tonumber((player.rank))
				local online_player = findPlayerByName(player.name)
				if online_player then
					if online_player == localPlayer then
						outputChatBox("Saját magadat nem rúghatod ki!")
					else
						triggerServerEvent("kickPlayerFromCompany",resourceRoot,online_player)
					end
				else
					if loaded_company["leader"] == player.dbid then
						outputChatBox("A leadert nem rúghatod ki!")
					else
						triggerServerEvent("kickPlayerFromCompany",resourceRoot,player.dbid)
					end
				end
				table.remove(loaded_company["membersCount"],selected)
				selected = 0
				outputChatBox("Sikeresen kirugtad '" .. player.name:gsub("_"," ") .. "' nevű játékost a vállalkozásodból!")
				triggerServerEvent("insertTransaction",resourceRoot,loaded_company["id"],getElementData(localPlayer,"char.Name"):gsub("_"," ") .. " kirúgta '" .. player.name:gsub("_"," ") .. "' nevű tagot a vállalkozásból!")

			elseif activeButtonC == "rankMinus" then
				local player = loaded_company["membersCount"][selected]
				local playerRankNum = tonumber((player.rank))
				local online_player = findPlayerByName(player.name)
				if playerRankNum > 1 then
					if online_player then
						triggerServerEvent("decratePlayer",resourceRoot,localPlayer,loaded_company["id"],online_player,getElementData(online_player,"char.CompanyRank"),player.name)
						player.rank = player.rank - 1
					else
						triggerServerEvent("decratePlayer",resourceRoot,localPlayer,loaded_company["id"],player.dbid,playerRankNum,player.name)
						player.rank = player.rank - 1
					end
					playerRankNum = playerRankNum - 1
					outputChatBox("Sikeresen lefokoztad a kiválasztott játékost.")
				else
					outputChatBox("A játékos már a legkissebb rangon van")
				end
			elseif activeButtonC == "rankUp" then
				local player = loaded_company["membersCount"][selected]
				local playerRankNum = tonumber((player.rank))
				local online_player = findPlayerByName(player.name)
				iprint(player.dbid)
				
				if playerRankNum < 5 then
					if online_player then
						triggerServerEvent("promotePlayer",resourceRoot,localPlayer,loaded_company["id"],online_player,getElementData(online_player,"char.CompanyRank"),player.name)
						player.rank = player.rank + 1
					else
						triggerServerEvent("promotePlayer",resourceRoot,localPlayer,loaded_company["id"],player.dbid,playerRankNum,player.name)
						player.rank = player.rank + 1
					end
					playerRankNum = playerRankNum + 1
					outputChatBox("Sikeresen előléptetted a kiválasztott játékost.")
				else
					outputChatBox("A játékos már a legmagasabb rangon van")
				end
			elseif activeButtonC == "buyMemberSlot" then
				buySlot = "member"
			elseif activeButtonC == "updatePay" then
				local text = dxGetEditText("reprecentRank")
				if tonumber(text) then
					text = tonumber(text)
					if text >= 0 then
						if text <= 100 then
							triggerServerEvent("insertTransaction",resourceRoot,loaded_company["id"],getElementData(localPlayer,"char.Name"):gsub("_"," ") .. " átírta a '" .. loaded_company["ranks"][tostring(selected)].name .. "' nevű rang részesedését! (" .. loaded_company["ranks"][tostring(selected)].precent .. "% -> " .. text .. "%)")

							loaded_company["ranks"][tostring(selected)].precent = text
							dxEditSetText("reprecentRank","")
							outputChatBox("Sikeresen átírtad a kiválasztott rang részesedését!")
							triggerServerEvent("editRanks",resourceRoot,loaded_company["id"],loaded_company["ranks"])
						else
							outputChatBox("Hibás összeg lett megadva.")
						end
					else
						outputChatBox("Hibás összeg lett megadva.")
					end
				else
					outputChatBox("Hibás összeg lett megadva.")
				end
			elseif activeButtonC == "progressMessage" then
				local text = dxGetEditText("rewriteMessage")
                loaded_company["message"] = text
                triggerServerEvent("changeCompanyText", resourceRoot, loaded_company["id"], text)
                dxEditSetText("rewriteMessage","")
                outputChatBox("Sikeresen átállítottad a vállalkozás üzenetet!")
                triggerServerEvent("insertTransaction", resourceRoot,loaded_company["id"], getElementData(localPlayer,"char.Name"):gsub("_"," ") .. " átírta a vállalkozás üzenetét!")
			elseif activeButtonC == "renameRankB" then	
				local text = dxGetEditText("renameRank")
				if #text > 0 then
					if #text <= 20 then
						triggerServerEvent("insertTransaction",resourceRoot,loaded_company["id"],getElementData(localPlayer,"char.Name"):gsub("_"," ") .. " átnevezett egy rangot! (" .. loaded_company["ranks"][tostring(selected)].name .. " -> " .. text .. ")")

						loaded_company["ranks"][tostring(selected)].name = text
						dxEditSetText("renameRank","")
						outputChatBox("Sikeresen átírtad a kiválasztott rang nevét!")
						triggerServerEvent("editRanks",resourceRoot,loaded_company["id"],loaded_company["ranks"])
					else
						outputChatBox("A rang nem lehet több 12 karakternél!")
					end
				else
					outputChatBox("A rang nevének legalább 1 karakterből kell állnia!")
				end
			elseif isInSlot(screenX / 2 - respc(350) / 2 + respc(350) - respc(30), screenY / 2 - respc(175) / 2, respc(35), respc(40)) then
				selectedSlot = 1
				buySlot = false
			elseif activeButtonC == 1 or activeButtonC == 2 or activeButtonC == 3 or activeButtonC == 4 or activeButtonC == 5 then
				if activeButtonC ~= page then
					page = activeButtonC
					if companyOldDatas ~= companyCurrentDatas then
						loaded = false
						--loaded_company["membersCount"] = {}
					end
				scroll = 0
				selected = 0
				triggerServerEvent("getCompanyDatas", resourceRoot, localPlayer, loaded_company["id"], false)
				payTaxes = false
				dxDestroyEdit("newPlayer")
				dxDestroyEdit("companyBalance")
				dxDestroyEdit("payTax")
				dxDestroyEdit("renameRank")
				dxDestroyEdit("reprecentRank")
				dxDestroyEdit("rewriteMessage")
				if activeButtonC == 1 then
					if playerHavePermission() then
						local sx, sy = screenX - respc(60), screenY - respc(60)
						local x = screenX / 2 - sx / 2
						local y = screenY / 2 - sy / 2
						local y = y + respc(80)
						local skinHolderSizeX = respc(240)
						local holderSizeY = screenY - respc(240)
						local marginMul = 2.2
						local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
						local oneSegmentSizeY = holderSizeY
	
						local sx2 = skinHolderSizeX * marginMul - respc(20)
						local x2 = x + sx - skinHolderSizeX * marginMul
						local y = y + respc(80)
						local boxesSize = ((oneSegmentSizeY - (8 * 10)) / 9)
						dxCreateEdit("companyBalance", "", "Írd be a kivánt összeget..",x2 + 8, y + (boxesSize + 8) * 3 + 8, sx2 - 16, boxesSize)
						dxCreateEdit("newPlayer", "", "Játékos ID/Név", x2 + 8, y + (boxesSize + 8) * 7 + 8, sx2 - 16, boxesSize)
					end
				elseif activeButtonC == 3 then
					selected = 1
					if playerHavePermission() then
						local sx, sy = screenX - respc(60), screenY - respc(60)
						local x = screenX / 2 - sx / 2
						local y = screenY / 2 - sy / 2
						local y = y + respc(80)
						local skinHolderSizeX = respc(240)
						local holderSizeY = screenY - respc(240)
						local marginMul = 2.2
						local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
						local oneSegmentSizeY = holderSizeY

						local sx2 = skinHolderSizeX * marginMul - respc(20)
						local x2 = x + sx - skinHolderSizeX * marginMul
						--local y = y + respc(80)
						local boxesSize = (oneSegmentSizeY - (9 * 16)) / 8
						local oneSize = oneSegmentSizeY / 12
						local startX = skinHolderSizeX * marginMul + respc(50)
						local startY = y + respc(80) + screenY - respc(240) - 5
						--rank name
						dxCreateEdit("reprecentRank", "", "Írd be a rang új részesedését..", startX + 5, startY - (oneSize * 4) - 15, oneSegmentSizeX - 10, oneSize, 13)
						
						dxCreateEdit("renameRank", "", "Írd be a rang új nevét..", startX + 5, startY - (oneSize * 2) - 5, oneSegmentSizeX - 10, oneSize, 13)
						local maxLine = 5
						local skinHolderSizeX = respc(240)
						local holderSizeY = screenY-respc(240)
						local marginMul = 2.2
						local startX = x + respc(20)
						local startY = y + respc(80)
						local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
						local oneSegmentSizeY = holderSizeY
						dxCreateEdit("rewriteMessage", "", "Írd be az új vállalkozás üzenetet..", startX, startY + ((oneSegmentSizeY / 15) * maxLine) + respc(20) + (oneSegmentSizeY / 15) + (oneSegmentSizeY) / 3 + 5, skinHolderSizeX * marginMul - respc(20), oneSize, 13)
						
					end
				end 
			end
			elseif activeButtonC == "setMoney" then
				local text = dxGetEditText("companyBalance")
				if tonumber(text) then
					text = tonumber(text)
					if text > 0 then
						if getElementData(localPlayer,"char.Money") >= text then
							triggerServerEvent("updateBalance",resourceRoot,localPlayer,loaded_company["id"],loaded_company["balance"],text,"+")
							triggerServerEvent("insertTransaction",resourceRoot,loaded_company["id"],getElementData(localPlayer,"char.Name"):gsub("_"," ") .. " befizetett " .. formatNumber(text) .. " $ összeget a vállalkozás számlájára!")
							loaded_company["balance"] = loaded_company["balance"] + text
							dxEditSetText("companyBalance","")
						else
							outputChatBox("Nincs elegendő készpénzed!")
						end
					else
						outputChatBox("Hibás összeg lett megadva!")
					end
				else
					outputChatBox("Hibás összeg lett megadva!")
				end
			elseif activeButtonC == "giveMoney" then
				local text = dxGetEditText("companyBalance")
				if tonumber(text) then
					text = tonumber(text)
					if text > 0 then
						if loaded_company["balance"] >= text then
							triggerServerEvent("updateBalance",resourceRoot,localPlayer,loaded_company["id"],loaded_company["balance"],text,"-")
							triggerServerEvent("insertTransaction",resourceRoot,loaded_company["id"],getElementData(localPlayer,"char.Name"):gsub("_"," ") .. " kivett " .. formatNumber(text) .. " $ összeget a vállalkozás számlájáról!")
							loaded_company["balance"] = loaded_company["balance"] - text
							dxEditSetText("companyBalance","")
						else
							outputChatBox("Nincs elegendő összeg a vállalkozás számláján!")
						end
					else
						outputChatBox("Hibás összeg lett megadva!")
					end
				else
					outputChatBox("Hibás összeg lett megadva!")
				end
			end
		end
		if activeButton then
			local buttonDetails = split(activeButton, ":")

			if state == "down" then
				if buttonDetails[1] == "openMyClothes" then
					togglePanel()
					executeCommandHandler("cuccaim")
					return
				end
				--wardis

				if buttonDetails[1] == "selectVehicle" then
					local vehicleId = tonumber(buttonDetails[2])

					if selectedVeh ~= vehicleId then
						selectedVeh = vehicleId
						playSound("files/sounds/switchoption.mp3")
					end
				end

				if buttonDetails[1] == "selectInterior" then
					local interiorId = tonumber(buttonDetails[2])

					if selectedInt ~= interiorId then
						selectedInt = interiorId
						playSound("files/sounds/switchoption.mp3")
					end
				end

				if buttonDetails[1] == "selectGroup" then
					local groupId = tonumber(buttonDetails[2])

					if selectedGroup ~= groupId then
						selectedGroup = groupId
						playSound("files/sounds/switchoption.mp3")
					end
				end

				if buttonDetails[1] == "selectGroupTab" then
					local tabId = tonumber(buttonDetails[2])

					if selectedGroupTab ~= tabId then
						selectedGroupTab = tabId

						activeFakeInput = false
						fakeInputText = ""
						fakeInputError = false

						memberFirePrompt = false
						fireErrorText = ""

						playSound("files/sounds/menuswitch2.mp3")
					end
				end

				if buttonDetails[1] == "selectMember" then
					local memberId = tonumber(buttonDetails[2])

					if selectedMember ~= memberId then
						selectedMember = memberId
						playSound("files/sounds/switchoption.mp3")
					end
				end

				if buttonDetails[1] == "selectRank" then
					local rankId = tonumber(buttonDetails[2])

					if selectedRank ~= rankId then
						selectedRank = rankId
						playSound("files/sounds/switchoption.mp3")
					end
				end

				if buttonDetails[1] == "selectGroupVeh" then
					local vehicleId = tonumber(buttonDetails[2])

					if selectedGroupVeh ~= vehicleId then
						selectedGroupVeh = vehicleId
						playSound("files/sounds/switchoption.mp3")
					end
				end

				if activeButton == "more_vehslot" then
					if not buyingVehicleSlot then
						buyingVehicleSlot = true
						fakeInputText = ""
						playSound("files/sounds/prompt.mp3")
					end
				elseif activeButton == "cancel_veh_slot" then
					buyingVehicleSlot = false
					fakeInputText = ""
					playSound("files/sounds/promptdecline.mp3")
				elseif activeButton == "buy_veh_slot" then
					triggerServerEvent("buyVehSlot", localPlayer, tonumber(fakeInputText))
					playSound("files/sounds/promptaccept.mp3")
				end

				if activeButton == "more_intslot" then
					if not buyingInteriorSlot then
						buyingInteriorSlot = true
						fakeInputText = ""
						playSound("files/sounds/prompt.mp3")
					end
				elseif activeButton == "cancel_int_slot" then
					buyingInteriorSlot = false
					fakeInputText = ""
					playSound("files/sounds/promptdecline.mp3")
				elseif activeButton == "buy_int_slot" then
					triggerServerEvent("buyIntSlot", localPlayer, tonumber(fakeInputText))
					playSound("files/sounds/promptaccept.mp3")
				end

				if activeButton == "sell_vehicle" then
					exports.sm_accounts:showInfo("e", "Jelenleg nem elérhető.")
					-- local veh = playerVehicles[selectedVeh]

					-- if (vehicleDatas[veh]["vehicle.group"] or 0) == 0 then
					-- 	exports.sm_tradecontract:sellingVehicle(veh, vehicleDatas[veh])
					-- end
				end

				if activeButton == "sell_interior" then
					exports.sm_accounts:showInfo("e", "Jelenleg nem elérhető.")
				end

				if buttonDetails[1] == "selectAnimal" then
					local animalId = tonumber(buttonDetails[2])

					if renderData.selectedAnimal ~= animalId then
						renderData.selectedAnimal = animalId
						playSound("files/sounds/switchoption.mp3")
					end
				end

				if activeButton == "newAnimal" then
					renderData.buyingPet = true
					renderData.buyDogProcessing = false
					playSound("files/sounds/prompt.mp3")
				elseif activeButton == "cancelPetBuy" then
					renderData.buyingPet = false
					renderData.dogName = ""
					renderData.buyDogType = false
					playSound("files/sounds/promptdecline.mp3")
				elseif buttonDetails[1] == "selectPetForBuy" then
					renderData.buyDogType = tonumber(buttonDetails[2])
					playSound("files/sounds/promptaccept.mp3")
				elseif activeButton == "buySelectedPet" then
					if not renderData.buyDogProcessing then
						if utf8.len((renderData.dogName or "")) > 0 then
							triggerServerEvent("buyPet", localPlayer, renderData.dogName, renderData.petNameTypes[renderData.buyDogType], renderData.petPrices[renderData.buyDogType])

							renderData.buyDogProcessing = true

							playSound("files/sounds/promptaccept.mp3")
						else
							exports.sm_accounts:showInfo("e", "Név nélkül nem vehetsz kutyát!")
						end
					end
				end

				if activeButton == "spawnAnimal" then
					if getTickCount() - (renderData.lastSpawnAnimal or 0) >= 5000 then
						local animal = renderData.loadedAnimals[renderData.selectedAnimal]

						if animal and animal.animalId then
							if 0 < renderData.spawnedAnimal then
								if renderData.spawnedAnimal == animal.animalId then
									triggerServerEvent("destroyAnimal", localPlayer, renderData.spawnedAnimal)
									renderData.lastSpawnAnimal = getTickCount()
									playSound("files/sounds/switchoption.mp3")
								else
									exports.sm_accounts:showInfo("e", "Másik állat lespawnolása előtt, először despawnold az aktívat!")
								end
							else
								triggerServerEvent("spawnAnimal", localPlayer, animal.animalId)
								renderData.lastSpawnAnimal = getTickCount()
								playSound("files/sounds/switchoption.mp3")
							end
						end
					else
						exports.sm_accounts:showInfo("e", "5 másodpercenként csak egyszer használhatod ezt a gombot.")
					end
				end

				if activeButton == "renameAnimal" then
					local animal = renderData.loadedAnimals[renderData.selectedAnimal]

					if animal then
						renderData.renamingPet = true
						renderData.newDogName = animal.name or ""
						playSound("files/sounds/prompt.mp3")
					end
				elseif activeButton == "cancelPetRename" then
					renderData.renamingPet = false
					playSound("files/sounds/promptdecline.mp3")
				elseif activeButton == "renameSelectedPet" then
					local animal = renderData.loadedAnimals[renderData.selectedAnimal]

					if animal then
						if utfLen(renderData.newDogName) > 0 then
							if renderData.newDogName ~= animal.name then
								triggerServerEvent("renamePet", localPlayer, animal.animalId, renderData.newDogName)
								playSound("files/sounds/promptaccept.mp3")
							else
								exports.sm_accounts:showInfo("e", "Nem lehet ugyan az a név, mint volt.")
							end
						else
							exports.sm_accounts:showInfo("e", "Nem lehet üres a pet neve.")
						end
					end
				end

				if activeButton == "reviveAnimal" then
					renderData.buyingPetRevive = true
					playSound("files/sounds/prompt.mp3")
				elseif activeButton == "cancelReviveAnimal" then
					renderData.buyingPetRevive = false
					playSound("files/sounds/promptdecline.mp3")
				elseif activeButton == "buyReviveAnimal" then
					local animal = renderData.loadedAnimals[renderData.selectedAnimal]

					if animal.health < 1 then
						renderData.buyReviveProcessing = true
						triggerServerEvent("buyPetRevive", localPlayer, animal.animalId)
						playSound("files/sounds/promptaccept.mp3")
					else
						exports.sm_accounts:showInfo("e", "Ez a kutya nem halott.")
					end
				end

				if activeButton == "sellAnimal" then
					exports.sm_accounts:showInfo("e", "Jelenleg nem elérhető.")
				end

				if string.find(activeButton, "setting_") then
					local id = -1

					for i = 1, #renderData.clientSettings do
						if renderData.clientSettings[i] and renderData.clientSettings[i][3] == buttonDetails[2] then
							id = i
							break
						end
					end

					if buttonDetails[1] == "setting_toggle" then
						if string.find(buttonDetails[2], "shader") then
							if renderData.clientSettings[id] then
								renderData.clientSettings[id][2] = not renderData.clientSettings[id][2]
								renderData.loadedSettings[buttonDetails[2]] = renderData.clientSettings[id][2]
								exports.sm_shader:setActiveShader(string.gsub(buttonDetails[2], "shader_", ""), renderData.clientSettings[id][2])
								playSound("files/sounds/switchoption.mp3")
							end
						end
					end

					if buttonDetails[1] == "setting_next" then
						if string.find(buttonDetails[2], "shader") then
							if renderData.clientSettings[id] then
								local shader = string.gsub(buttonDetails[2], "shader_", "")

								if not renderData.clientSettings[id][2] then
									renderData.clientSettings[id][2] = 1
								else
									renderData.clientSettings[id][2] = renderData.clientSettings[id][2] + 1

									local maxValue = 1

									if shader == "palette" then
										maxValue = 14
									elseif shader == "vehicle" then
										maxValue = 3
									elseif shader == "water" then
										maxValue = 2
									end

									if renderData.clientSettings[id][2] > maxValue then
										renderData.clientSettings[id][2] = maxValue
									end
								end

								renderData.loadedSettings[buttonDetails[2]] = renderData.clientSettings[id][2]

								exports.sm_shader:setActiveShader(shader, renderData.clientSettings[id][2])

								playSound("files/sounds/menuswitch2.mp3")
							end
						else
							if buttonDetails[2] == "walkingStyle" then
								local nextId = (renderData.walkingStylesEx[getPedWalkingStyle(localPlayer)] or 1) + 1

								if renderData.walkingStyles[nextId] then
									renderData.clientSettings[id][2] = nextId
									triggerServerEvent("setPedWalkingStyle", localPlayer, renderData.walkingStyles[nextId])
									playSound("files/sounds/menuswitch2.mp3")
								end
							elseif buttonDetails[2] == "fightingStyle" then
								local nextId = (renderData.fightStylesEx[getPedFightingStyle(localPlayer)] or 1) + 1

								if renderData.fightStyles[nextId] then
									renderData.clientSettings[id][2] = nextId
									triggerServerEvent("setPedFightingStyle", localPlayer, renderData.fightStyles[nextId])
									playSound("files/sounds/menuswitch2.mp3")
								end
							elseif buttonDetails[2] == "sayStyle" then
								local nextId = (renderData.sayStyleEx[getElementData(localPlayer, "talkingAnim")]) + 1

								if renderData.sayStyle[nextId] then
									renderData.clientSettings[id][2] = nextId
									setElementData(localPlayer, "talkingAnim", renderData.sayStyle[nextId])
									playSound("files/sounds/menuswitch2.mp3")
								end
							elseif buttonDetails[2] == "chatType" then
								local chatType = renderData.clientSettings[id][2]

								if chatType == -1 then
									chatType = 0
								elseif chatType == 0 then
									chatType = 1
								end

								renderData.clientSettings[id][2] = chatType
								exports.sm_hud:setChatType(chatType)

								playSound("files/sounds/menuswitch2.mp3")
							elseif buttonDetails[2] == "crosshair" then
								local currentShape = renderData.crosshairData[1] or 0

								currentShape = currentShape + 1

								if currentShape > 12 then
									currentShape = 12
								else
									playSound("files/sounds/menuswitch2.mp3")
								end

								renderData.crosshairData[1] = currentShape

								setElementData(localPlayer, "crosshairData", renderData.crosshairData, false)
							end
						end
					end

					if buttonDetails[1] == "setting_prev" then
						if string.find(buttonDetails[2], "shader") then
							if renderData.clientSettings[id] and renderData.clientSettings[id][2] then
								renderData.clientSettings[id][2] = renderData.clientSettings[id][2] - 1

								if renderData.clientSettings[id][2] <= 0 then
									renderData.clientSettings[id][2] = false
								end

								renderData.loadedSettings[buttonDetails[2]] = renderData.clientSettings[id][2]

								exports.sm_shader:setActiveShader(string.gsub(buttonDetails[2], "shader_", ""), renderData.clientSettings[id][2])

								playSound("files/sounds/menuswitch2.mp3")
							end
						else
							if buttonDetails[2] == "walkingStyle" then
								local nextId = (renderData.walkingStylesEx[getPedWalkingStyle(localPlayer)] or 1) - 1

								if renderData.walkingStyles[nextId] then
									renderData.clientSettings[id][2] = nextId
									triggerServerEvent("setPedWalkingStyle", localPlayer, renderData.walkingStyles[nextId])
									playSound("files/sounds/menuswitch2.mp3")
								end
							elseif buttonDetails[2] == "sayStyle" then
								local nextId = (renderData.sayStyleEx[getElementData(localPlayer, "talkingAnim")]) - 1

								if renderData.sayStyle[nextId] then
									renderData.clientSettings[id][2] = nextId
									setElementData(localPlayer, "talkingAnim", renderData.sayStyle[nextId])
									playSound("files/sounds/menuswitch2.mp3")
								end
							elseif buttonDetails[2] == "fightingStyle" then
								local nextId = (renderData.fightStylesEx[getPedFightingStyle(localPlayer)] or 1) - 1

								if renderData.fightStyles[nextId] then
									renderData.clientSettings[id][2] = nextId
									triggerServerEvent("setPedFightingStyle", localPlayer, renderData.fightStyles[nextId])
									playSound("files/sounds/menuswitch2.mp3")
								end
							elseif buttonDetails[2] == "chatType" then
								local chatType = renderData.clientSettings[id][2]

								if chatType == 1 then
									chatType = 0
								elseif chatType == 0 then
									chatType = -1
								end

								renderData.clientSettings[id][2] = chatType
								exports.sm_hud:setChatType(chatType)

								playSound("files/sounds/menuswitch2.mp3")
							elseif buttonDetails[2] == "crosshair" then
								local currentShape = renderData.crosshairData[1] or 0

								currentShape = currentShape - 1

								if currentShape < 0 then
									currentShape = 0
								else
									playSound("files/sounds/menuswitch2.mp3")
								end

								renderData.crosshairData[1] = currentShape

								setElementData(localPlayer, "crosshairData", renderData.crosshairData, false)
							end
						end
					end
				end

				if buttonDetails[1] == "crosshair_color" then
					local r, g, b = renderData.crosshairData[2], renderData.crosshairData[3], renderData.crosshairData[4]

					if r == 200 and g == 200 and b == 200 then
						r, g, b = 124, 197, 118
					elseif r == 124 and g == 197 and b == 118 then
						r, g, b = 215, 89, 89
					elseif r == 215 and g == 89 and b == 89 then
						r, g, b = 89, 142, 215
					elseif r == 89 and g == 142 and b == 215 then
						r, g, b = 255, 127, 0
					elseif r == 255 and g == 127 and b == 0 then
						r, g, b = 220, 163, 0
					else
						r, g, b = 200,200,200
					end

					renderData.crosshairData[2] = r
					renderData.crosshairData[3] = g
					renderData.crosshairData[4] = b
					setElementData(localPlayer, "crosshairData", renderData.crosshairData, false)

					playSound("files/sounds/switchoption.mp3")
				end
			elseif state == "up" then
				if buttonDetails[1] == "selectTab" then
					local selected = tonumber(buttonDetails[2])

					if selectedTab ~= selected then
						selectedTab = selected
						buySlot = false
						selectedSlot = 1
						if selectedTab ~= 6 then
							if panel then
								panel = false
								dxDestroyEdit("companyName")
								dxDestroyEdit("newPlayer")
								dxDestroyEdit("companyBalance")
								dxDestroyEdit("payTax")
								dxDestroyEdit("renameRank")
								dxDestroyEdit("reprecentRank")
								dxDestroyEdit("rewriteMessage")
								payTaxes = false
							end
						end

						if selectedTab == 3 then
							triggerServerEvent("requestGroups", localPlayer)
						elseif selectedTab == 4 then
							getAdmins()
						elseif selectedTab == 5 then
							fetchAnimals()
						elseif selectedTab == 6 then --companyP
							openCompanyTab()
						end

						activeFakeInput = false
						fakeInputText = ""
						fakeInputError = false

						memberFirePrompt = false
						fireErrorText = ""

						playSound("files/sounds/menuswitch.mp3")
					end
				end

				if buttonDetails[1] == "rankaction" then
					local actionNum = tonumber(buttonDetails[2])
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" and not activeFakeInput then
							fakeInputText = ""
							fakeInputError = false

							if actionNum == 1 then
								activeFakeInput = "setrankname"
							end

							if actionNum == 2 then
								activeFakeInput = "setrankpay"
							end

							playSound("files/sounds/switchoption.mp3")
						end
					end
				end

				if activeButton == "setrankname" then
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId and selectedRank then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							if string.len(fakeInputText) < 1 then
								fakeInputError = "#d75959Nem hagyhatod üresen a mezőt!"
								playSound("files/sounds/promptdecline.mp3")
							else
								fakeInputError = "#7cc576Sikeresen átnevezve!"
								triggerServerEvent("renameGroupRank", localPlayer, selectedRank, fakeInputText, groupId)
								playSound("files/sounds/promptaccept.mp3")
							end
						end
					end

					fakeInputText = ""
				end

				if activeButton == "setrankpay" then
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId and selectedRank then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							if string.len(fakeInputText) < 1 then
								fakeInputError = "#d75959Nem hagyhatod üresen a mezőt!"
								playSound("files/sounds/promptdecline.mp3")
							elseif not tonumber(fakeInputText) then
								fakeInputError = "#d75959Ez nem szám!"
								playSound("files/sounds/promptdecline.mp3")
							elseif string.find(fakeInputText, "e") then
								fakeInputError = "#d75959Ez nem szám!"
								playSound("files/sounds/promptdecline.mp3")
							elseif tonumber(fakeInputText) < 0 then
								fakeInputError = "#d75959Minuszba?!"
								playSound("files/sounds/promptdecline.mp3")
							elseif tonumber(fakeInputText) > 10000000 then
								fakeInputError = "#d75959Sok lesz ez!"
								playSound("files/sounds/promptdecline.mp3")
							else
								fakeInputError = "#7cc576Sikeresen átállítva!"
								triggerServerEvent("setGroupRankPayment", localPlayer, selectedRank, math.floor(tonumber(fakeInputText)), groupId)
								playSound("files/sounds/promptaccept.mp3")
							end
						end
					end

					fakeInputText = ""
				end

				if activeButton == "groupdesc" and not activeFakeInput then
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId and selectedRank then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							activeFakeInput = activeButton
							fakeInputText = groups[groupId].description
							fakeInputError = false
							playSound("files/sounds/switchoption.mp3")
						end
					end
				elseif activeButton == "setgroupdesc" then
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId and selectedRank then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							groups[groupId].description = fakeInputText
							triggerServerEvent("rewriteGroupDescription", localPlayer, fakeInputText, groupId)

							activeFakeInput = false
							fakeInputText = ""
							playSound("files/sounds/promptaccept.mp3")
						end
					end
				end

				if activeButton == "groupbalance" and not activeFakeInput then
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId and selectedRank then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							activeFakeInput = activeButton
							fakeInputText = ""
							fakeInputError = false
							playSound("files/sounds/switchoption.mp3")
						end
					end
				elseif activeButton == "getoutmoney" or activeButton == "putbackmoney" then
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId and selectedRank then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							if not isElementWithinColShape(localPlayer, bankCols[1]) and not isElementWithinColShape(localPlayer, bankCols[2]) then
								fakeInputError = "#d75959Nem vagy bankban!"
								playSound("files/sounds/notification.mp3")
								return
							end

							if string.len(fakeInputText) < 1 then
								fakeInputError = "#d75959Nem hagyhatod üresen a mezőt!"
								playSound("files/sounds/promptdecline.mp3")
							elseif not tonumber(fakeInputText) then
								fakeInputError = "#d75959Ez nem szám!"
								playSound("files/sounds/promptdecline.mp3")
							elseif string.find(fakeInputText, "e") then
								fakeInputError = "#d75959Ez nem szám!"
								playSound("files/sounds/promptdecline.mp3")
							elseif tonumber(fakeInputText) < 1000 then
								fakeInputError = "#d75959Minimum 1000$-t kezelhetsz!"
								playSound("files/sounds/promptdecline.mp3")
							else
								fakeInputText = math.floor(tonumber(fakeInputText))

								if activeButton == "getoutmoney" then
									fakeInputText = -fakeInputText
								end

								fakeInputError = "#7cc576Feldolgozás..."
								triggerServerEvent("setGroupBalance", localPlayer, fakeInputText, groupId)
								playSound("files/sounds/promptaccept.mp3")
							end

							fakeInputText = ""
							activeFakeInput = false
						end
					end
				end

				if buttonDetails[1] == "groupaction" then
					local actionNum = tonumber(buttonDetails[2])
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							if actionNum == 1 then
								triggerServerEvent("modifyRankForPlayer", localPlayer, member.id, member.rank, groupId, "up", member.online, playerGroups)
							end

							if actionNum == 2 then
								triggerServerEvent("modifyRankForPlayer", localPlayer, member.id, member.rank, groupId, "down", member.online, playerGroups)
							end

							if actionNum == 3 then
								memberFirePrompt = true
								fireErrorText = "#d75959Tényleg ki szeretnéd rúgni?"
								playSound("files/sounds/prompt.mp3")
							end

							if actionNum == 4 then
								activeFakeInput = "inviting"
								fakeInputText = ""
								fakeInputError = false
								playSound("files/sounds/prompt.mp3")
							end

							playSound("files/sounds/switchoption.mp3")
						end
					end
				end

				if activeButton == "cancelFire" then
					fireErrorText = ""
					memberFirePrompt = false
					playSound("files/sounds/promptdecline.mp3")
				end

				if activeButton == "fireMember" then
					local groupId = playerGroupsKeyed[selectedGroup]

					fireErrorText = ""
					memberFirePrompt = false
					playSound("files/sounds/promptdecline.mp3")

					if groupId then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							triggerServerEvent("deletePlayerFromGroup", localPlayer, member.id, groupId, member.online, playerGroups)
							playSound("files/sounds/promptaccept.mp3")
						end
					end
				end

				if activeButton == "errorOk" then
					activeFakeInput = false
					fakeInputError = false
					fireErrorText = ""
					playSound("files/sounds/notification.mp3")
				end

				if activeButton == "groupInvite" then
					local groupId = playerGroupsKeyed[selectedGroup]

					if groupId then
						local thisMembers = groupMembers[groupId]
						local member = thisMembers[selectedMember]

						if member and meInGroup[groupId].isLeader == "Y" then
							if string.len(fakeInputText) < 1 then
								fakeInputError = "#d75959Nem hagyhatod üresen a mezőt!"
								playSound("files/sounds/notification.mp3")
							else
								local found = false
								local multipleFounds = false
								local invitingText = string.lower(string.gsub(fakeInputText, " ", "_"))

								for k, v in ipairs(getElementsByType("player")) do
									if getElementData(v, "loggedIn") then
										local id = getElementData(v, "playerID")
										local name = string.lower(getElementData(v, "visibleName"):gsub(" ", "_"))

										if id == tonumber(invitingText) or string.find(name, invitingText) then
											if found then
												found = false
												multipleFounds = true
												break
											else
												found = v
											end
										end
									end
								end

								if multipleFounds then
									fakeInputError = "#d75959Több találat!"
									playSound("files/sounds/promptdecline.mp3")
								elseif isElement(found) then
									local name = getElementData(found, "visibleName")
									fakeInputError = "#7cc576" .. name:gsub("_", " ") .. " felvétele sikeres!"

									triggerServerEvent("invitePlayerToGroup", localPlayer, getElementData(found, "char.ID"), groupId, found, playerGroups)
									playSound("files/sounds/promptaccept.mp3")
								else
									fakeInputError = "#d75959Nincs találat!"
									playSound("files/sounds/promptdecline.mp3")
								end
							end
						end
					end
				end

				if activeButton == "setDutySkin" and not activeFakeInput then
					toggleDutySkinSelect(true, playerGroupsKeyed[selectedGroup])
					togglePanel()
				end
			end
		end
		end
	end

function drawDataRow(startX, startY, h, caption, data, scale)
	local w1 = dxGetTextWidth(caption, scale or 1, RobotoB2)
	local w2 = dxGetTextWidth(string.gsub(data, "#......", ""), scale or 1, Roboto)
	
	dxDrawText(caption, startX, startY, startX + w1, startY + h, rgba(200,200,200), scale or 1, RobotoB2, "center", "center", false, false, false, true)
	dxDrawText(data, startX + w1, startY, startX + w1 + w2, startY + h, rgba(61, 122, 188), scale or 1, Roboto, "center", "center", false, false, false, true)

	return startY + h, w1 + w2
end

function onRenderHandler()
	if alphaAnim then
		local now = getTickCount()
		local elapsedTime = now - alphaAnim[1]
		local progress = elapsedTime / 250

		alpha = interpolateBetween(alphaAnim[2], 0, 0, alphaAnim[3], 0, 0, progress, "Linear")

		if screenShader then
			dxSetShaderValue(screenShader, "alpha", alpha)
		end

		if progress >= 1 then
			if alphaAnim[3] == 0 then

				if isElement(screenShader) then
					destroyElement(screenShader)
				end

				if isElement(screenSource) then
					destroyElement(screenSource)
				end

				removeEventHandler("onClientRender", getRootElement(), onRenderHandler)
				removeEventHandler("onClientClick", getRootElement(), onClickHandler)
				removeEventHandler("onClientCharacter", getRootElement(), handleInputs)
				removeEventHandler("onClientKey", getRootElement(), editBoxesKey)
				removeEventHandler("onClientCharacter", getRootElement(), editBoxesCharacter)
				if isElement(Roboto) then
					destroyElement(Roboto)
				end

				if isElement(RobotoL) then
					destroyElement(RobotoL)
				end

				if isElement(RobotoB) then
					destroyElement(RobotoB)
				end

				if isElement(RobotoB2) then
					destroyElement(RobotoB2)
				end

				Roboto = nil
				RobotoL = nil
				RobotoB = nil
				RobotoB2 = nil
			end

			alphaAnim = false
		end
	end

	if not (panelState or alphaAnim) then
		return
	end

	if screenSource and screenShader then
		dxUpdateScreenSource(screenSource, true)
		dxDrawImage(0, 0, screenX, screenY, screenShader)
	end

	local cursorX, cursorY = getCursorPosition()

	if tonumber(cursorX) then
		cursorX = cursorX * screenX
		cursorY = cursorY * screenY
	end

	buttons = {}
	buttonsC = {}

	if getTickCount() - lastChangeCursorState >= 500 then
		cursorState = not cursorState
		lastChangeCursorState = getTickCount()
	end

	if renderData.renamingPet then
		local sx, sy = respc(600), respc(150)
		local x = screenX / 2 - sx / 2
		local y = screenY / 2 - sy / 2

		-- ** Háttér
		dxDrawRectangle(x, y, sx, sy, rgba(25, 25, 25))


		local y2 = y + respc(30)
		local formattedText = renderData.newDogName or ""

		dxDrawText("Név:", x + respc(15), y2, 0, y2 + respc(40), rgba(200,200,200), 0.5, RobotoB, "left", "center")

		dxDrawRectangle(x + respc(65), y2, sx - respc(80), respc(40), rgba(0, 0, 0, 150))

		dxDrawText(formattedText, x + respc(70), y2, 0, y2 + respc(40), rgba(200,200,200), 0.75, Roboto, "left", "center")

		if cursorState then
			local w = dxGetTextWidth(formattedText, 0.75, Roboto)
			dxDrawRectangle(x + respc(70) + w, y2 + respc(5), 2, respc(40) - respc(10), rgba(200,200,200))
		end

		y2 = y2 + respc(60)

		local buttonWidth = (sx - respc(60)) / 2

		-- Mégsem
		buttons["cancelPetRename"] = {x + respc(15), y2, buttonWidth, respc(40)}

		drawButton("cancelPetRename", "Mégsem", x + respc(15), y2, buttonWidth, respc(40), {215, 89, 89}, false, Roboto)

		-- Vásárlás
		buttons["renameSelectedPet"] = {x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40)}
		drawButton("renameSelectedPet", "Átnevezés", x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40), {61, 122, 188}, false, Roboto)


		-- ** Button handler
		activeButton = false
		activeButtonC = false

		if isCursorShowing() then
			for k, v in pairs(buttonsC) do
				if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
					activeButton = k
					activeButtonC = k
					break
				end
			end
		end

		return
	end

	if renderData.buyingPetRevive then
		local sx, sy = respc(600), respc(150)
		local x = screenX / 2 - sx / 2
		local y = screenY / 2 - sy / 2

		-- ** Háttér
		dxDrawRectangle(x, y, sx, sy, rgba(25, 25, 25))

		-- ** Content
		dxDrawText("Tényleg szeretnéd feléleszteni a peted?\nA felélesztés ára #3d7abc100 #ffffffPP", x, y, x + sx, y + sy - respc(70), rgba(200,200,200), 0.75, RobotoL, "center", "center", false, false, false, true)
		
		local y2 = y + sy - respc(60)
		local buttonWidth = (sx - respc(60)) / 2

		-- Mégsem
		buttons["cancelReviveAnimal"] = {x + respc(15), y2, buttonWidth, respc(40)}

		drawButton("cancelReviveAnimal", "Mégsem", x + respc(15), y2, buttonWidth, respc(40), {215, 89, 89}, false, Roboto)

		-- Vásárlás
		buttons["buyReviveAnimal"] = {x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40)}

		drawButton("buyReviveAnimal", "Igen", x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40), {61, 122, 188}, false, Roboto)

		
		activeButton = false
		activeButtonC = false

		if isCursorShowing() then
			for k, v in pairs(buttonsC) do
				if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
					activeButton = k
					activeButtonC = k
					break
				end
			end
		end

		return
	end

	if renderData.buyingPet then
		local sx, sy = respc(1200), respc(350)

		if tonumber(renderData.buyDogType) then
			sx, sy = respc(600), respc(300)
		end

		local x = screenX / 2 - sx / 2
		local y = screenY / 2 - sy / 2

		-- ** Háttér
		dxDrawRectangle(x, y, sx, sy, rgba(25, 25, 25))

		-- ** Content
		if tonumber(renderData.buyDogType) then
			if renderData.buyDogProcessing then
				dxDrawText("#7cc576Feldolgozás folyamatban...", x, y, x + sx, y + sy - respc(100), rgba(200,200,200), 0.75, RobotoL, "center", "center", false, false, false, true)
			else
				dxDrawText("Add meg a vásárolni kívánt kutya nevét.\nA kutya ára: #3d7abc" .. formatNumber(renderData.petPrices[renderData.buyDogType]) .. " PP", x, y, x + sx, y + sy - respc(100), rgba(200,200,200), 0.75, RobotoL, "center", "center", false, false, false, true)
			end

			local y2 = y + respc(180)
			local formattedText = renderData.dogName or ""

			dxDrawText("Név:", x + respc(15), y2, 0, y2 + respc(40), rgba(200,200,200), 0.5, RobotoB, "left", "center")

			dxDrawRectangle(x + respc(65), y2, sx - respc(80), respc(40), rgba(0, 0, 0, 150))

			dxDrawText(formattedText, x + respc(70), y2, 0, y2 + respc(40), rgba(200,200,200), 0.75, Roboto, "left", "center")

			if cursorState then
				local w = dxGetTextWidth(formattedText, 0.75, Roboto)
				dxDrawRectangle(x + respc(70) + w, y2 + respc(5), 2, respc(40) - respc(10), rgba(200,200,200))
			end

			y2 = y2 + respc(60)

			local buttonWidth = (sx - respc(60)) / 2

			-- Mégsem
			buttons["cancelPetBuy"] = {x + respc(15), y2, buttonWidth, respc(40)}

			drawButton("cancelPetBuy", "Mégsem", x + respc(15), y2, buttonWidth, respc(40), {215, 89, 89}, false, Roboto)
			-- Vásárlás
			buttons["buySelectedPet"] = {x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40)}
			drawButton("buySelectedPet", "Vásárlás", x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40), {61, 122, 188}, false, Roboto)
		else
			dxDrawText("Kattints egy kutyára a vásárláshoz!", x, y + respc(20), x + sx, 0, rgba(200,200,200), 0.75, RobotoL, "center", "top", false, false, false, true)

			local oneSize = (sx - respc(20) * 7) / 6

			for i = 1, 6 do
				local x2 = x + respc(20) + (oneSize + respc(20)) * (i - 1)
				local y2 = y + respc(70)

				buttons["selectPetForBuy:" .. i] = {x2, y2, oneSize, oneSize}
				drawButton("selectPetForBuy:" .. i, "", x2, y2, oneSize, oneSize, {60, 60, 60}, false, Roboto)

				dxDrawImage(x2 + oneSize / 2 - respc(371) / 2, y2 + oneSize / 2 - respc(146) / 2, respc(371), respc(146), "files/images/dogs/" .. i .. ".png", 0, 0, 0, rgba(200,200,200))
				
				dxDrawText(renderData.petNameTypes[i], x2, y2 + oneSize, x2 + oneSize, y2 + oneSize + respc(20), rgba(200, 200, 200), 0.65, Roboto, "center", "top")
			end

			buttons["cancelPetBuy"] = {x + respc(20), y + sy - respc(60), sx - respc(40), respc(40)}

			drawButton("cancelPetBuy", "Mégsem", x + respc(20), y + sy - respc(60), sx - respc(40), respc(40), {215, 89, 89}, false, Roboto)
		end


		-- ** Button handler
		activeButton = false
		activeButtonC = false

		if isCursorShowing() then
			for k, v in pairs(buttons) do
				if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
					activeButton = k
					activeButtonC = k
					break
				end
			end
		end

		return
	end

	if buyingVehicleSlot or buyingInteriorSlot or sellVehicleToCompanyPlayer then
		local sx, sy = respc(600), respc(300)
		local x = screenX / 2 - sx / 2
		local y = screenY / 2 - sy / 2

		-- ** Háttér
		dxDrawRectangle(x, y+respc(150), sx, respc(150), rgba(25, 25, 25))

		-- ** Cím
		local slotTypeText = "Járműslot vásárlás"
		local buttonPrefix = "veh"

		if buyingInteriorSlot then
			slotTypeText = "Interior slot vásárlás"
			buttonPrefix = "int"
		end


		-- ** Content
		local formattedText = tonumber(fakeInputText) or 0
		
		local y2 = y + respc(180)

		dxDrawText("Slot:", x + respc(15), y2, 0, y2 + respc(40), rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("db", 0, y2, x + sx - respc(15), y2 + respc(40), rgba(200,200,200), 0.5, RobotoB, "right", "center")

		dxDrawRectangle(x + respc(65), y2, sx - respc(110), respc(40), rgba(35, 35, 35))
		dxDrawText(formattedText, x + respc(70), y2, 0, y2 + respc(40), rgba(200,200,200), 0.75, Roboto, "left", "center")

		y2 = y2 + respc(60)

		local buttonWidth = (sx - respc(60)) / 2

		-- Mégsem
		buttons["cancel_" .. buttonPrefix .. "_slot"] = {x + respc(15), y2, buttonWidth, respc(40)}

		if activeButton == "cancel_" .. buttonPrefix .. "_slot" then
			dxDrawRectangle(x + respc(15), y2, buttonWidth, respc(40), rgba(215, 89, 89, 200))
		else
			dxDrawRectangle(x + respc(15), y2, buttonWidth, respc(40), rgba(215, 89, 89, 150))
		end

		dxDrawText("Mégsem", x + respc(15), y2, x + respc(15) + buttonWidth, y2 + respc(40), rgba(200,200,200), 0.9, RobotoL, "center", "center")

		-- Vásárlás
		buttons["buy_" .. buttonPrefix .. "_slot"] = {x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40)}

		if activeButton == "buy_" .. buttonPrefix .. "_slot" then
			dxDrawRectangle(x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40), rgba(61, 122, 188, 200))
		else
			dxDrawRectangle(x + sx - respc(15) - buttonWidth, y2, buttonWidth, respc(40), rgba(61, 122, 188, 150))
		end

		dxDrawText("Vásárlás", x + sx - respc(15) - buttonWidth, y2, x + sx - respc(15), y2 + respc(40), rgba(200,200,200), 0.9, RobotoL, "center", "center")

		-- Egyenleg
		--dxDrawText("Prémium egyenleg: " .. formatNumber(myDatas["acc.premiumPoints"] or 0) .. " PP", x + 1, y + sy + 1, x + sx + 1, y + sy + respc(40) + 1, rgba(0, 0, 0), 0.6, Roboto, "center", "center")
		dxDrawText(formattedText * 100 .. " #3d7abcPP", x, y + sy, x + sx, y + sy + respc(40), rgba(200,200,200), 0.8, Roboto, "center", "center", false, false, false, true)

		-- ** Button handler
		activeButton = false

		if isCursorShowing() then
			for k, v in pairs(buttons) do
				if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
					activeButton = k
					break
				end
			end
		end

		return
	end

	-- ** Dashboard
	--wardis
	local sx, sy = screenX - respc(60), screenY - respc(60)
	local x = screenX / 2 - sx / 2
	local y = screenY / 2 - sy / 2

	-- ** Háttér
	local headerHeight = respc(80)

	dxDrawRectangle(x, y, sx, sy, rgba(25,25,25))
	dxDrawRectangle(x, y, sx, headerHeight, rgba(35, 35, 35))

	-- ** Keret
	dxDrawRectangle(x, y + headerHeight, sx, 4, rgba(0, 0, 0, 150)) -- cím alatt
	
	-- ** Cím
	local logoPosX = x + respc(120) / 2 - respc(165 * 0.45) / 2
	local logoPosY = y + headerHeight / 2 - respc(132 * 0.45) / 2
	
	dxDrawImage(logoPosX, logoPosY, respc(165 * 0.45), respc(165 * 0.45), serverLogo, 0, 0, 0, rgba(200,200,200))
	dxDrawText("#3d7abcStrong#ffffffMTA", logoPosX + respc(165 * 0.45) + (logoPosX - x), y, 0, y + headerHeight, rgba(200,200,200), 1, RobotoB, "left", "center", false, false, false, true)



	-- ** Szekciók
	local oneTabSize = respc(120)
	local tabIconSize = respc(45)

	for k = 1, #tabCaptions do
		local v = #tabCaptions + 1 - k

		if v then
			local x2 = x + sx - oneTabSize * k
			local colorOfTab = rgba(200, 200, 200)

			if selectedTab == v then
				dxDrawRectangle(x2, y, oneTabSize, headerHeight, rgba(61, 122, 188, 50))
				dxDrawRectangle(x2, y + headerHeight, oneTabSize, 2, rgba(61, 122, 188))

				colorOfTab = rgba(61, 122, 188)
			elseif activeButton == "selectTab:" .. v then
				colorOfTab = rgba(200,200,200)
			end

			dxDrawImage(math.floor(x2 + (oneTabSize - tabIconSize) / 2), math.floor(y + (headerHeight - tabIconSize) / 2 - respc(10)), tabIconSize, tabIconSize, tabPictures[v], 0, 0, 0, colorOfTab)
			dxDrawText(tabCaptions[v], x2, 0, x2 + oneTabSize, y + headerHeight - respc(10), colorOfTab, 0.635, Roboto, "center", "bottom")

			buttons["selectTab:" .. v] = {x2, y, oneTabSize, headerHeight}
		end
	end

	y = y + headerHeight

	-- Információk
	if selectedTab == 1 then
		local skinHolderSizeX = respc(240)
		local holderSizeY = sy - headerHeight - respc(40)
		local marginMul = 2.2

		local currentSkin = getElementModel(localPlayer)
		local mySkin = myDatas["char.Skin"] or currentSkin

		local skinSizeX = respc(160) / responsiveMultipler
		local skinSizeY = respc(400) / responsiveMultipler

		if mySkin == currentSkin then
			local sx2 = skinHolderSizeX * marginMul - respc(20)

			local x2 = x + sx - skinHolderSizeX * marginMul
			local y2 = y + holderSizeY - respc(20)

			buttons["openMyClothes"] = {x2, y2, sx2, respc(40)}

			--if activeButton == "openMyClothes" then
			--	dxDrawRectangle(x2, y2, sx2, respc(40), rgba(61, 122, 188, 220))
			--else
			--	dxDrawRectangle(x2, y2, sx2, respc(40), rgba(61, 122, 188, 160))
		--	end
		--	dxDrawText("Kiegészítők megnyitása", x2, y2, x + sx - respc(20), y2 + respc(40), rgba(200, 200, 200), 0.75, RobotoL, "center", "center")

			drawButton("openMyClothes", "Kiegészítők megnyitása", x2, y2, sx2, respc(40), {61, 122, 188}, false, Roboto)

			y2 = y2 - respc(55)

			dxDrawRectangle(x2, y2, sx2, respc(40), rgba(35, 35, 35))
			dxDrawText("Skined", x2, y2, x + sx - respc(20), y2 + respc(40), rgba(200,200,200), 0.75, Roboto, "center", "center")

			local skinBcgHeight = holderSizeY - respc(110)

			dxDrawRectangle(x2, y + respc(20), sx2, skinBcgHeight, rgba(35, 35, 35))
			dxDrawImage(x2 + sx2 / 2 - skinSizeX / 2, y + respc(20) + skinBcgHeight / 2 - skinSizeY / 2, skinSizeX, skinSizeY, ":sm_binco/files/skins2/" .. mySkin .. ".png", 0, 0, 0, rgba(200,200,200))
		else
			local sx2 = skinHolderSizeX * marginMul - respc(20)

			local x2 = x + sx - skinHolderSizeX * marginMul
			local y2 = y + holderSizeY - respc(20)

			buttons["openMyClothes"] = {x2, y2, sx2, respc(40)}

			--if activeButton == "openMyClothes" then
			--	dxDrawRectangle(x2, y2, sx2, respc(40), rgba(61, 122, 188, 220))
			--else
			--	dxDrawRectangle(x2, y2, sx2, respc(40), rgba(61, 122, 188, 160))
			--end
			--dxDrawText("Kiegészítők megnyitása", x2, y2, x + sx - respc(20), y2 + respc(40), rgba(200, 200, 200), 0.75, RobotoL, "center", "center")
			drawButton("openMyClothes", "Kiegészítők megnyitása", x2, y2, sx2, respc(40), {61, 122, 188}, false, Roboto)

			y2 = y2 - respc(55)

			local skinBcgHeight = holderSizeY - respc(110)

			dxDrawRectangle(x2, y + respc(20), skinHolderSizeX, skinBcgHeight, rgba(35, 35, 35))
			dxDrawImage(x2 + skinHolderSizeX / 2 - skinSizeX / 2, y + skinBcgHeight / 2 - skinSizeY / 2, skinSizeX, skinSizeY, ":sm_binco/files/skins2/" .. currentSkin .. ".png", 0, 0, 0, rgba(200,200,200))
			
			dxDrawRectangle(x2, y2, skinHolderSizeX, respc(40), rgba(35, 35, 35))
			dxDrawText("Jelenlegi skined", x2, y2, x2 + skinHolderSizeX, y2 + respc(40), rgba(200,200,200), 0.75, Roboto, "center", "center")
			
			x2 = x + sx - skinHolderSizeX - respc(20)

			dxDrawRectangle(x2, y + respc(20), skinHolderSizeX, skinBcgHeight, rgba(35, 35, 35))
			dxDrawImage(x2 + skinHolderSizeX / 2 - skinSizeX / 2, y + skinBcgHeight / 2 - skinSizeY / 2, skinSizeX, skinSizeY, ":sm_binco/files/skins2/" .. mySkin .. ".png", 0, 0, 0, rgba(200,200,200))

			dxDrawRectangle(x2, y2, skinHolderSizeX, respc(40), rgba(35, 35, 35))
			dxDrawText("Állandó skined", x2, y2, x + sx - respc(20), y2 + respc(40), rgba(200,200,200), 0.75, Roboto, "center", "center")
		end

		local startX = x + respc(20)
		local startY = y + respc(20)
		local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
		local oneSegmentSizeY = holderSizeY

		dxDrawRectangle(startX, startY, oneSegmentSizeX, oneSegmentSizeY, rgba(35, 35, 35))

		local oneSize = oneSegmentSizeY / 15

		for i = 1, 15 do
			if i ~= 15 then
				dxDrawRectangle(startX, startY + i * oneSize, oneSegmentSizeX, 2, rgba(45, 45, 45))
			end
		end

		local totalHeight = oneSize * 15

		if myDatas["char.Name"] ~= myDatas["visibleName"] then
			dxDrawText("Karakter név:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
			dxDrawText("#3d7abc"..myDatas["char.Name"]:gsub("_", " "), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

			startY = startY + oneSize

			dxDrawText("Megjelenő név:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
			dxDrawText("#3d7abc"..myDatas["visibleName"]:gsub("_", " "), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)
		else
			dxDrawText("Karakter név:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
			dxDrawText("#3d7abc"..myDatas["char.Name"]:gsub("_", " "), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)
		end

		startY = startY + oneSize

		dxDrawText("Felhasználó azonosító:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc"..myDatas["char.accID"], 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Karakter azonosító:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc"..myDatas["char.ID"], 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		local playedSeconds =  math.floor(myDatas["char.playedMinutes"]*60)
		local playedDays = math.floor(playedSeconds / 86400)
		local playedHours = math.floor((playedSeconds % 86400) / 3600)
		local playedMinutes = math.floor((playedSeconds / 3600) / 60)
		local playedTime = ""

		if playedDays == 0 then
			if playedHours == 0 then
				playedTime = string.format("%d perc", playedMinutes)
			else
				playedTime = string.format("%d óra és %d perc", playedHours, playedMinutes)
			end
		else
			if playedHours == 0 then
				playedTime = string.format("%d nap és %d perc", playedDays, playedMinutes)
			else
				playedTime = string.format("%d nap, %d óra és %d perc", playedDays, playedHours, playedMinutes)
			end
		end
		local formatTime = formatTime(playedSeconds)
		dxDrawText("Játszott idő:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" ..formatTime, 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Idő a fizetésig:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" .. (myDatas["char.playTimeForPayday"] or 60) .. " #ffffffperc", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Készpénz:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" .. formatNumber(myDatas["char.Money"]) .. " #eaeaea$", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Banki egyenleg:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" .. formatNumber(myDatas["char.bankMoney"] or 0) .. " #eaeaea$", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Prémium egyenleg:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" .. formatNumber(myDatas["acc.premiumPoints"] or 0) .. " #eaeaeaPP", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Kaszínó zseton:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" .. formatNumber(myDatas["char.slotCoins"] or 0) .. " #eaeaeaCoin", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Járműveid száma:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" .. #playerVehicles .. " #ffffffdb", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Ingatlanjaid száma:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" .. #playerInteriors .. " #ffffffdb", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

		startY = startY + oneSize

		dxDrawText("Munka:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
		dxDrawText("#3d7abc" .. (jobNames[myDatas["char.Job"]] or "#3d7abcNincs"), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)
	end

	-- Vagyon
	if selectedTab == 2 then
		local startX = x
		local startY = y + respc(25)

		local oneSectionWidth = sx / 3

		local w = dxGetTextWidth("Készpénz: ", 1, RobotoB2)
		w = w + dxGetTextWidth(formatNumber(myDatas["char.Money"]) .. " $", 1, Roboto)

		local w2 = dxGetTextWidth("Banki egyenleg: ", 1, RobotoB2)
		w2 = w2 + dxGetTextWidth(formatNumber(myDatas["char.bankMoney"]) .. " $", 1, Roboto)

		local w3 = dxGetTextWidth("Prémium egyenleg: ", 1, RobotoB2)
		w3 = w3 + dxGetTextWidth(formatNumber(myDatas["acc.premiumPoints"] or 0 .. " PP"), 1, Roboto)

		drawDataRow(startX + (oneSectionWidth - w) / 2, startY, respc(40), "Készpénz: ", "#3d7abc" .. formatNumber(myDatas["char.Money"]) .. " #ffffff$")
		
		drawDataRow(startX + oneSectionWidth + (oneSectionWidth - w2) / 2, startY, respc(40), "Banki egyenleg: ", "#3d7abc" .. formatNumber(myDatas["char.bankMoney"]) .. " #ffffff$")
		
		drawDataRow(startX + oneSectionWidth * 2 + (oneSectionWidth - w3) / 2, startY, respc(40), "Prémium egyenleg: ", "#3d7abc"..formatNumber(myDatas["acc.premiumPoints"] or 0) .. " #ffffffPP")
	
		startX = x + respc(20)
		startY = y + respc(140)

		local oneSegmentSizeX = (sx - respc(40) - respc(50)) / 2
		local oneSegmentSizeY = sy - headerHeight - respc(300)

		-- Járművek
		local maxThings = #playerVehicles

		dxDrawRectangle(startX, startY - respc(50), oneSegmentSizeX, respc(45), rgba(35, 35, 35))
		dxDrawText("Járműveim (#3d7abc" .. maxThings .. " #ffffffdb/#3d7abc" .. myDatas["char.maxVehicles"] .. " #ffffffdb)", startX, startY - respc(50), startX + oneSegmentSizeX, startY - respc(5), rgba(200,200,200), 0.85, RobotoL, "center", "center", false, false, false, true)

		--if activeButton == "more_vehslot" then
		--	dxDrawRectangle(startX + oneSegmentSizeX - respc(105), startY - respc(50) + respc(45) / 2 - respc(35) / 2, respc(100), respc(35), rgba(61, 122, 188, 240))
		--else
		--	dxDrawRectangle(startX + oneSegmentSizeX - respc(105), startY - respc(50) + respc(45) / 2 - respc(35) / 2, respc(100), respc(35), rgba(61, 122, 188, 180))
		--end

		--dxDrawText("+ slot", startX + oneSegmentSizeX - respc(105), startY - respc(50), startX + oneSegmentSizeX - respc(5), startY - respc(5), rgba(200,200,200), 0.5, RobotoB, "center", "center")
		drawButton("more_vehslot", "+ slot", startX + oneSegmentSizeX - respc(105), startY - respc(50) + respc(45) / 2 - respc(35) / 2, respc(100), respc(35), {61, 122, 188, 170}, true, Roboto)

		buttons["more_vehslot"] = {startX + oneSegmentSizeX - respc(105), startY - respc(50) + respc(45) / 2 - respc(35) / 2, respc(100), respc(35)}

		dxDrawRectangle(startX, startY, oneSegmentSizeX, oneSegmentSizeY, rgba(35, 35, 35))

		local num = 11
		local oneSize = oneSegmentSizeY / num

		for i = 1, num do
			local lineY = startY + (i - 1) * oneSize
			local veh = playerVehicles[i + offsetVeh]

			if i + offsetVeh == selectedVeh and isElement(veh) then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(61, 122, 188, 150))
			elseif activeButton == "selectVehicle:" .. i + offsetVeh then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(61, 122, 188, 90))
			else
				if i % 2 == 0 then
					dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(0, 0, 0, 30))
				end
			end

			if i ~= num then
				dxDrawRectangle(startX, lineY + oneSize, oneSegmentSizeX, 2, rgba(45, 45, 45))
			end

			if isElement(veh) then
				local datas = vehicleDatas[veh]

				local plateText = split(getVehiclePlateText(veh), "-")
				local plateSections = {}

				for i = 1, #plateText do
					if utf8.len(plateText[i]) > 0 then
						table.insert(plateSections, plateText[i])
					end
				end

				local colorOfText = rgba(200, 200, 200)

				if i + offsetVeh == selectedVeh then
					colorOfText = rgba(200, 200, 200)
				elseif activeButton == "selectVehicle:" .. i + offsetVeh then
					colorOfText = rgba(200, 200, 200)
				end

				dxDrawImage(math.floor(startX + 10), math.floor(lineY + oneSize / 2 - respc(32) / 2), respc(32), respc(32), "files/images/vehicletypes/" .. datas.vehicleType .. ".png", 0, 0, 0, colorOfText)
				dxDrawText(datas.vehicleName, startX + 20 + respc(32), lineY, 0, lineY + oneSize, colorOfText, 0.75, Roboto, "left", "center")
				dxDrawText("ID: " .. formatNumber(datas["vehicle.dbID"], ",") .. " | " .. table.concat(plateSections, "-"), 0, lineY, startX + oneSegmentSizeX - 10, lineY + oneSize, colorOfText, 0.75, Roboto, "right", "center")

				buttons["selectVehicle:" .. i + offsetVeh] = {startX, lineY, oneSegmentSizeX, oneSize}
			elseif veh then
				dxDrawText("Hiányzó jármű.", startX + 10, lineY, 0, lineY + oneSize, rgba(255, 150, 0), 0.5, RobotoB, "left", "center")
			end
		end

		if maxThings > num then
			local trackSize = num * oneSize
			dxDrawRectangle(startX + oneSegmentSizeX, startY, 5, trackSize, rgba(45,45,45))
			dxDrawRectangle(startX + oneSegmentSizeX, startY + offsetVeh * (trackSize / maxThings), 5, trackSize / maxThings * num, rgba(61, 122, 188, 150))
		end

		local veh = playerVehicles[selectedVeh]

		if isElement(veh) then
			local datas = vehicleDatas[veh]

			local startY = startY + oneSegmentSizeY + respc(10)
			local sectionSize = (y + sy - headerHeight) - startY

			local holderSizeX = oneSegmentSizeX / 2
			local scale = 0.65
			local height = respc(30) * scale

			if (datas["vehicle.group"] or 0) == 0 then
				--if activeButton == "sell_vehicle" then
				--	dxDrawRectangle(startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), respc(100), respc(35), rgba(61, 122, 188, 240))
				--else
					--dxDrawRectangle(startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), respc(100), respc(35), rgba(61, 122, 188, 180))
				--end

				--dxDrawText("Eladás", startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), startX + oneSegmentSizeX - respc(5), startY + sectionSize - respc(20), rgba(0, 0, 0), 0.5, RobotoB, "center", "center")
				drawButton("sell_vehicle", "Eladás", startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), respc(100), respc(35), {61, 122, 188}, false, Roboto)
				buttons["sell_vehicle"] = {startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), respc(100), respc(35)}
			end

			local kilometersToChangeOil = 500 - math.floor(math.floor(datas["lastOilChange"] or 0) / 1000)

			if kilometersToChangeOil <= 0 then
				kilometersToChangeOil = "Olajcsere szükséges"
			else
				kilometersToChangeOil = "#3d7abc"..formatNumber(kilometersToChangeOil) .. " #ffffffkm múlva"
			end

			local health = math.floor(getElementHealth(veh) / 10)

			if health < 32 then
				health = 32
			end

			health = math.floor(reMap(health, 32, 100, 0, 100))

			local s2 = startY
			local s3 = 0

			startY, w1 = drawDataRow(startX, startY, height, "Kilóméterszámláló állása: ", "#3d7abc"..formatNumber(math.floor(datas["vehicle.distance"] * 10) / 10) .. "#ffffff km", scale)
			
			s3, w2 = drawDataRow(startX + w1 + respc(10), s2, height, "Olajcsere: ", kilometersToChangeOil, scale)
			
			s3, w3 = drawDataRow(startX + w1 + w2 + respc(20), s2, height, "Állapot: ", "#3d7abc"..health .. "#ffffff %", scale)
			
			drawDataRow(startX + w1 + w2 + w3 + respc(30), s2, height, "Üzemanyag: ", "#3d7abc"..math.floor((datas["vehicle.fuel"] or datas["vehicle.maxFuel"]) / datas["vehicle.maxFuel"] * 100) .. " #ffffff%", scale)

			local s = 0

			s, w1 = drawDataRow(startX, startY, height, "Motor: ", (datas["vehicle.engine"] == 1 and "#3d7abcelindítva" or "#3d7abcleállítva"), scale)
			
			s, w2 = drawDataRow(startX + w1 + respc(10), startY, height, "Lámpa: ", (getVehicleOverrideLights(veh) == 2 and "#3d7abcfelkapcsolva" or "#3d7abclekapcsolva"), scale)
			
			s, w3 = drawDataRow(startX + w1 + w2 + respc(20), startY, height, "Kézifék: ", (datas["vehicle.handBrake"] and "#3d7abcbehúzva" or "#3d7abckiengedve"), scale)
			
			startY = drawDataRow(startX + w1 + w2 + w3 + respc(30), startY, height, "Ajtók: ", (datas["vehicle.locked"] == 1 and "#3d7abczárva" or "#3d7abcnyitva"), scale)

			startY = startY + respc(10)
			dxDrawRectangle(startX, startY, oneSegmentSizeX, 2, rgba(200,200,200, 50))
			startY = startY + respc(10)

			s, w1 = drawDataRow(startX, startY, height, "Motor: ", tuningName[datas["vehicle.tuning.Engine"] or 0], scale)
			
			s, w5 = drawDataRow(startX + w1 + respc(10), startY, height, "Fék: ", tuningName[datas["vehicle.tuning.Brakes"] or 0], scale)
			
			s, w2 = drawDataRow(startX + w1 + w5 + respc(20), startY, height, "Turbo: ", tuningName[datas["vehicle.tuning.Turbo"] or 0], scale)
			
			s, w3 = drawDataRow(startX + w1 + w5 + w2 + respc(30), startY, height, "ECU: ", tuningName[datas["vehicle.tuning.ECU"] or 0], scale)
			
			startY, w4 = drawDataRow(startX + w1 + w5 + w2 + w3 + respc(40), startY, height, "Váltó: ", tuningName[datas["vehicle.tuning.Transmission"] or 0], scale)
			
			s, w6 = drawDataRow(startX, startY, height, "Gumi:  ", tuningName[datas["vehicle.tuning.Tires"] or 0], scale)
			
			s, w7 = drawDataRow(startX + w6 + respc(10), startY, height, "Súlycsökkentés: ", tuningName[datas["vehicle.tuning.WeightReduction"] or 0], scale)
			
			startY = drawDataRow(startX + w6 + w7 + respc(20), startY, height, "Felfüggesztés: ", tuningName[datas["vehicle.tuning.Suspension"] or 0], scale)

			if (datas["vehicle.nitroLevel"] or 0) == 0 then
				s, w1 = drawDataRow(startX, startY, height, "Nitro: ", "#3d7abc" .. math.floor(datas["vehicle.nitroLevel"] or 0) .. "%", scale)
			elseif (datas["vehicle.nitroLevel"] or 0) <= 50 then
				s, w1 = drawDataRow(startX, startY, height, "Nitro: ", "#3d7abc" .. math.floor(datas["vehicle.nitroLevel"] or 0) .. "%", scale)
			elseif (datas["vehicle.nitroLevel"] or 0) > 50 then
				s, w1 = drawDataRow(startX, startY, height, "Nitro: ", "#3d7abc" .. math.floor(datas["vehicle.nitroLevel"] or 0) .. "%", scale)
			end

			if (datas["vehicle.tuning.AirRide"] or 0) == 1 then
				s, w2 = drawDataRow(startX + w1 + respc(10), startY, height, "AirRide: ", "#3d7abcvan", scale)
			else
				s, w2 = drawDataRow(startX + w1 + respc(10), startY, height, "AirRide: ", "#3d7abcnincs", scale)
			end

			if (datas["tuning.neon"] or 0) > 10000 then
				s, w3 = drawDataRow(startX + w1 + w2 + respc(20), startY, height, "Neon: ", "#3d7abcvan", scale)
			else
				s, w3 = drawDataRow(startX + w1 + w2 + respc(20), startY, height, "Neon: ", "#3d7abcnincs", scale)
			end
		else
			local startY = startY + oneSegmentSizeY
			local sectionSize = (y + sy - headerHeight) - startY

			dxDrawText("Nincs jármű kiválasztva.", startX, startY, startX + oneSegmentSizeX, startY + sectionSize, rgba(255, 150, 0), 0.5, RobotoB, "center", "center")
		end

		-- Ingatlanok
		startX = x + sx - oneSegmentSizeX - respc(20)

		local maxThings = #playerInteriors

		dxDrawRectangle(startX, startY - respc(50), oneSegmentSizeX, respc(45), rgba(35, 35, 35))
		dxDrawText("Ingatlanjaim (#3d7abc" .. maxThings .. " #ffffffdb/#3d7abc" .. myDatas["char.interiorLimit"] .. " #ffffffdb)", startX, startY - respc(50), startX + oneSegmentSizeX, startY - respc(5), rgba(200,200,200), 0.85, RobotoL, "center", "center", false, false, false, true)

		--if activeButton == "more_intslot" then
		--	dxDrawRectangle(startX + oneSegmentSizeX - respc(105), startY - respc(50) + respc(45) / 2 - respc(35) / 2, respc(100), respc(35), rgba(61, 122, 188, 240))
		--else
		--	dxDrawRectangle(startX + oneSegmentSizeX - respc(105), startY - respc(50) + respc(45) / 2 - respc(35) / 2, respc(100), respc(35), rgba(61, 122, 188, 180))
		--end

		--dxDrawText("+ slot", startX + oneSegmentSizeX - respc(105), startY - respc(50), startX + oneSegmentSizeX - respc(5), startY - respc(5), rgba(200,200,200), 0.5, RobotoB, "center", "center")
		drawButton("more_intslot", "+ slot", startX + oneSegmentSizeX - respc(105), startY - respc(50) + respc(45) / 2 - respc(35) / 2, respc(100), respc(35), {61, 122, 188, 170}, false, Roboto)
		buttons["more_intslot"] = {startX + oneSegmentSizeX - respc(105), startY - respc(50) + respc(45) / 2 - respc(35) / 2, respc(100), respc(35)}

		dxDrawRectangle(startX, startY, oneSegmentSizeX, oneSegmentSizeY, rgba(35, 35, 35))

		local num = 11
		local oneSize = oneSegmentSizeY / num

		for i = 1, num do
			local lineY = startY + (i - 1) * oneSize
			local int = playerInteriors[i + offsetInt]

			if i + offsetInt == selectedInt and int then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(61, 122, 188, 150))
			elseif activeButton == "selectInterior:" .. i + offsetInt then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(61, 122, 188, 50))
			else
				if i % 2 == 0 then
					dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(0, 0, 0, 30))
				end
			end

			if i ~= num then
				dxDrawRectangle(startX, lineY + oneSize, oneSegmentSizeX, 2, rgba(45, 45, 45))
			end

			if int then
				local datas = int.data
				local colorOfText = rgba(200, 200, 200)

				if i + offsetInt == selectedInt then
					colorOfText = rgba(200, 200, 200)
				elseif activeButton == "selectInterior:" .. i + offsetInt then
					colorOfText = rgba(200, 200, 200)
				end

				if datas.iconPicture then
					dxDrawImage(math.floor(startX + 10), math.floor(lineY + oneSize / 2 - respc(32) / 2), respc(32), respc(32), datas.iconPicture, 0, 0, 0, colorOfText)
				end

				dxDrawText(datas.name, startX + 20 + respc(32), lineY, 0, lineY + oneSize, colorOfText, 0.75, Roboto, "left", "center")
				dxDrawText("ID: " .. formatNumber(datas.interiorId, ","), 0, lineY, startX + oneSegmentSizeX - 10, lineY + oneSize, colorOfText, 0.75, Roboto, "right", "center")

				buttons["selectInterior:" .. i + offsetInt] = {startX, lineY, oneSegmentSizeX, oneSize}
			end
		end

		if maxThings > num then
			local trackSize = num * oneSize
			dxDrawRectangle(startX + oneSegmentSizeX, startY, 5, trackSize, rgba(200,200,200, 25))
			dxDrawRectangle(startX + oneSegmentSizeX, startY + offsetInt * (trackSize / maxThings), 5, trackSize / maxThings * num, rgba(61, 122, 188, 150))
		end

		local int = playerInteriors[selectedInt]

		if int then
			local datas = int.data

			local startY = startY + oneSegmentSizeY + respc(10)
			local sectionSize = (y + sy - headerHeight) - startY

			local holderSizeX = oneSegmentSizeX / 2
			local scale = 0.65
			local height = respc(30) * scale

			if datas.type ~= "rentable" then
				--if activeButton == "sell_interior" then
				--	dxDrawRectangle(startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), respc(100), respc(35), rgba(61, 122, 188, 240))
				--else
				--	dxDrawRectangle(startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), respc(100), respc(35), rgba(61, 122, 188, 180))
				--end

				--dxDrawText("Eladás", startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), startX + oneSegmentSizeX - respc(5), startY + sectionSize - respc(20), rgba(0, 0, 0), 0.5, RobotoB, "center", "center")
				drawButton("sell_interior", "Eladás", startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), respc(100), respc(35), {61, 122, 188}, false, Roboto)
				buttons["sell_interior"] = {startX + oneSegmentSizeX - respc(105), startY + sectionSize - respc(55), respc(100), respc(35)}
			end

			if datas.iconPicture then
				dxDrawImage(math.floor(startX), math.floor(startY + height - respc(24)), respc(48), respc(48), datas.iconPicture, 0, 0, 0, rgba(61, 122, 188, 150))
			end

			dxDrawText(datas["name"], startX + respc(48), startY, 0, startY + height * 2, rgba(61, 122, 188,200), 0.75, RobotoB, "left", "center")

			startY = startY + height * 3
			startY = drawDataRow(startX, startY, height, "Típus: ", "#3d7abc" .. interiorTypes[datas.type] or "#3d7abcIsmeretlen", scale)
			startY = drawDataRow(startX, startY, height, "Ajtók: ", (datas.locked == "Y" and "#3d7abcZárva" or "#3d7abcNyitva"), scale)

			if datas.type == "rentable" then
				startY = drawDataRow(startX, startY, height, "Bérleti díj: ", formatNumber(datas.price) .. " $/hét", scale)
			else
				startY = drawDataRow(startX, startY, height, "Eredeti ár: ", "#3d7abc"..formatNumber(datas.price) .. " #ffffff$", scale)
			end
		else
			local startY = startY + oneSegmentSizeY
			local sectionSize = (y + sy - headerHeight) - startY

			dxDrawText("Nincs ingatlan kiválasztva.", startX, startY, startX + oneSegmentSizeX, startY + sectionSize, rgba(255, 150, 0), 0.5, RobotoB, "center", "center")
		end
	end

	-- Frakciók
	if selectedTab == 3 then
		local startX = x + respc(20)
		local startY = y + respc(20)

		local oneSegmentSizeX = (sx - respc(40) - respc(25)) / 3.5
		local oneSegmentSizeY = sy - headerHeight - respc(20) - respc(20)

		dxDrawRectangle(startX, startY, oneSegmentSizeX, oneSegmentSizeY, rgba(35, 35, 35))

		local num = 20
		local oneSize = oneSegmentSizeY / num

		for i = 1, num do
			local lineY = startY + (i - 1) * oneSize
			local groupId = playerGroupsKeyed[i + offsetGroup]

			if i + offsetGroup == selectedGroup and tonumber(groupId) then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(61, 122, 188, 150))
			elseif activeButton == "selectGroup:" .. i + offsetGroup then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(61, 122, 188, 50))
			else
				if i % 2 == 0 then
					dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(0, 0, 0, 30))
				end
			end

			if i ~= num then
				dxDrawRectangle(startX, lineY + oneSize, oneSegmentSizeX, 2, rgba(45, 45, 45))
			end

			if playerGroupsCount < 1 and i == 10 then
				dxDrawText("Nem vagy frakcióban.", startX, lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(61, 122, 188), 0.5, RobotoB, "center", "center")
			end

			if tonumber(groupId) then
				local datas = groups[groupId]
				local colorOfText = rgba(200, 200, 200)

				if i + offsetGroup == selectedGroup then
					colorOfText = rgba(200, 200, 200)
				elseif activeButton == "selectGroup:" .. i + offsetGroup then
					colorOfText = rgba(200, 200, 200)
				end

				dxDrawText(datas.name, startX + 10, lineY, 0, lineY + oneSize, colorOfText, 0.65, Roboto, "left", "center")
				dxDrawText(groupTypes[datas.type], 0, lineY, startX + oneSegmentSizeX - 10, lineY + oneSize, colorOfText, 0.65, Roboto, "right", "center")

				buttons["selectGroup:" .. i + offsetGroup] = {startX, lineY, oneSegmentSizeX, oneSize}
			end
		end

		if playerGroupsCount > num then
			local trackSize = num * oneSize
			dxDrawRectangle(startX + oneSegmentSizeX, startY, 5, trackSize, rgba(61, 122, 188, 50))
			dxDrawRectangle(startX + oneSegmentSizeX, startY + offsetGroup * (trackSize / playerGroupsCount), 5, trackSize / playerGroupsCount * num, rgba(61, 122, 188, 150))
		end

		local groupId = playerGroupsKeyed[selectedGroup]

		if tonumber(groupId) and playerGroups[groupId] and groups[groupId] and meInGroup[groupId] then
			local group = groups[groupId]
			local myRank = meInGroup[groupId].rank

			dxDrawText(group.name .. " (" .. groupId .. ")", startX + oneSegmentSizeX, startY, x + sx, startY + respc(50), rgba(61, 122, 188,200), 0.85, RobotoB, "center", "center")

			startX = startX + oneSegmentSizeX + respc(25)
			startY = startY + respc(60)

			local oneSize = (x + sx - oneSegmentSizeX - respc(100)) / 3
			local scale = 0.65
			local height = respc(30) * scale

			local w = dxGetTextWidth("Rangod: ", scale, RobotoB2)
			w = w + dxGetTextWidth(group.ranks[myRank].name .. " (" .. myRank .. ")", scale, Roboto)

			local w2 = dxGetTextWidth("Fizetésed: ", scale, RobotoB2)
			w2 = w2 + dxGetTextWidth(formatNumber(group.ranks[myRank].pay) .. " $", scale, Roboto)

			local w3 = dxGetTextWidth("Duty skined: ", scale, RobotoB2)

			if meInGroup[groupId].dutySkin == 0 then
				w3 = w3 + dxGetTextWidth("nincs beállítva", scale, Roboto)
			else
				w3 = w3 + dxGetTextWidth(meInGroup[groupId].dutySkin, scale, Roboto)
			end

			drawDataRow(startX + (oneSize - w) / 2, startY, height, "Rangod: ", "#3d7abc"..group.ranks[myRank].name .. " #ffffff(" .. myRank .. ")", scale)
			
			drawDataRow(startX + oneSize + (oneSize - w2) / 2, startY, height, "Fizetésed: ", "#dddddd" .."#3d7abc"..formatNumber(group.ranks[myRank].pay) .. " #ffffff$", scale)
			
			if meInGroup[groupId].dutySkin == 0 then
				drawDataRow(startX + oneSize * 2 + (oneSize - w3) / 2, startY, height, "Duty skined: ", "#3d7abcnincs beállítva", scale)
			else
				drawDataRow(startX + oneSize * 2 + (oneSize - w3) / 2, startY, height, "Duty skined: ", "#3d7abc" .. meInGroup[groupId].dutySkin, scale)
			end

			-- Tabok
			startY = startY + height + respc(10)

			local oneSize = (x + sx - oneSegmentSizeX - respc(100)) / 4

			for i = 1, 4 do
				local lineX = startX + (i - 1) * oneSize
				local colorOfText = rgba(200, 200, 200)

				if selectedGroupTab == i then
					dxDrawRectangle(lineX, startY, oneSize, respc(35), rgba(61, 122, 188, 150))
				else
					if activeButton == "selectGroupTab:" .. i then
						dxDrawRectangle(lineX, startY, oneSize, respc(35), rgba(61, 122, 188, 50))

						colorOfText = rgba(200, 200, 200)
					else
						dxDrawRectangle(lineX, startY, oneSize, respc(35), rgba(35,35,35))
					end
				end

				if i ~= 4 then
					dxDrawRectangle(lineX + oneSize - 1, startY, 2, respc(35), rgba(35,35,35))
				end

				dxDrawText(groupTabs[i], lineX, startY, lineX + oneSize, startY + respc(35), colorOfText, 0.75, RobotoL, "center", "center")

				buttons["selectGroupTab:" .. i] = {lineX, startY, oneSize, respc(35)}
			end

			startY = startY + respc(50)

			local oneSectionSizeX = (x + sx - oneSegmentSizeX - respc(100)) / 2
			local oneSectionSizeY = (y + sy - headerHeight) - startY - respc(20) - respc(40)

			-- Tagok
			if selectedGroupTab == 1 then
				dxDrawRectangle(startX, startY, oneSectionSizeX, oneSectionSizeY, rgba(35, 35, 35))

				local num = 14
				local oneSize = oneSectionSizeY / num
				local thisMembers = groupMembers[groupId]

				if selectedMember > #thisMembers then
					selectedMember = #thisMembers
				end

				for i = 1, num do
					local lineY = startY + (i - 1) * oneSize
					local member = thisMembers[i + offsetMember]

					if i + offsetMember == selectedMember and member then
						if member.online then
							dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(61, 122, 188, 150))
						else
							dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(61, 122, 188, 150))
						end
					elseif activeButton == "selectMember:" .. i + offsetMember then
						dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(61, 122, 188, 50))
					else
						if i % 2 == 0 then
							dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(0, 0, 0, 30))
						end
					end

					if i ~= num then
						dxDrawRectangle(startX, lineY + oneSize, oneSectionSizeX, 2, rgba(45, 45, 45))
					end

					if member then
						local colorOfText = rgba(200, 200, 200)

						if i + offsetMember == selectedMember then
							colorOfText = rgba(200, 200, 200)
						elseif activeButton == "selectMember:" .. i + offsetMember then
							if member.online then
								colorOfText = rgba(200, 200, 200)
							else
								colorOfText = rgba(200, 200, 200)
							end
						elseif not member.online then
							colorOfText = rgba(200, 200, 200)
						else
							colorOfText = rgba(200, 200, 200)
						end

						dxDrawText(member.characterName:gsub("_", " "), startX + 10, lineY, 0, lineY + oneSize, colorOfText, 0.65, Roboto, "left", "center")
						dxDrawText(group.ranks[member.rank].name .. " (" .. member.rank .. ")", 0, lineY, startX + oneSectionSizeX - 10, lineY + oneSize, colorOfText, 0.65, Roboto, "right", "center")

						buttons["selectMember:" .. i + offsetMember] = {startX, lineY, oneSectionSizeX, oneSize}
					end
				end

				local trackSize = num * oneSize

				if #thisMembers > num then
					dxDrawRectangle(startX + oneSectionSizeX, startY, 5, trackSize, rgba(35, 35, 35))
					dxDrawRectangle(startX + oneSectionSizeX, startY + offsetMember * (trackSize / #thisMembers), 5, trackSize / #thisMembers * num, rgba(61, 122, 188, 150))
				end

				dxDrawText(math.ceil(offsetMember / num) + 1 .. "/" .. math.ceil(#thisMembers / num) .. ". oldal (" .. selectedMember .. "/" .. #thisMembers .. "db tag)", startX, startY + trackSize, startX + oneSectionSizeX, startY + trackSize + respc(40), rgba(200, 200, 200), 0.6, Roboto, "center", "center")
				
				local member = thisMembers[selectedMember]

				if member then
					local startX = startX + oneSectionSizeX

					dxDrawText(member.characterName:gsub("_", " "), startX, startY, startX + oneSectionSizeX, startY + respc(50), rgba(200, 200, 200), 0.75, RobotoB, "center", "center")

					startX = startX + respc(20)
					startY = startY + respc(50)

					dxDrawRectangle(startX, startY - respc(5), oneSectionSizeX - respc(10), 2, rgba(35, 35, 35))

					local scale = 0.85
					local height = respc(45) * scale

					startY = drawDataRow(startX, startY, height, "Rang: ", "#3d7abc" .. group.ranks[member.rank].name .. " #ffffff(" .. member.rank .. ")", scale)
					startY = drawDataRow(startX, startY, height, "Fizetés: ", "#dddddd" .. formatNumber(group.ranks[member.rank].pay) .. " #3d7abc$", scale)
					
					if member.dutySkin == 0 then
						startY = drawDataRow(startX, startY, height, "Duty skin: ", "#3d7abcnincs beállítva", scale)
					else
						startY = drawDataRow(startX, startY, height, "Duty skin: ", "#3d7abc" .. member.dutySkin, scale)
					end

					local lastOnline = split(member.lastOnline or "#3d7abcnem_volt_még_online", " ")

					startY = drawDataRow(startX, startY, height, "Utoljára online: ", "#3d7abc" .. lastOnline[1]:gsub("_", " "), scale)

					if member.isLeader == "Y" then
						startY = drawDataRow(startX, startY, height, "Leader: ", "#3d7abcigen", scale)
					else
						startY = drawDataRow(startX, startY, height, "Leader: ", "#3d7abcnem", scale)
					end

					if member.online then
						startY = drawDataRow(startX, startY, height, "Online: ", "#3d7abcigen", scale)
					else
						startY = drawDataRow(startX, startY, height, "Online: ", "#3d7abcnem", scale)
					end

					startY = startY + respc(80)

					if meInGroup[groupId].isLeader == "Y" then
						local buttonMargin = respc(20)
						local buttonSizeX = oneSectionSizeX - respc(10)
						local buttonSizeY = ((y + sy - headerHeight) - startY - buttonMargin * 4) / 4

						local groupButtonColors = {
							rgba(61, 122, 188, 120),
							rgba(61, 122, 188, 120),
							rgba(61, 122, 188, 120),
							rgba(61, 122, 188, 120)
						}

						local groupButtonColorsHover = {
							rgba(61, 122, 188, 180),
							rgba(61, 122, 188, 180),
							rgba(61, 122, 188, 180),
							rgba(61, 122, 188, 180)
						}

						for i = 1, 4 do
							local buttonY = startY + (buttonSizeY + buttonMargin) * (i - 1)
							local fontFamily = RobotoL

							if i == 4 and fakeInputError then
								local acceptWidth = respc(75)

								dxDrawText(fakeInputError, startX, buttonY, 0, buttonY + buttonSizeY, rgba(200, 200, 200), 0.75, RobotoB2, "left", "center", false, false, false, true)

								if activeButton == "errorOk" then
									dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColorsHover[1])
								else
									dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColors[1])
								end

								dxDrawText("OK", startX + buttonSizeX - acceptWidth, buttonY, startX + buttonSizeX, buttonY + buttonSizeY, rgba(0, 0, 0), 0.65, fontFamily, "center", "center")
								
								buttons["errorOk"] = {startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY}
							elseif i == 4 and activeFakeInput == "inviting" then
								local acceptWidth = respc(75)

								dxDrawRectangle(startX, buttonY, buttonSizeX - acceptWidth - respc(10), buttonSizeY, rgba(40, 40, 40, 200))

								if string.len(fakeInputText) < 1 then
									dxDrawText("Hozzáadandó névrészlete/id-je", startX + respc(10), buttonY, startX + buttonSizeX - acceptWidth - respc(20), buttonY + buttonSizeY, rgba(100, 100, 100), 0.75, Roboto, "left", "center")
								else
									dxDrawText(fakeInputText, startX + respc(10), buttonY, startX + buttonSizeX - acceptWidth - respc(20), buttonY + buttonSizeY, rgba(200, 200, 200), 0.75, Roboto, "left", "center")
								end

								if cursorState then
									local w = dxGetTextWidth(fakeInputText, 0.75, Roboto)
									dxDrawRectangle(startX + respc(10) + w, buttonY + respc(5), 2, buttonSizeY - respc(10), rgba(200,200,200))
								end

								if activeButton == "groupInvite" then
									dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColorsHover[1])
								else
									dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColors[1])
								end

								dxDrawText("Hozzáad", startX + buttonSizeX - acceptWidth, buttonY, startX + buttonSizeX, buttonY + buttonSizeY, rgba(200, 200, 200), 0.65, fontFamily, "center", "center")
								
								buttons["groupInvite"] = {startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY}
							elseif i == 3 and memberFirePrompt then
								local acceptWidth = respc(75)

								dxDrawText(fireErrorText, startX, buttonY, 0, buttonY + buttonSizeY, rgba(200, 200, 200), 0.75, RobotoB2, "left", "center", false, false, false, true)

								if activeButton == "cancelFire" then
									dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColorsHover[3])
								else
									dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColors[3])
								end

								if activeButton == "fireMember" then
									dxDrawRectangle(startX + buttonSizeX - acceptWidth * 2 - respc(10), buttonY, acceptWidth, buttonSizeY, groupButtonColorsHover[1])
								else
									dxDrawRectangle(startX + buttonSizeX - acceptWidth * 2 - respc(10), buttonY, acceptWidth, buttonSizeY, groupButtonColors[1])
								end

								dxDrawText("Mégsem", startX + buttonSizeX - acceptWidth, buttonY, startX + buttonSizeX, buttonY + buttonSizeY, rgba(200, 200, 200), 0.65, fontFamily, "center", "center")
								dxDrawText("Kirúgás", startX + buttonSizeX - acceptWidth * 2 - respc(10), buttonY, startX + buttonSizeX - acceptWidth - respc(10), buttonY + buttonSizeY, rgba(200, 200, 200), 0.65, fontFamily, "center", "center")
								
								buttons["cancelFire"] = {startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY}
								buttons["fireMember"] = {startX + buttonSizeX - acceptWidth * 2 - respc(10), buttonY, acceptWidth, buttonSizeY}
							else
								if activeButton == "groupaction:" .. i then
									dxDrawRectangle(startX, buttonY, buttonSizeX, buttonSizeY, groupButtonColorsHover[i])
									fontFamily = Roboto
								else
									dxDrawRectangle(startX, buttonY, buttonSizeX, buttonSizeY, groupButtonColors[i])
								end

								dxDrawText(groupButtonCaptions[i], startX, buttonY, startX + buttonSizeX, buttonY + buttonSizeY, rgba(200, 200, 200), 0.75, fontFamily, "center", "center")

								buttons["groupaction:" .. i] = {startX, buttonY, buttonSizeX, buttonSizeY}
							end
						end
					end
				end
			-- Rangok
			elseif selectedGroupTab == 2 then
				dxDrawRectangle(startX, startY, oneSectionSizeX, oneSectionSizeY, rgba(35,35,35))

				local num = 14
				local oneSize = oneSectionSizeY / num
				local thisRanks = group.ranks

				for i = 1, num do
					local lineY = startY + (i - 1) * oneSize
					local rank = thisRanks[i + offsetRank]

					if i + offsetRank == selectedRank and rank then
						dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(61, 122, 188, 150))
					elseif activeButton == "selectRank:" .. i + offsetRank then
						dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(61, 122, 188, 50))
					else
						if i % 2 == 0 then
							dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(0, 0, 0, 30))
						end
					end

					if i ~= num then
						dxDrawRectangle(startX, lineY + oneSize, oneSectionSizeX, 2, rgba(45, 45, 45))
					end

					if rank then
						local colorOfText = rgba(200, 200, 200)

						if i + offsetRank == selectedRank then
							colorOfText = rgba(200, 200, 200)
						elseif activeButton == "selectRank:" .. i + offsetRank then
							colorOfText = rgba(200, 200, 200)
						end

						dxDrawText("[" .. i + offsetRank .. "] " .. rank.name, startX + 10, lineY, 0, lineY + oneSize, colorOfText, 0.65, Roboto, "left", "center")
						dxDrawText(formatNumber(rank.pay) .. " $", 0, lineY, startX + oneSectionSizeX - 10, lineY + oneSize, colorOfText, 0.65, Roboto, "right", "center")

						buttons["selectRank:" .. i + offsetRank] = {startX, lineY, oneSectionSizeX, oneSize}
					end
				end

				local trackSize = num * oneSize

				if #thisRanks > num then
					dxDrawRectangle(startX + oneSectionSizeX, startY, 5, trackSize, rgba(35, 35, 35))
					dxDrawRectangle(startX + oneSectionSizeX, startY + offsetRank * (trackSize / #thisRanks), 5, trackSize / #thisRanks * num, rgba(61, 122, 188, 150))
				end

				dxDrawText(math.ceil(offsetRank / num) + 1 .. "/" .. math.ceil(#thisRanks / num) .. ". oldal (" .. selectedRank .. "/" .. #thisRanks .. "db rang)", startX, startY + trackSize, startX + oneSectionSizeX, startY + trackSize + respc(40), rgba(200,200,200), 0.6, Roboto, "center", "center")
				
				local thisRank = thisRanks[selectedRank]

				if thisRank then
					local startX = startX + oneSectionSizeX

					dxDrawText(thisRank.name, startX, startY, startX + oneSectionSizeX, startY + respc(50), rgba(200,200,200), 0.75, RobotoB, "center", "center")

					startX = startX + respc(20)
					startY = startY + respc(50)

					dxDrawRectangle(startX, startY - respc(5), oneSectionSizeX - respc(10), 2, rgba(200,200,200, 40))

					local scale = 0.85
					local height = respc(45) * scale

					startY = drawDataRow(startX, startY, height, "Tagok száma ezen a rangon: ", "#3d7abc" .. (rankCount[groupId][selectedRank] or 0) .. " #ffffffdb", scale)
					startY = drawDataRow(startX, startY, height, "Fizetés: ", "#dddddd" .. formatNumber(thisRank.pay) .. " #3d7abc$", scale)
					
					startY = startY + respc(30)

					if meInGroup[groupId].isLeader == "Y" then
						local buttonMargin = respc(20)
						local buttonSizeX = oneSectionSizeX - respc(10)
						local buttonSizeY = respc(45)--((y + sy - headerHeight) - startY - buttonMargin * 2) / 2

						local groupButtonColors = {
							rgba(61, 122, 188, 200),
							rgba(61, 122, 188, 200)
						}

						local groupButtonColorsHover = {
							rgba(61, 122, 188, 240),
							rgba(61, 122, 188, 240)
						}

						for i = 1, 2 do
							local buttonY = startY + (buttonSizeY + buttonMargin) * (i - 1)
							local fontFamily = RobotoL

							if (i == 1 and activeFakeInput == "setrankname") or (i == 2 and activeFakeInput == "setrankpay") then
								if fakeInputError then
									local acceptWidth = respc(75)

									dxDrawText(fakeInputError, startX, buttonY, 0, buttonY + buttonSizeY, rgba(200,200,200), 0.75, RobotoB2, "left", "center", false, false, false, true)

									if activeButton == "errorOk" then
										dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColorsHover[1])
									else
										dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColors[1])
									end

									dxDrawText("OK", startX + buttonSizeX - acceptWidth, buttonY, startX + buttonSizeX, buttonY + buttonSizeY, rgba(0, 0, 0), 0.65, fontFamily, "center", "center")
									
									buttons["errorOk"] = {startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY}
								else
									local acceptWidth = respc(75)

									dxDrawRectangle(startX, buttonY, buttonSizeX - acceptWidth - respc(10), buttonSizeY, rgba(40, 40, 40, 200))

									if utf8.len(fakeInputText) < 1 then
										if i == 1 then
											dxDrawText(thisRank.name, startX + respc(10), buttonY, startX + buttonSizeX - acceptWidth - respc(20), buttonY + buttonSizeY, rgba(100, 100, 100), 0.75, Roboto, "left", "center")
										elseif i == 2 then
											dxDrawText(thisRank.pay, startX + respc(10), buttonY, startX + buttonSizeX - acceptWidth - respc(20), buttonY + buttonSizeY, rgba(100, 100, 100), 0.75, Roboto, "left", "center")
										end
									else
										dxDrawText(fakeInputText, startX + respc(10), buttonY, startX + buttonSizeX - acceptWidth - respc(20), buttonY + buttonSizeY, rgba(200,200,200), 0.75, Roboto, "left", "center")
									end

									if cursorState then
										local w = dxGetTextWidth(fakeInputText, 0.75, Roboto)
										dxDrawRectangle(startX + respc(10) + w, buttonY + respc(5), 2, buttonSizeY - respc(10), rgba(200,200,200))
									end

									if activeButton == activeFakeInput then
										dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColorsHover[1])
									else
										dxDrawRectangle(startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY, groupButtonColors[1])
									end

									dxDrawText("Módosít", startX + buttonSizeX - acceptWidth, buttonY, startX + buttonSizeX, buttonY + buttonSizeY, rgba(0, 0, 0), 0.65, fontFamily, "center", "center")
									
									buttons[activeFakeInput] = {startX + buttonSizeX - acceptWidth, buttonY, acceptWidth, buttonSizeY}
								end
							else
								if activeButton == "rankaction:" .. i then
									dxDrawRectangle(startX, buttonY, buttonSizeX, buttonSizeY, groupButtonColorsHover[i])
									fontFamily = Roboto
								else
									dxDrawRectangle(startX, buttonY, buttonSizeX, buttonSizeY, groupButtonColors[i])
								end

								dxDrawText(groupButtonCaptions2[i], startX, buttonY, startX + buttonSizeX, buttonY + buttonSizeY, rgba(0, 0, 0), 0.75, fontFamily, "center", "center")

								buttons["rankaction:" .. i] = {startX, buttonY, buttonSizeX, buttonSizeY}
							end
						end
					end
				end
			-- Kocsik
			elseif selectedGroupTab == 3 then
				dxDrawRectangle(startX, startY, oneSectionSizeX, oneSectionSizeY, rgba(35, 35, 35))

				local num = 14
				local oneSize = oneSectionSizeY / num
				local vehicles = groupVehicles[groupId]
				factionVehicleList = vehicles

				for i = 1, num do
					local lineY = startY + (i - 1) * oneSize
					local veh = vehicles[i + offsetGroupVeh]

					if i + offsetGroupVeh == selectedGroupVeh and isElement(veh) then
						dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(61, 122, 188, 150))
					elseif activeButton == "selectGroupVeh:" .. i + offsetGroupVeh then
						dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(61, 122, 188, 50))
					else
						if i % 2 == 0 then
							dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(0, 0, 0,20))
						end
					end

					if i ~= num then
						dxDrawRectangle(startX, lineY + oneSize, oneSectionSizeX, 2, rgba(45,45,45))
					end

					if isElement(veh) then
						local datas = vehicleDatas[veh]

						local plateText = split(getVehiclePlateText(veh), "-")
						local plateSections = {}

						for i = 1, #plateText do
							if utf8.len(plateText[i]) > 0 then
								table.insert(plateSections, plateText[i])
							end
						end

						local colorOfText = rgba(200, 200, 200)

						if i + offsetGroupVeh == selectedGroupVeh then
							colorOfText = rgba(200, 200, 200)
						elseif activeButton == "selectGroupVeh:" .. i + offsetGroupVeh then
							colorOfText = rgba(200, 200, 200)
						end

						dxDrawImage(math.floor(startX + 10), math.floor(lineY + oneSize / 2 - respc(32) / 2), respc(32), respc(32), "files/images/vehicletypes/" .. datas.vehicleType .. ".png", 0, 0, 0, colorOfText)
						dxDrawText(datas.vehicleName, startX + 20 + respc(32), lineY, 0, lineY + oneSize, colorOfText, 0.75, Roboto, "left", "center")
						dxDrawText("ID: " .. formatNumber(datas["vehicle.dbID"], ",") .. " | " .. table.concat(plateSections, "-"), 0, lineY, startX + oneSectionSizeX - 10, lineY + oneSize, colorOfText, 0.75, Roboto, "right", "center")

						buttons["selectGroupVeh:" .. i + offsetGroupVeh] = {startX, lineY, oneSectionSizeX, oneSize}
					elseif veh then
						dxDrawText("Hiányzó jármű.", startX + 10, lineY, 0, lineY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
					end
				end

				local trackSize = num * oneSize

				if #vehicles > num then
					dxDrawRectangle(startX + oneSectionSizeX, startY, 5, trackSize, rgba(45, 45, 45))
					dxDrawRectangle(startX + oneSectionSizeX, startY + offsetGroupVeh * (trackSize / #vehicles), 5, trackSize / #vehicles * num, rgba(61, 122, 188, 150))
				end

				dxDrawText(math.ceil(offsetGroupVeh / num) + 1 .. "/" .. math.ceil(#vehicles / num) .. ". oldal (" .. selectedGroupVeh .. "/" .. #vehicles .. "db jármű)", startX, startY + trackSize, startX + oneSectionSizeX, startY + trackSize + respc(40), rgba(200,200,200), 0.6, Roboto, "center", "center")
				
				local veh = vehicles[selectedGroupVeh]

				if isElement(veh) then
					local datas = vehicleDatas[veh]

					local startX = startX + oneSectionSizeX

					dxDrawText(datas.vehicleName, startX, startY, startX + oneSectionSizeX, startY + respc(50), rgba(200,200,200), 0.75, RobotoB, "center", "center")

					startX = startX + respc(20)
					startY = startY + respc(50)

					dxDrawRectangle(startX, startY - respc(5), oneSectionSizeX - respc(10), 2, rgba(200,200,200, 40))

					local scale = 0.75
					local height = respc(30) * scale

					if datas["vehicle.engine"] == 1 then
						startY = drawDataRow(startX, startY, height, "Motor: ", "#3d7abcelindítva", scale)
					else
						startY = drawDataRow(startX, startY, height, "Motor: ", "#3d7abcleállítva", scale)
					end

					if getVehicleOverrideLights(veh) == 2 then
						startY = drawDataRow(startX, startY, height, "Lámpa: ", "#3d7abcfelkapcsolva", scale)
					else
						startY = drawDataRow(startX, startY, height, "Lámpa: ", "#3d7abclekapcsolva", scale)
					end

					if datas["vehicle.handBrake"] then
						startY = drawDataRow(startX, startY, height, "Kézifék: ", "#3d7abc6behúzva", scale)
					else
						startY = drawDataRow(startX, startY, height, "Kézifék: ", "#3d7abckiengedve", scale)
					end

					if datas["vehicle.locked"] == 1 then
						startY = drawDataRow(startX, startY, height, "Ajtók: ", "#3d7abczárva", scale)
					else
						startY = drawDataRow(startX, startY, height, "Ajtók: ", "#3d7abcnyitva", scale)
					end

					startY = startY + height

					if (datas["vehicle.nitroLevel"] or 0) == 0 then
						startY = drawDataRow(startX, startY, height, "Nitro: ", "#3d7abc" .. math.floor(datas["vehicle.nitroLevel"] or 0) .. "%", scale)
					elseif (datas["vehicle.nitroLevel"] or 0) <= 50 then
						startY = drawDataRow(startX, startY, height, "Nitro: ", "#3d7abc" .. math.floor(datas["vehicle.nitroLevel"] or 0) .. "%", scale)
					elseif (datas["vehicle.nitroLevel"] or 0) > 50 then
						startY = drawDataRow(startX, startY, height, "Nitro: ", "#3d7abc" .. math.floor(datas["vehicle.nitroLevel"] or 0) .. "%", scale)
					end

					if (datas["vehicle.tuning.AirRide"] or 0) == 1 then
						startY = drawDataRow(startX, startY, height, "AirRide: ", "#3d7abcvan", scale)
					else
						startY = drawDataRow(startX, startY, height, "AirRide: ", "#3d7abcnincs", scale)
					end

					if (datas["tuning.neon"] or 0) > 10000 then
						startY = drawDataRow(startX, startY, height, "Neon: ", "#3d7abcvan", scale)
					else
						startY = drawDataRow(startX, startY, height, "Neon: ", "#3d7abcnincs", scale)
					end

					startY = drawDataRow(startX, startY, height, "Motor: ", tuningName[datas["vehicle.tuning.Engine"] or 0], scale)
					startY = drawDataRow(startX, startY, height, "Fék: ", tuningName[datas["vehicle.tuning.Brakes"] or 0], scale)
					startY = drawDataRow(startX, startY, height, "Turbo: ", tuningName[datas["vehicle.tuning.Turbo"] or 0], scale)
					startY = drawDataRow(startX, startY, height, "ECU: ", tuningName[datas["vehicle.tuning.ECU"] or 0], scale)
					startY = drawDataRow(startX, startY, height, "Váltó: ", tuningName[datas["vehicle.tuning.Transmission"] or 0], scale)
					startY = drawDataRow(startX, startY, height, "Gumi: ", tuningName[datas["vehicle.tuning.Tires"] or 0], scale)
					startY = drawDataRow(startX, startY, height, "Súlycsökkentés: ", tuningName[datas["vehicle.tuning.WeightReduction"] or 0], scale)
					startY = drawDataRow(startX, startY, height, "Felfüggesztés: ", tuningName[datas["vehicle.tuning.Suspension"] or 0], scale)

					local health = math.floor(getElementHealth(veh) / 10)

					if health < 32 then
						health = 32
					end

					health = math.floor(reMap(health, 32, 100, 0, 100))

					local kilometersToChangeOil = 500 - math.floor(math.floor(datas["lastOilChange"] or 0) / 1000)

					if kilometersToChangeOil <= 0 then
						kilometersToChangeOil = "Olajcsere szükséges"
					else
						kilometersToChangeOil = formatNumber(kilometersToChangeOil) .. "#ffffff km múlva"
					end

					startY = startY + height
					startY = drawDataRow(startX, startY, height, "Állapot: ", "#3d7abc"..health .. " #ffffff%", scale)
					startY = drawDataRow(startX, startY, height, "Üzemanyag: ", "#3d7abc"..math.floor((datas["vehicle.fuel"] or datas["vehicle.maxFuel"]) / datas["vehicle.maxFuel"] * 100) .. " #ffffff%", scale)
					startY = drawDataRow(startX, startY, height, "Olajcsere: ", "#3d7abc"..kilometersToChangeOil, scale)
					startY = drawDataRow(startX, startY, height, "Kilóméterszámláló állása: ", "#3d7abc"..formatNumber(math.floor(datas["vehicle.distance"] * 10) / 10) .. " #ffffffkm", scale)
				end
			-- Egyéb
			elseif selectedGroupTab == 4 then
				if (renderData.canSelectDutySkin and not renderData.dutySkinMarker) or (renderData.canSelectDutySkin and renderData.dutySkinMarker == groupId) then
					dxDrawText("Szolgálati öltözék:", startX, startY, 0, startY + respc(50), rgba(200,200,200), 0.75, RobotoB, "left", "center")

					startY = startY + respc(50)

					buttons["setDutySkin"] = {startX, startY, oneSectionSizeX * 2, respc(40)}

					if activeButton == "setDutySkin" then
						dxDrawRectangle(startX, startY, oneSectionSizeX * 2, respc(40), rgba(61, 122, 188, 240))
					else
						dxDrawRectangle(startX, startY, oneSectionSizeX * 2, respc(40), rgba(61, 122, 188, 200))
					end

					dxDrawText("Duty skin beállítása", startX, startY, startX + oneSectionSizeX * 2, startY + respc(40), rgba(0, 0, 0), 0.75, RobotoL, "center", "center")

					startY = startY + respc(50)
				end

				dxDrawText("Megjegyzés:", startX, startY, 0, startY + respc(50), rgba(200, 200, 200), 0.75, RobotoB, "left", "center")

				startY = startY + respc(50)

				if meInGroup[groupId].isLeader == "N" then
					dxDrawText(group.description, startX + respc(10), startY + respc(10), startX + oneSectionSizeX * 2 - respc(10), startY + respc(10) + respc(200), rgba(200, 200, 200), 0.75, Roboto, "left", "top", false, true)
				else
					dxDrawRectangle(startX, startY, oneSectionSizeX * 2, respc(200), rgba(35, 35, 35))

					if activeFakeInput == "groupdesc" then
						if utf8.len(fakeInputText) < 1 then
							dxDrawText(group.description, startX + respc(10), startY + respc(10), startX + oneSectionSizeX * 2 - respc(10), startY + respc(10) + respc(200), rgba(100, 100, 100), 0.75, Roboto, "left", "top", false, true)
							
							if cursorState then
								dxDrawText("|", startX + respc(10), startY + respc(10), startX + oneSectionSizeX * 2 - respc(10), startY + respc(10) + respc(200), rgba(200,200,200), 0.75, Roboto, "left", "top", false, true)
							end
						elseif cursorState then
							dxDrawText(fakeInputText .. "|", startX + respc(10), startY + respc(10), startX + oneSectionSizeX * 2 - respc(10), startY + respc(10) + respc(200), rgba(200,200,200), 0.75, Roboto, "left", "top", false, true)
						else
							dxDrawText(fakeInputText, startX + respc(10), startY + respc(10), startX + oneSectionSizeX * 2 - respc(10), startY + respc(10) + respc(200), rgba(200,200,200), 0.75, Roboto, "left", "top", false, true)
						end

						startY = startY + respc(220)

						if activeButton == "setgroupdesc" then
							dxDrawRectangle(startX, startY, oneSectionSizeX * 2, respc(40), rgba(61, 122, 188, 240))
						else
							dxDrawRectangle(startX, startY, oneSectionSizeX * 2, respc(40), rgba(61, 122, 188, 200))
						end

						dxDrawText("Módosít", startX, startY, startX + oneSectionSizeX * 2, startY + respc(40), rgba(200, 200, 200), 0.75, RobotoL, "center", "center")

						buttons["setgroupdesc"] = {startX, startY, oneSectionSizeX * 2, respc(40)}

						startY = startY + respc(50)
					else
						dxDrawText(group.description, startX + respc(10), startY + respc(10), startX + oneSectionSizeX * 2 - respc(10), startY + respc(10) + respc(200), rgba(100, 100, 100), 0.75, Roboto, "left", "top")
						
						buttons["groupdesc"] = {startX, startY, oneSectionSizeX * 2, respc(200)}

						startY = startY + respc(220)
					end
				end

				if meInGroup[groupId].isLeader == "Y" then
					dxDrawText("Pénzügyek:", startX, startY, 0, startY + respc(50), rgba(200,200,200), 0.75, RobotoB, "left", "center")

					startY = startY + respc(50)

					if group.balance >= 0 then
						startY = drawDataRow(startX, startY, respc(40), "Egyenleg: ", formatNumber(group.balance) .. " $", 0.75)
					else
						startY = drawDataRow(startX, startY, respc(40), "Egyenleg: ", "#d75959" .. formatNumber(group.balance) .. " $", 0.75)
					end

					startY = startY + respc(10)

					local buttonSizeX = (oneSectionSizeX * 2) / 3
					local buttonSizeY = respc(40)

					if fakeInputError then
						dxDrawText(fakeInputError, startX, startY, 0, startY + buttonSizeY, rgba(200,200,200), 0.75, RobotoB2, "left", "center", false, false, false, true)

						if activeButton == "errorOk" then
							dxDrawRectangle(startX + buttonSizeX * 2, startY, buttonSizeX, buttonSizeY, rgba(255, 125, 0, 240))
						else
							dxDrawRectangle(startX + buttonSizeX * 2, startY, buttonSizeX, buttonSizeY, rgba(255, 125, 0, 200))
						end

						dxDrawText("Ok", startX + buttonSizeX * 2, startY, startX + buttonSizeX * 3, startY + buttonSizeY, rgba(0, 0, 0), 0.75, RobotoL, "center", "center")

						buttons["errorOk"] = {startX + buttonSizeX * 2, startY, buttonSizeX, buttonSizeY}
					elseif activeFakeInput == "groupbalance" then
						dxDrawRectangle(startX + buttonSizeX, startY, buttonSizeX, buttonSizeY, rgba(40, 40, 40, 200))

						local inputText = fakeInputText

						if cursorState then
							inputText = inputText .. "|"
						end

						if string.len(inputText) > 0 then
							dxDrawText(inputText, startX + buttonSizeX, startY, startX + buttonSizeX * 2, startY + buttonSizeY, rgba(200,200,200), 0.75, Roboto, "center", "center")
						end

						buttons["getoutmoney"] = {startX, startY, buttonSizeX, buttonSizeY}

						if activeButton == "getoutmoney" then
							dxDrawRectangle(startX, startY, buttonSizeX, buttonSizeY, rgba(215, 89, 89, 240))
						else
							dxDrawRectangle(startX, startY, buttonSizeX, buttonSizeY, rgba(215, 89, 89, 200))
						end

						dxDrawText("Kivétel", startX, startY, startX + buttonSizeX, startY + buttonSizeY, rgba(0, 0, 0), 0.75, RobotoL, "center", "center")

						buttons["putbackmoney"] = {startX + buttonSizeX * 2, startY, buttonSizeX, buttonSizeY}

						if activeButton == "putbackmoney" then
							dxDrawRectangle(startX + buttonSizeX * 2, startY, buttonSizeX, buttonSizeY, rgba(61, 122, 188, 240))
						else
							dxDrawRectangle(startX + buttonSizeX * 2, startY, buttonSizeX, buttonSizeY, rgba(61, 122, 188, 200))
						end

						dxDrawText("Berakás", startX + buttonSizeX * 2, startY, startX + buttonSizeX * 3, startY + buttonSizeY, rgba(0, 0, 0), 0.75, RobotoL, "center", "center")
					else
						buttons["groupbalance"] = {startX, startY, oneSectionSizeX * 2, buttonSizeY}

						if activeButton == "groupbalance" then
							dxDrawRectangle(startX, startY, oneSectionSizeX * 2, buttonSizeY, rgba(61, 122, 188, 240))
						else
							dxDrawRectangle(startX, startY, oneSectionSizeX * 2, buttonSizeY, rgba(61, 122, 188, 200))
						end

						dxDrawText("Pénzügyek kezelése", startX, startY, startX + oneSectionSizeX * 2, startY + buttonSizeY, rgba(0, 0, 0), 0.75, RobotoL, "center", "center")
					end
				end
			end
		else
			dxDrawText("Nincs kiválasztva frakció.", startX + oneSegmentSizeX, y + headerHeight, x + sx, y + sy - headerHeight * 2, rgba(200,200,200), 1, RobotoB, "center", "center")
		end
	end

	-- Adminok
	if selectedTab == 4 then
		local adminSlots = renderData.adminSlots

		local startX = x + respc(20)
		local startY = y + respc(20)

		local oneSegmentSizeX = (sx - respc(40)) / 3
		local oneSegmentSizeY = sy - headerHeight - respc(40) - respc(100)

		local num = 20
		local oneSize = oneSegmentSizeY / num

		for i = 1, num do
			local lineY = startY + (i - 1) * oneSize

			if i % 2 ~= 0 then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(35, 35, 35))
			else
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(45, 45, 45))
			end

			local slot = i

			if adminSlots[slot] then
				if adminSlots[slot][1] == "admin" or adminSlots[slot][1] == "as" then
					dxDrawText(adminSlots[slot][2], startX + respc(10), lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "left", "center", false, false, false, true)

					if adminSlots[slot][1] == "admin" then
						if adminSlots[slot][3] then
							dxDrawText("Szolgálatban: #3d7abcigen", 0, lineY, startX + oneSegmentSizeX - respc(10), lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "right", "center", false, false, false, true)
						else
							dxDrawText("Szolgálatban: #d75959nem", 0, lineY, startX + oneSegmentSizeX - respc(10), lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "right", "center", false, false, false, true)
						end
					end
				elseif adminSlots[slot][1] == "title" then
					dxDrawText(adminSlots[slot][2], startX, lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(61, 122, 188), 0.65, RobotoB2, "center", "center")
				else
					dxDrawText(adminSlots[slot][2], startX, lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "center", "center")
				end
			end
		end

		startX = startX + oneSegmentSizeX

		for i = 1, num do
			local lineY = startY + (i - 1) * oneSize

			if i % 2 == 0 then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(35, 35, 35))
			else
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(45, 45, 45))
			end

			local slot = i + num

			if adminSlots[slot] then
				if adminSlots[slot][1] == "admin" or adminSlots[slot][1] == "as" then
					dxDrawText(adminSlots[slot][2], startX + respc(10), lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "left", "center", false, false, false, true)

					if adminSlots[slot][1] == "admin" then
						if adminSlots[slot][3] then
							dxDrawText("Szolgálatban: #3d7abcigen", 0, lineY, startX + oneSegmentSizeX - respc(10), lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "right", "center", false, false, false, true)
						else
							dxDrawText("Szolgálatban: #d75959nem", 0, lineY, startX + oneSegmentSizeX - respc(10), lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "right", "center", false, false, false, true)
						end
					end
				elseif adminSlots[slot][1] == "title" then
					dxDrawText(adminSlots[slot][2], startX, lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(61, 122, 188), 0.65, RobotoB2, "center", "center")
				else
					dxDrawText(adminSlots[slot][2], startX, lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "center", "center")
				end
			end
		end

		startX = startX + oneSegmentSizeX

		for i = 1, num do
			local lineY = startY + (i - 1) * oneSize

			if i % 2 ~= 0 then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(35, 35, 35))
			else
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(45, 45, 45))
			end

			local slot = i + num * 2

			if adminSlots[slot] then
				if adminSlots[slot][1] == "admin" or adminSlots[slot][1] == "as" then
					dxDrawText(adminSlots[slot][2], startX + respc(10), lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "left", "center", false, false, false, true)

					if adminSlots[slot][1] == "admin" then
						if adminSlots[slot][3] then
							dxDrawText("Szolgálatban: #3d7abcigen", 0, lineY, startX + oneSegmentSizeX - respc(10), lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "right", "center", false, false, false, true)
						else
							dxDrawText("Szolgálatban: #d75959nem", 0, lineY, startX + oneSegmentSizeX - respc(10), lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "right", "center", false, false, false, true)
						end
					end
				elseif adminSlots[slot][1] == "title" then
					dxDrawText(adminSlots[slot][2], startX, lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(61, 122, 188), 0.65, RobotoB2, "center", "center")
				else
					dxDrawText(adminSlots[slot][2], startX, lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(200,200,200), 0.65, Roboto, "center", "center")
				end
			end
		end

		local startY = startY + oneSegmentSizeY
		local sectionSize = (y + sy - headerHeight) - startY

		dxDrawText('Az alábbi panelen a szerveren lévő adminokat/adminsegédeket láthatod. Amennyiben probléma van keress egy admint, aki szolgálatban van, majd a "/pm ID ÜZENETED" paranccsal tudsz írni nekik. Az adminisztrátor ID-jét ezen a panelen akkor látod, ha az adott online adminisztrátor szolgálatban van.', x + respc(300), startY, x + sx - respc(300), startY + sectionSize, rgba(200,200,200), 0.6, Roboto, "center", "center", false, true)
	end

	-- Petek
	if selectedTab == 5 then
		local startX = x + respc(20)
		local startY = y + respc(20)

		local oneSegmentSizeX = (sx - respc(40) - respc(25)) / 3.5
		local oneSegmentSizeY = sy - headerHeight - respc(40) - respc(50)

		dxDrawRectangle(startX, startY, oneSegmentSizeX, oneSegmentSizeY, rgba(25, 25, 25))

		local num = 18
		local oneSize = oneSegmentSizeY / num
		local maxThings = #renderData.loadedAnimals

		for i = 1, num do
			local lineY = startY + (i - 1) * oneSize
			local animal = renderData.loadedAnimals[i + renderData.offsetAnimal]

			if i + renderData.offsetAnimal == renderData.selectedAnimal and animal then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(61, 122, 188, 150))
			elseif activeButton == "selectAnimal:" .. i + renderData.offsetAnimal then
				dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(61, 122, 188, 50))
			else
				if i % 2 == 0 then
					dxDrawRectangle(startX, lineY, oneSegmentSizeX, oneSize, rgba(35, 35, 35))
				end
			end

			if i ~= num then
				dxDrawRectangle(startX, lineY + oneSize, oneSegmentSizeX, 2, rgba(45,45,45))
			end

			if maxThings < 1 and i == math.ceil(num / 2) then
				dxDrawText("Nincs peted.", startX, lineY, startX + oneSegmentSizeX, lineY + oneSize, rgba(255, 150, 0), 0.5, RobotoB, "center", "center")
			end

			if animal then
				local colorOfText = rgba(200,200,200)

				if i + renderData.offsetAnimal == renderData.selectedAnimal then
					colorOfText = rgba(200, 200, 200)
				elseif activeButton == "selectAnimal:" .. i + renderData.offsetAnimal then
					colorOfText = rgba(200, 200, 200)
				end

				if renderData.spawnedAnimal == animal.animalId then
					dxDrawText(animal.name .. " (Aktív)", startX + 10, lineY, 0, lineY + oneSize, colorOfText, 0.65, Roboto, "left", "center")
				else
					dxDrawText(animal.name, startX + 10, lineY, 0, lineY + oneSize, colorOfText, 0.65, Roboto, "left", "center")
				end
				dxDrawText(animal.type, 0, lineY, startX + oneSegmentSizeX - 10, lineY + oneSize, colorOfText, 0.65, Roboto, "right", "center")

				buttons["selectAnimal:" .. i + renderData.offsetAnimal] = {startX, lineY, oneSegmentSizeX, oneSize}
			end
		end

		local trackSize = num * oneSize

		buttons["newAnimal"] = {startX, startY + trackSize + respc(10), oneSegmentSizeX, respc(40)}
		--if activeButton == "newAnimal" then
		--	dxDrawRectangle(startX, startY + trackSize + respc(10), oneSegmentSizeX, respc(40), rgba(61, 122, 188, 240))
		--else
		--	dxDrawRectangle(startX, startY + trackSize + respc(10), oneSegmentSizeX, respc(40), rgba(61, 122, 188, 200))
		--end
		--dxDrawText("Pet vásárlása", startX, startY + trackSize + respc(10), startX + oneSegmentSizeX, startY + trackSize + respc(50), rgba(255, 255, 255), 0.75, RobotoL, "center", "center")
		drawButton("newAnimal", "Pet vásárlása", startX, startY + trackSize + respc(10), oneSegmentSizeX, respc(40), {61, 122, 188, 170}, false, Roboto)

		if maxThings > num then
			dxDrawRectangle(startX + oneSegmentSizeX, startY, 5, trackSize, rgba(200,200,200, 25))
			dxDrawRectangle(startX + oneSegmentSizeX, startY + renderData.offsetAnimal * (trackSize / maxThings), 5, trackSize / maxThings * num, rgba(61, 122, 188, 150))
		end

		local animal = renderData.loadedAnimals[renderData.selectedAnimal]

		if animal then
			startX = startX + oneSegmentSizeX + respc(20)
			startY = y + headerHeight + respc(20)

			local oneSectionSizeX = (x + sx) - startX - respc(20)
			local oneSectionSizeY = (y + sy - headerHeight) - startY - respc(20)

			dxDrawText(animal.name, startX, startY - respc(80), startX + oneSectionSizeX, startY, rgba(61, 122, 188), 1, RobotoB, "center", "center")

			--dxDrawRectangle(startX, startY, oneSectionSizeX, oneSectionSizeY, rgba(0, 0, 0, 100))
			dxDrawRectangle(startX, startY, oneSectionSizeX, 2, rgba(200,200,200, 40))

			startY = startY + respc(30)

			--dxDrawRectangle(startX + oneSectionSizeX - respc(371), startY - respc(15), respc(371), respc(140), rgba(200,200,200, 25))
			--wardis
			dxDrawImage(startX + oneSectionSizeX - respc(260), startY - respc(15), respc(371), respc(140), "files/images/dogs/" .. renderData.petTypes[animal.type] .. ".png", 0, 0, 0, rgba(200,200,200))

			local scale = 0.85
			local height = respc(40) * scale

			startY = drawDataRow(startX, startY, height, "ID: ", animal.animalId, scale)
			startY = drawDataRow(startX, startY, height, "Típus: ", animal.type, scale)

			startY = startY + height

			if renderData and renderData.spawnedPetElement then
				dogHealth = getElementHealth(renderData.spawnedPetElement)
				dogFood = getElementData(renderData.spawnedPetElement, "animal.hunger")
				dogLove = getElementData(renderData.spawnedPetElement, "animal.love")
			end

			local healthLevel = dogHealth or animal.health
			startY = drawDataRow(startX, startY, height, "Élet: ", "#3d7abc"..math.floor(healthLevel) .. "#ffffff %", scale)

			dxDrawRectangle(startX, startY, oneSectionSizeX, respc(30), rgba(200,200,200, 25))
			dxDrawRectangle(startX + 3, startY + 3, (oneSectionSizeX - 6) * healthLevel / 100, respc(30) - 6, rgba(215, 89, 89, 200))

			startY = startY + respc(40)

			local hungerLevel = dogFood or animal.hunger
			startY = drawDataRow(startX, startY, height, "Éhség: ", "#3d7abc" .. math.floor(hungerLevel) .. "#ffffff %", scale)

			dxDrawRectangle(startX, startY, oneSectionSizeX, respc(30), rgba(200,200,200, 25))
			dxDrawRectangle(startX + 3, startY + 3, (oneSectionSizeX - 6) * hungerLevel / 100, respc(30) - 6, rgba(61, 122, 188))

			startY = startY + respc(40)

			local loveLevel = dogLove or animal.love
			startY = drawDataRow(startX, startY, height, "Szeretet: ", "#3d7abc" .. math.floor(loveLevel) .. "#ffffff %", scale)

			dxDrawRectangle(startX, startY, oneSectionSizeX, respc(30), rgba(200,200,200, 25))
			dxDrawRectangle(startX + 3, startY + 3, (oneSectionSizeX - 6) * loveLevel / 100, respc(30) - 6, rgba(223, 181, 81,180))

			startY = startY + respc(40)


			local buttonSizeY = respc(45)
			local buttonMargin = respc(10)

			startY = (y + headerHeight + respc(20) + oneSectionSizeY) - buttonSizeY * 4 - buttonMargin * 3

			-- Eladás
			buttons["sellAnimal"] = {startX, startY, oneSectionSizeX, buttonSizeY}

			drawButton("sellAnimal", "Eladás", startX, startY, oneSectionSizeX, buttonSizeY, {215, 89, 89}, false, Roboto)

			-- Felélesztés
			buttons["reviveAnimal"] = {startX, startY + buttonSizeY + buttonMargin, oneSectionSizeX, buttonSizeY}
			drawButton("reviveAnimal", "Felélesztés", startX, startY + buttonSizeY + buttonMargin, oneSectionSizeX, buttonSizeY, {50, 179, 239}, false, Roboto)

			-- Spawn/Despawn
			buttons["spawnAnimal"] = {startX, startY + buttonSizeY * 2 + buttonMargin * 2, oneSectionSizeX, buttonSizeY}

			if renderData.spawnedAnimal ~= animal.animalId then
				drawButton("spawnAnimal", "Spawn", startX, startY + buttonSizeY * 2 + buttonMargin * 2, oneSectionSizeX, buttonSizeY, {124, 197, 118}, false, Roboto)
			elseif renderData.petDatas and renderData.spawnedPetElement then
				drawButton("spawnAnimal", "Despawn", startX, startY + buttonSizeY * 2 + buttonMargin * 2, oneSectionSizeX, buttonSizeY, {124, 197, 118}, false, Roboto)
			end
			-- Átnevezés
			buttons["renameAnimal"] = {startX, startY + buttonSizeY * 3 + buttonMargin * 3, oneSectionSizeX, buttonSizeY}
			drawButton("renameAnimal", "Átnevezés", startX, startY + buttonSizeY * 3 + buttonMargin * 3, oneSectionSizeX, buttonSizeY, {186, 188, 61}, false, Roboto)
		else
			dxDrawText("Nincs kiválasztva pet.", startX + oneSegmentSizeX, y + headerHeight, x + sx, y + sy - headerHeight * 2, rgba(200, 200, 200, 200), 1, RobotoB, "center", "center")
		end
	end

	if selectedTab == 8 then -- setting
		local startX = x + respc(20)
		local startY = y + respc(20)

		local oneSectionSizeX = (x + sx) - startX - respc(20)
		local oneSectionSizeY = (y + sy - headerHeight) - startY - respc(20)

		local tabNum = 12
		local oneSize = oneSectionSizeY / tabNum
		local maxThings = #renderData.clientSettings

		for i = 1, tabNum do
			local lineY = startY + (i - 1) * oneSize
			
			if i % 2 == 0 then
				dxDrawRectangle(startX, lineY, oneSectionSizeX, oneSize, rgba(35, 35, 35))
			end

			if i ~= tabNum then
				dxDrawRectangle(startX, lineY + oneSize, oneSectionSizeX, 2, rgba(200,200,200, 50))
			end

			local set = renderData.clientSettings[i + renderData.offsetSettings]

			if set then
				dxDrawText(set[1], startX + respc(20), lineY, 0, lineY + oneSize, rgba(200,200,200), 0.85, RobotoB2, "left", "center")

				if set[4] then
					if type(set[4]) == "table" then
						local sliderWidth = respc(300)
						local sliderHeight = oneSize * 0.75

						local sliderBaseX = startX + oneSectionSizeX - sliderWidth - respc(20)
						local sliderBaseY = lineY + (oneSize - respc(10)) / 2

						local sliderX = sliderBaseX + reMap(tonumber(set[2]), -1, 1, 0, sliderWidth - respc(15))
						local sliderY = lineY + (oneSize - sliderHeight) / 2

						if set[4][3] then
							dxDrawText(math.ceil(set[2]) .. " " .. set[4][3], 0, lineY, sliderBaseX - respc(20), lineY + oneSize, rgba(150, 150, 150), 0.75, Roboto, "right", "center")
						else
							dxDrawText(math.ceil(set[2]), 0, lineY, sliderBaseX - respc(20), lineY + oneSize, rgba(150, 150, 150), 0.75, Roboto, "right", "center")
						end
			
						dxDrawRectangle(sliderBaseX, sliderBaseY, sliderWidth, respc(10), rgba(75, 75, 75))
						dxDrawRectangle(sliderX, sliderY, respc(15), sliderHeight, rgba(61, 122, 188,210))

						if getKeyState("mouse1") and renderData.sliderMoveX then
							if renderData.activeSlider == set[3] then
								local sliderValue = (cursorX - renderData.sliderMoveX - sliderBaseX) / (sliderWidth - respc(15))

								if sliderValue < 0 then
									sliderValue = 0
								end

								if sliderValue > 1 then
									sliderValue = 1
								end

								set[2] = reMap(sliderValue, 0, 1, -1, 1)
								
								if set[3] == "viewDistance" then
									setFarClipDistance(set[2])
								elseif set[3] == "chatBackgroundAlpha" then
									if renderData.chatInstance then
										executeBrowserJavascript(renderData.chatInstance, "document.getElementById(\"preview\").style.background = \"rgba(0, 0, 0, " .. math.floor(set[2]) / 100 .. ")\"; document.getElementById(\"preview2\").style.background = \"rgba(0, 0, 0, " .. math.floor(set[2]) / 100 .. ")\"; document.getElementById(\"preview\").style.left = \"" .. cursorX .. "px\"; document.getElementById(\"preview\").style.top = \"" .. cursorY .. "px\";")
									end
								elseif set[3] == "chatFontBackgroundAlpha" then
									if renderData.chatInstance then
										executeBrowserJavascript(renderData.chatInstance, "document.getElementById(\"shadow\").innerHTML = \"* { text-shadow: 1px 1px rgba(0, 0, 0, " .. math.floor(set[2]) / 100 .. "); }\"; document.getElementById(\"preview\").style.left = \"" .. cursorX .. "px\"; document.getElementById(\"preview\").style.top = \"" .. cursorY .. "px\";")
									end
								elseif set[3] == "chatFontSize" then
									if renderData.chatInstance then
										executeBrowserJavascript(renderData.chatInstance, "document.getElementById(\"preview\").style.fontSize = \"" .. math.floor(set[2]) .. "%\"; document.getElementById(\"preview\").style.left = \"" .. cursorX .. "px\"; document.getElementById(\"preview\").style.top = \"" .. cursorY .. "px\";")
									end
								end

								renderData.loadedSettings[set[3]] = set[2]
							end
						else
							renderData.sliderMoveX = false
							renderData.activeSlider = false
						end

						if not renderData.sliderMoveX and activeButton == "setting_slider:" .. set[3] then
							renderData.sliderMoveX = cursorX - sliderX
							renderData.activeSlider = set[3]
						end

						buttons["setting_slider:" .. set[3]] = {sliderX, sliderY, respc(15), sliderHeight}
					else
						local buttonSizeX = respc(50)
						local buttonSizeY = oneSize * 0.75

						local buttonStartX = startX + oneSectionSizeX - buttonSizeX - respc(20)
						local buttonStartY = lineY + oneSize / 2 - buttonSizeY / 2

						if set[4] == "crosshair" then
							local colorX = startX + oneSectionSizeX - respc(128) - respc(20)
							drawButton("crosshair_color", "Szín", colorX, buttonStartY, respc(128), buttonSizeY, {61, 122, 188}, false, Roboto)
							buttons["crosshair_color"] = {colorX, buttonStartY, respc(128), buttonSizeY}
							buttonStartX = buttonStartX - respc(128 + 20)
						end

						buttons["setting_next:" .. set[3]] = {buttonStartX, buttonStartY, buttonSizeX, buttonSizeY}
						drawButton("setting_next:" .. set[3], ">",buttonStartX, buttonStartY, buttonSizeX, buttonSizeY, {61, 122, 188}, false, Roboto)
						if set[4] == "crosshair" then
							local shapeSize = oneSize * 0.35
							local shapeX = buttonStartX - buttonSizeX * 2
							local shapeY = lineY + oneSize / 2 - shapeSize / 2 - respc(8)
							local shapeId = renderData.crosshairData[1] or 0
							local r, g, b = renderData.crosshairData[2], renderData.crosshairData[3], renderData.crosshairData[4]

							if shapeId == 0 then
								r, g, b = 200,200,200
							end

							buttons["crosshair_zoom"] = {shapeX, shapeY, shapeSize * 2, shapeSize * 2}

							if activeButton == "crosshair_zoom" then
								shapeSize = 32
								shapeX = cursorX - shapeSize / 2
								shapeY = cursorY - shapeSize / 2
							end

							dxDrawImage(math.floor(shapeX), math.floor(shapeY), shapeSize, shapeSize, ":sm_crosshair/files/" .. shapeId .. ".png", 0, 0, 0, rgba(r, g, b))
							dxDrawImage(math.floor(shapeX + shapeSize * 2), math.floor(shapeY), -shapeSize, shapeSize, ":sm_crosshair/files/" .. shapeId .. ".png", 0, 0, 0, rgba(r, g, b))
							dxDrawImage(math.floor(shapeX), math.floor(shapeY + shapeSize * 2), shapeSize, -shapeSize, ":sm_crosshair/files/" .. shapeId .. ".png", 0, 0, 0, rgba(r, g, b))
							dxDrawImage(math.floor(shapeX + shapeSize * 2), math.floor(shapeY + shapeSize * 2), -shapeSize, -shapeSize, ":sm_crosshair/files/" .. shapeId .. ".png", 0, 0, 0, rgba(r, g, b))
						else
							if type(set[2]) == "boolean" or not set[2] then
								dxDrawText("Kikapcsolva", buttonStartX - buttonSizeX * 2, lineY, buttonStartX - buttonSizeX, lineY + oneSize, rgba(200,200,200), 0.75, Roboto, "center", "center")
							else
								if renderData.shaderRealNames[set[3]] and renderData.shaderRealNames[set[3]][set[2]] then
									dxDrawText(renderData.shaderRealNames[set[3]][set[2]], buttonStartX - buttonSizeX * 2, lineY, buttonStartX - buttonSizeX, lineY + oneSize, rgba(200,200,200), 0.75, Roboto, "center", "center")
								else
									dxDrawText(set[2], buttonStartX - buttonSizeX * 2, lineY, buttonStartX - buttonSizeX, lineY + oneSize, rgba(200,200,200), 0.75, Roboto, "center", "center")
								end
							end
						end

						buttons["setting_prev:" .. set[3]] = {buttonStartX - buttonSizeX * 4, buttonStartY, buttonSizeX, buttonSizeY}

						drawButton("setting_prev:" .. set[3], "<", buttonStartX - buttonSizeX * 4, buttonStartY, buttonSizeX, buttonSizeY, {61, 122, 188}, false, Roboto)

					end
				else
					local enabled = false

					if type(set[2]) == "boolean" and set[2] then
						enabled = true
					end

					local buttonSizeX = respc(150)
					local buttonSizeY = oneSize * 0.75

					local buttonStartX = startX + oneSectionSizeX - buttonSizeX - respc(20)
					local buttonStartY = lineY + oneSize / 2 - buttonSizeY / 2

					if not enabled then
						drawButton("setting_toggle:" .. set[3], "Bekapcsolás", buttonStartX, buttonStartY, buttonSizeX, buttonSizeY, {61, 122, 188}, false, Roboto)
						buttons["setting_toggle:" .. set[3]] = {buttonStartX, buttonStartY, buttonSizeX, buttonSizeY}
					else
						drawButton("setting_toggle:" .. set[3], "Kikapcsolás", buttonStartX, buttonStartY, buttonSizeX, buttonSizeY, {215, 89, 89}, false, Roboto)
						buttons["setting_toggle:" .. set[3]] = {buttonStartX, buttonStartY, buttonSizeX, buttonSizeY}
					end
				end
			end
		end

		if maxThings > tabNum then
			local trackSize = tabNum * oneSize
			dxDrawRectangle(startX + oneSectionSizeX, startY, 5, trackSize, rgba(200,200,200, 25))
			dxDrawRectangle(startX + oneSectionSizeX, startY + renderData.offsetSettings * (trackSize / maxThings), 5, trackSize / maxThings * tabNum, rgba(61, 122, 188, 150))
		end

		if getKeyState("mouse1") and renderData.sliderMoveX then
			if renderData.activeSlider == "chatBackgroundAlpha" or renderData.activeSlider == "chatFontBackgroundAlpha" or renderData.activeSlider == "chatFontSize" then
				if renderData.chatInstance then
					dxDrawImage(0, 0, screenX, screenY, renderData.chatInstance)
				end
			end
		end
	end

	if selectedTab == 6 then --companyP
		for k, v in pairs(edits) do
			local name, text, defaultText, x, y, w, h, font, active, tick, w2, backState, tickBack = unpack(v)
			local textWidth = dxGetTextWidth(text, 0.7, RobotoL, false) or 0
			if active then
				edits[k][11] = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-tick)/200, "Linear")
				dxDrawRectangle(x, y + h - 2, w * w2, 2, tocolor(61, 122, 188), true)
	
				local carretAlpha = interpolateBetween(50, 0, 0, 255, 0, 0, (getTickCount()-tick)/1000, "SineCurve")
				local carretSize = dxGetFontHeight(0.7, RobotoL)*2.4
				local carretPosX = textWidth > (w-10) and x + w - 10 or x + textWidth + 5
				dxDrawRectangle(carretPosX + 2, y + 2.5, 2, h - 5, tocolor(200, 200, 200, carretAlpha), true)
	
				if getKeyState("backspace") then
					backState = backState - 1
				else
					backState = 100
				end
				if getKeyState("backspace") and (getTickCount() - tickBack) > backState then
					edits[k][2] = string.sub(text, 1, #text - 1)
					edits[k][13] = getTickCount()
				end
			else
				if w2 > 0 then
					edits[k][11] = interpolateBetween(edits[k][11], 0, 0, 0, 0, 0, (getTickCount()-tick)/200, "Linear")
					dxDrawRectangle(x, y + h - 2, w * w2, 2, tocolor(61, 122, 188), true)
				end
			end
	
			if string.len(text) == 0 or textWidth == 0 then
				dxDrawText(defaultText, x+5, y, w, y+h, tocolor(255, 255, 255, 120), 0.7, RobotoL, "left", "center", false, false, true)
			else
				if w > textWidth then
					dxDrawText(text, x+5, y, w, y+h, tocolor(255, 255, 255), 0.7, RobotoL, "left", "center", false, false, true)
				else
					dxDrawText(text, x+5, y, x+w-5, y+h, tocolor(255, 255, 255), 0.7, RobotoL, "right", "center", true, false, true)
				end
			end
		end
		if buySlot then
			dxDrawRectangle(0, 0, screenX, screenY, rgba(0, 0, 0, 50), true)
			local sizeX, sizeY = respc(350), respc(175)
			local posX, posY = screenX / 2 - sizeX / 2, screenY / 2 - sizeY / 2
			
			dxDrawRectangle(posX, posY, sizeX, sizeY, rgba(40, 40, 40, 250), true)
			dxDrawRectangle(posX + 3, posY + 3, sizeX - 6, respc(35), rgba(55, 55, 55, 250), true)
			dxDrawText("X", posX + sizeX - 3 - respc(5), posY + 2, nil, nil, rgba(188, 64, 61, 200), 1, RobotoL, "right", "top", false, false, true)

			if buySlot == "member" then
				drawText("Tag slot vásárlás", posX + 3, posY + 3, sizeX - 6, respc(35), rgba(200, 200, 200, 200), 1, Roboto, true)
			elseif buySlot == "vehicle"	then
				drawText("Jármű slot vásárlás", posX + 3, posY + 3, sizeX - 6, respc(35), rgba(200, 200, 200, 200), 1, Roboto, true)
			else
				drawText("Szint vásárlás", posX + 3, posY + 3, sizeX - 6, respc(35), rgba(200, 200, 200, 200), 1, Roboto, true)
			end
			
			dxDrawRectangle(posX + respc(5), posY + respc(60), sizeX - respc(90), respc(35), tocolor(200, 200, 200, 30), true)
			drawButton("minusSlot", "-", posX + sizeX - respc(5) - respc(35), posY + respc(60), respc(35), respc(35), {188, 64, 61, 170}, true, Roboto)
			drawButton("plusSlot", "+", posX + sizeX - respc(10) - respc(35) - respc(35), posY + respc(60), respc(35), respc(35), {61, 122, 188, 170}, true, Roboto)

			if buySlot == "member" or buySlot == "vehicle" then
				drawText(formatNumber(selectedSlot) .. " slot = " .. formatNumber(selectedSlot*slotPrice) .. "PP", posX + respc(5), posY + respc(60), sizeX - respc(90), respc(35), rgba(200, 200, 200, 200), 1, Roboto, true)
			else
				drawText(formatNumber(selectedSlot) .. " szint = " .. formatNumber(selectedSlot*slotPrice) .. "PP", posX + respc(5), posY + respc(60), sizeX - respc(90), respc(35), rgba(200, 200, 200, 200), 1, Roboto, true)
			end

			drawButton("buyTheSlots", "Vásárlás", posX + 4, posY + sizeY - respc(40) - respc(5), sizeX - 8, respc(40), {61, 122, 188}, true, Roboto)
			--buttonsC["closeBuySlot"] = {posX + respc(20), posY + sizeY - respc(40) - respc(5), sizeX - respc(40), respc(40)}
		end
		
		if panel == "noCompany" then
			
		elseif panel == "company" then
			if not loaded then
				rot = rot + 1
				dxDrawImage(x + (screenX - respc(60)) / 2 - respc(100), y + (screenY - respc(60)) / 2 - respc(100), respc(200), respc(200), "files/images/load.png", rot)
			else
				for i = 1, #panels do
					local oneSize = screenX / 5 - respc(60)
					local startY = screenX / 2- (oneSize * 5) / 2
					local lineX = startY + (i - 1) * (oneSize+respc(5))
					drawButton(panels[i].id, panels[i].text, lineX-respc(5), y + respc(15), oneSize, respc(50), {61, 122, 188}, false, Roboto)
				end
				if page == 1 then
					local skinHolderSizeX = respc(240)
					local holderSizeY = screenY-respc(240)
					local marginMul = 2.2
					local startX = x + respc(20)
					local startY = y + respc(80)
					local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
					local oneSegmentSizeY = holderSizeY

					dxDrawRectangle(startX, startY, oneSegmentSizeX, oneSegmentSizeY, rgba(35, 35, 35))

					local oneSize = oneSegmentSizeY / 15

					for i = 1, 11 do
						if i ~= 11 then
							dxDrawRectangle(startX, startY + i * oneSize, oneSegmentSizeX, 2, rgba(45, 45, 45))
						end
					end

					dxDrawText("Vállalkozás neve:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..loaded_company["name"]:gsub("_", " "), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)
					startY = startY + oneSize

					dxDrawText("Vállalkozás azonosítója:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..formatNumber(loaded_company["id"]), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

					startY = startY + oneSize

					dxDrawText("Számla egyenlege:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..formatNumber(loaded_company["balance"]).." $", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

					startY = startY + oneSize

					dxDrawText("Tagok:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					if loaded_company["membersCount"] then
						dxDrawText("#3d7abc"..#loaded_company["membersCount"] .. "/" .. loaded_company["memberSlot"], 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)
					end
					startY = startY + oneSize

					dxDrawText("Járművek:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..#getCompanyVehicles(loaded_company["id"]) .. "/" .. loaded_company["vehicleSlot"], 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

					startY = startY + oneSize

					dxDrawText("Rangod:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..loaded_company["ranks"][(getElementData(localPlayer,"char.CompanyRank"))].name, 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

					startY = startY + oneSize

					dxDrawText("Szint:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..loaded_company["level"], 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

					local xpToNextLevel = getEXPToNextLevel(loaded_company["level"])

					startY = startY + oneSize

					dxDrawText("EXP:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..formatNumber(loaded_company["xp"]).."/"..formatNumber(xpToNextLevel), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

					startY = startY + oneSize

					dxDrawText("Részesedés:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..loaded_company["ranks"][(getElementData(localPlayer,"char.CompanyRank"))].precent.."%", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

					startY = startY + oneSize

					dxDrawText("Járulék:", startX + respc(20), startY, 0, startY + oneSize, rgba(200,200,200), 0.5, RobotoB, "left", "center")
					dxDrawText("#3d7abc"..formatNumber(taxesByRank[tonumber(getElementData(localPlayer,"char.CompanyRank"))]).. " $/Nap", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200,200,200), 0.75, Roboto, "right", "center", false, false, false, true)

					drawText("EXP:", x + respc(20) + oneSegmentSizeX/2 - (oneSegmentSizeX - respc(100)) / 2, screenY-respc(200) - respc(50), oneSegmentSizeX - respc(100), respc(40), rgba(200, 200, 200, 200), 1, Roboto)
					dxDrawRectangle(x + respc(20) + oneSegmentSizeX/2 - (oneSegmentSizeX - respc(100)) / 2, screenY-respc(200), oneSegmentSizeX - respc(100), respc(40), rgba(45, 45, 45))
					dxDrawRectangle(x + respc(20) + oneSegmentSizeX/2 - (oneSegmentSizeX - respc(100)) / 2 + 4, screenY-respc(200) + 4, (oneSegmentSizeX - respc(100) - 8), respc(40) - 8, rgba(200, 200, 200, 40))
					dxDrawRectangle(x + respc(20) + oneSegmentSizeX/2 - (oneSegmentSizeX - respc(100)) / 2 + 4, screenY-respc(200) + 4, (oneSegmentSizeX - respc(100) - 8) / xpToNextLevel * loaded_company["xp"], respc(40) - 8, rgba(61, 122, 188, 125))
					
					local sx2 = skinHolderSizeX * marginMul - respc(20)
					local x2 = x + sx - skinHolderSizeX * marginMul
					local y = y + respc(80)
					--local boxesSize = ((oneSegmentSizeY - (9 * 16)) / 8) 
					local boxesSize = ((oneSegmentSizeY - (8 * 10)) / 9) 
					dxDrawRectangle(x2, y, sx2, oneSegmentSizeY, rgba(35, 35, 35))

					local y = y + 8
					drawButton("buyLevel", "Szint vásárlása", x2 + 8, y, sx2 - 16, boxesSize, {188, 128, 61}, false, Roboto)
					
					local y = y + boxesSize + 8
					drawButton("buyVehSlot", "Jármű slot vásárlása", x2 + 8, y, sx2 - 16, boxesSize, {185, 188, 61}, false, Roboto)

					local y = y + boxesSize + 8
					drawButton("buyMemberSlot", "Tagok slot vásárlása", x2 + 8, y, sx2 - 16, boxesSize, {122, 188, 61}, false, Roboto)
					if playerHavePermission() then
						local y = y + boxesSize + 8
						dxDrawRectangle(x2 + 8, y, sx2 - 16, boxesSize, rgba(45, 45, 45))
						local y = y + boxesSize + 8
						drawButton("setMoney", "Befizetés", x2 + 8, y, sx2 - 16, boxesSize, {61, 122, 188}, false, Roboto)

						local y = y + boxesSize + 8
						drawButton("giveMoney", "Kifizetés", x2 + 8, y, sx2 - 16, boxesSize, {188, 64, 61}, false, Roboto)

						local y = y + boxesSize + 8
						if dxGetActiveEditName() == "newPlayer" then
							local text = dxGetEditText("newPlayer")
							local thePlayerHasFind = findPlayerToCompany(text)

							if thePlayerHasFind then
								drawText(getElementData(thePlayerHasFind, "char.Name"):gsub("_"," ") .. " (" .. getElementData(thePlayerHasFind, "playerID") .. ")", x2 + 8, y, sx2 - 16, boxesSize, tocolor(200, 200, 200, 200), 1 ,RobotoB)
							else
								drawText("#e43232Nem található játékos",x2 + 8, y, sx2 - 16, boxesSize, tocolor(200, 200, 200, 200), 1 ,RobotoB)
							end
						end

						local y = y + boxesSize + 8
						dxDrawRectangle(x2 + 8, y, sx2 - 16, boxesSize, rgba(45, 45, 45))

						local y = y + boxesSize + 8
						drawButton("addMemberToCompany", "Játékos felvétele", x2 + 8, y, sx2 - 16, boxesSize, {61, 122, 188}, false, Roboto)
					end
				elseif page == 2 then
					maxLine = 15

					local skinHolderSizeX = respc(240)
					local holderSizeY = screenY-respc(240)
					local marginMul = 2.2
					local startX = x + respc(20)
					local startY = y + respc(80)
					local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
					local oneSegmentSizeY = holderSizeY
					dxDrawRectangle(startX, startY, skinHolderSizeX * marginMul - respc(20), oneSegmentSizeY+4, rgba(35, 35, 35))
					localPlayerBoxButtom = false
					local boxsize = {(skinHolderSizeX * marginMul - respc(20))-8, (oneSegmentSizeY / 15) - 4}
					for i = 1, maxLine do
						local boxpos = {startX + 4, startY + 4 + (i - 1) * (boxsize[2] + 4)}
						if isInSlot(boxpos[1], boxpos[2], boxsize[1], boxsize[2]) then
							localPlayerBoxButtom = i
							dxBackColor = rgba(200, 200, 200, 35)
						else
							if i%2 == 0 then
								dxBackColor = rgba(45, 45, 45, 150)
							else
								dxBackColor = rgba(55, 55, 55, 150)
							end
						end
						dxDrawRectangle(boxpos[1], boxpos[2], boxsize[1], boxsize[2], dxBackColor)
						
						local player = loaded_company["membersCount"][i + scroll]

						if selected == 0 then
							--dxDrawRectangle(startX, startY, skinHolderSizeX * marginMul - respc(20), oneSegmentSizeY+4, rgba(35, 35, 35))
							--drawText("asd", startX, startY, skinHolderSizeX * marginMul - respc(20), oneSegmentSizeY+4, tocolor(200, 200, 200, 200), 1, Roboto)
						end
						
						if player then
							if selected == i + scroll then
								textSelectedColor = rgba(61, 122, 188, 200)
							else
								textSelectedColor = rgba(200, 200, 200, 200)
							end
							if loaded_company["leader"] == player.dbid then
								drawText("✨ "..player.name:gsub("_"," "), boxpos[1], boxpos[2], boxsize[1], boxsize[2], textSelectedColor, 1, Roboto)
							else
								drawText(player.name:gsub("_"," "), boxpos[1], boxpos[2], boxsize[1], boxsize[2], textSelectedColor, 1, Roboto)
							end
						end
					end
					
					dxDrawRectangle(skinHolderSizeX * marginMul + respc(50), startY, oneSegmentSizeX, oneSegmentSizeY+4, rgba(35, 35, 35))
					
					if selected ~= 0 then
						local player = loaded_company["membersCount"][selected]
						if player then
							local oneSize = oneSegmentSizeY / 15

							for i = 1, 6 do
								dxDrawRectangle(respc(240) * marginMul + respc(50), startY + i * oneSize, oneSegmentSizeX, 2, rgba(45, 45, 45))
							end
							local online_player = findPlayerByName(player.name)
							local startX = skinHolderSizeX * marginMul + respc(50)

							dxDrawText("Utoljára online:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							if online_player then
								dxDrawText("#dededeJelenleg elérhető", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							else
								dxDrawText(formatDate("Y-m-d","'", player.lastOnline) or "Még nem volt elérhető", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							end

							startY = startY + oneSize
							dxDrawText("Rang:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(loaded_company["ranks"][tostring(player.rank)].name, 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

							startY = startY + oneSize
							dxDrawText("Tartózkodási hely:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							if online_player then
								dxDrawText(getZoneName(getElementPosition(online_player)), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							else
								dxDrawText("Ismeretlen", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							end
							
							startY = startY + oneSize
							dxDrawText("Járulék:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(formatNumber(taxesByRank[tonumber(player.rank)]).." $/nap", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
						
							startY = startY + oneSize
							if player.taxPayed == 0 then
								dxDrawText("Járulék befizetési állapota:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
								dxDrawText("#e43232Még nem volt befizetve!", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							else
								if player.taxPayed <= getTimestamp() then
									dxDrawText("Járulék lejárt ekkor:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
									dxDrawText(formatDate("Y-m-d","'", player.taxPayed), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
								else
									dxDrawText("Járulék Befizetve eddig:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
									dxDrawText(formatDate("Y-m-d","'", player.taxPayed), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
								end
							end

							startY = startY + oneSize
							dxDrawText("Részesedés:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(loaded_company["ranks"][tostring(player.rank)].precent .. "%", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

							startY = y + respc(80) + screenY - respc(240) - 5
							
							posTableFromRender = {startX + 5, startY - (oneSize * 5) - 20, (oneSegmentSizeX / 2) - 10, oneSize}
							
							
							if payTaxes then
								local text = dxGetEditText("payTax")
								if tonumber(text) then
									text = tonumber(text)
									if text <= 31 then
										drawText("#dedede" .. formatNumber(text) .. " nap = " .. formatNumber(taxesByRank[player.rank] * text) .. "$", startX + 5, startY - (oneSize * 6) - 25, oneSegmentSizeX - 10, oneSize, tocolor(200, 200, 200, 200), 1, Roboto)
									else
										drawText("#e43232Maximum 1 hónapra fizetheted ki!", startX + 5, startY - (oneSize * 6) - 25, oneSegmentSizeX - 10, oneSize, tocolor(200, 200, 200, 200), 1, Roboto)
									end
								else
									drawText("#e43232Hibás összeg lett megadva!", startX + 5, startY - (oneSize * 6) - 25, oneSegmentSizeX - 10, oneSize, tocolor(200, 200, 200, 200), 1, Roboto)
								end
								
								dxDrawRectangle(startX + 5, startY - (oneSize * 5) - 20, (oneSegmentSizeX / 2) - 7.5, oneSize, tocolor(45, 45, 45))
								drawButton("payPlayerTransEnter", "Befizetés", startX + 2.5 + (oneSegmentSizeX / 2), startY - (oneSize * 5) - 20 , ((oneSegmentSizeX / 2) - 10) + 2.5, oneSize, {96, 204, 99}, false, Roboto)
							end
							
							drawButton("rankUp", "Játékos előléptetése", startX + 5, startY - (oneSize * 4) - 15, oneSegmentSizeX - 10, oneSize, {61, 122, 188}, false, Roboto)
							drawButton("rankMinus", "Játékos lefokozása", startX + 5, startY - (oneSize * 3) - 10, oneSegmentSizeX - 10, oneSize, {230, 149, 0}, false, Roboto)

							drawButton("payPlayerTrans", "Járulék befizetése", startX + 5, startY - (oneSize * 2) - 5, oneSegmentSizeX - 10, oneSize, {134, 197, 77}, false, Roboto)
							drawButton("kickPlayer", "Játékos kirúgása", startX + 5, startY - oneSize, oneSegmentSizeX - 10, oneSize, {188, 64, 61}, false, Roboto)
						end
					end
				elseif page == 3 then
					maxLine = 5
					
					local skinHolderSizeX = respc(240)
					local holderSizeY = screenY-respc(240)
					local marginMul = 2.2
					local startX = x + respc(20)
					local startY = y + respc(80)
					local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
					local oneSegmentSizeY = holderSizeY
					local oneSize = oneSegmentSizeY / 12
					
					dxDrawRectangle(startX, startY, skinHolderSizeX * marginMul - respc(20), (oneSegmentSizeY / 15) * maxLine + 4, rgba(35, 35, 35))
					drawText("Üzenet:", startX, startY + ((oneSegmentSizeY / 15) * maxLine) + respc(20), skinHolderSizeX * marginMul - respc(20), (oneSegmentSizeY / 15), rgba(200, 200, 200, 200), 1, Roboto)
					dxDrawRectangle(startX, startY + ((oneSegmentSizeY / 15) * maxLine) + respc(20) + (oneSegmentSizeY / 15), skinHolderSizeX * marginMul - respc(20), (oneSegmentSizeY) / 3, rgba(35, 35, 35))
					
					dxDrawText(loaded_company["message"], startX + respc(25), startY + ((oneSegmentSizeY / 15) * maxLine) + respc(20) + (oneSegmentSizeY / 15), skinHolderSizeX * marginMul, (oneSegmentSizeY) / 3, tocolor(200, 200, 200), 1, Roboto, "left","top", false, true)
					
					dxDrawRectangle(startX, startY + ((oneSegmentSizeY / 15) * maxLine) + respc(20) + (oneSegmentSizeY / 15) + (oneSegmentSizeY) / 3 + 5, skinHolderSizeX * marginMul - respc(20), oneSize, rgba(35, 35, 35))

					drawButton("progressMessage", "Üzenet beállítása", startX, startY + ((oneSegmentSizeY / 15) * maxLine) + respc(20) + (oneSegmentSizeY / 15) + (oneSegmentSizeY) / 3 + 10 + oneSize, skinHolderSizeX * marginMul - respc(20), oneSize, {61, 122, 188}, false, Roboto)

					localPlayerBoxButtom = false
					local boxsize = {(skinHolderSizeX * marginMul - respc(20))-8, (oneSegmentSizeY / 15) - 4}
					for i = 1, maxLine do
						local boxpos = {startX + 4, startY + 4 + (i - 1) * (boxsize[2] + 4)}
						if isInSlot(boxpos[1], boxpos[2], boxsize[1], boxsize[2]) then
							localPlayerBoxButtom = i
							dxBackColor = rgba(200, 200, 200, 35)
						else
							if i%2 == 0 then
								dxBackColor = rgba(45, 45, 45, 150)
							else
								dxBackColor = rgba(55, 55, 55, 150)
							end
						end
						dxDrawRectangle(boxpos[1], boxpos[2], boxsize[1], boxsize[2], dxBackColor)
						
						if selected == i+scroll then
							textSelectedColor = rgba(61, 122, 188, 200)
						else
							textSelectedColor = rgba(200, 200, 200, 200)
						end
						
						drawText(loaded_company["ranks"][tostring(i)].name, boxpos[1], boxpos[2], boxsize[1], boxsize[2], textSelectedColor, 1, Roboto, false, true)
						
					end
					dxDrawRectangle(skinHolderSizeX * marginMul + respc(50), startY, oneSegmentSizeX, oneSegmentSizeY+4, rgba(35, 35, 35))
					if selected ~= 0 then
						local row = loaded_company["ranks"][tostring(selected)]
						local oneSize = oneSegmentSizeY / 12

						posTableFromRender = {startX + 5, startY - (oneSize * 4) - 15, (oneSegmentSizeX / 2) - 10, oneSize}
						--posTableFromRenderSecond = {startX + 5, startY - (oneSize * 2) - 5, (oneSegmentSizeX / 2) - 10, oneSize}
						if row then

							for i = 1, 3 do
								dxDrawRectangle(respc(240) * marginMul + respc(50), startY + i * oneSize, oneSegmentSizeX, 2, rgba(45, 45, 45))
							end
							local startX = skinHolderSizeX * marginMul + respc(50)
							dxDrawText("Tagok száma ezen a rangon:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(getPlayersWithThatRank(selected).." db", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							
							startY = startY + oneSize
							dxDrawText("Rang részesedése:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(row.precent.." %", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							
							startY = startY + oneSize
							dxDrawText("Járulék:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(taxesByRank[selected].." $/Nap", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

							startY = y + respc(80) + screenY - respc(240) - 5
							
							dxDrawRectangle(startX + 5, startY - (oneSize * 4) - 15, oneSegmentSizeX - 10, oneSize, tocolor(45, 45, 45))
							drawButton("updatePay", "Beállítás", startX + 5, startY - (oneSize * 3) - 10, oneSegmentSizeX - 10, oneSize, {61, 122, 188}, false, Roboto)
							dxDrawRectangle(startX + 5, startY - (oneSize * 2) - 5, oneSegmentSizeX - 10, oneSize, tocolor(45, 45, 45))
							drawButton("renameRankB", "Átnevezés", startX + 5, startY - oneSize, oneSegmentSizeX - 10, oneSize, {161, 210, 116}, false, Roboto)
							
							--[[
							local skinHolderSizeX = respc(240)
							local holderSizeY = screenY-respc(240)
							local marginMul = 2.2
							local startX = x + respc(20)
							local startY = y + respc(80)
							local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
							local oneSegmentSizeY = holderSizeY
							
							dxDrawRectangle(startX + 5, startY - (oneSize * 6) - 25, oneSegmentSizeX - 10, oneSize, tocolor(45, 45, 45))
							drawButton("updateCompanyMessage", "Beállítás", startX + 5, startY, oneSegmentSizeX - 10, oneSize, {61, 122, 188})]]
						end
					end
				elseif page == 4 then
					maxLine = 15

					local skinHolderSizeX = respc(240)
					local holderSizeY = screenY-respc(240)
					local marginMul = 2.2
					local startX = x + respc(20)
					local startY = y + respc(80)
					local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
					local oneSegmentSizeY = holderSizeY
					
					local companyVehicles = getCompanyVehicles(loaded_company["id"])
					
					dxDrawRectangle(startX, startY, skinHolderSizeX * marginMul - respc(20), oneSegmentSizeY+4, rgba(35, 35, 35))
					localPlayerBoxButtom = false
					local boxsize = {(skinHolderSizeX * marginMul - respc(20))-8, (oneSegmentSizeY / 15) - 4}
					
					for i = 1, maxLine do
						local boxpos = {startX + 4, startY + 4 + (i - 1) * (boxsize[2] + 4)}
						if isInSlot(boxpos[1], boxpos[2], boxsize[1], boxsize[2]) then
							localPlayerBoxButtom = i
							dxBackColor = rgba(200, 200, 200, 35)
						else
							if i%2 == 0 then
								dxBackColor = rgba(45, 45, 45, 150)
							else
								dxBackColor = rgba(55, 55, 55, 150)
							end
						end
						dxDrawRectangle(boxpos[1], boxpos[2], boxsize[1], boxsize[2], dxBackColor)

						local vehicle = companyVehicles[i + scroll]

						if vehicle then
							if selected == i + scroll then
								textSelectedColor = rgba(61, 122, 188, 200)
							else
								textSelectedColor = rgba(200, 200, 200, 200)
							end
							drawText(getVehicleNameFromShop(vehicle), boxpos[1], boxpos[2], boxsize[1], boxsize[2], textSelectedColor, 1, Roboto)
						end
					end

					dxDrawRectangle(skinHolderSizeX * marginMul + respc(50), startY, oneSegmentSizeX, oneSegmentSizeY+4, rgba(35, 35, 35))
					if selected ~= 0 then
						local startX = skinHolderSizeX * marginMul + respc(50)
						local vehicle = companyVehicles[selected]
						if not vehicle then
							selected = 0
						end
						local oneSize = oneSegmentSizeY / 15

						for i = 1, 6 do
							dxDrawRectangle(respc(240) * marginMul + respc(50), startY + i * oneSize, oneSegmentSizeX, 2, rgba(45, 45, 45))
						end

						dxDrawText("Jármű ID:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
						dxDrawText(getElementData(vehicle, "company.vehicleID"), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

						local driver = getVehicleController(vehicle)
						local dim = getElementDimension(vehicle)
						local posX, posY, posZ = getElementPosition(vehicle)
						if getElementDimension(vehicle) < 30000 then
							startY = startY + oneSize
							dxDrawText("Jelenlegi sofőr:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							if driver then
								dxDrawText(getElementData(driver,"char.Name"):gsub("_"," "), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							else
								dxDrawText("Használatban", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							end

							startY = startY + oneSize
							dxDrawText("Jelenlegi tartózkodási helye:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(getZoneName(posX, posY, posZ), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

							startY = startY + oneSize
							dxDrawText("Szállítmány típúsa:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							if getElementData(vehicle,"company.stuffName") then
								dxDrawText(getElementData(vehicle,"company.stuffName"), 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							else
								dxDrawText("Ismeretlen", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							end

							startY = startY + oneSize
							dxDrawText("Napi adó:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText("200$", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

							startY = startY + oneSize

							local rent = "Nem"
							if getElementData(vehicle,"company.rent") >= 0 then
								rent = "Igen (Még " .. getElementData(vehicle,"company.rent") .. " fuvar)"
							end

							dxDrawText("Bérelt:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(rent, 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
						else
							startY = startY + oneSize
							dxDrawText("Jelenlegi sofőr:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText("Nincs", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

							startY = startY + oneSize
							dxDrawText("Jelenlegi tartózkodási helye:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText("Ismeretlen", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
							
							startY = startY + oneSize
							dxDrawText("Szállítmány típúsa:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText("Ismeretlen", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

							startY = startY + oneSize
							dxDrawText("Napi adó:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText("200$", 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)

							startY = startY + oneSize
							
							local rent = "Nem"
							if getElementData(vehicle,"company.rent") >= 0 then 
								rent = "Igen (Még " .. getElementData(vehicle,"company.rent") .. " fuvar)" 
							end
							
							dxDrawText("Bérelt:", startX + respc(20), startY, 0, startY + oneSize, rgba(200, 200, 200), 0.5, RobotoB, "left", "center")
							dxDrawText(rent, 0, startY, startX + oneSegmentSizeX - respc(20), startY + oneSize, rgba(200, 200, 200), 0.75, Roboto, "right", "center", false, false, false, true)
						end
							startY = y + respc(80) + screenY - respc(240) - 5
		
							drawButton("sellVehicle", "Jármű eladása", startX + 5, startY - oneSize, oneSegmentSizeX - 10, oneSize, {188, 64, 61}, false, Roboto)
					end
				elseif page == 5 then

					local oneSegmentSizeX = (sx - respc(40)) / 3
					local oneSegmentSizeY = sy - headerHeight - respc(40) - respc(100)
					
					local startX = x + respc(20)
					local startY = y + respc(80)
					
					local maxLine = 15
					local oneSize = (oneSegmentSizeY / (maxLine + 1))

					dxDrawRectangle(startX, startY, sx - respc(40), oneSize, tocolor(65, 65, 65, 235))
					dxDrawText("Időpont:", startX + respc(5), startY + oneSize / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Roboto, "left", "center", false, false, false, true)
					dxDrawText("Tevékenység leírása:", startX + respc(305), startY + oneSize / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Roboto, "left", "center", false, false, false, true)
					for i = 1, maxLine - 1 do
						local row = loaded_company["transactions"][i + scroll]
						dxDrawRectangle(startX, startY + i * (oneSize + 5), sx - respc(40), oneSize, tocolor(55, 55, 55, 200))
						if row then
							dxDrawText(formatDate("Y/m/d - h:i:s","'",row.time), startX + respc(5), startY + i * (oneSize + 5) + oneSize / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Roboto, "left", "center", false, false, false, true)
							dxDrawText(row.text, startX + respc(305), startY + i * (oneSize + 5) + oneSize / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Roboto, "left", "center", false, false, false, true)
						end
					end
				end
			end
		end
	end

	activeButton = false
	if isCursorShowing() then
		for k, v in pairs(buttons) do
			if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end

	local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

		activeButtonC = false
		if not buttonsC then
			return
		end
		for k,v in pairs(buttonsC) do
			if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
				activeButtonC = k
				break
			end
		end
	else
		activeButtonC = false
	end
end


local sellVehicleToCompanyPlayer = false

function findPlayerByName(name)
	local player = false
	for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"char.Name") == name then
			player = v
		end
	end
	return player
end


--[[
panel = "company"
loaded = true
loaded_company = {
	name = "StrongMTA",
	id = 7,
	balance = 200000000,
	memberSlot = 20,
	vehicleSlot = 2,
	ranks = {["5"] = {name = "Tulajdonos", precent = 20}},
	level = 1,
	xp = 100,
	leader = 23,
	
}
]]

function dxDrawBorder(x, y, w, h, size, color, postGUI)
	size = size or 2;
	dxDrawRectangle(x - size, y, size, h, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x + w, y, size, h, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x - size, y - size, w + (size * 2), size, color or tocolor(0, 0, 0, 180), postGUI);
	dxDrawRectangle(x - size, y + h, w + (size * 2), size, color or tocolor(0, 0, 0, 180), postGUI);
end

function getPlayersWithThatRank(rank)
	local count = 0
	for k,v in ipairs(loaded_company["membersCount"]) do
		if v.rank == rank then
			count = count + 1
		end
	end
	return count
end

function playerHavePermission()
	local perm = false
	if loaded_company["leader"] == getElementData(localPlayer,"char.ID") then perm = true end
	if getElementData(localPlayer,"char.CompanyRank") == "5" then perm = true end
	return perm
end

addEvent("returnCompanyMembers",true)
addEventHandler("returnCompanyMembers", localPlayer,
	function(table)
		loaded_company["membersCount"] = table
		--companyMembersCurrentDatas = table
	end
)

function loadCompanyMembers(id)
	triggerServerEvent("loadCompanyMembers",resourceRoot,localPlayer,id)
end

addEvent("returnCompany",true)
addEventHandler("returnCompany",localPlayer,
	function(data,transactions,vehicles,firstOpen)
		companyCurrentDatas = data
		if companyOldDatas ~= data then
			companyOldDatas = data
		else
			companyOldDatas = companyOldDatas
		end
		if data then
			for k,v in ipairs(data) do
				for row,value in pairs(v) do
					loaded_company[row] = value
				end
				if loaded_company["ranks"] then
					loaded_company["ranks"] = fromJSON(loaded_company["ranks"])
				end

				loadCompanyMembers(loaded_company["id"])
				loaded_company["vehiclesCount"] = 1

				loaded_company["transactions"] = {}
				for id,row in pairs(transactions) do
					loaded_company["transactions"][id] = {time=row.time,text=row.text}
				end
				table.sort(loaded_company["transactions"], function(a,b) return a.time > b.time end )

				loaded_company["vehicles"] = vehicles

				if firstOpen then
					if loaded_company["type"] > 0 then 
						panel = "company"
						loaded = true
						page = 1
						local charID = getElementData(localPlayer,"char.ID")
						if playerHavePermission() then
							local sx, sy = screenX - respc(60), screenY - respc(60)
							local x = screenX / 2 - sx / 2
							local y = screenY / 2 - sy / 2
							local y = y + respc(80)
							local skinHolderSizeX = respc(240)
							local holderSizeY = screenY-respc(240)
							local marginMul = 2.2
							local oneSegmentSizeX = (sx - skinHolderSizeX * marginMul - respc(40))
							local oneSegmentSizeY = holderSizeY

							local sx2 = skinHolderSizeX * marginMul - respc(20)
							local x2 = x + sx - skinHolderSizeX * marginMul
							local y = y + respc(80)
							local boxesSize = ((oneSegmentSizeY - (8 * 10)) / 9)
							dxCreateEdit("companyBalance", "", "Írd be a kivánt összeget..",x2 + 8, y + (boxesSize + 8) * 3 + 8, sx2 - 16, boxesSize)
							dxCreateEdit("newPlayer", "", "Játékos ID/Név", x2 + 8, y + (boxesSize + 8) * 7 + 8, sx2 - 16, boxesSize)
						end
					else --// Hogyha új vállalkozásról beszélünk
						panel = "newCompany"
						--dxCreateEdit("companyName","","Írd be a vállalkozásd nevét..",pos[1]+size[1]/2-250,pos[2]+size[2]-200,500,50,17)
						selected_type = 1
					end
				else
					loaded = true
				end
			end 
		end
	end
)

function openCompanyTab()
	if getElementData(localPlayer,"loggedIn") then
		rot = 0
		buySlot = false
		selectedSlot = 1
		if panel then
			scroll = 0
			panel = false
			dxDestroyEdit("companyName")
			dxDestroyEdit("newPlayer")
			dxDestroyEdit("companyBalance")
			dxDestroyEdit("payTax")
			dxDestroyEdit("renameRank")
			dxDestroyEdit("reprecentRank")
			dxDestroyEdit("rewriteMessage")
			payTaxes = false
		else
			if tonumber(getElementData(localPlayer,"char.CompanyID")) > 0 then
				scroll = 0
				loaded = false
				panel = "company"
				triggerServerEvent("getCompanyDatas",resourceRoot,localPlayer,tonumber(getElementData(localPlayer,"char.CompanyID")),true)
			else
				panel = "noCompany"
			end
			
		end
	end
end


function drawText(text, x, y, w, h, color, size, font, postGUI, wordBreak)
	postGUI = postGUI or false
	wordBreak = wordBreak or false
	colored = true
	if wordBreak then
		wordBreak = false
	end
	dxDrawText(text, x + w / 2, y + h / 2, x + w / 2, y + h / 2, color, size, font, "center", "center", false, wordBreak, postGUI, colored)
end

----------------------------------------------------------------------------------------------------------
--------------------------------------editbox-------------------------------------------------------------
function dxCreateEdit(name, text, defaultText, x, y, w, h, font)
	local id = #edits + 1
	edits[id] = {name, text, defaultText, x, y, w, h, font, false, 0, 0, 100, getTickCount()}
	return id
end

function editBoxesKey(button, state)
	if button == "mouse1" and state and isCursorShowing() then
		for k, v in pairs(edits) do
			local name, text, defaultText, x, y, w, h, font, active, tick = unpack(v)
			if not active then
				if isMouseInPosition(x, y, w, h) then
					edits[k][9] = true
					edits[k][10] = getTickCount()
				end
			else
				edits[k][9] = false
				edits[k][10] = getTickCount()
			end
		end
	end

	if button == "tab" and state and isCursorShowing() then
		if dxGetActiveEdit() then
			local nextGUI = dxGetActiveEdit()+1
			if edits[nextGUI] then
				local current = dxGetActiveEdit()
				edits[current][9] = false
				edits[current][10] = getTickCount()

				edits[nextGUI][9] = true
				edits[nextGUI][10] = getTickCount()
			else
				local current = dxGetActiveEdit()
				edits[current][9] = false
				edits[current][10] = getTickCount()

				edits[1][9] = true
				edits[1][10] = getTickCount()
			end
		end
		cancelEvent()
	end

	for k, v in pairs(edits) do
		local name, text, defaultText, x, y, w, h, font, active, tick, w2 = unpack(v)
		if active then
			cancelEvent()
		end
	end
end

function editBoxesCharacter(key)
	if isCursorShowing() then
		for k, v in pairs(edits) do
			local name, text, defaultText, x, y, w, h, font, active, tick, w2 = unpack(v)
			if active then
				edits[k][2] = edits[k][2] .. key
			end
		end
	end
end

function isMouseInPosition(x, y, w, h)
	if not isCursorShowing() then 
		return 
	end
	local pos = {getCursorPosition()}
	pos[1], pos[2] = (pos[1] * sx), (pos[2] * sy)
	if pos[1] >= x and pos[1] <= (x + w) and pos[2] >= y and pos[2] <= (y + h) then
		return true
	else
		return false
	end
end

function dxGetActiveEditName()
	local a = false
	for k, v in pairs(edits) do
		local name, text, defaultText, x, y, w, h, font, active, tick, w2 = unpack(v)
		if active then
			a = name
			break
		end
	end
	return a
end

function dxGetActiveEdit()
	local a = false
	for k, v in pairs(edits) do
		local name, text, defaultText, x, y, w, h, font, active, tick, w2 = unpack(v)
		if active then
			a = k
			break
		end
	end
	return a
end

function dxDestroyEdit(id)
	if tonumber(id) then
		if not edits[id] then return false end
		table.remove(edits, id)
		return true
	else
		local edit = dxGetEdit(id)
		if not edits[edit] then 
			return false 
		end
		table.remove(edits, edit)
		return true
	end
end

function dxEditSetText(id, text)
	if tonumber(id) then
		if not edits[id] then 
			error("Not valid editbox") 
			return false 
		end

		edits[id][2] = text
		return true
	else
		local edit = dxGetEdit(id)
		if not edits[edit] then 
			error("Not valid editbox") 
			return false 
		end
		edits[edit][2] = text
		return true
	end
end

function dxGetEdit(name)
	local found = false
	for k, v in pairs(edits) do
		if v[1] == name then
			found = k
			break
		end
	end
	return found
end

function dxGetEditText(id)
	if tonumber(id) then
		if not edits[id] then error("Not valid editbox") return false end
		return edits[id][2]
	else
		local edit = dxGetEdit(id)
		if not edits[edit] then error("Not valid editbox") return false end
		return edits[edit][2]
	end
end

function dxSetEditPosition(id, x, y)
	if tonumber(id) then
		if not edits[id] then error("Not valid editbox") return false end
		edits[id][4] = x
		edits[id][5] = y
		return true
	else
		local edit = dxGetEdit(id)
		if not edits[edit] then error("Not valid editbox") return false end
		edits[edit][4] = x
		edits[edit][5] = y
		return true
	end
end

function isMouseInPosition(x, y, w, h)
	if not isCursorShowing() then return end
	local pos = {getCursorPosition()}
	pos[1], pos[2] = (pos[1] * screenX), (pos[2] * screenY)
	if pos[1] >= x and pos[1] <= (x + w) and pos[2] >= y and pos[2] <= (y + h) then
		return true
	else
		return false
	end
end
----------------------------------------------------------------------------------------------------------
--------------------------------------editbox-------------------------------------------------------------

addCommandHandler("dashboard",
	function ()
		if getElementData(localPlayer, "loggedIn") then
			togglePanel()
		end
	end
)

addCommandHandler("admins",
	function ()
		if getElementData(localPlayer, "loggedIn") then
			if not panelState then
				selectedTab = 4
				togglePanel()
			elseif selectedTab ~= 4 then
				playSound("files/sounds/menuswitch.mp3")
			end

			selectedTab = 4
		end
	end
)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if press then
			if key == "mouse_wheel_up" then
				if panel then
					if scroll > 0 then
						scroll = scroll - 1
					end
				end
			elseif key == "mouse_wheel_down" then
				if page == 2 then
					if scroll < #loaded_company["membersCount"] - maxLine then
						scroll = scroll + 1
					end
				elseif page == 4 then
					if scroll < #getCompanyVehicles(loaded_company["id"]) - maxLine then
						scroll = scroll + 1
					end
				elseif page == 5 then
					if scroll < #loaded_company["transactions"] - maxLine then
						scroll = scroll + 1
					end
				end
			end
			if key == "home" and not buyingVehicleSlot and not sellVehicleToCompanyPlayer and not buyingInteriorSlot and not renderData.buyingPet then
				if getElementData(localPlayer, "loggedIn") then
					togglePanel()
					if selectedTab == 6 and panelState then
						openCompanyTab()
					end
				end

				cancelEvent()
				return
			elseif key == "F2" and not buyingVehicleSlot and not sellVehicleToCompanyPlayer and not buyingInteriorSlot and not renderData.buyingPet then
				if getElementData(localPlayer, "loggedIn") then
					if not panelState then
						selectedTab = 6
						togglePanel()
						openCompanyTab()
					elseif selectedTab ~= 6 then
						playSound("files/sounds/menuswitch.mp3")
						openCompanyTab()
					elseif panelState and selectedTab == 6 then --comapnyp
						togglePanel()
					end
					selectedTab = 6
				end
				cancelEvent()
				return
			elseif key == "F3" and not buyingVehicleSlot and not sellVehicleToCompanyPlayer and not buyingInteriorSlot and not renderData.buyingPet then
				if getElementData(localPlayer, "loggedIn") then
					if not panelState then
						selectedTab = 3
						togglePanel()
					elseif selectedTab ~= 3 then
						playSound("files/sounds/menuswitch.mp3")
					elseif panelState and selectedTab == 3 then
						togglePanel()
					end

					selectedTab = 3
				end

				cancelEvent()
				return
			end
		end

		if panelState then
			if key ~= "esc" then
				cancelEvent()
			end

			if selectedTab == 2 then
				local cx, cy = getCursorPosition()

				cx = cx * screenX
				cy = cy * screenY

				if key == "mouse_wheel_down" then
					if cx < screenX / 2 then
						if offsetVeh < #playerVehicles - 11 then
							offsetVeh = offsetVeh + 1
						end
					else
						if offsetInt < #playerInteriors - 11 then
							offsetInt = offsetInt + 1
						end
					end
				elseif key == "mouse_wheel_up" then
					if cx < screenX / 2 then
						if offsetVeh > 0 then
							offsetVeh = offsetVeh - 1
						end
					else
						if offsetInt > 0 then
							offsetInt = offsetInt - 1
						end
					end
				end

				if key == "backspace" and press then
					if buyingVehicleSlot or sellVehicleToCompanyPlayer or buyingInteriorSlot then
						if string.len(fakeInputText) >= 1 then
							fakeInputText = string.sub(fakeInputText, 1, -2)
						end
					end
				end
			elseif selectedTab == 3 then
				local cx, cy = getCursorPosition()

				cx = cx * screenX
				cy = cy * screenY

				if key == "mouse_wheel_down" then
					if cx < respc(30) + (screenX - respc(60)) / 3.5 then
						if offsetGroup < playerGroupsCount - 20 then
							offsetGroup = offsetGroup + 1
						end
					else
						local groupId = playerGroupsKeyed[selectedGroup]

						if groupId then
							if selectedGroupTab == 1 then
								if offsetMember < #groupMembers[groupId] - 14 then
									offsetMember = offsetMember + 1
								end
							elseif selectedGroupTab == 2 then
								if offsetRank < #groups[groupId].ranks - 14 then
									offsetRank = offsetRank + 1
								end
							elseif selectedGroupTab == 3 then
								if offsetGroupVeh < #factionVehicleList - 14 then
									offsetGroupVeh = offsetGroupVeh + 1
								end
							end
						end
					end
				elseif key == "mouse_wheel_up" then
					if cx < respc(30) + (screenX - respc(60)) / 3.5 then
						if offsetGroup > 0 then
							offsetGroup = offsetGroup - 1
						end
					else
						local groupId = playerGroupsKeyed[selectedGroup]

						if groupId then
							if selectedGroupTab == 1 then
								if offsetMember > 0 then
									offsetMember = offsetMember - 1
								end
							elseif selectedGroupTab == 2 then
								if offsetRank > 0 then
									offsetRank = offsetRank - 1
								end
							elseif selectedGroupTab == 3 then
								if offsetGroupVeh > 0 then
									offsetGroupVeh = offsetGroupVeh - 1
								end
							end
						end
					end
				end

				if key == "backspace" and press then
					if activeFakeInput == "inviting" or activeFakeInput == "setrankname" or activeFakeInput == "setrankpay" or activeFakeInput == "groupdesc" or activeFakeInput == "groupbalance" then
						if utf8.len(fakeInputText) >= 1 then
							fakeInputText = utf8.sub(fakeInputText, 1, -2)
						end
					end
				end
			elseif selectedTab == 5 then
				if key == "backspace" and press then
					if tonumber(renderData.buyDogType) then
						if renderData.dogName and utf8.len(renderData.dogName) >= 1 then
							renderData.dogName = utf8.sub(renderData.dogName, 1, -2)
						end
					end

					if renderData.renamingPet then
						if renderData.newDogName and utf8.len(renderData.newDogName) >= 1 then
							renderData.newDogName = utf8.sub(renderData.newDogName, 1, -2)
						end
					end
				end

				if key == "mouse_wheel_down" then
					if renderData.offsetAnimal < #renderData.loadedAnimals - 18 then
						outputChatBox("asd")
						renderData.offsetAnimal = renderData.offsetAnimal + 1
					end
				elseif key == "mouse_wheel_up" then
					if renderData.offsetAnimal > 0 then
						outputChatBox("asd")
						renderData.offsetAnimal = renderData.offsetAnimal - 1
					end
				end
			elseif selectedTab == 8 then --setting
				if key == "mouse_wheel_down" then
					if renderData.offsetSettings < #renderData.clientSettings - 12 then
						renderData.offsetSettings = renderData.offsetSettings + 1
					end
				elseif key == "mouse_wheel_up" then
					if renderData.offsetSettings > 0 then
						renderData.offsetSettings = renderData.offsetSettings - 1
					end
				end
			end
		end
	end)

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

local dutySkinSelectState = false
local originalSkin = 0
local currentSkinOffset = 0
local skinForGroup = false
local skinSelectFont = false

function toggleDutySkinSelect(state, groupId)
	if dutySkinSelectState ~= state then
		if state then
			dutySkinSelectState = true
			exports.sm_controls:toggleControl("all", false)

			skinForGroup = groupId
			originalSkin = getElementModel(localPlayer)
			currentSkinOffset = 0

			bindKey("arrow_r", "up", nextSkin)
			bindKey("arrow_l", "up", previousSkin)
			bindKey("enter", "up", processDutySkinSelection)

			skinSelectFont = dxCreateFont("files/fonts/Roboto.ttf", 15, false, "antialiased")

			addEventHandler("onClientRender", getRootElement(), dutySkinRender)
		else
			removeEventHandler("onClientRender", getRootElement(), dutySkinRender)

			if isElement(skinSelectFont) then
				destroyElement(skinSelectFont)
			end

			skinSelectFont = nil

			unbindKey("arrow_r", "up", nextSkin)
			unbindKey("arrow_l", "up", previousSkin)
			unbindKey("enter", "up", processDutySkinSelection)

			skinForGroup = false
			exports.sm_controls:toggleControl("all", true)
			dutySkinSelectState = false
		end
	end
end

function nextSkin()
	if skinForGroup and groups[skinForGroup] then
		if groups[skinForGroup].duty.skins[currentSkinOffset + 1] then
			currentSkinOffset = currentSkinOffset + 1
			setElementModel(localPlayer, groups[skinForGroup].duty.skins[currentSkinOffset])
		end
	end
end

function previousSkin()
	if skinForGroup and groups[skinForGroup] then
		if groups[skinForGroup].duty.skins[currentSkinOffset - 1] then
			currentSkinOffset = currentSkinOffset - 1
			setElementModel(localPlayer, groups[skinForGroup].duty.skins[currentSkinOffset])
		end
	end
end

function processDutySkinSelection()
	local selectedSkin = getElementModel(localPlayer)
	
	if selectedSkin ~= originalSkin then
		setElementModel(localPlayer, originalSkin)

		triggerServerEvent("updateDutySkin", localPlayer, skinForGroup, selectedSkin, originalSkin)
	end

	toggleDutySkinSelect(false)
	exports.sm_accounts:showInfo("s", "Sikeresen megváltoztattad a csoporthoz tartozó szolgálati öltözékedet.")
	togglePanel()
end

function dutySkinRender()
	dxDrawText("Lapozás: [<-] és [->] Kiválasztás: [ENTER]", 0 + 1, 0 + 1, screenX + 1, screenY - 150 + 1, tocolor(0, 0, 0), 1, skinSelectFont, "center", "bottom")
	dxDrawText("Lapozás: #7cc576[<-] és [->] #ffffffKiválasztás: #7cc576[ENTER]", 0, 0, screenX, screenY - 150, tocolor(200,200,200), 1, skinSelectFont, "center", "bottom", false, false, false, true)
end

function checkDistance(sourceElement, targetElement)
	if getElementInterior(sourceElement) ~= getElementInterior(targetElement) then
		return 999999
	end

	if getElementDimension(sourceElement) ~= getElementDimension(targetElement) then
		return 999999
	end

	local sourceX, sourceY, sourceZ = getElementPosition(sourceElement)
	local targetX, targetY, targetZ = getElementPosition(targetElement)

	return getDistanceBetweenPoints3D(sourceX, sourceY, sourceZ, targetX, targetY, targetZ)
end

function formatTime( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )
		if day > 0 and day < 10 then 
			table.insert( results, "#3d7abc"..day.. " #ffffffnap" .. ( day == 1 and "" or "" ) ) 
		elseif day > 0  then 
			table.insert( results, "#3d7abc"..day.." #ffffffnap" .. ( day == 1 and "" or "" ) ) end	
		if hou >= 1 and hou < 10 then 
			table.insert( results, "#3d7abc".."0"..hou .." #ffffffóra" .. ( hou == 1 and "" or "" ) ) 
		elseif hou > 0  then 
			table.insert( results, "#3d7abc"..hou .." #ffffffóra"..  ( hou == 1 and "" or "" ) ) end	
		if min >= 0 and min < 10 then 
			table.insert( results, "#3d7abc".."0"..min .." #ffffffperc".. ( min == 1 and "" or "" ) ) 
		elseif min > 0  then 
			table.insert( results, "#3d7abc"..min.." #ffffffperc" .. ( hou == 1 and "" or "" ) ) end	
		return string.reverse ( table.concat ( results, " " ):reverse():gsub(" ", " ", 1 ) )
	end
	return ""
end

--%d nap, %d óra és %d perc

function isInSlot(x, y, width, height)
	if isCursorShowing() then
		local cx, cy = getCursorPosition()
		local cx, cy = (cx * screenX), (cy * screenY)
		if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
			return true
		else
			return false
		end
	else
		return false
	end
end