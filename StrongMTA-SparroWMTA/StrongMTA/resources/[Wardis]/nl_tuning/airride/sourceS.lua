addEvent("changeAirrideLevel",true)
addEventHandler("changeAirrideLevel",resourceRoot,
	function(player,vehicle,old_level,level)
		setElementData(vehicle,"danihe->tuning->airride_level",level)
		--exports.reach_chat:createMeMessage(player,"állít a járműve hasmagasságán.")

		local defaultHandling = exports.nl_handling:getDefaultHandling(getElementModel(vehicle))["suspensionLowerLimit"] or getOriginalHandling(getElementModel(vehicle))["suspensionLowerLimit"]

		if level == 0 then
			setVehicleHandling(vehicle,"suspensionLowerLimit",defaultHandling+0.135)
		elseif level == 1 then
			setVehicleHandling(vehicle,"suspensionLowerLimit",defaultHandling+0.09)
		elseif level == 2 then
			setVehicleHandling(vehicle,"suspensionLowerLimit",defaultHandling+0.045)
		elseif level == 3 then
			setVehicleHandling(vehicle,"suspensionLowerLimit",defaultHandling)	
		elseif level == 4 then
			setVehicleHandling(vehicle,"suspensionLowerLimit",defaultHandling-0.025)		
		elseif level == 5 then
			setVehicleHandling(vehicle,"suspensionLowerLimit",defaultHandling-0.05)		
		end

		triggerClientEvent(player,"playbackAirride",player,vehicle)
	end
)

--// Kiszerelésnél fix
addEventHandler("onElementDataChange",root,
	function(data,old,new)
		if getElementType(source) == "vehicle" then
			if data == "danihe->tuning->airride" then
				if new == 0 then
					local defaultHandling = exports.nl_handling:getDefaultHandling(getElementModel(source))["suspensionLowerLimit"] or getOriginalHandling(getElementModel(source))["suspensionLowerLimit"]
					
					setElementData(source,"danihe->tuning->airride_level",3)
					setVehicleHandling(source,"suspensionLowerLimit",defaultHandling)	
				end
			end
		end
	end
)