pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local screenX, screenY = guiGetScreenSize()

function resp(value)
    return value * responsiveMultipler
end

function respc(value)
    return math.ceil(value * responsiveMultipler)
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

Raleway = dxCreateFont("files/Raleway.ttf", respc(11))


RalewayBig = dxCreateFont("files/Raleway.ttf", respc(14))

local page = 1

racks = {}

computercount = {}

loadedComputers = {}

lastTaken = {}

oldTable = {}

oldCount = {}

playerItemsTable = {}

local maxScroll = 11

local currentScroll = 0

local maxExchangeScroll = 10

local currentExchangeScroll = 0

local renderData = {
    x = screenX / 2 - respc(800) / 2,
    y = screenY / 2 - respc(430) / 2,
    w = respc(800),
    h = respc(430)
    
}

addEvent("addCryptoOnClient", true)
function addCryptoOnClient(obj)
    racks[obj] = {}
    computercount[obj] = getElementData(obj, "crypto.computercount")
    lastTaken[obj] = false
end
addEventHandler("addCryptoOnClient", root, addCryptoOnClient)

coronas = {}

loadedCoronas = {}

setTimer(function()
    startCoronasFade()
end, 3000, 0)

function startCoronasFade()
    startTime = getTickCount()
end

function coronasFade()
    if startTime then
        progress = (getTickCount() - startTime) / 3000
        for k,v in ipairs(loadedCoronas) do
            alpha = interpolateBetween(255, 255, 0, 0, 255, 0, progress, "Linear")
            --exports.sm_corona:setCoronaColor(v[1], v[2], v[3], v[4], alpha)
        end
    end
end
addEventHandler("onClientRender", root, coronasFade)

function hitCryptoMarker(hitElement)
    if hitElement == localPlayer then
        if getElementData(source, "crypto.marker") then
            show = true
            addEventHandler("onClientRender", root, renderCryptoPanel)
            for k,v in ipairs(getElementsByType("object")) do
                if getElementDimension(v) == getElementDimension(localPlayer) then
                    if getElementModel(v) == 7537 then
                        if getElementData(v, "crypto.computer") then
                            local fromObj = getElementData(v, "crypto.fromrack")
                            table.insert(loadedComputers, {v, getElementData(fromObj, "crypto.rackid"), getElementData(v, "crypto.computerid")})
                        end
                    end
                end
            end
		elseif getElementData(source,"crypto.builderMarker") then
            if not showBuildMenu then
                showBuildMenu = true
                playerItemsTable = exports.sm_items:getLocalPlayerItems(localPlayer)
                addEventHandler("onClientRender", root, renderCryptoBuildPanel)
            end	
        end
    end
end
addEventHandler("onClientMarkerHit", getRootElement(), hitCryptoMarker)

function leaveCryptoMarker(hitElement)
    if hitElement == localPlayer then
        if getElementData(source, "crypto.marker") then
            if show then
                show = false
                removeEventHandler("onClientRender", root, renderCryptoPanel)
                loadedComputers = {}
                selectedComputer = false
            end
		elseif getElementData(source, "crypto.builderMarker") then
			if showBuildMenu then
				showBuildMenu = false
				playerItemsTable = {}
                removeEventHandler("onClientRender", root, renderCryptoBuildPanel)
                moving = false
                moved = false
                vga1 = {}
                vga2 = {}
                vga3 = {}
                cpu = {}
                psu = {}
			end
        end
    end
end
addEventHandler("onClientMarkerLeave", getRootElement(), leaveCryptoMarker)

vga1 = {}
vga2 = {}
vga3 = {}
cpu = {}
psu = {}
currentMove = 0
local removeTick = getTickCount()

function renderCryptoBuildPanel()
    dxDrawRectangle(renderData.x, renderData.y, renderData.w, renderData.h, tocolor(25, 25, 25))
    dxDrawRectangle(renderData.x + 3, renderData.y + 3, renderData.w - 6, respc(40) - 6, tocolor(45, 45, 45))
    dxDrawText("#3d7abcStrong#c8c8c8MTA", renderData.x + 3 + respc(10), renderData.y + respc(20), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
    dxDrawRectangle(renderData.x + 3, renderData.y + respc(40), renderData.w - 2*(renderData.w/3) -3 , renderData.h - 3 - respc(80), tocolor(45, 45, 45))
    dxDrawRectangle(renderData.x + 3 + renderData.w / 3 , renderData.y + respc(40), renderData.w - 2 * (renderData.w / 3) - 3 , renderData.h - 3 - respc(80), tocolor(45, 45, 45))
    dxDrawRectangle(renderData.x + 3 + 2 * renderData.w / 3, renderData.y + respc(40), renderData.w - 2 * (renderData.w / 3) - 6 , renderData.h - 3 - respc(80), tocolor(45, 45, 45))

	if isMouseInPosition(renderData.x + 3, renderData.y + 3 + respc(40) + renderData.h - 3 - respc(80), renderData.w - 6, respc(40) - 3) then
		dxDrawRectangle(renderData.x + 3, renderData.y + 3 + respc(40) + renderData.h - 3 - respc(80), renderData.w - 6, respc(40) - 3, tocolor(61, 122, 188, 200))
		if getKeyState("mouse1") then
			--print("asd")
		end	
	else
		dxDrawRectangle(renderData.x + 3, renderData.y + 3 + respc(40) + renderData.h - 3 - respc(80), renderData.w - 6, respc(40) - 3, tocolor(45, 45, 45))

	end
    dxDrawText("#c8c8c8Összerakás", renderData.x + renderData.w / 2 - respc(50), renderData.y + 3 + respc(40) + renderData.h - 3 - respc(80) + respc(17), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
	coreCount = 0
	
	--v.data1[number]   [3] --> Név [2] --> tdp    [1] --> performance
	
    dxDrawRectangle(renderData.x + 6 + respc(268), renderData.y + 3 + respc(45) + respc(20), respc(258), respc(36), tocolor(25, 25, 25))
    dxDrawRectangle(renderData.x + 6 + respc(268), renderData.y + 3 + respc(45) + respc(60), respc(258), respc(36), tocolor(25, 25, 25))
    dxDrawRectangle(renderData.x + 6 + respc(268), renderData.y + 3 + respc(45) + respc(100), respc(258), respc(36), tocolor(25, 25, 25))
    dxDrawRectangle(renderData.x + 6 + respc(268), renderData.y + 3 + respc(45) + respc(140), respc(258), respc(36), tocolor(25, 25, 25))
    dxDrawRectangle(renderData.x + 6 + respc(268), renderData.y + 3 + respc(45) + respc(180), respc(258), respc(36), tocolor(25, 25, 25))
    if #vga1 == 0 then
        dxDrawText("VGA 1", renderData.x + 6 + respc(370), renderData.y + 3 + respc(45) + respc(27), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)
    else
        dxDrawText(vga1[1]["data1"][3], renderData.x + 6 + respc(390), renderData.y + 3 + respc(45) + respc(27), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center")
    end
    if #vga2 == 0 then
        dxDrawText("VGA 2", renderData.x + 6 + respc(370), renderData.y + 3 + respc(45) + respc(67), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)
    else
        dxDrawText(vga2[1]["data1"][3], renderData.x + 6 + respc(390), renderData.y + 3 + respc(45) + respc(67), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center")
    end
    if #vga3 == 0 then
        dxDrawText("VGA 3", renderData.x + 6 + respc(370), renderData.y + 3 + respc(45) + respc(107), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)
    else
        dxDrawText(vga3[1]["data1"][3], renderData.x + 6 + respc(390), renderData.y + 3 + respc(45) + respc(107), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center")
    end
    if #cpu == 0 then
        dxDrawText("CPU", renderData.x + 6 + respc(370), renderData.y + 3 + respc(45) + respc(147), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)
    else
        dxDrawText(cpu[1]["data1"][3], renderData.x + 6 + respc(370), renderData.y + 3 + respc(45) + respc(147), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)
    end
    if #psu == 0 then
        dxDrawText("PSU", renderData.x + 6 + respc(370), renderData.y + 3 + respc(45) + respc(187), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)
    else
        dxDrawText(psu[1]["data1"][3], renderData.x + 6 + respc(370), renderData.y + 3 + respc(45) + respc(187), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)
    end
    if isMouseInPosition(renderData.x + 6 + respc(268), renderData.y + 3 + respc(45) + respc(20), respc(258), respc(36)) then
        if moving and not getKeyState("mouse1") and removeTick + 500 <= getTickCount() and #vga1 < 1 and moving.itemId == 129 and currentMove == 0 then
			removeTick = getTickCount()
            vga1 = {moving}
            table.remove(playerItemsTable, moved)
		elseif getKeyState("mouse1") and not moving and removeTick + 500 <= getTickCount() and #vga1 > 0 then
			removeTick = getTickCount()
			iprint(vga1)
			table.insert(playerItemsTable,vga1[1])
			moved = vga1[1]
			moving = vga1[1]
            currentMove = 1
        end
    elseif isMouseInPosition(renderData.x + 6 + respc(268), renderData.y + 3 + respc(45) + respc(60), respc(258), respc(36)) then
        if moving and not getKeyState("mouse1") and removeTick + 500 <= getTickCount() and #vga2 < 1 and moving.itemId == 129 and currentMove == 0 then
			removeTick = getTickCount()
            vga2 = {moving}
            table.remove(playerItemsTable, moved)
		elseif getKeyState("mouse1") and not moving and removeTick + 500 <= getTickCount() and #vga2 > 0 then
			removeTick = getTickCount()
			iprint(vga2)
			table.insert(playerItemsTable,vga2[1])
			moved = vga2[1]
			moving = vga2[1]
            currentMove = 2
        end
    elseif isMouseInPosition(renderData.x + 6 + respc(268), renderData.y + 3 + respc(45) + respc(100), respc(258), respc(36)) then
        if moving and not getKeyState("mouse1") and removeTick + 500 <= getTickCount() and #vga3 < 1 and moving.itemId == 129 and currentMove == 0 then
			removeTick = getTickCount()
            vga3 = {moving}
            table.remove(playerItemsTable, moved)
		elseif getKeyState("mouse1") and not moving and removeTick + 500 <= getTickCount() and #vga3 > 0 then
			removeTick = getTickCount()
			iprint(vga3)
			table.insert(playerItemsTable,vga3[1])
			moved = vga3[1]
			moving = vga3[1]
            currentMove = 3
        end
    end
	for k, v in pairs(playerItemsTable) do
		if v.itemId == 128 or v.itemId == 129 or v.itemId == 130 then
			coreCount = coreCount + 1
			if k <= 8 then
				if isMouseInPosition(renderData.x + 6, renderData.y + 3 + respc(45) - respc(40) + (38 * (coreCount)), respc(258), respc(36)) then
                    if moving ~= v then
                        dxDrawRectangle(renderData.x + 6, renderData.y + 3 + respc(45) - respc(40) + (38 * (coreCount)), respc(258), respc(36) ,tocolor(25, 25, 25))
                    end							
                    if getKeyState("mouse1") and not moving and removeTick + 500 <= getTickCount() then
                        removeTick = getTickCount()
                        moving = v
                        moved = k
                        local x, y = renderData.x + 6, renderData.y + 3 + respc(45) - respc(40) + (38 * (coreCount))
                        local cx, cy = getHudCursorPos()
                        dX, dY = cx - x, cy - y
                    end
				else
                    if moving ~= v then
					    dxDrawRectangle(renderData.x + 6, renderData.y + 3 + respc(45) - respc(40) + (38 * (coreCount)), respc(258), respc(36) ,tocolor(25, 25, 25))
                    end		
				end
                cursorX, cursorY = getHudCursorPos()
                if moving and isCursorShowing() then
                    mx = cursorX - dX
                    my = cursorY - dY
                end
                if not getKeyState("mouse1") or not isCursorShowing() then
                    if currentMove > 0 then
                        if currentMove == 3 then
                            vga3 = {}
                        elseif currentMove == 2 then
                            vga2 = {}
                        elseif currentMove == 1 then
                            vga1 = {}
                        end
                        currentMove = 0
                    end
                    moving = false
                    moved = false
                end
                if moving == v then
                    dxDrawRectangle(mx, my, respc(258), respc(36), tocolor(61, 122, 188), true)
                    dxDrawText("#c8c8c8" .. v.data1[3] .. "", mx + 9, my + respc(22), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, true, true)
                else
				    dxDrawText("#c8c8c8" .. v.data1[3] .. "", renderData.x + 9, renderData.y + 3 + respc(22) + (38 * (coreCount)), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, true, true)
                end
			end
		end
	end
end

function renderCryptoPanel()
    dxDrawRectangle(renderData.x, renderData.y, renderData.w, renderData.h, tocolor(25, 25, 25))
    dxDrawRectangle(renderData.x + 3, renderData.y + 3, renderData.w - 6, respc(40) - 6, tocolor(45, 45, 45))
    dxDrawText("#3d7abcStrong#c8c8c8MTA", renderData.x + 3 + respc(10), renderData.y + respc(20), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
    dxDrawRectangle(renderData.x + 3, renderData.y + respc(40), renderData.w - 6 - respc(650), renderData.h - 3 - respc(40), tocolor(45, 45, 45))
    dxDrawRectangle(renderData.x + 3 + renderData.w - 3 - respc(650), renderData.y + respc(40), (renderData.w - 6 - (respc(145)) - 6) / 2, renderData.h - 3 - respc(40), tocolor(45, 45, 45))
    dxDrawRectangle(renderData.x + 3 + renderData.w - 3 - respc(650) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(40), (renderData.w - 6 - (respc(145)) ) / 2, renderData.h - 3 - respc(40), tocolor(45, 45, 45))
    if page == 2 then
        dxDrawRectangle(renderData.x + renderData.w - respc(660), renderData.y + respc(40), (renderData.w - 6 - (respc(145)) - 6) / 2, renderData.h - 3 - respc(40), tocolor(45, 45, 45))
        if selectedEx then
            workingComputerCount = 0
            badComputerCount = 0
            for k,v in ipairs(loadedComputers) do
                if getElementData(v[1], "crypto.computerstate") == "Working" then
                    workingComputerCount = workingComputerCount + 1
                else
                    badComputerCount = badComputerCount + 1
                end
            end
            dxDrawText(selectedEx, renderData.x + 3 + respc(200), renderData.y + respc(50), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)		
            dxDrawRectangle(renderData.x + 3 + renderData.w - 3 - respc(1120) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(70), ((renderData.w - 6 + respc(140)) / 2 ) / 4 -3, (renderData.h - 3 - respc(30))/2 - respc(50), tocolor(25, 25, 25))
            dxDrawRectangle(renderData.x + 3 + ((renderData.w - 6 + respc(140)) / 2 ) / 4 + renderData.w - 3 - respc(1120) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(70), ((renderData.w - 6 + respc(140)) / 2 ) / 4 -3, (renderData.h - 3 - respc(30))/2 - respc(50), tocolor(25, 25, 25))
            dxDrawRectangle(renderData.x + 3 + (((renderData.w - 6 + respc(140)) / 2 ) / 4) * 2 + renderData.w - 3 - respc(1120) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(70), ((renderData.w - 6 + respc(140)) / 2 ) / 4 -3, (renderData.h - 3 - respc(30))/2 - respc(50), tocolor(25, 25, 25))
            dxDrawRectangle(renderData.x + 3 + (((renderData.w - 6 + respc(140)) / 2 ) / 4) * 3 + renderData.w - 3 - respc(1120) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(70), ((renderData.w - 6 + respc(140)) / 2 ) / 4 - respc(2) , (renderData.h - 3 - respc(30))/2 - respc(50), tocolor(25, 25, 25))
            dxDrawRectangle(renderData.x + 3 + renderData.w - 3 - respc(1120) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(25) + (renderData.h - 3 - respc(30))/2, ((renderData.w - 6 + (respc(140)) ) / 2) / 3 - 3, (renderData.h - 3 - respc(30))/2, tocolor(25, 25, 25))
            dxDrawRectangle(renderData.x + 3 + ((renderData.w - 6 + (respc(140)) ) / 2) / 3 + renderData.w - 3 - respc(1120) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(70) + (renderData.h - 3 - respc(30))/2 - respc(45), ((renderData.w - 6 + (respc(140)) ) / 2) / 3 - 3, (renderData.h - 3 - respc(30))/2, tocolor(25, 25, 25))
            dxDrawRectangle(renderData.x + 3 + (((renderData.w - 6 + (respc(140)) ) / 2) / 3) * 2 + renderData.w - 3 - respc(1120) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(70) + (renderData.h - 3 - respc(30))/2 - respc(45), ((renderData.w - 6 + (respc(140)) ) / 2) / 3 - respc(2), (renderData.h - 3 - respc(30))/2, tocolor(25, 25, 25))

            dxDrawText("Összes gép", renderData.x + 3 + respc(55), renderData.y + respc(80), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)	
            dxDrawText(#loadedComputers, renderData.x + 3 + respc(55), renderData.y + respc(120), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)	
            dxDrawText("Működő gépek", renderData.x + 3 + respc(170), renderData.y + respc(80), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)		
            dxDrawText(workingComputerCount, renderData.x + 3 + respc(170), renderData.y + respc(120), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)		
            dxDrawText("Hibás gépek", renderData.x + 3 + respc(287), renderData.y + respc(80), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)	
            dxDrawText(badComputerCount, renderData.x + 3 + respc(287), renderData.y + respc(120), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)	
            dxDrawText("Valuta váltás", renderData.x + 3 + respc(410), renderData.y + respc(80), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)		

            dxDrawText(selectedEx .." / nap", renderData.x + 3 + respc(75), renderData.y + respc(280) - respc(40), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)		
            dxDrawText("".. selectedExValue .." \n(ide majd a valósat)", renderData.x + 3 + respc(75), renderData.y + respc(320) - respc(40), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)		
            dxDrawText("Birtokolt ".. selectedEx, renderData.x + 3 + respc(230), renderData.y + respc(280) - respc(40), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)		
            dxDrawText("Birtokoltat majd ide", renderData.x + 3 + respc(230), renderData.y + respc(320) - respc(40), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)		
            dxDrawText("Árfolyam", renderData.x + 3 + respc(385), renderData.y + respc(280) - respc(40), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)		

            dxDrawText(selectedExValue .." $", renderData.x + 3 + respc(385), renderData.y + respc(320) - respc(40), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center", false, false, false, true)
        else
            dxDrawText("Válassz ki egy valutát", renderData.x + 3 + respc(110), renderData.y + respc(220), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
        end
    end
    dxDrawText("Bányászható valuták", renderData.x + 3 + renderData.w - 3 - respc(575) + (renderData.w - 6 - (respc(145))) / 2, renderData.y + respc(40), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayBig)

    for k,v in ipairs(exchange) do
        if k <= maxExchangeScroll and (k > currentExchangeScroll) then
            if isMouseInPosition(renderData.x + 3 + renderData.w - 3 - respc(650) + 3 + (renderData.w - 6 - (respc(145))) / 2, renderData.y + respc(43) - 6 + respc(35)*(k-currentExchangeScroll), (renderData.w - 3 - (respc(145)) - 6) / 2 - 6, renderData.h - respc(400)) or (selectedComputer and getElementData(selectedComputer, "crypto.selectedExchange") == v["name"]) then
                dxDrawRectangle(renderData.x + 3 + renderData.w - 3 - respc(650) + 3 + (renderData.w - 6 - (respc(145))) / 2, renderData.y + respc(43) - 6 + respc(35)*(k-currentExchangeScroll), (renderData.w - 3 - (respc(145)) - 6) / 2 - 6, renderData.h - respc(400), tocolor(61, 122, 188, 150))
            else
                dxDrawRectangle(renderData.x + 3 + renderData.w - 3 - respc(650) + 3 + (renderData.w - 6 - (respc(145))) / 2, renderData.y + respc(43) - 6 + respc(35)*(k-currentExchangeScroll), (renderData.w - 3 - (respc(145)) - 6) / 2 - 6, renderData.h - respc(400), tocolor(35, 35, 35))
            end
            if page == 2 then
                dxDrawText(v["prefix"].." | "..v["name"].. "#c8c8c8", renderData.x + 3 + renderData.w - 3 - respc(645) + 3 + (renderData.w - 6 - (respc(145))) / 2, renderData.y + respc(43) - 6 + 2 + respc(35)*(k-currentExchangeScroll), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "top", false, false, false, true)
            elseif page == 1 then
                dxDrawText(v["name"].. "#c8c8c8", renderData.x + 3 + renderData.w - 3 - respc(645) + 3 + (renderData.w - 6 - (respc(145))) / 2, renderData.y + respc(43) - 6 + 2 + respc(35)*(k-currentExchangeScroll), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "top", false, false, false, true)
            end
        end
    end
    if page == 1 then
        local listSize = respc(35 * 11)
        if #loadedComputers > 11 then
            dxDrawRectangle(renderData.x + respc(145), renderData.y + respc(41) + (listSize / #loadedComputers) * math.min(currentScroll, #loadedComputers - 11), respc(3), (listSize / #loadedComputers) * 11, tocolor(61, 122, 188, 150))
        end
        for k,v in ipairs(loadedComputers) do
            if k <= maxScroll and (k > currentScroll) then
                if selectedComputer == v[1] or isMouseInPosition(renderData.x + 6, renderData.y + respc(42) + resp(35)*((k - 1)-currentScroll), respc(135), respc(30)) then
					dxDrawRectangle(renderData.x + 6, renderData.y + respc(42) + resp(35)*((k - 1)-currentScroll), respc(135), respc(30), tocolor(61, 122, 188, 150))
                else
                    dxDrawRectangle(renderData.x + 6, renderData.y + respc(42) + resp(35)*((k - 1)-currentScroll), respc(135), respc(30), tocolor(25, 25, 25))
                end
                if getElementData(v[1], "crypto.computerstate") == "Working" then
                    dxDrawImage(renderData.x + 10, renderData.y + respc(42) + resp(35)*((k - 1)-currentScroll), respc(25), respc(25), "files/power.png", 0, 0, 0, tocolor(100, 250, 100))
                elseif getElementData(v[1], "crypto.computerstate") == "Bad" then
                    dxDrawImage(renderData.x + 10, renderData.y + respc(42) + resp(35)*((k - 1)-currentScroll), respc(25), respc(25), "files/power.png", 0, 0, 0, tocolor(250, 100, 100))
                end
                dxDrawText("PC - "..v[2].. " - ".. v[3] .."", renderData.x + respc(60), renderData.y + respc(47) + resp(35)*((k - 1)-currentScroll), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)
            end
        end
        if selectedComputer then

            local gpuText = getElementData(selectedComputer, "crypto.gpu") or "Nincs videókártya"

            local cpuText = getElementData(selectedComputer, "crypto.cpu") or "Nincs processzor"

            local psuText = getElementData(selectedComputer, "crypto.psu") or "Nincs tápegység"

            dxDrawRectangle(renderData.x + respc(155), renderData.y + respc(45), respc(310), respc(35), tocolor(25, 25, 25))
            dxDrawRectangle(renderData.x + respc(155), renderData.y + respc(83), respc(310), respc(35), tocolor(25, 25, 25))
            dxDrawRectangle(renderData.x + respc(155), renderData.y + respc(121), respc(310), respc(35), tocolor(25, 25, 25))

            dxDrawText("GPU: ".. gpuText .."", renderData.x + respc(160), renderData.y + respc(50), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)

            dxDrawText("CPU: ".. cpuText .."", renderData.x + respc(160), renderData.y + respc(90), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)

            dxDrawText("PSU: ".. psuText .."", renderData.x + respc(160), renderData.y + respc(130), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway)

        end
    end
    if isMouseInPosition(renderData.x + renderData.w - respc(40), renderData.y + 5, respc(32), respc(27)) or page == 2 then
        dxDrawImage(renderData.x + renderData.w - respc(40), renderData.y + 5, respc(32), respc(27), "files/money.png", 0, 0, 0, tocolor(61, 122, 188, 150))
    else
        dxDrawImage(renderData.x + renderData.w - respc(40), renderData.y + 5, respc(32), respc(27), "files/money.png", 0, 0, 0, tocolor(200, 200, 200, 200))
    end
    if isMouseInPosition(renderData.x + renderData.w - respc(75), renderData.y + 5, respc(32), respc(27)) or page == 1 then
        dxDrawImage(renderData.x + renderData.w - respc(75), renderData.y + 5, respc(32), respc(27), "files/servers.png", 0, 0, 0, tocolor(61, 122, 188, 150))
    else
        dxDrawImage(renderData.x + renderData.w - respc(75), renderData.y + 5, respc(32), respc(27), "files/servers.png", 0, 0, 0, tocolor(200, 200, 200, 200))
    end
end

fromCol = {}

fromRackElement = {}

fromColElement = {}

saveData = {}

addEvent("addInClients", true)
function addInClients(emptypos, clickedElement)
    local posx, posy, posz = unpack(clickedElement)
    local newComputer = createObject(7537, posx, posy, posz + 0.9 + (emptypos/5))
    setElementDimension(newComputer, getElementDimension(localPlayer))
    if realPlayer == localPlayer then
        setElementData(newComputer, "crypto.computer", computercount[realElement])
        setElementData(newComputer, "crypto.fromrack", realElement)
        setElementData(realElement, "crypto.computercount", computercount[realElement] + 1)
        setElementData(newComputer, "crypto.computerslotid", emptypos)
        table.insert(racks[realElement], newComputer)
        local col = createColSphere(0, 0, 0, 0.2)
        attachElements(col, newComputer)
        setElementData(col, "crypto.colid", emptypos)
        setElementData(newComputer, "crypto.computerid", emptypos)
        setElementData(newComputer, "crypto.computerrackid", getElementData(realElement, "crypto.rackid"))
        setElementData(newComputer, "crypto.fromcol", col)
        setElementData(col, "crypto.colrack", getElementData(realElement, "crypto.rackid"))
        setElementDimension(col, getElementDimension(localPlayer))
        setElementData(newComputer, "crypto.computerstate", "Working")
        if getElementDimension(newComputer) == getElementDimension(localPlayer) then
            if getElementData(newComputer, "crypto.computerid") then
                colid = getElementData(newComputer, "crypto.fromcol")
                fromCol[newComputer] = getElementData(colid, "crypto.colid")
                fromRackElement[newComputer] = getElementData(newComputer, "crypto.fromrack")
                for key, value in ipairs(getElementsByType("marker")) do
                    if getElementData(value, "crypto.entrance") == getElementDimension(localPlayer) then
                        markerElement = value
                        if not saveData then
                            saveData = {}
                        end
                        print("lerakva")
                        table.insert(saveData, {rack = (getElementData(fromRackElement[newComputer], "crypto.rackid") or 1), slot = fromCol[newComputer], state = getElementData(newComputer, "crypto.computerstate"), selectedExchange = getElementData(newComputer, "crypto.selectedExchange")})
                        setElementData(markerElement, "crypto.data", saveData)
                        break
                    end
                end
            end
        end
    end
end
addEventHandler("addInClients", root, addInClients)

addEvent("removeInClients", true)
function removeInClients(colid, rack)
    for k,v in ipairs(getElementsByType("object")) do
        if getElementData(v, "crypto.fromcol") then
            for key, value in ipairs(getElementsByType("colshape")) do
                if getElementData(value, "crypto.colid") == colid then
                    if getElementData(value, "crypto.colid") == getElementData(v, "crypto.computerid") then
                        if getElementData(v, "crypto.computerrackid") == rack then
                            for keys, values in ipairs(getElementsByType("marker")) do
                                if getElementData(values, "crypto.entrance") == getElementDimension(localPlayer) then
                                    markerElement = values
                                    for i, save in ipairs(getElementData(markerElement, "crypto.data")) do
                                        if save.rack == getElementData(v, "crypto.computerrackid") then
                                            if save.slot == getElementData(v, "crypto.computerid") then
                                                table.remove(saveData, i)
                                                setElementData(markerElement, "crypto.data", saveData)
                                            end
                                        end
                                    end
                                end
                            end
                            destroyElement(v)
                            break
                        end
                    end
                end
            end 
        end
    end
end
addEventHandler("removeInClients", root, removeInClients)

function clickRack(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "right" and state == "down" then
        if clickedElement then
            if getElementData(clickedElement, "crypto.rackid") then
                if true == true then
                    if ((#racks[clickedElement]) or {}) < 13 then
                        computercount[clickedElement] = #racks[clickedElement]
                        setElementData(clickedElement, "crypto.computercount", #racks[clickedElement])
                        findEmptyPosition(clickedElement)
                        local x, y, z = getElementPosition(clickedElement)
                        realPlayer = localPlayer
                        realElement = clickedElement
                        --triggerServerEvent("addCryptoComputer", root, 7537, {x, y, z + 0.9 + (emptypos/5)}, {"crypto.computer", computercount[clickedElement]}, {"crypto.fromrack", clickedElement}, {"crypto.computercount", computercount[clickedElement]}, emptypos)
                        for k, v in ipairs(getElementsByType("player")) do
                            if getElementDimension(v) == getElementDimension(localPlayer) then
                                triggerServerEvent("addInServer", v, v, emptypos, {x, y, z})
                            end
                        end
                    end
                end
            elseif getElementData(clickedElement, "crypto.computer") then
                for k,v in ipairs(racks[getElementData(clickedElement, "crypto.fromrack")]) do
                    if v == clickedElement then
                        lastTaken[getElementData(clickedElement, "crypto.fromrack")] = k
                        rackElement = getElementData(clickedElement, "crypto.fromrack")
                        setElementData(rackElement, "crypto.computercount", #racks[rackElement] - 1)
                        oldTable[rackElement] = getAttachedElements(clickedElement)
                        local fromCol = getElementData(clickedElement, "crypto.fromcol")
                        oldCount[rackElement] = getElementData(fromCol, "crypto.colid")
                        rackCount = getElementData(fromCol, "crypto.colrack")
                        table.remove(racks[rackElement], k)
                        --exports.sm_corona:destroyCorona(coronas[v])
                        for k, v in ipairs(getElementsByType("player")) do
                            if getElementDimension(v) == getElementDimension(localPlayer) then
                                print(rackCount)
                                print(oldCount[rackElement])
                                triggerServerEvent("removeInServer", v, v, oldCount[rackElement], rackCount)
                            end
                        end
                    end
                end
            end
        end
    end
    if button == "left" and state == "down" then
        if show then
            for k,v in ipairs(loadedComputers) do
                if k <= maxScroll and (k > currentScroll) then
                    if isMouseInPosition(renderData.x + 6, renderData.y + respc(42)+ resp(35)*((k - 1)-currentScroll), respc(135), respc(30)) then
                        selectedComputer = v[1]
                    end
                end
            end

            for k,v in ipairs(exchange) do
                if k <= maxExchangeScroll and (k > currentExchangeScroll) then
                    if isMouseInPosition(renderData.x + 3 + renderData.w - 3 - respc(650) + 3 + (renderData.w - 6 - (respc(145))) / 2, renderData.y + respc(43) - 6 + respc(35)*(k-currentExchangeScroll), (renderData.w - 3 - (respc(145)) - 6) / 2 - 6, renderData.h - respc(400)) then
                        if selectedComputer then
                            setElementData(selectedComputer, "crypto.selectedExchange", v["name"])
                            for keys, values in ipairs(getElementsByType("object")) do
                                if getElementDimension(values) == getElementDimension(localPlayer) then
                                    if getElementData(values, "crypto.computerid") then
                                        colid = getElementData(values, "crypto.fromcol")
                                        fromCol[values] = getElementData(colid, "crypto.colid")
                                        fromRackElement[values] = getElementData(values, "crypto.fromrack")
                                        for key, value in ipairs(getElementsByType("marker")) do
                                            if getElementData(value, "crypto.entrance") == getElementDimension(localPlayer) then
                                                markerElement = value
                                                if not saveData[v] then
                                                    saveData[v] = {}
                                                end
                                                table.insert(saveData[v], {rack = (getElementData(fromRackElement[values], "crypto.rackid") or 1), slot = fromCol[values], state = getElementData(values, "crypto.computerstate"), selectedExchange = getElementData(values, "crypto.selectedExchange")})
                                                setElementData(markerElement, "crypto.data", saveData[v])
                                            end
                                        end
                                    end
                                end
                            end
                            selectedEx = v["name"]
                            selectedExValue = v["price"]
                        else
                            selectedEx = v["name"]
                            selectedExValue = v["price"]
                        end
                    end
                end
            end
            if isMouseInPosition(renderData.x + renderData.w - respc(75), renderData.y + 5, respc(32), respc(27)) then
                page = 1
            elseif isMouseInPosition(renderData.x + renderData.w - respc(40), renderData.y + 5, respc(32), respc(27)) then
                page = 2
            end
        end
    end
end
addEventHandler("onClientClick", getRootElement(), clickRack)

function findEmptyPosition(rack)
    for i = 1, 13, 1 do
        if not racks[rack][i] then
            if not oldCount[rack] then
                emptypos = i
            else
                emptypos = oldCount[rack]
                oldCount[rack] = false
            end
            break
        end
    end
end


addEventHandler("onClientKey", getRootElement(), function(button, press)
    if show then
        if isMouseInPosition(renderData.x + 3 + renderData.w - 3 - respc(650) + (renderData.w - 6 - (respc(145))) / 2 , renderData.y + respc(40), (renderData.w - 6 - (respc(145)) ) / 2, renderData.h - 3 - respc(40)) then
            if button == "mouse_wheel_up" then
                if currentExchangeScroll > 0  then
                    currentExchangeScroll = currentExchangeScroll -1
                    maxExchangeScroll = maxExchangeScroll -1
                end
            elseif button == "mouse_wheel_down" then
                if maxExchangeScroll < #exchange then
                    currentExchangeScroll = currentExchangeScroll +1
                    maxExchangeScroll = maxExchangeScroll +1
                end
            end
        else
            if button == "mouse_wheel_up" then
                if currentScroll > 0  then
                    currentScroll = currentScroll -1
                    maxScroll = maxScroll -1
                end
            elseif button == "mouse_wheel_down" then
                if maxScroll < #loadedComputers then
                    currentScroll = currentScroll +1
                    maxScroll = maxScroll +1
                end
            end
        end
    end
end)


function starResourceFunc()
    col = engineLoadCOL("models/office.col" , 8079)
    dff = engineLoadDFF("models/office.dff", 8079)
    txd = engineLoadTXD('models/office.txd')
    engineImportTXD(txd, 8079)
    engineReplaceCOL (col, 8079)
    engineReplaceModel( dff, 8079 )
    
    col = engineLoadCOL("models/rack.col" , 7638)
    dff = engineLoadDFF( "models/rack.dff", 7638)
    txd = engineLoadTXD("models/office.txd")
    engineImportTXD(txd, 7638)
    engineReplaceCOL(col, 7638)
    engineReplaceModel(dff, 7638)

    col = engineLoadCOL("models/server.col", 7537)
    dff = engineLoadDFF("models/server.dff", 7537)
    txd = engineLoadTXD("models/office.txd")
    engineImportTXD(txd, 7537)
    engineReplaceModel(dff, 7537)
    engineReplaceCOL(col, 7537)

    removeWorldModel(7637, 10000, 0, 0, 0)
    removeWorldModel(7638, 10000, 0, 0, 0)

    createObject(8079, 1506.1412353516, -1731.0256347656, 12.3828125)
    createObject(7537, 1503.1103515625, -1729.5546875, 13.6328125)
end
starResourceFunc()

function hitCryptoPlaceMarker(hitElement)
    if hitElement == localPlayer then
        if getElementData(source, "crypto.placemarker") then
            if getElementDimension(localPlayer) > 0 then
                pass = false
            else
                pass = true
            end
            placeMarkerElement = source
            bindKey("e", "down", passPlace)
        end
    end
end
addEventHandler("onClientMarkerHit", getRootElement(), hitCryptoPlaceMarker)

function leaveCryptoPlaceMarker(hitElement)
    if hitElement == localPlayer then
        if getElementData(source, "crypto.placemarker") then
            unbindKey("e", "down", passPlace)
            placeMarkerElement = false
        end
    end
end
addEventHandler("onClientMarkerLeave", getRootElement(), leaveCryptoPlaceMarker)

passrack = {}

passComputers = {}

function passPlace()
    if pass then
        local obj = createObject(8079, 1506.1412353516, -1731.0256347656, 13)
        setElementDimension(obj, getElementData(placeMarkerElement, "crypto.placemarker"))
        playerInMarker = marker
    else
        if isElement(obj) then
            destroyElement(obj)
        end
        if isElement(obj2) then
            destroyElement(obj2)
        end
        for i = 1, 8 do
            if isElement(passrack[i]) then
                destroyElement(passrack[i])
            end
        end
        if isElement(marker) then
            destroyElement(marker)
        end

        for i = 1, 180 do
            for k, v in ipairs(getElementsByType("object")) do
                if getElementModel(v) == 7537 then
                    destroyElement(v)
                end
            end
        end
        if isElement(marker) then
            destroyElement(marker)
        end
    end
    triggerServerEvent("cryptoPlacePlayer", localPlayer, localPlayer, placeMarkerElement)
    triggeredComputer = 0
    triggered = 0
end

triggeredComputer = 0

racks = {}

addEvent("createPassObjects", true)
function createPassObjects(position, state, exchange, dimension, rackid, slot, marker)
    triggeredComputer = triggeredComputer + 1
    if position and state then
        if not racks[triggered] then
            racks[triggered] = {}
        end
        local x, y, z = unpack(position)
        passComputers[triggeredComputer] = createObject(7537, x, y, z)
        setElementData(passComputers[triggeredComputer], "crypto.computerstate", state)
        setElementData(passComputers[triggeredComputer], "crypto.selectedExchange", exchange)
        setElementData(passComputers[triggeredComputer], "crypto.computer", triggeredComputer)
        setElementData(passComputers[triggeredComputer], "crypto.computerrackid", rackid)
        setElementData(passComputers[triggeredComputer], "crypto.computerslotid", slot)
        setElementDimension(passComputers[triggeredComputer], dimension)
        local col = createColSphere(0, 0, 0, 0.2)
        setElementData(col, "crypto.colid", slot)
        setElementData(col, "crypto.colrack", rackid)
        attachElements(col, passComputers[triggeredComputer])
        setElementData(passComputers[triggeredComputer], "crypto.computerid", slot)
        setElementData(passComputers[triggeredComputer], "crypto.fromcol", col)
        setElementDimension(col, dimension)
        print("created")
        playerInMarker = marker
        for k,v in ipairs(getElementsByType("object")) do
            if tonumber(getElementData(v, "crypto.rackid")) then
            end
            if tonumber(getElementData(v, "crypto.rackid")) == tonumber(getElementData(passComputers[triggeredComputer], "crypto.computerrackid")) then
                if not racks[v] then
                    racks[v] = {}
                end
                table.insert(racks[v], passComputers[triggeredComputer])
                setElementData(passComputers[triggeredComputer], "crypto.fromrack", v)
            end
        end
        lastTaken[passComputers] = false
        oldCount[passComputers] = false
        local x, y, z = getElementPosition(passComputers[triggeredComputer])
        if getElementData(passComputers[triggeredComputer], "crypto.computerstate") == "Working" then
           -- passComputers[triggeredComputer] = exports.sm_corona:createCorona(x, y + 0.55, z + 0.1, 0.05, 100, 250, 100, 255)
            table.insert(loadedCoronas, {passComputers[triggeredComputer], 100, 250, 100, 255})
        else
            --passComputers[triggeredComputer] = exports.sm_corona:createCorona(x, y + 0.55, z + 0.1, 0.05, 250, 100, 100, 255)
            table.insert(loadedCoronas, {passComputers[triggeredComputer], 250, 100, 100, 255})
        end
    end
end
addEventHandler("createPassObjects", root, createPassObjects)

triggered = 0

racks = {}


addEvent("createPassRacks", true)
function createPassRacks(id, dimension)
    triggered = triggered + 1
    passrack[triggered] = createObject(7638, 1500.4351806641+(triggered*1.42), -1740.7288818359, 12.6328125)
    setElementDimension(passrack[triggered], dimension)
    setElementData(passrack[triggered], "crypto.rackid", triggered)
    racks[passrack[triggered]] = {}
    if triggered == 1 then
        marker = createMarker(1508.1834716797, -1727.4777832031, 12.6328125, "cylinder", 2)
        setElementData(marker, "crypto.marker", true)
        setElementDimension(marker, dimension)
        builderMarker = createMarker(1509.6494140625, -1734.4781494141, 12.09375, "cylinder", 2)
        setElementData(builderMarker, "crypto.builderMarker", true)
        setElementDimension(builderMarker, dimension)
    end
end
addEventHandler("createPassRacks", root, createPassRacks)

function removeObjectFromTable(fromelement, element)
    for k, v in ipairs(racks[fromelement]) do
        if v == element then
            table.remove(racks[fromelement], k)
        end
    end
end

function getHudCursorPos()
	local cx, cy = getCursorPosition()
	if tonumber(cx) and tonumber(cy) then
		return cx * screenX, cy * screenY
	end
	return false, false
end