local connection = false

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()
	end)

addEvent("buyVehSlot", true)
addEventHandler("buyVehSlot", getRootElement(),
	function (slot)
		slot = tonumber(slot) or 0

		if slot > 0 then
			dbQuery(
				function (qh, thePlayer, price)
					if isElement(thePlayer) then
						local result = dbPoll(qh, 0)

						if result then
							local row = result[1]
							local newPP = row.premiumPoints - price

							if newPP < 0 then
								exports.sm_accounts:showInfo(thePlayer, "e", "Nincs elég prémium pontod a +slot megvásárlásához!")
							else
								setElementData(thePlayer, "acc.premiumPoints", newPP)

								local currentLimit = getElementData(thePlayer, "char.maxVehicles") or 0
								local newLimit = currentLimit + slot

								setElementData(thePlayer, "char.maxVehicles", newLimit)
								exports.sm_accounts:showInfo(thePlayer, "s", "Sikeres vásárlás!")
								triggerClientEvent(thePlayer, "buySlotOK", thePlayer)

								dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", newPP, getElementData(thePlayer, "char.accID"))
								dbExec(connection, "UPDATE characters SET maxVehicles = ? WHERE characterId = ?", newLimit, getElementData(thePlayer, "char.ID"))

								exports.sm_logs:addLogEntry("premiumshop", {
									accountId = getElementData(thePlayer, "char.accID"),
									characterId = getElementData(thePlayer, "char.ID"),
									itemId = "vehicleslot",
									amount = slot,
									oldPP = row.premiumPoints,
									newPP = newPP
								})
							end
						end
					end
				end,
			{source, slot * 100}, connection, "SELECT premiumPoints FROM accounts WHERE accountId = ? LIMIT 1", getElementData(source, "char.accID"))
		else
			exports.sm_accounts:showInfo(source, "e", "Minimum 1 slotot vásárolhatsz!")
		end
	end)

addEvent("buyIntSlot", true)
addEventHandler("buyIntSlot", getRootElement(),
	function (slot)
		slot = tonumber(slot) or 0

		if slot > 0 then
			dbQuery(
				function (qh, thePlayer, price)
					if isElement(thePlayer) then
						local result = dbPoll(qh, 0)

						if result then
							local row = result[1]
							local newPP = row.premiumPoints - price

							if newPP < 0 then
								exports.sm_accounts:showInfo(thePlayer, "e", "Nincs elég prémium pontod a +slot megvásárlásához!")
							else
								setElementData(thePlayer, "acc.premiumPoints", newPP)

								local currentLimit = getElementData(thePlayer, "char.interiorLimit") or 0
								local newLimit = currentLimit + slot

								setElementData(thePlayer, "char.interiorLimit", newLimit)
								exports.sm_accounts:showInfo(thePlayer, "s", "Sikeres vásárlás!")
								triggerClientEvent(thePlayer, "buySlotOK", thePlayer)

								dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", newPP, getElementData(thePlayer, "char.accID"))
								dbExec(connection, "UPDATE characters SET interiorLimit = ? WHERE characterId = ?", newLimit, getElementData(thePlayer, "char.ID"))

								exports.sm_logs:addLogEntry("premiumshop", {
									accountId = getElementData(thePlayer, "char.accID"),
									characterId = getElementData(thePlayer, "char.ID"),
									itemId = "interiorslot",
									amount = slot,
									oldPP = row.premiumPoints,
									newPP = newPP
								})
							end
						end
					end
				end,
			{source, slot * 100}, connection, "SELECT premiumPoints FROM accounts WHERE accountId = ? LIMIT 1", getElementData(source, "char.accID"))
		else
			exports.sm_accounts:showInfo(source, "e", "Minimum 1 slotot vásárolhatsz!")
		end
	end
)

function loadCompanyMembers(player,id)
	local query = dbPoll(dbQuery(connection, "SELECT * FROM characters WHERE company = ?", id), -1)
	local players = {}
	for k, row in ipairs(query) do
		table.insert(players,
			{dbid=row.characterId, name=row.name, rank=row.company_rank, lastOnline=row.lastOnline, taxPayed=row.company_tax_payed}
		)
	end
	triggerClientEvent(player, "returnCompanyMembers", player, players)
end
addEvent("loadCompanyMembers", true)
addEventHandler("loadCompanyMembers", resourceRoot, loadCompanyMembers)

addEvent("getCompanyDatas",true)
addEventHandler("getCompanyDatas",resourceRoot, 
	function(player,companyID,firstOpen)
		if isElement(player) and companyID then
			local query = dbPoll(dbQuery(connection, "SELECT * FROM companys WHERE id = ?", companyID), -1)
			if #query > 0 then
				local transactions = dbPoll(dbQuery(connection, "SELECT * FROM companyTransactions WHERE companyID = ?", companyID), -1)
				local vehicles = {}
				triggerClientEvent(player,"returnCompany",player,query,transactions,vehicles,firstOpen)
			end
		end
	end
)

addEvent("updateBalance",true)
addEventHandler("updateBalance",resourceRoot, 
	function(player,id,old_company_amount,amount,type)
		if isElement(player) then
			if type == "+" then
				dbExec(connection, "UPDATE companys SET balance = ? WHERE id = ?",old_company_amount+amount, id)
				setElementData(player,"char.Money",getElementData(player,"char.Money")-amount)
			elseif type == "-" then
				dbExec(connection, "UPDATE companys SET balance = ? WHERE id = ?",old_company_amount-amount, id)
				setElementData(player,"char.Money",getElementData(player,"char.Money")+amount)
			end
		end
	end
)

addEvent("editRanks",true)
addEventHandler("editRanks",resourceRoot,
	function(id,ranks)
		dbExec(connection, "UPDATE companys SET ranks = ? WHERE id = ?", toJSON(ranks), id)
	end
)

addEvent("editBalance",true)
addEventHandler("editBalance",resourceRoot,
	function(id,balance) 
		dbExec(connection, "UPDATE companys SET balance = ? WHERE id = ?", balance,id)
	end
)

addEvent("payTaxesForPlayer",true)
addEventHandler("payTaxesForPlayer",resourceRoot,
	function(sourcePlayer,player,day,oldTax)
		local time = getTimestamp()
		time = time+(86400*day)
		if isElement(player) then
			if oldTax > 0 then
				time = oldTax+(86400*day)
			end
			setElementData(player,"char.CompanyTaxPayed",time)
			dbExec(connection, "UPDATE characters SET company_tax_payed = ? WHERE characterId = ?", time, getElementData(player,"char.ID"))
		else
			dbExec(connection, "UPDATE characters SET company_tax_payed = ? WHERE characterId = ?", time, player)
		end
		loadCompanyMembers(sourcePlayer,getElementData(sourcePlayer,"char.CompanyID"))
	end
)

addEvent("kickPlayerFromCompany",true)
addEventHandler("kickPlayerFromCompany",resourceRoot,
	function(playerOrID)
		if isElement(playerOrID) then
			setElementData(playerOrID,"char.CompanyID",0)
			dbExec(connection, "UPDATE characters SET company = ? WHERE characterId = ?", 0,getElementData(playerOrID,"char.ID"))
			
			outputChatBox("Ki lettél rúgva a vállalkozásból!",playerOrID,0,0,0,true)
		else
			dbExec(connection, "UPDATE characters SET company = ? WHERE characterId = ?", 0,playerOrID)
		end
	end
)

function insertTransaction(companyID,text)
	dbExec(connection, "INSERT INTO companyTransactions SET companyID = ?, time = ?, text = ?", companyID, getTimestamp(), text)
end
addEvent("insertTransaction", true)
addEventHandler("insertTransaction", resourceRoot, insertTransaction)

addEvent("tryBuySlot", true)
addEventHandler("tryBuySlot", resourceRoot,
	function(player, companyID, type, count)
		if isElement(player) then
			if companyID and type and count then
				if getElementData(player,"acc.premiumPoints") >= count * slotPrice then
					local query = dbPoll(dbQuery(connection, "SELECT * FROM companys WHERE id = ?", companyID), -1)
					local slot = 0
					setElementData(player, "acc.premiumPoints", getElementData(player,"acc.premiumPoints") - count * slotPrice)
					if type == "member" then
						slot = query[1].memberSlot
						dbExec(connection, "UPDATE companys SET memberSlot = ? WHERE id = ?", slot + count, companyID)
						insertTransaction(companyID,getElementData(player,"char.Name"):gsub("_"," ") .. " vásárolt " .. count .." darab tag slot-ot!")
					elseif type == "vehicle" then
						slot = query[1].vehicleSlot
						dbExec(connection, "UPDATE companys SET vehicleSlot = ? WHERE id = ?", slot + count, companyID)
						insertTransaction(companyID, getElementData(player, "char.Name"):gsub("_", " ") .. " vásárolt " .. count .." darab jármű slot-ot!")
					elseif type == "level" then
						slot = query[1].level
						dbExec(connection, "UPDATE companys SET level = ?, xp = ? WHERE id = ?", slot + count, 0, companyID)
						insertTransaction(companyID, getElementData(player, "char.Name"):gsub("_", " ") .. " vásárolt " .. count .." szintet a vállalkozásnak!")
					end
				else
					outputChatBox("Nincs elegendő PP a vásárláshoz!", player, 255, 255, 255, true)
				end
			end
		end
	end
)

addEvent("promotePlayer",true)
addEventHandler("promotePlayer",resourceRoot,
	function(sourcePlayer,companyID,playerOrID,rank_now,playerName) 
		if isElement(playerOrID) then
			outputChatBox(rank_now)
			setElementData(playerOrID,"char.CompanyRank",tostring(rank_now+1))
			dbExec(connection, "UPDATE characters SET company_rank = ? WHERE characterId = ?", rank_now+1,getElementData(playerOrID,"char.ID"))
		else
			dbExec(connection, "UPDATE characters SET company_rank = ? WHERE characterId = ?", rank_now+1,playerOrID)
		end
		insertTransaction(companyID,getElementData(sourcePlayer,"char.Name"):gsub("_"," ") .. " előléptette '" .. playerName:gsub("_"," ") .."' nevű tagot!")
	end
)
addEvent("decratePlayer",true)
addEventHandler("decratePlayer",resourceRoot,
	function(sourcePlayer,companyID,playerOrID,rank_now,playerName)
		if isElement(playerOrID) then
			setElementData(playerOrID,"char.CompanyRank",tostring(rank_now-1))
			dbExec(connection, "UPDATE characters SET company_rank = ? WHERE characterId = ?", rank_now-1,getElementData(playerOrID,"char.ID"))
		else
			dbExec(connection, "UPDATE characters SET company_rank = ? WHERE characterId = ?", rank_now-1,playerOrID)
		end
		insertTransaction(companyID,getElementData(sourcePlayer,"char.Name"):gsub("_"," ") .. " lefokozta '" .. playerName:gsub("_"," ") .."' nevű tagot!")
	end
)

addCommandHandler("setcompany", 
	function(player,cmd,pName,CompanyID)
		if getElementData(player,"acc.adminLevel") >= 9 then
			if pName and CompanyID then
				local targetPlayer = exports.sm_core:findPlayer(pName)
				if targetPlayer then
					if getElementData(targetPlayer,"loggedIn") then
						if tonumber(CompanyID) then
							CompanyID = tonumber(CompanyID)
							if CompanyID >= 1 then
								local query = dbPoll(dbQuery(connection, "SELECT * FROM companys WHERE id = ?", CompanyID), -1)
								if #query > 0 then
									query = query[1]
									
									setElementData(targetPlayer,"char.CompanyID",CompanyID)
									setElementData(targetPlayer,"char.CompanyRank","1")
									dbExec(connection,"UPDATE characters SET company = ? WHERE characterId = ?", CompanyID, getElementData(targetPlayer,"char.ID"))
									dbExec(connection,"UPDATE characters SET company_rank = ? WHERE characterId = ?", 1, getElementData(targetPlayer,"char.ID"))

									outputChatBox("#3d7abc[StrongMTA]:#FFFFFF Sikeresen betetted a játékost vállalkozásba! (" .. query.name .. ")",player,0,0,0,true)
									outputChatBox("#3d7abc[StrongMTA]:#ffffff " .. getElementData(player, "acc.adminNick") .. " betett téged egy vállalkozásodba! (" .. query.name .. ")",targetPlayer,0,0,0,true)
								else
									outputChatBox("#3d7abc[StrongMTA]:#ffffff Nem található vállalkozás a megadott ID-vel!",player,0,0,0,true)
								end
							elseif CompanyID == 0 then
								setElementData(targetPlayer,"char.CompanyID",CompanyID)
								setElementData(targetPlayer,"char.CompanyRank","1")
								dbExec(connection,"UPDATE characters SET company = ? WHERE characterId = ?", CompanyID, getElementData(targetPlayer,"char.ID"))
								dbExec(connection,"UPDATE characters SET company_rank = ? WHERE characterId = ?", 1, getElementData(targetPlayer,"char.ID"))

								outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen kivetted a játékost a vállalkozásból!",player,0,0,0,true)
								outputChatBox("#3d7abc[StrongMTA]:#ffffff " .. getElementData(player, "acc.adminNick") .. " kivett téged a vállalkozásodból!",targetPlayer,0,0,0,true)
							end
						else 
							outputChatBox("#3d7abc[StrongMTA]:#ffffff Hibás vállalkozás ID lett megadva!",player,0,0,0,true)
						end
					else
						outputChatBox("#3d7abc[StrongMTA]:#ffffff A kiválasztott játékos nincs bejelentkezve!",player,0,0,0,true)
					end
				else
					outputChatBox("#3d7abc[StrongMTA]:#ffffff Nem található játékos a megadott névvel/ID-vel!",player,0,0,0,true)
				end
			else
				outputChatBox("#3d7abc[StrongMTA]:#ffffff /" .. cmd .. " [Játékos Név/ID] [Vállalkozás ID]",player,0,0,0,true)
			end
		end
	end
)

addEvent("changeCompanyText",true)
addEventHandler("changeCompanyText",resourceRoot,
	function(id,message)
		dbExec(connection, "UPDATE companys SET message = ? WHERE id = ?", message, id)
	end
)

addEvent("inviteToCompany",true)
addEventHandler("inviteToCompany",resourceRoot,
	function(player,targetPlayer,id,name)
		if isElement(player) then
			outputChatBox(getElementData(player,"char.Name"):gsub("_"," ") .. " felvett téged a " .. name .. " nevű vállalkozásba!",targetPlayer,0,0,0,true)
			setElementData(targetPlayer,"char.CompanyID",id)
			setElementData(targetPlayer,"char.CompanyRank","1")

			dbExec(connection, "UPDATE characters SET company = ? WHERE characterId = ?", id,getElementData(targetPlayer,"char.ID"))

			loadCompanyMembers(player,id)
		end
	end
)