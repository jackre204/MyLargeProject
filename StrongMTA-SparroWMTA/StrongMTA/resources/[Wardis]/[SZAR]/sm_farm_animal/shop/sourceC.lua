pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local destinationData = {}

local progressPed = createPed(2, 104.17865753174, -84.541473388672, 1.4888645410538)

local screenX, screenY = guiGetScreenSize()

local responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function respc(x)
	return math.ceil(x * responsiveMultipler)
end


local screenDatas = {
    x = screenX / 2 - respc(800) / 2,
    y = screenY / 2 - respc(430) / 2,
    w = respc(800),
    h = respc(360)
    
}

function renderParkingZone()
	local x, y = unpack(destinationData.colShapeBounds[1])
	local z = getGroundPosition(x, y, 20) + 0.1

	local color = tocolor(255, 0, 0)

	if checkAABB(getElementData(localPlayer, "player.trailer"), destinationData.colShape) then
		color = tocolor(0, 255, 0)
		print("true")
	end

	dxDrawLine3D(
		destinationData.colShapeBounds[1][1], destinationData.colShapeBounds[1][2], z,
		destinationData.colShapeBounds[2][1], destinationData.colShapeBounds[2][2], z,
		color, 3
	)

	dxDrawLine3D(
		destinationData.colShapeBounds[2][1], destinationData.colShapeBounds[2][2], z,
		destinationData.colShapeBounds[4][1], destinationData.colShapeBounds[4][2], z,
		color, 3
	)

	dxDrawLine3D(
		destinationData.colShapeBounds[4][1], destinationData.colShapeBounds[4][2], z,
		destinationData.colShapeBounds[3][1], destinationData.colShapeBounds[3][2], z,
		color, 3
	)

	dxDrawLine3D(
		destinationData.colShapeBounds[3][1], destinationData.colShapeBounds[3][2], z,
		destinationData.colShapeBounds[1][1], destinationData.colShapeBounds[1][2], z,
		color, 3
	)
end

function createDropPoint(deliveryPoint)

	local middleX, middleY = deliveryPoints[deliveryPoint].dropPoint[1], deliveryPoints[deliveryPoint].dropPoint[2]

	local parkingDetails = {middleX, middleY, deliveryPoints[deliveryPoint].dropPoint[3], 5, 4}

	destinationData = {
		basePosition = {parkingDetails[1], parkingDetails[2], deliveryPoints[deliveryPoint].dropPoint[3]},
		baseRotation = deliveryPoints[deliveryPoint].dropPoint[4] + 90,
		parkingSizes = {parkingDetails[4], parkingDetails[5]},
	}

	rotated_x1, rotated_y1 = rotateAround(destinationData.baseRotation, -destinationData.parkingSizes[1] / 2, -destinationData.parkingSizes[2] / 2)
	local rotated_x2, rotated_y2 = rotateAround(destinationData.baseRotation, destinationData.parkingSizes[1] / 2, -destinationData.parkingSizes[2] / 2)
	local rotated_x3, rotated_y3 = rotateAround(destinationData.baseRotation, destinationData.parkingSizes[1] / 2, destinationData.parkingSizes[2] / 2)
	local rotated_x4, rotated_y4 = rotateAround(destinationData.baseRotation, -destinationData.parkingSizes[1] / 2, destinationData.parkingSizes[2] / 2)

	destinationData.colShape = createColPolygon(
		destinationData.basePosition[1],
		destinationData.basePosition[2],

		destinationData.basePosition[1] + rotated_x1,
		destinationData.basePosition[2] + rotated_y1,

		destinationData.basePosition[1] + rotated_x2,
		destinationData.basePosition[2] + rotated_y2,

		destinationData.basePosition[1] + rotated_x3,
		destinationData.basePosition[2] + rotated_y3,

		destinationData.basePosition[1] + rotated_x4,
		destinationData.basePosition[2] + rotated_y4
	)

	destinationData.colShapeBounds = {
		[1] = {destinationData.basePosition[1] + rotated_x2, destinationData.basePosition[2] + rotated_y2}, -- top right
		[2] = {destinationData.basePosition[1] + rotated_x3, destinationData.basePosition[2] + rotated_y3}, -- top left
		[3] = {destinationData.basePosition[1] + rotated_x1, destinationData.basePosition[2] + rotated_y1}, -- bottom right
		[4] = {destinationData.basePosition[1] + rotated_x4, destinationData.basePosition[2] + rotated_y4} -- bottom left
	}

	setDevelopmentMode(true)
end

function clickOnProgressPed(key, keyState, x, y, wx, wy, wz, element)
	if key == "right" and keyState == "down" then
		print("sad")
		if element then
			if element == progressPed then
				if getElementData(localPlayer, "farmOrdered") and not show then
					addEventHandler("onClientRender", getRootElement(), renderShipping)
					addEventHandler("onClientClick", getRootElement(), clickShipping)
					show = true
					if trailersInCol then
						trailerPage = true
					end
				end
			end
		end
	end
end

function clickShipping(key, keyState)
	if key == "left" and keyState == "down" then
		if activeButtonC == "closeTheOrder" then
			removeEventHandler("onClientRender", getRootElement(), renderShipping)
			removeHandler("onClientClick", getRootElement(), clickShipping)
		elseif activeButtonC == "acceptTheOrder" then
			removeEventHandler("onClientRender", getRootElement(), renderShipping)
			trailersInCol = checkAABB(getElementData(localPlayer, "player.trailer"), destinationData.colShape)
			removeEventHandler("onClientClick", getRootElement(), clickShipping)
			show = false
			outputChatBox("Most állj bele az utánfutóval a kockába!")
		elseif activeButtonC == "dontkeepTheOrder" then
			removeEventHandler("onClientRender", getRootElement(), renderShipping)
			removeEventHandler("onClientClick", getRootElement(), clickShipping)
			show = false
		elseif activeButtonC == "keepTheOrder" then
			local trailer = getElementData(localPlayer, "player.trailer")
			setElementData(trailer, "trailer.load", getElementData(localPlayer, "farmOrdered"))
			markFarm(getElementData(localPlayer, "farmOrdered")[4])
			findFarm(getElementData(localPlayer, "farmOrdered")[4])
			setElementData(trailer, "farmOrdered", false)
			triggerServerEvent("addObjToTrailer", localPlayer, localPlayer, trailer)
			removeEventHandler("onClientRender", getRootElement(), renderShipping)
			removeEventHandler("onClientClick", getRootElement(), clickShipping)
			show = false
			trailersInCol = false
			trailerPage = false
		end
	end
end

function renderShipping()
	buttonsC = {}

	if trailerPage then
		dxDrawRectangle(screenDatas.x + respc(200), screenDatas.y + respc(100), screenDatas.w/2, screenDatas.h/2, tocolor(25, 25, 25))
		dxDrawText("Mezőgazdasági nagyker", screenDatas.x + 3 + respc(10) + respc(200), screenDatas.y + respc(20) + respc(100), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
		if getElementData(localPlayer, "player.trailer") then
			dxDrawRectangle(screenDatas.x + 3 + respc(200), screenDatas.y + 3 + respc(100), screenDatas.w/2 - 6, respc(40) - 6, tocolor(45, 45, 45))
			dxDrawText("Mezőgazdasági nagyker", screenDatas.x + 3 + respc(10) + respc(200), screenDatas.y + respc(20) + respc(100), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
			dxDrawText("Felrakodás a következő utánfutóra: ".. getVehiclePlateText(getElementData(localPlayer, "player.trailer")) .."", screenDatas.x + 3 + respc(250), screenDatas.y + 3 + respc(180), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "top", false, false, true)
			drawButton("keepTheOrder", "Igen", screenDatas.x + respc(200) + 5, screenDatas.y + respc(210), screenDatas.w/2 - 10, respc(30), {61, 122, 188}, false, RalewayB)
			drawButton("dontkeepTheOrder", "Nem", screenDatas.x + respc(200) + 5, screenDatas.y + respc(245), screenDatas.w/2 - 10, respc(30), {188, 64, 61}, false, RalewayB)	dxDrawRectangle(screenDatas.x + 3 + respc(200), screenDatas.y + 3 + respc(170), screenDatas.w/2 - 6, respc(40) - 6, tocolor(45, 45, 45))
		end
	else
		dxDrawRectangle(screenDatas.x + respc(200), screenDatas.y + respc(100), screenDatas.w/2, screenDatas.h/2, tocolor(25, 25, 25))
		dxDrawRectangle(screenDatas.x + 3 + respc(200), screenDatas.y + 3 + respc(100), screenDatas.w/2 - 6, respc(40) - 6, tocolor(45, 45, 45))
		dxDrawRectangle(screenDatas.x + 3 + respc(200), screenDatas.y + 3 + respc(100), screenDatas.w/2 - 6, respc(40) - 6, tocolor(45, 45, 45))
		dxDrawText("Mezőgazdasági nagyker", screenDatas.x + 3 + respc(10) + respc(200), screenDatas.y + respc(20) + respc(100), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
		drawButton("closeTheOrder", "Bezárás", screenDatas.x + respc(200) + 5, screenDatas.y + respc(242), screenDatas.w/2 - 10, respc(30), {188, 64, 61}, false, RalewayB)	dxDrawRectangle(screenDatas.x + 3 + respc(200), screenDatas.y + 3 + respc(170), screenDatas.w/2 - 6, respc(40) - 6, tocolor(45, 45, 45))
		dxDrawText(""..getElementData(localPlayer, "farmOrdered")[1].. " ("..getElementData(localPlayer, "farmOrdered")[2].." db)", screenDatas.x + 3 + respc(10) + respc(200), screenDatas.y + respc(20) + respc(170), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
		drawButton("acceptTheOrder", "Kiválasztás", screenDatas.x + respc(440) + 5, screenDatas.y + respc(176), respc(150), respc(28), {61, 122, 188}, false, RalewayB)
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

function createAccesPoint()
	createDropPoint(1)
	addEventHandler("onClientRender", getRootElement(), renderParkingZone)
	addEventHandler("onClientClick", getRootElement(), clickOnProgressPed)
end

createAccesPoint()

allowedVehicles = {
	[608] = true
}

function checkAABB(vehicleElement, colshapeBounds)
	if not isElement(vehicleElement) then
		return false
	end

	if not allowedVehicles[getElementModel(vehicleElement)] then
		return false
	end

	if colshapeBounds then
	
		if isElementWithinColShape(vehicleElement, colshapeBounds) then
				return true
		end
	end

	return false
end

function renderParkingZone()
	local x, y = unpack(destinationData.colShapeBounds[1])
	local z = getGroundPosition(x, y, 20) + 0.1

	local color = tocolor(255, 0, 0)
	if checkAABB(getElementData(localPlayer, "player.trailer"), destinationData.colShape) then
		color = tocolor(0, 255, 0)
	end

	dxDrawLine3D(
		destinationData.colShapeBounds[1][1], destinationData.colShapeBounds[1][2], z,
		destinationData.colShapeBounds[2][1], destinationData.colShapeBounds[2][2], z,
		color, 3
	)

	dxDrawLine3D(
		destinationData.colShapeBounds[2][1], destinationData.colShapeBounds[2][2], z,
		destinationData.colShapeBounds[4][1], destinationData.colShapeBounds[4][2], z,
		color, 3
	)

	dxDrawLine3D(
		destinationData.colShapeBounds[4][1], destinationData.colShapeBounds[4][2], z,
		destinationData.colShapeBounds[3][1], destinationData.colShapeBounds[3][2], z,
		color, 3
	)

	dxDrawLine3D(
		destinationData.colShapeBounds[3][1], destinationData.colShapeBounds[3][2], z,
		destinationData.colShapeBounds[1][1], destinationData.colShapeBounds[1][2], z,
		color, 3
	)
end

function findFarm(dbid)
	for k, v in ipairs(getElementsByType("marker")) do
		if getElementData(v, "farm:markerID") == tonumber(dbid) then
			print(dbid)
			triggerServerEvent("syncOrderToServer", localPlayer, {}, dbid)
			return v
		end
	end
end

function markFarm(dbid)
	for k, v in ipairs(getElementsByType("marker")) do
		if getElementData(v, "farm:markerID") == tonumber(dbid) then
			local x, y, z = getElementPosition(v)
			local marker = createMarker(x + 1, y, z - 1, "cylinder", 3, 61, 122, 188)
			setElementData(marker, "orderDownMarker", true)
			outputChatBox("#3d7abc[StrongMTA]#ffffff Vidd az árut a farm előtt található markerbe!", 255, 255, 255, true)
			addEventHandler("onClientMarkerHit", getRootElement(), hitDownMarker)
			print("added")
			break
		end
	end
end

function hitDownMarker(hitElement, matchDimension)
	local vehicle = getPedOccupiedVehicle(hitElement)
	if vehicle then
		iprint(getElementData(localPlayer, "player.trailer"))
		local attachedTrailer = getVehicleTowedByVehicle(vehicle)
		if getElementData(source, "orderDownMarker") then
			if attachedTrailer == getElementData(localPlayer, "player.trailer") then
				outputChatBox("#3d7abc[StrongMTA]#ffffff Sikeresen leszállítottad az árut! Az árut a farmban találod!", 255, 255, 255, true)
				destroyElement(source)
				triggerServerEvent("removeOrderedThings", localPlayer, attachedTrailer, localPlayer)
				removeEventHandler("onClientMarkerHit", getRootElement(), hitDownMarker)
			end
		end
	end
end