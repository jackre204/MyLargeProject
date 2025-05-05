local cameraArray = {}
local lastCamTick = 0
local cameraState, playerCamState = false
local time = 0

function moveCamToObject(object, moveTime, offX, offY, offZ, lookOffX, lookOffY, lookOffZ)
	local objOffX, objOffY, objOffZ = getPositionFromElementOffset(object, offX, offY, offZ)
	local objX, objY, objZ = getPositionFromElementOffset(object, lookOffX, lookOffY, lookOffZ)

	local x, y, z, x2, y2, z2 = getCameraMatrix()
	cameraArray = {x, y, z, x2, y2, z2, objOffX, objOffY, objOffZ, objX, objY, objZ}

	lastCamTick = getTickCount()
	cameraState = true
	time = moveTime or 1000
end

function moveCamToPlayer(player, moveTime)
	local offX, offY, offZ = getPositionFromElementOffset(player, 0, -3, 0.5)
	local px, py, pz = getElementPosition(player)
	local x, y, z, x2, y2, z2 = getCameraMatrix()

	cameraArray = {x, y, z, x2, y2, z2, offX, offY, offZ, px, py, pz}
	lastCamTick = getTickCount()
	cameraState = true
	playerCamState = true
	time = moveTime or 1000
end

function renderCameraPosition()
	if cameraState then
		local currentTick = getTickCount()
		local progress = (currentTick - lastCamTick) / time

		if progress < 1 then
			local cx, cy, cz = interpolateBetween(cameraArray[1], cameraArray[2], cameraArray[3], cameraArray[7], cameraArray[8], cameraArray[9], progress, "Linear")
			local tx, ty, tz = interpolateBetween(cameraArray[4], cameraArray[5], cameraArray[6], cameraArray[10], cameraArray[11], cameraArray[12], progress, "Linear")
			setCameraMatrix(cx, cy, cz, tx, ty, tz, 0, 180)
		else
			cameraState = false
			if playerCamState then
				playerCamState = false
				setCameraTarget(localPlayer)
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), renderCameraPosition)
