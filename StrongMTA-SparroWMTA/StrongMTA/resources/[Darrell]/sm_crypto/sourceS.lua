local connection = exports.sm_database:getConnection()

computercount = {}

computer = {}



function addCryptoPlace(player)
    local x, y, z = getElementPosition(player)
    dbQuery(
        function(queryHandle)
            local result, rows, lastID = dbPoll(queryHandle, 0)
            local marker = createMarker(x, y, z - 1, "cylinder", 0.8, 100, 100, 200)
            setElementData(marker, "crypto.placeid", lastID+1)
            for i = 1, 8 do
                dbExec(connection, "INSERT INTO testcrypto SET intid = ?", lastID+)
            end
        end, connection, "INSERT INTO cryptoplaces SET position = ?, cryptoBalance = ?", toJSON({x, y, z}), toJSON({balanceTable})
    )
end
addCommandHandler("addcryptoplace", addCryptoPlace)

local dataTable = {}
local balanceTable1 = {}

local timerData = 0

function addCryptoValue()
    timerData = timerData + 1
    
    --print(timerData)
    for k,v in ipairs(getElementsByType("marker")) do
        if getElementData(v,"crypto.data") then
            dataTable = getElementData(v,"crypto.data")
            packedTable = getElementData(v,"crypto.balance")
            balanceTable1 = unpack(packedTable)
            --iprint(balanceTable1["1"].name)
            for key, value in ipairs(dataTable) do
                if #value.gpu1 > 0 then
                    --iprint(value.selectedExchange)
                    local farmedCoinPrice = tonumber(fromJSON(value.gpu1)[1]) / 10000000

                    for bKey, bValue in pairs(balanceTable1) do

                        if value.selectedExchange == balanceTable1[tostring(bKey)].name then
                            local cryptoComputerBalance = tonumber(balanceTable1[tostring(bKey)].balance)

                            local currentComouterFarm = cryptoComputerBalance + farmedCoinPrice * timerData
                            balanceTable1[tostring(bKey)].balance = currentComouterFarm
                            setElementData(v,"crypto.balance",{balanceTable1})
                            --print(currentComouterFarm)
                        end
                    end
                end
                if #value.gpu2 > 0 then
                    --iprint(value.selectedExchange)
                    local farmedCoinPrice = tonumber(fromJSON(value.gpu2)[1]) / 10000000

                    for bKey, bValue in pairs(balanceTable1) do

                        if value.selectedExchange == balanceTable1[tostring(bKey)].name then
                            local cryptoComputerBalance = tonumber(balanceTable1[tostring(bKey)].balance)

                            local currentComouterFarm = cryptoComputerBalance + farmedCoinPrice * timerData
                            balanceTable1[tostring(bKey)].balance = currentComouterFarm
                            setElementData(v,"crypto.balance",{balanceTable1})
                            --print(currentComouterFarm)
                        end
                    end
                end
                if #value.gpu3 > 0 then
                    --iprint(value.selectedExchange)
                    local farmedCoinPrice = tonumber(fromJSON(value.gpu3)[1]) / 10000000

                    for bKey, bValue in pairs(balanceTable1) do

                        if value.selectedExchange == balanceTable1[tostring(bKey)].name then
                            local cryptoComputerBalance = tonumber(balanceTable1[tostring(bKey)].balance)

                            local currentComouterFarm = cryptoComputerBalance + farmedCoinPrice * timerData
                            balanceTable1[tostring(bKey)].balance = currentComouterFarm
                            setElementData(v,"crypto.balance",{balanceTable1})
                            --print(currentComouterFarm)
                        end
                    end
                end
            end
        end
    end
end
setTimer(addCryptoValue,5000,0)

function loadCryptoPlaces(data)
    dbQuery(
        function(queryHandle)
            local result, rows, lastID = dbPoll(queryHandle, 0)
            for k, v in pairs(result) do
                local pack = fromJSON(v.position)
                local x, y, z = unpack(pack)
                local marker = createMarker(x, y, z - 1, "cylinder", 0.8, 100, 100, 200)
                setElementData(marker, "crypto.placemarker", v.id)
                setElementData(marker, "crypto.entrance", v.id)
                setElementData(marker, "crypto.data", fromJSON(v.cryptodata))
                setElementData(marker, "crypto.balance", fromJSON(v.cryptoBalance))
                local marker2 = createMarker(1503.15234375, -1727.2055664062, 12.6328125, "cylinder", 0.8, 100, 100, 200)
                setElementDimension(marker2, v.id)
                setElementData(marker2, "crypto.exit", true)
                setElementData(marker2, "crypto.placemarker", v.id)
                setElementData(marker2, "crypto.exitpos", {x, y, z - 1})
                setElementData(marker2, "crypto.exitby", marker)
            end
        end, connection, "SELECT * FROM cryptoplaces"
    )
end

loadCryptoPlaces()

computerData = {}

fromCol = {}

fromRack = {}

fromColElement = {}

function saveCryptoComputers()
    for k,v in ipairs(getElementsByType("object")) do
        if getElementData(v, "crypto.rack") or getElementData(v, "crypto.computer") then
            if getElementData(v, "crypto.rack") then
                local count = getElementData(v, "crypto.computercount")
                dbExec(connection, "UPDATE testcrypto SET count = ? WHERE id = ?", toJSON(count), getElementData(v, "crypto.id"))
            elseif getElementData(v, "crypto.computer") then
                if not computerData[getElementData(v, "crypto.fromrack")] then
                    computerData[getElementData(v, "crypto.fromrack")] = {}
                end
                fromColElement[v] = getAttachedElements(v)
                for key, value in ipairs(fromColElement[v]) do
                    fromCol[v] = getElementData(value, "crypto.colid")
                end
                fromRack[v] = getElementData(v, "crypto.fromrack")
                table.insert(computerData[getElementData(v, "crypto.fromrack")], {rack = getElementData(fromRack[v], "crypto.id"), slot = fromCol[v], state = getElementData(v, "crypto.computerstate"), selectedExchange = getElementData(v, "crypto.selectedExchange")})
                dbExec(connection, "UPDATE testcrypto SET computerdatas = ? WHERE id = ?", toJSON(computerData[getElementData(v, "crypto.fromrack")]), getElementData(fromRack[v], "crypto.id"))
            end
        end
    end
end
addEventHandler("onResourceStop", resourceRoot, saveCryptoComputers)

addEvent("destroyCryptoComputer", true)
function destroyCryptoComputer(obj)
    destroyElement(obj)
end
addEventHandler("destroyCryptoComputer", root, destroyCryptoComputer)

addEvent("addCryptoComputer", true)
function addCryptoComputer(object, position, elementData1, elementData2, elementData3, id)
    local x, y, z = unpack(position)
    local computer = createObject(object, x, y, z)
    setElementData(computer, "".. elementData1[1] .."", elementData1[2])
    setElementData(computer, "".. elementData2[1] .."", elementData2[2])
    setElementData(computer, "".. elementData3[1] .."", elementData3[2])
    local col = createColSphere(0, 0, 0, 0.2)
    setElementData(col, "crypto.colid", id)
    setElementData(computer, "crypto.computerid", id)
    setElementData(computer, "crypto.computerstate", "Working")
    attachElements(col, computer)
    triggerClientEvent("addCryptoComputerOnClient", root, computer, elementData2[2])
end
addEventHandler("addCryptoComputer", root, addCryptoComputer)

addEvent("addCryptoComputerToHand", true)
function addCryptoComputerToHand()

end

objs = {}

addEvent("cryptoPlacePlayer", true)
function cryptoPlacePlayer(player, marker)
    if getElementData(marker, "crypto.entrance") then
        local table = getElementData(marker, "crypto.data")
        playMarker = marker
        dbQuery(
            function(queryHandle)
                local result, rows, lastID = dbPoll(queryHandle, 0)
                for k, v in pairs(result) do
                    if table == "[[]]" or table == "[ [ ] ]" then

                    else
                        triggerClientEvent(player, "createPassRacks", player, v.id, v.intid)
                        interiorid = v.intid
                    end
                end
                for key, value in ipairs(table) do
                    local x, y, z = 1500.4351806641+(value.rack*1.42), -1740.7288818359, 12.6328125 + 0.9+(value.slot/5)
                    local unp = unpack(table)
                    iprint(value["gpu1"])
                    triggerClientEvent(player, "createPassObjects", player, {x, y, z}, value.state, value.selectedExchange, interiorid, value.rack, value.slot, playMarker, (value["gpu1"] or {}), (value["gpu2"] or {}), (value["gpu3"] or {}),( value["cpu"] or {}), (value["psu"] or {}))
                end
            end, connection, "SELECT * FROM testcrypto WHERE intid = ?", getElementData(marker, "crypto.entrance")
        )
        setElementPosition(player, 1503.15234375, -1727.2055664062, 13.6328125)
        setElementDimension(player, getElementData(marker, "crypto.entrance"))
    elseif getElementData(marker, "crypto.exit") then
        exMarkerPos = getElementData(marker, "crypto.exitpos")
        local exMarkerX, exMarkerY, exMarkerZ = unpack(exMarkerPos)
        setElementPosition(player, exMarkerX, exMarkerY, exMarkerZ + 1)
        setElementDimension(player, 0)
    end
end
addEventHandler("cryptoPlacePlayer", root, cryptoPlacePlayer)

addEvent("giveCryptoItemsToPlayer", true)
addEventHandler("giveCryptoItemsToPlayer", getRootElement(),
	function (player,item,value)
		if item and value then
            performance = fromJSON(value)[1]
            tdp = fromJSON(value)[2]
            name = fromJSON(value)[3]
            exports.sm_items:giveItem(player, item, 1, false, toJSON({performance, tdp, name}))
		end
	end)

addEvent("addInServer", true)
function addInServer(player, emptypos, clickedElement, data, rid)

    triggerClientEvent(player, "addInClients", player, emptypos, clickedElement, data, rid)

end
addEventHandler("addInServer", root, addInServer)

addEvent("addInServerToHand", true)
function addInServerToHand(player, realPlayer, data)
    outputChatBox("triggered")
    triggerClientEvent(player, "addInClientsToHand", player, realPlayer, data)

end
addEventHandler("addInServerToHand", root, addInServerToHand)

local createdComputer = {}

addEvent("destroyCreatedPCFromHand",true)
function destroyCreatedPCFromHand(player, vga1, vga2, vga3, cpu, psu)
    if isElement(createdComputer[player]) then
        for k, v in pairs(psu) do
            print("psu")
            exports.sm_items:takeItemWithData(player, 130, v["data1"], "data1")
        end
        for k, v in pairs(cpu) do
            print("cpu")
            exports.sm_items:takeItemWithData(player, 128, v["data1"], "data1")
        end
        for k, v in pairs(vga1) do
            print("vga")
            exports.sm_items:takeItemWithData(player, 129, v["data1"], "data1")
        end
        for k, v in pairs(vga2) do
            print("vga2")
            exports.sm_items:takeItemWithData(player, 129, v["data1"], "data1")
        end
        for k, v in pairs(vga3) do
            print("vga3")
            exports.sm_items:takeItemWithData(player, 129, v["data1"], "data1")
        end
        setElementData(player,"crypto.hasCreatedComputer",false)
        destroyElement(createdComputer[player])
		toggleControl(player,"fire", true)
		toggleControl(player,"sprint", true)
		toggleControl(player,"crouch", true)
		toggleControl(player,"jump", true)
		toggleControl(player,"enter_exit", true)
    end
end
addEventHandler("destroyCreatedPCFromHand",getRootElement(),destroyCreatedPCFromHand)

addEvent("createCreatedPCToHand",true)
function createCreatedPCToHand(player,componenttable)
    if not isElement(createdComputer[player]) then
        setElementData(player,"crypto.hasCreatedComputer",true)
        createdComputer[player] = createObject(7537, 0, 0, 0)
        local vga1 = componenttable[1]
        local vga2 = componenttable[2]
        local vga3 = componenttable[3]
        local cpu = componenttable[4]
        local psu = componenttable[5]
        setElementDimension(createdComputer[player], getElementDimension(player))
        setElementData(createdComputer[player],"crypto.vga1",vga1 or {})
        setElementData(createdComputer[player],"crypto.vga2",vga2 or {})
        setElementData(createdComputer[player],"crypto.vga3",vga3 or {})
        setElementData(createdComputer[player],"crypto.cpu",cpu or {})
        setElementData(createdComputer[player],"crypto.psu",psu or {})
        setElementData(player,"crypto.carrying",createdComputer[player])
        exports.sm_boneattach:attachElementToBone(createdComputer[player], player,3, 0, 0.7, 0, 0, 0, 0)    
        setPedAnimation(player, "CARRY", "crry_prtial", 0, true, false, true, true)
		toggleControl(player,"fire", false)
		toggleControl(player,"sprint", false)
		toggleControl(player,"crouch", false)
		toggleControl(player,"jump", false)
		toggleControl(player,"enter_exit", false)
    end
end
addEventHandler("createCreatedPCToHand",getRootElement(),createCreatedPCToHand)


local removedComputer = {}

addEvent("destroyRemovedPCFromHand",true)
function destroyRemovedPCFromHand(player)
    if isElement(removedComputer[player]) then
        destroyElement(removedComputer[player])
		toggleControl(player,"fire", true)
		toggleControl(player,"sprint", true)
		toggleControl(player,"crouch", true)
		toggleControl(player,"jump", true)
		toggleControl(player,"enter_exit", true)
    end
end
addEventHandler("destroyRemovedPCFromHand",getRootElement(),destroyRemovedPCFromHand)

addEvent("createRemovedPCToHand",true)
function createRemovedPCToHand(player)
    if not isElement(removedComputer[playerSource]) then
        removedComputer[player] = createObject(7537, 0, 0, 0)
        setElementDimension(removedComputer[player], getElementDimension(player))
        exports.sm_boneattach:attachElementToBone(removedComputer[player], player,3, 0, 0.7, 0, 0, 0, 0)    
        setPedAnimation(player, "CARRY", "crry_prtial", 0, true, false, true, true)
		toggleControl(player,"fire", false)
		toggleControl(player,"sprint", false)
		toggleControl(player,"crouch", false)
		toggleControl(player,"jump", false)
		toggleControl(player,"enter_exit", false)
    end
end
addEventHandler("createRemovedPCToHand",getRootElement(),createRemovedPCToHand)

addEvent("removeInServer", true)
function removeInServer(player, colid, rack)

    triggerClientEvent(player, "removeInClients", player, colid, rack)

end
addEventHandler("removeInServer", root, removeInServer)

function saveCryptoPlaces()
    for k,v in ipairs(getElementsByType("marker")) do
        if getElementData(v, "crypto.data") then
            --iprint(getElementData(v, "crypto.data"))
            dbExec(connection, "UPDATE cryptoplaces SET cryptodata = ?, cryptoBalance = ? WHERE id = ?", toJSON(getElementData(v, "crypto.data") or {}), toJSON(getElementData(v, "crypto.balance") or {}), getElementData(v, "crypto.entrance"))
        end
    end
end
addEventHandler("onResourceStop", resourceRoot, saveCryptoPlaces)

addEvent("destroyFromHand", true)
function destroyFromHand(player, data)
    iprint(data)
    triggerClientEvent(player, "destroyFrom")

end
addEventHandler("destroyFromHand", root, destroyFromHand)