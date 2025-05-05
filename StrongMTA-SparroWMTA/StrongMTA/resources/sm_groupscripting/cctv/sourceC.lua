local screenX, screenY = guiGetScreenSize()

-- local cctvMarker = createMarker(255.474609375, 114.5361328125, 1008.8130493164 - 1, "cylinder", 0.75, 215, 89, 89, 100)
-- local cctvMarkerCol = createColSphere(255.474609375, 114.5361328125, 1008.8130493164, 10)
local cctvMarker = createMarker(1539.1318359375, -1675.0455322266, 13.546875 - 1, "cylinder", 0.75, 215, 89, 89, 100)
local cctvMarkerCol = createColSphere(1539.1318359375, -1675.0455322266, 13.546875, 10)

-- setElementInterior(cctvMarker, 10)
-- setElementDimension(cctvMarker, 31)
setElementData(cctvMarker, "cctvMarker", 1, false)

-- setElementInterior(cctvMarkerCol, 10)
-- setElementDimension(cctvMarkerCol, 31)
setElementData(cctvMarkerCol, "cctvMarkerCol", cctvMarker, false)

local activeColshape = false

local activeMarker = false
local activeCamId = false

local screenShader = false
local screenSource = false

local lastCamPos = {}
local cameraPositions = {
	-- x, y, z, rx, ry, zoom, detect distance
	{1013.9547729492, -1464.2448730469, 23.706701278687, 360, -100, 0, 100, "Bank #1"},
	{970.41473388672, -1451.998046875, 26.213937759399, 360, -100, 0, 100, "Bank #2"},
	{1185.3072509766, -1367.685546875, 23.351999282837, 10, -160, 0, 65, "Kórház"},
	{1366.2690429688, -1276.1866455078, 32.348564147949, 270, -100, 0, 65, "Fegyverbolt"},
}

local cctvText = ""
local camMoveSound = false
local activeVehicle = false

local wantedCarTick = {}
local lastCheckMDC = {}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		local txd = engineLoadTXD("files/police_props.txd")
		engineImportTXD(txd, 2606)
	end)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if activeMarker then
			local x, y, z = getElementPosition(activeMarker)

			setElementInterior(localPlayer, getElementInterior(activeMarker))
			setElementDimension(localPlayer, getElementDimension(activeMarker))
			setElementPosition(localPlayer, x, y, z + 1)
			setElementFrozen(localPlayer, false)
			setCameraTarget(localPlayer)

			exports.sm_controls:toggleControl({"all"}, true)
			exports.sm_hud:showHUD()
			setCursorAlpha(255)
		end
	end)

local lastGunShotReport = false

addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function (weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement, startX, startY, startZ)
		if weapon >= 22 and weapon <= 33 then
			if not exports.sm_groups:isPlayerOfficer(localPlayer) then
				if not exports.sm_groups:isPlayerInGroup(localPlayer, 40) then
					if not lastGunShotReport then
						lastGunShotReport = 0
					end

					if getTickCount() - lastGunShotReport >= 60000 then
						for i = 1, #cameraPositions do
							local camX, camY, camZ, camRotX, camRotY, camZoom, camMaxDistance, camZone = unpack(cameraPositions[i])

							if isPedInVehicle(localPlayer) then
								local currVeh = getPedOccupiedVehicle(localPlayer)

								if currVeh then
									local targetX, targetY, targetZ = getElementPosition(currVeh)

									if getDistanceBetweenPoints3D(camX, camY, camZ, targetX, targetY, targetZ) <= camMaxDistance then
										local angle = math.atan2(targetY - camY, targetX - camX) + math.rad(180 - camRotX)

										if angle < 0 then
											angle = angle + math.rad(360)
										end

										angle = math.deg(angle)

										if angle > 85 and angle < 285 then
											local clearTarget = false
											local targetRadius = getElementRadius(currVeh)
											local targetRotZ = ({getElementRotation(currVeh)})[3]

											if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
												clearTarget = true
											end

											local lineX, lineY = rotateAround(targetRotZ - 20, 0, targetRadius, targetX, targetY)

											if isLineOfSightClear(camX, camY, camZ, lineX, lineY, targetZ, true, true, true, true, true, true, false, currVeh) then
												clearTarget = true
											end

											lineX, lineY = rotateAround(targetRotZ + 20, 0, targetRadius, targetX, targetY)

											if isLineOfSightClear(camX, camY, camZ, lineX, lineY, targetZ, true, true, true, true, true, true, false, currVeh) then
												clearTarget = true
											end

											lineX, lineY = rotateAround(targetRotZ - 20 + 180, 0, targetRadius, targetX, targetY)

											if isLineOfSightClear(camX, camY, camZ, lineX, lineY, targetZ, true, true, true, true, true, true, false, currVeh) then
												clearTarget = true
											end

											lineX, lineY = rotateAround(targetRotZ + 20 + 180, 0, targetRadius, targetX, targetY)

											if isLineOfSightClear(camX, camY, camZ, lineX, lineY, targetZ, true, true, true, true, true, true, false, currVeh) then
												clearTarget = true
											end

											if clearTarget then
												lastGunShotReport = getTickCount()
												triggerServerEvent("reportGunShot", localPlayer, currVeh, camZone or getZoneName(camX, camY, camZ))
												break
											end
										end
									end
								end
							else
								local targetX, targetY, targetZ = getElementPosition(localPlayer)

								if getDistanceBetweenPoints3D(camX, camY, camZ, targetX, targetY, targetZ) <= camMaxDistance then
									local angle = math.atan2(targetY - camY, targetX - camX) + math.rad(180 - camRotX)

									if angle < 0 then
										angle = angle + math.rad(360)
									end

									angle = math.deg(angle)

									if angle > 85 and angle < 285 then
										local clearTarget = false

										if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
											clearTarget = true
										end

										targetX, targetY, targetZ = getPedBonePosition(localPlayer, 34)

										if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
											clearTarget = true
										end

										targetX, targetY, targetZ = getPedBonePosition(localPlayer, 24)

										if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
											clearTarget = true
										end

										targetX, targetY, targetZ = getPedBonePosition(localPlayer, 54)

										if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
											clearTarget = true
										end

										targetX, targetY, targetZ = getPedBonePosition(localPlayer, 44)

										if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
											clearTarget = true
										end

										if clearTarget then
											lastGunShotReport = getTickCount()
											triggerServerEvent("reportGunShot", localPlayer, false, camZone or getZoneName(camX, camY, camZ))
											break
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end)

addEventHandler("onClientPlayerWasted", getRootElement(),
	function (killer)
		if killer == localPlayer then
			if not exports.sm_groups:isPlayerOfficer(localPlayer) then
				if not exports.sm_groups:isPlayerInGroup(localPlayer, 40) then
					for i = 1, #cameraPositions do
						local camX, camY, camZ, camRotX, camRotY, camZoom, camMaxDistance, camZone = unpack(cameraPositions[i])

						if isPedInVehicle(localPlayer) then
							local currVeh = getPedOccupiedVehicle(localPlayer)

							if currVeh then
								local targetX, targetY, targetZ = getElementPosition(currVeh)

								if getDistanceBetweenPoints3D(camX, camY, camZ, targetX, targetY, targetZ) <= camMaxDistance then
									local angle = math.atan2(targetY - camY, targetX - camX) + math.rad(180 - camRotX)

									if angle < 0 then
										angle = angle + math.rad(360)
									end

									angle = math.deg(angle)

									if angle > 85 and angle < 285 then
										local clearTarget = false
										local targetRadius = getElementRadius(currVeh)
										local targetRotZ = ({getElementRotation(currVeh)})[3]

										if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
											clearTarget = true
										end

										local lineX, lineY = rotateAround(targetRotZ - 20, 0, targetRadius, targetX, targetY)

										if isLineOfSightClear(camX, camY, camZ, lineX, lineY, targetZ, true, true, true, true, true, true, false, currVeh) then
											clearTarget = true
										end

										lineX, lineY = rotateAround(targetRotZ + 20, 0, targetRadius, targetX, targetY)

										if isLineOfSightClear(camX, camY, camZ, lineX, lineY, targetZ, true, true, true, true, true, true, false, currVeh) then
											clearTarget = true
										end

										lineX, lineY = rotateAround(targetRotZ - 20 + 180, 0, targetRadius, targetX, targetY)

										if isLineOfSightClear(camX, camY, camZ, lineX, lineY, targetZ, true, true, true, true, true, true, false, currVeh) then
											clearTarget = true
										end

										lineX, lineY = rotateAround(targetRotZ + 20 + 180, 0, targetRadius, targetX, targetY)

										if isLineOfSightClear(camX, camY, camZ, lineX, lineY, targetZ, true, true, true, true, true, true, false, currVeh) then
											clearTarget = true
										end

										if clearTarget then
											triggerServerEvent("reportKill", localPlayer, currVeh, camZone or getZoneName(camX, camY, camZ))
											break
										end
									end
								end
							end
						else
							local targetX, targetY, targetZ = getElementPosition(localPlayer)

							if getDistanceBetweenPoints3D(camX, camY, camZ, targetX, targetY, targetZ) <= camMaxDistance then
								local angle = math.atan2(targetY - camY, targetX - camX) + math.rad(180 - camRotX)

								if angle < 0 then
									angle = angle + math.rad(360)
								end

								angle = math.deg(angle)

								if angle > 85 and angle < 285 then
									local clearTarget = false

									if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
										clearTarget = true
									end

									targetX, targetY, targetZ = getPedBonePosition(localPlayer, 34)

									if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
										clearTarget = true
									end

									targetX, targetY, targetZ = getPedBonePosition(localPlayer, 24)

									if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
										clearTarget = true
									end

									targetX, targetY, targetZ = getPedBonePosition(localPlayer, 54)

									if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
										clearTarget = true
									end

									targetX, targetY, targetZ = getPedBonePosition(localPlayer, 44)

									if isLineOfSightClear(camX, camY, camZ, targetX, targetY, targetZ, true, true, true, true, true, true, false, localPlayer) then
										clearTarget = true
									end

									if clearTarget then
										triggerServerEvent("reportKill", localPlayer, false, camZone or getZoneName(camX, camY, camZ))
										break
									end
								end
							end
						end
					end
				end
			end
		end
	end)

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if hitElement == localPlayer and matchingDimension then
			if getElementData(source, "cctvMarkerCol") then

				activeColshape = source

				addEventHandler("onClientRender", getRootElement(), renderTheMarkerHint)
			end
		end
	end)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (leftElement, matchingDimension)
		if leftElement == localPlayer and matchingDimension then
			if getElementData(source, "cctvMarkerCol") then
				removeEventHandler("onClientRender", getRootElement(), renderTheMarkerHint)

				activeColshape = false
			end
		end
	end)

function renderTheMarkerHint()
	local px, py, pz = getElementPosition(localPlayer)
	local tx, ty, tz = getElementPosition(activeColshape)

	if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) > 11 then
		removeEventHandler("onClientRender", getRootElement(), renderTheMarkerHint)

		activeColshape = false

		return
	end

	local x, y = getScreenFromWorldPosition(tx, ty, tz)

	if x and y then
		x = math.floor(x - 100)
		y = math.floor(y - 10)

		dxDrawText("[CCTV]\nHasználata:\n[W][A][S][D][Q][E] - Mozgatás\n[JOBB/BAL NYÍL] - Kamera váltása\n[ESC] - Kilépés", x + 1, y + 1, x + 200 + 1, y + 20 + 1, tocolor(0, 0, 0), 1, RalewayS, "center", "center")
		dxDrawText("#3d7abc[CCTV]\n#ffffffHasználata:\n#3d7abc[W][A][S][D][Q][E]#ffffff - Mozgatás\n#3d7abc[JOBB/BAL NYÍL]#ffffff - Kamera váltása\n#3d7abc[ESC]#ffffff - Kilépés", x, y, x + 200, y + 20, tocolor(255, 255, 255), 1, RalewayS, "center", "center", false, false, false, true)
	end
end

addEventHandler("onClientMarkerHit", getResourceRootElement(),
	function (enterPlayer, matchingDimension)
		if enterPlayer == localPlayer and matchingDimension then
			local cctvMarkerId = getElementData(source, "cctvMarker")

			if cctvMarkerId then
				local px, py, pz = getElementPosition(localPlayer)
				local tx, ty, tz = getElementPosition(source)

				if math.abs(pz - tz) <= 1.1 then
					exports.sm_controls:toggleControl({"all"}, false)
					setElementFrozen(localPlayer, true)

					exports.sm_hud:hideHUD()
					setCursorAlpha(0)

					activeMarker = source
					activeCamId = 1

					screenShader = dxCreateShader("files/blackwhite.fx")
					screenSource = dxCreateScreenSource(screenX * 0.35, screenY * 0.35)
					dxSetShaderValue(screenShader, "screenSource", screenSource)

					if not lastCamPos[activeCamId] then
						lastCamPos[activeCamId] = {}
						
						for i = 1, #cameraPositions[activeCamId] do
							table.insert(lastCamPos[activeCamId], cameraPositions[activeCamId][i])
						end
					end

					cctvText = lastCamPos[activeCamId][8] or getZoneName(lastCamPos[activeCamId][1], lastCamPos[activeCamId][2], lastCamPos[activeCamId][3])
					cctvText = cctvText .. " (#" .. activeCamId .. ")"

					addEventHandler("onClientPreRender", getRootElement(), cctvPreRender)
					addEventHandler("onClientRender", getRootElement(), cctvRender)
					addEventHandler("onClientKey", getRootElement(), cctvKey)

					setElementDimension(localPlayer, 0)
					setElementInterior(localPlayer, 0)
				end
			end
		end
	end)

function cctvKey(key, press)
	if key ~= "escape" then
		cancelEvent()
	end

	if key == "w" or key == "a" or key == "s" or key == "d" or key == "q" or key == "e" then
		if not press then
			if not getKeyState("w") and not getKeyState("a") and not getKeyState("s") and not getKeyState("d") and not getKeyState("q") and not getKeyState("e") then
				if isElement(camMoveSound) then
					destroyElement(camMoveSound)
				end
			end
		else
			if not isElement(camMoveSound) then
				camMoveSound = playSound("files/sounds/cammove.mp3", true)
			end
		end
	end

	if press then
		if key == "m" then
			showCursor(not isCursorShowing())
			setCursorAlpha(0)
		end

		if key == "mouse1" and activeVehicle then
			if exports.sm_groups:isPlayerOfficer(localPlayer) then
				if not lastCheckMDC[activeVehicle] then
					lastCheckMDC[activeVehicle] = 0
				end

				if getTickCount() - lastCheckMDC[activeVehicle] >= 6000 then
					triggerServerEvent("checkMDC", localPlayer, activeVehicle, true)
					lastCheckMDC[activeVehicle] = getTickCount()
				end
			end
		end

		if key == "arrow_r" then
			activeCamId = activeCamId + 1

			if activeCamId > #cameraPositions then
				activeCamId = 1
			end

			if not lastCamPos[activeCamId] then
				lastCamPos[activeCamId] = {}

				for i = 1, #cameraPositions[activeCamId] do
					table.insert(lastCamPos[activeCamId], cameraPositions[activeCamId][i])
				end
			end

			cctvText = lastCamPos[activeCamId][8] or getZoneName(lastCamPos[activeCamId][1], lastCamPos[activeCamId][2], lastCamPos[activeCamId][3])
			cctvText = cctvText .. " (#" .. activeCamId .. ")"
		end

		if key == "arrow_l" then
			activeCamId = activeCamId - 1

			if activeCamId < 1 then
				activeCamId = #cameraPositions
			end

			if not lastCamPos[activeCamId] then
				lastCamPos[activeCamId] = {}

				for i = 1, #cameraPositions[activeCamId] do
					table.insert(lastCamPos[activeCamId], cameraPositions[activeCamId][i])
				end
			end
			cctvText = lastCamPos[activeCamId][8] or getZoneName(lastCamPos[activeCamId][1], lastCamPos[activeCamId][2], lastCamPos[activeCamId][3])
			cctvText = cctvText .. " (#" .. activeCamId .. ")"
		end

		if key == "backspace" or key == "escape" then
			removeEventHandler("onClientPreRender", getRootElement(), cctvPreRender)
			removeEventHandler("onClientRender", getRootElement(), cctvRender)
			removeEventHandler("onClientKey", getRootElement(), cctvKey)

			if isElement(screenSource) then
				destroyElement(screenSource)
			end
			screenSource = nil

			if isElement(screenShader) then
				destroyElement(screenShader)
			end
			screenShader = nil

			if isElement(camMoveSound) then
				destroyElement(camMoveSound)
			end
			camMoveSound = nil

			setCursorAlpha(255)
			showCursor(false)
			exports.sm_hud:showHUD()

			local x, y, z = getElementPosition(activeMarker)

			setElementInterior(localPlayer, getElementInterior(activeMarker))
			setElementDimension(localPlayer, getElementDimension(activeMarker))
			setElementPosition(localPlayer, x, y, z + 1)
			setTimer(setElementFrozen, 500, 1, localPlayer, false)
			setCameraTarget(localPlayer)
			exports.sm_controls:toggleControl({"all"}, true)

			activeCamId = false
			activeMarker = false
		end
	end
end

local lastColorChange = 0
local lastColorChangeState = false

function mdcAlertFromServer(plate, cctv, reason)
	if plate then
		wantedCarTick[plate] = getTickCount()
	end
end

function cctvRender()
	dxUpdateScreenSource(screenSource)

	local camdat = lastCamPos[activeCamId]

	if isElement(screenShader) then
		dxDrawImage(-respc(2) - screenX * camdat[6], -respc(2) - screenY * camdat[6], screenX * (camdat[6] * 2 + 1) + respc(4), screenY * (camdat[6] * 2 + 1) + respc(4), screenShader)
	else
		dxDrawImage(-respc(2) - screenX * camdat[6], -respc(2) - screenY * camdat[6], screenX * (camdat[6] * 2 + 1) + respc(4), screenY * (camdat[6] * 2 + 1) + respc(4), screenSource, 0, 0, 0, tocolor(190, 250, 220, 255))
	end

	local currTime = getRealTime()
	currTime = string.format("%04d.%02d.%02d %02d:%02d:%02d", currTime.year + 1900, currTime.month + 1, currTime.monthday, currTime.hour, currTime.minute, currTime.second)

	local sx = dxGetTextWidth(currTime, 1, cameraFont) + respc(15)
	local sy = dxGetFontHeight(1, cameraFont) + respc(15)

	dxDrawRectangle(respc(25), screenY - respc(25) - sy, sx, sy, tocolor(25, 25, 25))
	dxDrawText(currTime, respc(25), screenY - respc(25) - sy, respc(25) + sx, screenY - respc(25), tocolor(200, 200, 200, 200), 1, cameraFont, "center", "center", false, false, false, true)
	
	sx = dxGetTextWidth(cctvText, 1, cameraFont) + respc(15)

	dxDrawRectangle(screenX - sx - respc(25), screenY - respc(25) - sy, sx, sy, tocolor(25, 25, 25))
	dxDrawText(cctvText, screenX - sx - respc(25), screenY - respc(25) - sy, screenX - respc(25), screenY - respc(25), tocolor(200, 200, 200, 200), 1, cameraFont, "center", "center", false, false, false, true)
	
	local cx, cy = getCursorPosition()

	activeVehicle = false

	if cx and cy then
		cx = cx * screenX
		cy = cy * screenY

		dxDrawImage(cx - respc(32), cy - respc(32), respc(64), respc(64), "files/images/pointer.png", 0, 0, 0, tocolor(23.75, 31.25, 27.5, 200))
		
		local targetX = reMap(cx, -respc(2) - screenX * camdat[6], -respc(2) - screenX * camdat[6] + screenX * (camdat[6] * 2 + 1) + respc(4), 0, screenX)
		local targetY = reMap(cy, -respc(2) - screenY * camdat[6], -respc(2) - screenY * camdat[6] + screenY * (camdat[6] * 2 + 1) + respc(4), 0, screenY)
		local worldX, worldY, worldZ = getWorldFromScreenPosition(targetX, targetY, 100)

		if worldX and worldY and worldZ then
			local hit, hitX, hitY, hitZ, hitElement = processLineOfSight(camdat[1], camdat[2], camdat[3], worldX, worldY, worldZ, false, true, false, false, false, true, false, true)

			if hitElement then
				local plateText = getVehiclePlateText(hitElement)

				if plateText then
					local plateSections = {}

					plateText = split(plateText, "-")

					for i = 1, #plateText do
						if utf8.len(plateText[i]) > 0 then
							table.insert(plateSections, plateText[i])
						end
					end

					plateText = table.concat(plateSections, "-")

					local str = "Rendszám: " .. plateText
					local sx = dxGetTextWidth(str, 1, cameraFont) + respc(15)

					if wantedCarTick[plateText] then
						if getTickCount() - wantedCarTick[plateText] <= 5500 then
							if getTickCount() - lastColorChange >= 750 then
								lastColorChange = getTickCount()
								lastColorChangeState = not lastColorChangeState
							end

							if not lastColorChangeState then
								str = "#d75959" .. str
							else
								str = "#598ed7" .. str
							end
						else
							wantedCarTick[plateText] = nil
						end
					end

					activeVehicle = hitElement

					dxDrawRectangle(cx + respc(40), cy - sy / 2, sx, sy, tocolor(23.75, 31.25, 27.5, 200))
					dxDrawText(str, cx + respc(40), cy - sy / 2, cx + respc(40) + sx, cy - sy / 2 + sy, tocolor(255, 255, 255), 1, cameraFont, "center", "center", false, false, false, true)
				end
			end
		end
	end
end

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function cctvPreRender(deltaTime)
	deltaTime = deltaTime / 75

	local x, y, z, rx, ry, zoom, dist = unpack(lastCamPos[activeCamId])
	local diffRotX = rx - cameraPositions[activeCamId][4]
	local diffRotY = ry - cameraPositions[activeCamId][5]

	if not isConsoleActive() then
		if getKeyState("a") then
			if diffRotX <= 40 then
				lastCamPos[activeCamId][4] = lastCamPos[activeCamId][4] + 0.75 * deltaTime
			end
		elseif getKeyState("d") then
			if diffRotX >= -40 then
				lastCamPos[activeCamId][4] = lastCamPos[activeCamId][4] - 0.75 * deltaTime
			end
		end

		if getKeyState("w") then
			if diffRotY <= 50 then
				lastCamPos[activeCamId][5] = lastCamPos[activeCamId][5] + 0.75 * deltaTime
			end
		elseif getKeyState("s") then
			if diffRotY >= -50 then
				lastCamPos[activeCamId][5] = lastCamPos[activeCamId][5] - 0.75 * deltaTime
			end
		end

		if getKeyState("q") then
			if zoom < 0.5 then
				lastCamPos[activeCamId][6] = lastCamPos[activeCamId][6] + 0.01 * deltaTime
			end
		elseif getKeyState("e") then
			if zoom > 0 then
				lastCamPos[activeCamId][6] = lastCamPos[activeCamId][6] - 0.01 * deltaTime

				if lastCamPos[activeCamId][6] < 0 then
					lastCamPos[activeCamId][6] = 0
				end
			end
		end
	end

	local lx, ly = rotateAround(rx, 1, 0, x, y)
	local _, lz = rotateAround(ry, 0, 1, z, z)

	setCameraMatrix(x, y, z, lx, ly, lz, 0, 70 - 5 * zoom)
end

function rotateAround(angle, x1, y1, x2, y2)
	angle = math.rad(angle)

	local rotatedX = x1 * math.cos(angle) - y1 * math.sin(angle)
	local rotatedY = x1 * math.sin(angle) + y1 * math.cos(angle)

	return rotatedX + (x2 or 0), rotatedY + (y2 or 0)
end