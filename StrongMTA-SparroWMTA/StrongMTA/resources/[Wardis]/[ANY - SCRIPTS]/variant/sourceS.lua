addCommandHandler("setvariant", 
	function(sourcePlayer, sourceCommand, selectedVariant)
		if tonumber(selectedVariant) then
			local sourceVehicle = getPedOccupiedVehicle(sourcePlayer)

			if sourceVehicle then
				setVehicleVariant(sourceVehicle, selectedVariant, 255)
			end
		else
			outputChatBox("/" .. sourceCommand .. "[Variáns]", sourcePlayer, 255, 255, 255, true)
		end
	end
)