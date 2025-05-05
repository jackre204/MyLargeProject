local screenWidth, screenHeight = guiGetScreenSize()

local panelState = false
local panelWidth = 800
local panelHeight = 660
local panelPosX = (screenWidth - panelWidth) / 2
local panelPosY = (screenHeight - panelHeight) / 2

local symbolWidth = 115
local symbolHeight = 115
local symbolPosX = panelPosX + 102
local symbolPosY = panelPosY + 187

local activeButton = false
local buttons = {}

local fontContainer = {}
local soundContainer = {}

local currentBalance = 0
local statusText = ""

local betPerLines = {5, 10, 20, 40, 80, 160, 320}
local betPerLineTableCounter = 1

local soundsEnabled = true
local payTableOpened = false

local linesInUse = {
	[1] = true,
	[2] = false,
	[3] = false,
	[4] = false,
	[5] = false,
	[6] = false,
	[7] = false,
	[8] = false,
	[9] = false,
	[10] = false,
}

local linePaths = {
	[1] = {
		{0, 0, 0, 0, 0},
		{1, 1, 1, 1, 1},
		{0, 0, 0, 0, 0}
	},
	[2] = {
		{1, 1, 1, 1, 1},
		{0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0}
	},
	[3] = {
		{0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0},
		{1, 1, 1, 1, 1}
	},
	[4] = {
		{1, 0, 0, 0, 1},
		{0, 1, 0, 1, 0},
		{0, 0, 1, 0, 0}
	},
	[5] = {
		{0, 0, 1, 0, 0},
		{0, 1, 0, 1, 0},
		{1, 0, 0, 0, 1}
	},
	[6] = {
		{1, 1, 0, 0, 0},
		{0, 0, 1, 0, 0},
		{0, 0, 0, 1, 1}
	},
	[7] = {
		{0, 0, 0, 0, 0},
		{1, 0, 0, 0, 1},
		{0, 1, 1, 1, 0}
	},
	[8] = {
		{0, 1, 1, 1, 0},
		{1, 0, 0, 0, 1},
		{0, 0, 0, 0, 0}
	},
	[9] = {
		{0, 0, 0, 1, 1},
		{0, 0, 1, 0, 0},
		{1, 1, 0, 0, 0}
	},
	[10] = {
		{0, 0, 0, 0, 1},
		{0, 1, 1, 1, 0},
		{1, 0, 0, 0, 0}
	}
}

local betLineClickTime = 0
local betLineDisplayDuration = 3000

function calculatePath()
	local lineSlots = {}

	for lineIndex = 1, #linePaths do
		if linePaths[lineIndex] then
			lineSlots[lineIndex] = {}

			for columnIndex = 1, 5 do
				for rowIndex = 1, 3 do
					if linePaths[lineIndex][rowIndex][columnIndex] == 1 then
						table.insert(lineSlots[lineIndex], {columnIndex, rowIndex})
						break
					end
				end
			end
		end
	end

	return lineSlots
end

local symbolNames = {"10", "a", "bobe", "car", "desert", "faszi", "j", "k", "money", "q"}

local symbolWeights = {
	["10"] = 16,
	["a"] = 16,
	["bobe"] = 8,
	["car"] = 4,
	["desert"] = 8,
	["faszi"] = 1,
	["j"] = 16,
	["k"] = 16,
	["money"] = 4,
	["q"] = 16,
}

local symbolChances = {
	["10"] = 40,
	["a"] = 35,
	["bobe"] = 20,
	["car"] = 10,
	["desert"] = 20,
	["faszi"] = 5,
	["j"] = 40,
	["k"] = 35,
	["money"] = 10,
	["q"] = 40,
}

function generateSymbols()
	local weightedTable = {}

	for symbol, weight in pairs(symbolWeights) do
		for i = 1, weight do
			table.insert(weightedTable, symbol)
		end
	end

	return weightedTable
end

local lineWayPoints = calculatePath()
local weightedSymbols = generateSymbols()

local freePlayMode = false
local freePlayRoundCount = 0
local allFreePlayRounds = 10
local freePlaySymbol = ""
local freePlayRandomizerSpinning = false
local freePlayWon = false

local freePlaySymbolChance = 10
local scatterSymbolChance = 10

local columnSymbols = {}
local columnProgress = {}
local columnRollStart = 0
local symbolPerColumn = 20

local resultTable = {}
local totalWinOverall = 0
local canCollectReward = false

local specialColumns = {
	[1] = true,
	[3] = true,
	[5] = true
}

local waitingTimes = {
	["enterWait"] = 3000,
	["roll"] = 1000,
	["columnStop"] = symbolPerColumn * 50,
	["showLineReward"] = 700,
	["freePlaySymbolSelection_1"] = 5000,
	["freePlaySymbolSelection_2"] = 3000,
}

function execute(func, ...)
	local thread = coroutine.create(func)
	coroutine.resume(thread, ...)
end

function sleep(interval)
	local thread = coroutine.running()
	setTimer(
		function ()
			coroutine.resume(thread)
		end,
	interval, 1)
	coroutine.yield()
end

local waitingForButton = false
local waitingThread = false

function waitForButton(buttonName)
	waitingThread = coroutine.running()
	waitingForButton = buttonName
	coroutine.yield()
end

function triggerButton(buttonName)
	if waitingForButton == buttonName then
		if waitingThread then
			coroutine.resume(waitingThread)
			waitingForButton = false
			waitingThread = false
		end
	end
end

local gameStage = "none"
local currentLineRender = 0
local columnSoundPlayed = {}

function manageRoll()
	gameStage = "roll"
	columnSoundPlayed = {}

	-- Ha szabadjáték mód, számoljuk lefelé a köröket
	if freePlayMode then
		if freePlayRoundCount >= 1 then
			freePlayRoundCount = freePlayRoundCount - 1
		end
	end

	-- Generáljuk le a végleges lootot
	local finalResult = generateResult()

	-- Indítsuk el a slotok pörgetésének animálását
	performRoll(finalResult)

	-- Frissítsük a jelenlegi állapotot
	if freePlayMode then
		statusText = "Pörgetés... (Hátralévõ szabadjátékok: " .. allFreePlayRounds - freePlayRoundCount .. "/" .. allFreePlayRounds .. ")"
	else
		statusText = "Pörgetés..."
	end

	-- Várjunk amíg az összes slot animálása befejeződik
	sleep(2 * waitingTimes["roll"] + 5 * waitingTimes["columnStop"])

	-- Az animálásnak vége, állítsuk a slotokat a végső állapotba (biztos ami biztos)
	for i = 1, 5 do
		columnProgress[i] = 100
	end

	-- Értékeljük ki a jelenlegi szimbólumokat
	resultTable, scatterCount, freePlaySymbolCount, freePlaySymbolColumns, rewardAmount = evaluateResult(columnSymbols, "normal")

	-- Mutassuk meg egyesével a nyerő sorokat
	local totalWin = 0

	gameStage = "showRewards"

	if #resultTable > 0 then
		local activeLineBet = getActiveLineBet()

		for i = 1, #resultTable do
			local lineNumber = resultTable[i][1]
			local lineReward = resultTable[i][4]

			currentLineRender = i

			if freePlayMode then
				statusText = lineNumber .. ". sor nyereménye: " .. thousandsStepper(lineReward * 3)
			else
				statusText = lineNumber .. ". sor nyereménye: " .. thousandsStepper(lineReward)
			end

			-- Ha a vonalon lévő összeg nagyobb mint a szorzat akkor
			if lineReward >= activeLineBet * 800 then
				playSoundEx("files/sounds/bigwinnew.mp3")
				sleep(5500)
			elseif lineReward >= activeLineBet * 200 then
				playSoundEx("files/sounds/mediumwin.mp3")
				sleep(1500)
			elseif lineReward >= activeLineBet * 25 then
				playSoundEx("files/sounds/linewinmedium.mp3")
				sleep(1000)
			else
				playSoundEx("files/sounds/smalllinewin.mp3")
				sleep(1000)
			end
		end

		-- Nyeremények összeadása
		if freePlayMode then
			totalWinOverall = totalWinOverall + rewardAmount * 3
			totalWin = totalWin + rewardAmount * 3
		else
			totalWinOverall = totalWinOverall + rewardAmount
			totalWin = totalWin + rewardAmount
		end

		-- Engedélyezzük a nyeremény begyűjtését
		canCollectReward = true
	end

	-- Ha találunk legalább 3 scattert, indítjuk a szabadjátékot
	local freePlayStarting = false

	if scatterCount >= 3 then
		-- Ha jelenleg nem szabadjáték van, elindítjuk
		if not freePlayMode then
			gameStage = "freePlay_2"
			freePlayStarting = true
		-- Ellenkező esetben, nyerünk 15 szabadjátékot
		else
			freePlayRoundCount = freePlayRoundCount + 15
			allFreePlayRounds = allFreePlayRounds + 15

			sleep(1000)
			-- resultTable, scatterCount, freePlaySymbolCount, freePlaySymbolColumns, rewardAmount = evaluateResult(columnSymbols, "freePlay")
		end
	end

	-- Ha szabadjáték módban találtunk legalább 3 szabadjáték szimbólumot, elindul az oszlopkitöltés
	-- if freePlayMode then
	-- 	if freePlaySymbolCount >= 3 then
	-- 		currentLineRender = 0

	-- 		-- Kitöltjük az oszlopokat
	-- 		for i = 1, 5 do
	-- 			if freePlaySymbolColumns[i] then
	-- 				columnSymbols[i][#columnSymbols[i]] = freePlaySymbol
	-- 				columnSymbols[i][#columnSymbols[i] - 1] = freePlaySymbol
	-- 				columnSymbols[i][#columnSymbols[i] - 2] = freePlaySymbol

	-- 				playSoundEx("files/sounds/fulled.mp3")
	-- 				sleep(500)
	-- 			end
	-- 		end

	-- 		-- Összeszedjük a nyereményeket
	-- 		local freePlaySymbolReward = payTable[freePlaySymbol][betPerLineTableCounter][freePlaySymbolCount]

	-- 		resultTable = {}

	-- 		for selectedLine = 1, getActiveLines() do
	-- 			local winnerSlots = {}

	-- 			for columnIndex = 1, 5 do
	-- 				if freePlaySymbolColumns[columnIndex] then
	-- 					table.insert(winnerSlots, {lineWayPoints[selectedLine][columnIndex][1], lineWayPoints[selectedLine][columnIndex][2]})
	-- 				end
	-- 			end

	-- 			table.insert(resultTable, {selectedLine, freePlaySymbol, winnerSlots, freePlaySymbolReward, waitingTimes["showLineReward"]})
	-- 		end

	-- 		-- Megmutatjuk a nyertes sorokat egyesével
	-- 		if #resultTable > 0 then
	-- 			for i = 1, #resultTable do
	-- 				local lineNumber = resultTable[i][1]
	-- 				local lineReward = resultTable[i][4]

	-- 				currentLineRender = i
	-- 				statusText = lineNumber .. ". sor nyereménye: " .. thousandsStepper(lineReward)

	-- 				totalWinOverall = totalWinOverall + lineReward
	-- 				totalWin = totalWin + lineReward

	-- 				playSoundEx("files/sounds/freeplaytick.mp3")
	-- 				sleep(resultTable[i][5])
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- Státusz beállítása
	if totalWin > 0 then
		if freePlayStarting then
			statusText = "Össznyeremény: " .. thousandsStepper(totalWinOverall) .. " (+Szabadjáték)"
		else
			statusText = "Össznyeremény: " .. thousandsStepper(totalWinOverall)
		end
	elseif freePlayStarting then
		statusText = "Szabadjátékot nyertél"
	else
		statusText = "Ebben a körben sajnos nem nyertél semmit."
	end

	gameStage = "none"

	-- Ha indul szabadjáték
	if freePlayStarting then
		-- Megjelenítjük a freeplay nyerő ablakot
		gameStage = "freePlay_2"

		freePlayWon = true
		freePlayRandomizerSpinning = true -- a randomizáló pörög
		canCollectReward = false -- nyeremény begyűjtését letiltjuk

		-- Leállítjuk a fő háttérzenét, ha nincs kikapcsolva
		if soundsEnabled then
			setSoundPaused(soundContainer["background"], true)
		end

		-- Lejátszuk a freeplay nyerő hangot
		soundContainer["freePlayWon"] = playSoundEx("files/sounds/freeplaywon.mp3")

		-- Felfüggesztjük a kód lefutását addig, amíg rá nem kattintunk a pörgetés gombra
		waitForButton("spin")

		-- Leállítjuk az előzőleg elindított hangot, ha gyorsabban kattintottunk volna a gombra
		if isElement(soundContainer["freePlayWon"]) then
			destroyElement(soundContainer["freePlayWon"])
		end

		-- Megjelenítjük a szimbólum randomizáló ablakot
		-- gameStage = "freePlay_1"
		freePlayMode = true
		freePlayRoundCount = 15
		allFreePlayRounds = 15

		-- Elindítjuk a szimbólum randomizálását
		-- soundContainer["selectFreePlaySymbol"] = playSoundEx("files/sounds/gamblekartyaperges.mp3")

		-- for i = 1, math.ceil(waitingTimes["freePlaySymbolSelection_1"] / 100) do
		-- 	freePlaySymbol = symbolNames[math.random(1, #symbolNames)]
		-- 	sleep(100)
		-- end

		-- if isElement(soundContainer["selectFreePlaySymbol"]) then
		-- 	destroyElement(soundContainer["selectFreePlaySymbol"])
		-- end

		-- Ha befejezte a randomizálást, indítjuk a szabadjátékot
		-- sleep(waitingTimes["freePlaySymbolSelection_1"])
		freePlayRandomizerSpinning = false

		-- Elindítjuk a szabadjáték háttérzenéjét
		soundContainer["freePlayBackground"] = playSoundEx("files/sounds/freegame.mp3", true)

		if soundContainer["freePlayBackground"] then
			setSoundVolume(soundContainer["freePlayBackground"], 0.5)
		end

		-- Pörgetjük a slotokat
		execute(manageRoll)

		return
	end

	-- Ha jelenleg szabadjáték mód pörög
	if freePlayMode then
		-- Ha van még hátra szabadjáték, indítjuk a következő kört
		if freePlayRoundCount >= 1 then
			sleep(1000)
			execute(manageRoll)
		-- Ellenkező esetben leállítjuk, és megmutatjuk a szabadjáték eredményeit
		else
			gameStage = "freePlay_result"

			-- Leállítjuk a szabadjáték háttérzenéjét
			if isElement(soundContainer["freePlayBackground"]) then
				destroyElement(soundContainer["freePlayBackground"])
			end

			-- Lejátszuk a szabadjáték vége hangot
			soundContainer["freePlayOver"] = playSoundEx("files/sounds/freeplayover.mp3")

			-- Felfüggesztjük a kód lefutását egy kis ideig
			sleep(6000)

			-- Leállítjuk az előzőleg elindított hangot
			if isElement(soundContainer["freePlayOver"]) then
				destroyElement(soundContainer["freePlayOver"])
			end

			-- Elindítjuk a fő háttérzenét, ha nincs kikapcsolva
			if soundsEnabled then
				setSoundPaused(soundContainer["background"], false)
			end

			-- Engedélyezzük a nyeremény begyűjtését
			canCollectReward = true

			-- Kikapcsoljuk a szabadjáték módot
			freePlayWon = false
			freePlayMode = false
			freePlaySymbol = ""
			gameStage = "none"
		end
	end
end

function generateResult()
	local finalResult = {}
	local availableSymbols = weightedSymbols

	-- Ha szabadjáték mód van, akkor kiszedjük a szabadjáték szimbólumát a rendelkezésre álló szimbólumok közül
	if freePlayMode then
		availableSymbols = {}

		for i = 1, #weightedSymbols do
			if weightedSymbols[i] ~= freePlaySymbol then
				table.insert(availableSymbols, weightedSymbols[i])
			end
		end
	end

	-- Végigloopolunk az oszlopokon
	for i = 1, 5 do
		-- Berakjuk a jelenleg látható 3 sor szimbólumát az új táblába
		local finalRowSymbols = {}

		finalRowSymbols[1] = columnSymbols[i][#columnSymbols[i]]
		finalRowSymbols[2] = columnSymbols[i][#columnSymbols[i] - 1]
		finalRowSymbols[3] = columnSymbols[i][#columnSymbols[i] - 2]

		-- Legenerálunk adott mennyiségű szimbólumot az oszlopba
		local pickedRowSymbols = {}
		local currentRowIndex = 1

		for j = 1, symbolPerColumn + i * symbolPerColumn do
			-- Ha az aktuális sor a harmadik sor, akkor az előző sor az első, a következő sor pedig a második sor
			local prevRowIndex = 1
			local nextRowIndex = 2

			-- Ha az aktuális sor az első sor, akkor az előző sor a második, a következő sor pedig a harmadik sor
			if currentRowIndex == 1 then
				prevRowIndex = 2
				nextRowIndex = 3
			-- Ha az aktuális sor a második sor, akkor az előző sor az első, a következő sor pedig a harmadik sor
			elseif currentRowIndex == 2 then
				prevRowIndex = 1
				nextRowIndex = 3
			end

			-- Keresünk egy szimbólumot ami nem ugyan az mint a előző és a következő sorban választott
			local pickedSymbol = "none"

			repeat
				repeat
					pickedSymbol = availableSymbols[math.random(1, #availableSymbols)]
				until pickedSymbol ~= pickedRowSymbols[prevRowIndex]
			until pickedSymbol ~= pickedRowSymbols[nextRowIndex]

			pickedRowSymbols[currentRowIndex] = pickedSymbol

			-- Ha megvan a szimbólum, ugorjunk a következő sorra
			currentRowIndex = currentRowIndex + 1

			if currentRowIndex > 3 then
				currentRowIndex = 1
			end

			-- Hozzáadjuk az oszlop végső szimbólumaihoz
			table.insert(finalRowSymbols, pickedSymbol)
		end

		finalResult[i] = finalRowSymbols

		-- Ha az aktuális oszlop különleges, megpróbálunk scattert behelyezni
		if specialColumns[i] then
			local scatterChance = scatterSymbolChance

			-- Ha szabadjáték mód van, akkor azt a generálási esélyt használjuk
			if freePlayMode then
				scatterChance = freePlaySymbolChance
			end

			-- Ha megvan az esély a scatterre, berakjuk valamelyik utolsó három helyre
			if math.random(1, 100) <= scatterChance then
				finalResult[i][#finalResult[i] - math.random(0, 2)] = "scatter"
			end
		end

		-- Ha szabadjáték mód van, megpróbáljuk behelyezni szabadjáték szimbólumát az oszlopkitöltéshez
		-- if freePlayMode then
		-- 	if math.random(1, 100) <= symbolChances[freePlaySymbol] then
		-- 		finalResult[i][#finalResult[i] - math.random(0, 2)] = freePlaySymbol
		-- 	end
		-- end
	end

	return finalResult
end

function performRoll(finalResult)
	currentLineRender = 0
	canCollectReward = false
	columnRollStart = getTickCount()

	-- Végigloopolunk az oszlopokon
	for i = 1, 5 do
		-- Beállítjuk az oszlop új szimbólumait
		columnSymbols[i] = finalResult[i]
		-- Visszaállítjuk az oszlop animációjának állapotát
		columnProgress[i] = 0
	end
end

function evaluateResult(evaluationSymbols, evaluationType)
	-- Lekérjük a látható három sor szimbólumát
	local finalSymbols = {}

	for i = 1, 5 do
		finalSymbols[i] = {}
		finalSymbols[i][1] = evaluationSymbols[i][#evaluationSymbols[i]]
		finalSymbols[i][2] = evaluationSymbols[i][#evaluationSymbols[i] - 1]
		finalSymbols[i][3] = evaluationSymbols[i][#evaluationSymbols[i] - 2]
	end

	-- Összeszámoljuk a scattereket
	local scatterCount = 0

	-- Végigloopolunk az oszlopokon
	for i = 1, 5 do
		-- Végigloopolunk a sorokon
		for j = 1, 3 do
			if finalSymbols[i][j] == "scatter" then
				scatterCount = scatterCount + 1
				break
			end
		end
	end

	-- Összeszámoljuk a szabadjáték szimbólumokat, és megkeressük azok oszlopait
	local freePlaySymbolColumns = {}
	local freePlaySymbolCount = 0

	if freePlayMode then
		-- Végigloopolunk az oszlopokon
		for i = 1, 5 do
			freePlaySymbolColumns[i] = false

			-- Végigloopolunk a sorokon
			for j = 1, 3 do
				if finalSymbols[i][j] == freePlaySymbol then
					freePlaySymbolColumns[i] = true
					freePlaySymbolCount = freePlaySymbolCount + 1
					break
				end
			end
		end
	end

	-- Kiértékeljük a megtett vonalakat
	local resultTable = {}

	if evaluationType == "normal" then
		-- Végig loopolunk az összes kiválasztott vonalon
		for selectedLine = 1, getActiveLines() do
			local currentWayPoint = lineWayPoints[selectedLine]

			if currentWayPoint then
				local lastValidItem = false
				local numOfPoints = #currentWayPoint

				-- Végig loopolunk az útvonalon
				for loopIndex = 1, numOfPoints + 1 do
					-- Az első 5 érvényes oszlop
					if loopIndex <= numOfPoints then
						local currentLine = currentWayPoint[loopIndex]

						if currentLine then
							local currentItem = finalSymbols[currentLine[1]][currentLine[2]]

							if currentItem then
								-- Ha még nincs meg az első slot eleme, akkor megnézzük mi az
								if not lastValidItem or lastValidItem == "faszi" or lastValidItem == "scatter" then
									lastValidItem = currentItem
								-- Ha az előző után lévő slot eleme nem egyezik meg az előzővel, illetve ha nem joker
								elseif currentItem ~= lastValidItem and lastValidItem ~= "faszi" and lastValidItem ~= "scatter" and currentItem ~= "faszi" and currentItem ~= "scatter" then
									-- Megnézzük, hogy van-e nyeremény a waypoint ezen slotján
									local itemPayTable = payTable[lastValidItem]

									if itemPayTable then
										itemPayTable = itemPayTable[betPerLineTableCounter]

										if itemPayTable then
											local rewardAmount = itemPayTable[loopIndex - 1]

											if rewardAmount then
												local winnerSlots = {}

												for slotIndex = 1, loopIndex - 1 do
													table.insert(winnerSlots, {currentWayPoint[slotIndex][1], currentWayPoint[slotIndex][2]})
												end

												table.insert(resultTable, {selectedLine, lastValidItem, winnerSlots, rewardAmount, waitingTimes["showLineReward"]})
											end
										end
									end

									break
								end
							end
						end
					-- Speciális eset, hogyha nem sikerülne megállítania a loopot (pl. egy sor eredménye  scatter,j,scatter,j,scatter )
					else
						local selectedItem = lastValidItem

						-- Ha nincs meg az első slot eleme, akkor beállítjuk az első vonal, első slot elemére
						if not lastValidItem then
							local firstLine = currentWayPoint[1]

							if firstLine then
								local firstItem = finalSymbols[firstLine[1]][firstLine[2]]

								if firstItem then
									selectedItem = firstItem
								end
							end
						end

						-- Megnézzük, hogy van-e nyeremény a waypoint ezen slotján
						if selectedItem then
							local itemPayTable = payTable[selectedItem]

							if itemPayTable then
								itemPayTable = itemPayTable[betPerLineTableCounter]

								if itemPayTable then
									local rewardAmount = itemPayTable[loopIndex - 1]

									if rewardAmount then
										local winnerSlots = {}

										for slotIndex = 1, loopIndex - 1 do
											table.insert(winnerSlots, {currentWayPoint[slotIndex][1], currentWayPoint[slotIndex][2]})
										end

										table.insert(resultTable, {selectedLine, selectedItem, winnerSlots, rewardAmount, waitingTimes["showLineReward"]})
									end
								end
							end
						end
					end
				end
			end
		end
	end

	-- Összeadjuk a vonalakon nyert összeget
	local rewardAmount = 0

	for i = 1, #resultTable do
		rewardAmount = rewardAmount + resultTable[i][4]
	end

	-- Visszatérünk az eredményekkel
	return resultTable, scatterCount, freePlaySymbolCount, freePlaySymbolColumns, rewardAmount
end

local gambleOpened = false
local gambleCardTick = 0
local gambleCardState = false
local gambleInitialChance = 50
local gambleCurrentChance = gambleInitialChance

function clickGamble()
	-- Ha próbára tudjuk tenni a szerencsénket
	if totalWinOverall > 0 then
		-- Ha a generált szám, kisebb vagy egyenlő mint a jelenlegi nyerési esélyünk, akkor nyert.
		if math.random(1, 100) <= gambleCurrentChance then
			playSoundEx("files/sounds/gambletalalt.mp3")

			-- Csökkentjük a felével a nyerési esélyt
			if math.random(1, 2) == 1 then
				if gambleCurrentChance >= 1 then
					gambleCurrentChance = math.ceil(gambleCurrentChance / 2)
				else
					gambleCurrentChance = 1
				end
			end

			totalWinOverall = totalWinOverall * 2 -- megduplázzuk a nyereményt
			statusText = "Össznyeremény: " .. thousandsStepper(totalWinOverall)
		-- Nem nyert és bukta az eddigi nyereményt is
		else
			playSoundEx("files/sounds/slot.mp3")

			totalWinOverall = 0
			gambleOpened = false
			canCollectReward = false
			statusText = "Elbuktad a nyereményed"

			if isElement(soundContainer["gambleCard"]) then
				destroyElement(soundContainer["gambleCard"])
			end
		end
	end
end

local clickedMachineId = false

addEvent("receiveGameOpen", true)
addEventHandler("receiveGameOpen", resourceRoot,
	function (machineId, creditAmount)
		if not panelState then
			openGame(machineId, creditAmount)
		end
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		if panelState then
			exports.sm_hud:showHUD()
			exports.sm_controls:toggleControl("all", true)
			setElementFrozen(localPlayer, false)
		end
	end
)

function openGame(machineId, creditAmount)
	if not panelState then
		clickedMachineId = machineId
		currentBalance = creditAmount

		-- Állítsuk vissza a tétvonalakat
		linesInUse[1] = true

		for i = 2, 10 do
			linesInUse[i] = false
		end

		-- Tiltsuk le az összes controlt és rejtsük el a HUD-ot
		exports.sm_hud:hideHUD()
		exports.sm_controls:toggleControl("all", false)

		-- Hozuk létre a betűtípusokat
		fontContainer["pricedown"] = dxCreateFont("files/fonts/pricedown.ttf", 19, false, "antialiased")
		fontContainer["swanse"] = dxCreateFont("files/fonts/swanse.ttf", 16, false, "antialiased")
		fontContainer["payTable"] = dxCreateFont("files/fonts/paytable.ttf", 13, false, "antialiased")
		fontContainer["pricedown_2"] = dxCreateFont("files/fonts/pricedown.ttf", 32, false, "antialiased")
		fontContainer["swanse_2"] = dxCreateFont("files/fonts/swanse.ttf", 20, false, "antialiased")

		-- Generáljunk az oszlopokba szimbólumokat
		for i = 1, 5 do
			columnSymbols[i] = {}

			for j = 1, symbolPerColumn + i * symbolPerColumn do
				table.insert(columnSymbols[i], weightedSymbols[math.random(1, #weightedSymbols)])
			end

			columnProgress[i] = 100
		end

		-- Háttérzene elindítása
		soundContainer["welcome"] = playSoundEx("files/sounds/welcomesound.mp3", false)
		backgroundMusicStartTimer = setTimer(
			function ()
				if panelState then
					if not soundContainer["background"] then
						soundContainer["background"] = playSoundEx("files/sounds/background.mp3", true)

						if soundContainer["background"] then
							setSoundVolume(soundContainer["background"], 0.35)
						end
					end
				end
			end,
		3000, 1)

		-- Jelenítsük meg a panelt
		statusText = "Üdvözöllek a SeeMTA Western Slot játékában!"
		panelState = true

		addEventHandler("onClientRender", root, onGameRender)
		addEventHandler("onClientClick", root, onMouseClick)
		addEventHandler("onClientKey", root, onKeyPress)
	end
end

function closeGame()
	if panelState then
		-- Zárjuk be a panelt
		removeEventHandler("onClientRender", root, onGameRender)
		removeEventHandler("onClientClick", root, onMouseClick)
		removeEventHandler("onClientKey", root, onKeyPress)

		panelState = false
		payTableOpened = false
		gambleOpened = false

		activeButton = false
		buttons = {}

		-- Frissítsük a játékgép aktuális kreditmennyiségét
		if clickedMachineId then
			local gameMachinesResource = getResourceFromName("sm_gamemachines")

			if gameMachinesResource then
				local gameMachinesResourceRoot = getResourceRootElement(gameMachinesResource)

				if gameMachinesResourceRoot then
					triggerServerEvent("requestGameClose", gameMachinesResourceRoot, clickedMachineId, currentBalance)
				else
					outputDebugString("A játékgépek resource nem található.", 2)
				end
			else
				outputDebugString("A játékgépek resource nem található.", 2)
			end
		end

		-- Állítsuk vissza a HUD-ot és a controllokat
		exports.sm_hud:showHUD()
		exports.sm_controls:toggleControl("all", true)
		setElementFrozen(localPlayer, false)

		-- Állítsuk vissza a változókat
		currentBalance = 0
		betPerLineTableCounter = 1

		freePlayMode = false
		freePlayRoundCount = 0
		allFreePlayRounds = 10
		freePlaySymbol = ""
		freePlayRandomizerSpinning = false
		freePlayWon = false

		columnSymbols = {}
		columnProgress = {}

		resultTable = {}
		totalWinOverall = 0

		canCollectReward = false

		waitingForButton = false
		waitingThread = false

		gameStage = "none"
		currentLineRender = 0
		columnSoundPlayed = {}

		-- Állítsuk le a háttérzene elindító időzítőt
		if backgroundMusicStartTimer then
			if isTimer(backgroundMusicStartTimer) then
				killTimer(backgroundMusicStartTimer)
			end

			backgroundMusicStartTimer = nil
		end

		-- Töröljük a betűtípusokat
		for k,v in pairs(fontContainer) do
			if isElement(v) then
				destroyElement(v)
			end
		end

		fontContainer = {}

		-- Töröljük a hangokat
		for k,v in pairs(soundContainer) do
			if isElement(v) then
				destroyElement(v)
			end
		end

		soundContainer = {}
	end
end

function onGameRender()
	if panelState then
		local currentTick = getTickCount()
		local absX, absY = 0, 0

		if isCursorShowing() then
			local relX, relY = getCursorPosition()

			absX = relX * screenWidth
			absY = relY * screenHeight
		end

		buttons = {}

		-- ** Háttér
		dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/slotbg.png")

		-- ** Hangeffektek
		if soundsEnabled then
			dxDrawImage(panelPosX + 55, panelPosY + 40, 94, 15, "files/images/buttons/fxon.png")
		else
			dxDrawImage(panelPosX + 55, panelPosY + 40, 94, 15, "files/images/buttons/fxoff.png")
		end
		buttons["muteSound"] = {panelPosX + 55, panelPosY + 40, 94, 15}

		-- ** Főképernyő
		if not payTableOpened and not gambleOpened then
			local activeLines = getActiveLines()
			local activeLineBet = getActiveLineBet()

			-- Aktuális kreditmennyiség
			dxDrawText("$ " .. thousandsStepper(currentBalance), panelPosX + 50, panelPosY + 125, 0, 0, tocolor(255, 255, 255), 1, fontContainer["pricedown"], "left", "top", false, false, false, false, true)
			-- Státusz kiírása
			dxDrawText(statusText, panelPosX + 45, panelPosY + 556, panelPosX + 581, 0, tocolor(255, 255, 255), 1, fontContainer["swanse"], "center", "top", false, false, false, false, true)


			-- Tétvonalak számozása
			dxDrawText(activeLines, panelPosX + 128, panelPosY + 589, panelPosX + 165, 0, tocolor(255, 255, 255), 1, fontContainer["swanse"], "center", "top", false, false, false, false, true)

			-- Tétvonal csökkentés button
			if activeButton == "activeLines_minus" then
				dxDrawImage(panelPosX + 105, panelPosY + 594, 20, 20, "files/images/buttons/minus2.png")
			else
				dxDrawImage(panelPosX + 105, panelPosY + 594, 20, 20, "files/images/buttons/minus.png")
			end
			buttons["activeLines_minus"] = {panelPosX + 105, panelPosY + 594, 20, 20}

			-- Tétvonal növelés button
			if activeButton == "activeLines_plus" then
				dxDrawImage(panelPosX + 168, panelPosY + 594, 20, 20, "files/images/buttons/plus2.png")
			else
				dxDrawImage(panelPosX + 168, panelPosY + 594, 20, 20, "files/images/buttons/plus.png")
			end
			buttons["activeLines_plus"] = {panelPosX + 168, panelPosY + 594, 20, 20}

			-- Tét/vonal számozása
			dxDrawText(activeLineBet, panelPosX + 321, panelPosY + 589, panelPosX + 359, 0, tocolor(255, 255, 255), 1, fontContainer["swanse"], "center", "top", false, false, false, false, true)

			-- Tét/vonal csökkentés button
			if activeButton == "lineBet_minus" then
				dxDrawImage(panelPosX + 299, panelPosY + 594, 20, 20, "files/images/buttons/minus2.png")
			else
				dxDrawImage(panelPosX + 299, panelPosY + 594, 20, 20, "files/images/buttons/minus.png")
			end
			buttons["lineBet_minus"] = {panelPosX + 299, panelPosY + 594, 20, 20}

			-- Tét/vonal növelés button
			if activeButton == "lineBet_plus" then
				dxDrawImage(panelPosX + 362, panelPosY + 594, 20, 20, "files/images/buttons/plus2.png")
			else
				dxDrawImage(panelPosX + 362, panelPosY + 594, 20, 20, "files/images/buttons/plus.png")
			end
			buttons["lineBet_plus"] = {panelPosX + 362, panelPosY + 594, 20, 20}

			-- Jelenlegi tét
			dxDrawText(activeLines * activeLineBet, panelPosX + 434, panelPosY + 590, panelPosX + 574, 0, tocolor(255, 255, 255), 1, fontContainer["swanse"], "center", "top", false, false, false, false, true)

			-- Pörgetés button
			if activeButton == "spin" then
				if canCollectReward then
					dxDrawImage(panelPosX + 660, panelPosY + 565, 101, 59, "files/images/buttons/col2.png")
				else
					dxDrawImage(panelPosX + 660, panelPosY + 565, 101, 59, "files/images/buttons/spin2.png")
				end
			elseif canCollectReward then
				dxDrawImage(panelPosX + 660, panelPosY + 565, 101, 59, "files/images/buttons/col1.png")
			else
				dxDrawImage(panelPosX + 660, panelPosY + 565, 101, 59, "files/images/buttons/spin.png")
			end
			buttons["spin"] = {panelPosX + 660, panelPosY + 565, 101, 59}

			-- Bezárás button
			if activeButton == "close" then
				dxDrawImage(panelPosX + 720, panelPosY + 20, 48, 48, "files/images/buttons/close2.png")
			else
				dxDrawImage(panelPosX + 720, panelPosY + 20, 48, 48, "files/images/buttons/close.png")
			end
			buttons["close"] = {panelPosX + 720, panelPosY + 20, 48, 48}

			-- Szerencsejáték button
			if activeButton == "gamble" then
				dxDrawImage(panelPosX + 590, panelPosY + 580, 66, 40, "files/images/gamble/g2.png")
			else
				dxDrawImage(panelPosX + 590, panelPosY + 580, 66, 40, "files/images/gamble/g1.png")
			end
			buttons["gamble"] = {panelPosX + 590, panelPosY + 580, 66, 40}

			-- Fizetési táblázat button
			if activeButton == "payTable" then
				dxDrawImage(panelPosX + 55, panelPosY + 70, 94, 15, "files/images/paytable/pay2.png")
			else
				dxDrawImage(panelPosX + 55, panelPosY + 70, 94, 15, "files/images/paytable/pay.png")
			end
			buttons["payTable"] = {panelPosX + 55, panelPosY + 70, 94, 15}

			-- Szimbólumok és vonalak mutatása
			if gameStage == "none" then
				-- Szimbólumok
				renderSymbols()
				-- Útvonalak
				renderLines(currentTick)
			-- Pörgetés
			elseif gameStage == "roll" then
				local elapsedTime = currentTick - columnRollStart

				-- Végigloopolunk az oszlopokon
				for i = 1, 5 do
					local animationTime = waitingTimes["roll"] + i * (waitingTimes["columnStop"] / symbolPerColumn) * symbolPerColumn

					if elapsedTime <= animationTime then
						columnProgress[i] = interpolateBetween(0, 0, 0, 100, 0, 0, elapsedTime / animationTime, "Linear")
					else
						columnProgress[i] = 100
					end

					-- Oszlop animálása
					if columnProgress[i] < 100 then
						-- Végigloopolunk a sorokon
						for j = 1, #columnSymbols[i] do
							local imagePosX = symbolPosX + (i - 1) * (symbolWidth + 5)
							local imagePosY = symbolPosY - (j - 3) * symbolHeight + (#columnSymbols[i] - 3) * symbolHeight / 100 * columnProgress[i]
							local imageWidth = symbolWidth
							local imageHeight = symbolHeight

							local sectionPosX = 0
							local sectionPosY = 0
							local sectionWidth = imageWidth
							local sectionHeight = imageHeight

							local columnStartY = symbolPosY
							local columnEndY = symbolPosY + 3 * symbolHeight

							if imagePosY <= columnStartY and columnStartY <= imagePosY + imageHeight then
								sectionPosY = columnStartY - imagePosY
								imageHeight = imageHeight - sectionPosY
								sectionHeight = imageHeight
								imagePosY = columnStartY
							end

							if columnEndY <= imagePosY + imageHeight then
								imageHeight = imageHeight - (imagePosY + imageHeight - columnEndY)
								sectionHeight = imageHeight
							end

							-- Csak akkor drawolja, ha tényleg látszik
							if columnStartY <= imagePosY and imagePosY <= columnEndY then
								dxDrawImageSection(imagePosX, imagePosY, imageWidth, imageHeight, sectionPosX, sectionPosY, sectionWidth, sectionHeight, "files/images/" .. (freePlaySymbol == columnSymbols[i][j] and "freeplay" or "symbols") .. "/" .. columnSymbols[i][j] .. ".png")
							end
						end
					-- Oszlop animálás befejezve, mutatás
					else
						-- Szimbólumok
						renderSymbols(i)

						-- Ha még játszott le hangot az adott oszlopra, akkor
						if not columnSoundPlayed[i] then
							columnSoundPlayed[i] = true

							-- Különleges oszlopnál ellenőrizzük a scattert
							if specialColumns[i] then
								for j = 0, 2 do
									if columnSymbols[i][#columnSymbols[i] - j] == "scatter" then
										playSoundEx("files/sounds/oszlop" .. i .. ".mp3")
										break
									end
								end
							end

							playSoundEx("files/sounds/slot.mp3")
						end
					end
				end
			-- Nyeremények mutatása
			elseif gameStage == "showRewards" then
				-- Szimbólumok
				renderSymbols()

				-- Ha van nyeremény az aktuális vonalon, akkor
				if resultTable[currentLineRender] then
					local winnerSlots = resultTable[currentLineRender][3]
					local winnerSlotSet = {}

					for i = 1, #winnerSlots do
						winnerSlotSet[winnerSlots[i][1] .. "," .. winnerSlots[i][2]] = true
					end

					-- Lefedjük azokat a slotokat amik nem tartoznak a nyerő vonalhoz
					for i = 1, 5 do
						for j = 1, 3 do
							if not winnerSlotSet[i .. "," .. j] then
								dxDrawImage(symbolPosX + (i - 1) * (symbolWidth + 5), symbolPosY + (j - 1) * symbolHeight, symbolWidth, symbolHeight, "files/images/linebg.png")
							end
						end
					end

					-- Útvonal
					dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/lines/line" .. resultTable[currentLineRender][1] .. ".png")

					-- Szimbólum körvonal
					for i = 1, #winnerSlots do
						dxDrawImage(symbolPosX + (winnerSlots[i][1] - 1) * (symbolWidth + 5), symbolPosY + (winnerSlots[i][2] - 1) * symbolHeight, symbolWidth, symbolHeight, "files/images/selection/k" .. resultTable[currentLineRender][1] .. ".png")
					end
				end
			-- Szabadjáték randomizer
			-- elseif gameStage == "freePlay_1" then
			-- 	-- Szimbólumok
			-- 	renderSymbols()

			-- 	-- Háttér
			-- 	dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/fp.png")

			-- 	-- Generált szabadjáték szimbólum
			-- 	dxDrawImage(panelPosX + 337, panelPosY + 294, symbolWidth, symbolHeight, "files/images/freeplay/" .. freePlaySymbol .. ".png")
			-- Szabadjáték kezdése
			elseif gameStage == "freePlay_2" then
				-- Szimbólumok
				renderSymbols()

				-- Háttér
				dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/10won.png")
			-- Szabadjáték eredmény
			elseif gameStage == "freePlay_result" then
				-- Szimbólumok
				renderSymbols()

				-- Háttér
				dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/featurewin.png")

				-- Össznyeremény
				dxDrawText(thousandsStepper(totalWinOverall), panelPosX + 52, panelPosY + 302, panelPosX + 350, 0, tocolor(0, 0, 0), 1, fontContainer["pricedown_2"], "center", "top", false, false, false, false, true)
				dxDrawText(thousandsStepper(totalWinOverall), panelPosX + 50, panelPosY + 300, panelPosX + 350, 0, tocolor(255, 151, 14), 1, fontContainer["pricedown_2"], "center", "top", false, false, false, false, true)

				-- Játszott szabadjátékok
				dxDrawText(allFreePlayRounds, panelPosX + 84, panelPosY + 410, panelPosX + 244, 0, tocolor(0, 0, 0), 1, fontContainer["swanse_2"], "center", "top", false, false, false, false, true)
				dxDrawText(allFreePlayRounds, panelPosX + 82, panelPosY + 410, panelPosX + 244, 0, tocolor(200, 200, 200), 1, fontContainer["swanse_2"], "center", "top", false, false, false, false, true)
			end
		-- ** Szerencsejáték
		elseif gambleOpened then
			-- Háttér
			dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/gamble.png")

			-- Össznyeremény
			dxDrawText(thousandsStepper(totalWinOverall), panelPosX + 45, panelPosY + 90, panelPosX + 320, 0, tocolor(255, 0, 0), 1, fontContainer["swanse"], "center", "top", false, false, false, false, true)
			dxDrawText(thousandsStepper(totalWinOverall * 2), panelPosX + 500, panelPosY + 90, panelPosX + 750, 0, tocolor(255, 0, 0), 1, fontContainer["swanse"], "center", "top", false, false, false, false, true)

			-- Kártya
			if getTickCount() >= gambleCardTick + 100 then
				gambleCardTick = getTickCount()
				gambleCardState = not gambleCardState
			end

			if gambleCardState then
				dxDrawImage(panelPosX + (panelWidth - 200) / 2, panelPosY + (panelHeight - 300) / 2, 200, 300, "files/images/gamble/ace_of_heartsback.png")
			else
				dxDrawImage(panelPosX + (panelWidth - 200) / 2, panelPosY + (panelHeight - 300) / 2, 200, 300, "files/images/gamble/ace_of_spadesback.png")
			end

			-- Fekete button
			if activeButton == "gamble_black" then
				dxDrawImage(panelPosX + 125, panelPosY + 400, 100, 60, "files/images/gamble/b2.png")
			else
				dxDrawImage(panelPosX + 125, panelPosY + 400, 100, 60, "files/images/gamble/b1.png")
			end
			buttons["gamble_black"] = {panelPosX + 125, panelPosY + 400, 100, 60}

			-- Piros button
			if activeButton == "gamble_red" then
				dxDrawImage(panelPosX + 600, panelPosY + 400, 100, 60, "files/images/gamble/r2.png")
			else
				dxDrawImage(panelPosX + 600, panelPosY + 400, 100, 60, "files/images/gamble/r1.png")
			end
			buttons["gamble_red"] = {panelPosX + 600, panelPosY + 400, 100, 60}

			-- OK button
			if activeButton == "gamble_ok" then
				dxDrawImage(panelPosX + panelWidth / 2 - 50, panelPosY + 570, 100, 60, "files/images/buttons/ok2.png")
			else
				dxDrawImage(panelPosX + panelWidth / 2 - 50, panelPosY + 570, 100, 60, "files/images/buttons/ok.png")
			end
			buttons["gamble_ok"] = {panelPosX + panelWidth / 2 - 50, panelPosY + 570, 100, 60}
		-- ** Fizetési táblázat
		elseif payTableOpened then
			-- Háttér
			dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/paytable/paytable.png")

			-- money
			for i = 0, 3 do
				local payAmount = "- " .. thousandsStepper(payTable["money"][betPerLineTableCounter][5 - i])
				dxDrawText(payAmount, panelPosX + 170, panelPosY + 269 + i * 18 + 2, 0, 0, tocolor(0, 0, 0, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
				dxDrawText(payAmount, panelPosX + 168, panelPosY + 269 + i * 18, 0, 0, tocolor(255, 255, 255, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
			end

			-- desert
			for i = 0, 3 do
				local payAmount = "- " .. thousandsStepper(payTable["desert"][betPerLineTableCounter][5 - i])
				dxDrawText(payAmount, panelPosX + 170, panelPosY + 386 + i * 18 + 2, 0, 0, tocolor(0, 0, 0, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
				dxDrawText(payAmount, panelPosX + 168, panelPosY + 386 + i * 18, 0, 0, tocolor(255, 255, 255, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
			end

			-- a,k
			for i = 0, 2 do
				local payAmount = "- " .. thousandsStepper(payTable["a"][betPerLineTableCounter][5 - i])
				dxDrawText(payAmount, panelPosX + 170, panelPosY + 508 + i * 18 + 2, 0, 0, tocolor(0, 0, 0, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
				dxDrawText(payAmount, panelPosX + 168, panelPosY + 508 + i * 18, 0, 0, tocolor(255, 255, 255, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
			end

			-- car
			for i = 0, 3 do
				local payAmount = "- " .. thousandsStepper(payTable["car"][betPerLineTableCounter][5 - i])
				dxDrawText(payAmount, panelPosX + 660, panelPosY + 268 + i * 18 + 2, 0, 0, tocolor(0, 0, 0, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
				dxDrawText(payAmount, panelPosX + 658, panelPosY + 268 + i * 18, 0, 0, tocolor(255, 255, 255, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
			end

			-- bobe
			for i = 0, 3 do
				local payAmount = "- " .. thousandsStepper(payTable["bobe"][betPerLineTableCounter][5 - i])
				dxDrawText(payAmount, panelPosX + 660, panelPosY + 385 + i * 18 + 2, 0, 0, tocolor(0, 0, 0, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
				dxDrawText(payAmount, panelPosX + 658, panelPosY + 385 + i * 18, 0, 0, tocolor(255, 255, 255, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
			end

			-- q,10,j
			for i = 0, 2 do
				local payAmount = "- " .. thousandsStepper(payTable["q"][betPerLineTableCounter][5 - i])
				dxDrawText(payAmount, panelPosX + 660, panelPosY + 508 + i * 18 + 2, 0, 0, tocolor(0, 0, 0, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
				dxDrawText(payAmount, panelPosX + 658, panelPosY + 508 + i * 18, 0, 0, tocolor(255, 255, 255, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
			end

			-- faszi
			for i = 0, 2 do
				local payAmount = "- " .. thousandsStepper(payTable["faszi"][betPerLineTableCounter][5 - i])
				dxDrawText(payAmount, panelPosX + 365, panelPosY + 425 + i * 18 + 2, 0, 0, tocolor(0, 0, 0, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
				dxDrawText(payAmount, panelPosX + 363, panelPosY + 425 + i * 18, 0, 0, tocolor(255, 255, 255, 255), 1, fontContainer["payTable"], "left", "top", false, false, false, false, true)
			end

			-- Bezárás
			if activeButton == "closePayTable" then
				dxDrawImage(panelPosX + 352, panelPosY + 590, 67, 40, "files/images/buttons/ok2.png")
			else
				dxDrawImage(panelPosX + 352, panelPosY + 590, 67, 40, "files/images/buttons/ok.png")
			end
			buttons["closePayTable"] = {panelPosX + 352, panelPosY + 590, 67, 40}
		end

		-- ** Háttér kiegészítő
		dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/glass.png")

		-- ** Kijelölt gomb megkeresése
		activeButton = false

		for buttonKey, buttonInfo in pairs(buttons) do
			if absX >= buttonInfo[1] and absX <= buttonInfo[1] + buttonInfo[3] and absY >= buttonInfo[2] and absY <= buttonInfo[2] + buttonInfo[4] then
				activeButton = buttonKey
				break
			end
		end
	end
end

function renderSymbols(columnIndex)
	-- Végigloopolunk az oszlopokon
	for i = 1, 5 do
		if not columnIndex or i == columnIndex then
			local rowCounter = 1

			-- Kirajzoljuk az utolsó 3 sor szimbólumát
			for j = #columnSymbols[i], #columnSymbols[i] - 2, -1 do
				-- Ha nem pörög a szabadjáték randomizáló
				-- if gameStage ~= "freePlay_1" then
					local texturePack = "symbols"

					-- Ha szabadjáték mód, használjuk a szabadjáték szimbólumokat
					if freePlayMode then
						if freePlaySymbol == columnSymbols[i][j] then
							texturePack = "freeplay"
						end
					end

					dxDrawImage(math.floor(symbolPosX + (i - 1) * (symbolWidth + 5)), math.floor(symbolPosY + (rowCounter - 1) * symbolHeight), symbolWidth, symbolHeight, "files/images/" .. texturePack .. "/" .. columnSymbols[i][j] .. ".png")
				-- Ellenkező esetben, a normál mód szimbólumait rajzoljuk
				-- else
				-- 	dxDrawImage(math.floor(symbolPosX + (i - 1) * (symbolWidth + 5)), math.floor(symbolPosY + (rowCounter - 1) * symbolHeight), symbolWidth, symbolHeight, "files/images/symbols/" .. columnSymbols[i][j] .. ".png")
				-- end

				rowCounter = rowCounter + 1
			end
		end
	end
end

function renderLines(currentTick)
	-- Megjelenítjük a vonalakat a szükséges ideig
	if currentTick <= betLineClickTime + betLineDisplayDuration then
		-- Végigloopolunk az oszlopokon
		for i = 1, 5 do
			-- Végigloopolunk a sorokon
			for j = 1, 3 do
				dxDrawImage(symbolPosX + (i - 1) * (symbolWidth + 5), symbolPosY + (j - 1) * symbolHeight, symbolWidth, symbolHeight, "files/images/linebg.png")
			end
		end

		-- Végigloopolunk a vonalakon
		for i = 1, #linesInUse do
			-- Ha használatban van, megjelenítjük
			if linesInUse[i] then
				dxDrawImage(panelPosX, panelPosY, panelWidth, panelHeight, "files/images/lines/line" .. i .. ".png")
			end
		end
	end
end

function onKeyPress(keyName, isPressed)
	if panelState then
		if keyName == "space" then
			if isPressed then
				-- Ha nincs pörgetés folyamatban
				if gameStage == "none" or gameStage == "freePlay_2" then
					-- Ha nem szabadjáték mód, vagy ha szabadjáték indul
					if not freePlayMode or freePlayWon then
						-- Ha betudjuk gyűjteni a nyereményt, akkor
						if canCollectReward then
							currentBalance = currentBalance + totalWinOverall
							totalWinOverall = 0
							canCollectReward = false
							playSoundEx("files/sounds/collect.mp3")
						else
							-- Ha nem szabadjáték indul akkor felrakjuk a tétet
							local betAmount = getActiveLines() * getActiveLineBet()
							if betAmount <= currentBalance or freePlayWon then
								-- Ha a gomb amire várunk nem a pörgetés, elindítjük a pörgetést
								if waitingForButton ~= "spin" then
									-- Ha nem szabadjáték indul, levonjuk a tétet az egyenlegből
									if not freePlayWon then
										currentBalance = currentBalance - betAmount
										execute(manageRoll)
									end
									playSoundEx("files/sounds/spin.mp3")
								end
								-- Triggereljük a pörgetés gombot
								triggerButton("spin")
							else
								statusText = "Nincs elég coinod a pörgetéshez!"
							end
						end
					end
				end
			end
		end
	end
end

function onMouseClick(button, state)
	if panelState then
		if activeButton then
			if button == "left" then
				if state == "up" then
					if activeButton == "muteSound" then
						soundsEnabled = not soundsEnabled

						if isElement(soundContainer["freePlayBackground"]) then
							setSoundPaused(soundContainer["freePlayBackground"], not soundsEnabled)
						elseif isElement(soundContainer["background"]) then
							setSoundPaused(soundContainer["background"], not soundsEnabled)
						end
					else
						-- Ha nincs pörgetés folyamatban
						if gameStage == "none" or gameStage == "freePlay_2" then
							-- Ha nincs megnyitva a fizetési tábla vagy a duplázás
							if not payTableOpened and not gambleOpened then
								if activeButton == "activeLines_minus" then
									if gameStage == "none" then
										if not freePlayMode then
											for i = #linesInUse, 2, -1 do
												if linesInUse[i] then
													linesInUse[i] = false
													break
												end
											end
											playSoundEx("files/sounds/betlinebutton.mp3")
											betLineClickTime = getTickCount()
										end
									end
								elseif activeButton == "activeLines_plus" then
									if gameStage == "none" then
										if not freePlayMode then
											for i = 1, #linesInUse do
												if not linesInUse[i] then
													linesInUse[i] = true
													break
												end
											end
											playSoundEx("files/sounds/betlinebutton.mp3")
											betLineClickTime = getTickCount()
										end
									end
								elseif activeButton == "lineBet_minus" then
									if gameStage == "none" then
										if not freePlayMode then
											if betPerLineTableCounter - 1 >= 1 then
												betPerLineTableCounter = betPerLineTableCounter - 1
												playSoundEx("files/sounds/betlinebutton.mp3")
											end
										end
									end
								elseif activeButton == "lineBet_plus" then
									if gameStage == "none" then
										if not freePlayMode then
											if betPerLineTableCounter + 1 <= #betPerLines then
												betPerLineTableCounter = betPerLineTableCounter + 1
												playSoundEx("files/sounds/betlinebutton.mp3")
											end
										end
									end
								elseif activeButton == "payTable" then
									if gameStage == "none" then
										if not freePlayMode then
											payTableOpened = true
											playSoundEx("files/sounds/paytableopen.mp3")
										end
									end
								elseif activeButton == "spin" then
									-- Ha nem szabadjáték mód, vagy ha szabadjáték indul
									if not freePlayMode or freePlayWon then
										-- Ha betudjuk gyűjteni a nyereményt, akkor
										if canCollectReward then
											currentBalance = currentBalance + totalWinOverall
											totalWinOverall = 0
											canCollectReward = false
											playSoundEx("files/sounds/collect.mp3")
										else
											-- Ha nem szabadjáték indul akkor felrakjuk a tétet
											local betAmount = getActiveLines() * getActiveLineBet()
											if betAmount <= currentBalance or freePlayWon then
												-- Ha a gomb amire várunk nem a pörgetés, elindítjük a pörgetést
												if waitingForButton ~= "spin" then
													-- Ha nem szabadjáték indul, levonjuk a tétet az egyenlegből
													if not freePlayWon then
														currentBalance = currentBalance - betAmount
														execute(manageRoll)
													end
													playSoundEx("files/sounds/spin.mp3")
												end
												-- Triggereljük a pörgetés gombot
												triggerButton(activeButton)
											else
												statusText = "Nincs elég coinod a pörgetéshez!"
											end
										end
									end
								elseif activeButton == "close" then
									if totalWinOverall == 0 then
										closeGame()
									else
										exports.sm_accounts:showInfo("e", "Előbb gyűjtsd be a nyereményed!")
									end
								elseif activeButton == "gamble" then
									if gameStage == "none" then
										if not freePlayMode then
											if totalWinOverall > 0 then
												gambleOpened = true
												gambleCurrentChance = gambleInitialChance
												soundContainer["gambleCard"] = playSoundEx("files/sounds/gamblekartyaperges.mp3", true)
											end
										end
									end
								end
							elseif gambleOpened then
								if activeButton == "gamble_black" or activeButton == "gamble_red" then
									clickGamble()
								elseif activeButton == "gamble_ok" then
									currentBalance = currentBalance + totalWinOverall
									totalWinOverall = 0
									gambleOpened = false

									if isElement(soundContainer["gambleCard"]) then
										destroyElement(soundContainer["gambleCard"])
									end
								end
							elseif payTableOpened then
								if activeButton == "closePayTable" then
									payTableOpened = false
									playSoundEx("files/sounds/paytableclose.mp3")
								end
							end
						end
					end
				end
			end
		end
	end
end

function getActiveLines()
	local activeLineCounter = 0

	for i = 1, #linesInUse do
		if linesInUse[i] then
			activeLineCounter = activeLineCounter + 1
		end
	end

	return activeLineCounter
end

function getActiveLineBet()
	return betPerLines[betPerLineTableCounter] or 1
end

function playSoundEx(soundPath, isLooped)
	if soundsEnabled then
		return playSound(soundPath, isLooped or false)
	else
		return false
	end
end

function thousandsStepper(amount)
	local formatted = tostring(amount)
	local counter = 0

	while true do
		formatted, counter = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1 %2")

		if counter == 0 then
			break
		end
	end

	return formatted
end
