local screenX, screenY = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        engineReplaceCOL(engineLoadCOL("mods/garage.col"), 14784)
        engineImportTXD(engineLoadTXD("mods/garage.txd"), 14784)
        engineReplaceModel(engineLoadDFF("mods/garage.dff"), 14784)

        engineImportTXD(engineLoadTXD("mods/trailer.txd"), 591)
        engineReplaceModel(engineLoadDFF("mods/trailer.dff"), 591)

        startTruckerJob()
    end
)

depoPeds = {}

function startTruckerJob()
    for k, v in pairs(truckData.depo) do
        local pedPosX, pedPosY, pedPosZ, pedRot = unpack(v.blip)

        depoPeds[v] = createPed(299, pedPosX, pedPosY, pedPosZ)
        setElementFrozen(depoPeds[v], true)
        setElementData(depoPeds[v], "truckerJob.ped", true)
    end

    addEventHandler("onClientClick", getRootElement(), truckerJobClickHandler)
end

function truckerJobKeyHandler(sourceKey, keyState)

end

function truckerJobClickHandler(sourceKey, keyState, cursorX, cursorY, worldX, worldY, worldZ, clickedElement)
    if sourceKey == "right" and keyState == "down" then
        if clickedElement then
            if getElementData(clickedElement, "truckerJob.ped") then
                showTrailerSelector()
            end
        end
    end
end

local spawnedTrailers = {}

function showTrailerSelector()
    if checkPlayerTrailer(playerElement) then
        print("már van trailered")
    else
        setElementInterior(localPlayer, 18)
        setElementFrozen(localPlayer, true)
        setCameraMatrix(1286.6181640625, -6.8120965957642, 1011.3567504883, 1208.8494873047, -61.210971832275, 979.84802246094)
        
        addEventHandler("onClientRender", getRootElement(), renderTrailerSelector)

        for i = 1, 4 do
            spawnedTrailers[i] = createVehicle(591, 1263.6898193359, -32.421733856201 + 7 * (i - 1), 1005.1328125)
            setElementInterior(spawnedTrailers[i], 18)
            setElementRotation(spawnedTrailers[i], 0, 0, 270)
        end
    end
end

function renderTrailerSelector()
    dxDrawRectangle(screenX / 2 - 400 / 2, 30, 400, 30, tocolor(25, 25, 25))
    dxDrawRectangle(screenX / 2 - 400 / 2 + 3, 30 + 3, 400 - 6, 30 - 6, tocolor(55, 55, 55, 180))

    dxDrawRectangle(0, screenY / 2 - 300 / 2, 45, 300, tocolor(25, 25, 25))
    dxDrawRectangle(screenX - 45, screenY / 2 - 300 / 2, 45, 300, tocolor(25, 25, 25))
end

showTrailerSelector()

----utils
local animations = {}

addEventHandler("onClientRender", root, function()
	for k, v in pairs(animations) do
        if not v.completed then
            local currentTick = getTickCount()
            local elapsedTick = currentTick - v.startTick
            local duration = v.endTick - v.startTick
            local progress = elapsedTick / duration

            v.currentValue[1], v.currentValue[2], v.currentValue[3] = interpolateBetween(
                v.startValue[1], v.startValue[2], v.startValue[3], 
                v.endValue[1], v.endValue[2], v.endValue[3], 
                progress, 
                v.easingType or "Linear"
            )

            if progress >= 1 then
                v.completed = true

                if v.completeFunction then
                    v.completeFunction(unpack(v.functionArgs))
                end
            end
        end
	end
	
	if animationStarted then
		local cameraLook = getAnimationValue("trailerCam")

		setCameraMatrix(cameraLook[1] + 15, cameraLook[2] + 5, cameraLook[3] + 5, cameraLook[1], cameraLook[2], cameraLook[3])
	end
end)

function initAnimation(id, storeVal, startVal, endVal, time, easing, compFunction, args)
    if not storeVal then
        animations[id] = {}
    end

    if not animations[id] then
        animations[id] = {}
    end

    animations[id].startValue = startVal
    animations[id].endValue = endVal
    animations[id].startTick = getTickCount()
    animations[id].endTick = animations[id].startTick + (time or 3000)
    animations[id].easingType = easing
    animations[id].completeFunction = compFunction
    animations[id].functionArgs = args or {}

    animations[id].currentValue = storeVal and animations[id].currentValue or {0, 0, 0}
    animations[id].completed = false
end

function getAnimationValue(id)
	if animations[id] then
		return animations[id].currentValue
	end

	return {0, 0, 0}
end

function setAnimationValue(id, val)
    animations[id].currentValue = val 
end