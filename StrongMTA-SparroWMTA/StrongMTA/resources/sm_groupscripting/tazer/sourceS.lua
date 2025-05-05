addEvent("onTazerShoot", true)
addEventHandler("onTazerShoot", getRootElement(),
	function (targetPlayer)
		if isElement(source) and isElement(targetPlayer) then
			local tazed = getElementData(targetPlayer, "tazed")

			if not tazed then
				exports.sm_controls:toggleControl(targetPlayer, {"forwards", "backwards", "left", "right", "jump", "crouch", "aim_weapon", "fire", "enter_exit", "enter_passenger"}, false)
				
				setPedAnimation(targetPlayer, "ped", "FLOOR_hit_f", -1, false, false, true)
				setElementData(targetPlayer, "tazed", true)
				fadeCamera(targetPlayer, false, 1, 255, 255, 255)

				setTimer(
					function(player)
						if isElement(player) then
							setPedAnimation(player, "FAT", "idle_tired", -1, true, false, false)
							fadeCamera(player, true, 1, 255, 255, 255)

							setTimer(
								function(player)
									if isElement(player) then
										exports.sm_controls:toggleControl(player, {"forwards", "backwards", "left", "right", "jump", "crouch", "aim_weapon", "fire", "enter_exit", "enter_passenger"}, true)
										setPedAnimation(player, false)
										setElementData(player, "tazed", false)
									end
								end,
							10000, 1, player)
						end
					end,
				20000, 1, targetPlayer)

				triggerClientEvent(targetPlayer, "playTazerSound", targetPlayer)

				local targetName = getElementData(targetPlayer, "visibleName"):gsub("_", " ")
				local playerName = getElementData(source, "visibleName"):gsub("_", " ")

				outputChatBox("#3d7abc[StrongMTA]: #ffffffSikeresen lesokkoltad a kiválasztott játékost! #3d7abc(" .. targetName .. ")", source, 255, 255, 255, true)
				outputChatBox("#3d7abc[StrongMTA]: #3d7abc" .. playerName .. " #fffffflesokkolt téged!", targetPlayer, 255, 255, 255, true)

				exports.sm_chat:localAction(source, "lesokkolt valakit. ((" .. targetName .. "))")
			end
		end
	end
)