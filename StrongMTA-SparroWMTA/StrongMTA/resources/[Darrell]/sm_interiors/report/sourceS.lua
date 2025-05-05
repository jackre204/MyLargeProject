local connection = false
local reportPrice = 200

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end
)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()

		local pedElement = createPed(37, 1480.6569824219, -1783.8521728516, 18.25, 0)

		if isElement(pedElement) then
			setElementInterior(pedElement, 0)
			setElementDimension(pedElement, 0)
			setElementFrozen(pedElement, true)
			setElementData(pedElement, "invulnerable", true)
			setElementData(pedElement, "visibleName", "Ingatlanos Dezső")
			setElementData(pedElement, "ped.type", "interiorReport", false)
			setElementData(pedElement, "pedNameType", "Ingatlan bejelentés")
			--setPedWalkingStyle(pedElement, 120)
		end

		local currentTime = getRealTime()
		local nextInteriorReport = {currentTime.year + 1900, currentTime.month + 1 + 1, 20}

		if nextInteriorReport then
			setElementData(resourceRoot, "nextInteriorReport", nextInteriorReport)
		end
	end
)

addEventHandler("onElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "loggedIn" then
			local interiorsResource = true

			if interiorsResource then
				if interiorsResource then
					local nextInteriorReport = getElementData(resourceRoot, "nextInteriorReport")

					if nextInteriorReport then
						local interiorsTable = requestInteriors(source)

						if interiorsTable then
							local notReportedInteriors = {}
							local notReportedCounter = 0

							for i = 1, #interiorsTable do
								local interiorData = interiorsTable[i]

								if interiorData then
									if string.len(interiorData["data"]["lastReport"]) > 1 then
										local dateSplit = split(interiorData["data"]["lastReport"], ".")

										if dateSplit[1] ~= nextInteriorReport[1] or dateSplit[2] ~= nextInteriorReport[2] then
											if dateSplit[3] <= nextInteriorReport[3] - 7 then
												notReportedInteriors[interiorData["interiorId"]] = true
												notReportedCounter = notReportedCounter + 1
											end
										end
									end
								end
							end

							if notReportedCounter > 0 then
								setElementData(source, "notReportedInteriors", notReportedInteriors)
							else
								setElementData(source, "notReportedInteriors", false)
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler("onPlayerClick", getRootElement(),
	function (button, state, clickedElement)
		if button == "right" and state == "up" then
			if clickedElement then
				local pedType = getElementData(clickedElement, "ped.type")

				if pedType and pedType == "interiorReport" then
					local playerX, playerY, playerZ = getElementPosition(source)
					local targetX, targetY, targetZ = getElementPosition(clickedElement)

					if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 3 then
						local nextInteriorReport = getElementData(resourceRoot, "nextInteriorReport")
						local notReportedInteriors = getElementData(source, "notReportedInteriors")

						if nextInteriorReport and notReportedInteriors then
							local interiorCount = 0
							local interiorsList = {}

							for k, v in pairs(notReportedInteriors) do
								interiorCount = interiorCount + 1
								table.insert(interiorsList, k)
							end

							if interiorCount > 0 then
								local currentMoney = getElementData(source, "char.Money") or 0

								currentMoney = currentMoney - reportPrice

								if currentMoney > 0 then
									local currentTime = getRealTime()
									local reportTime = string.format("%04d.%02d.%02d.", currentTime.year + 1900, currentTime.month + 1, currentTime.monthday)

									setElementData(source, "char.Money", currentMoney)
									setElementData(source, "notReportedInteriors", false)

									npcTalk(source, clickedElement, 1, true)
									triggerClientEvent(source, "npcTalk", source, clickedElement, 1, true, reportPrice)

									--dbExec(connection, "UPDATE interiors SET lastReport = ? WHERE interiorId IN (" .. table.concat(interiorsList) .. ")", reportTime)
								else
									npcTalk(source, clickedElement, 1, false)
									triggerClientEvent(source, "npcTalk", source, clickedElement, 1, false, reportPrice)
								end
							else
								exports.sm_hud:showInfobox(source, "e", "Minden ingatlanod be van jelentve!")
							end
						else
							exports.sm_hud:showInfobox(source, "e", "Minden ingatlanod be van jelentve!")
						end
					end
				end
			end
		end
	end
)

function npcTalk(sourcePlayer, sourcePed, stage, state)
	if state == "deleting" then
		setPedAnimation(sourcePlayer, false)
		setPedAnimation(sourcePed, false)

		if stage == 1 then
			setPedAnimation(sourcePed, "GANGS", "prtial_gngtlkA", -1, true, false, false)
			setTimer(npcTalk, 8000, 1, sourcePed, stage + 1, state)
		end
	else
		setPedAnimation(sourcePlayer, false)
		setPedAnimation(sourcePed, false)

		if stage == 1 then
			setPedAnimation(sourcePed, "GANGS", "prtial_gngtlkA", -1, true, false, false)
		elseif stage == 2 then
			setPedAnimation(sourcePlayer, "GANGS", "prtial_gngtlkA", -1, true, false, false)
		elseif stage == 3 then
			setPedAnimation(sourcePed, "GANGS", "prtial_gngtlkA", -1, true, false, false)
		elseif stage == 4 then
			setPedAnimation(sourcePlayer, "GANGS", "prtial_gngtlkA", -1, true, false, false)
		elseif stage == 5 then
			setPedAnimation(sourcePed, "GANGS", "prtial_gngtlkA", 6000, true, false, false)
		end

		if stage < 5 then
			setTimer(npcTalk, 6000, 1, sourcePlayer, sourcePed, stage + 1, state)
		end
	end
end
