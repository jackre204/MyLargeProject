local selectedCategory = "GPUs"

local screenX, screenY = guiGetScreenSize()

local ped = createPed(10, 1108.2890625, -1140.5269775391, 23.65625)

setElementData(ped, "crypto.buyPed", true)

show = false

local buyPos = {
    x = screenX / 2 - respc(550) / 2,
    y = screenY / 2 - respc(430) / 2,
    w = respc(600),
    h = respc(430)
    
}

local currentBuyScroll = 0
local maxBuyScroll = 9

function click(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "right" and state == "down" then
        if clickedElement and isElement(clickedElement) then
            if getElementData(clickedElement, "crypto.buyPed") then
                show = true
                addEventHandler("onClientRender", root, renderCryptoBuy)
            end
        end
    end
    if button == "left" and state == "down" then
        if show then
            if isMouseInPosition(buyPos.x + 3 + respc(60), buyPos.y + respc(48), respc(110), respc(20)) then
                selectedCategory = "GPUs"
            elseif isMouseInPosition(buyPos.x + 3 + respc(240), buyPos.y + respc(48), respc(110), respc(20)) then
                selectedCategory = "CPUs"
            elseif isMouseInPosition(buyPos.x + 3 + respc(420), buyPos.y + respc(48), respc(110), respc(20)) then
                selectedCategory = "PSUs"
            end
            for k,v in ipairs(cryptoItems[selectedCategory]) do
                if k <= maxBuyScroll and (k > currentBuyScroll) then
                    if activeButtonC == "cryptobuy"..v["itemData"]["name"].."" then
                        triggerServerEvent("cryptoAddItem", localPlayer, v["itemId"], localPlayer, v["itemData"]["price"], v["itemData"]["performance"], v["itemData"]["tdp"], v["itemData"]["name"])
                    end
                end
            end
        end
    end
end
addEventHandler("onClientClick", getRootElement(), click)

RalewayMedium = dxCreateFont("files/Raleway.ttf", respc(12))

function renderCryptoBuy()

    buttonsC = {}

    dxDrawRectangle(buyPos.x, buyPos.y, buyPos.w, buyPos.h, tocolor(25, 25, 25))
    dxDrawRectangle(buyPos.x + 3, buyPos.y + 3, buyPos.w - 6, respc(40) - 6, tocolor(45, 45, 45))
    dxDrawText("#3d7abcStrong#c8c8c8MTA - Alkatrész vásárlás", buyPos.x + 3 + respc(10), buyPos.y + respc(20), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
    if isMouseInPosition(buyPos.x + 3 + respc(60), buyPos.y + respc(48), respc(110), respc(20)) or selectedCategory == "GPUs" then
        dxDrawText("Videókártyák", buyPos.x + 3 + respc(60), buyPos.y + respc(52), nil, nil, tocolor(200, 200, 200, 250), 1, RalewayBig, "left", "center", false, false, false, true)
    else
        dxDrawText("Videókártyák", buyPos.x + 3 + respc(60), buyPos.y + respc(52), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayBig, "left", "center", false, false, false, true)
    end
    if isMouseInPosition(buyPos.x + 3 + respc(240), buyPos.y + respc(48), respc(110), respc(20)) or selectedCategory == "CPUs" then
        dxDrawText("Processzorok", buyPos.x + 3 + respc(240), buyPos.y + respc(52), nil, nil, tocolor(200, 200, 200, 250), 1, RalewayBig, "left", "center", false, false, false, true)
    else
        dxDrawText("Processzorok", buyPos.x + 3 + respc(240), buyPos.y + respc(52), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayBig, "left", "center", false, false, false, true)
    end
    if isMouseInPosition(buyPos.x + 3 + respc(420), buyPos.y + respc(48), respc(110), respc(20)) or selectedCategory == "PSUs" then
        dxDrawText("Tápegységek", buyPos.x + 3 + respc(420), buyPos.y + respc(52), nil, nil, tocolor(200, 200, 200, 250), 1, RalewayBig, "left", "center", false, false, false, true)
    else
        dxDrawText("Tápegységek", buyPos.x + 3 + respc(420), buyPos.y + respc(52), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayBig, "left", "center", false, false, false, true)
    end

    for k,v in ipairs(cryptoItems[selectedCategory]) do
        if k <= maxBuyScroll and (k > currentBuyScroll) then
            if k % 2 ~= 0 then
                buyColor = tocolor(15, 15, 15)
            else
                buyColor= tocolor(35, 35, 35)
            end
            dxDrawRectangle(buyPos.x + respc(10), buyPos.y + respc(38) - 6 + respc(40)*(k-currentBuyScroll), respc(580), respc(35), buyColor)
            if v["itemData"]["tdp"] > 0 then
                dxDrawText(""..v["itemData"]["name"].."  | Power: #3d7abc".. v["itemData"]["performance"] .." #c8c8c8%  | TDP: #3d7abc".. v["itemData"]["tdp"] .. " #c8c8c8W  | Ár: #3d7abc"..v["itemData"]["price"].." $", buyPos.x + respc(20), buyPos.y + respc(38) - 2 + respc(40)*(k-currentBuyScroll), nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "top", false, false, false, true)
            else
                dxDrawText(""..v["itemData"]["name"].."  | Power: #3d7abc".. v["itemData"]["performance"] .." #c8c8c8W  | Ár: #3d7abc"..v["itemData"]["price"].." $", buyPos.x + respc(20), buyPos.y + respc(38) - 2 + respc(40)*(k-currentBuyScroll), nil, nil, tocolor(200, 200, 200, 200), 1, RalewayMedium, "left", "top", false, false, false, true)
            end
            drawButton("cryptobuy"..v["itemData"]["name"].."", "Vásárlás", buyPos.x + respc(495), buyPos.y + respc(38) - 3 + respc(40)*(k-currentBuyScroll), respc(90), respc(30), {61, 122, 188}, false, RalewayMedium)
        end
    end

    local relX, relY = getCursorPosition()

    activeButtonC = false

    if relX and relY then
        relX = relX * screenX
        relY = relY * screenY

        for k, v in pairs(buttonsC) do
            if relX >= v[1] and relY >= v[2] and relX <= v[1] + v[3] and relY <= v[2] + v[4] then
                activeButtonC = k
                break
            end
        end
    end
end


function exitCryptoBuy()
    if show then
        show = false
        removeEventHandler("onClientRender", root, renderCryptoBuy)
    end
end
bindKey("backspace", "down", exitCryptoBuy)

addEventHandler("onClientKey", getRootElement(), function(button, press)
    if show then
        if button == "mouse_wheel_up" then
            if currentBuyScroll > 0  then
                currentBuyScroll = currentBuyScroll -1
                maxBuyScroll = maxBuyScroll -1
            end
        elseif button == "mouse_wheel_down" then
            if maxBuyScroll < #cryptoItems[selectedCategory] then
                currentBuyScroll = currentBuyScroll +1
                maxBuyScroll = maxBuyScroll +1
            end
        end
    end
end)