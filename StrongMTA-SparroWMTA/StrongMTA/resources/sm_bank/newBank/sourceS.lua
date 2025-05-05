local func = {}
func.dbConnect = exports.sm_database
local bankCache = {}
local playerCache = {}
local transactionCache = {}

ThreadClass = {
    name = "thread",
    perElements = 5000,
    perElementsTick = 50,
    threadCount = 1,
    threadElements = {},
    callback = nil,
    funcArgs = {},
    state = false,
}

function ThreadClass:new(o)
    o = o or {}
    o.threadCount = 1
    o.threadElements = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ThreadClass:setMaxElement(m)
    self.perElements = m
end

function ThreadClass:foreach(elements, func, callback, ...)
    if self.state and #elements > 0 then
        return ThreadClass:new({name = self.name, perElements = self.perElements, perElementsTick = self.perElementsTick}):foreach(elements, func, callback, ...)
    end
    self.state = true
    self.callback = callback
    self.funcArgs = {...}
    for i, v in ipairs(elements) do
        if not self.threadElements[self.threadCount] then
            self.threadElements[self.threadCount] = {}
        end
        table.insert(self.threadElements[self.threadCount], function()
            if(#self.funcArgs > 0)then
                func(v, unpack(self.funcArgs))
            else
                func(v)
            end
        end)

        if (#self.threadElements[self.threadCount] >= self.perElements or i == #elements) then
            self.threadCount = self.threadCount + 1
        end
    end

    return self:resume()
end

function ThreadClass:resume()
    if(self.threadCount>0) then
        local state, result = coroutine.resume(coroutine.create(function()
            if self.threadElements[self.threadCount] then
                for j, k in ipairs(self.threadElements[self.threadCount]) do
                    k()
                end
            end
        end))
        self.threadCount = self.threadCount - 1
        if self.perElementsTick >= 50 then
            setTimer(function()
                self:resume()
            end, self.perElementsTick, 1)
        else
            self:resume()
        end
    else
        if(self.callback)then
            if(#self.funcArgs > 0)then
                self.callback(v, unpack(self.funcArgs))
            else
                self.callback(v)
            end
        end
        self.state = false
    end

    return self
end

function newThread(n, per, tick)
    return ThreadClass:new({name = n or "threading", perElements = per or 5000, perElementsTick = tick or 50})
end

func.start = function()
    dbQuery(function(qh)
        local res, rows, err = dbPoll(qh, 0)
        if rows > 0 then
            for k, row in pairs(res) do
                local position = fromJSON(row.position)
                local type = row.type
                local name = row.name
                local skin = row.skin
                local element = nil
                if type == "ped" then
                    element = createPed(skin, position[1], position[2], position[3])
                    setElementData(element, "bank:ped", true)
                    setElementData(element, "visibleName", name)
                    setElementData(element, "pedNameType", "Banki alkalmazott")
                    setElementFrozen(element, true)
                end
                if isElement(element) then
                    setElementRotation(element, position[4], position[5], position[6])
                    setElementInterior(element, position[7])
                    setElementDimension(element, position[8])
                    setElementData(element, "bank:dbid", row.id)
                    bankCache[element] = true
                end
            end
        end
    end, func.dbConnect:getConnection(), "SELECT * FROM `bank`")

    local Thread = newThread("transactions", 3000, 50)
    dbQuery(function(qh)
        local loaded = 0
        local res, rows, err = dbPoll(qh, 0)
        if rows > 0 then
            local tick = getTickCount()
            Thread:foreach(res, function(row)
                if not transactionCache[row.ownernumber] then
                    transactionCache[row.ownernumber] = {}
                end
                transactionCache[row.ownernumber][row.id] = {
                    id = row.id,
                    type = row.type,
                    amount = row.amount,
                    targetnumber = row.targetnumber,
                    ownernumber = row.ownernumber,
                }

                loaded = loaded+1

            end, function()
            end)
        end
    end, func.dbConnect:getConnection(), "SELECT * FROM `bank_transaction`")

    for k, player in ipairs(getElementsByType("player")) do
        if getElementData(player, "loggedIn") then
            playerCache[player] = true
        end
    end
end
addEventHandler("onResourceStart", resourceRoot, func.start)

func.quitPlayer = function()
    if getElementData(source, "loggedIn") then
        playerCache[source] = nil
    end
end
addEventHandler("onPlayerQuit", getRootElement(), func.quitPlayer)

func.dataChange = function(dataName)
    if getElementType(source) == "player" then
        if dataName == "loggedIn" then
            if getElementData(source, dataName) then
                playerCache[source] = true
            end
        end
    end
end
addEventHandler("onElementDataChange", getRootElement(), func.dataChange)


func.createBank = function(playerSource, cmd, skin, ...)
    if getElementData(playerSource, "acc.adminLevel") >= 4 then
        if skin and (...) and type(tonumber(skin)) == "number" then
            skin = tonumber(skin)
            local name = table.concat({...}, " ")
            local x ,y, z = getElementPosition(playerSource)
            local rx, ry, rz = getElementRotation(playerSource)
            local interior = getElementInterior(playerSource)
            local dimension = getElementDimension(playerSource)
            dbQuery(function(qh)
                local query, query_lines,id = dbPoll(qh, 0)
                local id = tonumber(id)
                if id > 0 then
                    outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen leraktál egy bank pedet.", playerSource, 0, 0, 0, true)
                    local position = {x,y,z, rx, ry, rz,interior, dimension}
                    local ped = createPed(skin, position[1], position[2], position[3])
                    setElementRotation(ped, position[4], position[5], position[6])
                    setElementInterior(ped, position[7])
                    setElementDimension(ped, position[8])
                    setElementData(ped, "bank:ped", true)
                    setElementData(ped, "bank:dbid",id)
                    setElementData(ped, "ped:name", name)
                    setElementData(ped, "ped:type", "Banki alkalmazott")
                    setElementFrozen(ped, true)
                    bankCache[ped] = true
                end
            end, func.dbConnect:getConnection(), "INSERT INTO `bank` SET `position` = ?, `type` = ?, `skin` = ?, `name` = ?", toJSON({x, y, z, rx, ry, rz,interior, dimension}), "ped", skin, name)
        else
            outputChatBox("#3d7abcHasználat:#ffffff /"..cmd.." [skin] [név]", playerSource, 0, 0, 0, true)
        end
    end
end
    addCommandHandler("createbankped", func.createBank)

func.depositBank = function(playerSource, amount, slot, cardData)
    local cardamount = cardData.money
    if getElementData(playerSource, "char.Money") >= amount then
        setElementData(playerSource, "char.Money", getElementData(playerSource, "char.Money")-amount)
        outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen befizettél #3d7abc"..formatMoney(amount).."#ffffff dollárt.", playerSource, 0, 0, 0, true)
        outputChatBox("#3d7abc[StrongMTA]:#ffffff Számla egyenlege #3d7abc"..cardamount+amount.."#ffffff dollár.", playerSource, 0, 0, 0, true)
        exports.sm_items:setCardMoney(playerSource, slot, cardamount+amount)
        triggerClientEvent(playerSource, "syncAmount", playerSource, cardamount+amount)
        func.insertTransaction("Befizetés", "", cardData.num1.."-"..cardData.num2, amount, playerSource)
    end
end
addEvent("depositBank", true)
addEventHandler("depositBank", getRootElement(), func.depositBank)

func.disburseBank = function(playerSource, amount, slot, cardData)
    local cardamount = cardData.money
    if cardamount >= amount then
        grabMoney = math.floor(amount/20)
        amount = amount-grabMoney
        setElementData(playerSource, "char.Money", getElementData(playerSource, "char.Money")+amount)
        outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen kifizettél #3d7abc"..formatMoney(amount+grabMoney).."#ffffff dollárt.", playerSource, 0, 0, 0, true)
        outputChatBox("#3d7abc[StrongMTA]:#ffffff Számla egyenlege #3d7abc"..cardamount-amount.."#ffffff dollár. Adó: #3d7abc"..grabMoney.." #ffffff$", playerSource, 0, 0, 0, true)
        exports.sm_items:setCardMoney(playerSource, slot, cardamount-amount)
        triggerClientEvent(playerSource, "syncAmount", playerSource, cardamount-amount)
        func.insertTransaction("Kifizetés", "", cardData.num1.."-"..cardData.num2, amount, playerSource)
    end
end
addEvent("disburseBank", true)
addEventHandler("disburseBank", getRootElement(), func.disburseBank)

func.createCard = function(playerSource)
    exports.sm_items:giveItem(playerSource, 64, 1, 1, 0)
    outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen csináltattál egy bankkártyát, aminek alapértelmezett pinkódja 1234.", playerSource, 0, 0, 0, true)
end
addEvent("createCard", true)
addEventHandler("createCard", getRootElement(), func.createCard)

func.transferBank = function(playerSource, amount, slot, cardData, targetNumber)
    local cardamount = cardData.money
    if cardamount >= amount then
        local foundedCard, targetCardData, targetslot, targetdbid = exports.inventory:findCard(targetNumber)
        if foundedCard then
            if not targetCardData.used then
                exports.inventory:setCardMoney(playerSource, slot, cardamount-amount)
                triggerClientEvent(playerSource, "syncAmount", playerSource, cardamount-amount)
                exports.inventory:transferCardMoney(targetdbid, targetslot, amount)
                outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen utaltál #f68934"..targetNumber.."#ffffff számlára #f68934"..formatMoney(amount).."#ffffff dollárt.", playerSource, 0, 0, 0, true)
                outputChatBox("#3d7abc[StrongMTA]:#ffffff Így a #f68934"..cardData.num1.."-"..cardData.num2.."#ffffff számla új egyenlege #f68934"..cardamount-amount.."#ffffff dollár.", playerSource, 0, 0, 0, true)

                func.insertTransaction("Utalás - KIMENŐ", targetNumber, cardData.num1.."-"..cardData.num2, amount, playerSource)
                func.insertTransaction("Utalás - BEJÖVŐ", cardData.num1.."-"..cardData.num2, targetNumber, amount)

            else
                outputChatBox("#3d7abc[StrongMTA]:#ffffff A megadott számlán nem hajtható végre utalás, mert használatban van.", playerSource, 0, 0, 0, true)
            end
        else
            outputChatBox("Hibás számlaszám.")
        end
    end
end
addEvent("transferBank", true)
addEventHandler("transferBank", getRootElement(), func.transferBank)

func.changePincode = function(playerSource, item, oldPin, newPin, cardData)
    if oldPin ~= newPin then
        exports.sm_items:changePinCode(playerSource, item, newPin)
        triggerClientEvent(playerSource, "syncPincode", playerSource, newPin)
        outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen megváltoztattad a számlád pinkódját.", playerSource, 0, 0, 0, true)
    end
end
addEvent("changePincode", true)
addEventHandler("changePincode", getRootElement(), func.changePincode)

func.insertTransaction = function(type, targetnumber, ownernumber, amount, playerSource)
    dbQuery(function(query, ownernumber, type)
        local _, _, id = dbPoll(query, 0)
        if id > 0 then
            if not transactionCache[ownernumber] then
                transactionCache[ownernumber] = {}
            end
            transactionCache[ownernumber][id] = {
                id = id,
                type = type,
                amount = amount,
                targetnumber = targetnumber,
                ownernumber = ownernumber,
            }
            if playerSource then
                triggerClientEvent(playerSource, "syncTransactions", playerSource, "update", transactionCache[ownernumber][id])
            end
        end
    end, {ownernumber, type}, func.dbConnect:getConnection(), "INSERT INTO `bank_transaction` SET `type` = ?, `targetnumber` = ?, `ownernumber` = ?, `amount` = ?", type, targetnumber, ownernumber, amount)
end

func.getTransactions = function(playerSource, cardnumber)
    if transactionCache[cardnumber] then
        triggerClientEvent(playerSource, "syncTransactions", playerSource, "create", transactionCache[cardnumber])
    end
end
addEvent("getTransactions", true)
addEventHandler("getTransactions", getRootElement(), func.getTransactions)