local screenX, screenY = guiGetScreenSize()

local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

function loadFonts()
	Roboto = exports.sm_core:loadFont("Raleway.ttf", respc(20), false, "antialiased")
	RobotoL = exports.sm_core:loadFont("Raleway.ttf", respc(15), false, "antialiased")
end

loadFonts()

addEventHandler("onAssetsLoaded", getRootElement(),
	function ()
		loadFonts()
	end
)

local scaleMultiplier = (screenX + 1920) / (1920 * 2)

local nameVisibleDistance = 35
local imageVisibleDistance = 28

local showMyName = false
local namesVisible = true
local adminNames = false

local streamedPlayers = {}
local streamedPeds = {}
local playerMessages = {}

local bloodProgressColor = {255, 255, 255}

local chatboxState = false
local consoleState = false

local lastAfkReset = 0
local deltaTimestamp = 0

local currentTickCount = 0
local currentTimestamp = 0

local placedDoLabels = {}

local placeDoColSize = 35
local placeDoColShapes = {}

local nearbyPlaceDos = {}
local hoverPlaceDo = false

local myCharacterId = 0
local myAdminLevel = 0

local devDutyImage = dxCreateTexture("files/images/devduty.png")
local mainDutyImage = dxCreateTexture("files/images/mainadmin.png")
local superDutyImage = dxCreateTexture("files/images/superadmin.png")
local adminDutyImage = dxCreateTexture("files/images/adminduty.png")
local ownerDutyImage = dxCreateTexture("files/images/owner.png")
local respawnImage = dxCreateTexture("files/images/respawn.png")
local cuffImage = dxCreateTexture("files/images/cuff.png")
local tazerImage = dxCreateTexture("files/images/taz.png")

addEvent("receiveNametagsTiming", true)
addEventHandler("receiveNametagsTiming", localPlayer,
	function (serverTimestamp)
		deltaTimestamp = serverTimestamp - getRealTime().timestamp
	end
)

local function requestPlayerInfos(player, dataName)
	if not isElement(player) then
		return
	end

	setPlayerNametagShowing(player, false)

	if player == localPlayer and not showMyName then
		return
	end

	if not dataName then
		if not streamedPlayers[player] then
			if getElementData(player, "loggedIn") then
				streamedPlayers[player] = {
					playerId = getElementData(player, "playerID") or "n/A",
					playerName = utf8.gsub(getElementData(player, "visibleName") or "", "_", " "),

					adminLevel = getElementData(player, "acc.adminLevel") or 0,
					adminNick = getElementData(player, "acc.adminNick"),
					adminDuty = getElementData(player, "adminDuty") or 0,
					helperLevel = getElementData(player, "acc.helperLevel") or 0,

					isAfk = getElementData(player, "afk"),
					startAfk = getElementData(player, "startAfk"),

					isTyping = getElementData(player, "typing"),
					isConsoling = getElementData(player, "consoling"),

					cuffed = getElementData(player, "cuffed"),
					tazed = getElementData(player, "tazed"),

					badgeData = getElementData(player, "badgeName"),
					paintVisibleOnPlayer = getElementData(player, "paintVisibleOnPlayer"),
					playerGlueState = getElementData(player, "playerGlueState"),

					bloodLevel = getElementData(player, "bloodLevel") or 100,
					inAnimTime = getElementData(player, "inAnimTime") or 0,
					startAnim = getElementData(player, "startAnim"),
					lastRespawn = getElementData(player, "lastRespawn") or 0
				}
			end
		end
	else
		if not streamedPlayers[player] then
			requestPlayerInfos(player)
			return
		end

		if dataName == "playerID" then
			streamedPlayers[player].playerId = getElementData(player, dataName) or "n/A"
		elseif dataName == "visibleName" then
			streamedPlayers[player].playerName = utf8.gsub(getElementData(player, dataName) or "", "_", " ")
		elseif dataName == "acc.adminLevel" then
			streamedPlayers[player].adminLevel = getElementData(player, dataName) or 0
		elseif dataName == "acc.adminNick" then
			streamedPlayers[player].adminNick = getElementData(player, dataName) or "Admin"
		elseif dataName == "adminDuty" then
			streamedPlayers[player].adminDuty = getElementData(player, dataName) or 0
		elseif dataName == "acc.helperLevel" then
			streamedPlayers[player].helperLevel = getElementData(player, dataName) or 0
		elseif dataName == "afk" then
			streamedPlayers[player].isAfk = getElementData(player, dataName)
		elseif dataName == "startAfk" then
			streamedPlayers[player].startAfk = getElementData(player, dataName)
		elseif dataName == "typing" then
			streamedPlayers[player].isTyping = getElementData(player, dataName)
		elseif dataName == "consoling" then
			streamedPlayers[player].isConsoling = getElementData(player, dataName)
		elseif dataName == "cuffed" then
			streamedPlayers[player].cuffed = getElementData(player, dataName)
		elseif dataName == "tazed" then
			streamedPlayers[player].tazed = getElementData(player, dataName)
		elseif dataName == "badgeName" then
			streamedPlayers[player].badgeData = getElementData(player, dataName)
		elseif dataName == "paintVisibleOnPlayer" then
			streamedPlayers[player].paintVisibleOnPlayer = getElementData(player, dataName)
		elseif dataName == "playerGlueState" then
			streamedPlayers[player].playerGlueState = getElementData(player, dataName)
		elseif dataName == "bloodLevel" then
			streamedPlayers[player].bloodLevel = getElementData(player, dataName) or 100
		elseif dataName == "inAnimTime" then
			streamedPlayers[player].inAnimTime = getElementData(player, dataName) or 0
		elseif dataName == "startAnim" then
			streamedPlayers[player].startAnim = getElementData(player, dataName)
		elseif dataName == "lastRespawn" then
			streamedPlayers[player].lastRespawn = getElementData(player, dataName) or 0
		end
	end
end

local function requestPedInfos(ped, dataName)
	if not isElement(ped) then
		return
	end

	if not dataName then
		if not streamedPeds[ped] then
			local visibleName = getElementData(ped, "visibleName")

			if visibleName then
				streamedPeds[ped] = {
					visibleName = utf8.gsub(visibleName, "_", " "),
					pedNameType = getElementData(ped, "pedNameType"),
					deathPed = getElementData(ped, "deathPed"),
					animalId = getElementData(ped, "animal.animalId")
				}
			end
		end
	else
		if not streamedPeds[ped] then
			requestPedInfos(ped)
			return
		end

		if dataName == "visibleName" then
			streamedPeds[ped].visibleName = utf8.gsub(getElementData(ped, dataName) or "", "_", " ")
		elseif dataName == "pedNameType" then
			streamedPeds[ped].pedNameType = getElementData(ped, dataName)
		elseif dataName == "deathPed" then
			streamedPeds[ped].deathPed = getElementData(ped, dataName)
		elseif dataName == "animal.animalId" then
			streamedPeds[ped].animalId = getElementData(ped, dataName)
		end
	end
end

addEventHandler("onClientPlayerQuit", getRootElement(),
	function ()
		if streamedPlayers[source] then
			streamedPlayers[source] = nil
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		local elementType = getElementType(source)

		if elementType == "player" then
			requestPlayerInfos(source)
		elseif elementType == "ped" then
			requestPedInfos(source)
		end
	end
)

addEventHandler("onClientElementStreamOut", getRootElement(),
	function ()
		if streamedPlayers[source] then
			streamedPlayers[source] = nil
		end

		if streamedPeds[source] then
			streamedPeds[source] = nil
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if streamedPlayers[source] then
			streamedPlayers[source] = nil
		end

		if streamedPeds[source] then
			streamedPeds[source] = nil
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		local elementType = getElementType(source)

		if elementType == "player" then
			if isElementStreamedIn(source) then
				requestPlayerInfos(source, dataName)
			end

			if source == localPlayer then
				if dataName == "char.ID" then
					myCharacterId = getElementData(localPlayer, "char.ID")
				elseif dataName == "acc.adminLevel" then
					myAdminLevel = getElementData(localPlayer, "acc.adminLevel")
				elseif dataName == "loggedIn" then
					triggerServerEvent("requestPlaceDos", resourceRoot)
				end
			end
		elseif elementType == "ped" then
			if isElementStreamedIn(source) then
				requestPedInfos(source, dataName)
			end
		end
	end
)

addEventHandler("onClientPlayerDamage", getRootElement(),
	function ()
		if streamedPlayers[source] then
			streamedPlayers[source].damageStart = getTickCount() + 3000
		end
	end
)

addEventHandler("onClientRestore", getRootElement(),
	function ()
		if getElementData(localPlayer, "afk") then
			lastAfkReset = getTickCount()
			setElementData(localPlayer, "afk", false)
		end
	end
)

addEventHandler("onClientMinimize", getRootElement(),
	function ()
		if not getElementData(localPlayer, "afk") then
			setElementData(localPlayer, "afk", true)
		end
	end
)

addEventHandler("onClientCursorMove", getRootElement(),
	function ()
		if getElementData(localPlayer, "afk") then
			lastAfkReset = getTickCount()
			setElementData(localPlayer, "afk", false)
		end
	end
)

addEventHandler("onClientKey", getRootElement(),
	function ()
		if getElementData(localPlayer, "afk") then
			lastAfkReset = getTickCount()
			setElementData(localPlayer, "afk", false)
		end
	end
)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		setTimer(triggerServerEvent, 2000, 1, "requestNametagsTiming", resourceRoot)

		if getElementData(localPlayer, "loggedIn") then
			for k, v in pairs(getElementsByType("player", getRootElement(), true)) do
				requestPlayerInfos(v)
			end

			for k, v in pairs(getElementsByType("ped", getRootElement(), true)) do
				requestPedInfos(v)
			end

			if isChatBoxInputActive() then
				setElementData(localPlayer, "typing", true)
				chatboxState = true
			else
				setElementData(localPlayer, "typing", false)
				chatboxState = false
			end

			if isConsoleActive() then
				setElementData(localPlayer, "consoling", true)
				consoleState = true
			else
				setElementData(localPlayer, "consoling", false)
				consoleState = false
			end

			myCharacterId = getElementData(localPlayer, "char.ID")
			myAdminLevel = getElementData(localPlayer, "acc.adminLevel")
		end
	end
)

addCommandHandler("tognames",
	function ()
		namesVisible = not namesVisible
	end
)

addCommandHandler("togmyname",
	function ()
		showMyName = not showMyName

		if streamedPlayers[localPlayer] then
			streamedPlayers[localPlayer] = nil
		else
			requestPlayerInfos(localPlayer)
		end
	end
)

addCommandHandler("anames",
	function ()
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			if not adminNames then
				adminNames = "normal"

				if getElementData(localPlayer, "acc.adminLevel") >= 7 then
					adminNames = "super"
				end

				outputChatBox("#3d7abc[StrongMTA]: #ffffffSikeresen #3d7abcbekapcsoltad #ffffffaz adminisztrátori neveket.", 255, 255, 255, true)
			else
				adminNames = false
				outputChatBox("#3d7abc[StrongMTA]: #ffffffSikeresen #d75959kikapcsoltad #ffffffaz adminisztrátori neveket.", 255, 255, 255, true)
			end
		end
	end
)

local function renderPlayerName(element, distanceProgress, boneX, boneY, boneZ)
	local v = streamedPlayers[element]
	if not v then
		return
	end

	local nametagX, nametagY = getScreenFromWorldPosition(boneX, boneY, boneZ + 0.38, 0, false)
	if not nametagX or not nametagY then
		return
	end

	local scaleProgress = interpolateBetween(1, 0, 0, 0.17, 0, 0, distanceProgress, "OutQuad") * scaleMultiplier
	local alphaProgress = interpolateBetween(1, 0, 0, 0, 0, 0, distanceProgress, "Linear")

	if adminNames then
		alphaProgress = 1

		if scaleProgress < 0.4 then
			scaleProgress = 0.4
		end
	end

	local pedX, pedY, pedZ = getElementPosition(element)
	local pedHealth = getElementHealth(element)
	local pedArmor = getPedArmor(element)

	local nameColor = "#FFFFFF"
	local indexColor = "#FFFFFF"

	if adminNames then
		nameColor = "#7cc576"
		indexColor = "#d75959"
	end

	if v.hitTick then
		if v.hitTick > 0 and currentTickCount <= v.hitTick then
			nameColor = "#d75959"
		else
			v.hitTick = false
		end
	elseif pedHealth <= 0 then
		nameColor = "#141414"
	end

	if v.bloodLevel < 100 then
		nameColor = string.format("#%.2X%.2X%.2X", bloodProgressColor[1], bloodProgressColor[2], bloodProgressColor[3])

		if not isPedInVehicle(element) then
			if math.random(100) <= 10 then
				fxAddBlood(pedX, pedY, pedZ - 2, 0, 0, 3, math.random(5))
			end
		end
	end

	local visibleText = nameColor .. v.playerName
	local dutyText = ""

	if v.adminDuty == 1 then
		if v.adminLevel == 11 then
			dutyText = "#bced4a<Main Developer/> "
		elseif v.adminLevel == 8 then
			dutyText = "#406ca2<Developer/> "
		elseif v.adminLevel == 9 then
			dutyText = "#d23131(Project Owner) "
		elseif v.adminLevel == 10 then
			dutyText = "#7cc576(NULL) "
		elseif v.adminLevel == 7 then
			dutyText = "#a24040(SuperAdmin) "
		elseif v.adminLevel == 6 then
			dutyText = "#a28340(Main Admin) "
		else
			dutyText = "#acd373(Game Admin [" .. v.adminLevel .. "]) "
		end
	elseif v.helperLevel > 0 then
		if v.helperLevel == 1 then
			dutyText = "#f49ac1(IDG Game Helper)"
		elseif v.helperLevel >= 2 then
			dutyText = "#f49ac1(Game Helper)"
		end
	end

	visibleText = visibleText .. " " .. dutyText
	visibleText = visibleText .. indexColor .. "#3d7abc(" .. v.playerId .. ")"

	if v.playerGlueState then
		visibleText = visibleText .. " #5b5b5b[G]"
	end

	local fontScale = scaleProgress * scaleMultiplier
	local textWidth = dxGetTextWidth(visibleText, fontScale, Roboto, true)
	local fontHeight = dxGetFontHeight(fontScale, Roboto)
	local textPosX = nametagX - textWidth / 2

	if v.badgeData then
		visibleText = visibleText .. "\n#3d7abc" .. v.badgeData
	end

	if v.paintVisibleOnPlayer then
		visibleText = visibleText .. "\n#BFFF00*festékes az arca*"
	end

	if v.badgeData then
		dxDrawText(utf8.gsub(visibleText, "#%x%x%x%x%x%x", ""), textPosX + 1, nametagY - 30, 100, 100, tocolor(0, 0, 0), fontScale, Roboto, "left", "top", false, false, false, false, true)
		dxDrawText(visibleText, textPosX, nametagY - 31, textPosX + textWidth, 100, tocolor(255, 255, 255), fontScale, Roboto, "left", "top", false, false, false, true, true)
	else
		dxDrawText(utf8.gsub(visibleText, "#%x%x%x%x%x%x", ""), textPosX + 1, nametagY + 1, 100, 100, tocolor(0, 0, 0), fontScale, Roboto, "left", "top", false, false, false, false, true)
		dxDrawText(visibleText, textPosX, nametagY, textPosX + textWidth, 100, tocolor(255, 255, 255), fontScale, Roboto, "left", "top", false, false, false, true, true)
	end

	if adminNames then
		local barWidth = 200 * scaleProgress
		local barHeight = 8 * scaleProgress

		local barPosX = nametagX - barWidth / 2
		local barPosY = nametagY + fontHeight * 1.25

		dxDrawRectangle(barPosX - 2, barPosY - 2, barWidth + 4, barHeight + 4, tocolor(0, 0, 0, 150), false, true)
		if pedHealth > 0 then
			dxDrawRectangle(barPosX, barPosY, barWidth * (pedHealth / 100), barHeight, tocolor(124, 197, 118, 150), false, true)
		end

		barPosY = barPosY + barHeight * 2

		dxDrawRectangle(barPosX - 2, barPosY - 2, barWidth + 4, barHeight + 4, tocolor(0, 0, 0, 150), false, true)
		if pedArmor > 0 then
			dxDrawRectangle(barPosX, barPosY, barWidth * (pedArmor / 100), barHeight, tocolor(50, 179, 239, 150), false, true)
		end
	end

	if distanceProgress * nameVisibleDistance < imageVisibleDistance then
		if scaleProgress < 1 then
			local scaleFactor = interpolateBetween(0.85, 0, 0, 0.15, 0, 0, distanceProgress, "OutQuad") * scaleMultiplier
			local imageSize = respc(256) * scaleFactor
			local imageX = nametagX - imageSize / 2
			local imageY = nametagY - fontHeight - imageSize * 0.7 + 5

			if v.isAfk then
				dxDrawImage(imageX, imageY, imageSize, imageSize, "files/images/afk.png", 0, 0, 0, tocolor(0, 0, 0, 255 * alphaProgress))

				if v.startAfk then
					local afkTime = currentTimestamp - v.startAfk

					if afkTime < 0 then
						afkTime = 0
					end

					afkTime = string.format("%.2d:%.2d:%.2d", afkTime / 3600, afkTime / 60 % 60, afkTime % 60)
					dxDrawText(afkTime, imageX, imageY, imageX + imageSize, imageY + 75 * scaleFactor, tocolor(0, 0, 0, 255 * alphaProgress), scaleFactor + 0.1, Roboto, "center", "center", false, false, false, false, true)
				end
			elseif v.isTyping then
				dxDrawImage(imageX, imageY, imageSize, imageSize, "files/images/typing.png", 0, 0, 0, tocolor(0, 0, 0, 255 * alphaProgress))
			elseif v.isConsoling then
				dxDrawImage(imageX, imageY, imageSize, imageSize, "files/images/console.png", 0, 0, 0, tocolor(0, 0, 0, 255 * alphaProgress))
			elseif pedHealth <= 0 then
				dxDrawImage(imageX, imageY, imageSize, imageSize, "files/images/death.png", 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
			elseif pedHealth <= 20 then
				if v.startAnim then
					local animProgress = 1 - (currentTimestamp - v.startAnim) / 600

					if animProgress < 0 then
						animProgress = 0
					elseif animProgress > 1 then
						animProgress = 1
					end

					imageSize = imageSize * 0.5

					dxDrawImage(imageX + imageSize - imageSize * 0.5, imageY + imageSize - imageSize * 0.5, imageSize, imageSize, "files/images/anim.png", 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))

					local barWidth = 128 * scaleFactor
					local barHeight = 14 * scaleFactor
					local iconSize = 18 * scaleFactor

					local barPosX = nametagX - barWidth / 2
					local barPosY = nametagY - fontHeight / 2 - barHeight / 2

					dxDrawRectangle(barPosX - 2, barPosY - 2, barWidth + 4, barHeight + 4, tocolor(0, 0, 0, 100), false, true)
					dxDrawRectangle(barPosX, barPosY, barWidth, barHeight, tocolor(0, 0, 0, 150), false, true)

					dxDrawImage(barPosX - iconSize - 6 * scaleFactor, barPosY + barHeight / 2 - iconSize / 2, iconSize, iconSize, "files/images/1.png")
					dxDrawImage(barPosX + barWidth + 6 * scaleFactor, barPosY + barHeight / 2 - iconSize / 2, iconSize, iconSize, "files/images/2.png")

					local colorR, colorG, colorB = interpolateBetween(215, 89, 89, 124, 197, 118, animProgress, "Linear")

					dxDrawRectangle(barPosX, barPosY, barWidth * animProgress, barHeight, tocolor(colorR, colorG, colorB), false, true)
				end
			elseif v.lastRespawn > 0 then
				local visibleText = (20 - v.lastRespawn) .. " perce éledt újra"

				imageSize = imageSize * 0.5
				imageX = imageX + imageSize - imageSize * 0.5
				imageY = imageY + imageSize - imageSize * 0.5
				dxDrawImage(imageX, imageY, imageSize, imageSize, respawnImage, 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
				dxDrawText(visibleText, imageX + 1, imageY + imageSize * 0.9 + 1, imageX + imageSize + 1, 101, tocolor(0, 0, 0, 255 * alphaProgress), fontScale * 0.85, Roboto, "center", "top", false, false, false, false, false)
				dxDrawText(visibleText, imageX, imageY + imageSize * 0.9, imageX + imageSize, 100, tocolor(215, 89, 89, 255 * alphaProgress), fontScale * 0.85, Roboto, "center", "top", false, false, false, false, false)
			elseif v.cuffed then
				dxDrawImage(imageX, imageY, imageSize, imageSize, cuffImage, 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
			elseif v.tazed then
				dxDrawImage(imageX, imageY, imageSize, imageSize,tazerImage, 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
			elseif v.adminDuty == 1 then
				if v.adminLevel == 8 or v.adminLevel >= 11 then
					dxDrawImage(imageX, imageY, imageSize, imageSize, devDutyImage, 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
				elseif v.adminLevel == 6 then
					dxDrawImage(imageX, imageY, imageSize, imageSize, mainDutyImage, 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
				elseif v.adminLevel == 7 then
					dxDrawImage(imageX, imageY, imageSize, imageSize, superDutyImage, 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
				elseif v.adminLevel == 9 then
					dxDrawImage(imageX, imageY, imageSize, imageSize, ownerDutyImage, 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
				else
					dxDrawImage(imageX, imageY, imageSize, imageSize, adminDutyImage, 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
				end
			elseif v.helperLevel > 0 then
				dxDrawImage(imageX, imageY, imageSize, imageSize, "files/images/helperduty.png", 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
			end
		end

		if playerMessages[element] then
			local messageCount = 0
			local messageHeight = dxGetFontHeight(scaleProgress, RobotoL)

			for i = #playerMessages[element], 1, -1 do
				local messageDetails = playerMessages[element][i]
				local messagePrefix = ""
				local messageColor = tocolor(255, 255, 255)

				if messageDetails.msgType == "me" then
					messagePrefix = "* "
					messageColor = tocolor(194, 162, 218)
				elseif messageDetails.msgType == "melow" then
					messagePrefix = "[LOW] * "
					messageColor = tocolor(219, 197, 235)
				elseif messageDetails.msgType == "ame" then
					messagePrefix = "> "
					messageColor = tocolor(149, 108, 180)
				elseif messageDetails.msgType == "do" then
					messagePrefix = "* "
					messageColor = tocolor(255, 40, 40)
				elseif messageDetails.msgType == "dolow" then
					messagePrefix = "[LOW] * "
					messageColor = tocolor(255, 102, 130)
				end

				local messageWidth = dxGetTextWidth(messagePrefix .. messageDetails.msgText, scaleProgress, RobotoL, true)
				local messagePosX = nametagX - messageWidth / 2
				local messagePosY = nametagY - fontHeight - messageCount * messageHeight * 1.5

				dxDrawRectangle(messagePosX - 6, messagePosY - 3, messageWidth + 12, messageHeight + 6, tocolor(0, 0, 0, 150), false, true)
				dxDrawText(messagePrefix .. messageDetails.msgText, messagePosX, messagePosY, 100, 100, messageColor, scaleProgress, RobotoL, "left", "top", false, false, false, true, true)

				if currentTickCount >= messageDetails.currentTime + messageDetails.visibleTime then
					table.remove(playerMessages[element], i)
				end

				messageCount = messageCount + 1
			end
		end
	end
end

local function renderPedName(element, distanceProgress, boneX, boneY, boneZ)
	local v = streamedPeds[element]
	if not v then
		return
	end

	if v.animalId then
		boneZ = boneZ + 0.25
	else
		boneZ = boneZ + 0.38
	end

	local nametagX, nametagY = getScreenFromWorldPosition(boneX, boneY, boneZ, 0, false)
	if not nametagX or not nametagY then
		return
	end

	local visibleText = v.visibleName

	if v.deathPed then
		visibleText = "#141414" .. visibleText .. " #ffffff(" .. v.deathPed[3] .. ")"
	else
		visibleText = visibleText .. " #3d7abc["

		if v.animalId then
			visibleText = visibleText .. "PET"
		else
			visibleText = visibleText .. "NPC"
		end

		if v.pedNameType then
			visibleText = visibleText .. " (" .. v.pedNameType .. ")"
		end

		visibleText = visibleText .. "]"
	end

	local scaleProgress = interpolateBetween(1, 0, 0, 0.17, 0, 0, distanceProgress, "OutQuad") * scaleMultiplier
	local alphaProgress = interpolateBetween(1, 0, 0, 0, 0, 0, distanceProgress, "Linear")
	local fontScale = scaleProgress * scaleMultiplier

	local textWidth = dxGetTextWidth(visibleText, fontScale, Roboto, true)
	local fontHeight = dxGetFontHeight(fontScale, Roboto)

	local textPosX = nametagX - textWidth / 2

	dxDrawText(utf8.gsub(visibleText, "#%x%x%x%x%x%x", ""), textPosX + 1, nametagY + 1, 100, 100, tocolor(0, 0, 0), fontScale, Roboto, "left", "top", false, false, false, false, true)
	dxDrawText(visibleText, textPosX, nametagY, textPosX + textWidth, 100, tocolor(255, 255, 255), fontScale, Roboto, "left", "top", false, false, false, true, true)

	if v.deathPed then
		textWidth = dxGetTextWidth("Halál oka: " .. v.deathPed[4], fontScale, Roboto)
		textPosX = nametagX - textWidth / 2

		dxDrawText("Halál oka: " .. v.deathPed[4], textPosX + 1, nametagY + fontHeight + 1, 100, 100, tocolor(0, 0, 0, 255 * alphaProgress), fontScale, Roboto, "left", "top", false, false, false, true, true)
		dxDrawText("Halál oka: " .. v.deathPed[4], textPosX, nametagY + fontHeight, 100, 100, tocolor(215, 89, 89, 255 * alphaProgress), fontScale, Roboto, "left", "top", false, false, false, true, true)

		if distanceProgress < 1 then
			local scaleFactor = interpolateBetween(0.85, 0, 0, 0.15, 0, 0, distanceProgress, "OutQuad") * scaleMultiplier
			local imageSize = 256 * scaleFactor

			local imageX = nametagX - imageSize / 2
			local imageY = nametagY - fontHeight - imageSize * 0.7 + 5

			dxDrawImage(imageX, imageY, imageSize, imageSize, "files/images/death.png", 0, 0, 0, tocolor(255, 255, 255, 255 * alphaProgress))
		end
	end
end

addEventHandler("onClientRender", getRootElement(),
	function ()
		currentTickCount = getTickCount()
		currentTimestamp = getRealTime().timestamp + deltaTimestamp

		if currentTickCount - lastAfkReset >= 25000 then
			if getElementHealth(localPlayer) > 1 then
				if not getElementData(localPlayer, "afk") then
					setElementData(localPlayer, "afk", true)
				end
			end
		end

		if not chatboxState then
			if isChatBoxInputActive() then
				setElementData(localPlayer, "typing", true)
				chatboxState = true
			end
		elseif chatboxState then
			if not isChatBoxInputActive() then
				setElementData(localPlayer, "typing", false)
				chatboxState = false
			end
		end

		if not consoleState then
			if isConsoleActive() then
				setElementData(localPlayer, "consoling", true)
				consoleState = true
			end
		elseif consoleState then
			if not isConsoleActive() then
				setElementData(localPlayer, "consoling", false)
				consoleState = false
			end
		end

		local cameraX, cameraY, cameraZ = getCameraMatrix()
		local cursorX, cursorY = getCursorPosition()

		if cursorX then
			cursorX = cursorX * screenX
			cursorY = cursorY * screenY
		else
			cursorX = -1
			cursorY = -1
		end

		if namesVisible then
			local bloodProgress = getTickCount() % 1000

			bloodProgressColor[1], bloodProgressColor[2], bloodProgressColor[3] = interpolateBetween(255, 255, 255, 215, 89, 89, bloodProgress / 500, "Linear")

			if bloodProgress > 500 then
				bloodProgressColor[1], bloodProgressColor[2], bloodProgressColor[3] = interpolateBetween(215, 89, 89, 255, 255, 255, (bloodProgress - 500) / 500, "Linear")
			end

			for player in pairs(streamedPlayers) do
				if isElement(player) then
					if getElementAlpha(player) > 0 or adminNames == "super" then
						if isElementOnScreen(player) then
							local targetX, targetY, targetZ = getElementPosition(player)
							local distanceBetween = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, targetX, targetY, targetZ)
							local visibleDistance = not adminNames and nameVisibleDistance or 150

							if distanceBetween < visibleDistance then
								local boneX, boneY, boneZ = getPedBonePosition(player, 5)

								if isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, true, false) or adminNames == "super" then
									renderPlayerName(player, distanceBetween / visibleDistance, boneX, boneY, boneZ)
								end
							end
						end
					end
				else
					streamedPlayers[player] = nil
				end
			end

			for ped in pairs(streamedPeds) do
				if isElement(ped) then
					if isElementOnScreen(ped) then
						local targetX, targetY, targetZ = getElementPosition(ped)
						local distanceBetween = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, targetX, targetY, targetZ)
						local visibleDistance = nameVisibleDistance

						if distanceBetween < visibleDistance then
							local boneX, boneY, boneZ = getPedBonePosition(ped, 5)

							if isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, true, false) then
								renderPedName(ped, distanceBetween / visibleDistance, boneX, boneY, boneZ)
							end
						end
					end
				else
					streamedPeds[ped] = nil
				end
			end
		end

		local currentDimension = getElementDimension(localPlayer)

		hoverPlaceDo = false

		for k in pairs(nearbyPlaceDos) do
			local v = placedDoLabels[k]

			if v then
				if v.dimension == currentDimension then
					if isLineOfSightClear(cameraX, cameraY, cameraZ, v.position[1], v.position[2], v.position[3] - 0.5, true, false, false, true, false, true, false) then
						local guiX, guiY = getScreenFromWorldPosition(v.position[1], v.position[2], v.position[3] - 0.5, 0, false)

						if guiX and guiY then
							local distanceBetween = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, v.position[1], v.position[2], v.position[3] - 0.5)
							local scaleProgress = interpolateBetween(1, 0, 0, 0.45, 0, 0, distanceBetween / 10, "OutQuad") * scaleMultiplier

							for x = -1, 1, 2 do
								for y = -1, 1, 2 do
									dxDrawText(v.messageText, guiX - 10 + x, guiY - 10 + y, guiX + 10 + x, guiY + 10 + y, tocolor(0, 0, 0, 170), scaleProgress, Roboto, "center", "center")
								end
							end

							dxDrawText(v.messageText, guiX - 10, guiY - 10, guiX + 10, guiY + 10, tocolor(255, 40, 80, 200), scaleProgress, Roboto, "center", "center")

							if distanceBetween <= 7.5 then
								if v.characterId == myCharacterId or myAdminLevel >= 1 then
									local fontHeight = dxGetFontHeight(scaleProgress, Roboto)
									local iconSize = 32 * scaleProgress

									if cursorX >= guiX - iconSize / 2 and cursorX <= guiX + iconSize / 2 and cursorY >= guiY + fontHeight and cursorY <= guiY + fontHeight + iconSize then
										dxDrawImage(guiX - iconSize / 2, guiY + fontHeight, iconSize, iconSize, "files/images/trash.png", 0, 0, 0, tocolor(255, 40, 80))
										hoverPlaceDo = k
									else
										dxDrawImage(guiX - iconSize / 2, guiY + fontHeight, iconSize, iconSize, "files/images/trash.png", 0, 0, 0, tocolor(255, 40, 80, 150))
									end
								end
							end
						end
					end
				else
					nearbyPlaceDos[k] = nil
				end
			else
				nearbyPlaceDos[k] = nil
			end
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if state == "up" then
			if hoverPlaceDo then
				triggerServerEvent("deletePlaceDo", resourceRoot, hoverPlaceDo)
			end
		end
	end
)

addEvent("deletePlaceDo", true)
addEventHandler("deletePlaceDo", getRootElement(),
	function (labelIndex)
		nearbyPlaceDos[labelIndex] = nil

		if placedDoLabels[labelIndex] then
			placeDoColShapes[placedDoLabels[labelIndex].colShape] = nil

			if isElement(placedDoLabels[labelIndex].colShape) then
				destroyElement(placedDoLabels[labelIndex].colShape)
			end
		end

		placedDoLabels[labelIndex] = nil
	end
)

addEvent("gotRequestPlaceDos", true)
addEventHandler("gotRequestPlaceDos", getRootElement(),
	function (storedLabels)
		local playerX, playerY, playerZ = getElementPosition(localPlayer)

		placedDoLabels = storedLabels

		for k, v in pairs(placedDoLabels) do
			v.colShape = createColSphere(v.position[1], v.position[2], v.position[3], placeDoColSize)

			if isElement(v.colShape) then
				setElementInterior(v.colShape, v.interior)
				setElementDimension(v.colShape, v.dimension)
			end

			placeDoColShapes[v.colShape] = k

			if getDistanceBetweenPoints3D(v.position[1], v.position[2], v.position[3], playerX, playerY, playerZ) < placeDoColSize then
				nearbyPlaceDos[k] = true
			end
		end
	end
)

addEvent("addPlaceDo", true)
addEventHandler("addPlaceDo", getRootElement(),
	function (labelIndex, labelDetails)
		local playerX, playerY, playerZ = getElementPosition(localPlayer)
		local colshapeElement = createColSphere(labelDetails.position[1], labelDetails.position[2], labelDetails.position[3], placeDoColSize)

		placedDoLabels[labelIndex] = labelDetails
		placedDoLabels[labelIndex].colShape = colshapeElement

		if isElement(colshapeElement) then
			setElementInterior(colshapeElement, labelDetails.interior)
			setElementDimension(colshapeElement, labelDetails.dimension)
		end

		placeDoColShapes[colshapeElement] = labelIndex

		if getDistanceBetweenPoints3D(labelDetails.position[1], labelDetails.position[2], labelDetails.position[3], playerX, playerY, playerZ) < placeDoColSize then
			nearbyPlaceDos[labelIndex] = true
		end
	end
)

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if hitElement == localPlayer then
			if matchingDimension then
				local labelIndex = placeDoColShapes[source]

				if labelIndex then
					nearbyPlaceDos[labelIndex] = true
				end
			end
		end
	end
)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if hitElement == localPlayer then
			if matchingDimension then
				local labelIndex = placeDoColShapes[source]

				if labelIndex then
					nearbyPlaceDos[labelIndex] = nil
				end
			end
		end
	end
)

addEventHandler("onClientChatMessage", getRootElement(),
	function (message, r, g, b)
		if utf8.sub(message, 1, 1) == "#" and r == 231 and g == 217 and b == 176 then
			local messageParts = splitex(utf8.sub(message, 8, utf8.len(message)), "mondja:")
			local myPlayerName = getElementData(localPlayer, "visibleName")

			if messageParts[1] ~= myPlayerName or showMyName then
				for k, v in pairs(streamedPlayers) do
					if v.adminDuty ~= 1 then
						if v.playerName == messageParts[1] then
							if not playerMessages[k] then
								playerMessages[k] = {}
							end

							table.insert(playerMessages[k], {
								msgText = messageParts[2],
								msgType = "local",
								currentTime = getTickCount(),
								visibleTime = 4000 + utf8.len(messageParts[2]) * 150
							})
						end
						break
					end
				end
			end
		elseif utf8.sub(message, 1, 16) == "#DBC5EB*** [LOW]" then
			local messageParts = splitex2(utf8.sub(message, 18, utf8.len(message)), "#DBC5EB")
			local myPlayerName = getElementData(localPlayer, "visibleName")

			if messageParts[1] ~= myPlayerName or showMyName then
				for k, v in pairs(streamedPlayers) do
					if v.adminDuty ~= 1 then
						if v.playerName == messageParts[1] then
							if not playerMessages[k] then
								playerMessages[k] = {}
							end

							table.insert(playerMessages[k], {
								msgText = messageParts[2],
								msgType = "melow",
								currentTime = getTickCount(),
								visibleTime = 4000 + utf8.len(messageParts[2]) * 150
							})
						end
						break
					end
				end
			end
		elseif utf8.sub(message, 1, 10) == "#C2A2DA***" then
			local messageParts = splitex2(utf8.sub(message, 12, utf8.len(message)), "#C2A2DA")
			local myPlayerName = getElementData(localPlayer, "visibleName")

			if messageParts[1] ~= myPlayerName or showMyName then
				for k, v in pairs(streamedPlayers) do
					if v.adminDuty ~= 1 then
						if v.playerName == messageParts[1] then
							if not playerMessages[k] then
								playerMessages[k] = {}
							end

							table.insert(playerMessages[k], {
								msgText = messageParts[2],
								msgType = "me",
								currentTime = getTickCount(),
								visibleTime = 4000 + utf8.len(messageParts[2]) * 150
							})
						end
						break
					end
				end
			end
		elseif utf8.sub(message, 1, 9) == "#956CB4>>" then
			local messageParts = splitex3(utf8.sub(message, 11, utf8.len(message)), "#956CB4")
			local myPlayerName = getElementData(localPlayer, "visibleName")

			if messageParts[1] ~= myPlayerName or showMyName then
				for k, v in pairs(streamedPlayers) do
					if v.adminDuty ~= 1 then
						if v.playerName == messageParts[1] then
							if not playerMessages[k] then
								playerMessages[k] = {}
							end

							table.insert(playerMessages[k], {
								msgText = messageParts[2],
								msgType = "ame",
								currentTime = getTickCount(),
								visibleTime = 4000 + utf8.len(messageParts[2]) * 150
							})
						end
						break
					end
				end
			end
		elseif utf8.sub(message, 1, 2) == " *" then
			if r == 255 and g == 40 and b == 80 then
				local messageParts = splitex4(utf8.sub(message, 3, utf8.len(message)), "((#FF2850")
				local myPlayerName = getElementData(localPlayer, "visibleName")
				local remotePlayerName = utf8.sub(messageParts[2], 10, utf8.len(messageParts[2]) - 2)

				if remotePlayerName ~= myPlayerName or showMyName then
					for k, v in pairs(streamedPlayers) do
						if v.adminDuty ~= 1 then
							if v.playerName == remotePlayerName then
								if not playerMessages[k] then
									playerMessages[k] = {}
								end

								table.insert(playerMessages[k], {
									msgText = messageParts[1],
									msgType = "do",
									currentTime = getTickCount(),
									visibleTime = 4000 + utf8.len(messageParts[1]) * 150
								})
							end
							break
						end
					end
				end
			end
		elseif utf8.sub(message, 1, 7) == "[LOW] *" then
			if r == 255 and g == 102 and b == 130 then
				local messageParts = splitex4(utf8.sub(message, 8, utf8.len(message)), "((#ff6682")
				local myPlayerName = getElementData(localPlayer, "visibleName")
				local remotePlayerName = utf8.sub(messageParts[2], 10, utf8.len(messageParts[2]) - 2)

				if remotePlayerName ~= myPlayerName or showMyName then
					for k, v in pairs(streamedPlayers) do
						if v.adminDuty ~= 1 then
							if v.playerName == remotePlayerName then
								if not playerMessages[k] then
									playerMessages[k] = {}
								end

								table.insert(playerMessages[k], {
									msgText = messageParts[1],
									msgType = "dolow",
									currentTime = getTickCount(),
									visibleTime = 4000 + utf8.len(messageParts[1]) * 150
								})
							end
							break
						end
					end
				end
			end
		end
	end
)

function splitex(text, seperator)
	local words = split(text, " ")
	local result = {[1] = {}, [2] = {}}
	local count = 1

	for i = 1, #words do
		local word = words[i]

		if word then
			if word == seperator then
				count = count + 1
			else
				table.insert(result[count], word)
			end
		end
	end

	result[1] = table.concat(result[1], " ")
	result[2] = table.concat(result[2], " ")

	return {result[1], result[2]}
end

function splitex2(text)
	local words = split(text, " ")
	local result = {[1] = {}, [2] = {}}
	local count = 1

	for i = 1, #words do
		local word = words[i]

		if word then
			local seperator = utf8.sub(word, 1, 7)

			if seperator == "#C2A2DA" or seperator == "#DBC5EB" then
				count = count + 1
			end

			if word == "#C2A2DA***" or word == "#DBC5EB***" then
				count = 2
			end

			table.insert(result[count], word)
		end
	end

	result[1] = table.concat(result[1], " ")
	result[2] = table.concat(result[2], " ")

	return {result[1], result[2]}
end

function splitex3(text)
	local words = split(text, " ")
	local result = {[1] = {}, [2] = {}}
	local count = 1

	for i = 1, #words do
		local word = words[i]

		if word then
			local seperator = utf8.sub(word, 1, 7)

			if seperator == "#956CB4" then
				count = count + 1
			end

			if word == "#956CB4>>" then
				count = 2
			end

			table.insert(result[count], word)
		end
	end

	result[1] = table.concat(result[1], " ")
	result[2] = table.concat(result[2], " ")

	return {result[1], result[2]}
end

function splitex4(text)
	local words = split(text, " ")
	local result = {[1] = {}, [2] = {}}
	local count = 1

	for i = 1, #words do
		local word = words[i]

		if word then
			local seperator = utf8.sub(word, 1, 9)

			if seperator == "((#FF2850" or seperator == "((#ff6682" then
				count = count + 1
			end

			if word == " *" then
				count = 2
			end

			table.insert(result[count], word)
		end
	end

	result[1] = table.concat(result[1], " ")
	result[2] = table.concat(result[2], " ")

	return {result[1], result[2]}
end
