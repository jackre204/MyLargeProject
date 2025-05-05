local screenX, screenY = guiGetScreenSize()

function reMap(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(value)
    return value * responsiveMultipler
end

function respc(value)
    return math.ceil(value * responsiveMultipler)
end

local width = respc(500)
local height = respc(450)
local posX = screenX/2 -width/2
local posY = screenY/2 -height/2
local func = {}
local cache = {
    syncing = false,
    transactions = {},
    wheel = 0,
    font = {
        Raleway = dxCreateFont("files/fonts/Raleway.ttf", resp(15)),
        RalewaySmall = dxCreateFont("files/fonts/Raleway.ttf", resp(12))
    },
    bankname = "Credit and Commerce",
    bankname2 = "Bank of San Andreas",
    page = "",
    bank = {
        guibox = {
            amount1 = guiCreateEdit(-1000, -1000, 0, 0, "", false),
            cardnumber = guiCreateEdit(-1000, -1000, 0, 0, "", false),
            descr = guiCreateEdit(-1000, -1000, 0, 0, "", false),
            amount2 = guiCreateEdit(-1000, -1000, 0, 0, "", false),
            amount3 = guiCreateEdit(-1000, -1000, 0, 0, "", false),
            newpin = guiCreateEdit(-1000, -1000, 0, 0, "", false)
        },
        editbox = 0,
        card = {
            show = false,
            data = {},
            slot = -1,
        },
        show = false,
        pinshow = false,
        box = {
            cardnumber = {"", ""},
            pincode = {},
            numpad = {1, 2, 3, 4, 5, 6, 7, 8, 9, "X", 0, "✔"}
        }
    }
}

alpha = 0

addEventHandler("onClientResourceStart", resourceRoot,
        function()
            guiEditSetMaxLength(cache.bank.guibox.amount1, 13)
            guiEditSetMaxLength(cache.bank.guibox.cardnumber, 13)
            guiEditSetMaxLength(cache.bank.guibox.descr, 31)
            guiEditSetMaxLength(cache.bank.guibox.amount2, 13)
            guiEditSetMaxLength(cache.bank.guibox.amount3, 13)
            guiEditSetMaxLength(cache.bank.guibox.newpin, 4)
        end
)

addEventHandler("onClientGUIChanged", getRootElement(),
        function()
            if source == cache.bank.guibox.amount1 or source == cache.bank.guibox.amount2 or source == cache.bank.guibox.amount3 or source == cache.bank.guibox.newpin then
                editText = guiGetText(source)
                editText = editText:gsub("[^0-9]", "")

                guiSetText(source, editText)
            end
        end
)

function syncTransactions(type, data)
    if type == "create" then
        cache.transactions = {}
        for k, v in pairs(data) do
            cache.transactions[#cache.transactions+1] = v
        end
    elseif type == "update" then
        cache.transactions[#cache.transactions+1] = data
    end
end
addEvent("syncTransactions", true)
addEventHandler("syncTransactions", getRootElement(), syncTransactions)

function renderBankPanel()
    if isConsoleActive() then
        if cache.bank.editbox > 0 then
            cache.bank.editbox = 0
        end
    end
    renderDataDraw.buttons = {}
    if cache.bank.show then
        if cache.page == "bank.Pincode" or cache.page == "atm.Pincode" then
            dxDrawRectangle(posX, posY, width, height, tocolor(25, 25, 25))
            dxDrawRectangle(posX+resp(4), posY+resp(4), width-resp(8), resp(35), tocolor(35, 35, 35))
            exports.sm_hud:dxDrawRoundedRectangle(posX+resp(8), posY+resp(35+12), resp(492)/2, resp(304)/2, tocolor(35, 35, 35))
            dxDrawImage(posX, posY+resp(4), resp(35), resp(35), exports.sm_core:getServerLogo())
            drawText("#3d7abcStrong#ffffffMTA", posX+resp(20), posY+resp(4), width-resp(8), resp(35), tocolor(200, 200, 200, 200), 1, cache.font.Raleway, true)
            drawText("Kérjük helyezze be kártyáját. \n Majd üsse be pinkódját!", posX+resp(130), posY+resp(80), width-resp(8), resp(35), tocolor(200, 200, 200, 200), 1, cache.font.RalewaySmall)
            if cache.bank.card.show then
                dxDrawImage(posX+resp(8), posY+resp(35+12), resp(492)/2, resp(304)/2, "files/card.png")
            end
            if cache.page == "bank.Pincode" then
                drawButton("createBank", "Bankszámla\nlétrehozása", posX+resp(492)/2+resp(40), posY+height-resp(55)-resp(40)-resp(15), resp(200), resp(40), {61, 122, 188}) 
               -- drawText("Bankszámla\nlétrehozása", posX+resp(492)/2+resp(40), posY+height-resp(55)-resp(40)-resp(15), resp(200), resp(40), tocolor(200, 200, 200, 200), 0.6, cache.font.Raleway)
            end
            drawButton("closeBank", "Kilépés", posX+resp(492)/2+resp(40), posY+height-resp(55), resp(200), resp(40), {188, 64, 61})
           -- drawText("Kilépés", posX+resp(492)/2+resp(40), posY+height-resp(55), resp(200), resp(40), tocolor(200, 200, 200, 200), 1, cache.font.Raleway)

            for i = 1, 4 do
                exports.sm_hud:dxDrawRoundedRectangle(posX+resp(218)+(i*(resp(56))), posY+resp(155), resp(42), resp(42), tocolor(35, 35, 35))

                if cache.bank.box.pincode and cache.bank.box.pincode[i] then
                    drawText(toPassword(cache.bank.box.pincode[i]), posX+resp(218)+(i*(resp(56))), posY+resp(155), resp(42), resp(42), tocolor(200, 200, 200, 200), 1.2, cache.font.Raleway)
                end
            end

            local drawRow = 0
            local drawColumn = 0
            for i = 1, #cache.bank.box.numpad do

                local left = posX+resp(8)+resp(492)/4-(resp(60)*3)/2 + drawColumn * resp(60)
                local top = posY+resp(200+8) + drawRow * resp(60)
                if isInSlot(left, top, resp(46), resp(46)) then
                    exports.sm_hud:dxDrawRoundedRectangle(left, top, resp(46), resp(46), tocolor(45, 45, 45))
                else
                    exports.sm_hud:dxDrawRoundedRectangle(left, top, resp(46), resp(46), tocolor(35, 35, 35))
                end
                drawText(cache.bank.box.numpad[i], left, top, resp(46), resp(46), tocolor(200, 200, 200, 200), 1, cache.font.Raleway)

                drawColumn = drawColumn + 1
                if (drawColumn == 3) then
                    drawColumn = 0
                    drawRow = drawRow + 1
                end

            end
        elseif cache.page == "atm.LoggedIn" then
            local width, height = resp(450), resp(200)
            local posX, posY = screenX/2-width/2, screenY/2-height/2
            dxDrawRectangle(posX, posY, width, height, tocolor(25, 25, 25))
            dxDrawRectangle(posX+resp(4), posY+resp(4), width-resp(8), resp(35), tocolor(35, 35, 35))
            dxDrawImage(posX, posY+resp(4), resp(35), resp(35), exports.sm_core:getServerLogo())
            drawText("#3d7abcStrong#ffffffMTA", posX+resp(20), posY+resp(4), width-resp(8), resp(35), tocolor(200, 200, 200, 200), 1, cache.font.Raleway, true)
            dxDrawRectangle(posX+resp(10), posY+resp(50), width-resp(20), resp(32), tocolor(35, 35, 35))
            local amount3 = guiGetText(cache.bank.guibox.amount3)
            if #amount3 > 0 then
                dxDrawText(amount3, posX+resp(20), posY+resp(58), 0, 0, tocolor(200, 200, 200, 200), 0.6, cache.font.Raleway)
            end
            if cache.bank.editbox == 5 then
                local textwidth = dxGetTextWidth(amount3, 0.6, cache.font.Raleway)
                dxDrawRectangle(posX+resp(20)+textwidth, posY+resp(58), resp(1), resp(18), tocolor(200, 200, 200, alpha))
            else
                if #amount3 == 0 then
                    drawText("Összeg", posX+resp(10), posY+resp(50), width-resp(20), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)
                end
            end

            drawButton("moneyToPlayer", "Kifizetés", posX+resp(10), posY+height-resp(105), width-resp(20), resp(40), {61, 122, 188})
            --drawText("Kifizetés",posX+resp(10), posY+height-resp(105), width-resp(20), resp(40), tocolor(200, 200, 200, 200), 1, cache.font.Raleway)
            drawButton("closeBank", "Kilépés", posX+resp(10), posY+height-resp(55), width-resp(20), resp(40), {188, 64, 61})
            --drawText("Kilépés",posX+resp(10), posY+height-resp(55), width-resp(20), resp(40), tocolor(200, 200, 200, 200), 1, cache.font.Raleway)
        elseif cache.page == "bank.LoggedIn" then

            local width, height = resp(665), resp(600)
            local posX, posY = screenX/2-width/2, screenY/2-height/2
            dxDrawRectangle(posX, posY, width, height, tocolor(25, 25, 25))
            dxDrawRectangle(posX+resp(4), posY+resp(4), width-resp(8), resp(35), tocolor(35, 35, 35))
            dxDrawImage(posX, posY+resp(4), resp(35), resp(35), exports.sm_core:getServerLogo())
            drawText("#3d7abcStrong#ffffffMTA", posX+resp(20), posY+resp(4), width-resp(8), resp(35), tocolor(200, 200, 200, 200), 1, cache.font.Raleway, true)

            if cache.bank.card.data and cache.bank.card.data.num2 then
                drawText("Számlaszám: "..cache.bank.card.data.num1.."-"..cache.bank.card.data.num2, posX+resp(4), posY+resp(70), width-resp(8), resp(35), tocolor(200, 200, 200, 200), 1, cache.font.Raleway, true)
            end
            if cache.page == "bank.LoggedIn" then

                dxDrawRectangle(posX+resp(458), posY+resp(120), resp(180), resp(32), tocolor(35, 35, 35))
                local amount1 = guiGetText(cache.bank.guibox.amount1)
                if #amount1 > 0 then
                    dxDrawText(amount1, posX+resp(465), posY+resp(127), 0, 0, tocolor(200, 200, 200, 200), 0.6, cache.font.Raleway)
                end
                if cache.bank.editbox == 1 then
                    local textwidth = dxGetTextWidth(amount1, 0.6, cache.font.Raleway)
                    dxDrawRectangle(posX+resp(466)+textwidth, posY+resp(127), resp(1), resp(18), tocolor(200, 200, 200, alpha))
                else
                    if #amount1 == 0 then
                        drawText("Összeg", posX+resp(458), posY+resp(120), resp(180), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)
                    end
                end

                dxDrawRectangle(posX+resp(30), posY+resp(120), resp(414), resp(32), tocolor(35, 35, 35))
                local cardnumber = guiGetText(cache.bank.guibox.cardnumber)
                if #cardnumber > 0 then
                    dxDrawText(cardnumber, posX+resp(38), posY+resp(127), 0, 0, tocolor(200, 200, 200, 200), 0.6, cache.font.Raleway)
                end
                if cache.bank.editbox == 2 then
                    local textwidth = dxGetTextWidth(cardnumber, 0.6, cache.font.Raleway)
                    dxDrawRectangle(posX+resp(39)+textwidth, posY+resp(127), resp(1), resp(18), tocolor(200, 200, 200, alpha))
                else
                    if #cardnumber == 0 then
                        drawText("Számlaszám", posX+resp(30), posY+resp(120), resp(414), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)
                    end
                end

                dxDrawRectangle(posX+resp(30), posY+resp(166), resp(414), resp(32), tocolor(35, 35, 35))
                local descr = guiGetText(cache.bank.guibox.descr)
                if #descr > 0 then
                    dxDrawText(descr, posX+resp(38), posY+resp(173), 0, 0, tocolor(31, 58, 80), 0.6, cache.font.Raleway)
                end
                if cache.bank.editbox == 3 then
                    local textwidth = dxGetTextWidth(descr, 0.6, cache.font.Raleway)
                    dxDrawRectangle(posX+resp(39)+textwidth, posY+resp(173), resp(1), resp(18), tocolor(200, 200, 200, alpha))
                else
                    if #descr == 0 then
                        drawText("Üzenet", posX+resp(30), posY+resp(166), resp(414), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)
                    end
                end
                drawText("Készpénz befizetése", posX+resp(30), posY+resp(210), resp(414), resp(32), tocolor(200, 200, 200, 200), 0.8, cache.font.Raleway)
                drawButton("sendMoney", "Utalás", posX+resp(458), posY+resp(166), resp(180), resp(32), {61, 122, 188})
               -- drawText("Utalás", posX+resp(458), posY+resp(166), resp(180), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)

                drawText("Befizetés", posX+resp(30), posY+resp(254), resp(414), resp(32), tocolor(200, 200, 200, 200), 0.7, cache.font.Raleway)

                drawText("Készpénz felvétele", posX+resp(30), posY+resp(300), resp(414), resp(32), tocolor(200, 200, 200, 200), 0.8, cache.font.Raleway)

                dxDrawRectangle(posX+resp(30), posY+resp(254), resp(414), resp(32), tocolor(35, 35, 35))
                local amount2 = guiGetText(cache.bank.guibox.amount2)
                if #amount2 > 0 then
                    dxDrawText(amount2, posX+resp(38), posY+resp(261), 0, 0, tocolor(200, 200, 200, 200), 0.6, cache.font.Raleway)
                end
                if cache.bank.editbox == 4 then
                    local textwidth = dxGetTextWidth(amount2, 0.6, cache.font.Raleway)
                    dxDrawRectangle(posX+resp(39)+textwidth, posY+resp(261), resp(1), resp(18), tocolor(200, 200, 200, alpha))
                else
                    if #amount2 == 0 then
                        drawText("Összeg", posX+resp(30), posY+resp(254), resp(414), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)
                    end
                end

                drawButton("moneyToBank", "Befizetés", posX+resp(458), posY+resp(254), resp(180), resp(32), {61, 122, 188})
                --drawText("Befizetés", posX+resp(458), posY+resp(254), resp(180), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)
            end

            dxDrawRectangle(posX+resp(30), posY+resp(341), resp(414), resp(32), tocolor(35, 35, 35))
            local amount3 = guiGetText(cache.bank.guibox.amount3)
            if #amount3 > 0 then
                dxDrawText(amount3, posX+resp(38), posY+resp(348), 0, 0, tocolor(200, 200, 200, 200), 0.6, cache.font.Raleway)
            end
            if cache.bank.editbox == 5 then
                local textwidth = dxGetTextWidth(amount3, 0.6, cache.font.Raleway)
                dxDrawRectangle(posX+resp(39)+textwidth, posY+resp(348) , resp(1), resp(18), tocolor(200, 200, 200, alpha))
            else
                if #amount3 == 0 then
                    drawText("Összeg", posX+resp(30), posY+resp(341), resp(414), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)
                end
            end

            drawButton("moneyToPlayer", "Kifizetés", posX+resp(458), posY+resp(341), resp(180), resp(32), {61, 122, 188})
            dxDrawRectangle(posX+resp(4), posY+resp(426), resp(408), resp(34*5), tocolor(35, 35, 35))
           -- drawText("Kifizetés", posX+resp(458), posY+resp(341), resp(180), resp(32), tocolor(200, 200, 200, 200), 0.52, cache.font.Raleway)
            drawText("Számlatörténet", posX, posY+resp(380), resp(408), resp(32), tocolor(200, 200, 200, 200), 0.8, cache.font.Raleway)

            dxDrawText("Típus", posX+resp(76), posY+resp(430), 0 , 0, tocolor(200, 200, 200, 200), 0.7, cache.font.Raleway)
            dxDrawText("Összeg", posX+resp(264), posY+resp(430), 0, 0, tocolor(200, 200, 200, 200), 0.7, cache.font.Raleway)
            drawButton("closeBank", "Kilépés", posX+resp(400)+resp(40), posY+height-resp(55), resp(200), resp(40), {188, 64, 61})
           -- drawText("Kilépés", posX+resp(400)+resp(40), posY+height-resp(55), resp(200), resp(40), tocolor(200, 200, 200, 200), 1, cache.font.Raleway)
            drawSideBar(posX+resp(410), posY+height-resp(34*5)-resp(4), resp(5), resp(34*5), #cache.transactions, 4, cache.wheel, tocolor(200, 200, 200, 50))
            if cache.transactions then
                local count = 0
                for k, data in ipairs(cache.transactions) do
                    if k > cache.wheel and count < 4 then
                        if k%2 == 0 then
                            dxDrawRectangle(posX+resp(8), posY+resp(440)+(count*resp(34))+resp(20), resp(400), resp(30), tocolor(45, 45, 45))
                        else
                            dxDrawRectangle(posX+resp(8), posY+resp(440)+(count*resp(34))+resp(20), resp(400), resp(30), tocolor(55, 55, 55))
                        end
                        dxDrawText(data.type, posX+resp(102), posY+resp(440+34)+(count*resp(34)), posX+resp(102), posY+resp(440+34)+(count*resp(34)), tocolor(200, 200, 200, 200), 0.7, cache.font.Raleway, "center", "center")
                        dxDrawText(formatMoney(data.amount).." $", posX+resp(270), posY+resp(440)+resp(34) +(count*resp(34)), posX+resp(270), posY+resp(440)+resp(34) +(count*resp(34)), tocolor(200, 200, 200, 200), 0.7, cache.font.Raleway, "left", "center")
                        count = count+1
                    end
                end
            end

            if cache.bank.card.data and cache.bank.card.data.money then
                drawText("Egyenleg: #3d7abc"..formatMoney(cache.bank.card.data.money).."#c8c8c8 $", posX+resp(4), posY+resp(45), width-resp(8), resp(35), tocolor(200, 200, 200, 200), 1, cache.font.Raleway, true)
            end

            if cache.page == "bank.LoggedIn" then
                drawButton("changePin", "Pinkód\nmegváltoztatása", posX+resp(400)+resp(40), posY+height-resp(55)*2, resp(200), resp(40), {61, 122, 188})
               -- drawText("Pinkód\nmegváltoztatása", posX+resp(400)+resp(40), posY+height-resp(55)*2, resp(200), resp(40), tocolor(200, 200, 200, 200), 0.6, cache.font.Raleway)
            end


            if cache.bank.pinshow then
                dxDrawRectangle(posX+resp(400)+resp(40), posY+resp(418), resp(200), resp(28), tocolor(35, 35, 35))

                local newpin = guiGetText(cache.bank.guibox.newpin)
                dxDrawText(newpin, posX+resp(400)+resp(50), posY+resp(420), 0, 0, tocolor(200, 200, 200, 200), 0.68, cache.font.Raleway)

                if cache.bank.editbox == 6 then
                    local textwidth = dxGetTextWidth(newpin, 0.68, cache.font.Raleway)
                    dxDrawRectangle(posX+resp(400)+resp(50)+textwidth, posY+resp(423), resp(1), resp(18), tocolor(200, 200, 200, alpha))
                end
                drawButton("triggerChangePin", "Megváltoztat", posX+resp(400)+resp(40), posY+resp(418)+resp(34), resp(200), resp(28), {61, 122, 188})
                --drawText("Megváltoztat", posX+resp(400)+resp(40), posY+resp(418)+resp(34), resp(200), resp(28), tocolor(200, 200, 200, 200), 0.6, cache.font.Raleway)
            end
        end
    end
end

function clickOnAtm()
    if not cache.bank.show then
        theBulShitTimer = setTimer(function()
            if alpha == 0 then
                alpha = 255
            elseif alpha == 255 then
                alpha = 0
            end

            if cache.element and isElement(cache.element) then
                local playerX, playerY, playerZ = getElementPosition(localPlayer)
                local targetX, targetY, targetZ = getElementPosition(cache.element)
                local distance = getDistanceBetweenPoints3D (playerX, playerY, playerZ, targetX, targetY, targetZ)
                if distance > 1.5 then
                    closePanel()
                end
            end

        end, 500, 0)
        addEventHandler("onClientRender", getRootElement(), renderBankPanel)
        addEventHandler("onClientRender", getRootElement(), renderButtonProgress)
        cache.bank.show = true
        cache.page = "atm.Pincode"
        cache.element = clickedElement
        setElementData(localPlayer, "player.isBank", true)
    end
end

addEventHandler("onClientClick", getRootElement(),
        function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
            if button == "right" then
                if state == "down" then
                    if clickedElement then
                        local playerX, playerY, playerZ = getElementPosition(localPlayer)
                        local targetX, targetY, targetZ = getElementPosition(clickedElement)
                        local distance = getDistanceBetweenPoints3D (playerX, playerY, playerZ, targetX, targetY, targetZ)
                        if distance < 2 then
                            if getElementData(clickedElement, "bank:ped") then
                                if not cache.bank.show then
                                    theBulShitTimer = setTimer(function()
                                        if alpha == 0 then
                                            alpha = 255
                                        elseif alpha == 255 then
                                            alpha = 0
                                        end

                                        if cache.element and isElement(cache.element) then
                                            local playerX, playerY, playerZ = getElementPosition(localPlayer)
                                            local targetX, targetY, targetZ = getElementPosition(cache.element)
                                            local distance = getDistanceBetweenPoints3D (playerX, playerY, playerZ, targetX, targetY, targetZ)
                                            if distance > 2 then
                                                closePanel()
                                            end
                                        end

                                    end, 500, 0)
                                    addEventHandler("onClientRender", getRootElement(), renderBankPanel)
                                    addEventHandler("onClientRender", getRootElement(), renderButtonProgress)
                                    cache.bank.show = true
                                    cache.page = "bank.Pincode"
                                    cache.element = clickedElement
                                    setElementData(localPlayer, "player.isBank", true)
                                end
                            end
                        end
                    end
                end
            elseif button == "left" then
                if state == "down" then
                    if renderDataDraw.activeButton == "closeBank" then
                        closePanel()
                    end
                    if cache.bank.show then
                        if cache.page == "bank.Pincode" or cache.page == "atm.Pincode" then
                            local width, height = respc(500), respc(450)
                            local posX, posY = screenX/2 -width/2, screenY/2 -height/2
                            local drawRow = 0
                            local drawColumn = 0
                            for i = 1, #cache.bank.box.numpad do
                                local left = posX+resp(8)+resp(492)/4-(resp(60)*3)/2 + drawColumn * resp(60)
                                local top = posY+resp(200+8) + drawRow * resp(60)

                                if isInSlot(left, top, 46, 46) then
                                    if i == 10 then
                                        if #cache.bank.box.pincode > 0 then
                                            cache.bank.box.pincode[#cache.bank.box.pincode] = nil
                                        end
                                    elseif i == 12 then
                                        local pincode = ""
                                        for i = 1, #cache.bank.box.pincode do
                                            if cache.bank.box.pincode[i] then
                                                pincode = pincode..cache.bank.box.pincode[i]
                                            end
                                        end
                                        if #pincode == 4 then
                                            if cache.bank.card.data and cache.bank.card.data.pincode then
                                                if tonumber(cache.bank.card.data.pincode) == tonumber(pincode) then
                                                    if not cache.bank.card.data.used then
                                                        if cache.page == "bank.Pincode" then
                                                            cache.page = "bank.LoggedIn"
                                                        else
                                                            cache.page = "atm.LoggedIn"
                                                        end
                                                        cache.bank.box.pincode = {}
                                                        cache.bank.card.show = false
                                                        triggerServerEvent("getTransactions", localPlayer, localPlayer, cache.bank.card.data.num1.."-"..cache.bank.card.data.num2)
                                                    else
                                                        exports.sm_accounts:showInfo("e", "Ez a kártya használatban van.")
                                                    end
                                                else
                                                    exports.sm_accounts:showInfo("e", "Helytelen pinkód.")
                                                end
                                            end
                                        else
                                            exports.sm_accounts:showInfo("e", "Nem megfelelő a bevitt karakterek mennyisége.")
                                        end
                                    else
                                        if #cache.bank.box.pincode < 4 then
                                            cache.bank.box.pincode[#cache.bank.box.pincode+1] = cache.bank.box.numpad[i]
                                        end
                                    end
                                end

                                drawColumn = drawColumn + 1
                                if (drawColumn == 3) then
                                    drawColumn = 0
                                    drawRow = drawRow + 1
                                end

                            end

                            if cache.page == "bank.Pincode" then
                                local width, height = respc(500), respc(450)
                                local posX, posY = screenX/2 -width/2, screenY/2 -height/2
                                if renderDataDraw.activeButton == "createBank" then
                                    if not isTimer(spamtimer) then
                                        triggerServerEvent("createCard", localPlayer, localPlayer)
                                        spamtimer = setTimer(function()
                                            killTimer(spamtimer)
                                        end, 3500, 1)
                                    else
                                        exports.sm_accounts:showInfo("e", "Várj egy kicsit.")
                                    end
                                end
                            end
                        elseif cache.page == "atm.LoggedIn" then
                            local width, height = resp(450), resp(200)
                            local posX, posY = screenX/2-width/2, screenY/2-height/2
                            if isInSlot(posX+resp(10), posY+height-resp(55), width-resp(20), resp(40)) then
                                closePanel()
                            elseif isInSlot(posX+resp(10), posY+resp(50), width-resp(20), resp(32)) then
                                if guiEditSetCaretIndex(cache.bank.guibox.amount3, string.len(guiGetText(cache.bank.guibox.amount3))) then
                                    guiBringToFront(cache.bank.guibox.amount3)
                                    cache.bank.editbox = 5
                                end
                            elseif isInSlot(posX+resp(10), posY+height-resp(105), width-resp(20), resp(40)) then
                                if #guiGetText(cache.bank.guibox.amount3) > 0 then
                                    local bankmoney = tonumber(cache.bank.card.data.money)
                                    local amount = tonumber(guiGetText(cache.bank.guibox.amount3))
                                    if amount > 0 then
                                        if not cache.syncing then
                                            if bankmoney >= amount then
                                                triggerServerEvent("disburseBank", localPlayer, localPlayer, amount, cache.bank.card.item, cache.bank.card.data)
                                                cache.syncing = true
                                            else
                                                exports.sm_accounts:showInfo("e", "A számlán nincs elegendő egyenleg. ("..formatMoney(amount).." $)")
                                            end
                                        end
                                    end
                                end
                                cache.bank.editbox = 0
                            end
                        elseif cache.page == "bank.LoggedIn" or cache.page == "atm.LoggedIn" then
                            local width, height = resp(800), resp(600)
                            local posX, posY = screenX/2-width/2, screenY/2-height/2
                            if isInSlot(posX+resp(400)+resp(40), posY+height-resp(55), resp(200), resp(40)) then
                                closePanel()
                            end
                            if isInSlot(posX+resp(458), posY+resp(120), resp(180), resp(32)) then
                                if guiEditSetCaretIndex(cache.bank.guibox.amount1, string.len(guiGetText(cache.bank.guibox.amount1))) then
                                    guiBringToFront(cache.bank.guibox.amount1)
                                    cache.bank.editbox = 1
                                end
                            elseif isInSlot(posX+resp(30), posY+resp(120), resp(414), resp(32)) then
                                if guiEditSetCaretIndex(cache.bank.guibox.cardnumber, string.len(guiGetText(cache.bank.guibox.cardnumber))) then
                                    guiBringToFront(cache.bank.guibox.cardnumber)
                                    cache.bank.editbox = 2
                                end
                            elseif isInSlot(posX+resp(30), posY+resp(166), resp(414), resp(32)) then
                                if guiEditSetCaretIndex(cache.bank.guibox.descr, string.len(guiGetText(cache.bank.guibox.descr))) then
                                    guiBringToFront(cache.bank.guibox.descr)
                                    cache.bank.editbox = 3
                                end
                            elseif isInSlot(posX+resp(30), posY+resp(254), resp(414), resp(32)) then
                                if guiEditSetCaretIndex(cache.bank.guibox.amount2, string.len(guiGetText(cache.bank.guibox.amount2))) then
                                    guiBringToFront(cache.bank.guibox.amount2)
                                    cache.bank.editbox = 4
                                end
                            elseif isInSlot(posX+resp(30), posY+resp(341), resp(414), resp(32)) then
                                if guiEditSetCaretIndex(cache.bank.guibox.amount3, string.len(guiGetText(cache.bank.guibox.amount3))) then
                                    guiBringToFront(cache.bank.guibox.amount3)
                                    cache.bank.editbox = 5
                                end
                            elseif renderDataDraw.activeButton == "moneyToBank" then
                                if cache.page == "bank.LoggedIn" then
                                    if #guiGetText(cache.bank.guibox.amount2) > 0 then
                                        local amount = tonumber(guiGetText(cache.bank.guibox.amount2))
                                        if amount > 0 then
                                            if not cache.syncing then
                                                if getElementData(localPlayer, "char.Money") >= amount then
                                                    triggerServerEvent("depositBank", localPlayer, localPlayer, amount, cache.bank.card.item, cache.bank.card.data)
                                                    cache.syncing = true
                                                else
                                                    exports.sm_accounts:showInfo("e", "Nincs nálad elegendő pénz a befizetéshez. ("..formatMoney(amount).." $)")
                                                end
                                            end
                                        end
                                    end
                                end
                                cache.bank.editbox = 0
                            elseif renderDataDraw.activeButton == "moneyToPlayer" then
                                if #guiGetText(cache.bank.guibox.amount3) > 0 then
                                    local bankmoney = tonumber(cache.bank.card.data.money)
                                    local amount = tonumber(guiGetText(cache.bank.guibox.amount3))
                                    if amount > 0 then
                                        if not cache.syncing then
                                            if bankmoney >= amount then
                                                triggerServerEvent("disburseBank", localPlayer, localPlayer, amount, cache.bank.card.item, cache.bank.card.data)
                                                cache.syncing = true
                                            else
                                                exports.sm_accounts:showInfo("e", "A számlán nincs elegendő egyenleg. ("..formatMoney(amount).." $)")
                                            end
                                        end
                                    end
                                end
                                cache.bank.editbox = 0
                            elseif renderDataDraw.activeButton == "sendMoney" then
                                if cache.page == "bank.LoggedIn" then
                                    local width, height = resp(800), resp(600)
                                    local posX, posY = screenX/2-width/2, screenY/2-height/2
                                    if #guiGetText(cache.bank.guibox.amount1) > 0 then
                                        local bankmoney = tonumber(cache.bank.card.data.money)
                                        local amount = tonumber(guiGetText(cache.bank.guibox.amount1))
                                        local cardnumber = guiGetText(cache.bank.guibox.cardnumber)
                                        local descr = guiGetText(cache.bank.guibox.descr)
                                        local actualnumber = cache.bank.card.data.num1.."-"..cache.bank.card.data.num2
                                        if cardnumber == actualnumber then
                                           exports.sm_accounts:showInfo("e", "Saját magadnak nem utalhatsz!")
                                        else
                                            if #descr > 5 then
                                                if #cardnumber > 1 then
                                                    if amount > 0 then
                                                        if not cache.syncing then
                                                            if bankmoney >= amount then
                                                                triggerServerEvent("transferBank", localPlayer, localPlayer, amount, cache.bank.card.item, cache.bank.card.data, cardnumber, descr)
                                                                cache.syncing = true
                                                            else
                                                                exports.sm_accounts:showInfo("e", "A számlán nincs elegendő egyenleg. ("..formatMoney(amount).." $)")
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                cache.bank.editbox = 0
                            elseif renderDataDraw.activeButton == "changePin" then
                                if cache.page == "bank.LoggedIn" then
                                    cache.bank.pinshow = not cache.bank.pinshow
                                end
                                cache.bank.editbox = 0

                            elseif isInSlot(posX+resp(400)+resp(40), posY+resp(418), resp(200), resp(28)) then
                                if cache.bank.pinshow then
                                    if guiEditSetCaretIndex(cache.bank.guibox.newpin, string.len(guiGetText(cache.bank.guibox.newpin))) then
                                        guiBringToFront(cache.bank.guibox.newpin)
                                        cache.bank.editbox = 6
                                    end
                                end
                            elseif renderDataDraw.activeButton == "triggerChangePin" then
                                if cache.bank.pinshow then
                                    if #guiGetText(cache.bank.guibox.newpin) > 0 then
                                        if #guiGetText(cache.bank.guibox.newpin) == 4 then
                                            local newpin = tonumber(guiGetText(cache.bank.guibox.newpin))
                                            if tonumber(cache.bank.card.data.pincode) ~= newpin then
                                                triggerServerEvent("changePincode", localPlayer, localPlayer, cache.bank.card.item, cache.bank.card.data.pincode, newpin, cache.bank.card.data)
                                            else
                                                exports.sm_accounts:showInfo("e", "A kártyának már ez a pinkódja.")
                                            end
                                        else
                                            exports.sm_accounts:showInfo("e", "A pinkód kizárólag 4 karakter lehet.")
                                        end
                                    end
                                end
                                cache.bank.editbox = 0
                            else
                                cache.bank.editbox = 0
                            end
                        end
                    end
                end
            end
        end
)

bindKey("mouse_wheel_up", "down",
        function()
            if cache.bank.show then

                cache.wheel = cache.wheel - 1
                if cache.wheel < 1 then
                    cache.wheel = 0
                end

            end
        end
)

bindKey("mouse_wheel_down", "down",
        function()
            if cache.bank.show then

                cache.wheel = cache.wheel + 1
                if cache.wheel > #cache.transactions - 4 then
                    cache.wheel = #cache.transactions - 4
                end

            end
        end
)

function setCardDataByItem(data, slot)
    cache.bank.card.show = true
    local newData = fromJSON(data.data1)
    cache.bank.card.data = newData
    cache.bank.card.slot = slot
    cache.bank.card.item = data
end

function syncAmount(amount)
    cache.bank.card.data.money = amount
    cache.syncing = false
end
addEvent("syncAmount", true)
addEventHandler("syncAmount", getRootElement(), syncAmount)

function setCardAmount(amount)
    cache.bank.card.data.money = amount
end

function syncPincode(pincode)
    cache.bank.card.data.pincode = pincode
end
addEvent("syncPincode", true)
addEventHandler("syncPincode", getRootElement(), syncPincode)

function toPassword(password)
    local length = utfLen(password)
    return string.rep("*", length)
end

function closePanel()
    if cache.bank.show then
        cache.bank.card.show = false
        cache.bank.card.data = {}
        cache.bank.card.slot = -1
        cache.bank.card.item = false
        cache.bank.show = false
        cache.page = ""
        cache.bank.box.pincode = {}

        guiSetText(cache.bank.guibox.cardnumber, "")
        guiSetText(cache.bank.guibox.amount1, "")
        guiSetText(cache.bank.guibox.descr, "")
        guiSetText(cache.bank.guibox.amount2, "")
        guiSetText(cache.bank.guibox.amount3, "")
        guiSetText(cache.bank.guibox.newpin, "")
        cache.bank.showpin = false
        cache.bank.editbox = 0
        cache.transactions = {}
        cache.wheel = 0
        cache.element = nil
        cache.syncing = false
    end
    removeEventHandler("onClientRender", getRootElement(), renderBankPanel)
    removeEventHandler("onClientRender", getRootElement(), renderButtonProgress)
    if isTimer(theBulShitTimer) then
        killTimer(theBulShitTimer)
    end
    if isElement(theBulShitTimer) then
        destroyElement(theBulShitTimer)
    end
    setElementData(localPlayer, "player.isBank", false)
end

function isInSlot(x, y, w, h)
    if(isCursorShowing()) then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX*screenX, cursorY*screenY
        if(cursorX >= x and cursorX <= x+w and cursorY >= y and cursorY <= y+h) then
            return true
        else
            return false
        end
    end
end

function drawText(text, x, y, w, h, color, size, font, left)
    if left then
        dxDrawText(text, x+20, y+h/2, x+20, y+h/2, color, size, font, "left", "center", false, false, false, true)
    else
        dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, size, font, "center", "center", false, false, false, true)
    end
end

function drawSideBar(x, y, h, w, maxRow, seenRow, currentRow, backColor, theColor)
    if(maxRow > seenRow) then
        dxDrawRectangle(x, y, h, w, backColor or tocolor(0, 0, 0, 200))
        dxDrawRectangle(x, y+((currentRow)*(w/(maxRow))), h, w/math.max((maxRow/seenRow), 1), theColor or tocolor(61, 122, 188, 255))
    end
end

renderDataDraw = {}
renderDataDraw.colorSwitches = {}
renderDataDraw.lastColorSwitches = {}
renderDataDraw.startColorSwitch = {}
renderDataDraw.lastColorConcat = {}

function processColorSwitchEffect(key, color, duration, type)
    if not renderDataDraw.colorSwitches[key] then
        if not color[4] then
            color[4] = 255
        end

        renderDataDraw.colorSwitches[key] = color
        renderDataDraw.lastColorSwitches[key] = color

        renderDataDraw.lastColorConcat[key] = table.concat(color)
    end

    duration = duration or 500
    type = type or "Linear"

    if renderDataDraw.lastColorConcat[key] ~= table.concat(color) then
        renderDataDraw.lastColorConcat[key] = table.concat(color)
        renderDataDraw.lastColorSwitches[key] = color
        renderDataDraw.startColorSwitch[key] = getTickCount()
    end

    if renderDataDraw.startColorSwitch[key] then
        local progress = (getTickCount() - renderDataDraw.startColorSwitch[key]) / duration

        local r, g, b = interpolateBetween(
                renderDataDraw.colorSwitches[key][1], renderDataDraw.colorSwitches[key][2], renderDataDraw.colorSwitches[key][3],
                color[1], color[2], color[3],
                progress, type
        )

        local a = interpolateBetween(renderDataDraw.colorSwitches[key][4], 0, 0, color[4], 0, 0, progress, type)

        renderDataDraw.colorSwitches[key][1] = r
        renderDataDraw.colorSwitches[key][2] = g
        renderDataDraw.colorSwitches[key][3] = b
        renderDataDraw.colorSwitches[key][4] = a

        if progress >= 1 then
            renderDataDraw.startColorSwitch[key] = false
        end
    end

    return renderDataDraw.colorSwitches[key][1], renderDataDraw.colorSwitches[key][2], renderDataDraw.colorSwitches[key][3], renderDataDraw.colorSwitches[key][4]
end

function drawButton(key, label, x, y, w, h, activeColor, postGui)
    local buttonColor
    if renderDataDraw.activeButton == key then
        buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], 175})}
    else
        buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], 125})}
    end

    local alphaDifference = 175 - buttonColor[4]

    dxDrawRectangle(x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 175 - alphaDifference), postGui)
    dxDrawInnerBorder(2, x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 125 + alphaDifference), postGui)

    labelFont = Roboto18L
    postGui = postGui or false
    labelScale =  0.85

    dxDrawText(label, x, y, x + w, y + h, tocolor(200, 200, 200, 200), labelScale, cache.font.Raleway, "center", "center", false, false, postGui, true)

    renderDataDraw.buttons[key] = {x, y, w, h}
end

function dxDrawInnerBorder(thickness, x, y, w, h, color, postGUI)
    thickness = thickness or 2
    dxDrawLine(x, y, x + w, y, color, thickness, postGUI)
    dxDrawLine(x, y + h, x + w, y + h, color, thickness, postGUI)
    dxDrawLine(x, y, x, y + h, color, thickness, postGUI)
    dxDrawLine(x + w, y, x + w, y + h, color, thickness, postGUI)
end

function renderButtonProgress()
    local cx, cy = getCursorPosition()

    if tonumber(cx) and tonumber(cy) then
        cx = cx * screenX
        cy = cy * screenY

        renderDataDraw.activeButton = false
        if not renderDataDraw then
            return
        end
        for k,v in pairs(renderDataDraw.buttons) do
            if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
                renderDataDraw.activeButton = k
                break
            end
        end
    else
        renderDataDraw.activeButton = false
    end
end