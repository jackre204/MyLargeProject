local connection = false

addEventHandler("onResourceStart", resourceRoot,
	function ()
		connection = exports.sm_database:getConnection()
	end)

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end)

addEventHandler("onPlayerJoin", getRootElement(),
	function ()
		if isElement(source) then
			setElementDimension(source, 6500 + math.random(500))
			setElementAlpha(source, 0)
			setElementFrozen(source, true)
		end
	end)

function checkPlayerBanState()
	if isElement(source) then
		local serial = getPlayerSerial(source)
		local qh = dbQuery(connection, "SELECT * FROM bans WHERE serial='" .. serial .. "'")
		local result, num = dbPoll(qh, -1)
		if #result > 0 then
			for k, v in ipairs(result) do
				if v then
					if v.suspended == 1 or getRealTime().timestamp < v.expireTimestamp then
						v.state = true
					end
				end
			end
		end
		triggerClientEvent(source, "checkPlayerBanState", source, ban or {})
	end
end
addEvent("checkPlayerBanState", true)
addEventHandler("checkPlayerBanState", getRootElement(), checkPlayerBanState)

addEvent("checkForAnExistingAccount", true)
addEventHandler("checkForAnExistingAccount", getResourceRootElement(),
	function ()
		local clientPlayer = client
		local clientSerial = getPlayerSerial(clientPlayer)

		if not clientPlayer then
			return
		end

		dbQuery(
			function (handle)
				local result = dbPoll(handle, 0)

				if result then
					triggerClientEvent(clientPlayer, "checkForAnExistingAccount", clientPlayer, tonumber(result[1].hasAccount) == 1)
				end
			end,
		connection, "SELECT EXISTS(SELECT 1 FROM accounts WHERE serial = ? LIMIT 1) AS hasAccount", clientSerial)
	end)

addEvent("checkCharacterName", true)
addEventHandler("checkCharacterName", getResourceRootElement(),
	function (characterName)
		if characterName then
			local clientPlayer = client

			if not clientPlayer then
				return
			end

			dbQuery(
				function (handle)
					local result = dbPoll(handle, 0)

					if result then
						triggerClientEvent(clientPlayer, "checkCharacterName", clientPlayer, tonumber(result[1].characterExists) == 1, characterName)
					end
				end,
			connection, "SELECT EXISTS(SELECT 1 FROM characters WHERE name = ? LIMIT 1) AS characterExists", characterName)
		end
	end)

function reloadPlayerCharacters(handle, sourcePlayer, accountId, fetch)
	local result = dbPoll(handle, 0)

	if result then
		if fetch then
			dbQuery(
				function (handle)
					local results = dbPoll(handle, 0)
					local characters = {}

					if results then
						for k, v in pairs(results) do
							table.insert(characters, v)
						end
					end

					triggerClientEvent(sourcePlayer, "onPlayerCharacterMade", sourcePlayer, characters)
				end,
			connection, "SELECT * FROM characters WHERE accountId = ?", accountId)
		else
			triggerClientEvent(sourcePlayer, "onPlayerCharacterMade", sourcePlayer)
		end
	else
		triggerClientEvent(sourcePlayer, "showAccountInfo", sourcePlayer, "e", "A karakter létrehozása sikertelen!\nVárj 5 másodpercet az újrapróbálkozáshoz!")
	end
end

function showInfo(player, typ, text)
	if isElement(player) then
		triggerClientEvent(player, "showAccountInfo", player, typ, text)
	end
end

addEvent("tryToCreateAccount", true)
addEventHandler("tryToCreateAccount", getResourceRootElement(),
	function (username, password, email, characterDetails)
		if username and password and email and characterDetails and type(characterDetails) == "table" then
			local clientPlayer = client

			if not clientPlayer then
				return
			end

			dbQuery(
				function (handle)
					local result = dbPoll(handle, 0)[1]

					if result and result.username == username then
						triggerClientEvent(clientPlayer, "showAccountInfo", clientPlayer, "e", "Ez a felhasználónév már foglalt!\nVárj 5 másodpercet az újrapróbálkozáshoz!")
						return
					end

					if result and result.email == email then
						triggerClientEvent(clientPlayer, "showAccountInfo", clientPlayer, "e", "Ez az e-mail cím már használatban van!\nVárj 5 másodpercet az újrapróbálkozáshoz!")
						return
					end

					passwordHash(password, "bcrypt", {}, function (hashedPassword)
						dbQuery(
							function (handle)
								local _, _, accountId = dbPoll(handle, 0)

								if accountId then
									dbQuery(reloadPlayerCharacters, {clientPlayer, accountId}, connection, "INSERT INTO characters (accountId, name, age, weight, height, gender, description, skin) VALUES (?,?,?,?,?,?,?,?)", accountId, unpack(characterDetails))
								else
									triggerClientEvent(clientPlayer, "showAccountInfo", clientPlayer, "e", "A felhasználó létrehozása sikertelen!\nVárj 5 másodpercet az újrapróbálkozáshoz!")
								end
							end,
						connection, "INSERT INTO accounts (username, password, emailAddress, serial) VALUES (?,?,?,?)", username, hashedPassword, email, getPlayerSerial(clientPlayer))
					end)
				end,
			connection, "SELECT username, emailAddress FROM accounts WHERE username = ? OR emailAddress = ? LIMIT 1", username, email)
		end
	end)

addEvent("tryToCreateCharacter", true)
addEventHandler("tryToCreateCharacter", getResourceRootElement(),
	function (characterDetails)
		if characterDetails and type(characterDetails) == "table" then
			local clientPlayer = client

			if not clientPlayer then
				return
			end

			dbQuery(
				function (handle)
					local result = dbPoll(handle, 0)[1]

					if not result or not result.accountId then
						triggerClientEvent(clientPlayer, "showAccountInfo", clientPlayer, "e", "Hiba történt, kérlek próbáld újra!")
						return
					end

					dbQuery(reloadPlayerCharacters, {clientPlayer, result.accountId, true}, connection, "INSERT INTO characters (accountId, name, age, weight, height, gender, description, skin) VALUES (?,?,?,?,?,?,?,?)", result.accountId, unpack(characterDetails))
				end,
			connection, "SELECT accountId FROM accounts WHERE serial = ?", getPlayerSerial(clientPlayer))
		end
	end)

addEvent("onLoginRequest", true)
addEventHandler("onLoginRequest", getResourceRootElement(),
	function (username, password, rememberMe)
		if username and password then
			local clientPlayer = client

			if not clientPlayer then
				return
			end

			dbQuery(
				function (handle)
					local result = dbPoll(handle, 0)

					if #result == 0 then
						triggerClientEvent(clientPlayer, "showAccountInfo", clientPlayer, "e", "Rossz felhasználónév és/vagy jelszó!\nVárj 10 másodpercet az újrapróbálkozáshoz!", true)
						return
					end

					local row = result[1]

					passwordVerify(password, row.password, {}, function (matches)
						if matches then
							loginPlayer(clientPlayer, row, rememberMe)
						else
							triggerClientEvent(clientPlayer, "showAccountInfo", clientPlayer, "e", "Rossz felhasználónév és/vagy jelszó!\nVárj 10 másodpercet az újrapróbálkozáshoz!", true)
						end
					end)
				end,
			connection, "SELECT * FROM accounts WHERE username = ? LIMIT 1", username)
		end
	end)

addEvent("onLoginRequestWithToken", true)
addEventHandler("onLoginRequestWithToken", getResourceRootElement(),
	function (username, accessToken)
		if username and accessToken then
			local clientPlayer = client

			if not clientPlayer then
				return
			end

			dbQuery(
				function (handle)
					local result = dbPoll(handle, 0)

					if #result == 0 then
						triggerClientEvent(clientPlayer, "showAccountInfo", clientPlayer, "e", "Rossz felhasználónév és/vagy jelszó!\nVárj 10 másodpercet az újrapróbálkozáshoz!", true)
						return
					end

					loginPlayer(clientPlayer, result[1], true)
				end,
			connection, "SELECT accounts.* FROM access_tokens JOIN accounts ON accounts.accountId = access_tokens.accountId WHERE accounts.username = ?", username)
		end
	end)

local codeAlphabet = {
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
	"0","1","2","3","4","5","6","7","8","9"
}

function generateToken(length)
	local token = ""

	length = length or 16

	--math.randomseed(getTickCount() + math.random(getTickCount()))

	for i = 1, length do
		token = token .. codeAlphabet[math.random(#codeAlphabet)]
	end

	return token
end

function loginPlayer(player, acc, rememberMe)
	local playerSerial = getPlayerSerial(player)

	if acc.serial == "0" then
		acc.serial = playerSerial do
			dbExec(connection, "UPDATE accounts SET serial = ? WHERE accountId = ?", playerSerial, acc.accountId)
		end
	end

	if acc.serial ~= playerSerial then
		triggerClientEvent(player, "showAccountInfo", player, "e", "Ez a fiók nem a Te gépedhez van társítva!", true)
		return
	end

	if acc.suspended == 1 then
		triggerClientEvent(player, "showAccountInfo", player, "e", "Ez a fiók határozatlan ideig fel van függesztve!", true)
		return
	end

	local newToken = false

	if rememberMe then
		newToken = generateToken() do
			dbExec(connection, "INSERT INTO access_tokens (accountId, token) VALUES (?,?) ON DUPLICATE KEY UPDATE token = VALUES(token)", acc.accountId, newToken)
		end
	end

	setElementData(player, "acc.Name", acc.username, false)
	setElementData(player, "acc.adminLevel", acc.adminLevel)
	setElementData(player, "acc.adminNick", acc.adminNick)
	setElementData(player, "acc.premiumPoints", acc.premiumPoints)

	dbExec(connection, "UPDATE accounts SET lastLogin = ? WHERE accountId = ?", getRealTime().timestamp, acc.accountId) do
		dbQuery(
			function (handle)
				local results, affectedRows = dbPoll(handle, 0)
				local characters = {}

				if results then
					for k, v in pairs(results) do
						table.insert(characters, v)
					end
				end

				triggerClientEvent(player, "onSuccessLogin", player, characters, affectedRows, newToken, acc.maximumCharacters)
			end,
		connection, "SELECT * FROM characters WHERE accountId = ?", acc.accountId)
	end
end

addEvent("onCharacterSelect", true)
addEventHandler("onCharacterSelect", getResourceRootElement(),
	function (characterId, data)
		if characterId and tonumber(characterId) and data and type(data) == "table" then
			local thePlayer = client

			if thePlayer then
				spawnPlayer(thePlayer, data.posX, data.posY, data.posZ, data.rotZ, data.skin, data.interior, data.dimension)

				setTimer(setElementPosition, 1000, 1, thePlayer, data.posX, data.posY, data.posZ)
				setPedRotation(thePlayer, data.rotZ)

				setElementInterior(thePlayer, data.interior)
				setElementDimension(thePlayer, data.dimension)

				setElementModel(thePlayer, data.skin)
				setElementData(thePlayer, "char.Skin", data.skin)

				setPedRotation(thePlayer, data.rotZ)
				setElementAlpha(thePlayer, 255)

				setElementHealth(thePlayer, data.health)
				setPedArmor(thePlayer, data.armor)

				setElementData(thePlayer, "visibleName", data.name)
				setPlayerName(thePlayer, data.name)

				setElementData(thePlayer, "char.accID", data.accountId)
				setElementData(thePlayer, "char.ID", characterId)
				setElementData(thePlayer, "char.Name", data.name)
				setElementData(thePlayer, "char.Age", data.age, false)
				setElementData(thePlayer, "char.Description", data.description, false)
				setElementData(thePlayer, "char.Weight", data.weight, false)
				setElementData(thePlayer, "char.Height", data.height, false)
				setElementData(thePlayer, "char.Gender", data.gender, false)
				setElementData(thePlayer, "char.Hunger", data.hunger)
				setElementData(thePlayer, "char.Thirst", data.thirst)
				setElementData(thePlayer, "char.Money", data.money)
				setElementData(thePlayer, "char.bankMoney", data.bankMoney)
				setElementData(thePlayer, "char.playTimeForPayday", data.playTimeForPayday)
				setElementData(thePlayer, "char.slotCoins", data.slotCoins)
				setElementData(thePlayer, "char.playedMinutes", data.playedMinutes)
				setElementData(thePlayer, "char.maxVehicles", data.maxVehicles)
				setElementData(thePlayer, "char.interiorLimit", data.interiorLimit)
				setElementData(thePlayer, "char.Job", data.job)

				if data.bulletDamages then
					bulletDamages = fromJSON(data.bulletDamages)
				else
					bulletDamages = {}
				end

				setElementData(thePlayer, "bulletDamages", bulletDamages)
				
				
				setElementData(thePlayer, "char.CompanyRank", tostring(data.company_rank))
				setElementData(thePlayer, "char.CompanyID", data.company)
				setElementData(thePlayer, "char.CompanyTaxPayed", data.company_tax_payed)
				
				if data.radio > 0 then
					setElementData(thePlayer, "char.Radio", data.radio)
				end

				if data.radio2 > 0 then
					setElementData(thePlayer, "char.Radio2", data.radio2)
				end

				if data.paintOnPlayerTime > 0 then
					setElementData(thePlayer, "paintOnPlayerTime", data.paintOnPlayerTime)
				end

				if data.clothesLimit then
					setElementData(thePlayer, "clothesLimit", data.clothesLimit or 2)

					if data.boughtClothes and data.boughtClothes ~= "[[]]" and utfLen(data.boughtClothes) > 0 then
						setElementData(thePlayer, "boughtClothes", data.boughtClothes)
					end

					if data.currentClothes and data.currentClothes ~= "[[]]" and utfLen(data.currentClothes) > 0 then
						setElementData(thePlayer, "currentClothes", data.currentClothes)
					end
				end

				if data.weaponSkills and utfLen(data.weaponSkills) > 0 then
					local skills = split(data.weaponSkills, ",")

					for i = 0, 10 do
						setPedStat(thePlayer, 69 + i, tonumber(skills[i + 1]))
					end
				end

				if data.actionBarItems and utfLen(data.actionBarItems) > 0 then
					local items = split(data.actionBarItems, ";")
					local temp = {}

					for i = 1, 6 do
						if items[i] then
							temp[i] = tonumber(items[i])
						else
							temp[i] = false
						end
					end

					setElementData(thePlayer, "actionBarItems", temp)
				end

				if #data.playerRecipes > 0 then
					local recipes = split(data.playerRecipes, ",")
					local temp = {}

					for i = 1, #recipes do
						temp[tonumber(recipes[i])] = true
					end

					setElementData(thePlayer, "playerRecipes", temp)
				end

				setElementData(thePlayer, "isPlayerDeath", data.isPlayerDeath == 1)

				if #data.groups > 0 then
					local groups = fromJSON(data.groups)

					if groups then
						local playerGroups = {}

						for k, v in pairs(groups) do
							playerGroups[tonumber(v.groupId)] = v.data
						end

						setElementData(thePlayer, "player.groups", playerGroups)

						if data.inDuty ~= 0 and playerGroups[data.inDuty] then
							setElementData(thePlayer, "inDuty", data.inDuty)
							setElementModel(thePlayer, playerGroups[data.inDuty][2])
						end
					end
				end

				dbQuery(
					function (qh)
						local result = dbPoll(qh, 0)

						if result then
							setElementData(thePlayer, "acc.adminJail", result[1].adminJail)
							setElementData(thePlayer, "acc.adminJailBy", result[1].adminJailBy, false)
							setElementData(thePlayer, "acc.adminJailTimestamp", result[1].adminJailTimestamp, false)
							setElementData(thePlayer, "acc.adminJailTime", result[1].adminJailTime)
							setElementData(thePlayer, "acc.adminJailReason", result[1].adminJailReason, false)
						end
					end,
				connection, "SELECT adminJail, adminJailBy, adminJailTimestamp, adminJailTime, adminJailReason FROM accounts WHERE accountId = ?", data.accountId)

				dbQuery(
					function (qh)
						local result = dbPoll(qh, 0)[1]

						if result and result.impoundedNum > 0 then
							exports.sm_impound:informatePlayer(thePlayer)
						end
					end,
				connection, "SELECT COUNT(vehicleId) AS impoundedNum FROM vehicles WHERE impounded = 1 AND ownerId = ?", characterId)

				if data.jail == 1 then
					setElementData(thePlayer, "char.jail", 1)
					setElementData(thePlayer, "char.jailTime", data.jailTime)
					setElementData(thePlayer, "char.jailTimestamp", data.jailTimestamp, false)
					setElementData(thePlayer, "char.jailReason", data.jailReason, false)
				end

				if data.currentCustomInterior ~= 0 then
					if not getElementData(thePlayer, "acc.adminJail") and not getElementData(thePlayer, "char.jail") then
						exports.sm_interioredit:loadInterior(thePlayer, data.currentCustomInterior)
					end
				end

				setCameraTarget(thePlayer, thePlayer)
				setElementData(thePlayer, "loggedIn", true)

				triggerClientEvent(thePlayer, "onClientLoggedIn", thePlayer, data.posX, data.posY, data.posZ)
			end
		end
	end)

local payDayData = {
	interest = 0.001,	-- Kamat [ % ]
	paymentTax = 0.15,	-- Jövedelem adó [ % ]
	vehicleTax = 50,	-- Jármű adó [ $ ]
	interiorTax = 50	-- Ingatlan adó [ $ ]
}

addEventHandler("onElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "char.playedMinutes" then
			local playTimeForPayday = getElementData(source, "char.playTimeForPayday") or 60

			if playTimeForPayday - 1 <= 0 then
				setElementData(source, "char.playTimeForPayday", 60)
				onPayDay(source)
			else
				setElementData(source, "char.playTimeForPayday", playTimeForPayday - 1)
			end
		end
	end)

addCommandHandler("payday",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 9 then
			onPayDay(sourcePlayer)
		end
	end)

function onPayDay(thePlayer)
	if thePlayer then
		local characterId = tonumber(getElementData(thePlayer, "char.ID"))

		if characterId then
			local currentMoney = getElementData(thePlayer, "char.Money") or 0
			local bankMoney = getElementData(thePlayer, "char.bankMoney") or 0
			local interest = math.floor(bankMoney * payDayData.interest)

			if interest < 0 then
				interest = 0
			elseif interest > 100000000 then
				interest = 100000000
			end

			local vehicleTax = 0

			for k, v in pairs(getElementsByType("vehicle")) do
				if characterId == getElementData(v, "vehicle.owner") then
					if getVehicleType(v) ~= "BMX" then
						vehicleTax = vehicleTax + payDayData.vehicleTax
					end
				end
			end

			local interiorTax = 0
			local interiors = exports.sm_interiors:requestInteriors(thePlayer)

			if #interiors > 0 then
				for i = 1, #interiors do
					interiorTax = interiorTax + payDayData.interiorTax
				end
			end

			local payment = 0
			local groups = getElementData(thePlayer, "player.groups") or {}

			if #groups > 0 then
				for groupId in pairs(groups) do
					local rankId, rankName, rankPayment = exports.sm_groups:getPlayerRank(thePlayer, groupId)
					payment = payment + rankPayment
				end
			end

			local paymentTax = math.floor(payment * payDayData.paymentTax)
			
			local isPaymentTable = {}
			--outputChatBox("#3d7abc[StrongMTA - PayDay]: #ffffffMegérkezett a #3d7abcfizetésed.", thePlayer, 0, 0, 0, true)

			if #groups > 0 then
				--outputChatBox("    #3d7abc* Bruttó bér: #ffffff" .. payment .. " $", thePlayer, 0, 0, 0, true)
				--outputChatBox("    #d75959* Jövedelemadó: #ffffff" .. paymentTax .. " $", thePlayer, 0, 0, 0, true)
				isPaymentTable.payment = payment
				isPaymentTable.paymentTax = paymentTax
			end

			--outputChatBox("    #d75959* Jármű adó: #ffffff" .. vehicleTax .. " $", thePlayer, 0, 0, 0, true)
			--outputChatBox("    #d75959* Ingatlan adó: #ffffff" .. interiorTax .. " $", thePlayer, 0, 0, 0, true)
			--outputChatBox("    #3d7abc* Kamat: #ffffff" .. interest .. " $", thePlayer, 0, 0, 0, true)

			isPaymentTable.vehicleTax = vehicleTax
			isPaymentTable.interiorTax = interiorTax
			isPaymentTable.interest = interest

			setElementData(thePlayer, "char.bankMoney", bankMoney + interest)
			setElementData(thePlayer, "char.Money", currentMoney - vehicleTax - interiorTax - paymentTax + payment)
			
			triggerClientEvent(thePlayer, "startPayDayRender", thePlayer, isPaymentTable)
		end
	end
end