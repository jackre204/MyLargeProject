local boltTable = {}

local boltTexture = dxCreateTexture("bolt.png")

addEvent("onLightning", true)
addEventHandler("onLightning", getRootElement(), function(boltX, boltY, boltZ)
	table.insert(boltTable, {boltX,boltY,boltZ,-500,0,getTickCount(),getTickCount() + 500 + 250})
end)

addEvent("onEarthquake", true)
addEventHandler("onEarthquake", getRootElement(), function(earthQuakeTime)
	setTimer(destroyElement, 1000 * earthQuakeTime + 1, 1, playSound("sound2.mp3", true))
	setTimer(setCameraShakeLevel, 1000 * (earthQuakeTime + 1), 1, 0)
	setTimer(setControlState, 1000 * (earthQuakeTime + 1), 1, "left", false)
	setTimer(setControlState, 1000 * (earthQuakeTime + 1), 1, "right", false)

	local pX,pY,pZ = getElementPosition(localPlayer)

	createExplosion(pX,pY,pZ)

	setTimer(function()
		local pX,pY,pZ = getElementPosition(localPlayer)

		createExplosion(pX,pY,pZ)
	end, 500, earthQuakeTime * 2)

	setTimer(function()

	    setControlState("left", false)
	    setControlState("right", false)

	    if getControlState("forwards") then

	    	local earthQuakeRandom = math.random(1,3)

		    if earthQuakeRandom == 2 then
		        setControlState("left", true)
		    elseif earthQuakeRandom == 3 then
		        setControlState("right", true)
		    end
	    end
	end, 1000, earthQuakeTime)
end)

addEventHandler("onClientPreRender", getRootElement(), function()
	for i = 1, #boltTable do
	    if boltTable[i] then
		    if boltTable[i][6] and (getTickCount() - boltTable[i][6]) / 450 >= 0 then

		        boltTable[i][4], boltTable[i][5] = interpolateBetween(-60, 0, 0, 2, 255, 0, (getTickCount() - boltTable[i][6]) / 450, "Linear")

		        if 1 < (getTickCount() - boltTable[i][6]) / 450 then
			        boltTable[i][6] = false
			        createExplosion(boltTable[i][1], boltTable[i][2], boltTable[i][3] - 2, 4, false, -1)
			        createExplosion(boltTable[i][1], boltTable[i][2], boltTable[i][3] - 1, 11, false, 0.5)
			        createFire(boltTable[i][1], boltTable[i][2], boltTable[i][3] - 2, 1)
			        setSoundMaxDistance(playSound3D("sound.mp3", boltTable[i][1], boltTable[i][2], boltTable[i][3]), 300)
		        end
		    end

		    if boltTable[i][7] and 0 <= (getTickCount() - boltTable[i][7]) / 500 then

		        boltTable[i][5] = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount() - boltTable[i][7]) / 500, "Linear")

		        if 1 < (getTickCount() - boltTable[i][7]) / 500 then
		        	table.remove(boltTable, i)
		        end
		    end

		    if boltTable[i] then
		        for c = 1, 100 do
		          	dxDrawMaterialLine3D(boltTable[i][1], boltTable[i][2], boltTable[i][3] - boltTable[i][4] + 4.5 * (c - 1), boltTable[i][1], boltTable[i][2], boltTable[i][3] - boltTable[i][4] + 4.5 * c, boltTexture, 4, tocolor(245, 245, 255, boltTable[i][5]))
		        end
		    end
	    end
	end
end)

addCommandHandler("villam", function()
	if getElementData(localPlayer, "acc.adminLevel") >= 9 then
	    boltActive = not boltActive
	    outputChatBox("#7cc576[SeeMTA]:#ffffff Villám mód " .. (boltActive and "#7cc576on" or "#d75959off") .. ".", 255, 255, 255, true)
	end
end)

addCommandHandler("diqdev", function()
	exports.strong_goldrob:startBalanceGame(1,1)
end)

addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, worldY, worldZ, clickedElement)
	if state == "down" and boltActive then
	    triggerServerEvent("onLightning", localPlayer, worldY, worldZ, clickedElement)
	end
end)
