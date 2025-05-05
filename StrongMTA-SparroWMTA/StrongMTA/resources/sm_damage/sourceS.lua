local healPositions = {
	[1] = {
		ped = {
			position = {1164.1064453125, -1315.3508300781, 15.4140625, 264},
			rotation = {0, 0, 0},
			name = "Trey Smith",
			skin = 274
		},
		marker = {
			position = {1165.5687255859, -1315.3205566406, 15.4140625 - 1}
		}
	}
}

for i = 1, #healPositions do
	local dat = healPositions[i]

	dat.ped.element = createPed(dat.ped.skin, dat.ped.position[1], dat.ped.position[2], dat.ped.position[3], dat.ped.position[4])
	dat.marker.element = createMarker(dat.marker.position[1], dat.marker.position[2], dat.marker.position[3] - 0.5, "cylinder", 1, 89, 142, 215, 200)
	dat.marker.colshape = createColSphere(dat.marker.position[1], dat.marker.position[2], dat.marker.position[3] + 1, 1)

	setElementFrozen(dat.ped.element, true)
	setElementData(dat.ped.element, "invulnerable", true)
	setElementData(dat.ped.element, "visibleName", dat.ped.name)
end

addEventHandler("onColShapeHit", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if matchingDimension then
			if getElementType(hitElement) == "player" then
				exports.sm_accounts:showInfo(hitElement, "i", "Használd az [E] betűt sérüléseid ellátásához!")
				bindKey(hitElement, "e", "up", healPlayer)
			end
		end
	end)

addEventHandler("onColShapeLeave", getResourceRootElement(),
	function (leftElement, matchingDimension)
		if getElementType(leftElement) == "player" then
			unbindKey(leftElement, "e", "up", healPlayer)
		end
	end)

function healPlayer(thePlayer)
	local onlinemedic = false
	local players = getElementsByType("player")

	for i = 1, #players do
		local player = players[i]

		if player and exports.sm_groups:isPlayerInGroup(player, 2) then
			onlinemedic = true
			break
		end
	end

	if onlinemedic then
		exports.sm_accounts:showInfo(thePlayer, "e", "Van fent mentős!")
		return
	end

	local injureLeftFoot = getElementData(thePlayer, "char.injureLeftFoot")
	local injureRightFoot = getElementData(thePlayer, "char.injureRightFoot")
	local injureLeftArm = getElementData(thePlayer, "char.injureLeftArm")
	local injureRightArm = getElementData(thePlayer, "char.injureRightArm")

	local damages = getElementData(thePlayer, "bulletDamages") or {}
	local damageCount = 0

	for k, v in pairs(damages) do
		damageCount = damageCount + 1
	end

	if injureLeftFoot or injureRightFoot or injureLeftArm or injureRightArm or damageCount > 0 or getElementHealth(thePlayer) <= 20 then
		helpUpPerson(thePlayer)
		exports.sm_accounts:showInfo(thePlayer, "s", "Sikeresen ellátták minden sérülésed.")
	else
		exports.sm_accounts:showInfo(thePlayer, "e", "Nem vagy megsérülve!")
	end
end

addEvent("stitchPlayerCut", true)
addEventHandler("stitchPlayerCut", getRootElement(),
	function (selected)
		if isElement(source) and selected then
			local damages = getElementData(source, "bulletDamages") or {}

			if damages[selected] then
				local bodypart = gettok(selected, 2, ";")
				local serial = gettok(selected, 3, ";")

				damages["stitch-cut;" .. bodypart .. ";" .. serial] = (damages["stitch-cut;" .. bodypart .. ";" .. serial] or 0) + 1
				damages[selected] = nil

				setElementData(source, "bulletDamages", damages)
			end
		end
	end)

addEvent("getOutBullet", true)
addEventHandler("getOutBullet", getRootElement(),
	function (selected)
		iprint(client)
		if isElement(source) and selected then
			local damages = getElementData(source, "bulletDamages") or {}

			if damages[selected] then
				local bodypart = gettok(selected, 2, ";")
				local serial = gettok(selected, 3, ";")

				if not exports.sm_items:hasSpaceForItem(source, 123) then
					outputChatBox("#d75959[StrongMTA]: #ffffffNem fér el nálad a tárgy!", client, 255, 255, 255, true)
					exports.sm_hud:showInfobox(client, "e", "Nem fér el nálad a tárgy!")
					return
				end

				if not serial or not bodypart then
					return
				end

				local added = exports.sm_items:giveItem(client, 123, 1, false, selected, "---------------")
				print(serial)

				if added then
					damages[selected] = damages[selected] - 1
					damages["hole;" .. bodypart .. ";" .. serial] = (damages["hole;" .. bodypart .. ";" .. serial] or 0) + 1

					if damages[selected] <= 0 then
						damages[selected] = nil
					end

					setElementData(source, "bulletDamages", damages)
				end
			end
		end
	end)

addEventHandler("onPlayerDamage", getRootElement(),
	function (attacker, weapon, bodypart, loss)
		if not loss or loss < 0.5 then
			return
		end

		if weapon == 53 then
			return
		end

		if not bodypart and getPedOccupiedVehicle(source) then
			bodypart = 3
		end

		if attacker and bodypart ~= 9 and weapon ~= 53 and (weapon < 16 or weapon > 18) then
			local bulletDamages = getElementData(source, "bulletDamages") or {}
			local damageType = false

			if weapon == 0 then
				damageType = "punch"
			elseif weapon == 4 or weapon == 8 then
				damageType = "cut"
			elseif weapon >= 22 and weapon <= 34 then
				damageType = weapon
			end

			if damageType then
				local data = damageType .. ";" .. bodypart
				local weaponSerial = getElementData(attacker, "currentWeaponSerial")

				if weaponSerial then
					data = data .. ";" .. weaponSerial
				end

				bulletDamages[data] = (bulletDamages[data] or 0) + 1

				setElementData(source, "bulletDamages", bulletDamages)
			end
		end

		if weapon > 15 then
			-- lábak
			if (bodypart == 3 and loss >= 15) or bodypart == 7 or bodypart == 8 then
				local torso = false

				if bodypart == 3 then
					torso = true
					bodypart = math.random(7, 8)
				end

				if bodypart == 7 then
					if not getElementData(source, "char.injureLeftFoot") then
						if torso then
							setElementData(source, "char.injureLeftFoot", true)
							exports.sm_controls:toggleControl(source, {"crouch", "sprint", "jump"}, false)
							exports.sm_hud:showInfobox(source, "w", "Eltörted a bal lábad!")
						else
							exports.sm_hud:showInfobox(source, "w", "Megütötted a bal lábad!")
						end
					end
				elseif bodypart == 8 then
					if not getElementData(source, "char.injureRightFoot") then
						if torso then
							setElementData(source, "char.injureRightFoot", true)
							exports.sm_controls:toggleControl(source, {"crouch", "sprint", "jump"}, false)
							exports.sm_hud:showInfobox(source, "w", "Eltörted a jobb lábad!")
						else
							exports.sm_hud:showInfobox(source, "w", "Megütötted a jobb lábad!")
						end
					end
				end
			-- karok
			elseif bodypart == 5 or bodypart == 6 then
				if bodypart == 5 then
					if not getElementData(source, "char.injureLeftArm") then
						setElementData(source, "char.injureLeftArm", true)
						exports.sm_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, false)
						exports.sm_hud:showInfobox(source, "w", "Eltörted a bal kezed!")
					end
				elseif bodypart == 6 then
					if not getElementData(source, "char.injureRightArm") then
						setElementData(source, "char.injureRightArm", true)
						exports.sm_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, false)
						exports.sm_hud:showInfobox(source, "w", "Eltörted a jobb kezed!")
					end
				end
			end
		end
	end)

addEvent("damageCarPunch", true)
addEventHandler("damageCarPunch", getRootElement(),
	function ()
		if isElement(source) then
			local bodypart = math.random(5, 6)

			if bodypart == 5 then
				if not getElementData(source, "char.injureLeftArm") then
					setElementData(source, "char.injureLeftArm", true)
					exports.sm_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, false)
					exports.sm_hud:showInfobox(source, "w", "Eltörted a bal kezed!")
				end
			elseif bodypart == 6 then
				if not getElementData(source, "char.injureRightArm") then
					setElementData(source, "char.injureRightArm", true)
					exports.sm_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, false)
					exports.sm_hud:showInfobox(source, "w", "Eltörted a jobb kezed!")
				end
			end
		end
	end)

addEvent("processHeadShot", true)
addEventHandler("processHeadShot", getRootElement(),
	function (attacker, weapon)
		if isElement(attacker) and weapon then
			killPed(source, attacker, weapon, 9)
			setPedHeadless(source, true)
		end
	end)

addEventHandler("onPlayerSpawn", getRootElement(),
	function ()
		setPedHeadless(source, false)
		setElementData(source, "player.seatBelt", false)
	end)

addEvent("vehicleDamage", true)
addEventHandler("vehicleDamage", getRootElement(),
	function (affected)
		if type(affected) == "table" then
			local players = {}

			for k, v in pairs(affected) do
				if isElement(k) and not isPedDead(k) then
					local health = getElementHealth(k) - v

					setElementHealth(k, health)

					if health <= 0 then
						setElementData(k, "customDeath", "autóbaleset")
					end

					table.insert(players, k)
				end
			end

			triggerClientEvent(players, "addBloodToScreenByCarDamage", source, affected)
		end
	end)

addEvent("killPlayerBadHelpup", true)
addEventHandler("killPlayerBadHelpup", getRootElement(),
	function ()
		if isElement(source) then
			setElementData(source, "customDeath", "elrontott elsősegély")
			setElementHealth(source, 0)
			setPedAnimation(source)
		end
	end)

addEvent("helpUpPerson", true)
addEventHandler("helpUpPerson", getRootElement(),
	function ()
		if isElement(source) then
			helpUpPerson(source)
			setElementData(source, "char.Hunger", 50)
			setElementData(source, "char.Thirst", 50)
		end
	end)

addEvent("takeMedicBag", true)
addEventHandler("takeMedicBag", getRootElement(),
	function (player)
		if isElement(source) then
			-- sm_clothesshop után az lvmsbag-ot a földre rakni
			triggerClientEvent(source, "takeMedicBag", source, player)
			setElementData(player, "triedToHelpUp", true)
		end
	end)

function helpUpPerson(player)
	setElementHealth(player, 100)
	setElementData(player, "bloodLevel", 100)

	removeElementData(player, "bulletDamages")
	removeElementData(player, "triedToHelpUp")

	if getElementData(player, "char.injureLeftFoot") then
		exports.sm_controls:toggleControl(player, {"crouch", "sprint", "jump"}, true)
	end

	if getElementData(player, "char.injureRightFoot") then
		exports.sm_controls:toggleControl(player, {"crouch", "sprint", "jump"}, true)
	end

	if getElementData(player, "char.injureLeftArm") then
		exports.sm_controls:toggleControl(player, {"aim_weapon", "fire", "jump"}, true)
	end

	if getElementData(player, "char.injureRightArm") then
		exports.sm_controls:toggleControl(player, {"aim_weapon", "fire", "jump"}, true)
	end

	removeElementData(player, "char.injureLeftFoot")
	removeElementData(player, "char.injureRightFoot")
	removeElementData(player, "char.injureLeftArm")
	removeElementData(player, "char.injureRightArm")
end

addCommandHandler("agyogyit",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.sm_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local adminTitle = exports.sm_administration:getPlayerAdminTitle(sourcePlayer)

					helpUpPerson(targetPlayer)
					setElementData(targetPlayer, "char.Hunger", 100)
					setElementData(targetPlayer, "char.Thirst", 100)

					outputChatBox("[StrongMTA]: #6094cb" .. adminName .. " #ffffffmeggyógyított téged.", targetPlayer, 61, 122, 188, true)
					outputChatBox("[StrongMTA]: #ffffffMeggyógyítottad #6094cb" .. targetName .. " #ffffffjátékost.", sourcePlayer, 61, 122, 188, true)

					exports.sm_administration:showAdminLog(adminTitle .. " " .. adminName .. " meggyógyította #6094cb" .. targetName .. "#ffffff-t.", 2)
					exports.sm_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end
)
