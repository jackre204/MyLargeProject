local connection = exports.sm_database:getConnection()

addEvent("spawnVehicle",true)
addEventHandler("spawnVehicle",resourceRoot,
	function(player,dbid)
		if player and dbid then
			local data = dbPoll(dbQuery(connection,"SELECT * FROM companyVehicles WHERE id = ?",dbid),-1)[1]
			if data then
				local vehicle = findVehicleByDBID(data.id)
				if vehicle then
					local rand = math.random(1,#spawnPoses)
					setElementPosition(vehicle,spawnPoses[rand][1],spawnPoses[rand][2],spawnPoses[rand][3] + 1)
					setElementRotation(vehicle,0,0,spawnPoses[rand][4])

					setElementDimension(vehicle,0)
					setElementInterior(vehicle,0)

					setElementCollisionsEnabled(vehicle,true)

					setElementData(vehicle,"lastOilChange",0)
					--setElementData(vehicle,"vehicle.fuel",exports.nlrp_hud:getTheFuelTankSizeOfVehicle(getElementModel(vehicle)))
                    setElementData(vehicle,"vehicle.fuel", 27)
					setElementFrozen(vehicle,false)

					triggerClientEvent(player,"toggleVehicleCollisions",player,vehicle,false)

					setElementData(vehicle,"company.driver",player)

					setElementData(player,"char.SpawnedVehicle",vehicle)

					outputChatBox("Sikeresen lekérted a kiválasztott járművet! Menj és rakodj fel egy fuvart!")

					insertTransaction(getElementData(player,"char.CompanyID"),getElementData(player,"char.Name"):gsub("_"," ") .. " lekért egy járművet! ( " .. getVehicleNameFromShop(vehicle) .. " - ID: " .. dbid .. " )")
					
					warpPedIntoVehicle(player, vehicle)
				
				end
			end
		end
	end
)

addEvent("dropDownvehicle",true)
addEventHandler("dropDownvehicle",resourceRoot,
	function(p,v)
		if isElement(getElementData(p,"company.trailer")) then
			destroyElement(getElementData(p,"company.trailer"))
		end

		removePedFromVehicle(p)
		deLoadVehicle(v)
	end
)

function deLoadVehicle(vehicle)
	if vehicle then
		setElementFrozen(vehicle,true)
		setElementCollisionsEnabled(vehicle,false)
		setElementDimension(vehicle,30000+getElementData(vehicle,"company.vehicleID"))

		setElementData(vehicle,"company.driver",false)
	end
end

addCommandHandler("getccar",
	function(player,cmd,id)
		if getElementData(player,"acc.adminLevel") >= 1 then
			if id then
				if tonumber(id) then
					id = tonumber(id)
					local vehicle = findVehicleByDBID(id)
					if vehicle then
						if getElementDimension(vehicle) >= 30000 then
							outputChatBox("#3d7abc[StrongMTA]:#ffffff A kiválasztott jármű nincs használatban, így nem get-elheted!",player,0,0,0,true)
						else
							local x,y,z = getPositionFromElementOffset(player,4,0,0.4)
							local rx,ry,rz = getElementRotation(player)

							if setElementPosition(vehicle,x,y,z) and setElementRotation(vehicle,rx,ry,rz) then
								outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen get-elted az adott járművet!",player,0,0,0,true)
							else
								outputChatBox("#3d7abc[StrongMTA]:#ffffff Nem sikerült get-elni az adott járművet!",player,0,0,0,true)
							end
						end
					else
						outputChatBox("#3d7abc[StrongMTA]:#ffffff Nem található jármű a megadott ID-vel!",player,0,0,0,true)
					end
				else
					outputChatBox("#3d7abc[StrongMTA]:#ffffff Hibás jármű ID lett megadva!",player,0,0,0,true)
				end
			else
				outputChatBox("#3d7abc[StrongMTA]:#ffffff /" .. cmd .. " [Jármű ID]",player,0,0,0,true)
			end
		end
	end
)

addCommandHandler("gotoccar",
	function(player,cmd,id)
		if getElementData(player,"acc.adminLevel") >= 1 then
			if id then
				if tonumber(id) then
					id = tonumber(id)
					local vehicle = findVehicleByDBID(id)
					if vehicle then
						if getElementDimension(vehicle) >= 30000 then
							outputChatBox("#3d7abc[StrongMTA]:#ffffff A kiválasztott jármű nincs használatban, így nem teleportálhatsz oda hozzá!",player,0,0,0,true)
						else
							local x,y,z = getPositionFromElementOffset(vehicle,4,0,0.4)

							if setElementPosition(player,x,y,z) then
								outputChatBox("#3d7abc[StrongMTA]:#ffffff Sikeresen elteleportáltál az adott járműhöz!",player,0,0,0,true)
							else
								outputChatBox("#3d7abc[StrongMTA]:#ffffff Nem sikerült goto-zni az adott járműhöz!",player,0,0,0,true)
							end
						end
					else
						outputChatBox("#3d7abc[StrongMTA]:#ffffff Nem található jármű a megadott ID-vel!",player,0,0,0,true)
					end
				else
					outputChatBox("#3d7abc[StrongMTA]:#ffffff Hibás jármű ID lett megadva!",player,0,0,0,true)
				end
			else
				outputChatBox("#3d7abc[StrongMTA]:#ffffff /" .. cmd .. " [Jármű ID]",player,0,0,0,true)
			end
		end
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

addEvent("getPlayerPrecent",true)
addEventHandler("getPlayerPrecent",resourceRoot,
	function(player)
		if player then
			local query = dbPoll(dbQuery(connection, "SELECT * FROM companys WHERE id = ?", getElementData(player,"char.CompanyID")), -1)
			if #query > 0 then
				query = query[1]
				local rank_id = getElementData(player,"char.CompanyRank")
				local ranks = fromJSON(query.ranks)
				if ranks[tostring(rank_id)] then
					triggerClientEvent(player,"returnPrecent",player,ranks[rank_id].precent)
				end
			end
		end
	end
)

addEvent("giveLetter",true)
addEventHandler("giveLetter",resourceRoot,
	function(player, job)
		local vehicle = getPedOccupiedVehicle(player)
		local company = dbPoll(dbQuery(connection, "SELECT * FROM companys WHERE id = ?", getElementData(player,"char.CompanyID")), -1)
		company = company[1]
		local ranks = fromJSON(company.ranks)

		local data = {}
		data.plate = getVehiclePlateText(vehicle)
		data.vehicle_model = getVehicleNameFromShop(vehicle)
		data.max_weight = 40000
		data.driver = getElementData(player,"char.Name"):gsub("_"," ")
		data.date = getTimestamp()
		data.company_name = company["name"]
		local x,y,z = getElementPosition(player)
		data.start = getZoneName(x,y,z)
		data.destination = "Los Santos"
		data.product_name = job.name
		data.product_weight = job.weight
		data.product_id = "#" .. math.random(1000000,9999999)
		data.payment = (job.payment/100)*ranks[getElementData(player,"char.CompanyRank")].precent -- job.payment
		data.vehicleDistance = getElementData(vehicle, "vehicle.distance") or 0

		exports.sm_items:giveItem(player, 122, 1, false, toJSON(data))
		
	end
)

payVehicleTaxes = function()
	local query = dbPoll(dbQuery(connection, "SELECT * FROM companys"), -1)
	for _,v in ipairs(query) do
		local tax = 0
		local count = 0
		for _,row in ipairs(dbPoll(dbQuery(connection,"SELECT * FROM companyVehicles WHERE companyID = ?",v.id),-1)) do
			tax = tax + exports.danihe_carshop:getModelOriginalPrice(row.model)*vehicleTaxAmount
			count = count + 1
		end
		if tax > 0 then
			if v.balance-tax <= -10000000 then
				dbExec(connection, "DELETE FROM companys WHERE id = ?",v.id)
				dbExec(connection, "DELETE FROM companyVehicles WHERE companyID = ?",v.id)
				dbExec(connection, "DELETE FROM companyTransactions WHERE companyID = ?",v.id)

				for _,player in ipairs(getElementsByType("player")) do
					if getElementData(player,"char.CompanyID") == v.id then
						setElementData(player,"char.CompanyID",0)
					end
				end

				dbExec(connection,"UPDATE characters SET company = ? WHERE company = ?", 0,v.id)
			else
				insertTransaction(v.id,"Napi jármű adók levonva: -" .. format(tax) .. " Ft (" .. count .. " db jármű)")

				dbExec(connection,"UPDATE companys SET balance = ? WHERE id = ?", v.balance-tax,v.id)
			end
		end
	end
end

setTimer( function()
	if getRealTime().hour == 0 then
		payVehicleTaxes()
	end
end,(60*1000)*60,0)

tryToBuyVehicle = function(player,row,r,g,b,minLevel,rent)
	if row then
		if not minLevel then minLevel = 1 end
		local companyID = getElementData(player,"char.CompanyID")
		local query = dbPoll(dbQuery(connection, "SELECT * FROM companys WHERE id = ?", companyID), -1)
		if #query > 0 then
			local company = query[1]

			if rent > 0 then
				row.price = rent*(getModelRentPrice(row.id))
			end

			if company.balance >= row.price then
				if company.level >= minLevel then
					if #getCompanyVehicles(company.id) < company.vehicleSlot then
						dbExec(connection, "UPDATE companys SET balance = ? WHERE id = ?", company.balance - row.price, companyID)
						insertTransaction(companyID,getElementData(player,"char.Name"):gsub("_"," ") .. " vásárolt egy '" .. getVehicleNameFromShop(row.id) .. "' típúsú járművet! ( -" .. formatNumber(row.price) .. " Ft )")
					
						local insertQuery = dbQuery(connection, "INSERT INTO companyVehicles SET model=?,companyID=?,rent=?,color=?", row.id, companyID, rent, toJSON({r, g, b}) )
						local result, num, insertID = dbPoll(insertQuery, -1)
						if insertID then
							loadCompanyVehicle(insertID)
							iprint(row)
							outputChatBox("Sikeresen megvásároltál egy " .. getVehicleNameFromShop(row.id) .. " típúsú járművet!")
							--triggerClientEvent(player,"successVehicleBought",player)
						end
					else
						outputChatBox("Nincs több hely autót venni a vállalkozásnak!")
					end
				else
					outputChatBox("Vállalkozásod szintje nem elég magas ehhez a járműhöz!")
				end
			else
				outputChatBox("Nincs elegendő egyenlege a vállalkozásnak!")
			end
		end
	end
end
addEvent("tryToBuyVehicle",true)
addEventHandler("tryToBuyVehicle", resourceRoot, tryToBuyVehicle)

local unloadTimers = {}

addEventHandler("onPlayerQuit", getRootElement(),
	function()
		for k,v in ipairs(getElementsByType("vehicle")) do
			if getElementData(v,"company.driver") == source then
				local vehicle = v
				table.insert(unloadTimers,
					{
						timer = setTimer(function()
							deLoadVehicle(vehicle)
						end, unloadVehicleAfterQuit * 1000, 1),
						serial = getPlayerSerial(source),
					}
				)
			end
		end
	end
)

addEventHandler("onPlayerConnect", getRootElement(),
	function(_, _, _, serial)
		for k, v in ipairs(unloadTimers) do
			if v.serial == serial then
				if isTimer(v.timer) then
					killTimer(v.timer)
				end
				table.remove(unloadTimers, k)
			end
		end
	end
)