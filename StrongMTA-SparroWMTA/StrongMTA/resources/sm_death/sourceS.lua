local deathPeds = {}

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		if deathPeds[source] then
			if isElement(deathPeds[source]) then
				destroyElement(deathPeds[source])
			end

			deathPeds[source] = nil
		end
	end)

addEvent("pickupSpawnBack", true)
addEventHandler("pickupSpawnBack", getRootElement(),
	function ()
		if isElement(source) then
			if isElement(deathPeds[source]) then
				local x, y, z = getElementPosition(deathPeds[source])

				setElementPosition(source, x, y, z)
				setElementRotation(source, 0, 0, getPedRotation(deathPeds[source]))
				setElementInterior(source, getElementInterior(deathPeds[source]))
				setElementDimension(source, getElementDimension(deathPeds[source]))
				setPedAnimation(source, "ped", "FLOOR_hit_f", -1, false, false, false)

				destroyElement(deathPeds[source])
				deathPeds[source] = nil
			else
				setPedAnimation(source, false)
				setElementHealth(source, 35)
			end
		end
	end)

addEvent("spawnToHospital", true)
addEventHandler("spawnToHospital", getRootElement(),
	function ()
		if isElement(source) then
			setElementPosition(source, 1184.6053466797, -1320.2065429688, 13.576691627502)
			setElementRotation(source, 0, 0, 0)
			setElementInterior(source, 0)
			setElementDimension(source, 0)

			if isElement(deathPeds[source]) then
				destroyElement(deathPeds[source])
			end

			deathPeds[source] = nil

			setElementHealth(source, 100)
			setElementData(source, "bloodLevel", 100)
			setElementData(source, "lastRespawn", 20)

			removeElementData(source, "bulletDamages")
			removeElementData(source, "triedToHelpUp")

			if getElementData(source, "char.injureLeftFoot") then
				exports.sm_controls:toggleControl(source, {"crouch", "sprint", "jump"}, true)
			end

			if getElementData(source, "char.injureRightFoot") then
				exports.sm_controls:toggleControl(source, {"crouch", "sprint", "jump"}, true)
			end

			if getElementData(source, "char.injureLeftArm") then
				exports.sm_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, true)
			end

			if getElementData(source, "char.injureRightArm") then
				exports.sm_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, true)
			end

			removeElementData(source, "char.injureLeftFoot")
			removeElementData(source, "char.injureRightFoot")
			removeElementData(source, "char.injureLeftArm")
			removeElementData(source, "char.injureRightArm")

			removeElementData(source, "paintOnPlayerTime")
			removeElementData(source, "paintVisibleOnPlayer")
			removeElementData(source, "paintOnPlayerFace")
		end
	end)

addEvent("spawnPlayerInAether", true)
addEventHandler("spawnPlayerInAether", getRootElement(),
	function ()
		if isElement(source) then
			local playerPosX, playerPosY, playerPosZ = getElementPosition(source)
			local playerRotX, playerRotY, playerRotZ = getElementRotation(source)
			local currentInterior = getElementInterior(source)
			local currentDimension = getElementDimension(source)

			local playerId = getElementData(source, "playerID")
			local headless = isPedHeadless(source)
			local skinId = getElementModel(source)

			spawnPlayer(source, playerPosX, playerPosY, playerPosZ, 0, skinId, 111, playerId)
			setElementDimension(source, playerId)
			setElementInterior(source, 0)
			setCameraTarget(source, source)

			local deathPed = createPed(skinId, playerPosX, playerPosY, playerPosZ, playerRotZ)

			if isElement(deathPed) then
				setElementInterior(deathPed, currentInterior)
				setElementDimension(deathPed, currentDimension)
				setElementFrozen(deathPed, true)
				setPedAnimation(deathPed, "ped", "FLOOR_hit_f", -1, false, false, false)
				setElementData(deathPed, "activeAnimation", {"ped", "FLOOR_hit_f", -1, false, false, false})
				setElementData(deathPed, "invulnerable", true)
				setPedHeadless(deathPed, headless)

				local visibleName = getElementData(source, "visibleName"):gsub("_", " ")
				local deathReason = getElementData(source, "deathReason") or "ismeretlen"
				local bulletDamages = getElementData(source, "bulletDamages")

				setElementData(deathPed, "deathPed", {source, visibleName, playerId, deathReason, bulletDamages})
				setElementData(deathPed, "visibleName", visibleName)

				deathPeds[source] = deathPed
			end
		end
	end)

addEvent("killPlayerAnimTimer", true)
addEventHandler("killPlayerAnimTimer", getRootElement(),
	function ()
		if isElement(source) then
			setElementData(source, "customDeath", "elvérzett (lejárt anim idő)")
			setElementHealth(source, 0)
			setPedAnimation(source)
		end
	end)

addEvent("bringBackInjureAnim", true)
addEventHandler("bringBackInjureAnim", getRootElement(),
	function (state)
		if isElement(source) then
			if state then
				setPedAnimation(source)
			elseif isPedInVehicle(source) then
				setPedAnimation(source, "ped", "car_dead_lhs", -1, false, false, false)
			else
				setPedAnimation(source, "sweet", "sweet_injuredloop", -1, false, false, false)
			end
		end
	end)

addCommandHandler("asegit",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if getElementData(targetPlayer, "isPlayerDeath") then
						local x, y, z = getElementPosition(targetPlayer)
						local int = getElementInterior(targetPlayer)
						local dim = getElementDimension(targetPlayer)
						local skin = getElementModel(targetPlayer)
						local rot = getPedRotation(targetPlayer)

						if isElement(deathPeds[targetPlayer]) then
							x, y, z = getElementPosition(deathPeds[targetPlayer])
							int = getElementInterior(deathPeds[targetPlayer])
							dim = getElementDimension(deathPeds[targetPlayer])
							rot = getPedRotation(deathPeds[targetPlayer])

							destroyElement(deathPeds[targetPlayer])
							deathPeds[targetPlayer] = nil
						end

						removeElementData(targetPlayer, "triedToHelpUp")
						setElementData(targetPlayer, "isPlayerDeath", false)
						spawnPlayer(targetPlayer, x, y, z, rot, skin, int, dim)
						setPedAnimation(targetPlayer)
						setElementData(targetPlayer, "bloodLevel", 100)

						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminTitle = exports.sm_administration:getPlayerAdminTitle(sourcePlayer)

						outputChatBox("[StrongMTA]: #ffffffSikeresen felsegítetted a kiválasztott játékost. #6094cb(" .. targetName .. ")", sourcePlayer, 61, 122, 188, true)
						outputChatBox("[StrongMTA]: #6094cb" .. adminName .. " #fffffffelsegített téged.", targetPlayer, 61, 122, 188, true)

						exports.sm_administration:showAdminLog(adminTitle .. " " .. adminName .. " felsegítette #6094cb" .. targetName .. "#ffffff-t.", 2)
						exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName})
					else
						outputChatBox("[StrongMTA]: #ffffffA kiválasztott játékos nincs meghalva.", sourcePlayer, 215, 89, 89, true)
					end
				end
			end
		end
	end)
