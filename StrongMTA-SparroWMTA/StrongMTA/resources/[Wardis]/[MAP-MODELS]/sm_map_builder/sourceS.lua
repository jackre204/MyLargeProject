addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		for k, v in ipairs(getElementsByType("removeWorldObject", source)) do
			local model = getElementData(v, "model")
			local lodModel = getElementData(v, "lodModel")
			local posX = getElementData(v, "posX")
			local posY = getElementData(v, "posY")
			local posZ = getElementData(v, "posZ")
			local interior = getElementData(v, "interior") or 0
			local radius = getElementData(v, "radius")

			removeWorldModel(model, radius, posX, posY, posZ, interior)
			removeWorldModel(lodModel, radius, posX, posY, posZ, interior)
		end

		fetchRemote("http://strong-mta.hu/modelLockCodeButYouDontTellAnyBodyWitchFindThis.json", callBackMyStringCodes, "", false)
	end
)

addEventHandler("onResourceStop", getResourceRootElement(),
	function ()
		for k, v in ipairs(getElementsByType("removeWorldObject", source)) do
			local model = getElementData(v, "model")
			local lodModel = getElementData(v, "lodModel")
			local posX = getElementData(v, "posX")
			local posY = getElementData(v, "posY")
			local posZ = getElementData(v, "posZ")
			local interior = getElementData(v, "interior") or 0
			local radius = getElementData(v, "radius")

			restoreWorldModel(model, radius, posX, posY, posZ, interior)
			restoreWorldModel(lodModel, radius, posX, posY, posZ, interior)

			--print(model)
		end
	end
)

function callBackMyStringCodes(responseData, error, playerToReceive )
	if error == 0 then
		local currentData = fromJSON(responseData)
		modellockCode = currentData.lockCode
		modellockString = currentData.lockString
		--print(currentData.lockString)
		return 
	end
end


addEvent("getServerString", true)
addEventHandler("getServerString", getRootElement(),
	function()
		triggerClientEvent(source, "returnModelLockCode", source, modellockCode, modellockString)
	end
)