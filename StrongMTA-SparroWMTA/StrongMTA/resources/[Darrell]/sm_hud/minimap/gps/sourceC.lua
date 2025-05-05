

gpsRoute = false
gpsThread = false
gpsWaypoints = {}
nextWp = false
turnAround = false
currentWaypoint = false
waypointInterpolation = false
waypointEndInterpolation = false
reRouting = false

local currentNode = false

local lastDestinationX = false
local lastDestinationY = false

local lastRerouteCheck = 0

local colshapes = false
local colshapeIds = {}

local currentSound = false
local playedSounds = {}
local selectionSound = false

local rerouteCheckTimer = false
local rerouteCheckRate = 1500

local distanceDivider = 0.9

function shallowcopy(t)
	if type(t) ~= "table" then
		return t
	end
	
	local target = {}

	for k,v in pairs(t) do
		target[k] = v
	end

	return target
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for _, node in ipairs(disabledNodes) do
			local area = math.floor(node[1] / 65536)
			local copy = shallowcopy(vehicleNodes[area][node[1]].neighbours)
			
			vehicleNodes[area][node[1]].neighbours = {}
			
			for k, v in pairs(copy) do
				if k ~= node[2] then
					vehicleNodes[area][node[1]].neighbours[k] = v
				end
			end

		end

		local currVeh = getPedOccupiedVehicle(localPlayer)
		
		if isElement(currVeh) then
			carCanGPS()

			if getElementData(currVeh, "gpsDestination") then
				local dataVal = getElementData(currVeh, "gpsDestination")

				gpsThread = coroutine.create(makeRoute)

				coroutine.resume(gpsThread, dataVal[1], dataVal[2], true)
			end
		end
	end)

addEventHandler("onClientVehicleEnter", getRootElement(),
	function (enterPlayer)
		if enterPlayer == localPlayer then
			carCanGPS()

			if getElementData(source, "gpsDestination") then
				local dataVal = getElementData(source, "gpsDestination")

				gpsThread = coroutine.create(makeRoute)

				coroutine.resume(gpsThread, dataVal[1], dataVal[2], true)
			end
		end
	end)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (exitPlayer)
		if exitPlayer == localPlayer then
			if gpsRoute then
				endRoute()
			end
		end
	end)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		local currVeh = getPedOccupiedVehicle(localPlayer)

		if isElement(currVeh) then
			if source == currVeh then
				if getElementData(source, "gpsDestination") then
					setElementData(source, "gpsDestination", false)
					
					if gpsRoute then
						endRoute()
					end
				end
			end
		end
	end)

function getPositionFromElementOffset(element, x, y, z)
	local m = getElementMatrix(element)
	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
		   x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
		   x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end

local function getAngle(x1, y1, x2, y2)
	local angle = math.atan2(x2, y2) - math.atan2(x1, y1)
	
	if angle <= -math.pi then
		angle = angle + math.pi * 2
	elseif angle > math.pi then
		angle = angle - math.pi * 2
	end
	
	return angle
end

local function getVehicleNodeByID(nodeId)
	local areaId = math.floor(nodeId / 65536)

	if areaId >= 0 and areaId <= 63 then
		return vehicleNodes[areaId][nodeId]
	end
end

local function calculatePath(startNode, endNode)
	local usedNodes = {}
	local currentNodes = {}
	local ways = {}

	usedNodes[startNode.id] = true
	
	for id, distance in pairs(startNode.neighbours) do
		usedNodes[id] = true
		currentNodes[id] = distance
		ways[id] = {startNode.id}
	end
	
	while true do
		local currentNode = -1
		local maxDistance = 10000
		
		for id, distance in pairs(currentNodes) do
			if distance < maxDistance then
				currentNode = id
				maxDistance = distance
			end
		end
		
		if currentNode == -1 then
			return false
		end
		
		if endNode.id == currentNode then
			local lastNode = currentNode
			local bestNodes = {}
			
			while tonumber(lastNode) do
				local node = getVehicleNodeByID(lastNode)

				table.insert(bestNodes, 1, node)

				lastNode = ways[lastNode]
			end
			
			return bestNodes
		end
		
		for id, distance in pairs(getVehicleNodeByID(currentNode).neighbours) do
			if not usedNodes[id] then
				ways[id] = currentNode
				currentNodes[id] = maxDistance + distance
				usedNodes[id] = true
			end
		end
		
		currentNodes[currentNode] = nil
	end
end

local function getVehicleNodeClosestToPoint(x, y)
	local areaId = math.floor((x + 3000) / 750) + math.floor((y + 3000) / 750) * 8
	local closestNode = -1
	local lastDistance = 10000
	
	if not vehicleNodes[areaId] then
		return false
	end
	
	for _, node in pairs(vehicleNodes[areaId]) do
		local distance = getDistanceBetweenPoints2D(x, y, node.x, node.y)
		
		if lastDistance > distance then
			lastDistance = distance
			closestNode = node
		end
	end
	
	return closestNode
end

function calculateRoute(x1, y1, x2, y2)
	local startNode = getVehicleNodeClosestToPoint(x1, y1)
	local endNode = getVehicleNodeClosestToPoint(x2, y2)
	
	if not startNode then
		playOneGPSSound("nincskapcs")
		return false
	end
	
	if not endNode then
		playOneGPSSound("masikuticel")
		return false
	end
	
	return calculatePath(startNode, endNode)
end

function playGPSSound(sounds)
	if isElement(currentSound) then
		destroyElement(currentSound)
	end
	
	if isTimer(currentSoundTimer) then
		killTimer(currentSoundTimer)
	end

	if carCanGPSVal ~= "off" then
		currentSound = playSound("minimap/gps/sound" .. carCanGPSVal .. "/ding.mp3")
		currentSoundTimer = setTimer(playNextGPSSound, getSoundLength(currentSound) * 0.9 * 1000, 1, split(sounds, ";"), 1)
	end

	if isElement(gpsHello) then
		destroyElement(gpsHello)
	end

	gpsHello = nil
end

function playNextGPSSound(sounds, count)
	if carCanGPSVal ~= "off" then
		currentSound = playSound("minimap/gps/sound" .. carCanGPSVal .. "/" .. sounds[count] .. ".mp3")
		
		if count < #sounds then
			currentSoundTimer = setTimer(playNextGPSSound, getSoundLength(currentSound) * 0.9 * 1000, 1, sounds, count + 1)
		end
	end
end

function playOneGPSSound(sound)
	if isElement(currentSound) then
		destroyElement(currentSound)
	end
	
	if isTimer(currentSoundTimer) then
		killTimer(currentSoundTimer)
	end

	if carCanGPSVal ~= "off" then
		currentSound = playSound("minimap/gps/sound" .. carCanGPSVal .. "/" .. sound .. ".mp3")
	end
end

function endRoute()
	if gpsRoute then
		if colshapes then
			for k, v in pairs(colshapes) do
				colshapeIds[colshapes[k]] = nil
				
				if isElement(v) then
					destroyElement(v)
				end
					
				colshapes[k] = nil
			end
		end
		
		nextWp = false
		
		if isTimer(rerouteCheckTimer) then
			killTimer(rerouteCheckTimer)
		end
		
		rerouteCheckTimer = nil
		waypointEndInterpolation = getTickCount()

		clearGPSRoute()

		gpsRoute = false
		gpsThread = false
	end
end

function reRoute(checkShape)
	local currVeh = getPedOccupiedVehicle(localPlayer)

	if not gpsRoute or not currVeh then
		return
	end
	
	local vehPosX, vehPosY, vehPosZ = getElementPosition(currVeh)
	
	if getDistanceBetweenPoints2D(gpsRoute[checkShape].x, gpsRoute[checkShape].y, vehPosX, vehPosY) >= 50 then
		if not makeRoute(lastDestinationX, lastDestinationY, true) then
			rerouteCheckTimer = setTimer(checkForReroute, 10000, 1)
			reRouting = true
		end
	else
		rerouteCheckTimer = setTimer(checkForReroute, rerouteCheckRate, 1)
		reRouting = false
	end
end

function checkForReroute()
	local currVeh = getPedOccupiedVehicle(localPlayer)

	if not gpsRoute or not currVeh then
		return
	end
	
	local vehPosX, vehPosY, vehPosZ = getElementPosition(currVeh)
	local distance = getDistanceBetweenPoints2D(gpsRoute[currentNode].x, gpsRoute[currentNode].y, vehPosX, vehPosY)

	if distance >= 30 and distance < 80 then
		if gpsRoute[currentNode + 1] then
			if lastRerouteCheck and getTickCount() - lastRerouteCheck > 5000 then
				local x, y = getPositionFromElementOffset(currVeh, -1, 0, 0)
				local angle = getAngle(gpsRoute[currentNode + 1].x - gpsRoute[currentNode].x, gpsRoute[currentNode + 1].y - gpsRoute[currentNode].y, x - vehPosX, y - vehPosY)
				
				if math.deg(angle) > 0 then
					lastRerouteCheck = getTickCount()
					rerouteCheckTimer = setTimer(checkForReroute, rerouteCheckRate, 1)

					playGPSSound("forduljvissza")

					turnAround = true
					reRouting = false

					return
				else
					turnAround = false
					reRouting = false
				end
			end
		end
	end
	
	if isTimer(rerouteCheckTimer) then
		killTimer(rerouteCheckTimer)
	end
	
	if distance > 100 then
		rerouteCheckTimer = setTimer(reRoute, math.random(3000, 5000), 1, currentNode)
		reRouting = getTickCount()
		playGPSSound("ujratervezes")
	else
		rerouteCheckTimer = setTimer(checkForReroute, rerouteCheckRate, 1)
	end
end

function makeRoute(destinationX, destinationY, uturned)
	waypointInterpolation = false
	
	if isElement(currentSound) then
		destroyElement(currentSound)
	end
	
	if isTimer(currentSoundTimer) then
		killTimer(currentSoundTimer)
	end
	
	if isTimer(rerouteCheckTimer) then
		killTimer(rerouteCheckTimer)
	end
	
	clearGPSRoute()

	gpsWaypoints = {}
	turnAround = false
	gpsLines = {}
	gpsRoute = false
	
	if colshapes then
		for k, v in pairs(colshapes) do
			colshapeIds[colshapes[k]] = nil
			
			if isElement(v) then
				destroyElement(v)
			end
				
			colshapes[k] = nil
		end
	end
	
	colshapes = {}
	colshapeIds = {}

	local currVeh = getPedOccupiedVehicle(localPlayer)
	
	if not currVeh then
		return
	end
	
	local vehPosX, vehPosY, vehPosZ = getElementPosition(currVeh)
	
	local currentZone = getZoneName(vehPosX, vehPosY, 0)
	local currentCity = getZoneName(vehPosX, vehPosY, 0, true)

	local targetZone = getZoneName(destinationX, destinationY, 0)
	local targetCity = getZoneName(destinationX, destinationY, 0, true)

	local disabledZones = {
		Unknown = true,

	--	["Los Santos"] = true,
		["Red County"] = false,
		
		["San Fierro"] = true,
		["San Fierro Bay"] = true,
		["Gant Bridge"] = true,
		["Flint County"] = true,
		--Whetstone = true,
		
		["Las Venturas"] = true,
		["Bone County"] = true,
		["Garver Bridge"] = true,
		["Tierra Robada"] = false,
		["Easter Bay Airport"] = true,
	}
	
	if disabledZones[currentZone] or disabledZones[currentCity] then
		playOneGPSSound("nincskapcs")
		setElementData(currVeh, "gpsDestination", false)
		return false
	end
	
	if disabledZones[targetZone] or disabledZones[targetCity] then
		exports.sm_accounts:showInfo("e", "Nem található útvonal a kiválasztott célhoz.")
		playOneGPSSound("masikuticel")
		setElementData(currVeh, "gpsDestination", false)
		return false
	end
	
	local routePath = calculateRoute(vehPosX, vehPosY, destinationX, destinationY)
	
	if not routePath then
		if not uturned then
			exports.sm_accounts:showInfo("e", "Nem található útvonal a kiválasztott célhoz.")
			playOneGPSSound("masikuticel")
		else
			playOneGPSSound("nincskapcs")
		end
		
		setElementData(currVeh, "gpsDestination", false)

		return false
	end
	
	gpsRoute = routePath

	if not gpsRoute[1] or not gpsRoute[2] then
		exports.sm_accounts:showInfo("e", "A kiválasztott uticél túl közel van hozzád.")
		playOneGPSSound("masikuticel")
		setElementData(currVeh, "gpsDestination", false)
		return false
	end

	nextWp = 1
	currentWaypoint = 0
	currentNode = 1
	rerouteCheckTimer = setTimer(checkForReroute, rerouteCheckRate, 1)

	local turnPoints = {}

	for i, node in ipairs(gpsRoute) do
		local nextNode = gpsRoute[i + 1]
		local prevNode = gpsRoute[i - 1]
		
		if i > 1 and i < #gpsRoute then
			for k in pairs(node.neighbours) do
				if prevNode and nextNode and k ~= prevNode.id and k ~= nextNode.id then
					local angle = getAngle(node.x - prevNode.x, node.y - prevNode.y, nextNode.x - node.x, nextNode.y - node.y)
					
					if math.deg(angle) > 10 then
						table.insert(turnPoints, {i, "right"})
						break
					end
					
					if math.deg(angle) < -10 then
						table.insert(turnPoints, {i, "left"})
					end
					
					break
				end
			end
		end
		
		local colshapeElement = createColTube(node.x, node.y, node.z - 0.3, 8, 5)
		colshapes[i] = colshapeElement
		colshapeIds[colshapeElement] = i
		

		addGPSLine(node.x, node.y)
	end
	
	local nodeIndex = 1

	for i = 1, #turnPoints do
		local prevNode = gpsRoute[nodeIndex]
		local nodeId = tonumber(turnPoints[i][1])

		if not nodeId then
			nodeId = #gpsRoute
		end

		local distance = 0

		for j = nodeIndex, nodeId do
			distance = distance + getDistanceBetweenPoints2D(gpsRoute[j].x, gpsRoute[j].y, prevNode.x, prevNode.y)
			prevNode = gpsRoute[j]
		end
		
		prevNode = gpsRoute[nodeIndex]
		
		if distance > 600 then
			local nextdistance = 0
			
			for j = nodeIndex, nodeId do
				nextdistance = nextdistance + getDistanceBetweenPoints2D(gpsRoute[j].x, gpsRoute[j].y, prevNode.x, prevNode.y)
				
				if distance - 500 < nextdistance then
					table.insert(gpsWaypoints, {j, "forward"})
					break
				end
			end
		end
	
		nodeIndex = nodeId
		table.insert(gpsWaypoints, turnPoints[i])
	end
	
	table.insert(gpsWaypoints, {"end", "end"})
	
	local distance = 0
	local prevNode = gpsRoute[1]

	for i = 1, tonumber(gpsWaypoints[nextWp][1]) or #gpsRoute do
		distance = distance + getDistanceBetweenPoints2D(gpsRoute[i].x, gpsRoute[i].y, prevNode.x, prevNode.y)
		prevNode = gpsRoute[i]
	end

	gpsWaypoints[nextWp][3] = distance / distanceDivider
	
	local x, y = getPositionFromElementOffset(currVeh, -1, 0, 0)
	local angle = getAngle(gpsRoute[2].x - gpsRoute[1].x, gpsRoute[2].y - gpsRoute[1].y, x - vehPosX, y - vehPosY)
	
	if math.deg(angle) > 0 then
		lastRerouteCheck = getTickCount()
		
		if not uturned then
			currentSound = setTimer(playGPSSound, 1750, 1, "forduljvissza")
		else
			playGPSSound("forduljvissza")
		end
		
		turnAround = true
	end

	lastDestinationX = destinationX
	lastDestinationY = destinationY

	processGPSLines()
	
	if isElement(selectionSound) then
		destroyElement(selectionSound)
	end
	
	selectionSound = false
	
	if not uturned then
		if carCanGPSVal ~= "off" then
			selectionSound = playSound("minimap/gps/sound" .. carCanGPSVal .. "/uticel.mp3")
		end
	end
end

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (hitElement)
		if hitElement == localPlayer then
			local colshapeId = colshapeIds[source]
				
			if not colshapeId then
				return
			end

			clearGPSRoute()
			
			if colshapeId >= 2 then
				if isTimer(rerouteCheckTimer) then
					killTimer(rerouteCheckTimer)
				end
				
				rerouteCheckTimer = nil
				turnAround = false
			end
			
			if colshapeId == #gpsRoute then
				playGPSSound("finish")
				
				for i = 1, colshapeId do
					if isElement(colshapes[i]) then
						destroyElement(colshapes[i])
					end
					
					colshapes[i] = nil
				end
				
				nextWp = false
				
				if isTimer(rerouteCheckTimer) then
					killTimer(rerouteCheckTimer)
				end
				
				rerouteCheckTimer = nil

				setElementData(getPedOccupiedVehicle(localPlayer), "gpsDestination", false)

				return
			else
				for i = 1, colshapeId do
					if isElement(colshapes[i]) then
						destroyElement(colshapes[i])
					end
					
					colshapes[i] = nil
				end
				
				for i = colshapeId, #gpsRoute do
					addGPSLine(gpsRoute[i].x, gpsRoute[i].y)
				end
				
				if isTimer(rerouteCheckTimer) then
					killTimer(rerouteCheckTimer)
				end
				
				currentNode = colshapeId + 1
				local x, y, z = getElementPosition(colshapes[currentNode])
				local rx, ry, rz = getElementRotation(colshapes[currentNode])
				--triggerServerEvent("setGPSDATA", getPedOccupiedVehicle(localPlayer), {x, y, z, rx, ry, rz})
				setElementData(getPedOccupiedVehicle(localPlayer), "nextColShape", {getElementPosition(colshapes[currentNode])})
				lastRerouteCheck = getTickCount()
				rerouteCheckTimer = setTimer(checkForReroute, rerouteCheckRate, 1)
				reRouting = false

				processGPSLines()
			end

			if gpsWaypoints[nextWp] and gpsWaypoints[nextWp][1] ~= "end" then
				if colshapeId >= gpsWaypoints[nextWp][1] then
					nextWp = nextWp + 1
					playedSounds = {}
					
					local distance = 0
					local prevNode = gpsRoute[colshapeId]

					for i = colshapeId, tonumber(gpsWaypoints[nextWp][1]) or #gpsRoute do
						distance = distance + getDistanceBetweenPoints2D(gpsRoute[i].x, gpsRoute[i].y, prevNode.x, prevNode.y)
						prevNode = gpsRoute[i]
					end

					gpsWaypoints[nextWp][3] = distance / distanceDivider
				else
					local distance = 0
					local prevNode = gpsRoute[colshapeId]

					for i = colshapeId, gpsWaypoints[nextWp][1] do
						distance = distance + getDistanceBetweenPoints2D(gpsRoute[i].x, gpsRoute[i].y, prevNode.x, prevNode.y)
						prevNode = gpsRoute[i]
					end

					gpsWaypoints[nextWp][3] = distance / distanceDivider

					if gpsWaypoints[nextWp][2] == "forward" and not playedSounds["forward"] and colshapeId > 2 then
						if gpsWaypoints[nextWp - 1] and colshapeId < 2 + gpsWaypoints[nextWp - 1][1] then
							return
						end
						
						playedSounds["forward"] = true
						playGPSSound("egyenes")

						return
					end
					
					local distance = math.floor(gpsWaypoints[nextWp][3] / 10) * 10
					
					if distance <= 50 and not playedSounds[50] then
						playedSounds[50] = true
						playedSounds[250] = true
						playedSounds[500] = true
						playedSounds[1200] = true
						playedSounds[1500] = true
						
						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("jobbra")
						end
						
						return
					end

					if distance > 230 and distance <= 250 and not playedSounds[250] then
						playedSounds[250] = true
						playedSounds[500] = true
						playedSounds[1200] = true
						playedSounds[1500] = true
						
						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("menj;200;50;metert;majd;balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("menj;200;50;metert;majd;jobbra")
						end
						
						return
					end
					
					if distance > 480 and distance <= 500 and not playedSounds[500] then
						playedSounds[500] = true
						playedSounds[1200] = true
						playedSounds[1500] = true
						
						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("menj;500;metert;majd;balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("menj;500;metert;majd;jobbra")
						end
						
						return
					end
					
					if distance > 1180 and distance <= 1200 and not playedSounds[1200] then
						playedSounds[1200] = true
						playedSounds[1500] = true

						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("menj;1000;200;metert;majd;balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("menj;1000;200;metert;majd;jobbra")
						end
						
						return
					end
					
					if distance > 1480 and distance <= 1500 and not playedSounds[1500] then
						playedSounds[1500] = true
						
						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("menj;1000;500;metert;majd;balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("menj;1000;500;metert;majd;jobbra")
						end
						
						return
					end
				end
			else
				local distance = 0
				local prevNode = gpsRoute[colshapeId]

				for i = colshapeId, #gpsRoute do
					distance = distance + getDistanceBetweenPoints2D(gpsRoute[i].x, gpsRoute[i].y, prevNode.x, prevNode.y)
					prevNode = gpsRoute[i]
				end
				
				gpsWaypoints[nextWp][3] = distance / distanceDivider
			end
		end
	end)