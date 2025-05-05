local modelTable = {
	[603] = 2,
	[566] = 4,
	--[426] = 2,
	--[402] = 1,
	--[479] = 2,
	[579] = 1,
	--[526] = 3,
	--[503] = 2,
	--[575] = 3,
	--[507] = 1
}

addEventHandler("onClientElementStreamIn", getRootElement(),
	function()
		if getElementType(source) == "vehicle" then
			local maxVarriants = modelTable[getElementModel(source)]

			local var1, var2 = getVehicleVariant(source)

			if getElementModel(source) == 503 then
				if var1 == 1 then
					setVehicleComponentVisible(source, "extra2lokos", true)
				else
					setVehicleComponentVisible(source, "extra2lokos", false)
				end
			elseif getElementModel(source) == 479 then
				if var1 == 0 then
					setVehicleComponentVisible(source, "extra2lokos", false)
					setVehicleComponentVisible(source, "extra3logo", false)
				elseif var1 == 2 then
					setVehicleComponentVisible(source, "extra3logo", true)
					--setVehicleComponentVisible(source, "extra3logo", false)
					setVehicleComponentVisible(source, "extra2lokos", false)
				else
					setVehicleComponentVisible(source, "extra3logo", false)
					setVehicleComponentVisible(source, "extra2lokos", true)
				end
			end

			if maxVarriants then
				for k = 1, maxVarriants + 1 do
					--print(k - 1)
					setVehicleComponentVisible(source, "extra_" .. k, false)
				end 

				if var1 > maxVarriants then
					print(var1)
					setVehicleComponentVisible(source, "extra_1", true)
				else
					--print(var1 + 1)
					setVehicleComponentVisible(source, "extra_" .. var1 + 1, true)
				end
			end
		end
	end
)