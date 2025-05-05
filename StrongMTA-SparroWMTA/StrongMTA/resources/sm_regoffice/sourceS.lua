addEvent("tryToRenewLicense", true)
addEventHandler("tryToRenewLicense", getRootElement(),
	function (itemId, renewPrice, realItemId)
		if itemId then
			if exports.sm_core:takeMoneyEx(client, renewPrice, "renewLicense") then
				local items = exports.sm_items:getElementItems(client) or {}
				local data = false

				for k, v in pairs(items) do
					if v.dbID == itemId then
						data = v
						break
					end
				end

				if data then
					exports.sm_items:takeItem(client, "dbID", itemId)

					data.data1, data.data2, data.data3 = processDocumentData(client, realItemId, data.data1, data.data2, data.data3)

					exports.sm_items:giveItem(client, realItemId, 1, false, data.data1, data.data2, data.data3)

					exports.sm_hud:showInfobox(client, "s", "Sikeresen megújítottad. Új érvényesség: " .. data.data3)
				end
			else
				exports.sm_hud:showInfobox(client, "e", "Nincs nálad elég pénz az okmány megújításához!")
			end
		end
	end)

addEvent("giveDocument", true)
addEventHandler("giveDocument", getRootElement(),
	function (itemId, data1, data2, data3)
		if itemId then
			local buyPrice = 0
			-- Üres adásvételi
			if itemId == 69 then
				buyPrice = 100
			-- Horgászengedély
			elseif itemId == 66 then
				buyPrice = 200
			-- Útlevél
			elseif itemId == 67 then
				buyPrice = 350
			end
            
			if exports.sm_items:hasSpaceForItem(source, itemId) then
			    print("asd")
				if exports.sm_core:takeMoneyEx(source, buyPrice, "giveDocument") then
					data1, data2, data3 = processDocumentData(source, itemId, data1, data2, data3)

					exports.sm_items:giveItem(source, itemId, 1, false, data1, data2, data3)

					exports.sm_hud:showInfobox(source, "s", "Sikeresen kiváltottad az okmányt!")
				else
					exports.sm_hud:showInfobox(source, "e", "Nincs nálad elég pénz az okmány kiváltásához!")
				end
			else
				exports.sm_hud:showInfobox(source, "e", "Nincs elég hely az inventoydban az okmányhoz!")
			end
		end
	end)

function processDocumentData(element, itemId, data1, data2, data3)
	local currentTime = getRealTime().timestamp

	-- Személyi/Jogsi/Fegyverengedély
	if itemId == 65 or itemId == 68 or itemId == 308 then
		local expireTime = getRealTime(currentTime + 2678400)
		data1 = "-1;" .. getElementData(element, "visibleName"):gsub("_", " ")
		data2 = getElementModel(element)
		data3 = expireTime.year + 1900 .. "." .. expireTime.month + 1 .. "." .. expireTime.monthday
	-- Horgászengedély
	elseif itemId == 66 then
		data1 = "-1;" .. getElementData(element, "visibleName"):gsub("_", " ")
		data2 = getElementModel(element)
		data3 = expireTime.year + 1900 .. "." .. expireTime.month + 1 .. "." .. expireTime.monthday
	-- Útlevél
	elseif itemId == 67 then
		local nameParts = split(getElementData(element, "visibleName"), "_")
		local charGender = getElementData(element, "char.Gender") or 0

		if charGender == 0 then
			charGender = "Férfi"
		else
			charGender = "Nő"
		end

		data2 = getElementData(element, "char.Description")
		data1 = toJSON({
			name1 = nameParts[1],
			name2 = nameParts[#nameParts],
			age = getElementData(element, "char.Age"),
			sex = charGender,
			weight = getElementData(element, "char.Weight") .. " kg",
			height = getElementData(element, "char.Height") .. " cm",
			skin = getElementModel(element)
		}, true)
	elseif itemId == 74 then
		data1 = getElementData(element, "visibleName"):gsub("_", " ")..";"..data1
		data2 = data2
		data3 = data3
	end

	return data1, data2, data3
end