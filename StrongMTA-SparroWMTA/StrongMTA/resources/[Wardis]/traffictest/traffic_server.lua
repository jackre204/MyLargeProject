citizens = createTeam ("Citizens", 0, 0, 255 )

addEventHandler ( "onResourceStart", _local, function ()

	-- Make sure our definitions exist and match the paths file
	if ( not AREA_WIDTH or not AREA_HEIGHT or not AREA_MAX or not AREA_STEP ) then
		outputDebugString ( "Paths file definitions missing! Unloading.." )
		cancelEvent ()
		return
	elseif ( AREA_MAX ~= getRealAreasCount() - 1 ) then
		outputDebugString ( "Invalid paths file! Unloading.." )
		cancelEvent ()
		return
	end

	-- Reset active areas
	for areaID = 0, AREA_MAX do
		AREA_ACTIVE[areaID] = false
		AREA_VEHICLECOUNT[areaID] = 0
	end
	
	for i, player in ipairs(getElementsByType("player")) do
		-- bindKey(player, "x", "down", warpIntoNextVehicle)
		bindKey(player, "m", "down", spawnNearVehicle)
		PLAYER_VEHICLECOUNT[player] = 0
	end

	-- Set up area preloader timer OLD
	setTimer ( function ()
		local temp = {}
		for i, player in ipairs ( getElementsByType ( "player" ) ) do
			local areaID = getAreaFromPos ( getElementPosition ( player ) )
			temp[areaID] = true
			if ( AREA_PRELOAD ) then
				-- This will make it heavier, but looking better
				for i, area in ipairs ( findCloseAreas ( areaID ) ) do
					temp[area] = true
				end
			end
		end
		for areaID = 0, AREA_MAX do
			if ( temp[areaID] and not AREA_ACTIVE[areaID] ) then
				onAreaStatus ( areaID, true )
			elseif ( AREA_ACTIVE[areaID] and not temp[areaID] ) then
				onAreaStatus ( areaID, false )
			end
			AREA_ACTIVE[areaID] = temp[areaID] or false
		end
	end, 1500, 0 )
	--]]

	--Setup loader/unloader queue processing timer
	setTimer ( function ()
		local preload = TRAFFIC_PRELOADER[1]
		if ( preload ) then
			createVehicleOnNodes ( preload.node, preload.next, preload.syncer )
			table.remove ( TRAFFIC_PRELOADER, 1 )
		end
		local unload = TRAFFIC_UNLOADER[1]
		if unload then
			-- outputDebugString("UNLOAD: "..tostring(unload).." "..tostring(getElementType(unload)).." "..tostring(destroyElement(unload)))
			destroyElement(unload)
			table.remove(TRAFFIC_UNLOADER, 1)
			for veh in pairs ( TRAFFIC_VEHICLES ) do
				if veh == unload then
					TRAFFIC_VEHICLES[veh] = nil
					outputDebugString("UNLOAD: "..tostring(unload))
				end
			end
		end	
	end, 100, 0 )
	
	setTimer ( function ()
		for veh in pairs ( TRAFFIC_VEHICLES ) do
			if getElementChild(veh, 0) then
				warpPedIntoVehicle(getElementChild(veh, 0), veh)
			end
		end
	end, 10000, 0 )
	
	setTimer ( function ()
		local syncer
		for veh in pairs ( TRAFFIC_VEHICLES ) do
			syncer = getElementSyncer(veh)
			if DEBUG then
				setElementData(veh, "syncer", tostring(syncer and getPlayerName(syncer)))
			end
			-- if not getValidSyncer(getElementPosition(veh)) or not getElementChild(veh, 0) or not getVehicleController(veh) then
				-- local areaID = getAreaFromPos(getElementPosition(veh))
				-- AREA_VEHICLECOUNT[areaID] = AREA_VEHICLECOUNT[areaID] - 1
				-- destroyElement(veh)
				-- TRAFFIC_VEHICLES[veh] = nil
			-- end
		end
		if DEBUG then
			for i, player in ipairs(getElementsByType("player")) do
				setElementData(player, "vehiclecount", PLAYER_VEHICLECOUNT[player])
			end
		end
	end, 1000, 0 )
end )

addEventHandler ( "onPlayerJoin", root,
	function ()
		PLAYER_VEHICLECOUNT[source] = 0
		-- bindKey(source, "x", "down", warpIntoNextVehicle)
		bindKey(source, "m", "down", spawnNearVehicle)
		for veh in pairs ( TRAFFIC_VEHICLES ) do
			local ped = getElementChild(veh, 0)
			if ped then
				triggerClientEvent(source, VEH_CREATED, ped)
			end
		end
	end
)

addEvent("onPlayerFinishedDownloadTraffic", true)
addEventHandler ("onPlayerFinishedDownloadTraffic", _root, 
	function()
		if ( DEBUG ) then
			outputDebugString("send vehs on join for "..tostring(getPlayerName(source)))
		end
		for veh in pairs ( TRAFFIC_VEHICLES ) do
			local ped = getElementChild(veh, 0)
			if ped then
				triggerClientEvent(source, VEH_CREATED, ped)
			end
		end
	end
)

addEventHandler ( "onVehicleExplode", root,
	function()
		outputDebugString("EXPLODE: "..tostring(source))
		setTimer(
			function(veh)
				destroyElement(veh)
				table.insert(TRAFFIC_UNLOADER, veh)
			end
		, 3000, 1, source)
	end
)

function onAreaStatus ( areaID, active )
	if ( active ) then
		local nodes = {}
		local temp = {}
		-- for node, v in pairs ( AREA_PATHS[areaID] ) do
		for node, v in pairs ( AREA_PATHS_ALL[areaID].veh ) do
			table.insert ( nodes,node )
		end
		local max_boats = AREA_LIMITS[areaID].BOATS
		for i = 1, AREA_LIMITS[areaID].ALL do
			local random = nodes[math.random ( 1, #nodes )]
			if ( not temp[random] ) then
				local nb = {}
				local node = getNode ( random )
				if node and verifyNodeFlags(node.flags) then
					if getValidSyncer(node.x, node.y) and (node.type == TYPE_BOATS and max_boats > 0 or node.type == TYPE_DEFAULT) then
						local next = pathsFindNextNode(node.id)
						if ( next ) then
							table.insert ( TRAFFIC_PRELOADER, { node = node, next = next } )
							temp[random] = true
						end
					else
						i = i - 1
					end
				end
			end
		end
	else
		for vehicle in pairs ( TRAFFIC_VEHICLES ) do
			if not getElementSyncer(vehicle) and ( getAreaFromPos ( getElementPosition ( vehicle ) ) == areaID ) then
				table.insert ( TRAFFIC_UNLOADER, vehicle )
			end
		end
	end
end
--]]

function createVehicleOnNodes ( node, next )
	local x, y, z = node.x, node.y, node.z
	local ped
	repeat
		ped = createPed ( math.random ( 9, 264 ), x, y, z, 0, false )
		setElementData(ped, "BotTeam", getTeamFromName("Citizens"))
	until ped
	if ( ped ) then
		-- createMarker ( node.x, node.y, node.z, "corona", 1, 255, 0, 0, 255 )
		-- createMarker ( next.x, next.y, next.z, "corona", 1, 0, 0, 255, 255 )
		local rotz = ( 360 - math.deg ( math.atan2 ( ( next.x - x ), ( next.y - y ) ) ) ) % 360
		local ox, oy = calcNodeLaneOffset ( next, rotz, node )
		local x, y = x + ox, y + oy
		local veh = nil
		if ( node.type == TYPE_DEFAULT ) then
			local rotx = math.deg ( math.atan2 ( next.z - z, getDistanceBetweenPoints2D ( next.x, next.y, x, y ) ) )
			veh = createVehicle ( VEHICLE_TYPES[math.random(1,#VEHICLE_TYPES)], x, y, z + 1, rotx, 0, rotz )
			--veh = createVehicle ( 431, x, y, z + 1, rotx, 0, rotz )
		elseif ( node.type == TYPE_BOAT ) then
			veh = createVehicle ( BOAT_TYPES[math.random(1,#BOAT_TYPES)], x, y, z, 0, 0, rot )
		end
		if ( not veh ) then
			destroyElement ( ped )
		else
            setElementData(veh, "type", "traffic")
			warpPedIntoVehicle ( ped, veh )
			-- setTimer ( warpPedIntoVehicle, 1000, 1, ped, veh )
			setElementParent ( ped, veh )
			if ( DEBUG ) then
				setElementParent ( createBlipAttachedTo ( ped, 0, 1, 0, 255, 0, 255 ), ped )
			end
			setElementData(veh, "next", next.id)
			-- if syncer then
				-- setElementSyncer(veh, syncer)
			-- end
			triggerClientEvent ( VEH_CREATED, ped, node.id, next.id )
			return true
		end
	end
	return false
end


setTimer(function()
--checa se não tem ninguém perto do veiculo, se não tem, apaga ele
            for i, vehi in ipairs(getElementsByType("vehicle")) do
	            if getElementData(vehi, "type") == "traffic" then
					contajogadores = 0
					local deucerto = 0
					for i, players in ipairs(getElementsByType("player")) do
						contajogadores = contajogadores + 1
                        --outputChatBox("tentando apagar")
						x, y, z = getElementPosition(players)
						xp, yp, zp = getElementPosition(vehi)
						if getDistanceBetweenPoints2D(x, y, xp, yp) > 90 then
							deucerto = deucerto + 1
                            --outputChatBox("testei")
						end
					end
					if deucerto >= contajogadores then
						--outputChatBox("distancia correta:"..deucerto)
						--outputChatBox("numero de jogadores:"..contajogadores)
						destroyElement(vehi)
						--outputChatBox("veh deleted")
					end
				end
			end
end, 100, 0)

setTimer(function()
--checa se não tem ninguém perto do pedestre, se não tem, apaga ele
            for i, peds in ipairs(getElementsByType("ped")) do
	            if getElementData(peds, "type") == "Citi" or getElementData(peds, "type") == "Citi2" then
					contajogadores = 0
					local deucerto = 0
					for i, players in ipairs(getElementsByType("player")) do
						contajogadores = contajogadores + 1
                        --outputChatBox("tentando apagar")
						x, y, z = getElementPosition(players)
						xp, yp, zp = getElementPosition(peds)
						if getDistanceBetweenPoints2D(x, y, xp, yp) > 90 then
							deucerto = deucerto + 1
                            --outputChatBox("testei")
						end
					end
					if deucerto >= contajogadores then
						--outputChatBox("distancia correta:"..deucerto)
						--outputChatBox("numero de jogadores:"..contajogadores)
						destroyElement(peds)
						--outputChatBox("Citizen deleted")
					end
				end
			end
end, 100, 0)


setTimer(function()
    local randomPlayer1 = getRandomPlayer()
    local rand_loc = math.random(4)
    local x, y, z = getElementPosition(randomPlayer1)
                    if rand_loc == 1 then
			            x = x - 60
			            y = y + 10
		            elseif rand_loc == 2 then
			            x = x + 60
			            y = y + 10
		            elseif rand_loc == 3 then
			            x = x + 10
			            y = y - 60
		            elseif rand_loc == 4 then
			            x = x + 10
			            y = y + 60
		            end
	local node = pathsNodeFindClosest(x,y,z)
	local nb = {}
	local next = pathsFindNextNode(node.id)
    createVehicleOnNodes(node, next)
end, 5000, 0)







function findCloseAreas ( areaID )
	local close = {}
	local rows, columns = 6000 / AREA_WIDTH, 6000 / AREA_HEIGHT

	local area = areaID - rows - 1
	for c = area, area + 2 do
		if ( 0 <= c and c <= AREA_MAX ) then
			for i = 0, 2 do
				local r = c + rows * i
				if ( r ~= areaID and 0 <= r and r <= AREA_MAX ) then
					table.insert ( close, r )
				end
			end
		end
	end
	return close
end

function getRealAreasCount ()
	local count = 0
	-- for k, v in pairs ( AREA_PATHS ) do
	for k, v in pairs ( AREA_PATHS_ALL ) do
		count = count + 1
	end
	return count
end

function getValidSyncer(x, y)
	local nearestPlayer = getNearestPlayer(x, y)
	if nearestPlayer and getDistanceBetweenPoints2D(x, y, getElementPosition(nearestPlayer)) < PLAYER_LOADDISTANCE then
		return nearestPlayer
	end
	return false
end

function isInRightDistance(x, y, z)
	local dist
	local notToNear, rightDist = true, false
	for i, player in ipairs(getElementsByType("player")) do
		dist = getDistanceBetweenPoints3D(x, y, z, getElementPosition(player))
		if dist < PLAYER_NOLOADDISTANCE then
			notToNear = false
		end
		if dist < PLAYER_LOADDISTANCE then
			rightDist = true
		end
	end
	return rightDist and notToNear
end

function getNearestPlayer(x, y)
	local nearestPlayer = false
	local smallestDist, dist
	for i, player in ipairs(getElementsByType("player")) do
		dist = getDistanceBetweenPoints2D(x, y, getElementPosition(player))
		if not smallestDist or dist < smallestDist then
			smallestDist = dist
			nearestPlayer = player
		end
	end
	return nearestPlayer
end

function warpIntoNextVehicle(player)
	--if isPedInVehicle(player) then
		--removePedFromVehicle(player)
		--return
	--end
	local x,y,z = getElementPosition(player)
	local dist, nearest = 0.00000005
	for veh in pairs(TRAFFIC_VEHICLES) do
		local tempdist = getDistanceBetweenPoints3D(x,y,z,getElementPosition(veh))
		if tempdist < dist then
			dist = tempdist
			nearest = veh
		end
	end
	
	if nearest then
		local i = 0
		--repeat
			--i = i + 1
			--if i > 3 then
				--break
			--end
		--until not getVehicleOccupant(nearest, i)
		--warpPedIntoVehicle(player, nearest, i)
	end
end


function spawnNearVehicle(player)
	local node = pathsNodeFindClosest(getElementPosition(player))
	local nb = {}
	
	local next = pathsFindNextNode(node.id)
	-- checando se quem digitou é admin se for executa
		local accName = getAccountName ( getPlayerAccount (player) ) 
		if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
	        createVehicleOnNodes(node, next)
        end
end
