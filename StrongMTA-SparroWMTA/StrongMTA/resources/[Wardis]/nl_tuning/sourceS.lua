addEvent("buyTuning",true)
addEventHandler("buyTuning",resourceRoot,
	function(player,vehicle,price,pricetype,elementdata,data)
		if player and vehicle then
			local amount = getElementData(player,"char." .. pricetype)
			setElementData(player,"char." .. pricetype,amount-price)
			if elementdata and data then
				setElementData(vehicle,elementdata,data)
			end
		end
	end
)

addEvent("changeSteering",true)
addEventHandler("changeSteering",resourceRoot,
	function(player,vehicle,price,pricetype,steer)
		if player and vehicle then
			local amount = getElementData(player,"char." .. pricetype)
			setElementData(player,"char." .. pricetype,amount-price)
			
			setVehicleHandling(vehicle,"steeringLock",steer)
		end
	end
)

addEvent("removePP",true)
addEventHandler("removePP",resourceRoot,
	function(player,price)
		if player and price then
			local amount = getElementData(player,"char.PP")
			setElementData(player,"char.PP",amount-price)
		end
	end
)

addEvent("tryBuyPlate",true)
addEventHandler("tryBuyPlate",resourceRoot,
	function(player,vehicle,old_text,text,style)
		if player and text then
			if old_text ~= text then
				--if exports.reach_vehicles:isPlateOccupied(text) then
					--core:togInfobox(player,"error","A kiválasztott #d6af42rendszám#dedede már forgalomban van!")
				--else
					setElementData(vehicle,"danihe->vehicles->plate",text)
					setElementData(vehicle,"danihe->vehicles->plateStyle",style)

					triggerClientEvent(player,"succesPlateBuy",player)
				--end
			else
				setElementData(vehicle,"danihe->vehicles->plate",text)
				setElementData(vehicle,"danihe->vehicles->plateStyle",style)

				triggerClientEvent(player,"succesPlateBuy",player)
			end
		end
	end
)

addEvent("addOpticalTuning",true)
addEventHandler("addOpticalTuning",resourceRoot,
	function(player,vehicle,price,pricetype,slot,opticalID)
		if player and vehicle then
			local amount = getElementData(player,"char." .. pricetype)
			setElementData(player,"char." .. pricetype,amount-price)
			if slot and opticalID then
				if opticalID == 0 then
					removeVehicleUpgrade(vehicle,getVehicleUpgradeOnSlot(vehicle,slot))
				else
					addVehicleUpgrade(vehicle,opticalID)
				end
			end
		end
	end
)

addEvent("addCustomExhaust",true)
addEventHandler("addCustomExhaust",resourceRoot,
	function(player,vehicle,price,pricetype,id)
		if player and vehicle then
			local amount = getElementData(player,"char." .. pricetype)
			setElementData(player,"char." .. pricetype,amount-price)
			
			setElementData(vehicle,"danihe->tuning->customexhaust",id)
		end
	end
)

addEvent("recolorVehicle",true)
addEventHandler("recolorVehicle",resourceRoot,
	function(player,vehicle,paintID,r,g,b)
		if player and vehicle then
			if paintID == 1 then
				setElementData(vehicle,"danihe->vehicles->bodyColor",{r,g,b})
			elseif paintID == 2 then
				local r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(vehicle,true)
				setVehicleColor(vehicle,r1,g1,b1,r,g,b,r3,g3,b3,r4,g4,b4)
			elseif paintID == 3 then
				local r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(vehicle,true)
				setVehicleColor(vehicle,r1,g1,b1,r2,g2,b2,r,g,b,r4,g4,b4)
			elseif paintID == 4 then
				local r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(vehicle,true)
				setVehicleColor(vehicle,r1,g1,b1,r2,g2,b2,r3,g3,b3,r,g,b)
			elseif paintID == 5 then
				setVehicleHeadLightColor(vehicle,r,g,b)
			end
		end
	end
)

addEvent("fillNitro",true)
addEventHandler("fillNitro",resourceRoot,
	function(player,vehicle,price,pricetype)
		if player and vehicle then
			local amount = getElementData(player,"char." .. pricetype)
			setElementData(player,"char." .. pricetype,amount-price)

			setElementData(vehicle,"danihe->tuning->nitroprecent",100)
		end
	end
)

--// Teljesítmény tuning betöltés
addEventHandler("onElementDataChange",root,
	function(data,old,new)
		if getElementType(source) == "vehicle" then
			local vehicle = source
			if findPerformanceByData(data,1) then
				if not old then old = 0 end

				local tuning_table = findPerformanceByData(data,tonumber(new)+1)
				local old_tuning_table = findPerformanceByData(data,tonumber(old)+1)
				local now_handling = getVehicleHandling(vehicle)[tuning_table[1]]
				setVehicleHandling(vehicle,tuning_table[1],now_handling-old_tuning_table[2])

				local new_handling = getVehicleHandling(vehicle)[tuning_table[1]]
				setVehicleHandling(vehicle,tuning_table[1],new_handling+tuning_table[2])
			end

			if data == "danihe->tuning->nitro" then
				if new == 1 then
					setElementData(vehicle,"danihe->tuning->nitroprecent",100)
					addVehicleUpgrade(vehicle,1010)
				else
					removeVehicleUpgrade(vehicle,1010)
				end
			end

			if data == "danihe->vehicles->drivetype" then
				if new ~= "def" then
					setVehicleHandling(source,"driveType",new)
				end
			end
			if data == "danihe->vehicles->plate" then
				setVehiclePlateText(source,new)
			end
			if data == "danihe->vehicles->variant" then
				if new > 0 then
					setVehicleVariant(source,new-1,new-1)
				else
					setVehicleVariant(source,255,255)
				end
			end
		end
	end
)


addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		local characterId = getElementData(source, "char.ID") or 0
		if characterId > 0 then
			if getElementData(source,"activeTuning") then
				createTuningMarker(getElementData(source,"activeTuning"))
			end

			local vehicle = getElementData(source,"activeVehicle") or false
			if vehicle then
				local stickers = getElementData(vehicle,"danihe->vehicles->stickers") or {}
				for k,v in ipairs(stickers) do
					if v[9] then
						table.remove(stickers,k)
					end
				end
				setElementData(vehicle,"danihe->vehicles->stickers",stickers)
			end
		end
	end
)

addEventHandler("onResourceStart",resourceRoot,
	function()
		for id,v in ipairs(tuning_markers) do
			createTuningMarker(id)
		end
	end
)

function createTuningMarker(id)
	if id then
		if tuning_markers[id] then
			local marker = createMarker(tuning_markers[id].pos[1],tuning_markers[id].pos[2],tuning_markers[id].pos[3]-1,"cylinder",2.5,116,179,71,30)

			setElementData(marker,"danihe->tuning->isMarker",true)
			setElementData(marker,"danihe->tuning->marker_id",id)
			setElementData(marker,"danihe->tuning->marker_logo",tuning_markers[id].logo)
		end
	end
end
addEvent("createTuningMarker",true)
addEventHandler("createTuningMarker",resourceRoot,createTuningMarker)

function destroyTuningMarker(id)
	if id then
		if tuning_markers[id] then
			for k,v in ipairs(getElementsByType("marker")) do
				if getElementData(v,"danihe->tuning->isMarker") then
					if getElementData(v,"danihe->tuning->marker_id") == id then
						destroyElement(v)
					end
				end
			end
		end
	end
end
addEvent("destroyTuningMarker",true)
addEventHandler("destroyTuningMarker",resourceRoot,destroyTuningMarker)

addEvent("enterTuning",true)
addEventHandler("enterTuning",resourceRoot,
	function(player,vehicle,tuning_id)
		if player and vehicle then
			local _,_,z = getElementPosition(vehicle)
			setElementFrozen(vehicle,true)
			setElementPosition(vehicle,tuning_markers[tuning_id].pos[1],tuning_markers[tuning_id].pos[2],z)
			setElementRotation(vehicle,0,0,tuning_markers[tuning_id].pos[4])
			setElementData(player,"activeVehicle",vehicle)
		end
	end
)

addEvent("exitTuning",true)
addEventHandler("exitTuning",resourceRoot,
	function(player,vehicle)
		if player and vehicle then
			setElementFrozen(vehicle,false)
			setElementData(player,"activeVehicle",false)
		end
	end
)