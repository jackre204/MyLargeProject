local screenX, screenY = guiGetScreenSize()

pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(value)
    return math.ceil(value * responsiveMultipler)
end

local availableJobs = {}
for i = 1, 7 do
	availableJobs[i] = {}
end
-- x, y, z, model1, model2, desc1, desc2, color1, color2
table.insert(availableJobs[2], {2484.0300292969, -2091.6408691406, 13.546875, 456, -1, "Az áru szállítására szolgáló jármű.", false, "#587e59", false})
table.insert(availableJobs[2], {61.933612823486, -249.46115112305, 1.578125, 456, -1, "Az áru szállítására szolgáló jármű.", false, "#587e59", false})

table.insert(availableJobs[3], {1279.6478271484, -1361.6693115234, 13.324367523193, 498, -1, "A postai csomagok és levelek szállítására szolgáló jármű.", false, "#ffffff", false})

table.insert(availableJobs[4], {2298.611328125, 2575.1787109375, 10.822759628296, 448, -1, "A pizza szállítására szolgáló robogó.", false, "#8b1014", false})

table.insert(availableJobs[5], {1631.0372314453, -1825.1842041016, 13.533410072327, 431, -1, "Tömegközlekedési jármű, az utasok szállítására alkalmas.", false, "#3d7abc", false})
table.insert(availableJobs[6], {2842.1328125, 1357.3876953125, 10.75, 431, -1, "Tömegközlekedési jármű, az utasok szállítására alkalmas.", false, "#b92c2c", false})

table.insert(availableJobs[7], {1769.3702392578, -2528.818359375, 13.546875, 573, -1, "Az üzemanyag szállítására szolgáló jármű.", false, "#8b1014", false})
table.insert(availableJobs[7], {1760.3702392578, -2528.818359375, 13.546875, 573, -1, "Az üzemanyag szállítására szolgáló jármű.", false, "#8b1014", false})

addEvent("ghostJobCar", true)
addEventHandler("ghostJobCar", getRootElement(),
	function (jobcar)
		local affected = {}

		setElementAlpha(jobcar, 150)

		for k, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
			setElementCollidableWith(jobcar, v, false)
			table.insert(affected, v)
		end

		for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
			setElementCollidableWith(jobcar, v, false)
			table.insert(affected, v)
		end

		setTimer(
			function ()
				if isElement(jobcar) then
					for i = 1, #affected do
						if isElement(affected[i]) then
							setElementCollidableWith(jobcar, affected[i], true)
						end
					end

					setElementAlpha(jobcar, 255)
				end
			end,
		15000, 1)
	end)

addCommandHandler("nearbyjobvehicles",
	function ()
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			local x, y, z = getElementPosition(localPlayer)
			local nearby = 0

			outputChatBox("#DC143C[StrongMTA]: #FFFFFFA közeledben lévő munkajárművek (15 yard):", 255, 255, 255, true)

			for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
				local id = getElementData(v, "jobVehicleID")

				if id then
					local tx, ty, tz = getElementPosition(v)
					local dist = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)

					if dist <= 15 then
						outputChatBox("#DC143C[StrongMTA]: #FFFFFFAzonosító: #8dc63f" .. id .. "#FFFFFF <> Típus: #8dc63f" .. exports.sm_vehiclenames:getCustomVehicleName(getElementModel(v)) .. "#FFFFFF <> Távolság: #8dc63f" .. math.floor(dist), 255, 255, 255, true)
						nearby = nearby + 1
					end
				end
			end

			if nearby == 0 then
				outputChatBox("#DC143C[StrongMTA]: #FFFFFFA közeledben nem található egyetlen munkajármű sem.", 255, 255, 255, true)
			end
		end
	end)

addCommandHandler("deljobveh",
	function (commandName, vehicleId)
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			vehicleId = tonumber(vehicleId)

			if not vehicleId then
				outputChatBox("#3d7abc[Használat]: #FFFFFF/" .. commandName .. " [ID]", 255, 255, 255, true)
				return
			end

			local found = false

			for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
				if vehicleId == getElementData(v, "jobVehicleID") then
					triggerServerEvent("deleteJobVehicle", v)
					outputChatBox("#3d7abc[StrongMTA]: #FFFFFFA munkajármű sikeresen törölve.", 255, 255, 255, true)
					found = true
					break
				end
			end

			if not found then
				outputChatBox("#d75959[StrongMTA]: #FFFFFFNincs találat.", 255, 255, 255, true)
			end
		end
	end)

addCommandHandler("getjobowner",
	function (commandName, vehicleId)
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			vehicleId = tonumber(vehicleId)

			if not vehicleId then
				outputChatBox("#3d7abc[Használat]: #FFFFFF/" .. commandName .. " [ID]", 255, 255, 255, true)
				return
			end

			local found = false

			for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
				if vehicleId == getElementData(v, "jobVehicleID") then
					outputChatBox("#3d7abc[StrongMTA - Munkajármű]: #FFFFFFLehívó: " .. (getElementData(v, "jobSpawnerName") or "N/A") .. " (" .. (getElementData(v, "jobSpawner") or "N/A") .. ")", 255, 255, 255, true)
					found = true
					break
				end
			end

			if not found then
				outputChatBox("#d75959[StrongMTA]: #FFFFFFNincs találat.", 255, 255, 255, true)
			end
		end
	end)

local jobData = {}
local jobBlips = {}

function refreshJobs()
	for k, v in pairs(jobData) do
		if isElement(k) then
			destroyElement(k)
		end
	end

	for k, v in pairs(jobBlips) do
		if isElement(v) then
			destroyElement(v)
		end
	end

	jobData = {}
	jobBlips = {}

	local jobId = getElementData(localPlayer, "char.Job") or 0

	if jobId > 0 then
		if availableJobs[jobId] then
			for i = 1, #availableJobs[jobId] do
				local job = availableJobs[jobId][i]

				local markerElement = createMarker(job[1], job[2], job[3], "checkpoint", 2, 61, 122, 188)
				local blipElement = createBlip(job[1], job[2], job[3], 1, 2)

				setElementData(blipElement, "blipTooltipText", "Munkajármű igénylés")

				jobBlips[markerElement] = blipElement
				jobData[markerElement] = {job[4], job[5], job[6], job[7], job[8], job[9]}
			end
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), refreshJobs)

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName)
		if dataName == "char.Job" or dataName == "loggedIn" then
			refreshJobs()
		end
	end)

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local panelState = false
local selectedJob = false
local Roboto = false
local activeButton = false

addEventHandler("onClientMarkerHit", getResourceRootElement(),
	function (hitPlayer, matchingDimension)
		if hitPlayer == localPlayer and matchingDimension then
			if jobData[source] then
				local pedveh = getPedOccupiedVehicle(localPlayer)

				if isElement(Roboto) then
					destroyElement(Roboto)
				end

				if isElement(pedveh) then
					if getElementModel(pedveh) == jobData[source][1] or getElementModel(pedveh) == jobData[source][2] then
						Roboto = dxCreateFont("files/Roboto.ttf", respc(20))
						panelState = "destroy"

						selectedJob = shallowcopy(jobData[source])

						showCursor(true)
						setElementFrozen(pedveh, true)
					else
						outputChatBox("#DC143C[StrongMTA]: #FFFFFFEzt a járművet itt nem tudod leadni.", 255, 255, 255, true)
					end
				else
					Roboto = dxCreateFont("files/Roboto.ttf", respc(20))
					panelState = true

					selectedJob = shallowcopy(jobData[source])
					selectedJob[7] = selectedJob[5]
					selectedJob[8] = selectedJob[6]
					selectedJob[5] = exports.sm_vehiclenames:getCustomVehicleName(selectedJob[1])
					selectedJob[6] = selectedJob[2] ~= -1 and exports.sm_vehiclenames:getCustomVehicleName(selectedJob[2])

					showCursor(true)
					setElementFrozen(localPlayer, true)
				end
			end
		end
	end)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if panelState == "destroy" then
			local sx, sy = respc(270), respc(180) + 10
			local x = screenX / 2 - sx / 2
			local y = screenY / 2 - sy / 2
			local buttons = {}
			buttonsC = {}

			-- ** Háttér
			dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))
			dxDrawRectangle(x + 3, y + 3, sx - 6, respc(35) - 6, tocolor(45, 45, 45, 200))
			dxDrawText("#3d7abcStrong#ffffffMTA", x + 6, y - 6 + ((respc(35) - 6) / 2), nil, nil, tocolor(200, 200, 200, 200), 0.55, Roboto, "left", "top", false, false, false, true)

			-- ** Content
			dxDrawText("Leakarod adni a munkajárművedet?", x + sx / 2, y + respc(35) - 6 + respc(20), nil, nil, tocolor(200, 200, 200, 200), 0.55, Roboto, "center", "top")

			-- Igen
			buttons["destroy"] = {x + 5, y + sy - respc(80) - 10, sx - 10}

			drawButton("destroy", "Igen", x + 5, y + sy - respc(80) - 10, sx - 10, respc(40), {215, 89, 89}, false, Roboto)

			-- Nem
			buttons["close"] = {x + 5, y + sy - respc(40) - 5, sx - 10, respc(40)}

			drawButton("close", "Nem", x + 5, y + sy - respc(40) - 5, sx - 10, respc(40), {61, 122, 188}, false, Roboto)


			-- ** Gombok
			local cx, cy = getCursorPosition()

			if tonumber(cx) then
				cx = cx * screenX
				cy = cy * screenY

				activeButton = false
				activeButtonC = false

				for k, v in pairs(buttonsC) do
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
		elseif panelState then
			local buttons = {}
			buttonsC = {}

			if selectedJob[4] then
				local sx, sy = respc(510), respc(465)
				local x = screenX / 2 - sx / 2
				local y = screenY / 2 - sy / 2

				-- ** Háttér
				dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))

				-- ** Keret
				dxDrawRectangle(x - 3, y - 3, sx + (3 * 2), 3, tocolor(0, 0, 0, 200)) -- felső
				dxDrawRectangle(x - 3, y + sy, sx + (3 * 2), 3, tocolor(0, 0, 0, 200)) -- alsó
				dxDrawRectangle(x - 3, y, 3, sy, tocolor(0, 0, 0, 200)) -- bal
				dxDrawRectangle(x + sx, y, 3, sy, tocolor(0, 0, 0, 200)) -- jobb

				-- ** Content
				dxDrawImage(math.floor(x + 8), math.floor(y + 8), 240, 240, "files/" .. utf8.lower(getVehicleNameFromModel(selectedJob[1])) .. ".png")
				dxDrawImage(math.floor(x + sx - 240 - 8), math.floor(y + 8), 240, 240, "files/" .. utf8.lower(getVehicleNameFromModel(selectedJob[2])) .. ".png")

				-- Jármű
				dxDrawText(selectedJob[5], x + 10, y + 270, x + 240 - 10, y + 300, tocolor(255, 255, 255), 1, Roboto, "center", "center")
				dxDrawText(selectedJob[6], x + sx - 248, y + 270, x + sx - 10, y + 300, tocolor(255, 255, 255), 1, Roboto, "center", "center")

				-- Leírás
				dxDrawText(selectedJob[3], x + 10, y + 300, x + 240 - 10, y + sy - 110, tocolor(255, 255, 255), 0.5, Roboto, "center", "center", false, true)
				dxDrawText(selectedJob[4], x + sx - 248, y + 300, x + sx - 10, y + sy - 110, tocolor(255, 255, 255), 0.5, Roboto, "center", "center", false, true)

				-- Kiválaszt
				buttons["spawn"] = {x + 10, y + sy - 100, 240, 40}
				buttons["spawn2"] = {x + sx - 248, y + sy - 100, 240, 40}

				if activeButton == "spawn" then
					dxDrawRectangle(x + 10, y + sy - 100, 240, 40, tocolor(124, 197, 118))
				else
					dxDrawRectangle(x + 10, y + sy - 100, 240, 40, tocolor(124, 197, 118, 200))
				end

				if activeButton == "spawn2" then
					dxDrawRectangle(x + sx - 248, y + sy - 100, 240, 40, tocolor(124, 197, 118))
				else
					dxDrawRectangle(x + sx - 248, y + sy - 100, 240, 40, tocolor(124, 197, 118, 200))
				end

				dxDrawText("Ezt szeretném!", x + 10, y + sy - 100, x + 250, y + sy - 60, tocolor(0, 0, 0), 0.65, Roboto, "center", "center")
				dxDrawText("Ezt szeretném!", x + sx - 248, y + sy - 100, x + sx - 10, y + sy - 60, tocolor(0, 0, 0), 0.65, Roboto, "center", "center")

				-- Kilépés
				buttons["close"] = {x + 10, y + sy - 50, sx - 20, 40}

				if activeButton == "close" then
					dxDrawRectangle(x + 10, y + sy - 50, sx - 20, 40, tocolor(215, 89, 89))
				else
					dxDrawRectangle(x + 10, y + sy - 50, sx - 20, 40, tocolor(215, 89, 89, 200))
				end

				dxDrawText("Kilépés", x + 10, y + sy - 50, x + sx - 20, y + sy - 10, tocolor(0, 0, 0), 0.65, Roboto, "center", "center")
			else
				local sx, sy = respc(255), respc(350)
				local x = screenX / 2 - sx / 2
				local y = screenY / 2 - sy / 2

				-- ** Háttér
				dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))
				dxDrawRectangle(x + 3, y + 3, sx - 6, respc(35) - 6, tocolor(45, 45, 45, 200))
				dxDrawText("#3d7abcStrong#ffffffMTA", x + 3 + respc(5), y + 3 + ((respc(35) - 6) / 2), nil, nil, tocolor(200, 200, 200, 200), 0.8, Roboto, "left", "center", false, false, false, true)
				dxDrawImage(math.floor(x), math.floor(y - respc(25)), sx, sx, "files/" .. utf8.lower(getVehicleNameFromModel(selectedJob[1])) .. ".png")

				-- Jármű
				dxDrawText(selectedJob[5], x + respc(10), y - respc(120) + respc(270), x + sx - respc(10), y - respc(120) + respc(300), tocolor(200, 200, 200, 200), 1, Roboto, "center", "center")

				-- Leírás
				dxDrawText(selectedJob[3], x + respc(10), y - respc(60) + respc(300), x + sx - respc(10), y - respc(60) + sy - respc(110), tocolor(200, 200, 200, 200), 0.5, Roboto, "center", "center", false, true)

				-- Kiválaszt
				buttons["spawn"] = {x + 5, y + sy - respc(80) - 10, sx - 10, respc(40)}

				drawButton("spawn", "Jármű spawnolása", x + 5, y + sy - respc(80) - 10, sx - 10, respc(40), {61, 122, 188}, false, Roboto)

				-- Kilépés
				buttons["close"] = {x + 5, y + sy - respc(40) - 5, sx - 10, respc(40)}

				drawButton("close", "Kilépés", x + 5, y + sy - respc(40) - 5, sx - 10, respc(40), {215, 89, 89}, false, Roboto)

			end

			-- ** Gombok
			local cx, cy = getCursorPosition()

			if tonumber(cx) then
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
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if activeButton then
			if button == "left" then
 				if state == "up" then
 					if activeButton == "destroy" then
 						triggerServerEvent("createJobVehicle", localPlayer, false)
 					elseif activeButton == "spawn" then
 						triggerServerEvent("createJobVehicle", localPlayer, selectedJob[1], selectedJob[7])
 					elseif activeButton == "spawn2" then
 						triggerServerEvent("createJobVehicle", localPlayer, selectedJob[2], selectedJob[8])
 					end

 					panelState = false

					if isElement(Roboto) then
						destroyElement(Roboto)
					end

					Roboto = nil
					activeButton = false
					selectedJob = false

					showCursor(false)
					setElementFrozen(localPlayer, false)

					local pedveh = getPedOccupiedVehicle(localPlayer)

					if isElement(pedveh) then
						setElementFrozen(pedveh, false)
					end
 				end
			end
		end
	end)


function drawText(text, x, y, w, h, color, size, font, left)
    if left then
        dxDrawText(text,x+20,y+h/2,x+20,y+h/2,color,size,font,"left","center",false,false,false,true)
    else
        dxDrawText(text,x+w/2,y+h/2,x+w/2,y+h/2,color,size,font,"center","center",false,false,false,true)
    end
end