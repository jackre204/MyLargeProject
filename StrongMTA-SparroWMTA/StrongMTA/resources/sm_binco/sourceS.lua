addEvent("bincoBuy", true)
addEventHandler("bincoBuy", getRootElement(),
	function (buyPrice, skinId)
		if isElement(source) then
			if buyPrice and skinId then
				if exports.sm_core:takeMoneyEx(source, buyPrice, "bincoBuy") then
					setElementModel(source, skinId)
					setElementData(source, "char.Skin", skinId)
					triggerClientEvent(source, "bincoBuy", source, skinId)
				else
					exports.sm_accounts:showInfo(source, "e", "Nincs elég pénzed!")
				end
			end
		end
	end
)

addEvent("setPlayerDimensionForBinco", true)
addEventHandler("setPlayerDimensionForBinco", getRootElement(),
	function(dimension)
		if isElement(source) then
			if dimension then
				setElementDimension(source, dimension)
			end
		end
	end
)