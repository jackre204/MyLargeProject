pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)


local jobPed = createPed(299, 1503.8459472656, -1782.6993408203, 24.706586837769, 0)
setElementDimension(jobPed, 0)
setElementInterior(jobPed, 0)
setElementData(jobPed, "invulnerable", true)
setElementData(jobPed, "visibleName", "Dominic Goodwin", true)
setElementData(jobPed, "ped.type", "v3Job", true)
setElementFrozen(jobPed, true)

local panelState = false
local RobotoFont = false
local activeButton = false

addEventHandler("onClientClick", getRootElement(),
	function (button, state, _, _, _, _, _, hitElement)
		if button == "right" then
			if state == "up" then
				if hitElement then
					local pedType = getElementData(hitElement, "ped.type")
					if pedType and type(pedType) == "string" then
						if pedType == "v3Job" then
							local playerX, playerY, playerZ = getElementPosition(localPlayer)
							local targetX, targetY, targetZ = getElementPosition(hitElement)

							if getDistanceBetweenPoints3D(targetX, targetY, targetZ, playerX, playerY, playerZ) < 2.5 then
								if getElementData(localPlayer, "char.Job") > 0 then
									exports.sm_hud:showInfobox("e", "Már van munkád. Használd a /felmond parancsot!")
								else
									if not panelState then
										panelState = true
										showCursor(true)
										RobotoFont = dxCreateFont(":sm_core/fonts/Raleway.ttf", respc(18), false, "antialiased")
										addEventHandler("onClientRender", getRootElement(), renderThePanel)
										addEventHandler("onClientClick", getRootElement(), handlePanelClick)
										addEventHandler("onClientKey", root, keyHandler)
									end
								end
							end
						end
					end
				end
			end
		end
	end)

function terminateJob()
	if getElementData(localPlayer, "char.Job") > 0 then
		local playerX, playerY, playerZ = getElementPosition(localPlayer)
		local targetX, targetY, targetZ = getElementPosition(jobPed)

		if getDistanceBetweenPoints3D(targetX, targetY, targetZ, playerX, playerY, playerZ) < 2.5 then
			setElementData(localPlayer, "char.Job", 0)
			exports.sm_hud:showInfobox("s", "Sikeresen felmondtál! Már vállalhatsz más munkát is!")
		else
			exports.sm_hud:showInfobox("e", "Itt nem tudsz felmondani!")
		end
	else
		exports.sm_hud:showInfobox("e", "Már munkanélküli vagy!")
	end
end
addCommandHandler("felmond", terminateJob)
addCommandHandler("felmondas", terminateJob)
addCommandHandler("quitjob", terminateJob)

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = 1

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedres)
		if getResourceName(startedres) == "sm_hud" then
			responsiveMultipler = exports.sm_hud:getResponsiveMultipler()
		else
			if source == getResourceRootElement() then
				local sm_hud = getResourceFromName("sm_hud")

				if sm_hud then
					if getResourceState(sm_hud) == "running" then
						responsiveMultipler = exports.sm_hud:getResponsiveMultipler()
					end
				end
			end
		end
	end)

function respc(num)
	return num*responsiveMultipler
end

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName)
		if dataName == "char.Job" then
			local id = getElementData(localPlayer, dataName)

			if availableJobs[id] then
				for i = 1, #availableJobs[id].instructions do
					outputChatBox("#3d7abc[Project: Synthetical - " .. availableJobs[id].name .. "]: #ffffff" .. availableJobs[id].instructions[i], 255, 255, 255, true)
				end
			end
		end
	end)

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
    
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
    
    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end
    
    return timestamp
end

function handlePanelClick(button, state)
	if button == "left" then
		if state == "up" then
			if activeButton then
				if string.find(activeButton, "applyJob_") then
					local id = tonumber(gettok(activeButton, 2, "_"))

					if availableJobs[id] then
						local items = exports.sm_items:getLocalPlayerItems()
						local identityCard = false
						local driverLicense = false
						local myName = getElementData(localPlayer, "visibleName"):gsub("_", " ")

						for k, v in pairs(items) do
							if v.itemId == 207 or v.itemId == 208 then
								local characterName = split(v.data1, ";")[2] or "N/A"

								if characterName:gsub("_", " ") == myName then
									local expireTime = split(v.data3, ".")

									if getTimestamp() < getTimestamp(expireTime[1], expireTime[2], expireTime[3], 0, 0, 0) then
										if v.itemId == 207 then
											identityCard = true
										else
											driverLicense = true
										end
									end
								end
							end
						end

					--[[	if not identityCard then
							exports.sm_hud:showInfobox("e", "A munka felvételéhez érvényes személyi kell!")
							return
						end

						if availableJobs[id].driverLicense then
							if not driverLicense then
								exports.sm_hud:showInfobox("e", "A munka felvételéhez érvényes jogosítvány kell!")
								return
							end
						end]]

						setElementData(localPlayer, "char.Job", id)
						exports.sm_hud:showInfobox("s", "Sikeresen felvetted a következő munkát: " .. availableJobs[id].name .. "!")
					end
				end

				removeEventHandler("onClientRender", getRootElement(), renderThePanel)
				removeEventHandler("onClientClick", getRootElement(), handlePanelClick)
				removeEventHandler("onClientKey", getRootElement(), keyHandler)

				panelState = false

				showCursor(false)
				destroyElement(RobotoFont)
				RobotoFont = nil
			end
		end
	end
end

function keyHandler(key, state)
	if key == "backspace" and state then
		if panelState then
			removeEventHandler("onClientKey", getRootElement(), keyHandler)
			removeEventHandler("onClientRender", getRootElement(), renderThePanel)
			removeEventHandler("onClientClick", getRootElement(), handlePanelClick)
			panelState = false
			showCursor(false)
			destroyElement(RobotoFont)
			RobotoFont = nil
		end
	end
end

function renderThePanel()
	local sx, sy = respc(500), respc(80) + respc(40) * #availableJobs--600
	local x, y = screenX / 2 - sx / 2, screenY / 2 - sy / 2

	dxDrawRectangle(x, y, sx, sy+respc(12), tocolor(25, 25, 25))
	dxDrawRectangle(x+respc(4), y+respc(4), sx-respc(8), respc(35), tocolor(45, 45, 45, 180))
	dxDrawText("#3d7abcStrong#ffffffMTA", x + respc(33), y+respc(4) - respc(1), 0, y+respc(4) + respc(35), tocolor(200, 200, 200, 200), 0.9, RobotoFont, "left", "center", false, false, false, true)
	dxDrawImage(x, y+respc(4), respc(35), respc(35),exports.sm_core:getServerLogo())

	local buttons = {}
	buttonsC = {}


	local oneSize = (sy - respc(35)) / #availableJobs

	for i=1, #availableJobs do
		local y = y+respc(8) + oneSize * (i - 1) + respc(35)

		if i % 2 ~= 1 then
			dxDrawRectangle(x+respc(4), y, sx-respc(8), oneSize, tocolor(35, 35, 35, 180))
		else
			dxDrawRectangle(x+respc(4), y, sx-respc(8), oneSize, tocolor(45, 45, 45, 180))
		end

		dxDrawText(availableJobs[i].name, x + respc(15), y, 0, y + oneSize, tocolor(200, 200, 200, 200), 0.75, RobotoFont, "left", "center")

		local buttonHeight = oneSize * 0.75
		local y2 = y + (oneSize - buttonHeight) / 2


		--exports.sm_hud:dxDrawRoundedRectangle(x + sx - respc(15) - respc(150), y2, respc(150), buttonHeight, tocolor(61, 122, 188, buttonAlpha))
		drawButton("applyJob_" .. i, "Munka felvétele", x + sx - respc(15) - respc(150), y2, respc(150), buttonHeight, {61, 122, 188}, false, RobotoFont, true, 0.65)
		--dxDrawText("Munka felvétele", x + sx - respc(15) - respc(150), y, x + sx - respc(15), y + oneSize, tocolor(200, 200, 200, 200), 0.65, RobotoFont, "center", "center")

		buttons["applyJob_" .. i] = {x + sx - respc(15) - respc(150), y2, respc(150), buttonHeight}
	end

	local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

		activeButton = false
		activeButtonC = false

		for k, v in pairs(buttons) do
			if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
				activeButton = k
				activeButtonC = k
				break
			end
		end
	else
		activeButton = false
		activeButtonC = false
	end
end

