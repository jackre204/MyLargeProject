pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local responsiveMultipler = 1

local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

local alpha = 0
local animType = "open"
local animTick = getTickCount()

local oldLastItemPosition, newLastItemPosition, lastItemPosition =  sx*0.005, sx*0.005, sx*0.005
local lastItemMoveTick = getTickCount()
local itemMoveTime = 750
local moveTimer = false

local randomInterior = math.random(1, 999)

local shopedItems = {}

local buyedItemPrice = 0

local fonts = {
    ["lcd-15"] = dxCreateFont("files/fonts/digital7.ttf", 15),
    ["barcode-15"] = dxCreateFont("files/fonts/barcode.ttf", 15),
    ["sans-17"] = dxCreateFont("files/fonts/opensans.ttf", 17),
    ["sans-12"] = dxCreateFont("files/fonts/opensans.ttf", 12),
    ["sans-15"] = dxCreateFont("files/fonts/opensans.ttf", 15),
}

local grid = {}
local conveyorBelt = {}

for i = 1, 5 do 
    table.insert(grid, {sx*0.005 + (#grid*250/myX*sx), sy*0.715, 250/myX*sx, 250/myY*sy})
end

function generateConveyors()
    conveyorBelt = {}
    for i = 1, 20 do 
        table.insert(conveyorBelt, {{0-sx*0.005 + ((i-1)*sx*0.05), sy*0.715, 141/myX*sx, 250/myY*sy}, {"open", 0, getTickCount()}, {false, getTickCount()}, true})
    end
    table.insert(conveyorBelt, {{0-141/myX*sx, sy*0.715, 141/myX*sx, 250/myY*sy}, {"open", 0, getTickCount()}, {false, getTickCount()}, true})
end
generateConveyors()

local posIndex = 0

local renderButtons = false

local buttonValues = {0, 0}

local movePed = false

function renderJobPanel()
    if animType == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount()-animTick)/300, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount()-animTick)/300, "Linear")
    end

    dxDrawRectangle(0, sy*0.7, sx, sy*0.4, tocolor(35, 35, 35, 255*alpha))


    if renderButtons then 
        buttonsC = {}


        dxDrawRectangle(sx / 2 - 300 / 2, sy / 2 - 150 / 2, 300, 150, tocolor(25, 25, 25, 255 * alpha))
        dxDrawRectangle(sx / 2 - 300 / 2 + 3, sy / 2 - 150 / 2 + 3, 300 - 6, 30, tocolor(45, 45, 45, 180 * alpha))
        dxDrawText("StrongMTA - Pénztáros", sx / 2 - 300 / 2 + 3 + 5, sy / 2 - 150 / 2 + 3 + 30 / 2, nil, nil, tocolor(200, 200, 200, 200), 0.8, fonts["sans-17"], "left", "center")

        nextColor = {60, 60, 60, 40}

        if activeButtonC == "nextCustomer" then
            nextColor = {61, 122, 188, 140}
        end

        drawButton("nextCustomer", "Tovább", sx / 2 - 300 / 2 + 10, sy / 2 - 150 / 2 + 36 + 10, 300 - 20, 40, nextColor, false, fonts["sans-17"], true)

        closeColor = {60, 60, 60, 40}


        if activeButtonC == "exitPanel" then
            closeColor = {188, 64, 61, 140}
        end

        drawButton("exitPanel", "Kilépés", sx / 2 - 300 / 2 + 10, sy / 2 - 150 / 2 + 36 + 10 + 40 + 10, 300 - 20, 40, closeColor, false, fonts["sans-17"], true)
        --dxDrawRectangle(, tocolor(45, 45, 45))

        local cx, cy = getCursorPosition()

        if tonumber(cx) and tonumber(cy) then
            cx = cx * sx
            cy = cy * sy

            activeButtonC = false
            if not buttonsC then
                return
            end
            for k,v in pairs(buttonsC) do
                if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
                    activeButtonC = k
                    break
                end
            end
        else
            activeButtonC = false
        end

        for k, v in ipairs(conveyorBelt) do 
            if v[2][1] == "open" then 
                v[2][2] = interpolateBetween(v[2][2], 0, 0, 1, 0, 0, (getTickCount() - v[2][3])/300, "Linear")
            else
                v[2][2] = interpolateBetween(v[2][2], 0, 0, 0, 0, 0, (getTickCount() - v[2][3])/300, "Linear")
            end
    
            if v[3][1] then 
                v[1][1] = interpolateBetween(v[1][1], 0, 0, v[1][1] + 5/myX*sx, 0, 0, (getTickCount() - v[3][2])/itemMoveTime, "Linear")
            end
    
            if v[4] then 
                if v[1][1] > sx then 
                    v[4] = false 
                    v[2][1] = "close"
                    v[2][3] = getTickCount()
                    table.insert(conveyorBelt, {{0 - 141/myX*sx, sy*0.715, 141/myX*sx, 250/myY*sy}, {"open", 0, getTickCount()}, {true, getTickCount()}, true})
                end
            end
    
            dxDrawRectangle(v[1][1], v[1][2], v[1][3], v[1][4], tocolor(30, 30, 30, 255*v[2][2]*alpha))
            dxDrawImage(v[1][1], v[1][2], v[1][3], v[1][4], "files/conveyorbelt.png", 0, 0, 0, tocolor(255, 255, 255, 255*v[2][2]*alpha))
        end
            
        if activeButtonC == "nextCustomer" and getKeyState("mouse1") then 
            startPedMovement(1)
            renderButtons = false
        end

        if activeButtonC == "exitPanel" and getKeyState("mouse1") then 
            closePanel()
            renderButtons = false
        end

    else
        for k, v in ipairs(conveyorBelt) do 
            if v[2][1] == "open" then 
                v[2][2] = interpolateBetween(v[2][2], 0, 0, 1, 0, 0, (getTickCount() - v[2][3])/300, "Linear")
            else
                v[2][2] = interpolateBetween(v[2][2], 0, 0, 0, 0, 0, (getTickCount() - v[2][3])/300, "Linear")
            end
    
            if v[3][1] then 
                v[1][1] = interpolateBetween(v[1][1], 0, 0, v[1][1] + 5/myX*sx, 0, 0, (getTickCount() - v[3][2])/itemMoveTime, "Linear")
            end
    
            if v[4] then 
                if v[1][1] > sx then 
                    v[4] = false 
                    v[2][1] = "close"
                    v[2][3] = getTickCount()
                    table.insert(conveyorBelt, {{0 - 141/myX*sx, sy*0.715, 141/myX*sx, 250/myY*sy}, {"open", 0, getTickCount()}, {true, getTickCount()}, true})
                end
            end
    
            dxDrawRectangle(v[1][1], v[1][2], v[1][3], v[1][4], tocolor(30, 30, 30, 255*v[2][2]*alpha))
            dxDrawImage(v[1][1], v[1][2], v[1][3], v[1][4], "files/conveyorbelt.png", 0, 0, 0, tocolor(255, 255, 255, 255*v[2][2]*alpha))
        end

        for k, v in ipairs(shopedItems) do 
            if v[3] == "show" then 
                v[4] = interpolateBetween(v[4], 0, 0, 1, 0, 0, (getTickCount()-v[2])/300, "Linear")
            else
                v[4] = interpolateBetween(v[4], 0, 0, 0, 0, 0, (getTickCount()-v[2])/300, "Linear")
            end
            
            dxDrawImage(lastItemPosition + ((k-1)*250/myX*sx), sy*0.715, 250/myX*sx, 250/myY*sy, "files/items/"..v[1]..".png", 0, 0, 0, tocolor(255, 255, 255, 255*v[4]))
            dxDrawImage(lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1] /myX*sx, sy*0.715 + buyableItems[v[1]][2] /myX*sx, sx*0.04, sy*0.03,"files/barcodes/"..v[5]..".png", 0, 0, 0, tocolor(255, 255, 255, 255*v[4]))
            --dxDrawText(v[5], lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1], sy*0.715 + buyableItems[v[1]][2], lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1] + sx*0.03, sy*0.715 + buyableItems[v[1]][2] + sy*0.03, tocolor(0, 0, 0, 255*v[4]), 0.7/myX*sx, fonts["barcode-15"], "center", "center")
        end

        lastItemPosition = interpolateBetween(oldLastItemPosition, 0, 0, newLastItemPosition, 0, 0, (getTickCount() - lastItemMoveTick)/itemMoveTime, "Linear")
    end

    dxDrawImage(sx*0.84, sy*0.43, 250/myX*sx, 250/myY*sy, "files/cash_machine.png", 0, 0, 0, tocolor(200, 200, 200, 255*alpha))
    dxDrawText(buyedItemPrice .. " $", sx*0.873, sy*0.44, sx*0.873+sx*0.09, sy*0.44+sy*0.045, tocolor(200, 200, 200, 200*alpha), 0.9/myX*sx, fonts["lcd-15"], "center", "center")

    if not renderButtons then 
        if isCursorShowing() then 
            local cx, cy = getCursorPosition()
            cx, cy = cx*sx, cy*sy 

            dxDrawLine(cx-sx*0.025, cy, cx+sx*0.025, cy, tocolor(212, 49, 49, 255*alpha), 5)
        end
    end
end

function keyJobPanel(key, state)
    if key == "mouse1" and state then 
        for k, v in ipairs(shopedItems) do 
            if isInSlot(grid[5][1], grid[5][2], grid[5][3], grid[5][4]) then 
                if isInSlot(lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1] /myX*sx, sy*0.715 + buyableItems[v[1]][2] /myX*sx, sx*0.03, sy*0.03) then 
                    if v[6] then 
                        buyedItemPrice = buyedItemPrice + buyableItems[v[1]][3]

                        playSound("files/scanner.mp3")
                        v[6] = false 
                        v[2] = getTickCount()
                        v[3] = "dissappear"
                        setTimer(function()
                            table.remove(shopedItems, #shopedItems)

                            if #shopedItems == 0 then 
                                triggerServerEvent("giveMoney", resourceRoot, buyedItemPrice)
                                playSound("files/money.mp3")
                                
                                startPedMovement(2)
                            else
                                moveConveyorBelt(1)
                            end
                        end, 300, 1)
                    end                    
                end
            end
        end
    end
end

function moveConveyorBelt(count)
    for i = 1, count do 
        setTimer(function() 
            posIndex = posIndex + 1
            lastItemMoveTick = getTickCount()
            oldLastItemPosition = lastItemPosition 
            newLastItemPosition = lastItemPosition + 250/myX*sx

            for k, v in ipairs(conveyorBelt) do 
                v[3][1] = true 
                v[3][2] = getTickCount()
            end

        end, math.max(itemMoveTime*(i-1), 100), 1) 
    end

    setTimer(function()
        for k, v in ipairs(conveyorBelt) do 
            v[3][1] = false
        end
    end, math.max(itemMoveTime*count, 100), 1)
end

function startItemMove()
    local difference = 5 - #shopedItems

    if difference > 0 then 
        moveConveyorBelt(difference)
    end
end

function generateRandomItems()
    buyedItemPrice = 0
    shopedItems = {}
    posIndex = 0
    oldLastItemPosition, newLastItemPosition, lastItemPosition =  sx*0.005, sx*0.005, sx*0.005

    for i = 1, math.random(1, 5) do 
        table.insert(shopedItems, {math.random(#buyableItems), getTickCount(), "show", 0, math.random(1, 6), true})
    end

    startItemMove()
end

local pedStopCol, pedDelCol = false, false
local erintes = false
local validModels = getValidPedModels()

function startPedMovement(state)
    if state == 1 then 
        movePed = createPed(validModels[math.random(#validModels)], -33.079513549805, -137.84886169434, 1003.546875, 270)
        setElementInterior(movePed, 16)
        setElementDimension(movePed, 99999999 + getElementData(localPlayer, "char.ID"))
        setPedAnimation(movePed, "ped", "walk_civi")
        setElementData(movePed, "ped:name", "Vásárló")

        erintes = false
    elseif state == 2 then 
        setPedAnimation(movePed, "dealer", "shop_pay", _, false)

        setTimer(function()
            setElementRotation(movePed, 0, 0, 270)
            setPedAnimation(movePed, "ped", "walk_civi")
        end, 5000, 1)
    end
end

addEventHandler("onClientColShapeHit", resourceRoot, function(element, mdim)
    if not mdim then return end
    if element == movePed then 
        if source == pedStopCol then
            if erintes then return end 
            generateRandomItems()
            setElementRotation(movePed, 0, 0, 180)
            setPedAnimation(movePed)
            erintes = true
        elseif source == pedDelCol then 
            destroyElement(movePed)
            renderButtons = true

            generateConveyors()
        end
    end
end)

function openPanel()
    animType = "open"
    animTick = getTickCount()
    addEventHandler("onClientRender", root, renderJobPanel)
    addEventHandler("onClientKey", root, keyJobPanel)
    startPedMovement(1)
    setElementAlpha(localPlayer, 0)
    setElementFrozen(localPlayer, true)
    exports.sm_hud:hideHUD()
    local x1,y1,z1,x1t,y1t,z1t = getCameraMatrix()
    smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, -21.911600112915,-140.68899536133,1004.2025756836,-21.932523727417,-139.70083618164,1004.0505981445, 1000)
    showChat(false)
end

function closePanel()
    animType = "close"
    animTick = getTickCount()
    removeEventHandler("onClientKey", root, keyJobPanel)

    setTimer(function()
        removeEventHandler("onClientRender", root, renderJobPanel)

        setElementAlpha(localPlayer, 255)
        setElementFrozen(localPlayer, false)

        exports.sm_hud:showHUD()
    end, 300, 1)

    showCursor(false)

    setCameraTarget(localPlayer, localPlayer)
    showChat(true)
end

local createdJobElements = {}

function interactionRender()
    dxDrawShadowedText("Nyomd le az "..color.."[E] #ffffffbillentyűt a belépéshez.", 0, sy*0.89, sx, sy*0.89+sy*0.05, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.9/myX*sx, fonts["sans-15"], "center", "center", false, false, false, true)
end

local startPos = {}
local inInterior = false
local outMarker = false 
local jobStartMarker = false 

function warpToShop()
    inInterior = true
    startPos = {getElementPosition(localPlayer)}

    setElementPosition(localPlayer, -26.048749923706, -141.0009765625, 1003.546875)
    setElementInterior(localPlayer, 16)
    setElementDimension(localPlayer, 99999999 + getElementData(localPlayer, "char.ID"))
    
   
    outMarker =  createMarker(-26.048749923706, -141.0009765625, 1003.546875 - 1 , "cylinder", 1.0, r, g, b, 100)
    setElementInterior(outMarker, 16)
    setElementDimension(outMarker, 99999999 + getElementData(localPlayer, "char.ID"))

    jobStartMarker =  createMarker(-22.244277954102, -140.57881164551, 1003.546875 - 1, "cylinder", 1.0, r, g, b, 100)
    setElementInterior(jobStartMarker, 16)
    setElementDimension(jobStartMarker, 99999999 + getElementData(localPlayer, "char.ID"))

    pedStopCol = createColTube(-21.196887969971, -138.61964416504, 1002.5468755, 1.3, 3)
    setElementInterior(pedStopCol, 16)
    setElementDimension(pedStopCol, 99999999 + getElementData(localPlayer, "char.ID"))

    pedDelCol = createColTube(-14.912612915039, -138.51348876953, 1002.546875, 1, 3)
    setElementInterior(pedDelCol, 16)
    setElementDimension(pedDelCol, 99999999 + getElementData(localPlayer, "char.ID"))

    setElementData(localPlayer, "playerInClientsideJobInterior", startPos)
end

function warpOutFromInterior()
    setElementPosition(localPlayer, unpack(startPos))
    setElementDimension(localPlayer, 0)
    setElementInterior(localPlayer, 0)

    inInterior = false

    destroyElement(outMarker)
    destroyElement(jobStartMarker)
    destroyElement(pedStopCol)
    destroyElement(pedDelCol)
    setCameraTarget(localPlayer, localPlayer)

    showCursor(false)

    setElementData(localPlayer, "playerInClientsideJobInterior", false)
end

addEventHandler("onClientMarkerHit", root, function(player, mdim)
    if (player == localPlayer and mdim) then 
        if not isElement(source) then return end
        
        if getElementData(source, "isCashierJobMarker") then 
            addEventHandler("onClientRender", root, interactionRender)
            bindKey("e", "up", warpToShop)
        elseif source == outMarker then 
            addEventHandler("onClientRender", root, interactionRender)
            bindKey("e", "up", warpOutFromInterior)
        elseif source == jobStartMarker then 
            openPanel()
            showCursor(true)
        end
    end
end)

addEventHandler("onClientMarkerLeave", root, function(player, mdim)
    if (player == localPlayer and mdim) then 
        if getElementData(source, "isCashierJobMarker") then 
            removeEventHandler("onClientRender", root, interactionRender)
            unbindKey("e", "up", warpToShop)
        elseif source == outMarker then 
            removeEventHandler("onClientRender", root, interactionRender)
            unbindKey("e", "up", warpOutFromInterior)
        end
    end
end)

function createJobElements()
    for k, v in ipairs(markerPositions) do 
        local marker = createMarker(v[1], v[2], v[3] - 1, "cylinder", 1.0, r, g, b, 100)
        setElementData(marker, "isCashierJobMarker", true)
        table.insert(createdJobElements, marker)

        local blip = createBlipAttachedTo(marker, 2)
        table.insert(createdJobElements, blip)
        setElementData(blip, "blipTooltipText", "Munkahely")
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "char.Job") == 6 then
        createJobElements()
    end
end)

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName)
		if dataName == "char.Job" then
            if createdJobElements then
                for k, v in ipairs(createdJobElements) do 
                    destroyElement(v)
                end
            end

            if inInterior then 
                warpOutFromInterior()
                setElementFrozen(localPlayer, false)
                setElementAlpha(localPlayer, 255)
            end

			if getElementData(localPlayer, "char.Job") == 6 then
				createJobElements()
			end
		end
	end
)

addEventHandler("onClientResourceStop", resourceRoot, function()
    for k, v in ipairs(createdJobElements) do 
        destroyElement(v)
    end

    exports.sm_hud:showHUD()

    if inInterior then 
        warpOutFromInterior()
        setElementFrozen(localPlayer, false)
        setElementAlpha(localPlayer, 255)
    end
end)

addEventHandler("onClientPlayerQuit", getRootElement(), 
    function()
        if source == localPlayer then
            outputChatBox("kileptel csoves")
            for k, v in ipairs(createdJobElements) do 
                destroyElement(v)
            end

            exports.sm_hud:showHUD()

            
        end
    end
)

addEventHandler("onPlayerQuitTakeFromInterior",
    function()
        if inInterior then 
            warpOutFromInterior()
            setElementFrozen(source, false)
            setElementAlpha(source, 255)
        end
    end
)