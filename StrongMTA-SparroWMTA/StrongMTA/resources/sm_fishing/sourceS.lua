local perishableValue = 420

local itemNames = {}
local itemPrices = {
	[221] = 1500,
	[222] = 750,
	[223] = 750,
	[224] = 750,
	[225] = 750,
	[226] = 1500,
	[227] = 150,
	[228] = 150,
	[229] = 150,
	[230] = 150,
	[231] = 150,
	[246] = 750,
	[247] = 3000,
	[248] = 150,
	[250] = 1500,
	[251] = 1500,
	[252] = 1500,
	[253] = 3000,
	[254] = 3000,
	[255] = 1500,
	[256] = 750,
	[259] = 3000,
	[260] = 3000,
	[261] = 1500,
	[351] = 1800,
	[352] = 1950,
	[353] = 750,
	[354] = 1500,
	[355] = 1500,
	[356] = 750,
	[357] = 750,
	[359] = 2100,
	[360] = 1500,
	[363] = 50000
}

local availableTradePoints = {
	{192, "Sophie Lung", 816.30609130859, 856.66107177734, 12.7890625, 260}, -- Bányató
	{158, "Az öreg halász", -315.09371948242, 811.10095214844, 15.604573249817, 110}, -- Kikötő
	{160, "Az öreg halász", 2901.1335449219, 2127.1279296875, 11.307812690735, 210},
	{161, "Az öreg halász", -2035.68359375, 2368.8308105469, 3.7380256652832, 156},
	{132, "Az öreg halász", 263.46380615234, 2895.8076171875, 10.531394958496, 34},
}

addEventHandler("onResourceStart", getRootElement(),
	function (startedResource)
		if startedResource == getThisResource() then
			for i, v in ipairs(availableTradePoints) do
				local colSphereElement = createColSphere(v[3], v[4], v[5], 2)

				if isElement(colSphereElement) then
					local pedElement = createPed(v[1], v[3], v[4], v[5], v[6], false)

					if isElement(pedElement) then
						setElementFrozen(pedElement, true)
						setElementData(pedElement, "invulnerable", true)
						setElementData(pedElement, "visibleName", v[2])
						setElementData(pedElement, "pedNameType", "Hal leadó")
					end
				end
			end

			local inventoryResource = getResourceFromName("sm_items")
			if inventoryResource then
				if getResourceState(inventoryResource) == "running" then
					itemNames = {}

					for itemId in pairs(itemPrices) do
						itemNames[itemId] = exports.sm_items:getItemName(itemId)
					end
				end
			end
		else
			if getResourceName(startedResource) == "sm_items" then
				itemNames = {}

				for itemId in pairs(itemPrices) do
					itemNames[itemId] = exports.sm_items:getItemName(itemId)
				end
			end
		end
	end
)

addEventHandler("onColShapeHit", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if isElement(source) then
			if matchingDimension then
				if getElementType(hitElement) == "player" then
					if not getPedOccupiedVehicle(hitElement) then
						local playerItems = exports.sm_items:getElementItems(hitElement)
						local rewardAmount = 0

						for k, v in pairs(playerItems) do
							if itemPrices[v.itemId] then
								local health = math.floor(100 - (tonumber(v.data3) or 0) / perishableValue * 100)
								local price = math.ceil(itemPrices[v.itemId] * health / 100)

								rewardAmount = rewardAmount + price
								exports.sm_items:takeItem(hitElement, "dbID", v.dbID)

								outputChatBox("#7cc576[SeeMTA - Horgászat]: #FFFFFFLeadtál #7cc5761 #FFFFFFdarab #7cc576" .. itemNames[v.itemId] .. "#FFFFFF-t #598ed7(" .. health .. "%)#FFFFFF, kaptál érte #7cc576" .. price .. " #FFFFFFdollárt.", hitElement, 0, 0, 0, true)
							end
						end

						if rewardAmount > 0 then
							exports.sm_core:giveMoney(hitElement, rewardAmount)
							exports.sm_hud:showInfobox(hitElement, "s", "Sikeresen leadtál " .. rewardAmount .. " $ értékű halat.")
						end
					end
				end
			end
		end
	end
)

addEvent("throwInRod", true)
addEventHandler("throwInRod", getRootElement(),
	function (waterPosX, waterPosY, waterPosZ)
		if isElement(source) then
			if waterPosX and waterPosY and waterPosZ then
				triggerClientEvent("throwInRod", source, waterPosX, waterPosY, waterPosZ)
				exports.sm_chat:localAction(source, "bedobja a horgot a vízbe.")
			end
		end
	end
)

addEvent("endFishing", true)
addEventHandler("endFishing", getRootElement(),
	function (itemId, itemName)
		if isElement(source) then
			triggerClientEvent("endFishing", source, itemId)

			if itemId and itemName then
				if exports.sm_items:hasSpaceForItem(source, itemId) then
					exports.sm_items:giveItem(source, itemId, 1)

					exports.sm_hud:showInfobox(source, "s", "Sikeresen kifogtad a halat! (" .. itemName .. ")")
					exports.sm_chat:localAction(source, "kihúz valamit a vízből.")

					outputChatBox("#7cc576[SeeMTA - Horgászat]: #FFFFFFSikeresen fogtál egy #598ed7" .. itemName .. "#FFFFFF-t.", source, 0, 0, 0, true)
				else
					outputChatBox("#d75959[SeeMTA - Horgászat]: #FFFFFFSajnos nincs elég hely az inventorydban, hogy megtartsd a halat.", source, 0, 0, 0, true)
				end
			end

			setElementFrozen(source, false)
			setPedAnimation(source, false)

			exports.sm_controls:toggleControl(source, "all", true)
			exports.sm_chat:localAction(source, "kihúzza a horgot a vízből.")
		end
	end
)

addEvent("setFishingAnim", true)
addEventHandler("setFishingAnim", getRootElement(),
	function (streamedPlayers)
		if isElement(source) then
			triggerClientEvent(streamedPlayers, "moveDownFloater", source)
			setElementFrozen(source, true)
			setPedAnimation(source, "SWORD", "sword_IDLE")
			exports.sm_controls:toggleControl(source, "all", false)
		end
	end
)

addEvent("floaterMoveStopped", true)
addEventHandler("floaterMoveStopped", getRootElement(),
	function (streamedPlayers)
		if isElement(source) then
			triggerClientEvent(streamedPlayers, "floaterMoveStopped", source)
		end
	end
)

addEvent("failTheRod", true)
addEventHandler("failTheRod", getRootElement(),
	function ()
		if isElement(source) then
			local fishingRodInHand = getElementData(source, "fishingRodInHand")
			if fishingRodInHand then
				exports.sm_items:takeItem(source, "dbID", fishingRodInHand)
				setElementData(source, "fishingRodInHand", false)
			end
		end
	end
)

addEvent("playCatchSound", true)
addEventHandler("playCatchSound", getRootElement(),
	function (streamedPlayers)
		if isElement(source) then
			triggerClientEvent(streamedPlayers, "playCatchSound", source)
		end
	end
)
