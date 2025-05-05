pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local screenX, screenY = guiGetScreenSize()

local responsiveMultipler = 1

local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

function createFonts()
	destroyFonts()
	Raleway = dxCreateFont("files/Raleway.ttf", respc(11), false, "antialiased")
end

function destroyFonts()
	if isElement(Raleway) then
		destroyElement(Raleway)
	end
end

local enabledButtons = 0

local bulletDamages = false

local canOperate = false
local canStitch = false

local renderDamageData = {
    sizeX = respc(300),
    sizeY = respc(50)
}

local bulletLocation = {
	[3] = "törzsben",
	[4] = "medencében",
	[5] = "bal kézben",
	[6] = "jobb kézben",
	[7] = "bal lábban",
	[8] = "jobb lábban",
	[9] = "fejben"
}

local surfaceLocation = {
	[3] = "törzsön",
	[4] = "medencén",
	[5] = "bal kézen",
	[6] = "jobb kézen",
	[7] = "bal lábon",
	[8] = "jobb lábon",
	[9] = "fejen"
}

local bulletOperation = {
	[3] = "törzséből",
	[4] = "medencéjéből",
	[5] = "bal kezéből",
	[6] = "jobb kezéből",
	[7] = "bal lábából",
	[8] = "jobb lábából",
	[9] = "fejéből"
}

local stitchOperation = {
	[3] = "törzsén",
	[4] = "medencéjén",
	[5] = "bal kezén",
	[6] = "jobb kezén",
	[7] = "bal lábán",
	[8] = "jobb lábán",
	[9] = "fején"
}

function dogElementStreamed()
    if getElementType(source) == "ped" then
        if getElementData(source, "animal.animalId") then
            if getElementData(source, "animal.ownerId") == getElementData(localPlayer, "char.ID") then
                animalElement = source
            end
        end
    end 
end
addEventHandler("onClientElementStreamIn", getRootElement(), dogElementStreamed)

function renderClickPanel()
    if renderData.sourceElement and isElement(renderData.sourceElement) then
        buttonsC = {}

        local worldX, worldY, worldZ = getPositionFromElementOffset(renderData.sourceElement, 0, 0, -0.2)
        local worldDamageX, worldDamageY, worldDamageZ = getPositionFromElementOffset(renderData.sourceElement, 0, 0, 0.3)

        if worldX and worldY and worldZ then
            local posX, posY = getScreenFromWorldPosition(worldX, worldY, worldZ)
            local damageX, damageY = getScreenFromWorldPosition(worldDamageX, worldDamageY, worldDamageZ)

            if posX and posY then
                if bulletDamages then
                    local damages = {}

                    for data, amount in pairs(bulletDamages) do
                        local typ = gettok(data, 1, ";")
                        local part = tonumber(gettok(data, 2, ";"))

                        if typ == "stitch-cut" then
                            table.insert(damages, {"Összevart vágás a " .. surfaceLocation[part]})
                        elseif typ == "stitch-hole" then
                            table.insert(damages, {"Összevart golyó helye a " .. surfaceLocation[part]})
                        elseif typ == "punch" then
                            table.insert(damages, {"Ütések a " .. surfaceLocation[part]})
                        elseif typ == "hole" then
                            table.insert(damages, {amount .. " golyó helye a " .. surfaceLocation[part], false, data})
                        elseif typ == "cut" then
                            table.insert(damages, {amount .. " vágás a " .. surfaceLocation[part], false, data})
                        else
                            local weapon = tonumber(typ)

                            if weapon >= 25 and weapon <= 27 then
                                table.insert(damages, {"Sörétek a " .. bulletLocation[part], data, false})
                            else
                                table.insert(damages, {amount .. " golyó a " .. bulletLocation[part], data, false})
                            end
                        end
                    end

                    if #damages == 0 then
                        damages[1] = {"Nem található sérülés."}
                    end

                    local onesize = respc(30)
				    renderDamageData.sizeY = respc(60) + onesize * #damages

                    dxDrawRectangle(damageX - renderDamageData.sizeX / 2, damageY - renderDamageData.sizeY / 2, renderDamageData.sizeX, renderDamageData.sizeY, tocolor(25, 25, 25, 250))

                    local panelPosX = damageX - renderDamageData.sizeX / 2
                    local panelPosY = damageY - renderDamageData.sizeY / 2
                   
                    local startY = panelPosY + respc(10)

                    for i = 1, #damages do
                        local dmg = damages[i]
                        local y = startY + onesize * (i - 1)

                        dxDrawText(dmg[1], panelPosX + respc(10), y, 0, y + onesize, tocolor(200, 200, 200), 0.9, Raleway, "left", "center")

                        if dmg[2] and canOperate then
                            outBulletColor = {60, 60, 60, 40}
                           
                            if activeButtonC == "getoutbullet:" .. dmg[2] then
                                outBulletColor = {	61, 122, 188}
                            end

                            drawButton("getoutbullet:"  .. dmg[2], "Kivétel", panelPosX + respc(300) - respc(110), y + onesize / 2 - respc(10), respc(100), respc(20), outBulletColor, false, Raleway, true, 0.75)
                        elseif dmg[3] and canStitch then
                            stitchColor = {60, 60, 60, 40}
                           
                            if activeButtonC == "stitch:" .. dmg[3] then
                                stitchColor = {	61, 122, 188}
                            end
                            drawButton("stitch:"  .. dmg[3], "Összevarrás", panelPosX + respc(300) - respc(100) - respc(10), y + onesize / 2 - respc(10), respc(100), respc(20), stitchColor, false, Raleway, true, 0.75)
                        end
                    end

                    startY = panelPosY + onesize * #damages + respc(20)

                    drawButton("exitPanel", "Kilépés", panelPosX + respc(10), startY, respc(280), onesize, {188, 64, 61}, false, Raleway, true)

                else
                    renderData.sizeY = enabledButtons * respc(40) + 4 + respc(30)

                    dxDrawRectangle(posX - renderData.sizeX / 2, posY - (renderData.sizeY)/ 2 - 4, renderData.sizeX, renderData.sizeY, tocolor(25, 25, 25, 250))

                    dxDrawRectangle(posX - renderData.sizeX / 2 + 4, posY - renderData.sizeY / 2, renderData.sizeX - 8, respc(30) - 4, tocolor(45, 45, 45, 180))
                    dxDrawText(renderData.visibleName, posX - renderData.sizeX / 2 + 4 + 5, posY - renderData.sizeY / 2 + respc(30) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center")

                    startY = (posY - renderData.sizeY / 2) + respc(30)
                    local spectateColor = {60, 60, 60, 40}

                    if activeButtonC == "spectatePlayer" then
                        spectateColor = {61, 188, 64, 140}
                    end

                    drawButton("spectatePlayer", "Vizsgálat", (posX - renderData.sizeX / 2) + 4, startY, renderData.sizeX - 8, respc(40) - 4, spectateColor, false, Raleway, true)
                    enabledButtons = 0

                    enabledButtons = enabledButtons + 1

                    if renderData.injureLeftFoot or renderData.injureRightFoot or renderData.injureLeftArm or renderData.injureRightArm or getElementHealth(renderData.sourceElement) <= 20 then
                        startY = (posY - renderData.sizeY / 2) + respc(30)

                        local healColor = {60, 60, 60, 40}

                        if activeButtonC == "growUpPlayer" then
                            healColor = {188, 61, 64, 140}
                        end

                        if getElementHealth(renderData.sourceElement) <= 20 then
                            startY = startY + respc(40)
                        
                            drawButton("growUpPlayer", "Felsegítés", (posX - renderData.sizeX / 2) + 4, startY, renderData.sizeX - 8, respc(40) - 4, healColor, false, Raleway, true)
                            enabledButtons = enabledButtons + 1
                        elseif renderData.injureLeftFoot or renderData.injureRightFoot or renderData.injureLeftArm or renderData.injureRightArm or getElementHealth(renderData.sourceElement) <= 20 then
                            startY = startY + respc(40)
                            drawButton("growUpPlayer", "Gyógyítás", (posX - renderData.sizeX / 2) + 4, startY, renderData.sizeX - 8, respc(40) - 4, healColor, false, Raleway, true)
                            enabledButtons = enabledButtons + 1
                        end
                    end

                    if exports.sm_groups:isPlayerHavePermission(localPlayer, "cuff") then
                        local cuffed = getElementData(renderData.sourceElement, "cuffed")

                        local buttonText = "Megbilincselés"

                        if cuffed then
                            buttonText = "Bilincs levétele"
                        end

                        local toggleColor = {60, 60, 60, 40}

                        if activeButtonC == "cuffPlayer" then
                            toggleColor = {61, 122, 188, 140}

                            if buttonText == "Bilincs levétele" then
                                toggleColor = {247, 148, 29, 140}
                            end
                        end

                        startY = startY + respc(40)
                        drawButton("cuffPlayer", buttonText, (posX - renderData.sizeX / 2) + 4, startY, renderData.sizeX - 8, respc(40) - 4, toggleColor, false, Raleway, true)
                        enabledButtons = enabledButtons + 1

                        if cuffed then
                            local buttonText = "Visz"

                            if getElementData(renderData.sourceElement, "visz") then
                                buttonText = "Elenged"
                            end

                            local toggleColor = {60, 60, 60, 40}

                            if activeButtonC == "takePlayer" then
                                toggleColor = {61, 122, 188, 140}

                                if buttonText == "Elenged" then
                                    toggleColor = {247, 148, 29, 140}
                                end
                            end

                            startY = startY + respc(40)
                            drawButton("takePlayer", buttonText, (posX - renderData.sizeX / 2) + 4, startY, renderData.sizeX - 8, respc(40) - 4, toggleColor, false, Raleway, true)
                            enabledButtons = enabledButtons + 1
                        end
                    end

                    
                    if animalElement then
                        local myAnimal = animalElement
                        if isElement(myAnimal) then
                            local attackColor = {60, 60, 60, 40}

                            if activeButtonC == "dogAttack" then
                                attackColor = {61, 188, 64, 140}
                            end

                            startY = startY + respc(40)
                            drawButton("dogAttack", "Kutya rá úszítása", (posX - renderData.sizeX / 2) + 4, startY, renderData.sizeX - 8, respc(40) - 4, attackColor, false, Raleway, true)
                            enabledButtons = enabledButtons + 1
                        end
                    end

                    startY = startY + respc(40)
                    local seeInvColor = {60, 60, 60, 40}

                    if activeButtonC == "seePlayerItems" then
                        seeInvColor = {61, 188, 64, 140}
                    end

                    drawButton("seePlayerItems", "Motozás", (posX - renderData.sizeX / 2) + 4, startY, renderData.sizeX - 8, respc(40) - 4, seeInvColor, false, Raleway, true)
                    enabledButtons = enabledButtons + 1

                    local closeColor = {60, 60, 60, 40}

                    if activeButtonC == "exitPanel" then
                        closeColor = {188, 64, 61, 140}
                    end

                    startY = startY + respc(40)
                    drawButton("exitPanel", "Bezárás", (posX - renderData.sizeX / 2) + 4, startY, renderData.sizeX - 8, respc(40) - 4, closeColor, false, Raleway, true)
                    enabledButtons = enabledButtons + 1

                end
            end
        end
    end

    local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

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
end

local lastTryToHelpUp = 0

function clickOnClickPanel(sourceKey, keyState)
    if sourceKey == "left" and keyState == "down" then
        if activeButtonC then
            if activeButtonC == "spectatePlayer" then
                spectatePlayerBody(renderData.sourceElement)

            elseif activeButtonC == "growUpPlayer" then
                helpUpPlayer(renderData.sourceElement)
                closeClickPanel()

            elseif activeButtonC == "cuffPlayer" then
                triggerServerEvent("cuffPlayer", localPlayer, renderData.sourceElement)
                closeClickPanel()

            elseif activeButtonC == "takePlayer" then
                triggerServerEvent("viszPlayer", localPlayer, renderData.sourceElement)
                closeClickPanel()

            elseif activeButtonC == "dogAttack" then
                local localX, localY, localZ = getElementPosition(localPlayer)
				local targetX, targetY, targetZ = getElementPosition(animalElement)

				if getDistanceBetweenPoints3D(localX, localY, localZ, targetX, targetY, targetZ) <= 15 then
                    setPedTask(animalElement, {"killPed", renderData.sourceElement, 5, 0})
                    triggerEvent("createDogPanelFont", localPlayer)
                    closeClickPanel()
                else
                    outputChatBox("#d75959[StrongMTA]: #ffffffA peted túl messze van tőled.", 255, 255, 255, true)
                end

            elseif activeButtonC == "seePlayerItems" then
                triggerServerEvent("searchPlayerItems", localPlayer, renderData.sourceElement)
                closeClickPanel()

            elseif activeButtonC == "exitPanel" then
                closeClickPanel()

            elseif string.find(activeButtonC, "getoutbullet") then
                if canOperate then
                    local selected = gettok(activeButtonC, 2, ":")
                    local dmgtype = tonumber(gettok(selected, 1, ";"))
                    local bodypart = tonumber(gettok(selected, 2, ";"))
                    local visibleName = getElementData(renderData.sourceElement, "visibleName"):gsub("_", " ")

                    triggerServerEvent("getOutBullet", renderData.sourceElement, selected)

                    if dmgtype >= 25 and dmgtype <= 27 then
                        exports.sm_chat:localActionC(localPlayer, "kiveszi a söréteket " .. visibleName .. " " .. bulletOperation[bodypart] .. ".")
                    else
                        exports.sm_chat:localActionC(localPlayer, "kivesz egy golyót " .. visibleName .. " " .. bulletOperation[bodypart] .. ".")
                    end

                    closeClickPanel()
                end

            elseif string.find(activeButtonC, "stitch") then
                if canStitch then
                    local selected = gettok(activeButtonC, 2, ":")
                    local bodypart = tonumber(gettok(selected, 2, ";"))
                    local visibleName = getElementData(renderData.sourceElement, "visibleName"):gsub("_", " ")

                    triggerServerEvent("stitchPlayerCut", renderData.sourceElement, selected)

                    exports.sm_chat:localActionC(localPlayer, "összevarr egy sebet " .. visibleName .. " " .. stitchOperation[bodypart] .. ".")

                    closeClickPanel()
                end
            end
            playSound(":sm_radio/files/hifibuttons.mp3", false)
            activeButtonC = false
        end
    end
end



function examineMyself()
    if not renderData then
        openClickPanel(localPlayer)

        spectatePlayerBody(localPlayer)
    end
end
addCommandHandler("examinemyself", examineMyself)
addCommandHandler("sérüléseim", examineMyself)
addCommandHandler("seruleseim", examineMyself)

function openClickPanel(targetPlayer)
    animalElement = getElementByID("animal_" .. getElementData(localPlayer, "char.ID"))

    renderData = {
        sourceElement = targetPlayer,
        visibleName = utf8.gsub(getElementData(targetPlayer, "visibleName"), "_", " "),
        sizeX = respc(200),
        sizeY = respc(240),
        injureLeftFoot = getElementData(targetPlayer, "char.injureLeftFoot"),
        injureRightFoot = getElementData(targetPlayer, "char.injureRightFoot"),
        injureLeftArm = getElementData(targetPlayer, "char.injureLeftArm"),
        injureRightArm = getElementData(targetPlayer, "char.injureRightArm"),
    }

    playSound(":sm_radio/files/hifiopen.mp3", false)

    createFonts()

    addEventHandler("onClientClick", getRootElement(), clickOnClickPanel)
    addEventHandler("onClientRender", getRootElement(), renderClickPanel)
end

function closeClickPanel()
    removeEventHandler("onClientClick", getRootElement(), clickOnClickPanel)
    removeEventHandler("onClientRender", getRootElement(), renderClickPanel)

    playSound(":sm_radio/files/hificlose.mp3", false)

    bulletDamages = false

    renderData = nil 
    destroyFonts()
end

addEventHandler("onClientClick", getRootElement(), 
    function(sourceKey, keyState, relX, relY, worldX, worldY, worldZ, clickedElement)
        if sourceKey  == "right" and keyState == "down" then
            if clickedElement then
                if getElementType(clickedElement) == "player" then
                    --if sourceElement ~= localPlayer then
                        if not renderData then
                            openClickPanel(clickedElement)
                        end
                   -- end
                end
            end
        end
    end
)

function setPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		clearPedTasks(pedElement)
		setElementData(pedElement, "ped.task.1", selectedTask)
		setElementData(pedElement, "ped.thisTask", 1)
		setElementData(pedElement, "ped.lastTask", 1)
		return true
	else
		return false
	end
end

function clearPedTasks(pedElement)
	if isElement(pedElement) then
		local thisTask = getElementData(pedElement, "ped.thisTask")

		if thisTask then
			local lastTask = getElementData(pedElement, "ped.lastTask")

			for currentTask = thisTask, lastTask do
				setElementData(pedElement, "ped.task." .. currentTask, nil)
			end

			setElementData(pedElement, "ped.thisTask", nil)
			setElementData(pedElement, "ped.lastTask", nil)
			return true
		end
	else
		return false
	end
end

function spectatePlayerBody(targetPlayer)
    if getElementType(targetPlayer) == "player" then
        bulletDamages = getElementData(targetPlayer, "bulletDamages") or {}
    else
        bulletDamages = getElementData(targetPlayer, "deathPed") or {}

        if bulletDamages then
            bulletDamages = bulletDamages[5] or {}
        end
    end

    canOperate = exports.sm_items:playerHasItem(125)
    canStitch = exports.sm_items:playerHasItem(124)

    if not exports.sm_groups:isPlayerInGroup(localPlayer, 2) then
        canOperate = false
        canStitch = false
    end
end

function helpUpPlayer(targetPlayer)
    if getTickCount() - lastTryToHelpUp >= 1000 then
        lastTryToHelpUp = getTickCount()

        local injureLeftFoot = getElementData(targetPlayer, "char.injureLeftFoot")
        local injureRightFoot = getElementData(targetPlayer, "char.injureRightFoot")
        local injureLeftArm = getElementData(targetPlayer, "char.injureLeftArm")
        local injureRightArm = getElementData(targetPlayer, "char.injureRightArm")
        local damages = {}
        local damageCount = 0

        if getElementType(targetPlayer) == "player" then
            damages = getElementData(targetPlayer, "bulletDamages") or {}
        else
            damages = getElementData(targetPlayer, "deathPed") or {}

            if damages then
                damages = damages[5] or {}
            end
        end

        for k, v in pairs(damages) do
            damageCount = damageCount + 1
        end

        if injureLeftFoot or injureRightFoot or injureLeftArm or injureRightArm or damageCount > 0 or getElementHealth(targetPlayer) <= 20 then
            for data, amount in pairs(damages) do
                local typ = gettok(data, 1, ";")

                if typ == "stitch-cut" then
                elseif typ == "stitch-hole" then
                elseif typ == "punch" then
                elseif typ == "hole" then
                    outputChatBox("#d75959[StrongMTA]: #ffffffAddig nem gyógyíthatod meg, amíg vágás van a testén!", 255, 255, 255, true)
                    exports.sm_hud:showInfobox("e", "Addig nem gyógyíthatod meg, amíg vágás van a testén!")
                    return
                elseif typ == "cut" then
                    outputChatBox("#d75959[StrongMTA]: #ffffffAddig nem gyógyíthatod meg, amíg vágás van a testén!", 255, 255, 255, true)
                    exports.sm_hud:showInfobox("e", "Addig nem gyógyíthatod meg, amíg vágás van a testén!")
                    return
                else
                    local weapon = tonumber(typ)

                    if weapon >= 25 and weapon <= 27 then
                        outputChatBox("#d75959[StrongMTA]: #ffffffAddig nem gyógyíthatod meg, amíg sörétek vannak a testében!", 255, 255, 255, true)
                        exports.sm_hud:showInfobox("e", "Addig nem gyógyíthatod meg, amíg sörétek vannak a testében!")
                        return
                    else
                        outputChatBox("#d75959[StrongMTA]: #ffffffAddig nem gyógyíthatod meg, amíg golyó van a testében!", 255, 255, 255, true)
                        exports.sm_hud:showInfobox("e", "Addig nem gyógyíthatod meg, amíg golyó van a testében!")
                        return
                    end
                end
            end

            triggerServerEvent("takeMedicBag", localPlayer, targetPlayer)
            closeClickPanel()
        else
            outputChatBox("#d75959[StrongMTA]: #ffffffA kiválasztott játékos nincs megsérülve!", 255, 255, 255, true)
            exports.sm_hud:showInfobox("e", "A kiválasztott játékos nincs megsérülve!")
        end
    end
end

function getPositionFromElementOffset(element, x, y, z)
    if element then
        m = getElementMatrix(element)
        return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1], x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2], x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
    end
end
