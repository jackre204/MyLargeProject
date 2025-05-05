local modelTable = {
	{"files/models/inti_kicsi", "files/models/hoe", 16672},
	{"files/models/inti_kicsi", "files/models/shovel", 16102},
	{"files/models/inti_kicsi", "files/models/watercan", 16191},
	{"files/models/carrot", "files/models/carrot", 16192},
	{"files/models/radish", "files/models/radish", 16193},
	{"files/models/inti_kicsi", "files/models/inti_kicsi", 16671},
	{"files/models/inti_kicsi", "files/models/inti_kicsi", 16673},
	{"files/models/inti_kicsi", "files/models/board", 16674},
	{"files/models/parsley", "files/models/parsley", 16675},
	{"files/models/onion", "files/models/onion", 16134},
}
local animalTable = {}
local cargoTable = {}
local createdFarmModels = {}

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end
setElementData(localPlayer, "farmOrdered", false)
local orderTable = {}

function fosasok()
	txd = engineLoadTXD ( "files/models/feeding/tex.txd" )
	engineImportTXD(txd, 2713)
	engineImportTXD(txd, 2714)
	engineImportTXD(txd, 2715)
	engineImportTXD(txd, 2716)
	engineImportTXD(txd, 2717)
	engineImportTXD(txd, 2718)


	txd = engineLoadTXD ( "skin.txd" )
	engineImportTXD ( txd, 299)
    dff = engineLoadDFF ("skin.dff")
    engineReplaceModel (dff, 299)

    dff = engineLoadDFF ("files/models/feeding/etetonagy.dff")
    engineReplaceModel (dff, 2714)
	col = engineLoadCOL ( "files/models/feeding/etetonagy.col" )
	engineReplaceCOL ( col, 2714)

    dff = engineLoadDFF ("files/models/feeding/itato.dff")
    engineReplaceModel (dff, 2715)
	col = engineLoadCOL ( "files/models/feeding/itato.col" )
	engineReplaceCOL ( col, 2715)

	txd = engineLoadTXD ( "files/mods/trailer.txd" )
	engineImportTXD(txd, 608)
    dff = engineLoadDFF ("files/mods/trailer.dff")
    engineReplaceModel (dff, 608)


    dff = engineLoadDFF ("files/models/feeding/tap.dff")
    engineReplaceModel (dff, 2716)
	col = engineLoadCOL ( "files/models/feeding/tap.col" )
	engineReplaceCOL ( col, 2716)

    dff = engineLoadDFF ("files/models/feeding/villa.dff")
    engineReplaceModel (dff, 2717)
	col = engineLoadCOL ( "files/models/feeding/villa.col" )
	engineReplaceCOL ( col, 2717)

    dff = engineLoadDFF ("files/models/feeding/vodor.dff")
    engineReplaceModel (dff, 2718)
	col = engineLoadCOL ( "files/models/feeding/vodor.col" )
	engineReplaceCOL ( col, 2718)
	
	createObject(2713, 92.054908752441, -108.0142288208, 1.080873966217)
	createObject(2714, 93.054908752441, -108.0142288208, 1.080873966217)

	createObject(2715, 94.054908752441, -108.0142288208, 1.080873966217)
	createObject(2716, 95.054908752441, -108.0142288208, 1.080873966217)

	createObject(2717, 96.054908752441, -108.0142288208, 1.080873966217)
	createObject(2718, 97.054908752441, -108.0142288208, 1.080873966217)

end
addEventHandler("onClientResourceStart", resourceRoot, fosasok)

local renderTarget = dxCreateRenderTarget(128*5, 128*10)

local screenX, screenY = guiGetScreenSize()

pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

boardTarget = {}
boardShader = {}

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

function loadFarmModels()
	for k, v in pairs(modelTable) do
		changeObjectModel(v[1],v[2],v[3])
	end
end

local screenDatas = {
    x = screenX / 2 - respc(800) / 2,
    y = screenY / 2 - respc(430) / 2,
    w = respc(800),
    h = respc(430)
    
}

function loadFonts()

	RalewayB = exports.sm_core:loadFont("Raleway.ttf", respc(10), false, "antialiased")
	Raleway = exports.sm_core:loadFont("Raleway.ttf", respc(10), false, "antialiased")
	RalewayBig = exports.sm_core:loadFont("Raleway.ttf", respc(20), false, "antialiased")

end

addEventHandler("onAssetsLoaded", getRootElement(),
    function ()
        loadFonts()
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function ()
        loadFonts()
		loadClientFarmForPlayer()
    end
)

function changeObjectModel(filename,filename2,id)
	if id and filename then
		if fileExists(filename..".txd") then
			txd = engineLoadTXD( filename..".txd", true)
			engineImportTXD( txd, id )
		end
		if fileExists(filename2..".dff") then
			dff = engineLoadDFF( filename2..".dff", 0)
			engineReplaceModel( dff, id )
		end
		if fileExists(filename2..".col") then
			col = engineLoadCOL( filename2..".col" )
			engineReplaceCOL( col, id )
		end
	end
end
loadFarmModels()


function enterFarmInterior()
	if isElement(hitMarker) then
		if not getPedOccupiedVehicle(localPlayer) then
			if getElementData(hitMarker, "farm:owner") > 0 then
				if getElementData(hitMarker, "farm:locked") == 0 then
					if getElementData(localPlayer, "farm:hoe") or getElementData(localPlayer, "farm:spade") then
						outputChatBox("Előbb rakd le ami a kezedben van!")
						return
					end
					farmMarker = hitMarker
					triggerServerEvent("getIntoFarmInterior", localPlayer, localPlayer, hitMarker)
				else
					outputChatBox("bevan zarva xddd", 255,255,255, true)
				end
			end
		end
	end
end


notificationData = {}

function farmMarkerHit(thePlayer)
	if thePlayer == localPlayer then
		if getElementDimension(source) == getElementDimension(thePlayer) then
			if getElementData(source, "farm:marker") then
				local px,py,pz = getElementPosition(thePlayer)
				local mx,my,mz = getElementPosition(source)
				if getDistanceBetweenPoints3D(px,py,pz, mx,my,mz) < 2 then
					hitMarker = source
					farmMarker = hitMarker
					bindKey("e", "down", enterFarmInterior)
					if (notificationData ~= nil) then
						table.remove(notificationData, #notificationData);
					end

					table.insert(notificationData,
						{
							StartY = (screenY+(10)),
							EndY = (screenY)-(150),
							Text = "text",
							State = 'openTile',
							Tick = getTickCount(),
							Name = getElementData(hitMarker, "farm:name").." #"..getElementData(hitMarker, "farm:markerID"),
							owner = getElementData(hitMarker, "farm:owner")
						}
					)
					if getElementData(hitMarker, "farm:owner") == 0 then
						outputChatBox("rentfarm mer nincs tulaja", 255,255,255, true)
					end
				end
			end
		end
	end
end
addEventHandler("onClientMarkerHit", getRootElement(), farmMarkerHit)

blockTable = {}

local renderData = {
	plantState = false,
	maxSeedShow = 4,
	scrollNum = 0,
	farmInterior = false,
	farmDimension = 0,
	interiorW = 300,
	interiorH = 60,
	invitingText = "",
	actualEditing = "",
	memberNameEdit = "",
	permissionState = false,
	newMemberState = false,
}

rentPrice = 8000

function generateDefaultBlockTable()
	local defaultBlockTable = {}
	local row, column = 0, 0
	for i = 1, 50 do
		if column ~= 5 then
			column = column + 1
		end
        table.insert(defaultBlockTable, {
            state = "land",
            newState = false,
            newStateLevel = 0,
            newStateSaveLevel = 0,
            changingTick = 0,
            changingState = false,
            changingSlot = 0,
            changingValue = 0,
            changingTime = 0,

            plantObject = 0,
            plantTimer = growingTime,
            plantSize = 0,
            plantFullSize = 1,
            plantTick = 0,
            plantIndex = 0,
            plantHealth = 100,
            plantHelathChanger = 100,
            healthRemainingTime = healthTime,
            healthTick = 0,
            sizeChanger = 0,

            hayLevel = 0,
            manureLevel = 0,
			clearLevel = 100,
            waterChanger = 0,
            wateringState = false,
            wateringTick = 0,
            waterLossTick = 0,
            waterLossTime = waterLosingTime,

            blockRow = row,
            blockColumn = column,
        })

		if column == 5 then
			column = 0
			row = row + 1
		end
	end
	return defaultBlockTable
end


addEvent("syncBlockTableClient", true)
addEventHandler("syncBlockTableClient", getRootElement(), function(player, table, delete, permissions, atable, orders, cargo)
	if not delete then
		renderData.farmDimension = getElementDimension(player)
		if table then
			blockTable[renderData.farmDimension] = table
			if atable then
				animalTable[renderData.farmDimension] = atable or {}
				orderTable[renderData.farmDimension] = orders or {}
				cargoTable[renderData.farmDimension] = cargo or {}
				for k, v in ipairs(cargo) do
					if v[1] == "Szalma" then
						for i = 1, tonumber(v[2]) do
							local obj = createObject(v[3], -24.412273406982, -352.80783081055, 5004.317773438 + i/2)
							setObjectScale(obj, 2.1)
							print("createdobject")
							setElementDimension(obj, renderData.farmDimension)
							setElementData(obj, "farm.cargo", true)
							setElementData(obj, "farm.cargoslot", v[2])
							setElementData(obj, "farm.cargotype", v[1])
						end
					elseif v[1] == "Pellet táp" then
						for i = 1, tonumber(v[2]) do
							local pelletobj = createObject(v[3], -21.532529830933, -352.97512817383, 5004.317773438 + i/4)
							print("createdobject")
							setElementDimension(pelletobj, renderData.farmDimension)
							setElementData(pelletobj, "farm.cargo", true)
							setElementData(pelletobj, "farm.cargoslot", v[2])
							setElementData(pelletobj, "farm.cargotype", v[1])
						end
					elseif v[1] == "Csirke táp" then
						for i = 1, tonumber(v[2]) do
							local chickenobj = createObject(v[3], -22.886692047119, -352.88027954102, 5004.317773438 + i/4)
							print("createdobject")
							setElementDimension(chickenobj, renderData.farmDimension)
							setElementData(chickenobj, "farm.cargo", true)
							setElementData(chickenobj, "farm.cargoslot", v[2])
							setElementData(chickenobj, "farm.cargotype", v[1])
						end
					end
				end
			else
				animalTable[renderData.farmDimension] = {}
				orderTable[renderData.farmDimension] = orders or {}
				cargoTable[renderData.farmDimension] = cargo or {}
				for k, v in ipairs(cargo) do
					if v[1] == "Szalma" then
						for i = 1, tonumber(v[2]) do
							local obj = createObject(v[3], -24.412273406982, -352.80783081055, 5004.317773438 + i/2)
							setObjectScale(obj, 2.1)
							print("createdobject")
							setElementDimension(obj, renderData.farmDimension)
							setElementData(obj, "farm.cargo", true)
							setElementData(obj, "farm.cargoslot", v[2])
							setElementData(obj, "farm.cargotype", v[1])
						end
					elseif v[1] == "Pellet táp" then
						for i = 1, tonumber(v[2]) do
							local pelletobj = createObject(v[3], -21.532529830933, -352.97512817383, 5004.317773438 + i/4)
							print("createdobject")
							setElementDimension(pelletobj, renderData.farmDimension)
							setElementData(pelletobj, "farm.cargo", true)
							setElementData(pelletobj, "farm.cargoslot", v[2])
							setElementData(pelletobj, "farm.cargotype", v[1])
						end
					elseif v[1] == "Csirke táp" then
						for i = 1, tonumber(v[2]) do
							local chickenobj = createObject(v[3], -22.886692047119, -352.88027954102, 5004.317773438 + i/4)
							print("createdobject")
							setElementDimension(chickenobj, renderData.farmDimension)
							setElementData(chickenobj, "farm.cargo", true)
							setElementData(chickenobj, "farm.cargoslot", v[2])
							setElementData(chickenobj, "farm.cargotype", v[1])
						end
					end
				end
			end
			iprint(atable)
			addEventHandler("onClientRender", root, renderLand)
			local forkObj = createObject(2717, worldX, -366.29569702148, 5006.5717773438, 0, 180, -90)
            setElementDimension(forkObj, renderData.farmDimension)
            setElementData(forkObj, "farm:fork", true)
            setElementData(forkObj, "farm:forkNumber", 2)
            renderTarget = dxCreateRenderTarget(128*5, 128*10) 
		else
            renderTarget = dxCreateRenderTarget(128*5, 128*10) 
			blockTable[renderData.farmDimension] = generateDefaultBlockTable()
			animalTable[renderData.farmDimension] = {}
			orderTable[renderData.farmDimension] = {}
			cargoTable[renderData.farmDimension] = {}
			for k, v in ipairs(cargo) do
				if v[1] == "Szalma" then
					for i = 1, tonumber(v[2]) do
						local obj = createObject(v[3], -24.412273406982, -352.80783081055, 5004.317773438 + i/2)
						setObjectScale(obj, 2.1)
						print("createdobject")
						setElementDimension(obj, renderData.farmDimension)
						setElementData(obj, "farm.cargo", true)
						setElementData(obj, "farm.cargoslot", v[2])
						setElementData(obj, "farm.cargotype", v[1])
					end
				elseif v[1] == "Pellet táp" then
					for i = 1, tonumber(v[2]) do
						local pelletobj = createObject(v[3], -21.532529830933, -352.97512817383, 5004.5717773438 + i/4)
						print("createdobject")
						setElementDimension(pelletobj, renderData.farmDimension)
						setElementData(pelletobj, "farm.cargo", true)
						setElementData(pelletobj, "farm.cargoslot", v[2])
						setElementData(pelletobj, "farm.cargotype", v[1])
					end
				elseif v[1] == "Csirke táp" then
					for i = 1, tonumber(v[2]) do
						local chickenobj = createObject(v[3], -22.886692047119, -352.88027954102, 5004.5717773438 + i/4)
						print("createdobject")
						setElementDimension(chickenobj, renderData.farmDimension)
						setElementData(chickenobj, "farm.cargo", true)
						setElementData(chickenobj, "farm.cargoslot", v[2])
						setElementData(chickenobj, "farm.cargotype", v[1])
					end
				end
			end
            addEventHandler("onClientRender", root, renderLand)
		end
		renderData.farmInterior = true

		permissionTable = permissions
	else
		for k, v in pairs(blockTable[renderData.farmDimension]) do
			if isElement(v.plantObject) then
				destroyElement(v.plantObject)
			end
		end
		for k, v in pairs(getElementsByType("object")) do
			if isElement(v) then
				if getElementData(v, "farm.cargo") then
					destroyElement(v)
				end
			end
		end
        destroyElement(renderTarget)
		if isElement(createdFarmModels[player]) then
			destroyElement(createdFarmModels[player])
		end
        removeEventHandler("onClientRender", root, renderLand)
		renderData.farmInterior = false
		blockTable[renderData.farmDimension] = nil

		permissionTable = {}
	end
end)

function rentFarm(cmd, premium)
	if hitMarker then
		if getElementData(hitMarker, "farm:owner") == 0 then
			if premium == "pp" then
				if getElementData(localPlayer, premiumElementData) >= rentPricePremium then
					triggerServerEvent("rentFarmServer", localPlayer, localPlayer, getElementData(hitMarker, "farm:markerID"), rentPricePremium, premiumElementData)
				else
					outputChatBox("nincs pp xddddddd ppz pls", 255,255,255, true)
				end
			else
				if tonumber(getElementData(localPlayer, "char.Money")) >= rentPrice then
					triggerServerEvent("rentFarmServer", localPlayer, localPlayer, getElementData(hitMarker, "farm:markerID"), rentPrice, moneyElementData)
				else
					outputChatBox("nincs penzed xDDDDDD", 255,255,255, true)
				end
			end
		else
			outputChatBox("mar megvette valaki", 255,255,255, true)
		end
	end
end
addCommandHandler("rentfarm", rentFarm)

local clickTick = getTickCount()
local sliderHeight = screenY * 0.018
local infoW, infoH = 190, 85
local sliderWidth = respc(600) / 1.5
function renderLand()
	local fontH = dxGetFontHeight(1, Raleway)

	buttonsC = {}
    lastActiveDirectX = activeDirectX
	activeDirectX = false
	local localX, localY, localZ = getElementPosition(localPlayer)
	local objects = getElementsByType("object", getRootElement(), true)
	if #objects > 0 then
		for i = 1, #objects do
			local object = objects[i]

			if isElement(object) and isElementStreamable(object) then
				if getElementData(object, "farm:fork") then
					local objX, objY, objZ = getElementPosition(object)
					objZ = objZ - 0.5
					if isLineOfSightClear(objX, objY, objZ, localX, localY, localZ, false, false, false, false, false, false, false, localPlayer) then
						local screenX, screenY = getScreenFromWorldPosition(objX, objY, objZ + 0.5)

						if screenX and screenY then
							local distance = getDistanceBetweenPoints3D(objX, objY, objZ, localX, localY, localZ)
							print("fork")
							if distance < 3 then
								local distMul = 1 - distance / 40
								local alphaMul = 1

								local sx = 100 * distMul
								local sy = 40 * distMul
								local x = screenX - sx
								local y = screenY - sy
								local text = ""
								local numberOfObject = 0
								dxDrawRectangle(x, y + (24) * distMul, 100, 40, tocolor(25, 25, 25))
								if getElementData(object, "farm:fork") then
									text = "Vasvilla"
									numberOfObject = getElementData(object, "farm:forkNumber")
								end
								dxDrawText("#3d7abc" .. text, x, y + (24) * distMul + 10, x + sx, 0, tocolor(255, 255, 255, 255 * alphaMul), distMul * 1, Raleway, "center", "top", false, false, false, true)
							end
						end
					end
				end
			end
		end
	end
	if renderAnimals then
		dxDrawRectangle(screenDatas.x, screenDatas.y, screenDatas.w, screenDatas.h, tocolor(25, 25, 25))
		for k, v in ipairs(renderAnimals) do
			dxDrawText(v["name"], screenDatas.x + respc(10), screenDatas.y + respc(35)*k, screenDatas.w, screenDatas.h, tocolor(200, 200, 200, 200), 1, RalewayBig)
		end
		drawButton("closeGetAnimals", "Bezárás", screenDatas.x + 5, screenDatas.y + screenDatas.h - 40, screenDatas.w - 10, respc(35), {188, 64, 61}, false, RalewayB)

	end
	if hayOrdering or pelletShow then
		dxDrawRectangle(screenDatas.x + respc(200), screenDatas.y + respc(100), screenDatas.w/2, screenDatas.h/2, tocolor(25, 25, 25))

		drawButton("closeHay", "Bezárás", screenDatas.x + respc(200) + 5, screenDatas.y + respc(280), screenDatas.w/2 - 10, respc(30), {188, 64, 61}, false, RalewayB)
		drawButton("orderHay", "Rendelés", screenDatas.x + respc(200) + 5, screenDatas.y + respc(245), screenDatas.w/2 - 10, respc(30), {61, 122, 188}, false, RalewayB)
		dxDrawRectangle(screenDatas.x + 3 + respc(200), screenDatas.y + 3 + respc(100), screenDatas.w/2 - 6, respc(40) - 6, tocolor(45, 45, 45))
		dxDrawText("".. set[1] .." rendelés", screenDatas.x + 3 + respc(10) + respc(200), screenDatas.y + respc(20) + respc(100), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
		dxDrawText("#3d7abc "..math.floor(set[2]).." db", screenDatas.x + 3 + respc(10) + respc(350), screenDatas.y + respc(55) + respc(100), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayBig, "left", "center", false, false, false, true)
		
		local cursorX, cursorY = getCursorPosition()

		if tonumber(cursorX) and tonumber(cursorY) then
			cursorX = cursorX * screenX
			cursorY = cursorY * screenY
		end

		

		local lineY = respc(500)

		sliderBaseX = screenDatas.x + respc(200)
		local sliderBaseY = screenDatas.y + respc(200)

		sliderX = sliderBaseX + reMap(tonumber(set[2]), set[3][1], set[3][2], 0, sliderWidth - respc(15))
		sliderY = lineY - sliderHeight + 10

		dxDrawRectangle(sliderBaseX, sliderBaseY, sliderWidth, sliderHeight, tocolor(55, 55, 55, 200))
		dxDrawRectangle(sliderX, sliderBaseY, respc(15), sliderHeight, tocolor(61, 122, 188, 210))

		if getKeyState("mouse1") and sliderMoveX then
			if activeSlider == set[1] then
				local sliderValue = (cursorX - sliderMoveX - sliderBaseX) / (sliderWidth - respc(15))

				if sliderValue < 0 then
					sliderValue = 0
				end

				if sliderValue > 1 then
					sliderValue = 1
				end

				set[2] = reMap(sliderValue, 0, 1, set[3][1], set[3][2])
				--set[2] = reMap(sliderValue, 0, 1, set[4][1], set[4][2])
			end
		else
			sliderMoveX = false
			activeSlider = false
		end

		if not sliderMoveX and activeButtonC == "setting_slider:" .. set[1] then
			sliderMoveX = cursorX - sliderX
			activeSlider = set[1]
			
		end

		buttonsC["setting_slider:" .. set[1]] = {sliderX, sliderBaseY, respc(15), sliderHeight}
	end
    dxSetRenderTarget(renderTarget, true)
        for k, v in pairs(blockTable[renderData.farmDimension]) do
            if v.state then
                dxDrawImage((v.blockColumn-1)*128,v.blockRow*128,128, 128,"files/images/land.png")
                dxDrawImage((v.blockColumn-1)*128-64,v.blockRow*128-64,256, 256,"files/images/hay.png",0,0,0,tocolor(255,255,255,255 * (v.hayLevel/100)))
                dxDrawImage((v.blockColumn-1)*128-64,v.blockRow*128-64,256, 256,"files/images/manure.png",0,0,0,tocolor(255,255,255,255 * (v.manureLevel/100)))
            end
            if selectedPlant == k then
                if isCursorShowing() then
                    dxDrawImage((v.blockColumn-1)*128,v.blockRow*128,128, 128,"files/images/selection.png")
                    if getKeyState("mouse1") and clickTick + 1000 <= getTickCount() and not interPolation then
						if tonumber(blockTable[renderData.farmDimension][selectedPlant].hayLevel + 100) < 101 then
							clickTick = getTickCount()
							startInterpolate = clickTick
							stopInterpolate = clickTick + 1000
							interPolation = true
							addingFor = selectedPlant
							oldLevel = blockTable[renderData.farmDimension][addingFor].hayLevel
							triggerServerEvent("syncNewSurfaceToServer", localPlayer, selectedPlant, "haying", localPlayer, 0, renderData.farmDimension, oldLevel + 100)
							setTimer(function()
								interPolation = false
								blockTable[renderData.farmDimension][addingFor].state = "land"
								oldLevel = false
							end, 2550, 1)
						else
							clickTick = getTickCount()
							startInterpolate = clickTick
							stopInterpolate = clickTick + 1000
							interPolation = true
							addingFor = selectedPlant
							oldLevel = blockTable[renderData.farmDimension][addingFor].hayLevel
							triggerServerEvent("syncNewSurfaceToServer", localPlayer, selectedPlant, "haying", localPlayer, 0, renderData.farmDimension, 100)
							setTimer(function()
								interPolation = false
								blockTable[renderData.farmDimension][addingFor].state = "land"
								oldLevel = false
							end, 2550, 1)
						end
                    end
                end
            end
        end
    dxSetRenderTarget()
	if interPolation then
		progress = (getTickCount() - startInterpolate) / 2500
		local state = interpolateBetween ( oldLevel, 0, 0, 100, 0, 0, progress, "Linear")
		if oldLevel + state < 101 then
			blockTable[renderData.farmDimension][addingFor].hayLevel = oldLevel + state
		end
	end
    	if isCursorShowing() then
			local relativeX, relativeY = getCursorPosition()
			local cursorX, cursorY = relativeX * screenX, relativeY * screenY
			local cameraPosX, cameraPosY, cameraPosZ = getCameraMatrix()
			local cursorWorldPosX, cursorWorldPosY, cursorWorldPosZ = getWorldFromScreenPosition(cursorX, cursorY, 1000)
			local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ = processLineOfSight(cameraPosX, cameraPosY, cameraPosZ, cursorWorldPosX, cursorWorldPosY, cursorWorldPosZ, true, true, true, true, true, true, false, true, localPlayer)
			local row, column = 0, 0
			selectedPlant = 0
			hitPosZ = hitZ
			for i = 1, 50 do
				if column ~= 5 then
					column = column + 1
				end


				if isCursorInterSect3D(hitX, hitY, worldX+((column-1)), worldY+row, 1, 1) then
					selectedPlant = i
					activeDirectX = selectedPlant
					selectedRow = row
					selectedColumn = column
					surfaceX, surfaceY = getScreenFromWorldPosition(worldX+(column-1)+0.5, worldY+row+0.5, 5004.5)
					if surfaceX and isCursorShowing() then
						dxDrawRectangle(surfaceX-infoW/2, surfaceY-infoH/2, infoW, infoH, tocolor(25, 25, 25))
						dxDrawRectangle(surfaceX-infoW/2 + 3 + 2, surfaceY-infoH/2 + 20, infoW - 10, 20, tocolor(45, 45, 45, 255))
						dxDrawRectangle(surfaceX-infoW/2 + 5 + 2, surfaceY-infoH/2 + 2 + 20, blockTable[renderData.farmDimension][selectedPlant].hayLevel * 1.75, 16, tocolor(61, 122, 188, 255))
						dxDrawText("".. math.floor(blockTable[renderData.farmDimension][selectedPlant].hayLevel) .."%", surfaceX-infoW/2 + 77, surfaceY-infoH/2 + 2 + 20, nil, nil, tocolor(200, 200, 200, 255), 1, Raleway)	
						dxDrawText("Szalmázottság", surfaceX-infoW/2 + 50, surfaceY-infoH/2 + 2, nil, nil, tocolor(200, 200, 200, 255), 1, Raleway)	
						
						dxDrawRectangle(surfaceX-infoW/2 + 3 + 2, surfaceY-infoH/2 + 56, infoW - 10, 20, tocolor(45, 45, 45, 255))
						dxDrawRectangle(surfaceX-infoW/2 + 5 + 2, surfaceY-infoH/2 + 2 + 56, blockTable[renderData.farmDimension][selectedPlant].clearLevel * 1.75, 16, tocolor(61, 122, 188, 255))
						dxDrawText("".. math.floor(blockTable[renderData.farmDimension][selectedPlant].clearLevel) .."%", surfaceX-infoW/2 + 77, surfaceY-infoH/2 + 2 + 56, nil, nil, tocolor(200, 200, 200, 255), 1, Raleway)	
						dxDrawText("Tisztaság", surfaceX-infoW/2 + 65, surfaceY-infoH/2 + 39, nil, nil, tocolor(200, 200, 200, 255), 1, Raleway)	
					end			
				end
					
				if column == 5 then
					column = 0
					row = row + 1
				end
        	end
			if activeDirectX ~= lastActiveDirectX and activeDirectX then
				renderData.plantState = false
			end
    	end
		dxDrawImage3D(worldX, worldY, 4.45, 10, 1, renderTarget, tocolor( 255, 255, 255, 255 ) )
	if not farmMarker then
		return
	end

	if (getElementData(localPlayer, "char.ID") == getElementData(farmMarker, "farm:owner")) or hasPlayerPermission("allowOrder") then
		local manageX, manageY = getScreenFromWorldPosition(-21.083984375, -367.43768310547, 5005.8471306800842)
		if manageX and manageY then
			local localX, localY, localZ = getElementPosition(localPlayer)
			local distance = getDistanceBetweenPoints3D(-21.083984375, -367.43768310547, 5006.4471306800842, localX, localY, localZ)

			if distance < 3 then
				local distMul = 1 - distance / 30
				local alphaMul = 1 - distance / 5
				boardText = getElementData(farmMarker, "farm:name") or "Fos"
				local cursorTickCorrectY = 0

				if not renderData.permissionState then
					local sx = 150 * distMul
					local sy = 30 * distMul
					local x = manageX - sx / 2
					local y = manageY - sy / 2

					if renderData.actualEditing == "farm:board" then
						boardText = utf8.gsub(utf8.upper(renderData.invitingText), "_", " ")
						changeNameButtonText = "Tábla neve"
						if cursorState then
							local w = dxGetTextWidth(renderData.invitingText, distMul * 0.8, RalewayB)
							if utf8.len(boardText) >= 11 then
								cursorTickCorrectY = 23
								w = dxGetTextWidth(utf8.sub(renderData.invitingText, 12, utf8.len(boardText)), distMul * 0.8, RalewayB)
							end
							dxDrawLine(x+80+w/2, y + (24) * distMul+35+cursorTickCorrectY, x+80+w/2, y + (24) * distMul+55+cursorTickCorrectY, tocolor(255, 255, 255, 255), 1, true)
						end
					else
						changeNameButtonText = "Tábla név változtatás"
					end
					if not string.find(boardText, "\n") then
						if utf8.len(boardText) >= 11 then
							boardText = utf8.sub(boardText, 1, 11).."/xentx/"..utf8.sub(boardText, 12, utf8.len(boardText))
						end
						boardText = boardText:gsub("/xentx/", "\n")
					end
					if not renderAnimals and not hayOrdering then
						if (#orderTable[renderData.farmDimension] < 1 or closedOrdering or not getElementData(localPlayer, "farmOrdered")) then
							dxDrawRectangle(x, y + (24) * distMul, 150, 150, tocolor(25,25,25))
							dxDrawText("Farm kezelése", x, y + (24) * distMul, x + sx+10, y + (24) * distMul+25, tocolor(255, 255, 255, 255 * alphaMul), distMul * 0.9, RalewayB, "center", "center")
						end
					end
					if not orderState and not orderPanel and not animalMainOrderPanel and not hayOrdering then
						dxDrawText(boardText, x, y + (24) * distMul+35, x + sx+10, y + (24) * distMul+55, tocolor(255, 255, 255, 255 * alphaMul), distMul * 0.8, RalewayB, "center", "top")
						if (getElementData(localPlayer, "char.ID") == getElementData(farmMarker, "farm:owner")) then
							drawButton("perms", "Jogok", x+5, y + (24) * distMul + 75, 140, 20, {61, 122, 188}, false, RalewayB)
							drawButton("editFarmName", "Farm név", x+5, y + (24) * distMul + 100, 140, 20, {61, 122, 188}, false, RalewayB)
						end
						if (getElementData(localPlayer, "char.ID") == getElementData(farmMarker, "farm:owner")) or hasPlayerPermission("allowOrder") then
							drawButton("manageAnimals", "Állatok kezelése", x+5, y + (24) * distMul + 125, 140, 20, {61, 122, 188}, false, RalewayB)
						end
					end
					if orderState and not renderAnimals and not hayOrdering and not orderPanel then
						drawButton("getAnimals", "Állatok", x+5, y + (24) * distMul + 25, 140, 20, {61, 122, 188}, false, RalewayB)
						drawButton("farmState", "Farm állapot", x+5, y + (24) * distMul + 50, 140, 20, {61, 122, 188}, false, RalewayB)
						drawButton("order", "Mezőgazdasági nagyker", x+5, y + (24) * distMul + 75, 140, 20, {61, 122, 188}, false, RalewayB)
						drawButton("closeOrderState", "Bezárás", x+5, y + (24) * distMul + 100, 140, 20, {188, 64, 61}, false, RalewayB)
					end
					if orderPanel and not renderAnimals and not hayOrdering then
						if #orderTable[renderData.farmDimension] < 1 then
							drawButton("orderAnimals", "Állatok", x+5, y + (24) * distMul + 25, 140, 20, {61, 122, 188}, false, RalewayB)
							drawButton("hay", "Szalma", x+5, y + (24) * distMul + 50, 140, 20, {61, 122, 188}, false, RalewayB)
							drawButton("pellet", "Pellet táp", x+5, y + (24) * distMul + 75, 140, 20, {61, 122, 188}, false, RalewayB)
							drawButton("chickenfood", "Csirke táp", x+5, y + (24) * distMul + 100, 140, 20, {61, 122, 188}, false, RalewayB)
							drawButton("closeOrderPanel", "Bezárás", x+5, y + (24) * distMul + 125, 140, 20, {188, 64, 61}, false, RalewayB)
						else
							if not closedOrdering then
								dxDrawRectangle(screenDatas.x + respc(200), screenDatas.y + respc(100), screenDatas.w/2, screenDatas.h/2, tocolor(25, 25, 25))
								drawButton("removeOrder", "Rendelés lemondása", screenDatas.x + respc(200) + 5, screenDatas.y + respc(280), screenDatas.w/2 - 10, respc(30), {188, 64, 61}, false, RalewayB)
								drawButton("closeOrder", "Bezárás", screenDatas.x + respc(200) + 5, screenDatas.y + respc(245), screenDatas.w/2 - 10, respc(30), {188, 64, 61}, false, RalewayB)
								dxDrawRectangle(screenDatas.x + 3 + respc(200), screenDatas.y + 3 + respc(100), screenDatas.w/2 - 6, respc(40) - 6, tocolor(45, 45, 45))
								dxDrawText("Mezőgazdasági nagyker", screenDatas.x + 3 + respc(10) + respc(200), screenDatas.y + respc(20) + respc(100), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayB, "left", "center", false, false, false, true)
								dxDrawText("Jelenlegi rendelés: #3d7abc".. orderTable[renderData.farmDimension][1] .." \n #c8c8c8Mennyiség: #3d7abc".. orderTable[renderData.farmDimension][2] .."", screenDatas.x + 3 + respc(110) + respc(200), screenDatas.y + respc(80) + respc(100), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayB, "left", "center", false, false, false, true)
							end
						end
					end
					if animalMainOrderPanel and not renderAnimals and not hayOrdering and (#orderTable[renderData.farmDimension] < 1 or closedOrdering) then
						drawButton("orderMainGoat", "Kecske", x+5, y + (24) * distMul + 25, 140, 20, {61, 122, 188}, false, RalewayB)
						drawButton("orderMainPig", "Sertés", x+5, y + (24) * distMul + 50, 140, 20, {61, 122, 188}, false, RalewayB)
						drawButton("orderMainChicken", "Csirke", x+5, y + (24) * distMul + 75, 140, 20, {61, 122, 188}, false, RalewayB)
						drawButton("orderMainCow", "Tehén", x+5, y + (24) * distMul + 100, 140, 20, {61, 122, 188}, false, RalewayB)
						drawButton("closeMainOrderPanel", "Bezárás", x+5, y + (24) * distMul + 125, 140, 20, {188, 64, 61}, false, RalewayB)
					end
				else
					local sx = 300 * distMul
					local sy = 25 * distMul
					local x = manageX - sx / 2
					local y = manageY - sy / 2
					local plusPermissionWidth = #permissionTable * 25
					permissionSelected = ""
					permissionKey = 0
					dxDrawRectangle(x, y + (24) * distMul, 300, 25, tocolor(25, 25, 25))
					dxDrawText("Jogosultságok kezelése", x, y + (24) * distMul, x + sx+10, y + (24) * distMul+25, tocolor(255, 255, 255, 255 * alphaMul), distMul * 0.9, RalewayB, "center", "center")
					if renderData.actualEditing == "" then
						dxDrawRectangle(x, y + (24) * distMul+25, 300, 25+plusPermissionWidth, tocolor(35, 35, 35))						
						drawButton("newMemberButton", "Tag hozzáadása", x+3, y + (24) * distMul + 27+plusPermissionWidth, 130, 20, {61, 122, 188}, false, RalewayB)

						drawButton("closePermission", "Mentés", x+237, y + (24) * distMul + 27+plusPermissionWidth, 60, 20, {61, 122, 188}, false, RalewayB)

						
						for k, v in pairs(permissionTable) do
							dxDrawText(v.playerName, x+5, y + (24) * distMul + 23 + (k*25)-25, x + sx+10, y + (24) * distMul+50 + (k*25)-25, tocolor(255, 255, 255, 255 * alphaMul), distMul * 0.9, RalewayB, "left", "center")
							local counter = 0
							for permK, permV in pairs(v.permissions) do
								counter = counter + 1
								if isMouseInPosition(x+150+(counter-1)*25, y + (24) * distMul + 23 + (k*25)-25, 25, 25) then
									permissionKey = k
									permissionSelected = permK
								end
								dxDrawTick(x+150+(counter-1)*25, y + (24) * distMul + 23 + (k*25)-25, permV, permissionMenu[counter])
							end
						end
					else
						dxDrawRectangle(x, y + (24) * distMul+25, 300, 25, tocolor(35, 35, 35))
						renderData.memberNameEdit = renderData.invitingText
						local w = dxGetTextWidth(renderData.invitingText, distMul * 0.9, RalewayB)
						dxDrawLine(x+8+w, y + (24) * distMul+28, x+8+w, y + (24) * distMul+45, tocolor(255, 255, 255, 255), 1, true)
						dxDrawText(renderData.memberNameEdit, x+5, y + (24) * distMul + 23, x + sx+10, y + (24) * distMul+50, tocolor(255, 255, 255, 255 * alphaMul), distMul * 0.9, RalewayB, "left", "center")
						drawButton("addMemberDone", "Hozzáadás", x+237, y + (24) * distMul + 27, 60, 20, {61, 122, 188}, false, RalewayB)
					end
				end
			end
		end
	end
	local relX, relY = getCursorPosition()

    activeButtonC = false

    if relX and relY then
        relX = relX * screenX
        relY = relY * screenY

        for k, v in pairs(buttonsC) do
            if relX >= v[1] and relY >= v[2] and relX <= v[1] + v[3] and relY <= v[2] + v[4] then
                activeButtonC = k
                break
            end
        end
    end
end

function dxDrawImage3D( x, y, z, width, height, material, color, rotation, ... )
	return dxDrawMaterialLine3D( x+2.5, y, z + 5000.1, x+2.5, y+width, z + tonumber( rotation or 0 ) + 5000.1, material, -5, color or 0xFFFFFFFF, -8.927734375, -367.939453125,10000)
end

function leaveFarmMarker(thePlayer)
	if thePlayer == localPlayer then
		if source == hitMarker then
			hitMarker = nil
			unbindKey("e", "down", enterFarmInterior)
			unbindKey("k", "down", lockFarmInterior)
			for k, v in pairs(notificationData) do
				v.State = 'fixTile'
				v.Tick = getTickCount()
				v.State = 'closeTile'
			end
		end
	end
end
addEventHandler("onClientMarkerLeave", getRootElement(), leaveFarmMarker)

function isCursorInterSect3D(hitPosX, hitPosY, worldX, worldY, worldW, worldH)
	if (hitPosX >= worldX and hitPosX <= worldX + worldW and hitPosY >= worldY and hitPosY <= worldY + worldH) then
		return true
	end
	return false
end

addEvent("syncNewSurfaceToClient", true)
addEventHandler("syncNewSurfaceToClient", getRootElement(), function(selectedIndex, type, player, plantIndex, newLevel)
	--[[if fileExists("files/sounds/"..type..".mp3") then
		if isElement(soundEffects[player]) then
			stopSound(soundEffects[player])
		end
		local x,y,z = getElementPosition(player)
		local dimension = getElementDimension(player)
		soundEffects[player] = playSound3D("files/sounds/"..type..".mp3", x,y,z, false)
		setElementDimension(soundEffects[player], dimension)
	end]]
	if type == "haying" then
		blockTable[renderData.farmDimension][selectedIndex].hayLevel = newLevel
		blockTable[renderData.farmDimension][selectedIndex].state = "hay"
		setElementData(player, "isPlayerWorking", true)
		setPedAnimation(player, "bomber", "bom_plant_loop", -1, true, false, false)

		setTimer(function()
			setPedAnimation(player)
			setElementData(player, "isPlayerWorking", false)
			blockTable[renderData.farmDimension][selectedIndex].hayLevel = blockTable[renderData.farmDimension][selectedIndex].hayLevel
			triggerServerEvent("saveBlockTableActionServer", localPlayer, blockTable[renderData.farmDimension], renderData.farmDimension, selectedIndex, type)
		end, 2550, 1)

	elseif type == "cultivate" then
		blockTable[renderData.farmDimension][selectedIndex].newStateSaveLevel = blockTable[renderData.farmDimension][selectedIndex].newStateLevel
		blockTable[renderData.farmDimension][selectedIndex].changingTime = cultivateTime
		blockTable[renderData.farmDimension][selectedIndex].changingSlot = selctedIndex
		blockTable[renderData.farmDimension][selectedIndex].changingTick = getTickCount()
		blockTable[renderData.farmDimension][selectedIndex].newState = "land_cultivated"
		blockTable[renderData.farmDimension][selectedIndex].changingValue = math.floor(blockTable[renderData.farmDimension][selectedIndex].newStateLevel+changingProcess)
		blockTable[renderData.farmDimension][selectedIndex].changingState = true

		setPedAnimation(player, "baseball", "bat_4", -1, false, false, false)
		setElementData(player, "isPlayerWorking", true)


		setTimer(function()
			setPedAnimation(player)
			setElementData(player, "isPlayerWorking", false)

			blockTable[renderData.farmDimension][selectedIndex].hayLevel = blockTable[renderData.farmDimension][selectedIndex].hayLevel
		end, 500, 1)
	end
end)

function dxDrawButtonWithText(x,y,w,h,buttonColor, hoverColor, text, textColor, scale, font, alignX, alignY, button)
	if isMouseInPosition(x,y,w,h) then
		dxDrawRectangle(x,y,w,h, hoverColor)
		if button then
			activeDirectX = button
		end
	else
		dxDrawRectangle(x,y,w,h, buttonColor)
	end
	if alignX == "left" then
		x = x + 5
	end
	dxDrawText(text, x, y, x+w, y+h,textColor, scale, font, alignX, alignY, false,false,false,true)
end

addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "left" and state == "down" then
			if clickedElement then
				if getElementData(localPlayer, "isPlayerWorking") then
					return outputChatBox("mar dogozo")
				end

				--if getTickCount() - lastClickTick < 1000 then
				--	return 
				--end
				if activeButtonC == "newMemberButton" then
					if renderData.actualEditing == "" then
						renderData.invitingText = ""
						renderData.actualEditing = "newMemberName"
					end
				end
				if activeButtonC == "getAnimals" then
					renderAnimals = animalTable[renderData.farmDimension]
					iprint(renderAnimals)
					showCursor(true)
				end

				if activeButtonC == "pellet" then
					pelletShow = true
					set = {"Pellet táp", 0, {0, 8}, 2716}
				end

				if activeButtonC == "chickenfood" then
					pelletShow = true
					set = {"Csirke táp", 0, {0, 8}, 2716}
				end
				if activeButtonC == "closeOrder" then
					pelletShow = false
					closedOrdering = true
					orderState = true
					hayOrdering = false
					pelletShow = false
					orderPanel = false
				end
				if activeButtonC == "orderHay" then
					outputChatBox("Sikeresen rendeltél ".. math.floor(set[2]) .." db "..set[1].."-t!")
					triggerServerEvent("syncOrderToServer", localPlayer, {""..set[1].."", math.floor(set[2]), set[4]}, renderData.farmDimension)
					setElementData(localPlayer, "farmOrdered", {""..set[1].."", math.floor(set[2]), set[4], renderData.farmDimension})
					orderPanel = true
					hayOrdering = false
					pelletShow = false
				end
				if activeButtonC == "removeOrder" then
					outputChatBox("Sikeresen lemondtad a rendelést!")
					triggerServerEvent("syncOrderToServer", localPlayer, {}, renderData.farmDimension)
					setElementData(localPlayer, "farmOrdered", false)
					orderPanel = true
					hayOrdering = false
					pelletShow = false
				end
				if activeButtonC == "closeHay" then
					orderPanel = true
					hayOrdering = false
					pelletShow = false
				end
				if activeButtonC == "closeGetAnimals" then
					renderAnimals = false
					showCursor(false)
				end
				if activeButtonC == "orderMainGoat" then
					triggerServerEvent("syncAnimalToServer", localPlayer, animals[3], renderData.farmDimension)
				end
				if activeButtonC == "hay" then
					hayOrdering = true
					set = {"Szalma", 0, {0, 5}, 917}
				end

				if activeButtonC == "closePermission" then
					if renderData.permissionState and renderData.actualEditing == "" then
						renderData.permissionState = false
						triggerServerEvent("savePermissionTable", localPlayer, localPlayer, renderData.farmDimension, permissionTable)
					end
				end
				if activeButtonC == "perms" then
					if not renderData.permissionState and renderData.actualEditing == "" then
						renderData.permissionState = true
					end
				end
				if activeButtonC == "editFarmName" then
					if renderData.actualEditing ~= "farm:board" then
						renderData.invitingText = getElementData(farmMarker, "farm:name")
						renderData.actualEditing = "farm:board"
					else
						renderData.actualEditing = ""
						triggerServerEvent("changeFarmInteriorName", localPlayer, getElementData(farmMarker, "farm:markerID"), boardText)
					end
				end
				if activeButtonC == "order" then
					orderPanel = true
					orderState = false
					closedOrdering = false
				end
				if activeButtonC == "orderAnimals" then
					animalMainOrderPanel = true
					orderState = false
					orderPanel = false
				end
				if activeButtonC == "closeMainOrderPanel" then
					animalMainOrderPanel = false
					orderPanel = true
				end
				if activeButtonC == "closeOrderPanel" then
					orderPanel = false
					orderState = true
				end
				if activeButtonC == "closeOrderState" then
					orderState = false
					closedOrdering = true
					orderPanel = false
				end
				if activeButtonC == "manageAnimals" then
					orderState = true
				end
				if activeButtonC == "addMemberDone" then
					local targetPlayer, targetPlayerName = findPlayerByName(localPlayer, renderData.memberNameEdit)
					if targetPlayer then
						table.insert(permissionTable, {
							playerName = targetPlayerName,
							permissions = {
								toolState = false,
								milkAndEgg = false,
								lockState = false,
								feedingState = false,
								allowOrder = false,
								sellState = false,
							}
						})
					end
					renderData.actualEditing = ""
					renderData.memberNameEdit = ""
					triggerServerEvent("savePermissionTable", localPlayer, localPlayer, renderData.farmDimension, permissionTable)
				end
				if permissionKey and permissionKey > 0 and permissionSelected and permissionSelected ~= "" then
					permissionTable[permissionKey].permissions[permissionSelected] = not permissionTable[permissionKey].permissions[permissionSelected]
				end
				if getElementData(clickedElement, "farm:fork") then
					if hasPlayerPermission("toolState") then

						if not getElementData(localPlayer, "farm:fork")then
							clickedTool = clickedElement
							setElementData(localPlayer, "farm:fork", true)
						else
							clickedTool = clickedElement
							setElementData(localPlayer, "farm:fork", false)
						end
					end
				end
			end
		end
	end
)

function findPlayerByName(thePlayer, partialNick)
	if partialNick == "" then
		return false
	end

	local candidates = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	local partialNick = string.lower(partialNick)

	local players = getElementsByType("player")
	for playerKey, arrayPlayer in ipairs(players) do
		if isElement(arrayPlayer) then
			if arrayPlayer and getElementData(arrayPlayer, "loggedIn") then
				local playerName = string.lower(getElementData(arrayPlayer, "visibleName"))
				if(string.find(playerName, tostring(partialNick))) then
					local posStart, posEnd = string.find(playerName, tostring(partialNick))
					if posEnd - posStart > matchNickAccuracy then
						matchNickAccuracy = posEnd-posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						candidates = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						matchNick = nil
						matchPlayer = nil
						table.insert( candidates, arrayPlayer )
					end
				end
			end
		end
	end

	if not matchPlayer or not isElement(matchPlayer) then
		if isElement( thePlayer ) then
			if #candidates == 0 then
				outputChatBox("Nem található játékos", 255,255,255, true)
			else
				outputChatBox(""..#candidates.." Több ember található", 255,255,255, true)
				for _, arrayPlayer in ipairs( candidates ) do
					outputChatBox("  (" .. tostring( getElementData( arrayPlayer, "playerid" ) ) .. ") " .. getElementData(arrayPlayer, "visibleName"), 255, 255, 255)
				end
			end
		end
		return false
	else
		if matchPlayer == thePlayer then
			outputChatBox("Magadat nem adhatod hozzá!", 255,255,255, true)
			return false
		else
			return matchPlayer, getElementData(matchPlayer, "visibleName"):gsub("_", " ")
		end
	end
end


local maximumLetter = 22
addEventHandler('onClientCharacter', getRootElement(), function(character)
  if renderData.actualEditing == "farm:board" then
    maximumLetter = 22
	elseif renderData.actualEditing == "newMemberName" then
		maximumLetter = 27
	end
	if renderData.actualEditing ~= "" then
		if (utf8.len(renderData.invitingText) < maximumLetter) then
			renderData.invitingText = renderData.invitingText .. character
		end
	end
end)

addEventHandler("onClientKey", getRootElement(), function(button, state)
	if renderData.actualEditing ~= "" then
		if button == "backspace" and state then
			if utf8.len(renderData.invitingText) >= 1 then
				renderData.invitingText = utf8.sub(renderData.invitingText, 1, utf8.len(renderData.invitingText)-1)
			end
		end
	end
end)

function dxDrawTick(x,y,state,toolTipText)
	if state then
		if isMouseInPosition(x,y,25,25) then
			dxDrawImage(x,y,25,25,"files/images/tick.png",0,0,0,tocolor(104,170,249,255))
		else
			dxDrawImage(x,y,25,25,"files/images/tick.png",0,0,0,tocolor(104,170,249,180))
		end
	else
		if isMouseInPosition(x,y,25,25) then
			dxDrawImage(x,y,25,25,"files/images/minus.png",0,0,0,tocolor(217, 83, 79,255))
		else
			dxDrawImage(x,y,25,25,"files/images/minus.png",0,0,0,tocolor(217, 83, 79,180))
		end
	end

	if isCursorShowing() then
		local cursorX, cursorY = getCursorPosition()
		local relX, relY = cursorX * screenX, cursorY * screenY
		local textWidth = dxGetTextWidth(toolTipText, 1, RalewayB)
		if isMouseInPosition(x,y,25,25) then
			dxDrawRectangle(relX+5, relY+5, textWidth+10, 25, tocolor(0,0,0,255), true)
			dxDrawText(toolTipText,relX+10, relY+5, 0,relY+30,white,1,RalewayB, "left", "center",false,false,true)
		end
	end
end

function changeBoardTexture(dbID, newName, boardElement)
	boardShader[dbID] = dxCreateShader("files/texturechanger.fx")
	boardTarget[dbID] = dxCreateRenderTarget(256, 128)
	engineApplyShaderToWorldTexture(boardShader[dbID], "pole", v)
	dxSetRenderTarget(boardTarget[dbID], true)
		dxDrawImage(0,0,256,128,"files/images/board.png")
		dxDrawText(newName, 0,0,256,128, tocolor(0, 0, 0, 255), 1, RalewayBig, "center", "center")
	dxSetRenderTarget()
end
addEvent("changeBoardTexture", true)
addEventHandler("changeBoardTexture", getRootElement(), changeBoardTexture)

function createBoardTexture(dbID, newName)
	for k, v in pairs(getElementsByType("object")) do
		local boardID = getElementData(v, "farm:boardID")
		if boardID == dbID then
			local boardOwner = getElementData(v, "farm:boardOwner")
			boardShader[boardID] = dxCreateShader("files/texturechanger.fx")
			boardTarget[boardID] = dxCreateRenderTarget(256, 128)
			engineApplyShaderToWorldTexture(boardShader[boardID], "pole", v)
			dxSetRenderTarget(boardTarget[boardID], true)
				dxDrawImage(0,0,256,128,"files/images/board.png")
				dxDrawText(newName, 0,0,256,128, tocolor(0, 0, 0, 255), 1, RalewayBig, "center", "center")
			dxSetRenderTarget()
			dxSetShaderValue(boardShader[boardID], "gTexture", boardTarget[boardID])
		end
	end
end
addEvent("createBoardTexture", true)
addEventHandler("createBoardTexture", getRootElement(), createBoardTexture)

function loadClientFarmForPlayer()
	setTimer(function()
		for k, v in pairs(getElementsByType("marker")) do
			if getElementData(v, "farm:marker") and getElementData(v, "farm:markerID") > 0 then
				if getElementData(v, "farm:markerID") == getElementDimension(localPlayer) then
					local x,y,z = getElementPosition(localPlayer)
					local markX, markY, markZ = getElementPosition(v)

					if getDistanceBetweenPoints3D(x,y,z,markX,markY,markZ) <= 20 then
						farmMarker = v
					end
				end
			end
		end
	end, 1000, 1)
	for k, v in pairs(getElementsByType("object")) do
		local boardName = getElementData(v, "farm:boardName")
		if boardName then
			local boardID = getElementData(v, "farm:boardID")
			local boardOwner = getElementData(v, "farm:boardOwner")
			if isElement(boardTarget[boardID]) then
				dxSetRenderTarget(boardTarget[boardID], false)
				destroyElement(boardShader[boardID])
				destroyElement(boardTarget[boardID])
			end
			boardShader[boardID] = dxCreateShader("files/texturechanger.fx")
			boardTarget[boardID] = dxCreateRenderTarget(256, 128)
			engineApplyShaderToWorldTexture(boardShader[boardID], "pole", v)
			dxSetRenderTarget(boardTarget[boardID], true)
				dxDrawImage(0,0,256,128,"files/images/board.png")
				if boardOwner == 0 then
					dxDrawText("Kiadó!", 0,0,256,128, tocolor(0, 0, 0, 255), 1, RalewayBig, "center", "center")
				else
					dxDrawText(boardName, 0,0,256,128, tocolor(0, 0, 0, 255), 1, RalewayBig, "center", "center")
				end
			dxSetRenderTarget()
			dxSetShaderValue(boardShader[boardID], "gTexture", boardTarget[boardID])
		end
	end
end

function restore(didClearRenderTargets)
	loadClientFarmForPlayer()
end
addEventHandler("onClientRestore", root, restore)

function streamOut()
	if getElementType(source) == "object" then
		if getElementData(source, "farm:boardID") then
			local boardID = getElementData(source, "farm:boardID")
			print("asd")
			dxSetRenderTarget(boardTarget[boardID], false)
			destroyElement(boardShader[boardID])
			destroyElement(boardTarget[boardID])
		end
	end
end
addEventHandler("onClientElementStreamOut", root, streamOut)

function streamIn()
	if getElementType(source) == "object" then
		if getElementData(source, "farm:boardID") then
			local boardID = getElementData(source, "farm:boardID")
			boardTarget[boardID] = dxCreateRenderTarget(256, 128)
			boardShader[boardID] = dxCreateShader("files/texturechanger.fx")
			engineApplyShaderToWorldTexture(boardShader[boardID], "pole", v)
			local boardName = getElementData(source, "farm:boardName")
			local boardID = getElementData(source, "farm:boardID")
			local boardOwner = getElementData(source, "farm:boardOwner")
			dxSetRenderTarget(boardTarget[boardID], true)
		end
	end
end
addEventHandler("onClientElementStreamIn", root, streamIn)

function onLoggedIn(theKey, oldValue, newValue)
	if source == localPlayer then
		if theKey == "loggedIn" then
			loadClientFarmForPlayer()
		end
	end
end
addEventHandler("onClientElementDataChange", root, onLoggedIn)

function hasPlayerPermission(permissionIndex)
	if getElementData(localPlayer, "char.ID") == getElementData(farmMarker, "farm:owner") then
		return true
	end
	for k, v in pairs(permissionTable) do
		if tostring(getElementData(localPlayer, "char.Name"):gsub("_", " ")) == tostring(v.playerName) then
			if v.permissions[permissionIndex] then
				lastClickTick = getTickCount()
				return true
			else
				outputChatBox("Ehhez nincs jogosultságod!")
				return false
			end
		else
			return false
		end
	end
end

addEventHandler("onClientElementDataChange", getRootElement(), function(theKey, oldValue, newValue)
	if source == localPlayer then
		if theKey == "farm:fork" then
			triggerServerEvent("createFarmItemServer", localPlayer, localPlayer, "fork", newValue)
		end
	end
end)

function onquit()
	if isElement(createdFarmModels[source]) then
		destroyElement(createdFarmModels[source])
	end
end
addEventHandler("onClientPlayerQuit", root, onquit)


addEvent("createFarmItemClient", true)
addEventHandler("createFarmItemClient", getRootElement(), function(player, type, newValue)
	if isElement(createdFarmModels[player]) then
		destroyElement(createdFarmModels[player])
	end

	if newValue then
		if type == "fork" then
			createdFarmModels[player] = createObject(2717, 0, 0, 0)
			setElementDimension(createdFarmModels[player], renderData.farmDimension)
			exports.sm_boneattach:attachElementToBone(createdFarmModels[player], player, 12, -0.05, 0.03, 0.3, 0, -180, 0)
		end
	end
end)

addEvent("syncAnimalToClient", true)
function syncAnimalToClient(animal, dimid)
	table.insert(animalTable[dimid], animal)
	iprint(dimid)
	animalTable[dimid] = animalTable[dimid]
end
addEventHandler("syncAnimalToClient", root, syncAnimalToClient)

addEvent("syncOrderToClient", true)
function syncOrderToClient(order, dimid)
	iprint(order)
	orderTable[dimid] = order
end
addEventHandler("syncOrderToClient", root, syncOrderToClient)

addEvent("syncCargoToFarm", true)
function syncCargoToFarm(cargo)
	if cargo then
		cargoTable[renderData.farmDimension] = cargo
		for k, v in ipairs(cargo) do
			if v[1] == "Szalma" then
				for i = 1, tonumber(v[2]) do
					local obj = createObject(v[3], -24.412273406982, -352.80783081055, 5004.317773438 + i/2)
					setObjectScale(obj, 2.1)
					print("createdobject")
					setElementDimension(obj, renderData.farmDimension)
					setElementData(obj, "farm.cargo", true)
					setElementData(obj, "farm.cargoslot", v[2])
					setElementData(obj, "farm.cargotype", v[1])
				end
			elseif v[1] == "Pellet táp" then
				for i = 1, tonumber(v[2]) do
					local pelletobj = createObject(v[3], -21.532529830933, -352.97512817383, 5004.317773438 + i/4)
					print("createdobject")
					setElementDimension(pelletobj, renderData.farmDimension)
					setElementData(pelletobj, "farm.cargo", true)
					setElementData(pelletobj, "farm.cargoslot", v[2])
					setElementData(pelletobj, "farm.cargotype", v[1])
				end
			elseif v[1] == "Csirke táp" then
				for i = 1, tonumber(v[2]) do
					local chickenobj = createObject(v[3], -22.886692047119, -352.88027954102, 5004.317773438 + i/4)
					print("createdobject")
					setElementDimension(chickenobj, renderData.farmDimension)
					setElementData(chickenobj, "farm.cargo", true)
					setElementData(chickenobj, "farm.cargoslot", v[2])
					setElementData(chickenobj, "farm.cargotype", v[1])
				end
			end
		end
	end
end
addEventHandler("syncCargoToFarm", root, syncCargoToFarm)
