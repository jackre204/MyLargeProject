local screenX, screenY = guiGetScreenSize()
function reMap(value, low1, high1, low2, high2)
    return (value - low1) * (high2 - low2) / (high1 - low1) + low2
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(num)
    return num * responsiveMultipler
end

local availableAnswers = {}
local questionId = 0
local questionText = false
local correctAnswerId = false

function shuffleTable(array)
	for i = #array, 2, -1 do
		local j = math.random(i)
		array[i], array[j] = array[j], array[i]
	end
	
	return array
end

local quizMarker = false
local quizState = false
local quizStage = false

local correctAnswers = 0
local quizPercent = 0

local activeButton = false
local Roboto = false

local drivingTest = {
	markerElement = false,
	markerId = 1
}
local testVehicle = false
local pedTalkTimer = false

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		quizMarker = createMarker(2352.5634765625, -1485.1312255859, 24-1.5, "cylinder", 2, 50, 179, 239, 160)
		
		if isElement(quizMarker) then
			setElementInterior(quizMarker, 0)
			setElementDimension(quizMarker, 0)
		end
	end)

addEventHandler("onClientMarkerHit", getResourceRootElement(),
	function (hitPlayer, matchingDimension)
		if hitPlayer == localPlayer and matchingDimension then
			if source == quizMarker then
				if not quizState then
					local carlicense = getElementData(localPlayer, "license.car") or 0

					createFonts()

					if carlicense then
						if carlicense == 0 then
							questionId = 0
							quizState = true
							quizStage = "startQuiz"
							correctAnswers = 0
							quizPercent = 0
						elseif carlicense == 1 then
							quizState = true
							quizStage = "drivingTest"
						end
					end
				end
			elseif source == drivingTest.startMarker then
				destroyElement(drivingTest.startMarker)
				triggerServerEvent("createLicenseVehicle", localPlayer)
			elseif source == drivingTest.markerElement then
				local pedveh = getPedOccupiedVehicle(localPlayer)

				if pedveh and pedveh == testVehicle then
					destroyElement(drivingTest.markerElement)

					if isElement(drivingTest.blipElement) then
						destroyElement(drivingTest.blipElement)
					end

					drivingTest.markerId = drivingTest.markerId + 1

					if drivingTest.markerId <= #waypoints then
						drivingTest.markerElement = createMarker(waypoints[drivingTest.markerId][1], waypoints[drivingTest.markerId][2], waypoints[drivingTest.markerId][3] - 1, "cylinder", 4, 215, 89, 89, 160)
						
						if isElement(drivingTest.markerElement) then
							drivingTest.blipElement = createBlip(waypoints[drivingTest.markerId][1], waypoints[drivingTest.markerId][2], waypoints[drivingTest.markerId][3], 0, 2, 215, 89, 89, 255, 0, 99999)
						end
					else
						if getElementHealth(pedveh) < 600 then
							exports.sm_accounts:showInfo("e", "Megbuktál a vizsgán, mivel a járműved túlságosan sérült!")
						else
							exports.sm_accounts:showInfo("s", "Gratulálok, sikeresen letetted az autóvezetői vizsgát!")
							
							setElementData(localPlayer, "license.car", 0)
							triggerServerEvent("giveDocument", localPlayer, 68)
						end

						triggerServerEvent("destroyLicenseVehicle", localPlayer)
						testVehicle = false

						if isTimer(pedTalkTimer) then
							killTimer(pedTalkTimer)
						end
						pedTalkTimer = nil
					end
				end
			end
		end
	end)

addEventHandler("onClientMarkerLeave", getResourceRootElement(),
	function (leftPlayer, matchingDimension)
		if leftPlayer == localPlayer then
			if source == quizMarker then
				if quizState then
					quizState = false
					destroyFonts()
				end
			end
		end
	end)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if testVehicle then
			checkSpeed()
		elseif quizState then
			local sx, sy = resp(430), resp(340)
			local x = screenX / 2 - sx / 2
			local y = screenY / 2 - sy / 2
			local buttons = {}

			-- ** Háttér
			dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))
			dxDrawRectangle(x+resp(4), y+resp(4), sx-resp(8), resp(35), tocolor(35, 35, 35))
			drawText("#3d7abcStrong#c8c8c8MTA", x+resp(14), y+resp(4), sx-resp(8), resp(35), tocolor(200, 200, 200, 200), 1, Roboto, true)
			dxDrawImage(x, y+resp(4), resp(35), resp(35), exports.sm_core:getServerLogo())
			if quizStage == "startQuiz" then
				dxDrawText("#3d7abc 1. Elméleti vizsga\n#c8c8c8A vizsga díja: #3d7abc250$#c8c8c8\n #3d7abc2. Gyakorlati vizsga\n#c8c8c8A vizsga díja: #3d7abc1100$#c8c8c8\n\nAz elméleti vizsgán #3d7abc14 kérdést #c8c8c8fogsz kapni,\namiből legalább #3d7abc80%-ára helyesen #c8c8c8kell válaszolnod.\n\nAmennyiben készen állsz az elméleti vizsgára,\nnyomj a #3d7abc\"Kezdés\" #c8c8c8gombra.", x, y+resp(10), x + sx, y + sy - resp(40)+resp(10), tocolor(200, 200, 200, 200), 0.85, Roboto, "center", "center", false, false, false, true)
			
				-- Mégsem
				local buttonWidth = (sx - resp(30)) / 2
				local buttonHeight = resp(35)

				buttons["decline"] = {x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight}
				if activeButton == "decline" then
					exports.sm_hud:dxDrawRoundedRectangle(x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(215, 89, 89, 200))
				else
					exports.sm_hud:dxDrawRoundedRectangle(x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(215, 89, 89, 150))
				end
				dxDrawText("Mégsem", x + resp(10), y + sy - resp(10) - buttonHeight, x + resp(10) + buttonWidth, y + sy - resp(10), tocolor(200, 200, 200, 200), 0.8, Roboto, "center", "center")

				-- Kezdés
				buttons["accept"] = {x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight}
				if activeButton == "accept" then
					exports.sm_hud:dxDrawRoundedRectangle(x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(61, 122, 188, 200))
				else
					exports.sm_hud:dxDrawRoundedRectangle(x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(61, 122, 188, 150))
				end
				dxDrawText("Kezdés", x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, x + sx - resp(10), y + sy - resp(10), tocolor(200, 200, 200, 200), 0.8, Roboto, "center", "center")
			elseif quizStage == "quiz" then
				local buttonWidth = sx - resp(20)
				local buttonHeight = resp(35)
                 if questionText == "Mekkora lehet a legnagyobb sebessége a személygépkocsinak az autópályán egy ilyen táblakombináció hatálya alatt?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(250), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(250)-resp(8), resp(300), "files/4.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                 elseif questionText == "Mekkora lehet a legnagyobb sebessége személygépkocsinak az autópályán egy ilyen táblakombináció hatálya alatt?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(250), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(250)-resp(8), resp(300), "files/5.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                elseif questionText == "Megelőzheti-e az ábrázolt helyen és módon a motorkerékpáros a gépkocsit?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(400), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(400)-resp(8), resp(300), "files/6.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                elseif questionText == "Meddig tart a képen látható táblával jelzett sebességkorlátozás?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(250), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(250)-resp(8), resp(300), "files/7.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                elseif questionText == "Mit jelez a tábla?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(170), resp(170)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(170)-resp(8), resp(170), "files/8.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                elseif questionText == "Szabályos- e ez a megfordulás az ábrázolt pályavonal szerint?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(400), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(400)-resp(8), resp(300), "files/9.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                elseif questionText == "Mikor haladhat át kormánykerékkel ábrázolt gépkocsijával az ábrán látható útkereszteződésben?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(400), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(400)-resp(8), resp(300), "files/10.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                elseif questionText == "Ki haladhat tovább elsőként?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(400), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(400)-resp(8), resp(300), "files/11.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                elseif questionText == "Szabályos-e az ábrázolt párhuzamos közlekedésre alkalmas úttesten, ha az A jelű mezőgazdasági vontató a berajzolt pályavonal szerint, a belső forgalmi sávban folyamatosan halad?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(400), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(400)-resp(8), resp(300), "files/12.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                elseif questionText == "Melyik jármű haladhat tovább elsőként?" then
                    dxDrawRectangle(x+sx+resp(4), y, resp(400), resp(300)+resp(8), tocolor(25, 25, 25))
                    dxDrawImage(x+sx+resp(8), y+resp(4), resp(400)-resp(8), resp(300), "files/13.jpg", 0, 0, 0, tocolor(200, 200, 200, 200))
                 end
                 dxDrawText(questionText, x + resp(10), y+resp(10), x + sx - resp(20), y+resp(10) + sy - buttonHeight * 4 - resp(10) * 4, tocolor(200, 200, 200, 200), 0.9, Roboto, "center", "center", false, true)
				for i = 1, 4 do
					local buttY = y + sy - (buttonHeight + 10) * i

					buttons["quiz" .. i] = {x + resp(10), buttY, buttonWidth, buttonHeight}
					if activeButton == "quiz" .. i then
						exports.sm_hud:dxDrawRoundedRectangle(x + resp(10), buttY, buttonWidth, buttonHeight, tocolor(61, 122, 188, 200))
					else
						exports.sm_hud:dxDrawRoundedRectangle(x + resp(10), buttY, buttonWidth, buttonHeight, tocolor(61, 122, 188, 150))
					end
					dxDrawText(availableAnswers[i], x + resp(10), buttY, x + resp(10) + buttonWidth, buttY + buttonHeight, tocolor(200, 200, 200, 200), 0.7, Roboto, "center", "center")
				end
			elseif quizStage == "quizEnd" then
				if quizPercent < 80 then
					dxDrawText("Sajnos elrontottad a tesztet!\nMinimum 80%-ot kell elérned legközelebb\nEredményed: #3d7abc" .. quizPercent .. "%#c8c8c8\nAz újra gombra kattintva újra kezdheted a\ntesztet.\n\nEnnek díja további 120$.", x + resp(10), y + resp(15), x + sx - resp(20), y + sy - resp(30), tocolor(200, 200, 200, 200), 1, Roboto, "center", "center", false, true, false, true)
				else
					dxDrawText("Sikeresen kitöltötted a tesztet!\nEredményed: #3d7abc" .. quizPercent .. "%#c8c8c8\nA tovább gombra kattintva elkezdheted a\ngyakorlati vizsgát.", x + resp(10), y + resp(15), x + sx - resp(20), y + sy - resp(30), tocolor(200, 200, 200, 200), 1, Roboto, "center", "center", false, true, false, true)
				end

				local buttonWidth = (sx - resp(30)) / 2
				local buttonHeight = resp(35)

				buttons["cancel"] = {x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight}
				if activeButton == "cancel" then
					exports.sm_hud:dxDrawRoundedRectangle(x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(215, 89, 89, 200))
				else
					exports.sm_hud:dxDrawRoundedRectangle(x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(215, 89, 89, 150))
				end
				dxDrawText("Megszakítás", x + resp(10), y + sy - resp(10) - buttonHeight, x + resp(10) + buttonWidth, y + sy - resp(10), tocolor(200, 200, 200, 200), 0.8, Roboto, "center", "center")

				-- Kezdés
				buttons["ok"] = {x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight}
				if activeButton == "ok" then
					exports.sm_hud:dxDrawRoundedRectangle(x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(61, 122, 188, 200))
				else
					exports.sm_hud:dxDrawRoundedRectangle(x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(61, 122, 188, 150))
				end
				if quizPercent < 80 then
					dxDrawText("Újra (120$)", x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, x + sx - resp(10), y + sy - resp(10), tocolor(200, 200, 200, 200), 0.8, Roboto, "center", "center")
				else
					dxDrawText("Tovább", x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, x + sx - resp(10), y + sy - resp(10), tocolor(200, 200, 200, 200), 0.8, Roboto, "center", "center")
				end
			elseif quizStage == "drivingTest" then
				dxDrawText("Mivel már rendelkezel egy #3d7abcsikeres\nKRESZ vizsgával #c8c8c8ezért a #3d7abc\"Kezdés\"\n#c8c8c8gombra kattintva azonnal elkezdheted\na #3d7abcgyakorlati vizsgát,\n#c8c8c8melynek díja #3d7abc1100$.", x + resp(10), y + resp(15), x + sx - resp(20), y + sy - resp(30), tocolor(200, 200, 200, 200), 1, Roboto, "center", "center", false, true, false, true)
				
				local buttonWidth = (sx - resp(30)) / 2
				local buttonHeight = resp(35)

				buttons["cancel"] = {x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight}
				if activeButton == "cancel" then
					exports.sm_hud:dxDrawRoundedRectangle(x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(215, 89, 89, 200))
				else
					exports.sm_hud:dxDrawRoundedRectangle(x + resp(10), y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(215, 89, 89, 150))
				end
				dxDrawText("Kilépés", x + resp(10), y + sy - resp(10) - buttonHeight, x + resp(10) + buttonWidth, y + sy - resp(10), tocolor(200, 200, 200, 200), 0.8, Roboto, "center", "center")

				-- Kezdés
				buttons["ok"] = {x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight}
				if activeButton == "ok" then
					exports.sm_hud:dxDrawRoundedRectangle(x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(61, 122, 188, 200))
				else
					exports.sm_hud:dxDrawRoundedRectangle(x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, buttonWidth, buttonHeight, tocolor(61, 122, 188, 150))
				end
				dxDrawText("Kezdés", x + sx - resp(10) - buttonWidth, y + sy - resp(10) - buttonHeight, x + sx - resp(10), y + sy - (10), tocolor(200, 200, 200, 200), 0.8, Roboto, "center", "center")
			end

			local cx, cy = getCursorPosition()

			if tonumber(cx) then
				cx = cx * screenX
				cy = cy * screenY

				activeButton = false

				for k, v in pairs(buttons) do
					if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
						activeButton = k
						break
					end
				end
			else
				activeButton = false
			end
		end
	end)

local checkProcess = false

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if quizState then
			if not checkProcess then
				if button == "left" then
					if state == "up" then
						if activeButton then
							if quizStage == "startQuiz" then
								if activeButton == "accept" then
									triggerServerEvent("checkQuizTest", localPlayer)
									checkProcess = true
								elseif activeButton == "decline" then
									quizState = false
									destroyFonts()
								end
							elseif quizStage == "quiz" then
								if string.find(activeButton, "quiz") then
									local selected = string.gsub(activeButton, "quiz", "")
									local answerId = tonumber(selected)

									if correctAnswerId == availableAnswers[answerId] then
										correctAnswers = correctAnswers + 1
									end

									if questionId < #quizTable then
										pickQuizQuestion()
									else
										quizPercent = math.floor(correctAnswers / #quizTable * 100)
										
										if quizPercent >= 80 then
											exports.sm_accounts:showInfo("s", "Sikeresen teljesítetted az elméleti tesztet. Most következzen a gyakorlati rész.")
											setElementData(localPlayer, "license.car", 1)
										else
											exports.sm_accounts:showInfo("e", "Elrontottad a tesztet! Minimum 80%-ot kellet volna elérned!")
										end

										quizStage = "quizEnd"
									end
								end
							elseif quizStage == "quizEnd" then
								if activeButton == "ok" then
									if quizPercent < 80 then
										questionId = 0
										quizState = true
										correctAnswers = 0
										quizPercent = 0
										quizTable = shuffleTable(quizTable)
										pickQuizQuestion()
										quizStage = "quiz"
									else
										if getElementData(localPlayer, "license.car") == 1 then
											triggerServerEvent("checkDrivingTest", localPlayer)
											checkProcess = true
										end
									end
								elseif activeButton == "cancel" then
									quizState = false
									destroyFonts()
								end
							elseif quizStage == "drivingTest" then
								if activeButton == "ok" then
									if getElementData(localPlayer, "license.car") == 1 then
										triggerServerEvent("checkDrivingTest", localPlayer)
										checkProcess = true
									end
								elseif activeButton == "cancel" then
									quizState = false
									destroyFonts()
								end
							end
						end
					end
				end
			end
		end
	end)

addEvent("checkQuizTest", true)
addEventHandler("checkQuizTest", getRootElement(),
	function (result)
		if result == "Y" then
			quizTable = shuffleTable(quizTable)
			pickQuizQuestion()
			quizStage = "quiz"
		end

		checkProcess = false
	end)

addEvent("checkDrivingTest", true)
addEventHandler("checkDrivingTest", getRootElement(),
	function (result)
		if result == "Y" then
			quizState = false
			destroyFonts()
			startDrivingTest()
		end

		checkProcess = false
	end)

addEvent("startDrivingTest", true)
addEventHandler("startDrivingTest", getRootElement(),
	function (vehicleElement)
		if isTimer(pedTalkTimer) then
			killTimer(pedTalkTimer)
		end

		testVehicle = vehicleElement

		setVehicleEngineState(testVehicle, true)

		outputChatBox("#3d7abc* Oktató: #c8c8c8Ha készen állsz, akkor indulhatunk!", 255, 255, 255, true)
		outputChatBox("#3d7abc* Oktató: #c8c8c8De azért a kéziféket ne felejtsük el kiengedni!", 255, 255, 255, true)
		outputChatBox("#3d7abc(( ALT lenyomva, és az egeret előretolni a zöld mezőbe ))", 255, 255, 255, true)

		pedTalkTimer = setTimer(
			function ()
				if testVehicle then
					local pedveh = getPedOccupiedVehicle(localPlayer)

					if isElement(pedveh) and testVehicle == pedveh then
						outputChatBox("#3d7abc* Oktató: #c8c8c8" .. instructions[math.random(1, #instructions)], 255, 255, 255, true)
					end
				end
			end,
		30000, 0)

		drivingTest.overSpeed = 0
		drivingTest.noSeatbelt = 0
		drivingTest.markerElement = createMarker(waypoints[1][1], waypoints[1][2], waypoints[1][3] - 1, "cylinder", 4, 215, 89, 89, 160)
		drivingTest.markerId = 1

		if isElement(drivingTest.markerElement) then
			drivingTest.blipElement = createBlip(waypoints[1][1], waypoints[1][2], waypoints[1][3], 0, 2, 255, 0, 0, 255, 0, 99999)
		end
	end)

addEvent("destroyLicenseVehicle", true)
addEventHandler("destroyLicenseVehicle", getRootElement(),
	function ()
		testVehicle = false

		if isElement(drivingTest.markerElement) then
			destroyElement(drivingTest.markerElement)
		end

		if isElement(drivingTest.blipElement) then
			destroyElement(drivingTest.blipElement)
		end

		if isTimer(pedTalkTimer) then
			killTimer(pedTalkTimer)
		end
		pedTalkTimer = nil

		exports.sm_accounts:showInfo("e", "Megbuktál a vizsgán!")
	end)

local seatBeltState = false

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName)
		if dataName == "player.seatBelt" then
			seatBeltState = getElementData(localPlayer, "player.seatBelt")
		end
	end)

function startDrivingTest()
	if not isElement(drivingTest.startMarker) then
		drivingTest.startMarker = createMarker(2365.9079589844, -1474.1995849609, 23.826776504517-2, "cylinder", 3, 50, 179, 239, 160)

		if isElement(drivingTest.startMarker) then
			outputChatBox("#3d7abc[StrongMTA]: #c8c8c8A vizsga megkezdéséhez menj bele az épület előtt található #3d7abcmarkerbe#c8c8c8.", 255, 255, 255, true)
		end
	end
end

function checkSpeed()
	local pedveh = getPedOccupiedVehicle(localPlayer)

	if isElement(pedveh) then
		if pedveh == testVehicle then
			local velx, vely, velz = getElementVelocity(pedveh)
			local actualspeed = math.sqrt(velx*velx + vely*vely + velz*velz) * 187.5

			if actualspeed > 70 then
				if not isTimer(speedTimer) then
					speedTimer = setTimer(
						function ()
							local pedveh = getPedOccupiedVehicle(localPlayer)

							if isElement(pedveh) then
								if pedveh == testVehicle then
									local velx, vely, velz = getElementVelocity(pedveh)
									local actualspeed = math.sqrt(velx*velx + vely*vely + velz*velz) * 187.5

									if actualspeed > 70 then
										if drivingTest.overSpeed + 1 == 3 then
											if isElement(drivingTest.markerElement) then
												destroyElement(drivingTest.markerElement)
											end

											if isElement(drivingTest.blipElement) then
												destroyElement(drivingTest.blipElement)
											end

											if isTimer(pedTalkTimer) then
												killTimer(pedTalkTimer)
											end

											testVehicle = false
											triggerServerEvent("destroyLicenseVehicle", localPlayer)

											exports.sm_accounts:showInfo("e", "Megbuktál, mert túl sokszor lépted át a megengedett sebességhatárt!")
										else
											exports.sm_accounts:showInfo("e", "Túl gyorsan hajtasz (70km/h)! Ha így folytatod, akkor meg fogsz bukni!")
										end

										drivingTest.overSpeed = drivingTest.overSpeed + 1
									end
								end
							end
						end,
					5000, 1)

					outputChatBox("#3d7abc* Oktató: #c8c8c8Haver azt akarod, hogy megbuktassalak? LASSÍTS! Tartsd be a sebességet.", 255, 255, 255, true)
				end
			end
		end
	end

	if isElement(pedveh) then
		if pedveh == testVehicle then
			if not seatBeltState then
				if not isTimer(noSeatbeltTimer) then
					noSeatbeltTimer = setTimer(
						function ()
							local pedveh = getPedOccupiedVehicle(localPlayer)

							if isElement(pedveh) then
								if pedveh == testVehicle then
									if not drivingTest then
										if drivingTest.noSeatbelt + 1 == 4 then
											if isElement(drivingTest.markerElement) then
												destroyElement(drivingTest.markerElement)
											end

											if isElement(drivingTest.blipElement) then
												destroyElement(drivingTest.blipElement)
											end

											if isTimer(pedTalkTimer) then
												killTimer(pedTalkTimer)
											end

											testVehicle = false
											triggerServerEvent("destroyLicenseVehicle", localPlayer)

											exports.sm_accounts:showInfo("e", "Megbuktál, mert nem volt bekötve az öved!")
										else
											exports.sm_accounts:showInfo("e", "Nincs bekötve az öved! Ha így folytatod, akkor meg fogsz bukni!")
										end

										drivingTest.noSeatbelt = drivingTest.noSeatbelt + 1
									end
								end
							end
						end,
					15000, 1)

					outputChatBox("#3d7abc* Oktató: #c8c8c8Haver azt akarod, hogy megbuktassalak? Kösd be az övedet! ((F5))", 255, 255, 255, true)
				end
			end
		end
	end
end

function pickQuizQuestion()
	questionId = questionId + 1
	questionText = quizTable[questionId][1]
	correctAnswerId = quizTable[questionId][quizTable[questionId][6] + 1]
	availableAnswers = {}

	outputDebugString("válasz: " .. correctAnswerId)

	local answerIds = shuffleTable({1, 2, 3, 4})

	for i = 1, 4 do
		availableAnswers[i] = quizTable[questionId][1 + answerIds[i]]
	end
end

function createFonts()
	destroyFonts()
	Roboto = dxCreateFont("files/Roboto.ttf", resp(14), false, "antialiased")
end

function destroyFonts()
	if isElement(Roboto) then
		destroyElement(Roboto)
	end
	Roboto = nil
end

function drawText(text, x, y, w, h, color, size, font, left)
    if left then
        dxDrawText(text, x+20, y+h/2, x+20, y+h/2, color, size, font, "left", "center", false, false, false, true)
    else
        dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, size, font, "center", "center", false, false, false, true)
    end
end