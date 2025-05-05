local connection = exports.lsmta_mysql:kapcsolatCallback()

local hivasok = {}
local actualTelefons = {}

function takePhotoServer(player)
	takePlayerScreenShot( player, 1920, 1080 )
end
addEvent("takePhotoServer", true)
addEventHandler("takePhotoServer", getRootElement(), takePhotoServer)


addCommandHandler("nullcall", function(player, cmd)
	setElementData(player, "inCall", false)
end)

function telefonObject(player, id, state)
	--for k, v in pairs(actualTelefons) do
	if state then
		actualTelefons[id] = createObject(7079,0,0,0)
		exports.bone_attach:attachElementToBone(actualTelefons[id],player,12,0,0,0,0,-90,0)
	else
		exports.bone_attach:detachElementFromBone(actualTelefons[id])
		destroyElement(actualTelefons[id])
	end
	--end
end
addEvent("telefonObject", true)
addEventHandler("telefonObject", getRootElement(), telefonObject)

function addPhone(playerSource)
	local phoneID = generatePhoneNumber()
	local phoneNumber = "212"..phoneID
	phoneNumber = tonumber(phoneNumber)
	local checkID = dbPoll(dbQuery(connection, "SELECT * FROM phones"), -1)
	if (checkID) then
		for k, v in ipairs(checkID) do
			if (tonumber(v["number"])) == phoneNumber then
				return addPhone(playerSource)
			end
		end
	end
	local insterT = dbQuery(connection, "INSERT INTO phones SET number = ?", phoneNumber)
	local QueryEredmeny, _, Beszurid = dbPoll(insterT, -1)
	if QueryEredmeny then
		exports.lsmta_items:giveItem(playerSource,8,tonumber(phoneNumber),1,0)
	end
end

function generatePhoneNumber()
	return math.random(1111111,9999999)
end


--[[function sendMessageToPD(playerSource, msg)
	local pX, pY, pZ = getElementPosition(playerSource)
	local factionID = 1
	if not hivasok[factionID] then
		hivasok[factionID] = {}
	end
	hivasok[factionID][tonumber(#hivasok[factionID]) + 1] = {pX, pY, pZ, msg, true, playerSource}
	for k, v in ipairs(getElementsByType("player")) do
		if (getElementData(v, "char.faction") == factionID) then
			outputChatBox("#F89406[Riasztás] #ffffffHívás érkezett! Elfogadáshoz #22A7F0/accept " .. #hivasok[factionID], v,255,255,255,true)
		end
	end
end
addEvent("sendMessageToPD", true)
addEventHandler("sendMessageToPD", getRootElement(), sendMessageToPD)

function sendMessageToES(playerSource, msg)
	local pX, pY, pZ = getElementPosition(playerSource)
	local factionID = 8
	if not hivasok[factionID] then
		hivasok[factionID] = {}
	end
	hivasok[factionID][tonumber(#hivasok[factionID]) + 1] = {pX, pY, pZ, msg, true, playerSource}
	for k, v in ipairs(getElementsByType("player")) do
		if (exports["lsmta_dashboard"]:isPlayerInFaction(v, 8)) then
			outputChatBox("#F89406[Riasztás] #ffffffHívás érkezett! Elfogadáshoz #22A7F0/accept " .. #hivasok[factionID], v,255,255,255,true)
		end
	end
end
addEvent("sendMessageToES", true)
addEventHandler("sendMessageToES", getRootElement(), sendMessageToES)

function sendMessageToFD(playerSource, msg)
	local pX, pY, pZ = getElementPosition(playerSource)
	local factionID = 4
	if not hivasok[factionID] then
		hivasok[factionID] = {}
	end
	hivasok[factionID][tonumber(#hivasok[factionID]) + 1] = {pX, pY, pZ, msg, true, playerSource}
	for k, v in ipairs(getElementsByType("player")) do
		if (getElementData(v, "char.faction") == factionID) then
			outputChatBox("#F89406[Riasztás] #ffffffHívás érkezett! Elfogadáshoz #22A7F0/accept " .. #hivasok[factionID], v,255,255,255,true)
		end
	end
end
addEvent("sendMessageToFD", true)
addEventHandler("sendMessageToFD", getRootElement(), sendMessageToFD)]]

function chatToServer(playerSource, msg)
	if playerSource then

		local dimension = getElementDimension(playerSource)
		local interior = getElementInterior(playerSource)
		local shownto = 1
		local kieg = ""
		for key, nearbyPlayer in ipairs(getElementsByType( "player" )) do
			local dist = getElementDistance( playerSource, nearbyPlayer )

			if dist < 20 then
				local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
				local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

				if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
					local logged = getElementData(nearbyPlayer, "loggedin")
					if not (isPedDead(nearbyPlayer)) and (logged) then
						local message2 = message
						local pveh = getPedOccupiedVehicle(playerSource)
						local jatekos = nearbyPlayer
						outputChatBox(getElementData(playerSource, "charname") .. " mondja (telefon): #e7d9b0" .. msg.. "", jatekos, 255, 255, 255, true)

						shownto = shownto + 1
					end
				end
			end
		end
	end
end
addEvent("chatToServer", true)
addEventHandler("chatToServer", getRootElement(), chatToServer)

function sendMessageToLC(playerSource, msg)
	local pX, pY, pZ = getElementPosition(playerSource)
	local factionID = 3
	if not hivasok[factionID] then
		hivasok[factionID] = {}
	end
	hivasok[factionID][tonumber(#hivasok[factionID]) + 1] = {pX, pY, pZ, msg, true, playerSource}
	for k, v in ipairs(getElementsByType("player")) do
		if (getElementData(v, "char.faction") == factionID) then
			outputChatBox("#F89406[Warning] #ffffffA telefonod csörög! Felvételhez: #22A7F0/accept " .. #hivasok[factionID], v,255,255,255,true)
		end
	end
end
addEvent("sendMessageToLC", true)
addEventHandler("sendMessageToLC", getRootElement(), sendMessageToLC)

--[[function acceptCall(playerSource, cmd, id)
	if (id) then
		id = tonumber(id)
		local factionID = 8
		if hivasok[8] then
			if hivasok[factionID][id] then
				if hivasok[factionID][id][5] then
					hivasok[factionID][id][5] = false
					triggerClientEvent(playerSource, "acceptCallInClient", playerSource, hivasok[factionID][id][1], hivasok[factionID][id][2], hivasok[factionID][id][3])
					for k, v in ipairs(getElementsByType("player")) do
						if (exports["lsmta_dashboard"]:isPlayerInFaction(v, 8)) then
							outputChatBox("#22A7F0" .. string.gsub(getPlayerName(playerSource), "_", " ") .. " #fffffffogadta a következő hívást: " .. id .. " ((Feladó: #22A7F0" .. string.gsub(getPlayerName(hivasok[factionID][id][6]), "_", " ") .. "#ffffff))",v,255,255,255,true)
						end
					end
				else
					outputChatBox("#D64541[Hiba] #ffffffEzt azt a hívást már fogadták!", playerSource,255,255,255,true)
				end
			else
				outputChatBox("#D64541[Hiba] #ffffffNincs ilyen hívás!", playerSource,255,255,255,true)
			end
		else
			outputChatBox("#D64541[Hiba] #ffffffNincs ilyen hívás!", playerSource,255,255,255,true)
		end
	else
		outputChatBox("#F89406[Help] #ffffff/" .. cmd .. " [HÍVÁSID]", playerSource,255,255,255,true)
	end
end
addCommandHandler("accept", acceptCall)]]





function checkOnline(phoneNumber)
	for k, v in ipairs(getElementsByType("player")) do
		if v and phoneNumber and exports.lsmta_items:hasItem(v,8,phoneNumber) then
			return v
		end
	end
	return false
end


function checkNumberExists(player, number)
	local numberQuery = dbQuery( connection, "SELECT `number` FROM `phones`")
	local numberResult, count = dbPoll ( numberQuery, -1 )
	number = tonumber(number)
	if numberResult then
		local found = false
		for k, v in pairs(numberResult) do
			if v.number == number then
				found = true
			end
		end
		if not found then
			outputChatBox("#d9534f[LSRP]: #FFFFFFIlyen telefonszámon a kiszolgáló nem található!", player, 255, 0, 0, true)
		else
			if checkPlayerOnline(number) then
				triggerClientEvent(player, "syncSentMessageToClient", player) -- TODO: folytatni , FIGY!: másik playert kikeresni
			else
				outputChatBox("#d9534f[LSRP]: #FFFFFFA telefonszámhoz tartozó játékos nem online!", player, 255, 0, 0, true)
			end
		end
	end
end
addEvent("checkNumberExists", true)
addEventHandler("checkNumberExists", getRootElement(), checkNumberExists)

function sendMessageServer(player, message, playerNumber, targetNumber)
	number = tonumber(number)
	local targetPlayer = checkPlayerOnline(targetNumber)
	if not targetPlayer then
		-- // Nem található online a player
		outputChatBox("#d9534f[LSRP]: #FFFFFFA telefonszámhoz tartozó játékos nem online!", player, 255, 0, 0, true)
	else
		triggerClientEvent(player, "syncSentMessageToClient", player, message, playerNumber, targetNumber) -- senderPlayer
		triggerClientEvent(targetPlayer, "syncSentMessageToClient", targetPlayer, message, playerNumber, playerNumber, targetNumber) -- targetPlayer
		setElementData(player, "money", getElementData(player, "money")-8)
		exports.lsmta_global:sendLocalDoAction(targetPlayer, "Kapott egy SMS-t")
	end
end
addEvent("sendMessageServer", true)
addEventHandler("sendMessageServer", getRootElement(), sendMessageServer)

function checkPlayerOnline(number)
	for k, v in ipairs(getElementsByType("player")) do
		if v and number and exports.lsmta_items:hasItem(v,8,number) then
			return v
		end
	end
	return false
end

function saveMessageTableServer(player, number, table)
	dbExec(connection, "UPDATE phones SET messages = ? WHERE number = ?", toJSON(table), number)
end
addEvent("saveMessageTableServer", true)
addEventHandler("saveMessageTableServer", getRootElement(), saveMessageTableServer)

function getMessageTableServer(player, number)
	local messageQuery = dbQuery( connection, "SELECT `messages` FROM `phones` WHERE `number`=?", number)
	local messageResult, count = dbPoll ( messageQuery, -1 )
	if messageResult then
		if messageResult[1].messages then
			triggerClientEvent(player, "syncMessageTableClient", player, fromJSON(messageResult[1].messages), true)
		else
			triggerClientEvent(player, "syncMessageTableClient", player, false, false)
		end
	end
end
addEvent("getMessageTableServer", true)
addEventHandler("getMessageTableServer", getRootElement(), getMessageTableServer)

function saveContactTableServer(player, number, table)
	dbExec(connection, "UPDATE phones SET contact = ? WHERE number = ?", toJSON(table), number)
end
addEvent("saveContactTableServer", true)
addEventHandler("saveContactTableServer", getRootElement(), saveContactTableServer)


function getContactTableServer(player, number)
	local contactQuery = dbQuery( connection, "SELECT `contact` FROM `phones` WHERE `number`=?", number)
	local contactResult, count = dbPoll ( contactQuery, -1 )
	if contactResult then
		if contactResult[1].contact then
			triggerClientEvent(player, "syncContactTableClient", player, fromJSON(contactResult[1].contact), true)
		else
			triggerClientEvent(player, "syncContactTableClient", player, false, false)
		end
	end
end
addEvent("getContactTableServer", true)
addEventHandler("getContactTableServer", getRootElement(), getContactTableServer)

function callTargetInServer(playerSource, calledNumber, playerNumber)
	print(calledNumber)
	targetPlayer = callMember(calledNumber)
	if targetPlayer ~= false and targetPlayer ~= "inCall" then
		triggerClientEvent(playerSource, "showMenu", playerSource, calledNumber, targetPlayer, true) -- Hívás kezdeményező
		triggerClientEvent(targetPlayer, "showMenu", targetPlayer, playerNumber, playerSource, false, calledNumber) -- Hívott félnek
		triggerClientEvent(targetPlayer, "showSound", targetPlayer)
		exports.lsmta_global:sendLocalDoAction(targetPlayer, "Csörög a telefonja")
	elseif targetPlayer == "inCall" then
		outputChatBox("#e63946[LSRP] #ffffffA hívott szám foglalt!", playerSource,255,255,255,true)
	else
		outputChatBox("#e63946[LSRP] #ffffffEz a telefonszám jelenleg nem kapcsolható!", playerSource,255,255,255,true)
	end
end
addEvent("callTargetInServer", true)
addEventHandler("callTargetInServer", getRootElement(), callTargetInServer)

function acceptCallServer(callerElement, targetElement)
	triggerClientEvent(callerElement, "clientAcceptCall", callerElement, callerElement)
	triggerClientEvent(targetElement, "clientAcceptCall", targetElement, targetElement)
end
addEvent("acceptCallServer", true)
addEventHandler("acceptCallServer", getRootElement(), acceptCallServer)


function cancelCallServer(callerElement, targetElement)
	triggerClientEvent(callerElement, "clientCancelCall", callerElement, callerElement)
	triggerClientEvent(targetElement, "clientCancelCall", targetElement, targetElement)
end
addEvent("cancelCallServer", true)
addEventHandler("cancelCallServer", getRootElement(), cancelCallServer)

function sendCallMessages(playerSource, targetPlayerSource, message, number)
	triggerClientEvent(playerSource, "insertMessages", playerSource, message, number)
	triggerClientEvent(targetPlayerSource, "insertMessages", targetPlayerSource, message, number)
end
addEvent("sendCallMessages", true)
addEventHandler("sendCallMessages", getRootElement(), sendCallMessages)


function placeAdvertServer(player, text, price, numberCall, toggleContact, formOfAdvertise)
	price = math.ceil(price)
	setElementData(player, "money", getElementData(player, "money") - price)
	triggerClientEvent(getElementsByType("player"), "clientPlaceAdvertisement", source, player, text, numberCall, toggleContact, formOfAdvertise)
end
addEvent("placeAdvertServer", true )
addEventHandler("placeAdvertServer", getRootElement(), placeAdvertServer)


function setAdvertsShowingServer(player, state)
	setElementData(player, "advertShowingServer", state)
end
addEvent("setAdvertsShowingServer", true )
addEventHandler("setAdvertsShowingServer", getRootElement(), setAdvertsShowingServer)

function setSeeNionAdvertsShowingServer(player, state)
	setElementData(player, "seeNionAdvertShowingServer", state)
end
addEvent("setSeeNionAdvertsShowingServer", true )
addEventHandler("setSeeNionAdvertsShowingServer", getRootElement(), setSeeNionAdvertsShowingServer)


function callMember(number)
	for k, v in ipairs(getElementsByType("player")) do
		print(number)
		if v and number and exports.lsmta_items:hasItem(v,8,number) then
			if (getElementData(v, "inCall")) then
				return "inCall"
			else
				return v
			end
		end
	end
	return false
end

function getElementDistance( a, b )
	if not isElement(a) or not isElement(b) or getElementDimension(a) ~= getElementDimension(b) then
		return math.huge
	else
		local x, y, z = getElementPosition( a )
		return getDistanceBetweenPoints3D( x, y, z, getElementPosition( b ) )
	end
end
