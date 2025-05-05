local connection = exports.sm_database:getConnection()

addCommandHandler("createfarm", function(thePlayer, cmd, numberOfSize)
    if not numberOfSize or tonumber(numberOfSize) < 1 then
        outputChatBox("[Farm]: /farm [Size of Farm]")
    else
        numberOfSize = tonumber(numberOfSize)
        local lastInsertID = 0
        for i = 1, numberOfSize do
            local x, y, z = getElementPosition(thePlayer)
            if i > 1 then
                x, y = getPositionFromElementOffset(farmExteriors[lastInsertID],5.2,-7.5,0)
            end
            local _, _, rot = getElementRotation(thePlayer)
            local farmInsertQuery = dbQuery(connection, "INSERT INTO farms SET x = ?, y = ?, z = ?, rotation = ?", x,y,z, rot)
            local success, _, insertID = dbPoll(farmInsertQuery, -1)
            if success then
                loadFarmFromDatabase(insertID)
            else
                print("nem")
            end
            triggerClientEvent(getElementsByType("player"), "createBoardTexture", thePlayer, insertID, "Kiadó!")
            lastInsertID = insertID
        end
    end
end)

farmInMarker = {}
farmExteriors = {}
orderTables = {}
fork = {}
cargoTables = {}

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    local allFarmQuery = dbPoll(dbQuery(connection,"SELECT * FROM farms"),-1)
    if allFarmQuery then
        for k, v in pairs(allFarmQuery) do
            loadFarmFromDatabase(v["id"])
        end
        setTimer(function()
            for k, v in pairs(getElementsByType("player")) do
                local farmID = getElementData(v, "farm:inFarmID")
                if farmID and farmID > 0 then
                    loadFarmForPlayer(v, farmID)
                end
            end
        end, 500, 1)
    end
end)

farmTimers = {}

addEvent("getIntoFarmInterior", true)
addEventHandler("getIntoFarmInterior", root, function(player, marker)
    local intDim = getElementData(marker, "farm:dimension")
    setElementPosition(player, unpack(getElementData(marker, "farm:position")))
    setElementDimension(player, intDim)
    if intDim > 0 then
        loadFarmForPlayer(player, intDim)
        setElementData(player, "farm:inFarmID", intDim)
    else
        triggerClientEvent(player, "syncBlockTableClient", player, player, false, true, false)
        setElementData(player, "farm:inFarmID", 0)
    end
end)

farmOutMarker = {}

blockTables = {}

animalTables = {}

farmInteriors2 = {}

farmInteriors = {}

permissionTables = {}

local farmBoards = {}

function loadFarmFromDatabase(dbID)
    local farmQuery = dbPoll(dbQuery(connection,"SELECT * FROM farms WHERE id = ?", dbID), -1)
    if farmQuery then
        for k, v in pairs(farmQuery) do
            local markerColor = {farmMarkerColor[1], farmMarkerColor[2], farmMarkerColor[3], farmMarkerColor[4]}
            if v["owner"] == 0 then
                markerColor = {farmRentMarkerColor[1], farmRentMarkerColor[2], farmRentMarkerColor[3], farmRentMarkerColor[4]}
            else
                farmTimers[dbID] = setTimer(function()
                dbExec(connection, "UPDATE farms SET owner = ?, blockTable = NULL, permissionTable = '[[]]' WHERE id = ? ", 0, dbID)
                blockTables[dbID] = nil
                animalTables[dbID] = {}
                orderTables[dbID] = {}
                cargoTables[dbID] = {}
                permissionTables[dbID] = {}
                setElementData(farmOutMarker[dbID], "farm.owner", 0)
                setElementData(farmInMarker[dbID], "farm.owner", 0)
                setMarkerColor(farmInMarker[dbID], farmRentMarkerColor[1], farmRentMarkerColor[2], farmRentMarkerColor[3], farmRentMarkerColor[4])
                print("[Server]: Rent Time ended")
                end, v["rentTime"], 1)
            end
            farmInMarker[dbID] = createMarker(v["x"], v["y"], v["z"]-1, "cylinder", 0.7, markerColor[1], markerColor[2], markerColor[3], markerColor[4])
            setElementData(farmInMarker[dbID], "farm:marker", true)
            setElementData(farmInMarker[dbID], "farm:markerID", dbID)
            setElementData(farmInMarker[dbID], "farm:position", {farmInteriorPosition[1], farmInteriorPosition[2], farmInteriorPosition[3]})
            setElementData(farmInMarker[dbID], "farm:dimension", dbID)
            setElementData(farmInMarker[dbID], "farm:name", v["name"])
            setElementData(farmInMarker[dbID], "farm:owner", v["owner"])
            setElementData(farmInMarker[dbID], "farm:locked", v["locked"])
            local x,y,z = getPositionInfrontOfElement(v["x"], v["y"], v["z"]-1, v["rotation"], 7.5)
            farmExteriors[dbID] = createObject(16673,x,y,z)
            setElementRotation(farmExteriors[dbID], 0, 0, v["rotation"])
            farmOutMarker[dbID] = createMarker(farmInteriorPosition[1], farmInteriorPosition[2], farmInteriorPosition[3]-1, "cylinder", 0.7, farmMarkerColor[1], farmMarkerColor[2], farmMarkerColor[3], farmMarkerColor[4])
            setElementData(farmOutMarker[dbID], "farm:marker", true)
            setElementData(farmOutMarker[dbID], "farm:markerID", dbID)
            setElementData(farmOutMarker[dbID], "farm:position", {v["x"], v["y"], v["z"]})
            setElementData(farmOutMarker[dbID], "farm:dimension", 0)
            setElementData(farmOutMarker[dbID], "farm:name", v["name"])
            setElementData(farmOutMarker[dbID], "farm:owner", v["owner"])
            setElementData(farmOutMarker[dbID], "farm:locked", v["locked"])
            farmBoards[dbID] = createObject(16674,0,0,0)
            attachElements(farmBoards[dbID], farmExteriors[dbID], 0.025, -6.65, 1.3, 0)
            setElementCollisionsEnabled(farmBoards[dbID], false)
            setElementData(farmBoards[dbID], "farm:boardName", v["name"])
            setElementData(farmBoards[dbID], "farm:boardID", dbID)
            setElementData(farmBoards[dbID], "farm:boardOwner", v["owner"])
            setElementDimension(farmOutMarker[dbID], dbID)
            -- villa
            if v["blockTable"] then
                blockTables[dbID] = fromJSON(v["blockTable"])
            end
            if v["animalTable"] then
                animalTables[dbID] = fromJSON(v["animalTable"])
            end
            if v["permissionTable"] then
                permissionTables[dbID] = fromJSON(v["permissionTable"])
            else
                permissionTables[dbID] = {}
            end
            if v["permissionTable"] then
                cargoTables[dbID] = fromJSON(v["cargoTable"])
            else
                cargoTables[dbID] = {}
            end
        end
    end
end

addEvent("rentFarmServer", true)
addEventHandler("rentFarmServer", root, function(player, markerID, price, elementData)
    local playerName = getElementData(player, "visibleName"):gsub("_", " ")
    dbExec(connection, "UPDATE farms SET owner = ?, name = ?, rentTime = ? WHERE id = ?", getElementData(player, "char.ID"), getElementData(player, "visibleName"), defaultRentTime, markerID)
    setMarkerColor(farmInMarker[markerID], farmMarkerColor[1], farmMarkerColor[2], farmMarkerColor[3], farmMarkerColor[4])
    setElementData(farmInMarker[markerID], "farm:owner", getElementData(player, "char.ID"))
    setElementData(farmOutMarker[markerID], "farm:owner", getElementData(player, "char.ID"))
    setElementData(farmOutMarker[markerID], "farm:name", playerName)
    setElementData(farmInMarker[markerID], "farm:name", playerName)
    triggerClientEvent(getElementsByType("player"), "changeBoardTexture", player, markerID, playerName)
    farmTimers[markerID] = setTimer(function()
        dbExec(connection, "UPDATE farms SET owner = ?, blockTable = NULL, permissionTable = '[[]]' WHERE id = ? ", 0, markerID)
        blockTables[markerID] = nil
        animalTables[markerID] = {}
        orderTables[markerID] = {}
        cargoTables[markerID] = {}
        permissionTables[markerID] = {}
        setElementData(farmOutMarker[markerID], "farm:owner", 0)
        setElementData(farmInMarker[markerID], "farm:owner", 0)
        setMarkerColor(farmInMarker[markerID], farmRentMarkerColor[1], farmRentMarkerColor[2], farmRentMarkerColor[3], farmRentMarkerColor[4])
        print("[Server]: Rent is over. "..markerID)
    end, defaultRentTime, 1)
    outputChatBox("sikerut", player, 255,255,255,true)
end)

function loadFarmForPlayer(player, farmID, permissions)
    --if getElementData(v, "farm:inFarmID") and getElementData(v, "farm:inFarmID") > 0 then
        local atvTable = nil
        if blockTables[farmID] then
            atvTable = blockTables[farmID]
        end
        if animalTables[farmID] then
            animalTable = animalTables[farmID]
        end
        triggerClientEvent(player, "syncBlockTableClient", player, player, atvTable, false, permissionTables[farmID], animalTables[farmID], orderTables[farmID], cargoTables[farmID])
    --end
end

addEvent("syncNewSurfaceToServer", true)
addEventHandler("syncNewSurfaceToServer", root, function(selectedIndex, type, player, seedIndex, dimid, newLevel)
    
    for k, v in pairs(getElementsByType("player")) do
        if getElementData(v, "farm:inFarmID") and getElementData(v, "farm:inFarmID") == dimid then
            triggerClientEvent(v, "syncNewSurfaceToClient", source, selectedIndex, type, player, seedIndex, newLevel)
        end
    end
end)


addEvent("saveBlockTableActionServer", true)
addEventHandler("saveBlockTableActionServer", root, function(table, dimid, index, type)
    if not blockTables[dimid] then
        blockTables[dimid] = table
    else
        for k, v in pairs(blockTables[dimid]) do
            v.state = table[k].state
            v.hayLevel = table[k].hayLevel
        end
    end
end)

addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), function()
    for k, v in pairs(farmInMarker) do
        if blockTables[k] then
            dbExec(connection, "UPDATE farms SET blockTable = ?, animalTable = ?, cargoTable = ? WHERE id = ?", toJSON(blockTables[k]), toJSON(animalTables[k]), toJSON(cargoTables[k]),k)
        end

        if isTimer(farmTimers[k]) then
            local rentTimeLeft = getTimerDetails(farmTimers[k])
            dbExec(connection, "UPDATE farms SET rentTime = ?, permissionTable = ? WHERE id = ?", rentTimeLeft, toJSON(permissionTables[k]), k)
        end
    end
end)

addEvent("savePermissionTable", true)
addEventHandler("savePermissionTable", root, function(player, dbid, table)
    permissionTables[dbid] = table
end)

addEvent("changeFarmInteriorName", true)
addEventHandler("changeFarmInteriorName", root, function(dimID, newName)
	dbExec(connection, "UPDATE farms SET name = ? WHERE id = ?", newName, dimID)
	for k, v in pairs(getElementsByType("marker")) do
		if getElementData(v, "farm:markerID") and getElementData(v, "farm:markerID") == dimID then
			setElementData(v, "farm:name", newName)
		end
	end
	triggerClientEvent(getElementsByType("player"), "changeBoardTexture", source, dimID, newName)
end)

obj = createObject(16671, worldX+3.1-0.60, worldY+3.45, 5004.4)
obj2 = createObject(16673, worldX+3.1-0.60, worldY+3.45, 5004.4)
setElementDimension(obj, -1)
setElementDimension(obj2, -1)

addEvent("syncAnimalToServer", true)
function syncAnimalToServer(animal, dimid)
    for k, v in pairs(getElementsByType("player")) do
        if getElementData(v, "farm:inFarmID") and getElementData(v, "farm:inFarmID") == dimid then
            triggerClientEvent(v, "syncAnimalToClient", source, animal, dimid)
        end
    end
    if not animalTables[dimid] then
        animalTables[dimid] = {}
    end
    table.insert(animalTables[dimid], animal)
end
addEventHandler("syncAnimalToServer", root, syncAnimalToServer)

addEvent("syncOrderToServer", true)
function syncOrderToServer(table, dimid)
    for k, v in pairs(getElementsByType("player")) do
        if getElementData(v, "farm:inFarmID") and getElementData(v, "farm:inFarmID") == dimid then
            triggerClientEvent(v, "syncOrderToClient", source, table, dimid)
        end
    end
    orderTables[dimid] = table
end
addEventHandler("syncOrderToServer", root, syncOrderToServer)

addEvent("addCargoToFarm", true)
function addCargoToFarm(cargo, dimid)
    for k, v in pairs(getElementsByType("player")) do
        if getElementData(v, "farm:inFarmID") and getElementData(v, "farm:inFarmID") == dimid then
            triggerClientEvent(v, "syncCargoToFarm", source, cargo, dimid)
        end
    end
    if not cargoTables[dimid] then
        cargoTables[dimid] = {}
    end
    table.insert(cargoTables[dimid], cargo)
end
addEventHandler("addCargoToFarm", root, addCargoToFarm)

addEvent("createFarmItemServer", true)
addEventHandler("createFarmItemServer", root, function(player, type, newValue)
    triggerClientEvent(getElementsByType("player"), "createFarmItemClient", source, player, type, newValue)
end)