local screenX, screenY = guiGetScreenSize()

local panelState = false
local panelWidth = 200
local panelHeight = 120
local panelPosX = (screenX / 2)
local panelPosY = (screenY / 2)
local panelMargin = 3

local playerElement = false

local moveDifferenceX, moveDifferenceY = 0, 0
local isMoving = false

local cuffModel = 2812

local leftCuffObj = {}
local rightCuffObj = {}

local cuffData = {}
local cuffAnim = {}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		setElementData(localPlayer, "cuffed", false)
		setElementData(localPlayer, "visz", false)

		local txd = engineLoadTXD("cuff/files/cuff.txd")
		if txd then
			local dff = engineLoadDFF("cuff/files/cuff.dff")
			if dff then
				engineImportTXD(txd, cuffModel)
				engineReplaceModel(dff, cuffModel)
			end
		end

		engineLoadIFP("cuff/files/standing2.ifp", "cuff_standing2")
		engineLoadIFP("cuff/files/standing.ifp", "cuff_standing")
		engineLoadIFP("cuff/files/walking.ifp", "cuff_walking")
	end)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if getElementData(localPlayer, "cuffed") or getElementData(localPlayer, "cuffAnimation") then
			setPedAnimation(localPlayer)
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "visz" then
			if getElementData(source, "visz") then
				cuffData[source] = getElementData(source, "visz")
			else
				cuffData[source] = getElementData(source, "cuffed") and 1 or nil
			end
		elseif dataName == "cuffed" then
			local cuffed = getElementData(source, "cuffed")
			local visz = getElementData(source, "visz") or 1

			if isElement(leftCuffObj[source]) then
				destroyElement(leftCuffObj[source])
			end
			
			if isElement(rightCuffObj[source]) then
				destroyElement(rightCuffObj[source])
			end

			leftCuffObj[source] = nil
			rightCuffObj[source] = nil

			cuffData[source] = cuffed and visz or nil

			if cuffed then
				setPedAnimation(source, "cuff_standing2", "standing", -1, true, false)

				cuffAnim[source] = 0

				leftCuffObj[source] = createObject(cuffModel, 0, 0, 0)
				setElementDoubleSided(leftCuffObj[source], true)
				exports.sm_boneattach:attachElementToBone(leftCuffObj[source], source, 11, 0, 0, 0, 90, -45, 0)

				rightCuffObj[source] = createObject(cuffModel, 0, 0, 0)
				setElementDoubleSided(rightCuffObj[source], true)
				exports.sm_boneattach:attachElementToBone(rightCuffObj[source], source, 12, 0, 0, 0, 90, -45, 0)

				local playerX, playerY, playerZ = getElementPosition(source)
				local soundEffect = playSound3D("cuff/files/cuff.mp3", playerX, playerY, playerZ)

				setElementInterior(soundEffect, getElementInterior(source))
				setElementDimension(soundEffect, getElementDimension(source))
				setSoundMaxDistance(soundEffect, 5)
			else
				setPedAnimation(source)
				cuffData[source] = nil
				cuffAnim[source] = nil
			end
		elseif dataName == "cuffAnimation" then
			local dataValue = getElementData(source, "cuffAnimation")
			
			if dataValue == 1 then
				setPedAnimation(source, "cuff_standing", "standing", -1, true, false)
			elseif dataValue == 2 then
				setPedAnimation(source, "cuff_walking", "walking", -1, true, true)
			elseif dataValue == 3 then
				setPedAnimation(source, "cuff_standing2", "standing", -1, true, false)
			else
				setPedAnimation(source)
			end

			if dataValue then
				cuffAnim[source] = dataValue
			else
				cuffAnim[source] = nil
			end
		end
	end)

addEventHandler("onClientRender", getRootElement(),
	function ()
		for k, v in pairs(cuffData) do
			if isElement(leftCuffObj[k]) and isElement(rightCuffObj[k]) then
				if isElementStreamedIn(k) then
					local interior = getElementInterior(k)
					local dimension = getElementDimension(k)

					if getElementDimension(leftCuffObj[k]) ~= dimension then
						setElementInterior(leftCuffObj[k], interior)
						setElementInterior(rightCuffObj[k], interior)
						setElementDimension(leftCuffObj[k], dimension)
						setElementDimension(rightCuffObj[k], dimension)
					end

					local lx, ly, lz = getElementPosition(leftCuffObj[k])
					local rx, ry, rz = getElementPosition(rightCuffObj[k])

					dxDrawLine3D(lx, ly, lz, rx, ry, rz, tocolor(75, 75, 75))

					if isElement(v) then
						local bx, by, bz = getPedBonePosition(v, 25)

						dxDrawLine3D(lx, ly, lz, bx, by, bz, tocolor(10, 10, 10))
					end
				end
			else
				if isElement(leftCuffObj[source]) then
					destroyElement(leftCuffObj[source])
				end

				if isElement(rightCuffObj[source]) then
					destroyElement(rightCuffObj[source])
				end

				leftCuffObj[source] = nil
				rightCuffObj[source] = nil

				cuffData[k] = nil
				cuffAnim[k] = nil
			end
		end
	end
)

addEventHandler("onClientPreRender", getRootElement(),
	function ()
		for k, v in pairs(cuffData) do
			if isElementStreamedIn(k) and isElement(v) then
				if not isPedInVehicle(v) then
					local sourceX, sourceY, sourceZ = getElementPosition(k)
					local targetX, targetY, targetZ = getElementPosition(v)

					local deltaX = targetX - sourceX
					local deltaY = targetY - sourceY
					local distance = deltaX * deltaX + deltaY * deltaY

					if distance >= 2 then
						local sourceRotX, sourceRotY, sourceRotZ = getElementRotation(k)

						setElementRotation(k, sourceRotX, sourceRotY, -math.deg(math.atan2(deltaX, deltaY)), "default", true)

						if cuffAnim[source] ~= 2 then
							cuffAnim[source] = 2
							setElementData(k, "cuffAnimation", 2)
						end
					elseif cuffAnim[source] ~= 1 then
						cuffAnim[source] = 1
						setElementData(k, "cuffAnimation", 1)
					end
				end
			end
		end
	end
)