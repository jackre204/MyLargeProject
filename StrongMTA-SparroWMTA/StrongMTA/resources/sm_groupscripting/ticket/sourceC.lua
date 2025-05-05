local screenX, screenY = guiGetScreenSize()

local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(x)
    return math.ceil(x * responsiveMultipler)
  end

local ticketData = {}

local ticketShowState = false

local factionTickets = {
    [1] = "pd",
    [2] = "sheriff"
}

local activeFakeInput = false

function ticketCharacter(sourceCharacter)
    if activeFakeInput then
        if activeFakeInput == "money" and not tonumber(sourceCharacter) then
            return
        end

        if utf8.len(fakeInputValue[activeFakeInput]) > 5 and activeFakeInput == "money" then
            return
        end

        fakeInputValue[activeFakeInput] = utf8.insert(fakeInputValue[activeFakeInput], tostring(sourceCharacter))
    end
end

function ticketKey(sourceKey, keyState)
    if activeFakeInput then
        cancelEvent()
        if sourceKey == "backspace" and keyState then
            if string.len(fakeInputValue[activeFakeInput]) >= 1 then
                fakeInputValue[activeFakeInput] = string.sub(fakeInputValue[activeFakeInput], 1, -2)
            end
        end
    end
end

local col = createColSphere(281.08264160156, -170.72891235352, 1.4296875, 5)

function ticketClick(clickedButton, buttonState, absX, absY)
    if buttonState == "up" then
        activeFakeInput = false


        if activatedButton == "ok" then
            if not exports.sm_items:isHavePen() then
                exports.sm_hud:showInfobox("e", "Nincs nálad toll.")
                return
            end

            if ticketType == 2 then
                if not isElementWithinColShape(localPlayer, col) then
                    exports.sm_hud:showInfobox("e", "Nem vagy olyan helyen ahol a csekk befizethető!")
                    return
                end

                --triggerServerEvent("payTheTicket", localPlayer, _UPVALUE10_.dbID, _UPVALUE10_.money, _UPVALUE10_.logo)
                handwriteTicket = getTickCount()
            else
                ticketRenderData.money = tonumber(ticketRenderData.money)

                if not ticketRenderData.money then
                    exports.sm_hud:showInfobox("e", "Nem lehet üres a büntetés mező.")
                    ticketRenderData.money = ""
                    return
                end

                if not ticketRenderData.money then
                    exports.sm_hud:showInfobox("e", "Nem lehet üres a büntetés mező.")
                    ticketRenderData.money = ""
                    return
                end

                if utf8.len(ticketRenderData.name) < 1 then
                    exports.sm_hud:showInfobox("e", "Nem lehet üres a név mező.")
                    return
                end

                if ticketRenderData.money <= 0 then
                    exports.sm_hud:showInfobox("e", "Minimum 1$-t lehet a büntetés.")
                    return
                end

                if ticketRenderData.money > 150000 then
                    exports.sm_hud:showInfobox("e", "Maximum 150 000$ lehet a büntetés.")
                    return
                end

                local found = false
				local multipleFounds = false
				local invitingText = string.lower(string.gsub(fakeInputValue["name"], " ", "_"))

				for k, v in ipairs(getElementsByType("player")) do
					if getElementData(v, "loggedIn") then
					    local id = getElementData(v, "playerID")
						local name = string.lower(getElementData(v, "visibleName"):gsub(" ", "_"))
						if id == tonumber(invitingText) or string.find(name, invitingText) then
							if found then
								found = false
								multipleFounds = true
								break
							else
								found = v
							end
						end
					end
				end

                if found then
                    if multipleFounds then
                        exports.sm_hud:showInfobox("e", "Több találat van erre a névre!")
                    else
                        local foundX, foundY, foundZ = getElementPosition(found)

                        if getDistanceBetweenPoints3D(foundX, foundY, foundZ, getElementPosition(localPlayer)) < 10 then 
                           -- if found ~= localPlayer then
                                fakeInputValue["name"] = getElementData(found, "visibleName")
                                ticketRenderData.name = getElementData(found, "visibleName")

                                handwriteTicket = getTickCount()
                                exports.sm_chat:localActionC(localPlayer, "elkezd megírni egy csekket.")

                                exports.sm_items:penSetData()
                                activeFakeInput = false
                           -- else
                              --  exports.sm_hud:showInfobox("e", "Saját magad nem büntetheted meg.")
                           -- end
                        else
                            exports.sm_hud:showInfobox("e", "Nem található a közeledben '" .. fakeInputValue["name"] .. "' nevű játékos.")
                        end
                    end
                else
                    exports.sm_hud:showInfobox("e", "Nincs ilyen játékos a szerveren!")
                end
            end
        end

        if activatedButton == "cancel" then
            removeEventHandler("onClientRender", getRootElement(), renderTheTicket)
            removeEventHandler("onClientCharacter", getRootElement(), ticketCharacter)
            removeEventHandler("onClientKey", getRootElement(), ticketKey)
            removeEventHandler("onClientClick", getRootElement(), ticketClick)

            ticketShowState = false
        end

        if ticketType == 1 and not handwriteTicket then
            if absY >= screenY / 2 - respc(248) + respc(170) and absY <= screenY / 2 - respc(248) + respc(194) and absX >= screenX / 2 - respc(200) + respc(120) and absX <= screenX / 2 - respc(200) + respc(281) then
                activeFakeInput = "money"
                lineAlphaTick = getTickCount()
                _UPVALUE18_ = true
                lineAlphaKey = "alphaDown"
            elseif absX <= screenX / 2 - respc(200) + respc(375) then
                if absX >= screenX / 2 - respc(200) + respc(154) and absY <= screenY / 2 - respc(248) + respc(226) and absY >= screenY / 2 - respc(248) + respc(206) then
                    activeFakeInput = "name"
                    lineAlphaTick = getTickCount()
                    _UPVALUE18_ = true
                    lineAlphaKey = "alphaDown"
                end

                if absX >= screenX / 2 - respc(200) + respc(137) and absY <= screenY / 2 - respc(248) + respc(248) and absY >= screenY / 2 - respc(248) + respc(228) then
                    activeFakeInput = "location"
                    lineAlphaTick = getTickCount()
                    _UPVALUE18_ = true
                    lineAlphaKey = "alphaDown"
                end

                if absX >= screenX / 2 - respc(200) + respc(134) and absY <= screenY / 2 - respc(248) + respc(270) and absY >= screenY / 2 - respc(248) + respc(250) then
                    activeFakeInput = "time"
                    lineAlphaTick = getTickCount()
                    _UPVALUE18_ = true
                    lineAlphaKey = "alphaDown"
                end

                if absX >= screenX / 2 - respc(200) + respc(30) and absY <= screenY / 2 - respc(248) + respc(314) and absY >= screenY / 2 - respc(248) + respc(294) then
                    activeFakeInput = "reason"
                    lineAlphaTick = getTickCount()
                    _UPVALUE18_ = true
                    lineAlphaKey = "alphaDown"
                end

                if absX >= screenX / 2 - respc(200) + respc(123) and absY <= screenY / 2 - respc(248) + respc(380) and absY >= screenY / 2 - respc(248) + respc(360) then
                    activeFakeInput = "vehicleType"
                    lineAlphaTick = getTickCount()
                    _UPVALUE18_ = true
                    lineAlphaKey = "alphaDown"
                end

                if absX >= screenX / 2 - respc(200) + respc(153) and absY <= screenY / 2 - respc(248) + respc(401) and absY >= screenY / 2 - respc(248) + respc(381) then
                    activeFakeInput = "vehiclePlate"
                    lineAlphaTick = getTickCount()
                    _UPVALUE18_ = true
                    lineAlphaKey = "alphaDown"
                end
            end
        end
    end
end

function renderTheTicket()
    if ticketType == 1 then
        ticketRenderData[activeFakeInput] = fakeInputValue[activeFakeInput] 
    end

    local cursorX, cursorY = getCursorPosition()

    if cursorX and cursorY then
        cursorX, cursorY = cursorX * screenX, cursorY * screenY
    else
        cursorX, cursorY = 0, 0
    end

    activatedButton = false

    dxDrawImage(screenX / 2 - respc(200), screenY / 2 - respc(248), respc(400), respc(496), "files/images/ticket.png")
    dxDrawImage(screenX / 2 - respc(200), screenY / 2 - respc(248), respc(400), respc(496), "files/images/groups/" .. ticketRenderData.logo .. ".png")

    dxDrawRectangle(screenX / 2 - respc(200), screenY / 2 - respc(248) + respc(504), respc(195), respc(25), tocolor(0, 0, 0, 150))
    dxDrawRectangle(screenX / 2 - respc(200) + respc(2), screenY / 2 - respc(248) + respc(506), respc(191), respc(21), tocolor(124, 197, 118, 255))
    
    dxDrawRectangle(screenX / 2 - respc(200) + respc(205), screenY / 2 - respc(248) + respc(504), respc(195), respc(25), tocolor(0, 0, 0, 150))
    dxDrawRectangle(screenX / 2 - respc(200) + respc(207), screenY / 2 - respc(248) + respc(506), respc(191), respc(21), tocolor(215, 89, 89, 255))
    
    if not handwriteTicket and not _UPVALUE8_ and cursorX >= screenX / 2 - respc(200) and cursorY >= screenY / 2 - respc(248) + respc(504) and cursorX <= screenX / 2 - respc(200) + respc(195) and cursorY <= screenY / 2 - respc(248) + respc(529) then
        activatedButton = "ok"
    end
    
    if not handwriteTicket and not _UPVALUE8_ and cursorX >= screenX / 2 - respc(200) + respc(205) and cursorY >= screenY / 2 - respc(248) + respc(504) and cursorX <= screenX / 2 - respc(200) + respc(400) and cursorY <= screenY / 2 - respc(248) + respc(529) then
        activatedButton = "cancel"
    end

    if ticketType == 2 then
        dxDrawText("Befizetés", screenX / 2 - respc(200), screenY / 2 - respc(248) + respc(504), screenX / 2 - respc(200) + respc(195), screenY / 2 - respc(248) + respc(529), tocolor(0, 0, 0), 1, RalewayS, "center", "center")
      else
        dxDrawText("Kiállítás", screenX / 2 - respc(200), screenY / 2 - respc(248) + respc(504), screenX / 2 - respc(200) + respc(195), screenY / 2 - respc(248) + respc(529), tocolor(0, 0, 0), 1, RalewayS, "center", "center")
    end

    dxDrawText("Mégsem", screenX / 2 - respc(200) + respc(205), screenY / 2 - respc(248) + respc(504), screenX / 2 - respc(200) + respc(400), screenY / 2 - respc(248) + respc(529), tocolor(0, 0, 0), 1, RalewayS, "center", "center")

    if utf8.len(ticketRenderData.money) >= 6 then
        dxDrawText(utf8.sub(ticketRenderData.money, utf8.len(ticketRenderData.money) - 6 + 1, utf8.len(ticketRenderData.money) - 6 + 1), screenX / 2 - respc(200) + respc(120), screenY / 2 - respc(248) + respc(170), screenX / 2 - respc(200) + respc(145), screenY / 2 - respc(248) + respc(194), tocolor(20, 60, 160), 0.5, handFont, "center", "center")
    end
    if utf8.len(ticketRenderData.money) >= 5 then
        dxDrawText(utf8.sub(ticketRenderData.money, utf8.len(ticketRenderData.money) - 6 + 2, utf8.len(ticketRenderData.money) - 6 + 2), screenX / 2 - respc(200) + respc(147), screenY / 2 - respc(248) + respc(170), screenX / 2 - respc(200) + respc(172), screenY / 2 - respc(248) + respc(194), tocolor(20, 60, 160), 0.5, handFont, "center", "center")
    end
    if utf8.len(ticketRenderData.money) >= 4 then
        dxDrawText(utf8.sub(ticketRenderData.money, utf8.len(ticketRenderData.money) - 6 + 3, utf8.len(ticketRenderData.money) - 6 + 3), screenX / 2 - respc(200) + respc(174), screenY / 2 - respc(248) + respc(170), screenX / 2 - respc(200) + respc(199), screenY / 2 - respc(248) + respc(194), tocolor(20, 60, 160), 0.5, handFont, "center", "center")
    end
    if utf8.len(ticketRenderData.money) >= 3 then
        dxDrawText(utf8.sub(ticketRenderData.money, utf8.len(ticketRenderData.money) - 6 + 4, utf8.len(ticketRenderData.money) - 6 + 4), screenX / 2 - respc(200) + respc(202), screenY / 2 - respc(248) + respc(170), screenX / 2 - respc(200) + respc(227), screenY / 2 - respc(248) + respc(194), tocolor(20, 60, 160), 0.5, handFont, "center", "center")
    end
    if 2 <= utf8.len(ticketRenderData.money) then
        dxDrawText(utf8.sub(ticketRenderData.money, utf8.len(ticketRenderData.money) - 6 + 5, utf8.len(ticketRenderData.money) - 6 + 5), screenX / 2 - respc(200) + respc(229), screenY / 2 - respc(248) + respc(170), screenX / 2 - respc(200) + respc(254), screenY / 2 - respc(248) + respc(194), tocolor(20, 60, 160), 0.5, handFont, "center", "center")
    end
    if 1 <= utf8.len(ticketRenderData.money) then
        dxDrawText(utf8.sub(ticketRenderData.money, utf8.len(ticketRenderData.money) - 6 + 6, utf8.len(ticketRenderData.money) - 6 + 6), screenX / 2 - respc(200) + respc(256), screenY / 2 - respc(248) + respc(170), screenX / 2 - respc(200) + respc(281), screenY / 2 - respc(248) + respc(194), tocolor(20, 60, 160), 0.5, handFont, "center", "center")
    end

    if lineAlphaKey == "alphaDown" then
        lineAlphaProgress = interpolateBetween(225, 0, 0, 0, 0, 0, (getTickCount() - lineAlphaTick) / 1000, "Linear")
        if (getTickCount() - lineAlphaTick) / 1000 >= 1 then
            lineAlphaTick = getTickCount()
            lineAlphaKey = "alphaUp"
        end
    elseif lineAlphaKey == "alphaUp" then
        lineAlphaProgress = interpolateBetween(0, 0, 0, 225, 0, 0, (getTickCount() - lineAlphaTick) / 1000, "Linear")
        if (getTickCount() - lineAlphaTick) / 1000 >= 1 then
            lineAlphaTick = getTickCount()
            lineAlphaKey = "alphaDown"
        end
    end

    dxDrawText(ticketRenderData.name:gsub("_", " "), screenX / 2 - respc(200) + respc(154), 0, 0, screenY / 2 - respc(248) + respc(226), tocolor(20, 60, 160, 225), 0.45, handFont, "left", "bottom")
    if _UPVALUE18_ and activeFakeInput == "name" then
        dxDrawLine(screenX / 2 - respc(200) + respc(154) + math.ceil(dxGetTextWidth(ticketRenderData.name, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(223), screenX / 2 - respc(200) + respc(154) + math.ceil(dxGetTextWidth(ticketRenderData.name, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(208), tocolor(20, 60, 160, lineAlphaProgress), 2)
    end

    dxDrawText(ticketRenderData.location, screenX / 2 - respc(200) + respc(137), 0, 0, screenY / 2 - respc(248) + respc(248), tocolor(20, 60, 160, 225), 0.45, handFont, "left", "bottom")
    if _UPVALUE18_ and activeFakeInput == "location" then
        dxDrawLine(screenX / 2 - respc(200) + respc(137) + math.ceil(dxGetTextWidth(ticketRenderData.location, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(245), screenX / 2 - respc(200) + respc(137) + math.ceil(dxGetTextWidth(ticketRenderData.location, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(230), tocolor(20, 60, 160, lineAlphaProgress), 2)
    end

    dxDrawText(ticketRenderData.time, screenX / 2 - respc(200) + respc(134), 0, 0, screenY / 2 - respc(248) + respc(270), tocolor(20, 60, 160, 225), 0.45, handFont, "left", "bottom")
    if _UPVALUE18_ and activeFakeInput == "time" then
        dxDrawLine(screenX / 2 - respc(200) + respc(134) + math.ceil(dxGetTextWidth(ticketRenderData.time, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(267), screenX / 2 - respc(200) + respc(134) + math.ceil(dxGetTextWidth(ticketRenderData.time, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(252), tocolor(20, 60, 160, lineAlphaProgress), 2)
    end

    dxDrawText(ticketRenderData.reason, screenX / 2 - respc(200) + respc(30), 0, 0, screenY / 2 - respc(248) + respc(314), tocolor(20, 60, 160, 225), 0.45, handFont, "left", "bottom")
    if _UPVALUE18_ and activeFakeInput == "reason" then
        dxDrawLine(screenX / 2 - respc(200) + respc(30) + math.ceil(dxGetTextWidth(ticketRenderData.reason, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(311), screenX / 2 - respc(200) + respc(30) + math.ceil(dxGetTextWidth(ticketRenderData.reason, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(296), tocolor(20, 60, 160, lineAlphaProgress), 2)
    end

    dxDrawText(ticketRenderData.vehicleType, screenX / 2 - respc(200) + respc(123), 0, 0, screenY / 2 - respc(248) + respc(380), tocolor(20, 60, 160, 225), 0.45, handFont, "left", "bottom")
    if _UPVALUE18_ and activeFakeInput == "vehicleType" then
        dxDrawLine(screenX / 2 - respc(200) + respc(123) + math.ceil(dxGetTextWidth(ticketRenderData.vehicleType, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(377), screenX / 2 - respc(200) + respc(123) + math.ceil(dxGetTextWidth(ticketRenderData.vehicleType, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(362), tocolor(20, 60, 160, lineAlphaProgress), 2)
    end

    dxDrawText(ticketRenderData.vehiclePlate, screenX / 2 - respc(200) + respc(153), 0, 0, screenY / 2 - respc(248) + respc(401), tocolor(20, 60, 160, 225), 0.45, handFont, "left", "bottom")
    if _UPVALUE18_ and activeFakeInput == "vehiclePlate" then
        dxDrawLine(screenX / 2 - respc(200) + respc(153) + math.ceil(dxGetTextWidth(ticketRenderData.vehiclePlate, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(398), screenX / 2 - respc(200) + respc(153) + math.ceil(dxGetTextWidth(ticketRenderData.vehiclePlate, 0.45, handFont) + 3), screenY / 2 - respc(248) + respc(383), tocolor(20, 60, 160, lineAlphaProgress), 2)
    end

    if ticketType == 2 then
        dxDrawText(ticketRenderData.policeOfficer, screenX / 2 - respc(200) + respc(287 - dxGetTextWidth(ticketRenderData.policeOfficer, 0.75, lunabarFont) / 2), 0, screenX / 2 - respc(200) + respc(287 - dxGetTextWidth(ticketRenderData.policeOfficer, 0.75, lunabarFont) / 2) + dxGetTextWidth(ticketRenderData.policeOfficer, 0.75, lunabarFont), screenY / 2 - respc(248) + respc(457), tocolor(20, 60, 160, 225), 0.75, lunabarFont, "left", "bottom", true)
    end

    if ticketType >= 2 then
        if ticketType == 2 and tonumber(handwriteTicket) then
            if (getTickCount() - handwriteTicket) / 3579 >= 1.25 then
                removeEventHandler("onClientRender", getRootElement(), renderTheTicket)
                removeEventHandler("onClientCharacter", getRootElement(), ticketCharacter)
                removeEventHandler("onClientKey", getRootElement(), ticketKey)
                removeEventHandler("onClientClick", getRootElement(), ticketClick)

                ticketShowState = false

                destroyFonts()
                return
            end

            dxDrawText(ticketRenderData.name:gsub("_", " "), screenX / 2 - respc(200) + respc(111 - dxGetTextWidth(ticketRenderData.name, 0.75, lunabarFont) / 2), 0, screenX / 2 - respc(200) + respc(111 - dxGetTextWidth(ticketRenderData.name, 0.75, lunabarFont) / 2) + interpolateBetween(0, 0, 0, dxGetTextWidth(ticketRenderData.name, 0.75, lunabarFont), 0, 0, (getTickCount() - handwriteTicket) / 3579, "Linear"), screenY / 2 - respc(248) + respc(457), tocolor(20, 60, 160, 225), 0.75, lunabarFont, "left", "bottom", true)
        end
    end

    if ticketType >= 1 then
        if tonumber(handwriteTicket) and ticketType == 1 then
            if (getTickCount() - handwriteTicket) / 3579 >= 1.25 then
                removeEventHandler("onClientRender", getRootElement(), renderTheTicket)
                removeEventHandler("onClientCharacter", getRootElement(), ticketCharacter)
                removeEventHandler("onClientKey", getRootElement(), ticketKey)
                removeEventHandler("onClientClick", getRootElement(), ticketClick)

                ticketShowState = false

                exports.sm_chat:localActionC(localPlayer, "letépi a csekket, és átadja " .. ticketRenderData.name:gsub("_", " ") .. "-nak/nek.")

                triggerServerEvent("addItem", localPlayer, localPlayer, 136, 1, false, ticketRenderData, false, 0)

                iprint(ticketRenderData)
                
                return
            end
            dxDrawText(ticketRenderData.policeOfficer, screenX / 2 - respc(200) + respc(287 - dxGetTextWidth(ticketRenderData.policeOfficer, 0.75, lunabarFont) / 2), 0, screenX / 2 - respc(200) + respc(287 - dxGetTextWidth(ticketRenderData.policeOfficer, 0.75, lunabarFont) / 2) + interpolateBetween(0, 0, 0, dxGetTextWidth(ticketRenderData.policeOfficer, 0.75, lunabarFont), 0, 0, (getTickCount() - handwriteTicket) / 3579, "Linear"), screenY / 2 - respc(248) + respc(457), tocolor(20, 60, 160, 225), 0.75, lunabarFont, "left", "bottom", true)
        end
    end
end

function openTheTicketBook(itemID, itemFaction)
    if not ticketShowState then
        ticketShowState = true

        openTicketPanel()

        if not factionTickets[itemFaction] then
            itemFaction = "pd"
        end

        ticketRenderData = {
            logo = itemFaction,
            money = "",
            name = "",
            location = "",
            time = "",
            reason = "",
            vehicleType = "",
            vehiclePlate = "",
            policeOfficer = getElementData(localPlayer, "visibleName"):gsub("_", " ")
        }

        ticketType = 1
        handwriteTicket = false

    else
        ticketShowState = false

        closeTicketPanel()

        exports.lv_chat:localActionC(localPlayer, "elrak egy csekkfüzetet.")
    end
end

addCommandHandler("ticket",
    function()
        openTheTicketBook(1, "pd")
    end
)

local defaultData = {
    logo = "pd",
    money = "20002",
    name = "Wardis D Cavan",
    location = "Anyad",
    time = "2021-08-30",
    reason = "Apad",
    vehicleType = "",
    vehiclePlate = "",
    policeOfficer = "Turos Fasz"
}

addCommandHandler("showticket",
    function()
        openTheTicket(2, toJSON(defaultData))
    end
)


function openTheTicket(itemID, itemData)
    if not ticketShowState then
        ticketRenderData = fromJSON(itemData) or {}
        ticketRenderData.dbID = itemID

        openTicketPanel()

        ticketType = 2
        handwriteTicket = false
        ticketShowState = true

        exports.sm_chat:localActionC(localPlayer, "elővesz egy csekket.")
    else
        closeTicketPanel()

        ticketShowState = false

        exports.sm_chat:localActionC(localPlayer, "elrak egy csekket.")
    end
end

function openTicketPanel()
    fakeInputValue = {
        ["money"] = "",
        ["name"] = "",
        ["location"] = "",
        ["time"] = "",
        ["reason"] = "",
        ["vehicleType"] = "",
        ["vehiclePlate"] = ""
    }

    addEventHandler("onClientRender", getRootElement(), renderTheTicket)
    addEventHandler("onClientCharacter", getRootElement(), ticketCharacter)
    addEventHandler("onClientKey", getRootElement(), ticketKey)
    addEventHandler("onClientClick", getRootElement(), ticketClick)
end

function closeTicketPanel()
    removeEventHandler("onClientRender", getRootElement(), renderTheTicket)
    removeEventHandler("onClientCharacter", getRootElement(), ticketCharacter)
    removeEventHandler("onClientKey", getRootElement(), ticketKey)
    removeEventHandler("onClientClick", getRootElement(), ticketClick)
end