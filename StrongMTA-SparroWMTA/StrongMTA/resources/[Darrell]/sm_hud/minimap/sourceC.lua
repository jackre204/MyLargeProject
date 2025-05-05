pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local getZoneNameEx = getZoneName

function getZoneName(x, y, z, cities)
	local zone = getZoneNameEx(x, y, z, cities)

	if zone == "Greenglass College" then
		return "Las Venturas City Hall"
	end

	return zone
end

local screenSource = dxCreateScreenSource(screenX, screenY)

--local radarTexture = dxCreateTexture("minimap/radar.png", "dxt3")
--local radarTexture2 = dxCreateTexture("minimap/radar.png", "dxt3")

--dxSetTextureEdge(radarTexture, "border", tocolor(0, 0, 0, 0))
--dxSetTextureEdge(radarTexture2, "border", tocolor(0, 0, 0, 0))

local radarTextureSize = 4096
local mapScaleFactor = 6000 / radarTextureSize
local mapUnit = radarTextureSize / 6000

local minimapWidth = respc(320)
local minimapHeight = respc(225)
local minimapX = 0
local minimapY = 0

local rtsize = math.ceil((minimapWidth + minimapHeight) * 0.85)
local renderTarget = dxCreateRenderTarget(rtsize, rtsize)

local zoomval = 0.5
local zoom = zoomval
local targetZoom = zoom

local radarTexture = svgCreate(4096, 4096, "files/images/map.svg")
local radarTexture2 = svgCreate(4096, 4096, "files/images/map.svg")

dxSetTextureEdge(radarTexture, "border", tocolor(0, 0, 0, 0))
dxSetTextureEdge(radarTexture2, "border", tocolor(0, 0, 0, 0))

local defaultBlips = {
	{1128.7957763672, -1484.8616943359, 36.796875, "minimap/newblips/plaza.png"},
	{1022.6760864258, -1116.1193847656, 46.88011932373, "minimap/newblips/cblip.png"},
	{-786.12451171875, 1439.8848876953, 22.7890625, "minimap/newblips/change.png"},
	{-1460.7268066406, 1869.2399902344, 45.578125, "minimap/newblips/fuel.png"},
	{-1313.7156982422, 2694.8559570312, 55.578125, "minimap/newblips/fuel.png"},
	{658.42315673828, -566.48291015625, 23.578125, "minimap/newblips/fuel.png"},
	{1932.3742675781, -1775.5921630859, 34.578125, "minimap/newblips/fuel.png"},
	{1017.0587768555, -922.11193847656, 58.578125, "minimap/newblips/fuel.png"},
	{1478.2370605469, -1794.712890625, 40.578125, "minimap/newblips/vh.png"},
	{1004.7850341797, -1447.0267333984, 40.578125, "minimap/newblips/bank.png"}
}

local blipNames = {
	["minimap/newblips/versenypalya.png"] = "Versenypálya",
	["minimap/newblips/club.png"] = "Disco",
	["minimap/newblips/shop_h.png"] = "Munkahely",
	["minimap/newblips/carshop.png"] = "Autókereskedés",
	["minimap/newblips/bank.png"] = "Bank",
	["minimap/newblips/autosiskola.png"] = "Autósiskola",
	["minimap/newblips/tuning.png"] = "Tuning",
	["minimap/newblips/korhaz.png"] = "Kórház",
	["minimap/newblips/pd.png"] = "Rendőrség",
	["minimap/newblips/cb.png"] = "Cluckin' Bell",
	["minimap/newblips/vh.png"] = "Városháza",
	["minimap/newblips/szerelo.png"] = "Szerelőtelep",
	["minimap/newblips/banya.png"] = "Bánya",
	["minimap/newblips/gyar.png"] = "Gyár",
	["minimap/newblips/repter.png"] = "Reptér",
	["minimap/newblips/plaza.png"] = "Pláza",
	["minimap/newblips/fuel.png"] = "Benzinkút",
	["minimap/newblips/hatar.png"] = "Határátkelőhely",
	["minimap/newblips/templom.png"] = "Templom",
	["minimap/newblips/loter.png"] = "Lőtér",
	["minimap/newblips/hunting.png"] = "Vadászat",
	["minimap/newblips/favago.png"] = "Fatelep",
	["minimap/newblips/kikoto.png"] = "Kikötő",
	["minimap/newblips/kocsma.png"] = "Kocsma",
	["minimap/newblips/burger.png"] = "Burger Shot",
	["minimap/newblips/binco.png"] = "Ruhabolt",
	["minimap/newblips/fisherman.png"] = "Horgászbolt",
	["minimap/newblips/hunting2.png"] = "Vadász",
	["minimap/newblips/change.png"] = "Olajkút",
	["minimap/newblips/junkyard.png"] = "Roncstelep",
	["minimap/newblips/lottoblip.png"] = "Lottózó",
	["minimap/newblips/boat.png"] = "Hajóbolt",
	["minimap/newblips/cblip.png"] = "Kaszinó",
	["minimap/newblips/crab.png"] = "Rákászat",
	["minimap/newblips/carrent.png"] = "Autóbérlő",
	["minimap/newblips/szerelo_boat.png"] = "Szerelőtelep (hajó)",
	["minimap/newblips/szerelo_heli.png"] = "Szerelőtelep (helikopter)",
	["minimap/newblips/motel.png"] = "Motel",
	["minimap/newblips/sheriffblip.png"] = "Sheriff",
	["minimap/newblips/kosar.png"] = "Streetball pálya",
	["minimap/newblips/markblip.png"] = "Kijelölt pont (Kattints a törléshez)",
	["minimap/newblips/north.png"] = "Észak",
	["minimap/newblips/impound.png"] = "Lefoglalt járművek"
}

createdBlips = {}
local blipTooltipText = {}
local farBlips = {}
local jobBlips = {}

state3DBlip = true
stateMarksBlip = true

function delJobBlips()
	for k = 1, #jobBlips do
		local v = jobBlips[k]

		if v then
			createdBlips[v] = nil
		end
	end

	local temp = {}

	for k = 1, #createdBlips do
		local v = createdBlips[k]

		if v then
			table.insert(temp, v)
		end
	end

	createdBlips = temp
	jobBlips = {}
	temp = nil
end

function addJobBlips(data)
	for k = 1, #data do
		if data[k] then
			table.insert(createdBlips, {
				blipPosX = data[1],
				blipPosY = data[2],
				blipPosZ = data[3],
				blipId = data[4],
				farShow = data[6],
				renderDistance = 9999,
				iconSize = data[5] or 48,
				blipColor = data[7] or tocolor(255, 255, 255)
			})
			table.insert(jobBlips, #createdBlips)
		end
	end
end

carCanGPSVal = false
gpsHello = false

local gpsLines = {}
local gpsRenderTarget = false
local gpsBoundingBox = {}
local gpsColor = tocolor(220, 163, 30)

function carCanGPS()
	carCanGPSVal = false

	local currVehicle = getPedOccupiedVehicle(localPlayer)

	if currVehicle then
		local gpsVal = tonumber(getElementData(currVehicle, "vehicle.GPS"))

		if gpsVal == 1 then
			carCanGPSVal = ""
		elseif gpsVal == 2 then
			carCanGPSVal = "2"
		elseif gpsVal == 3 then
			carCanGPSVal = "off"
		else
			carCanGPSVal = false

			if getElementData(currVehicle, "gpsDestination") then
				setElementData(currVehicle, "gpsDestination", false)
			end
		end
	end

	return carCanGPSVal
end

function addGPSLine(x, y)
	table.insert(gpsLines, {remapTheFirstWay(x), remapTheFirstWay(y)})
end

function clearGPSRoute()
	gpsLines = {}
	gpsBoundingBox = false

	if isElement(gpsRenderTarget) then
		destroyElement(gpsRenderTarget)
	end

	gpsRenderTarget = nil
end

function processGPSLines()
	local minX, minY = 99999, 99999
	local maxX, maxY = -99999, -99999

	for i = 1, #gpsLines do
		local v = gpsLines[i]

		if v[1] < minX then
			minX = v[1]
		end

		if v[1] > maxX then
			maxX = v[1]
		end

		if v[2] < minY then
			minY = v[2]
		end

		if v[2] > maxY then
			maxY = v[2]
		end
	end

	local sx = maxX - minX + 16
	local sy = maxY - minY + 16

	if isElement(gpsRenderTarget) then
		destroyElement(gpsRenderTarget)
	end

	gpsRenderTarget = dxCreateRenderTarget(sx, sy, true)
	gpsBoundingBox = {minX - 8, minY - 8, sx, sy}

	dxSetRenderTarget(gpsRenderTarget)
	dxSetBlendMode("modulate_add")

	dxDrawImage(gpsLines[1][1] - minX + 4, gpsLines[1][2] - minY + 4, 8, 8, "minimap/gps/dot.png")
	dxDrawImage(gpsLines[#gpsLines][1] - minX, gpsLines[#gpsLines][2] - minY, 16, 16, "minimap/gps/dot.png")

	for i = 2, #gpsLines do
		local j = i - 1

		if gpsLines[j] then
			dxDrawImage(gpsLines[i][1] - minX + 4, gpsLines[i][2] - minY + 4, 8, 8, "minimap/gps/dot.png")
			dxDrawLine(gpsLines[i][1] - minX + 8, gpsLines[i][2] - minY + 8, gpsLines[j][1] - minX + 8, gpsLines[j][2] - minY + 8, tocolor(255, 255, 255), 9)
		end
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end

addEventHandler("onClientRestore", getRootElement(),
	function ()
		if gpsRoute then
			processGPSLines()
		end
	end)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for k, v in ipairs(getElementsByType("blip")) do
			blipTooltipText[v] = getElementData(v, "blipTooltipText")
		end

		for k, v in ipairs(defaultBlips) do
			v[5] = v[5] or 22
			v[6] = v[6] or false
			v[7] = v[7] or 9999
			v[8] = v[8] or tocolor(255, 255, 255)

			table.insert(createdBlips, {
				blipPosX = v[1],
				blipPosY = v[2],
				blipPosZ = v[3],
				blipId = v[4],
				iconSize = v[5],
				farShow = v[6],
				renderDistance = v[7],
				blipColor = v[8]
			})
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if getElementType(source) == "blip" then
			if dataName == "blipTooltipText" then
				blipTooltipText[source] = getElementData(source, "blipTooltipText")
			end
		end

		if source == getPedOccupiedVehicle(localPlayer) then
			if dataName == "vehicle.GPS" then
				carCanGPS()
			end

			if dataName == "gpsDestination" then
				local dataVal = getElementData(source, dataName)

				if dataVal then
					gpsThread = coroutine.create(makeRoute)
					gpsColor = dataVal[3] or tocolor(220, 163, 30)

					coroutine.resume(gpsThread, unpack(dataVal))

					waypointInterpolation = false
				else
					endRoute()
				end
			end
		end
	end)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if getElementType(source) == "blip" then
			blipTooltipText[source] = nil
		end
	end)

local damageStart = false

addEventHandler("onClientPlayerDamage", localPlayer,
	function ()
		damageStart = getTickCount()
	end)

function renderBlip(icon, x1, y1, x2, y2, sx, sy, color, farshow, cameraRot, blipNum)
	if icon == "minimap/newblips/markblip.png" and not stateMarksBlip then
		return
	end

	local x = 0 + rtsize / 2 + (remapTheFirstWay(x2) - remapTheFirstWay(x1)) * zoom
	local y = 0 + rtsize / 2 - (remapTheFirstWay(y2) - remapTheFirstWay(y1)) * zoom

	if not farshow and (x > rtsize or x < 0 or y > rtsize or y < 0) then
		return
	end

	local rendering = true

	if farshow then
		if icon == 0 then
			sx = sx / 1.5
			sy = sy / 1.5
		end

		if x > rtsize then
			x = rtsize
		elseif x < 0 then
			x = 0
		end

		if y > rtsize then
			y = rtsize
		elseif y < 0 then
			y = 0
		end

		local middleSize = rtsize / 2
		local angle = math.rad(cameraRot)
		local x2 = middleSize + (x - middleSize) * math.cos(angle) - (y - middleSize) * math.sin(angle)
		local y2 = middleSize + (x - middleSize) * math.sin(angle) + (y - middleSize) * math.cos(angle)

		x2 = x2 + minimapX - rtsize / 2 + (minimapWidth - sx) / 2
		y2 = y2 + minimapY - rtsize / 2 + (minimapHeight - sy) / 2

		farBlips[blipNum] = nil

		if x2 < minimapX then
			rendering = false
			x2 = minimapX
		elseif x2 > minimapX + minimapWidth - sx then
			rendering = false
			x2 = minimapX + minimapWidth - sx
		end

		if y2 < minimapY then
			rendering = false
			y2 = minimapY
		elseif y2 > minimapY + minimapHeight - resp(30) - sy then
			rendering = false
			y2 = minimapY + minimapHeight - resp(30) - sy
		end

		if not rendering then
			farBlips[blipNum] = {x2, y2, sx, sy, icon, color}
		end
	end

	if rendering then
		dxDrawImage(x - sx / 2, y - sy / 2, sx, sy, icon, 360 - cameraRot, 0, 0, color)
	end
end

function remapTheFirstWay(x)
	return (-x + 3000) / mapScaleFactor
end

function remapTheSecondWay(x)
	return (x + 3000) / mapScaleFactor
end

local lostSignalStart = false
local lostSignalDirection = false

render.minimap = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["minimap"] and smoothMove then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["minimap"] and  smoothMove < resp(224) then
		return
	end
	minimapWidth, minimapHeight = tonumber(renderData.size.minimapX), tonumber(renderData.size.minimapY)

	local newRTsize = math.ceil((minimapWidth + minimapHeight) * 0.85)

	if math.abs(newRTsize - rtsize) > 10 then
		rtsize = newRTsize

		if isElement(renderTarget) then
			destroyElement(renderTarget)
		end

		renderTarget = dxCreateRenderTarget(rtsize, rtsize)
	end

	minimapX, minimapY = tonumber(x), tonumber(y)

	-- ** Zoom
	if getKeyState("num_add") and zoomval < 1.2 then
		zoomval = zoomval + 0.01
	elseif getKeyState("num_sub") and zoomval > 0.31 then
		zoomval = zoomval - 0.01
	end

	zoom = zoomval

	local pedveh = getPedOccupiedVehicle(localPlayer)

	if isElement(pedveh) then
		local velx, vely, velz = getElementVelocity(pedveh)
		local actualspeed = math.sqrt(velx * velx + vely * vely + velz * velz) * 180 / 1300

		if actualspeed >= 0.4 then
			actualspeed = 0.4
		end

		zoom = zoom - actualspeed
	end

	-- ** Map
	local px, py, pz = getElementPosition(localPlayer)
	local _, _, prz = getElementRotation(localPlayer)
	local dim = getElementDimension(localPlayer)

	if dim == 0 or dim == 987 then
		local crx, cry, crz = getElementRotation(getCamera())

		farBlips = {}

		dxUpdateScreenSource(screenSource, true)

		dxSetRenderTarget(renderTarget)
		dxSetBlendMode("modulate_add")

		dxDrawRectangle(0, 0, rtsize, rtsize, tocolor(110, 158, 204))
		dxDrawImageSection(0, 0, rtsize, rtsize, remapTheSecondWay(px) - rtsize / zoom / 2, remapTheFirstWay(py) - rtsize / zoom / 2, rtsize / zoom, rtsize / zoom, radarTexture)

		-- ** GPS Útvonal
		if gpsRenderTarget then
			dxDrawImage(
				rtsize / 2 + (remapTheFirstWay(px) - (gpsBoundingBox[1] + gpsBoundingBox[3] / 2)) * zoom - gpsBoundingBox[3] * zoom / 2,
				rtsize / 2 - (remapTheFirstWay(py) - (gpsBoundingBox[2] + gpsBoundingBox[4] / 2)) * zoom + gpsBoundingBox[4] * zoom / 2,
				gpsBoundingBox[3] * zoom,
				-(gpsBoundingBox[4] * zoom),
				gpsRenderTarget,
				180, 0, 0,
				gpsColor
			)
		end

		-- ** Blipek
		local blipCount = 0

		for k = 1, #createdBlips do
			local v = createdBlips[k]

			if v then
				blipCount = blipCount + 1

				renderBlip(v.blipId, v.blipPosX, v.blipPosY, px, py, v.iconSize, v.iconSize, v.blipColor, v.farShow, crz, blipCount)
			end
		end

		local blips = getElementsByType("blip")

		for k = 1, #blips do
			local v = blips[k]

			if v then
				local bx, by = getElementPosition(v)
				local color = tocolor(getBlipColor(v))

				blipCount = blipCount + 1

				if getBlipIcon(v) == 1 then
					renderBlip("minimap/newblips/munkajarmu.png", bx, by, px, py, 18, 15, tocolor(255, 255, 255), true, crz, blipCount)
				elseif getBlipIcon(v) == 2 then
					renderBlip("minimap/newblips/shop_h.png", bx, by, px, py, 14.5, 14.5, tocolor(255, 255, 255), true, crz, blipCount)
				else
					renderBlip("minimap/newblips/target.png", bx, by, px, py, 14.5, 14.5, color, true, crz, blipCount)
				end
			end
		end

		dxSetBlendMode("blend")
		dxSetRenderTarget()

		-- ** Térkép
		dxDrawImage(x - rtsize / 2 + minimapWidth / 2, y - rtsize / 2 + minimapHeight / 2, rtsize, rtsize, renderTarget, crz)
		dxDrawImage(x, y, minimapWidth, minimapHeight, "files/images/vin.png")

		-- ** Távoli blipek
		for k, v in pairs(farBlips) do
			dxDrawImage(v[1], v[2], v[3], v[4], v[5], 0, 0, 0, v[6])
		end

		-- ** Pozíciónk
		local arrowsize = 60 / (4 - zoom) + 3
		dxDrawImage(x + (minimapWidth - arrowsize) / 2, y + (minimapHeight - arrowsize) / 2, arrowsize, arrowsize, "minimap/files/arrow.png", crz + math.abs(360 - prz))

		-- ** Rendertarget kitakarása a képernyőforrással
		local margin = respc(rtsize * 0.75)
		dxDrawImageSection(x - margin, y - margin, minimapWidth + margin * 2, margin, x - margin, y - margin, minimapWidth + margin * 2, margin, screenSource) -- felsó
		dxDrawImageSection(x - margin, y + minimapHeight, minimapWidth + margin * 2, margin, x - margin, y + minimapHeight, minimapWidth + margin * 2, margin, screenSource) -- alsó
		dxDrawImageSection(x - margin, y, margin, minimapHeight, x - margin, y, margin, minimapHeight, screenSource) -- bal
		dxDrawImageSection(x + minimapWidth, y, margin, minimapHeight, x + minimapWidth, y, margin, minimapHeight, screenSource) -- jobb

		-- ** Keret
		dxDrawRectangle(x - 2, y - 2, minimapWidth + 4, 2, tocolor(33, 33, 33, 200)) -- felső
		dxDrawRectangle(x - 2, y + minimapHeight, minimapWidth + 4, 2, tocolor(33, 33, 33, 200)) -- alsó
		dxDrawRectangle(x - 2, y, 2, minimapHeight, tocolor(33, 33, 33, 200)) -- bal
		dxDrawRectangle(x + minimapWidth, y, 2, minimapHeight, tocolor(33, 33, 33, 200)) -- jobb

		-- ** GPS Location
		dxDrawRectangle(x, y + minimapHeight - resp(30), minimapWidth, resp(30), tocolor(22, 22, 22, 200))
		dxDrawText(getZoneName(px, py, pz), x, y + minimapHeight - resp(30), x + minimapWidth - resp(10), y + minimapHeight, tocolor(200, 200, 200, 200), 0.5, Raleway, "center", "center",false,false,false,true)

		-- ** GPS Navigáció
		if gpsRoute or waypointEndInterpolation then
			local offsetY = (minimapHeight - respc(30)) / 2
			local iconX = x + minimapWidth - respc(50)
			local iconY = y + offsetY

			if waypointEndInterpolation then
				local progress = (getTickCount() - waypointEndInterpolation) / 500
				local alpha = interpolateBetween(
					1, 0, 0,
					0, 0, 0,
					progress, "Linear"
				)

				dxDrawRectangle(x + minimapWidth - respc(60), y, respc(60), minimapHeight - respc(30), tocolor(0, 0, 0, 150 * alpha))
				dxDrawImage(iconX, iconY - respc(20), respc(40), respc(40), "minimap/gps/end.png", 0, 0, 0, tocolor(124, 197, 118, 255 * alpha))
				dxDrawText("0 m", iconX, iconY + respc(20), x + minimapWidth - respc(10), iconY + respc(36), tocolor(124, 197, 118, 255 * alpha), 0.9, Roboto, "center", "center")

				if progress > 1 then
					waypointEndInterpolation = false
				end
			elseif nextWp then
				dxDrawRectangle(x + minimapWidth - respc(60), y, respc(60), minimapHeight - respc(30), tocolor(0, 0, 0, 150))

				if currentWaypoint ~= nextWp and not tonumber(reRouting) then
					if nextWp > 1 then
						waypointInterpolation = {getTickCount(), currentWaypoint}
					end

					currentWaypoint = nextWp
				end

				if tonumber(reRouting) then
					local progress = (getTickCount() - reRouting) / 1250
					local rot, count = interpolateBetween(
						360, 0, 0,
						0, 3, 0,
						progress, "Linear"
					)

					currentWaypoint = nextWp
					dxDrawImage(iconX, iconY - respc(20), respc(40), respc(40), "minimap/gps/refresh.png", rot, 0, 0, tocolor(124, 197, 118))

					if count > 2 then
						dxDrawText("•••", iconX, iconY + respc(20), x + minimapWidth - respc(10), iconY + respc(36), tocolor(124, 197, 118), 0.9, Roboto, "center", "center")
					elseif count > 1 then
						dxDrawText("••", iconX, iconY + respc(20), x + minimapWidth - respc(10), iconY + respc(36), tocolor(124, 197, 118), 0.9, Roboto, "center", "center")
					elseif count > 0 then
						dxDrawText("•", iconX, iconY + respc(20), x + minimapWidth - respc(10), iconY + respc(36), tocolor(124, 197, 118), 0.9, Roboto, "center", "center")
					end

					if progress > 1 then
						reRouting = getTickCount()
					end
				elseif turnAround then
					currentWaypoint = nextWp
					dxDrawImage(iconX, iconY - respc(20) - respc(8), respc(40), respc(40), "minimap/gps/around.png", 0, 0, 0, tocolor(124, 197, 118))
					dxDrawText("Fordulj\nvissza!", iconX, iconY + respc(20) + respc(8), x + minimapWidth - respc(10), iconY + respc(36) + respc(8), tocolor(124, 197, 118), 0.9, Roboto, "center", "center")
				elseif not waypointInterpolation then
					local distance = 0

					if gpsWaypoints[nextWp] then
						distance = math.floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10
					end

					dxDrawImage(iconX, iconY - respc(20), respc(40), respc(40), "minimap/gps/" .. gpsWaypoints[nextWp][2] .. ".png", 0, 0, 0, tocolor(124, 197, 118))

					if gpsWaypoints[nextWp + 1] then
						dxDrawImage(iconX, iconY + respc(44), respc(40), respc(40), "minimap/gps/" .. gpsWaypoints[nextWp + 1][2] .. ".png", 0, 0, 0, tocolor(220, 163, 30))
					end

					dxDrawText(distance .. " m", iconX, iconY + respc(20), x + minimapWidth - respc(10), iconY + respc(36), tocolor(124, 197, 118), 0.9, Roboto, "center", "center")
				else
					local waypointId = waypointInterpolation[2]
					local currDist = 0
					local nextDist = 0

					if gpsWaypoints[waypointId] then
						currDist = math.floor((gpsWaypoints[waypointId][3] or 0) / 10) * 10
					end

					if gpsWaypoints[waypointId+1] then
						nextDist = math.floor((gpsWaypoints[waypointId+1][3] or 0) / 10) * 10
					end

					local elapsedTime = getTickCount() - waypointInterpolation[1]
					local progress = elapsedTime / 750

					if progress > 1 then
						progress = 1
					end

					local alpha, currentY, nextY = interpolateBetween(
						255, offsetY - respc(20), offsetY + respc(44),
						0, 0, offsetY - respc(20),
						progress, "Linear"
					)

					dxDrawImage(iconX, y + currentY, respc(40), respc(40), "minimap/gps/" .. gpsWaypoints[waypointId][2] .. ".png", 0, 0, 0, tocolor(124, 197, 118, alpha))
					dxDrawText(currDist .. " m", iconX, y + currentY + respc(40), x + minimapWidth - respc(10), y + currentY + respc(40) + respc(16), tocolor(124, 197, 118, alpha), 0.9, Roboto, "center", "center")

					if gpsWaypoints[waypointId+1] then
						local r, g, b = interpolateBetween(
							220, 163, 30,
							124, 197, 118,
							progress, "Linear"
						)

						dxDrawImage(iconX, y + nextY, respc(40), respc(40), "minimap/gps/" .. gpsWaypoints[waypointId+1][2] .. ".png", 0, 0, 0, tocolor(r, g, b))
						dxDrawText(nextDist .. " m", iconX, y + nextY + respc(40), x + minimapWidth - respc(10), y + nextY + respc(40) + respc(16), tocolor(r, g, b, 255 - alpha), 0.9, Roboto, "center", "center")
					end

					if progress >= 1 then
						local progress = (elapsedTime - 750) / 500

						if gpsWaypoints[waypointId+2] then
							if progress > 1 then
								progress = 1
							end

							dxDrawImage(iconX, iconY + respc(44), respc(40), respc(40), "minimap/gps/" .. gpsWaypoints[waypointId+2][2] .. ".png", 0, 0, 0, tocolor(220, 163, 30, 255 * progress))
						end

						if progress >= 1 then
							waypointInterpolation = false
						end
					end
				end
			end
		end
	end
end

local bigRadarState = false

local bigmapWidth = screenX
local bigmapHeight = screenY
local bigmapX = 0
local bigmapY = 0

local zoom = 0.5

local cursorX, cursorY = -1, -1
local lastCursorPos = false
local cursorMoveDiff = false

local mapMoveDiff = false
local lastMapMovePos = false
local mapIsMoving = false

local lastMapPosX, lastMapPosY = 0, 0
local mapMovedX, mapMovedY = 0, 0

local hoverBlip = false
local hoverMarkBlip = false
local hoverMarksButton = false
local hoverMarksRemove = false
local hover3DBlip = false

function render3DBlips()
	if getElementDimension(localPlayer) == 0 then
		local px, py, pz = getElementPosition(localPlayer)

		if pz < 10000 then
			local blips = getElementsByType("blip")

			for i = 1, #blips do
				local v = blips[i]

				if v then
					if getElementAttachedTo(v) ~= localPlayer then
						local bx, by, bz = getElementPosition(v)
						local sx, sy = getScreenFromWorldPosition(bx, by, bz)

						if sx and sy then
							local dist = getDistanceBetweenPoints3D(px, py, pz, bx, by, bz)
							local tooltip = ""

							if blipTooltipText[v] then
								tooltip = blipTooltipText[v]
							end

							dxDrawText(math.floor(dist) .. " m\n" .. tooltip, sx + 1, sy + 1 + 7.5 + respc(4), sx, 0, tocolor(0, 0, 0, 255), 0.75, Roboto, "center", "top")
							dxDrawText(math.floor(dist) .. " m#e0e0e0\n" .. tooltip, sx, sy + 7.5 + respc(4), sx, 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top", false, false, false, true)

							local icon = "target"
							local color = tocolor(getBlipColor(v))

							if getBlipIcon(v) == 1 then
								icon = "munkajarmu"
								color = tocolor(255, 255, 255)
							elseif getBlipIcon(v) == 2 then
								icon = "shop_h"
								color = tocolor(255, 255, 255)
							end

							dxDrawImage(sx - 9, sy - 7.5, 18, 15, "minimap/newblips/" .. icon .. ".png", 0, 0, 0, color)
						end
					end
				end
			end

			for i = 1, #createdBlips do
				local v = createdBlips[i]

				if v then
					if v.blipId == "minimap/newblips/markblip.png" and stateMarksBlip then
						local z = getGroundPosition(v.blipPosX, v.blipPosY, 400) + 3
						local sx, sy = getScreenFromWorldPosition(v.blipPosX, v.blipPosY, z)

						if sx and sy then
							local dist = getDistanceBetweenPoints3D(px, py, pz, v.blipPosX, v.blipPosY, z)
							local size = v.iconSize / 2

							dxDrawText(math.floor(dist) .. " m\nKijelölt pont", sx + 1, sy + 1 + size + respc(4), sx, 0, tocolor(0, 0, 0, 255), 0.75, Roboto, "center", "top")
							dxDrawText(math.floor(dist) .. " m#e0e0e0\nKijelölt pont", sx, sy + size + respc(4), sx, 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top", false, false, false, true)

							dxDrawImage(sx - size, sy - size, v.iconSize, v.iconSize, "minimap/newblips/markblip2.png", 0, 0, 0, tocolor(255, 255, 255, 200))
						end
					end

					if string.find(v.blipId, "jobblips") then
						local z = getGroundPosition(v.blipPosX, v.blipPosY, 400) + 3
						local sx, sy = getScreenFromWorldPosition(v.blipPosX, v.blipPosY, z)

						if sx and sy then
							local dist = getDistanceBetweenPoints3D(px, py, pz, v.blipPosX, v.blipPosY, z)
							local size = v.iconSize / 2

							dxDrawText(math.floor(dist) .. " m", sx + 1, sy + 1 + size + respc(4), sx, 0, tocolor(0, 0, 0, 255), 0.75, Roboto, "center", "top")
							dxDrawText(math.floor(dist) .. " m", sx, sy + size + respc(4), sx, 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top")

							dxDrawImage(sx - size, sy - size, v.iconSize, v.iconSize, v.blipId, 0, 0, 0, tocolor(255, 255, 255, 200))
						end
					end
				end
			end
		end
	end
end

function renderBigBlip(icon, x1, y1, x2, y2, sx, sy, color, maxdist, tooltip, id, element)
	if icon == "minimap/newblips/markblip.png" and not stateMarksBlip then
		return
	end

	if maxdist and getDistanceBetweenPoints2D(x2, y2, x1, y1) > maxdist then
		return
	end

	local x = bigmapX + bigmapWidth / 2 + (remapTheFirstWay(x2) - remapTheFirstWay(x1)) * zoom
	local y = bigmapY + bigmapHeight / 2 - (remapTheFirstWay(y2) - remapTheFirstWay(y1)) * zoom

	sx = (sx / (4 - zoom) + 3) * 2.25
	sy = (sy / (4 - zoom) + 3) * 2.25

	if x < bigmapX + sx / 2 then
		x = bigmapX + sx / 2
	elseif x > bigmapX + bigmapWidth - sx / 2 then
		x = bigmapX + bigmapWidth - sx / 2
	end

	if y < bigmapY + sy / 2 then
		y = bigmapY + sy / 2
	elseif y > bigmapY + bigmapHeight - respc(30) - sy / 2 then
		y = bigmapY + bigmapHeight - respc(30) - sy / 2
	end

	if cursorX and cursorY then
		if not hoverBlip then
			if cursorX >= x - sx / 2 and cursorY >= y - sy / 2 and cursorX <= x + sx / 2 and cursorY <= y + sy / 2 then
				hoverYardText = getDistanceBetweenPoints2D(x1, y1, getElementPosition(localPlayer))

				if isElement(element) and getElementType(element) == "player" then
					hoverBlip = element
					--hoverBlipDatas = element
				elseif tooltip then
					hoverBlip = tooltip
					--hoverBlipDatas = hoverBlip
				elseif blipNames[icon] then
					hoverBlip = blipNames[icon]
					--hoverBlipDatas = maxdist
					--print(maxdist)
				end

				if icon == "minimap/newblips/markblip.png" then
					hoverMarkBlip = id
					--hoverBlipDatas = id
				end

			end
		end
	end

	if icon == "minimap/files/arrow.png" then
		local _, _, prz = getElementRotation(localPlayer)

		dxDrawImage(x - sx / 2, y - sy / 2, sx, sy, icon, math.abs(360 - prz))
	else
		dxDrawImage(x - sx / 2, y - sy / 2, sx, sy, icon, 0, 0, 0, color)
	end
end

function renderTheBigmap()
	buttonsC = {}

	local px, py, pz = getElementPosition(localPlayer)
	local _, _, prz = getElementRotation(localPlayer)
	local dim = getElementDimension(localPlayer)

	hover3DBlip = false
	hoverMarkBlip = false
	hoverMarksButton = false
	hoverMarksRemove = false

	if dim == 0 or dim == 987 then
		-- ** Térkép mozgatása
		cursorX, cursorY = getCursorPosition()

		if cursorX and cursorY then
			cursorX, cursorY = cursorX * screenX, cursorY * screenY

			if getKeyState("mouse1") then
				if not lastCursorPos then
					lastCursorPos = {cursorX, cursorY}
				end

				if not cursorMoveDiff then
					cursorMoveDiff = {0, 0}
				end

				cursorMoveDiff = {
					cursorMoveDiff[1] + cursorX - lastCursorPos[1],
					cursorMoveDiff[2] + cursorY - lastCursorPos[2]
				}

				if not lastMapMovePos then
					if not mapMoveDiff then
						lastMapMovePos = {0, 0}
					else
						lastMapMovePos = {mapMoveDiff[1], mapMoveDiff[2]}
					end
				end

				if not mapMoveDiff then
					if math.abs(cursorMoveDiff[1]) >= 3 or math.abs(cursorMoveDiff[2]) >= 3 then
						mapMoveDiff = {
							lastMapMovePos[1] - cursorMoveDiff[1] / zoom / mapUnit,
							lastMapMovePos[2] + cursorMoveDiff[2] / zoom / mapUnit
						}
						mapIsMoving = true
					end
				elseif cursorMoveDiff[1] ~= 0 or cursorMoveDiff[2] ~= 0 then
					mapMoveDiff = {
						lastMapMovePos[1] - cursorMoveDiff[1] / zoom / mapUnit,
						lastMapMovePos[2] + cursorMoveDiff[2] / zoom / mapUnit
					}
					mapIsMoving = true
				end

				lastCursorPos = {cursorX, cursorY}
			else
				if mapMoveDiff then
					lastMapMovePos = {mapMoveDiff[1], mapMoveDiff[2]}
				end

				lastCursorPos = false
				cursorMoveDiff = false
			end
		end

		mapMovedX, mapMovedY = lastMapPosX, lastMapPosY

		if mapMoveDiff then
			mapMovedX = mapMovedX + mapMoveDiff[1]
			mapMovedY = mapMovedY + mapMoveDiff[2]
		else
			mapMovedX, mapMovedY = px, py
			lastMapPosX, lastMapPosY = mapMovedX, mapMovedY
		end
		local mapPlayerPosX = remapTheSecondWay(mapMovedX) - bigmapWidth / zoom / 2
		local mapPlayerPosY = remapTheFirstWay(mapMovedY) - bigmapHeight / zoom / 2

		

		dxDrawRectangle(bigmapX, bigmapY, bigmapWidth, bigmapHeight, tocolor(61, 122, 188, 150))
		dxDrawImage(bigmapX, bigmapY, bigmapWidth, bigmapHeight, "minimap/files/vin2.png")
		dxDrawImageSection(bigmapX, bigmapY, bigmapWidth, bigmapHeight, mapPlayerPosX, mapPlayerPosY, bigmapWidth / zoom, bigmapHeight / zoom, radarTexture2, 0, 0, 0, tocolor(255, 255, 255))

		dxDrawRectangle(bigmapX, bigmapY, bigmapWidth, respc(50), tocolor(25, 25, 25, 230))
		-- ** GPS Útvonal
		if gpsRenderTarget then
			dxUpdateScreenSource(screenSource, true)

			dxDrawImage(
				bigmapX + bigmapWidth / 2 + (remapTheFirstWay(mapMovedX) - (gpsBoundingBox[1] + gpsBoundingBox[3] / 2)) * zoom - gpsBoundingBox[3] * zoom / 2,
				bigmapY + bigmapHeight / 2 - (remapTheFirstWay(mapMovedY) - (gpsBoundingBox[2] + gpsBoundingBox[4] / 2)) * zoom + gpsBoundingBox[4] * zoom / 2,
				gpsBoundingBox[3] * zoom,
				-(gpsBoundingBox[4] * zoom),
				gpsRenderTarget,
				180, 0, 0,
				gpsColor
			)

			dxDrawImageSection(0, 0, bigmapX, screenY, 0, 0, bigmapX, screenY, screenSource)
			dxDrawImageSection(screenX - bigmapX, 0, bigmapX, screenY, screenX - bigmapX, 0, bigmapX, screenY, screenSource)
			dxDrawImageSection(bigmapX, 0, screenX - 2 * bigmapX, bigmapY, bigmapX, 0, screenX - 2 * bigmapX, bigmapY, screenSource)
			dxDrawImageSection(bigmapX, screenY - bigmapY, screenX - 2 * bigmapX, bigmapY, bigmapX, screenY - bigmapY, screenX - 2 * bigmapX, bigmapY, screenSource)
		end

		-- ** Blipek
		local blipCount = 0

		for k = 1, #createdBlips do
			local v = createdBlips[k]

			if v then
				blipCount = blipCount + 1

				renderBigBlip(v.blipId, v.blipPosX, v.blipPosY, mapMovedX, mapMovedY, v.iconSize, v.iconSize, v.blipColor, v.renderDistance or 9999, v.tooltip, blipCount)
			end
		end

		local blips = getElementsByType("blip")

		for k = 1, #blips do
			local v = blips[k]

			if v then
				local bx, by = getElementPosition(v)
				local renderDistance = getBlipVisibleDistance(v)
				local color = tocolor(getBlipColor(v))

				blipCount = blipCount + 1

				if getBlipIcon(v) == 1 then
					renderBigBlip("minimap/newblips/munkajarmu.png", bx, by, mapMovedX, mapMovedY, 18, 15, tocolor(255, 255, 255), renderDistance, blipTooltipText[v], blipCount, v)
				elseif getBlipIcon(v) == 2 then
					renderBigBlip("minimap/newblips/shop_h.png", bx, by, mapMovedX, mapMovedY, 14.5, 14.5, tocolor(255, 255, 255), renderDistance, blipTooltipText[v], blipCount, v)
				else
					renderBigBlip("minimap/newblips/target.png", bx, by, mapMovedX, mapMovedY, 14.5, 14.5, color, renderDistance, blipTooltipText[v], blipCount, v)
				end
			end
		end

		-- ** Pozíciónk
		dxDrawImage(bigmapX, bigmapY, bigmapWidth, bigmapHeight, "files/images/vin.png")

		renderBigBlip("minimap/files/arrow.png", px, py, mapMovedX, mapMovedY, 20, 20)

		if mapMoveDiff then
			renderBigBlip("minimap/newblips/cross.png", mapMovedX, mapMovedY, mapMovedX, mapMovedY, 128, 128)
		end

		--dxDrawRectangle(bigmapX, bigmapY + bigmapHeight - respc(30), bigmapWidth, respc(30), tocolor(0, 0, 0, 200))

		if tonumber(cursorX) then
			local zx = reMap((cursorX - bigmapX) / zoom + mapPlayerPosX, 0, radarTextureSize, -3000, 3000)
			local zy = reMap((cursorY - bigmapY) / zoom + mapPlayerPosY, 0, radarTextureSize, 3000, -3000)


			dxDrawText(getZoneName(zx, zy, 0), bigmapX + bigmapWidth / 2, respc(50) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center")
			
			if hoverBlip then -- kijelölt blip
				local tooltipWidth = dxGetTextWidth(hoverBlip, 0.75, Roboto) + respc(10)
				dxDrawRectangle(cursorX + respc(12.5), cursorY, tooltipWidth, respc(35), tocolor(25, 25, 25, 190))
				if hoverYardText then
					dxDrawText(hoverBlip .." \n ".. math.floor(hoverYardText) .. " m", cursorX + respc(12.5), cursorY, cursorX + tooltipWidth + respc(12.5), cursorY + respc(35), tocolor(200, 200, 200, 200), 0.75, Roboto, "center", "center")
				end
			end
		else

			dxDrawText(getZoneName(px, py, pz), bigmapX + bigmapWidth / 2, respc(50) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center")
		end

		if hoverBlip then
			hoverBlip = false
		end

		-- ** GPS be -és kikapcs
		if isPedInVehicle(localPlayer) and carCanGPSVal then
			dxDrawImage(bigmapX + bigmapWidth - respc(144), bigmapY + bigmapHeight - respc(174), respc(128), respc(128), "minimap/gps/sgo.png", 0, 0, 0, tocolor(255, 255, 255, 200))

			if carCanGPSVal == "" then
				dxDrawText("Női hang", bigmapX + bigmapWidth - respc(85), bigmapY + bigmapHeight - respc(46), bigmapX + bigmapWidth - respc(144) + respc(128), 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top")
			elseif carCanGPSVal == "2" then
				dxDrawText("Férfi hang", bigmapX + bigmapWidth - respc(85), bigmapY + bigmapHeight - respc(46), bigmapX + bigmapWidth - respc(144) + respc(128), 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top")
			else
				dxDrawText("Nincs hang", bigmapX + bigmapWidth - respc(85), bigmapY + bigmapHeight - respc(46), bigmapX + bigmapWidth - respc(144) + respc(128), 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top")
			end
		end

		if state3DBlip then
			drawButton("state3DBlip", "3D blipek kikapcsolása", screenX - respc(205), screenY - respc(50), respc(200), respc(30), {188, 64, 61}, false, Roboto, true)
		else
			drawButton("state3DBlip", "3D blipek bekapcsolása", screenX - respc(205), screenY - respc(50), respc(200), respc(30), {61, 122, 188}, false, Roboto, true)
		end

		if stateMarksBlip then
			drawButton("stateMarksBlip", "Jelölések kikapcsolása", screenX - respc(205), screenY - respc(50) - respc(35), respc(200), respc(30), {188, 64, 61}, false, Roboto, true)
		else
			drawButton("stateMarksBlip", "Jelölések bekapcsolása", screenX - respc(205), screenY - respc(50) - respc(35), respc(200), respc(30), {61, 122, 188}, false, Roboto, true)
		end

		drawButton("stateMarksRemove", "Jelölések törlése", screenX - respc(205), screenY - respc(50) - respc(70), respc(200), respc(30), {188, 64, 61}, false, Roboto, true)

		if mapMoveDiff then
			drawButton("cringeSpaceButton", "Nézet alphelyzetbe állítása", screenX - respc(205), screenY - respc(50) - respc(70) - respc(35), respc(200), respc(30), {188, 64, 61}, false, Roboto, true)
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

function bigmapClickHandler(button, state, absX, absY)
	if not bigRadarState then
		return
	end

	if activeButtonC == "cringeSpaceButton" then
		if state == "up" then
			if mapMoveDiff then
				mapMoveDiff = false
				lastMapMovePos = false
				activeButtonC = false
				playSound(":sm_accounts/files/bubble.mp3")
			end
		end
	end

	if activeButtonC == "stateMarksBlip" then
		if state == "up" then
			stateMarksBlip = not stateMarksBlip
			playSound(":sm_accounts/files/bubble.mp3")
		end

		return
	end

	if activeButtonC == "stateMarksRemove" then
		if state == "up" then
			for i = #createdBlips, 1, -1 do
				if createdBlips[i].blipId == "minimap/newblips/markblip.png" then
					table.remove(createdBlips, i)
				end
			end
		end

		return
	end

	if activeButtonC == "state3DBlip" then
		if state == "up" then
			state3DBlip = not state3DBlip

			if state3DBlip then
				addEventHandler("onClientHUDRender", getRootElement(), render3DBlips, true, "low-99999999")
			else
				removeEventHandler("onClientHUDRender", getRootElement(), render3DBlips)
			end

			playSound(":sm_accounts/files/bubble.mp3")
		end

		return
	end

	if state == "up" and mapIsMoving then
		mapIsMoving = false
		return
	end

	local currVeh = getPedOccupiedVehicle(localPlayer)

	if currVeh and carCanGPS() then
		if absX >= bigmapX + bigmapWidth - respc(85) and absY >= bigmapY + bigmapHeight - respc(174) and absX <= bigmapX + bigmapWidth - respc(144) + respc(128) and absY <= bigmapY + bigmapHeight - respc(30) then
			if state == "down" then
				local newVal = carCanGPSVal

				if newVal == "" then
					newVal = 2
				elseif newVal == "2" then
					newVal = 3
				elseif newVal == "off" then
					newVal = 1
				end

				setElementData(currVeh, "vehicle.GPS", newVal)
			end

			return
		end

		if button == "left" and state == "up" and not activeButtonC then
			local tx = reMap((absX - bigmapX) / zoom + (remapTheSecondWay(mapMovedX) - bigmapWidth / zoom / 2), 0, radarTextureSize, -3000, 3000)
			local ty = reMap((absY - bigmapY) / zoom + (remapTheFirstWay(mapMovedY) - bigmapHeight / zoom / 2), 0, radarTextureSize, 3000, -3000)

			if getElementData(currVeh, "gpsDestination") then
				setElementData(currVeh, "gpsDestination", false)
			else
				setElementData(currVeh, "gpsDestination", {tx, ty})
			end

			return
		end
	end

	if state == "up" and stateMarksBlip and not activeButtonC then
		if absX >= bigmapX and absY >= bigmapY and absX <= bigmapX + bigmapWidth and absY <= bigmapY + bigmapHeight then
			if hoverMarkBlip then
				table.remove(createdBlips, hoverMarkBlip)
			else
				local tx = reMap((absX - bigmapX) / zoom + (remapTheSecondWay(mapMovedX) - bigmapWidth / zoom / 2), 0, radarTextureSize, -3000, 3000)
				local ty = reMap((absY - bigmapY) / zoom + (remapTheFirstWay(mapMovedY) - bigmapHeight / zoom / 2), 0, radarTextureSize, 3000, -3000)
				local tz = getGroundPosition(tx, ty, 400) + 3

				table.insert(createdBlips, {
					blipPosX = tx,
					blipPosY = ty,
					blipPosZ = tz,
					blipId = "minimap/newblips/markblip.png",
					farShow = true,
					renderDistance = 9999,
					iconSize = 18,
					blipColor = tocolor(255, 255, 255)
				})
			end
		end
	end
end

addEventHandler("onClientKey", getRootElement(),
	function (key, state)
		if key == "F11" then
			local dim = getElementDimension(localPlayer)
			if dim ~= 0 then
				return
			end

			if state and renderData.loggedIn then
				bigRadarState = not bigRadarState

				if bigRadarState then
					hideHUD()

					addEventHandler("onClientHUDRender", getRootElement(), renderTheBigmap)
					addEventHandler("onClientClick", getRootElement(), bigmapClickHandler)
					addEventHandler("onClientPreRender", getRootElement(), bigmapZoomHandler)

					playSound("minimap/files/f11radaropen.mp3")

					if isPedInVehicle(localPlayer) and carCanGPS() and carCanGPSVal ~= "off" then
						gpsHello = playSound("minimap/gps/sound" .. carCanGPSVal .. "/hello.mp3")
					end
				else
					playSound("minimap/files/f11radarclose.mp3")

					removeEventHandler("onClientHUDRender", getRootElement(), renderTheBigmap)
					removeEventHandler("onClientClick", getRootElement(), bigmapClickHandler)
					removeEventHandler("onClientPreRender", getRootElement(), bigmapZoomHandler)

					showHUD()

					if isElement(gpsHello) then
						destroyElement(gpsHello)
					end

					gpsHello = nil
				end

				setElementData(localPlayer, "bigRadarState", bigRadarState, false)
			end

			cancelEvent()
		elseif key == "mouse_wheel_up" and bigRadarState then
			if targetZoom + 0.1 <= 2 then
				targetZoom = targetZoom + 0.1
			end
		elseif key == "mouse_wheel_down" and bigRadarState then
			if targetZoom - 0.1 >= 0.2 then
				targetZoom = targetZoom - 0.1
			end
		end
	end
)

function bigmapZoomHandler(timeSlice)
	zoom = zoom + (targetZoom - zoom) * timeSlice * 0.005
end

local zoneLineHeight = respc(30)
local gpsLineWidth = respc(60)
local gpsLineIconSize = respc(40)
local gpsLineIconHalfSize = gpsLineIconSize / 2

local minimapRenderSize = 400
min, max, cos, sin, rad, deg, atan2 = math.min, math.max, math.cos, math.sin, math.rad, math.deg, math.atan2
sqrt, abs, floor, ceil, random = math.sqrt, math.abs, math.floor, math.ceil, math.random
gsub = string.gsub

minimapRenderSize = 400
minimapRenderHalfSize = minimapRenderSize * 0.5
if isElement(minimapRender) then
	destroyElement(minimapRender)
end
minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)

function renderMinimapExport(x, y, w, h)
	minimapWidth = w
	minimapHeight = h

	if minimapPosX ~= x or minimapPosY ~= y then
		minimapPosX = x
		minimapPosY = y
	end

	minimapCenterX = minimapPosX + minimapWidth / 2
	minimapCenterY = minimapPosY + minimapHeight / 2

	dxUpdateScreenSource(screenSource, true)

	minimapZoom = 0.4

	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local playerDimension = getElementDimension(localPlayer)
	local cameraX, cameraY, _, faceTowardX, faceTowardY = getCameraMatrix()
	local cameraRotation = deg(atan2(faceTowardY - cameraY, faceTowardX - cameraX)) + 360 + 90
	local crx, cry, crz = getElementRotation(getCamera())

	local minimapRenderSizeOffset = respc(minimapRenderSize * 0.75)

	farshowBlips = {}
	farshowBlipsData = {}

	if playerDimension == 0 or playerDimension == 65000 or playerDimension == 33333 then
		local remapPlayerPosX, remapPlayerPosY = remapTheFirstWay(playerPosX), remapTheFirstWay(playerPosY)
		local farBlips = {}
		local farBlipsCount = 10000
		local manualBlipsCount = 1
		local defaultBlipsCount = 1

		dxSetRenderTarget(minimapRender)
		dxDrawRectangle(0, 0, minimapRenderSize, minimapRenderSize, tocolor(110, 158, 204))
		dxDrawImageSection(0, 0, minimapRenderSize, minimapRenderSize, remapTheSecondWay(playerPosX) - minimapRenderSize / minimapZoom / 2, remapTheFirstWay(playerPosY) - minimapRenderSize / minimapZoom / 2, minimapRenderSize / minimapZoom, minimapRenderSize / minimapZoom, radarTexture)

		if gpsRouteImage then
			dxSetBlendMode("add")
				dxDrawImage(minimapRenderSize / 2 + (remapTheFirstWay(playerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * minimapZoom - gpsRouteImageData[3] * minimapZoom / 2, minimapRenderSize / 2 - (remapTheFirstWay(playerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * minimapZoom + gpsRouteImageData[4] * minimapZoom / 2, gpsRouteImageData[3] * minimapZoom, -(gpsRouteImageData[4] * minimapZoom), gpsRouteImage, 180, 0, 0, tocolor(220, 163, 30))
			dxSetBlendMode("blend")
		end

		for i = 1, #createdBlips do
			if createdBlips[i] then
				if createdBlips[i].farShow then
					farBlips[farBlipsCount + manualBlipsCount] = createdBlips[i].icon
				end
				manualBlipsCount = manualBlipsCount + 1
				renderBlip2(createdBlips[i].blipId, createdBlips[i].blipPosX, createdBlips[i].blipPosY, remapPlayerPosX, remapPlayerPosY, createdBlips[i].iconSize, createdBlips[i].iconSize, createdBlips[i].blipColor, createdBlips[i].farShow, crz, manualBlipsCount)
			end
		end

		dxSetRenderTarget()
		dxDrawImage(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2, minimapRenderSize, minimapRenderSize, minimapRender)


	end

	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)
	dxDrawImageSection(minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)

	local textWidth = dxGetTextWidth(getZoneName(playerPosX, playerPosY, playerPosZ), 0.7, Roboto) + 14
	local centerText = (minimapCenterX) - (textWidth /2)
	dxDrawRectangle(centerText, minimapPosY + minimapHeight - 25, textWidth, 18, tocolor(0, 0, 0, 180))
	dxDrawText(getZoneName(playerPosX, playerPosY, playerPosZ), centerText, minimapPosY + minimapHeight - 25, textWidth + centerText, 18 + minimapPosY + minimapHeight - 25, tocolor(255, 255, 255, 255), 0.75, Roboto, "center", "center", false, false, false, true)
	
	if playerDimension == 0 then
		local playerArrowSize = 60 / (4 - minimapZoom) + 3
		local playerArrowHalfSize = playerArrowSize / 2
		local _, _, playerRotation = getElementRotation(localPlayer)

		dxDrawImage(minimapCenterX - playerArrowHalfSize, minimapCenterY - playerArrowHalfSize, playerArrowSize, playerArrowSize, "minimap/files/arrow.png", abs(360 - playerRotation))
	else
		dxDrawRectangle(minimapPosX, minimapPosY, minimapWidth, minimapHeight, tocolor(0, 0, 0))

		if not lostSignalStartTick then
			lostSignalStartTick = getTickCount()
		end

		local fadeAlpha = 255
		if not lostSignalFadeIn then
			fadeAlpha = 255
		else
			fadeAlpha = 0
		end

		local lostSignalTick = (getTickCount() - lostSignalStartTick) / 1500
		if lostSignalTick > 1 then
			lostSignalStartTick = getTickCount()
			lostSignalFadeIn = not lostSignalFadeIn
		end

		dxDrawImage(minimapCenterX - 32, minimapCenterY - 32 - 16, 64, 64, "minimap/files/gpslosticon.png", 0, 0, 0, tocolor(255, 255, 255, interpolateBetween(fadeAlpha, 0, 0, 255 - fadeAlpha, 0, 0, lostSignalTick, "Linear")))
		dxDrawImage(minimapCenterX - 128, minimapCenterY + 16 + 8, 256, 16, "minimap/files/gpslosttext.png")
		dxDrawImage(minimapPosX + minimapWidth - 64, minimapPosY, 64, 16, "minimap/files/nosignaltext.png")
	end

	if damageEffectStart then
		if tonumber(damageEffectStart) then
			if getTickCount() - damageEffectStart >= 1000 then
				damageEffectStart = false
				return
			end
		else
			damageEffectStart = false
			return
		end

		local effectProgress = (getTickCount() - damageEffectStart) / 500
		if effectProgress > 1 then
			damageEffectStart = false
			return
		end

		dxDrawRectangle(minimapPosX, minimapPosY, minimapWidth, minimapHeight, tocolor(255, 0, 0, interpolateBetween(150, 0, 0, 0, 0, 0, effectProgress, "Linear")))
	end
end

function renderBlip2(icon, blipX, blipY, playerPosX, playerPosY, blipWidth, blipHeight, blipColor, farShow, blipTableId)
	local blipPosX = minimapRenderHalfSize + (playerPosX - remapTheFirstWay(blipX)) * minimapZoom
	local blipPosY = minimapRenderHalfSize - (playerPosY - remapTheFirstWay(blipY)) * minimapZoom

	if not farShow and (blipPosX > minimapRenderSize or 0 > blipPosX or blipPosY > minimapRenderSize or 0 > blipPosY) then
		return
	end

	local blipIsVisible = true
	if farShow then
		if blipPosX > minimapRenderSize then
			blipPosX = minimapRenderSize
		end
		if blipPosX < 0 then
			blipPosX = 0
		end
		if blipPosY > minimapRenderSize then
			blipPosY = minimapRenderSize
		end
		if blipPosY < 0 then
			blipPosY = 0
		end

		local blipScreenPosX = minimapPosX - minimapRenderHalfSize + minimapWidth / 2 + (minimapRenderHalfSize * (blipPosX - minimapRenderHalfSize)  * (blipPosY - minimapRenderHalfSize) - blipWidth / 2)
		local blipScreenPosY = minimapPosY - minimapRenderHalfSize + minimapHeight / 2 + (minimapRenderHalfSize * (blipPosX - minimapRenderHalfSize) * (blipPosY - minimapRenderHalfSize) - blipHeight / 2)

		farshowBlips[blipTableId] = nil

		if blipScreenPosX < minimapPosX or blipScreenPosX > minimapPosX + minimapWidth - blipWidth then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if blipScreenPosY < minimapPosY or blipScreenPosY > minimapPosY + minimapHeight - zoneLineHeight - blipHeight then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if farshowBlips[blipTableId] then
			farshowBlipsData[blipTableId] = {
				posX = max(minimapPosX, min(minimapPosX + minimapWidth - blipWidth, blipScreenPosX)),
				posY = max(minimapPosY, min(minimapPosY + minimapHeight - zoneLineHeight - blipHeight, blipScreenPosY)),
				icon = icon,
				iconWidth = blipWidth,
				iconHeight = blipHeight,
				color = blipColor
			}
		end
	end

	if blipIsVisible then
		dxDrawImage(blipPosX - blipWidth / 2, blipPosY - blipHeight / 2, blipWidth, blipHeight, "" .. icon, 0, 0, blipColor)
	end
end

--[[
addEventHandler("onClientRender", root,
		function ()
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local areaId = math.floor((playerX + 3000) / 750) + math.floor((playerY + 3000) / 750) * 8
			local drawnNodes = {}

			for id, node in pairs(vehicleNodes[areaId]) do
				local distanceBetween = getDistanceBetweenPoints3D(playerX, playerY, playerZ, node.x, node.y, playerZ)

				if distanceBetween < 50 then
					local screenX, screenY = getScreenFromWorldPosition(node.x, node.y, node.z + 1)

					if screenX and screenY then
						dxDrawText(tostring(id), screenX - 10, screenY - 5, 0, 0, -1, 1, "arial")
					end

					for neighbour in pairs(node.neighbours) do
						if not drawnNodes[id .. "-" .. neighbour] then
							local nodeNeighbour = vehicleNodes[math.floor(neighbour / 65536)][neighbour]

							if nodeNeighbour then
								dxDrawLine3D(node.x, node.y, node.z + 1, nodeNeighbour.x, nodeNeighbour.y, nodeNeighbour.z + 1, tocolor(50, 50, 200), 3)
							end

							drawnNodes[id .. "-" .. neighbour] = true
						end
					end
				end
			end
		end
)]]