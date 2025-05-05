pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

function resp(num)
	return (num * responsiveMultipler)
end

local lastNames = {
	"Bell", "Walsh", "Black", "Butler", "Thompson", "O'connor", "Marquez", "Morales", "Douglas", "Hendrix",
	"Chapman", "Adams", "Harper", "Saunders", "Reynolds", "Lara", "Wong", "Leon", "Mayo", "Donaldson",
	"Stewart", "Wallace", "Bell", "Sutton", "Shaw", "Carson", "Ferrell", "Donovan", "Carson", "Mathis",
	"Riley", "West", "Stone", "Hughes", "Lawson", "Zamora", "Cotton", "Silva", "Frye", "Townsend",
	"Hopkins", "Brown", "Kelly", "Harris", "Harvey", "Sparks", "Gonzales", "Lane", "Meyer", "Vazquez",
	"Day", "Hayes", "Wilson", "Howard", "Jordan", "Mills", "Daugherty", "Manning", "Franklin", "Duffy"
}

local maleNames = {
	"Jess", "Leigh", "Elliot", "Rory", "Silver", "Emerson", "Kris", "Tyler", "Riley", "Casey",
	"Ashton", "Sam", "Taylor", "Ollie", "Christoph", "Brennen", "Cedric", "Otto", "Colten", "Jameson",
	"Morgan", "Bobby", "Anthony", "Arthur", "Leo", "Gilbert", "Jaycob", "Wade", "Louis", "Arthur",
	"Jake", "Declan", "Kian", "Charles", "Anthony", "Kayson", "Bryan", "Caiden", "Foster", "Moshe",
	"Arthur", "Zak", "Alex", "Lucas", "Oliver", "Atticus", "Randall", "Prince", "Royce", "Jalen",
	"Kayden", "Matthew", "Ryan", "Ollie", "Edward", "Levi", "Fletcher", "William", "Hassan", "Ernesto"
}

local femaleNames = {
	"Amber", "Rosie", "Kayleigh", "Mollie", "Mya", "Jenna", "Brynlee", "Ryleigh", "Jillian", "Kylah",
	"Paige", "Lucy", "Alisha", "Daisy", "Zoe", "Caroline", "Alisha", "Jane", "Michaela", "Karla",
	"Holly", "Isabel", "Leah", "Erin", "Charlotte", "Carleigh", "Everly", "Audrianna", "Melanie", "Sky",
	"Evelyn", "Amelie", "Kayleigh", "Emma", "Abby", "Alyssa", "Miley", "Thalia", "Sasha", "Adley",
	"Matilda", "Abby", "Kayla", "Skye", "Paige", "Gisselle", "Angelina", "Iris", "Zahra", "Yareli",
	"Molly", "Lola", "Lara", "Amy", "Freya", "Eliana", "Carissa", "Laney", "Danica", "Clarissa"
}

local maleSkins = exports.sm_binco:getSkinsByType("Férfi")
local femaleSkins = exports.sm_binco:getSkinsByType("Női")

local jobPedElement = createPed(67, 1310.1330566406, -1367.4982910156, 13.536259651184, 180)
local jobPedBlip = false

setElementFrozen(jobPedElement, true)
setElementData(jobPedElement, "invulnerable", true)
setElementData(jobPedElement, "visibleName", "Frank", false)
setElementData(jobPedElement, "pedNameType", "Munka", false)

local deliveryPackages = false
local requestJobStart = false

local pdaWidth = respc(300)
local pdaHeight = respc(600)
local pdaPosX = math.floor(screenX - pdaWidth * 1.15)
local pdaPosY = math.floor(screenY / 2 - pdaHeight / 2)

local pdaFont = false
local pdaPage = 1
local pdaHover = false
local pdaMoving = false

local carriedObjects = {}

local postCarInventory = {}
local postCarElement = false

local Roboto = false
local activeButton = false

addEventHandler("onClientVehicleStartEnter", getRootElement(),
	function (enterPlayer)
		if enterPlayer == localPlayer then
			if carriedObjects[localPlayer] then
				cancelEvent()
			end
		end
	end
)

addEventHandler("onClientVehicleEnter", getRootElement(),
	function (enterPlayer, seat)
		if enterPlayer == localPlayer then
			if seat == 0 then
				if getElementModel(source) == 498 then
					if getElementData(localPlayer, "char.Job") == jobID then
						if not deliveryPackages then
							outputChatBox("#3d7abc[StrongMTA - Postás]: #ffffffMenj #3d7abcFrank#ffffff-hez, és vedd fel a rendeléseket. (Jobbklikk az NPC-n)", 255, 255, 255, true)
							
							if not isElement(jobPedBlip) then
								local x, y, z = getElementPosition(jobPedElement)
								jobPedBlip = createBlip(x, y, z, 0, 2, 124, 197, 118)
								setElementData(jobPedBlip, "blipTooltipText", "Frank")
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (leftPlayer, seat)
		if leftPlayer == localPlayer then
			if seat == 0 then
				if getElementModel(source) == 498 then
					if isElement(jobPedBlip) then
						destroyElement(jobPedBlip)
					end

					jobPedBlip = nil
				end
			end
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, absX, absY, worldX, worldY, worldZ, clickedElement)
		if pdaHover then
			if state == "up" then
				if pdaHover == "plus" then
					pdaPage = pdaPage + 1

					if pdaPage > #deliveryPackages then
						pdaPage = 1
					end

					playSound("files/button.mp3")
				else
					pdaPage = pdaPage - 1

					if pdaPage < 1 then
						pdaPage = #deliveryPackages
					end

					playSound("files/button.mp3")
				end
			end
		end
		if state == "up" then
			if isElement(clickedElement) then
				if clickedElement == jobPedElement then
					if getElementData(localPlayer, "char.Job") == jobID then
						local playerX, playerY, playerZ = getElementPosition(localPlayer)
						local targetX, targetY, targetZ = getElementPosition(clickedElement)

						if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 3 then
							if not deliveryPackages and not requestJobStart then
								local jobVehicle = getElementData(localPlayer, "jobVehicle")

								if isPedInVehicle(localPlayer) then
									outputChatBox("#d75959[StrongMTA - Postás]: #ffffffElőbb szállj ki a járművedből.", 255, 255, 255, true)
									return
								end

								if not jobVehicle or getElementModel(jobVehicle) ~= 498 then
									outputChatBox("#d75959[StrongMTA - Postás]: #ffffffElőbb kérj egy furgont a #3d7abcmunkajármű#ffffff ikonnál.", 255, 255, 255, true)
									return
								end

								requestJobStart = true
								triggerServerEvent("requestPostmanJobStart", localPlayer)
							end
						end
					end
				end
			end
		end
	end
)

addEvent("onPostmanJobStarted", true)
addEventHandler("onPostmanJobStarted", localPlayer,
	function (recipientsNumber, deliveryPositions, packageType, packageIdentifier)
		if isElement(jobPedBlip) then
			destroyElement(jobPedBlip)
		end
		
		requestJobStart = false
		deliveryPackages = {}

		shuffleTable(lastNames)
		shuffleTable(maleNames)
		shuffleTable(femaleNames)

		pdaPage = 1

		local carryingMail = {}

		for i = 1, recipientsNumber do
			local visibleName = "_" .. lastNames[i]
			local skinId = 0

			if math.random(2) == 1 then
				skinId = maleSkins[math.random(1, #maleSkins)][1]
				visibleName = maleNames[i] .. visibleName
			else
				skinId = femaleSkins[math.random(1, #femaleSkins)][1]
				visibleName = femaleNames[i] .. visibleName
			end

			local position = deliveryPositions[i]
			local pedElement = createPed(skinId, unpack(position))
			local markerElement = createMarker(position[1], position[2], position[3] + 1.5, "arrow", 0.3, 61, 122, 188)
			local blipElement = createBlip(position[1], position[2], position[3], 0, 2, 61, 122, 188)
			local zoneName = getZoneName(position[1], position[2], position[3])

			setElementFrozen(pedElement, true)
			setElementData(pedElement, "visibleName", visibleName, false)
			setElementData(pedElement, "pedNameType", "Munka", false)
			setElementData(pedElement, "invulnerable", true)
			setElementData(blipElement, "blipTooltipText", i .. ".: " .. visibleName:gsub("_", " ") .. " - " .. zoneName)

			table.insert(deliveryPackages, {
				pedElement,
				false,
				packageType[i],
				markerElement,
				math.random(2),
				false,
				visibleName:gsub("_", " "),
				zoneName,
				packageIdentifier[i],
				blipElement
			})

			table.insert(carryingMail, {packageType[i], packageIdentifier[i]})
		end

		setElementData(localPlayer, "carryingMail", carryingMail)

		triggerServerEvent("carryAnimation", localPlayer)
		exports.sm_controls:toggleControl({"jump", "aim_weapon", "fire", "enter_exit", "enter_passenger", "crouch"}, false)

		pdaFont = dxCreateFont("files/pda.ttf", respc(20), false, "antialiased")
		addEventHandler("onClientRender", getRootElement(), renderPDA)

		outputChatBox("#3d7abc[StrongMTA - Postás]: #ffffffFelvetted a küldeményeket. Tedd be a kocsiba a szállítmányt. (Jobbklikk az autó hátuljára)", 255, 255, 255, true)
		outputChatBox("#3d7abc[StrongMTA - Postás]: #ffffffA #3d7abccímzetteket#ffffff a térképen és a #3d7abcPDA-n#ffffff látod.", 255, 255, 255, true)
		outputChatBox("#3d7abc[StrongMTA - Postás]: #ffffffA PDA-n a címzettek között a nyilakkal tudsz navigálni.", 255, 255, 255, true)
		outputChatBox("#3d7abc[StrongMTA - Postás]: #ffffffAz autód csomagtartóját a jobbklikk segitségével nyithatod meg.", 255, 255, 255, true)
	end
)

function renderPDA()
	local cursorX, cursorY = getCursorPosition()

	pdaHover = false

	if cursorX then
		cursorX = cursorX * screenX
		cursorY = cursorY * screenY

		if getKeyState("mouse1") then
			if pdaMoving then
				pdaPosX = math.floor(pdaMoving[3] + cursorX - pdaMoving[1])
				pdaPosY = math.floor(pdaMoving[4] + cursorY - pdaMoving[2])
			else
				if cursorY >= pdaPosY + respc(420) and cursorY <= pdaPosY + respc(420) + respc(30) then
					if cursorX >= pdaPosX + respc(60) and cursorX <= pdaPosX + respc(60) + respc(45) then
						pdaHover = "minus"
					elseif cursorX >= pdaPosX + respc(195) and cursorX <= pdaPosX + respc(195) + respc(45) then
						pdaHover = "plus"
					end
				end

				if not pdaHover and cursorX > pdaPosX and cursorY > pdaPosY and cursorX < pdaPosX + pdaWidth and cursorY < pdaPosY + pdaHeight then
					pdaMoving = {cursorX, cursorY, pdaPosX, pdaPosY}
				end
			end
		else
			pdaMoving = false
		end
	end

	local deliveryData = deliveryPackages[pdaPage]

	

	dxDrawImage(pdaPosX, pdaPosY, pdaWidth, pdaHeight, "files/pda.png")
	dxDrawText(string.format(".....................\n%s. címzett", pdaPage), pdaPosX - respc(3), pdaPosY + respc(80), pdaPosX + pdaWidth, 0, tocolor(30, 40, 70), 0.3, pdaFont, "center", "top")
	dxDrawText(string.format("%s\n%s\n\nKüldemény: %s\nAzonosító: %s", deliveryData[7], deliveryData[8], (deliveryData[3] == 1 and "levél" or "csomag"), deliveryData[9]), pdaPosX - respc(3), pdaPosY + respc(130), pdaPosX + pdaWidth, 0, tocolor(30, 40, 70), 0.5, pdaFont, "center", "top")

	if deliveryData[6] then
		dxDrawText("- KÉZBESÍTVE -", pdaPosX - respc(3), pdaPosY + respc(250), pdaPosX + pdaWidth, 0, tocolor(30, 40, 70), 0.5, pdaFont, "center", "top")
	end

	dxDrawText(string.format(".....................\n%s/%s\n.....................", pdaPage, #deliveryPackages), pdaPosX - respc(3), pdaPosY + respc(300), pdaPosX + pdaWidth, 0, tocolor(30, 40, 70), 0.5, pdaFont, "center", "top")
	dxDrawImage(pdaPosX, pdaPosY, pdaWidth, pdaHeight, "files/pda2.png")
	--dxDrawRectangle(pdaPosX + respc(60), pdaPosY + respc(420), respc(45), respc(30))
	--dxDrawRectangle(pdaPosX + respc(195), pdaPosY + respc(420), respc(45), respc(30))
end

addEvent("openPostCar", true)
addEventHandler("openPostCar", getRootElement(),
	function ()
		postCarInventory = getElementData(source, "postCarInventory") or {}
		postCarElement = source

		if isElement(postCarElement) and not isPanelShow then
			Roboto = dxCreateFont("files/Roboto.ttf", respc(12), false, "antialiased")

			showCursor(true)
			addEventHandler("onClientRender", getRootElement(), renderInventory)
			addEventHandler("onClientClick", getRootElement(), clickInventory)
			isPanelShow = true
		end
	end
)

addEvent("postDeliveredSuccessfully", true)
addEventHandler("postDeliveredSuccessfully", getRootElement(),
	function (packageId, remainingPackages)
		deliveryPackages[packageId][6] = true

		if isElement(deliveryPackages[packageId][4]) then
			destroyElement(deliveryPackages[packageId][4])
		end

		if isElement(deliveryPackages[packageId][2]) then
			destroyElement(deliveryPackages[packageId][2])
		end

		if isElement(deliveryPackages[packageId][10]) then
			destroyElement(deliveryPackages[packageId][10])
		end

		setElementData(localPlayer, "carryingMail", false)
		exports.sm_controls:toggleControl({"jump", "aim_weapon", "fire", "enter_exit", "enter_passenger", "crouch"}, true)

		if remainingPackages <= 0 then
			endTheJob()
		end

		playSound("files/bubble.mp3")
	end
)

function endTheJob(forced)
	if deliveryPackages then
		local pedElements = {}

		for i = 1, #deliveryPackages do
			table.insert(pedElements, deliveryPackages[i][1])
		end

		deliveryPackages = false

		if not forced then
			if not isElement(jobPedBlip) then
				local x, y, z = getElementPosition(jobPedElement)
				jobPedBlip = createBlip(x, y, z, 0, 2, 124, 197, 118)
				setElementData(jobPedBlip, "tooltipText", "Frank")
			end

			outputChatBox("#3d7abc[StrongMTA - Postás]: #ffffffLeszállítottad az összes küldeményt. Új kör megkezdéséhez menj #3d7abcFrank#ffffff-hez.", 255, 255, 255, true)
		else
			if isElement(jobPedBlip) then
				destroyElement(jobPedBlip)
			end

			jobPedBlip = nil
		end

		setTimer(
			function ()
				for i = 1, #pedElements do
					if isElement(pedElements[i]) then
						destroyElement(pedElements[i])
					end
				end
			end,
		10000, 1)

		if isElement(pdaFont) then
			destroyElement(pdaFont)
		end

		pdaFont = nil

		removeEventHandler("onClientRender", getRootElement(), renderPDA)
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		setElementData(localPlayer, "usingPostCar", false)
		setElementData(localPlayer, "carryingMail", false)
	end
)

function clickInventory(button, state)
	if state == "up" then
		if activeButton then
			if string.find(activeButton, "get_out:") then
				local packageDetails = split(activeButton, ":")
				local packageIdentifier = packageDetails[2]
				local packageType = tonumber(packageDetails[3])

				if packageIdentifier then
					if postCarInventory[packageIdentifier] then
						triggerServerEvent("getOutMail", localPlayer, postCarElement, packageIdentifier, packageType)
						exports.sm_chat:localActionC(localPlayer, "kivett egy " .. (packageType == 1 and "levelet" or "csomagot") .. " a kocsiból.")
					else
						return
					end
				end
			end

			if activeButton == "exit" then
				setElementData(localPlayer, "usingPostCar", false)
			end

			if isElement(Roboto) then
				destroyElement(Roboto)
			end

			showCursor(false)
			removeEventHandler("onClientRender", getRootElement(), renderInventory)
			removeEventHandler("onClientClick", getRootElement(), clickInventory)
			isPanelShow = false
		end
	end
end

function renderInventory()
	if not isElement(postCarElement) then
		setElementData(localPlayer, "usingPostCar", false)

		if isElement(Roboto) then
			destroyElement(Roboto)
		end

		showCursor(false)
		removeEventHandler("onClientRender", getRootElement(), renderInventory)
		removeEventHandler("onClientClick", getRootElement(), clickInventory)
		isPanelShow = false
		return
	end

	local buttons = {}
	buttonsC = {}
	local counter = 1
	local empty = true

	for k in pairs(postCarInventory) do
		counter = counter + 1
	end	

	if counter > 1 then
		counter = counter - 1
		empty = false
	end

	local sx, sy = respc(255), respc(32) * counter + respc(32)
	local x = screenX / 2 - sx / 2
	local y = screenY / 2 - sy / 2
	
	-- ** Háttér
	dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))

	-- ** Cím
	dxDrawRectangle(x + 3, y + 3, sx - 6, respc(32) - 6, tocolor(45, 45, 45, 180))
	dxDrawText("#3d7abcStrong#ffffffMTA - Postakocsi", x + 4, y + 3 + (respc(32) - 6) / 2, nil, nil, tocolor(200, 200, 200, 200), 0.85, Roboto, "left", "center", false, false, false, true)

	-- ** Content
	buttons.exit = {x + sx - 4 - respc(28), y + respc(16) - respc(14), respc(28), respc(28)}

	if activeButton == "exit" then
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/close.png", 0, 0, 0, tocolor(215, 89, 89))
	else
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/close.png", 0, 0, 0, tocolor(255, 255, 255, 200))
	end

	y = y + respc(32)

	if empty then
		dxDrawText("Üres a postakocsid.", x, y, x + sx, y + respc(32), tocolor(200, 200, 200, 200), 0.85, Roboto, "center", "center")
	else
		for k in pairs(postCarInventory) do
			local buttonName = "get_out:" .. k .. ":" .. (string.sub(k, 1, 1) == "M" and 1 or 2)

			dxDrawText(string.sub(k, 1, 1) == "M" and "Levél" or "Csomag", x + respc(8), y, 0, y + respc(32), tocolor(200, 200, 200, 200), 0.85, Roboto, "left", "center")

			buttons[buttonName] = {x + sx - respc(8) - respc(64), y + respc(4), respc(64), respc(32) - respc(8)}

			dxDrawText(k, x, y, buttons[buttonName][1] - respc(8), y + respc(32), tocolor(200, 200, 200, 200), 0.825, Roboto, "right", "center")

			drawButton(buttonName, "Kivesz", buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], {61, 122, 188}, false, Roboto)
			y = y + respc(32)
		end
	end

	-- ** Button handler
	activeButton = false
	activeButtonC = false

	if isCursorShowing() then
		local relX, relY = getCursorPosition()
		local absX, absY = relX * screenX, relY * screenY

		for k, v in pairs(buttons) do
			if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
				activeButton = k
				activeButtonC = k
				break
			end
		end
	end
end

addEventHandler("onClientPlayerQuit", getRootElement(),
	function ()
		if carriedObjects[source] then
			for i = 1, #carriedObjects[source] do
				local objectElement = carriedObjects[source][i]

				if isElement(objectElement) then
					destroyElement(objectElement)
				end
			end

			carriedObjects[source] = nil
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "carryingMail" then
			local dataValue = getElementData(source, dataName)

			if dataValue and #dataValue > 0 then
				if not carriedObjects[source] then
					carriedObjects[source] = {}
				end

				if #dataValue == 1 then
					if dataValue[1][1] == 1 then
						local objectElement = createObject(8583, 0, 0, 0)
						if isElement(objectElement) then
							setElementCollisionsEnabled(objectElement, false)
							setObjectScale(objectElement, 1.2)

							exports.sm_boneattach:attachElementToBone(objectElement, source, 12, 0, 0.05, 0, 270, 0, 0)
							table.insert(carriedObjects[source], objectElement)
						end
					else
						local objectElement = createObject(2694, 0, 0, 0)
						if isElement(objectElement) then
							setElementCollisionsEnabled(objectElement, false)

							exports.sm_boneattach:attachElementToBone(objectElement, source, 12, 0.2, 0.1, 0.15, 0, 90, 70)
							table.insert(carriedObjects[source], objectElement)
						end
					end
				else
					local objectElement = createObject(1271, 0, 0, 0)
					if isElement(objectElement) then
						setElementCollisionsEnabled(objectElement, false)
						setObjectScale(objectElement, 0.9)

						exports.sm_boneattach:attachElementToBone(objectElement, source, 12, 0.25, 0.3, 0.15, -100, 0, -20)
						table.insert(carriedObjects[source], objectElement)
					end

					local objectElement = createObject(1550, 0, 0, 0)
					if isElement(objectElement) then
						setElementCollisionsEnabled(objectElement, false)
						setObjectScale(objectElement, 1)

						exports.sm_boneattach:attachElementToBone(objectElement, source, 3, 0, -0.3, 0, 0, 0, 180)
						table.insert(carriedObjects[source], objectElement)
					end
				end
			else
				if carriedObjects[source] then
					for i = 1, #carriedObjects[source] do
						local objectElement = carriedObjects[source][i]

						if isElement(objectElement) then
							destroyElement(objectElement)
						end
					end

					carriedObjects[source] = nil
				end
			end
		elseif dataName == "char.Job" or dataName == "jobVehicle" then
			if source == localPlayer then
				local characterJob = getElementData(localPlayer, "char.Job")
				local jobVehicle = getElementData(localPlayer, "jobVehicle")

				if characterJob ~= jobID or not jobVehicle then
					if deliveryPackages then
						if getElementData(localPlayer, "carryingMail") then
							exports.sm_controls:toggleControl({"jump", "aim_weapon", "fire", "enter_exit", "enter_passenger", "crouch"}, true)
						end

						for i = 1, #deliveryPackages do
							local datas = deliveryPackages[i]

							for j = 1, #datas do
								if isElement(datas[j]) then
									destroyElement(datas[j])
								end
							end
						end
					end

					endTheJob(true)

					local usingPostCar = getElementData(localPlayer, "usingPostCar")

					if isElement(usingPostCar) then
						setElementData(usingPostCar, "postCarInventory", false)
					end

					setElementData(localPlayer, "usingPostCar", false)
					setElementData(localPlayer, "carryingMail", false)
				end
			end
		end
	end
)