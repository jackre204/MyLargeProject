addEvent("playTurboSound", true)
addEventHandler("playTurboSound", getRootElement(),
	function (vehicle, turboLevel, players)
		if isElement(vehicle) and turboLevel and #players > 0 then
			triggerClientEvent(players, "playTurboSound", vehicle, turboLevel)
		end
	end)

addEvent("doVehicleDoorInteract", true)
addEventHandler("doVehicleDoorInteract", getRootElement(),
	function (vehicle, door, doorname)
		if isElement(source) and door then
			local doorRatio = getVehicleDoorOpenRatio(vehicle, door)

			if doorRatio <= 0 then
				setVehicleDoorOpenRatio(vehicle, door, 1, 500)

				triggerClientEvent(getElementsByType("player"), "playDoorEffect", source, vehicle, "open")

				exports.sm_chat:localAction(source, "kinyitja a " .. doorname .. "t.")
			elseif doorRatio > 0 then
				setVehicleDoorOpenRatio(vehicle, door, 0, 250)

				setTimer(triggerClientEvent, 250, 1, getElementsByType("player"), "playDoorEffect", source, vehicle, "close")
				
				exports.sm_chat:localAction(source, "becsukja a " .. doorname .. "t.")
			end

			setPedAnimation(source, "ped", "CAR_open_LHS", 300, false, false, true, false)
		end
	end)

addEvent("toggleHandBrake", true)
addEventHandler("toggleHandBrake", getRootElement(),
	function (state, normalmode)
		if isElement(source) then
			if state then
				if not normalmode then
					setElementFrozen(source, true)
				end

				setElementData(source, "vehicle.handBrake", true)
			else
				setElementFrozen(source, false)
				setElementData(source, "vehicle.handBrake", false)
			end
		end
	end)

addEvent("toggleLights", true)
addEventHandler("toggleLights", getRootElement(),
	function (vehicle)
		if isElement(vehicle) then
			local theTrailer = getVehicleTowedByVehicle(vehicle)
			if (getElementData(vehicle, "vehicle.lights") or 0) == 1 then
				setVehicleOverrideLights(vehicle, 1)
				if isElement(theTrailer) then
					setVehicleOverrideLights(theTrailer, 1)
				end
				setElementData(vehicle, "vehicle.lights", 0)
				exports.sm_chat:localAction(source, "lekapcsolta a jármű lámpáit.")
				triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/headlightoff.mp3")
			else
				setVehicleOverrideLights(vehicle, 2)
				if isElement(theTrailer) then
					setVehicleOverrideLights(theTrailer, 2)
				end
				setElementData(vehicle, "vehicle.lights", 1)
				exports.sm_chat:localAction(source, "felkapcsolta a jármű lámpáit.")
				triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/headlighton.mp3")
			end
		end
	end)

addEvent("toggleLock", true)
addEventHandler("toggleLock", getRootElement(),
	function (vehicle, nearby)
		if isElement(vehicle) then
			local vehicleId = getElementData(vehicle, "vehicle.dbID") or 0
			local adminDuty = getElementData(source, "adminDuty") or 0

			if vehicleId > 0 then
				if adminDuty == 0 then
					if not exports.sm_items:hasItemWithData(source, 1, vehicleId) then
						exports.sm_hud:showInfobox(source, "e", "Ehhez a járműhöz nincs kulcsod!")
						return
					end
				end
			else
				if adminDuty == 0 then
					local jobSpawner = getElementData(vehicle, "jobSpawner")

					if jobSpawner ~= getElementData(source, "playerID") then
						exports.sm_hud:showInfobox(source, "e", "Ehhez a járműhöz nincs kulcsod!")
						return
					end
				end
			end

			local vehicleModel = getElementModel(vehicle)

			if isVehicleLocked(vehicle) then
				setElementData(vehicle, "vehicle.locked", 0)
				setVehicleLocked(vehicle, false)

				if isPedInVehicle(source) then
					triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/unlockinside.mp3")
				else
					triggerClientEvent(nearby, "onVehicleLockEffect", vehicle)
					triggerClientEvent(nearby, "syncVehicleSound", vehicle, "3d", "files/unlockoutside.mp3")
				end
			else
				setElementData(vehicle, "vehicle.locked", 1)
				setVehicleLocked(vehicle, true)

				if isPedInVehicle(source) then
					triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/lockinside.mp3")
				else
					triggerClientEvent(nearby, "onVehicleLockEffect", vehicle)
					triggerClientEvent(nearby, "syncVehicleSound", vehicle, "3d", "files/lockoutside.mp3")
				end
			end

			if not isVehicleLocked(vehicle) then
				exports.sm_chat:localAction(source, "kinyitotta egy " .. exports.sm_vehiclenames:getCustomVehicleName(vehicleModel) .. " ajtaját.")
			else
				exports.sm_chat:localAction(source, "bezárta egy " .. exports.sm_vehiclenames:getCustomVehicleName(vehicleModel) .. " ajtaját.")
			end

			exports.sm_logs:logVehicle(source, vehicle, eventName, {
				"locked: " .. tostring(isVehicleLocked(vehicle)),
				"adminDuty: " .. tostring(adminDuty)
			})
		end
	end)

addEvent("syncVehicleSound", true)
addEventHandler("syncVehicleSound", getRootElement(),
	function (path, nearby, typ)
		if isElement(source) then
			if path then
				triggerClientEvent(nearby, "syncVehicleSound", source, typ or "3d", path)
			end
		end
	end)

addEvent("toggleEngine", true)
addEventHandler("toggleEngine", getRootElement(),
	function (vehicle, toggle)
		if isElement(vehicle) then
			local vehicleId = getElementData(vehicle, "vehicle.dbID") or 0
			local adminDuty = getElementData(source, "adminDuty") or 0

			if vehicleId > 0 then
				if adminDuty == 0 then
					if not exports.sm_items:hasItemWithData(source, 1, vehicleId) then
						exports.sm_hud:showInfobox(source, "e", "Ehhez a járműhöz nincs kulcsod!")
						return
					end
				end
			else
				if adminDuty == 0 then
					local jobSpawner = getElementData(vehicle, "jobSpawner")

					if jobSpawner ~= getElementData(source, "playerID") then
						exports.sm_hud:showInfobox(source, "e", "Ehhez a járműhöz nincs kulcsod!")
						return
					end
				end
			end

			local vehicleModel = getElementModel(vehicle)

			if toggle then
				if getElementHealth(vehicle) <= 320 then
					exports.sm_hud:showInfobox(source, "e", "A jármű motorja túlságosan sérült.")
					exports.sm_chat:localAction(source, "megpróbálja beindítani a jármű motorját, de nem sikerül neki.")
					return
				end

				if (getElementData(vehicle, "vehicle.fuel") or 50) <= 0 then
					exports.sm_hud:showInfobox(source, "e", "Nincs elég üzemanyag a járműben.")
					exports.sm_chat:localAction(source, "megpróbálja beindítani a jármű motorját, de nem sikerül neki.")
					return
				end

				exports.sm_chat:localAction(source, "beindítja egy " .. exports.sm_vehiclenames:getCustomVehicleName(vehicleModel) .. " motorját.")
			else
				exports.sm_chat:localAction(source, "leállítja egy " .. exports.sm_vehiclenames:getCustomVehicleName(vehicleModel) .. " motorját.")
			end
			
			setVehicleEngineState(vehicle, toggle)


			setElementData(vehicle, "vehicle.engine", toggle and 1 or 0)
		end
	end)

addEventHandler("onVehicleEnter", getRootElement(),
	function ()
		local vehicleType = getVehicleType(source)

		if vehicleType ~= "BMX" then
			setVehicleEngineState(source, getElementData(source, "vehicle.engine") == 1)
			setVehicleDamageProof(source, false) 
		end

		if vehicleType == "BMX" or vehicleType == "Bike" or vehicleType == "Boat" then
			setElementData(source, "vehicle.windowState", true)
		end
	end)

addCommandHandler("kiszed",
	function (sourcePlayer, commandName, targetPlayer)
		if not targetPlayer then
			outputChatBox("#7cc576[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
		else
			targetPlayer = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

			if targetPlayer then
				if targetPlayer ~= sourcePlayer then
					local playerX, playerY, playerZ = getElementPosition(sourcePlayer)
					local targetX, targetY, targetZ = getElementPosition(targetPlayer)

					if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) < 5 then
						if getElementInterior(sourcePlayer) == getElementInterior(targetPlayer) and getElementDimension(sourcePlayer) == getElementDimension(targetPlayer) then
							if isPedInVehicle(targetPlayer) then
								local targetVehicle = getPedOccupiedVehicle(targetPlayer)

								if (getElementData(targetVehicle, "vehicle.locked") or 0) == 0 then
									if not getElementData(targetPlayer, "player.seatBelt") then
										removePedFromVehicle(targetPlayer)
										setElementPosition(targetPlayer, playerX, playerY, playerZ)
										exports.sm_chat:localAction(sourcePlayer, "kirángatott valakit egy járműből.")
									else
										exports.sm_core:showMessageToPlayer(false, "A kiválasztott játékosnak be van csatolva az öve.", "error", sourcePlayer)
									end
								else
									exports.sm_core:showMessageToPlayer(false, "A jármű be van zárva.", "error", sourcePlayer)
								end
							else
								exports.sm_core:showMessageToPlayer(false, "A kiválasztott játékos nem ül járműben.", "error", sourcePlayer)
							end
						else
							exports.sm_core:showMessageToPlayer(false, "A kiválasztott játékos túl messze van tőled.", "error", sourcePlayer)
						end
					else
						exports.sm_core:showMessageToPlayer(false, "A kiválasztott játékos túl messze van tőled.", "error", sourcePlayer)
					end
				else
					exports.sm_core:showMessageToPlayer(false, "Magadat nem tudod kirángatni.", "error", sourcePlayer)
				end
			end
		end
	end)

addEventHandler("onVehicleStartEnter", getRootElement(),
	function (occupant, seat, jacked)
		if isElement(jacked) then
			cancelEvent()
			outputChatBox("#d75959[StrongMTA]: #ffffffEz NonRP-s kocsilopás. Használd a #d75959/kiszed #ffffffparancsot!", occupant, 0, 0, 0, true)
		end
	end)

addEventHandler("onVehicleStartExit", getRootElement(),
	function (player)
		if getElementData(player, "player.seatBelt") then
			cancelEvent()
			exports.sm_hud:showInfobox(player, "e", "Kiszállás előtt csatold ki a biztonsági övet. (F5)")
		else
			local vehicleType = getVehicleType(source)

			if vehicleType ~= "Bike" and vehicleType ~= "BMX" and vehicleType ~= "Boat" then
				if isVehicleLocked(source) then
					cancelEvent()
					exports.sm_hud:showInfobox(player, "e", "A jármű be van zárva!")
				elseif getElementData(player, "cuffed") then
					cancelEvent()
				end
			end
		end
	end)