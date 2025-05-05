pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)


local screenX, screenY = guiGetScreenSize()

local availableStations = {
	{"http://stream3.radio1.hu/mid.mp3", "Rádió 1"},
	{"http://stream002.radio.hu/mr2.mp3", "MR2 Petőfi"},
	{"http://onair-ha1.krone.at/kronehit-hd.mp3.m3u", "Kronehit"},
	{"http://www.radio88.hu/stream/radio88.pls", "Rádió 88"},
	{"http://87.229.53.9:9000/;stream.mp3", "Part FM"},
	{"http://wssgd.gdsinfo.com:8200/listen.pls", "Balaton rádió"},
	{"http://195.56.193.129:8100/listen.pls", "Sunshine FM"},
	{"http://stream.retrofm.hu:8000/listen", "Retro Rádió"},
	{"http://listen.181fm.com/181-90sdance_128k.mp3", "181.FM - 90's dance"},
	{"http://mixradio.hu/listen.m3u", "Mix Radio - Napjaink slágerei"},
	{"https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://91.121.155.204:8048/listen.pls?sid=1&t=.m3u", "1000 HITS 80s"},
	{"https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://192.99.37.181:8050/live.mp3.m3u&t=.m3u", "Obrilho radio"},
	{"http://www.181.fm/winamp.pls?station=181-uktop40&file=181-uktop40.pls", "UK top 40 - 181.fm"},
	{"http://www.181.fm/winamp.pls?station=181-office&file=181-office.pls", "The Office - 181.fm"},
	{"http://www.181.fm/winamp.pls?station=181-themix&file=181-themix.pls", "The Mix - 181.fm"},
	{"http://www.181.fm/winamp.pls?station=181-power&file=181-power.pls", "Power 181 - 181.fm"},
	{"http://www.181.fm/winamp.pls?station=181-vibe&file=181-vibe.pls", "The Vibe of Vegas - 181.fm"},
	{"http://stream.laut.fm/jahfari.m3u", "Jahfari Radio"},
	{"http://162.252.85.85:8872/;", "Wu Tang World"},
	{"http://www.hot108.com/hot108.asx", "Hot 108 Jamz"},
	{"http://149.56.175.167:5461/listen.pls", "Hip Hop Request # 1"},
	{"http://blackbeats.fm/listen.m3u", "BlackBeats.FM"},
	{"http://listen.radionomy.com/classic-rap.m3u", "Classic RAP Radio"},
	{"http://www.181.fm/winamp.pls?station=181-oldschool&file=181-oldschool.pls", "181.FM - Old School Hip Hop & RNB"},
	{"http://192.96.205.59:7660/listen.pls", "Gtronik Radio"},
	{"http://79.120.77.11:8000/rapru", "Russian Rap Radio"},
	{"http://www.macchiatomedia.org:2199/tunein/hiphop.pls", "WHAT?! Radio"},
	{"https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://37.187.93.104:8589/listen.pls?sid=1&t=.m3u", "Deep House Radio"},
	{"http://discoshit.hu/ds-radio.m3u", "DISCO*S HIT Radio"},
	{"http://ibizaglobalradio.streaming-pro.com:8024/listen.pls", "Ibiza Global Radio"},
	{"http://5.39.71.159:8750/listen.pls", "Minimal Mix Radio"},
	{"http://streamer.psyradio.org:8100/listen.pls", "Psyradio"},
	{"http://space.ducks.invasion.started.at.bassjunkees.com:8442/listen.pls", "Bassjunkees"},
	{"http://50.7.70.58:8200/listen.pls", "Bassdrive"},
	{"http://www.pulsradio.com/pls/puls-adsl.m3u", "Pulsradio"},
	{"http://somafm.com/wma128/thetrip.asx", "The Trip (Progressive house / trance.)"},
	{"http://stream2.dancewave.online:8080/dance.mp3.m3u", "Dance Wave"},
	{"http://149.56.157.81:5100/listen.pls", "JR.FM Techno Radio"},
	{"http://listen.technobase.fm/tunein-mp3-pls", "TechnoBase FM"},
	{"https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://schranz.in:8000/listen.pls?sid=1&t=.m3u", "Hardtechno AFK killer fm"},
	{"http://209.9.238.6:6040/listen.pls", "Rockabilly Radio"},
	{"http://www.181.fm/winamp.pls?station=181-rock40&file=181-rock40.pls", "Rock 40 (Rock & Roll) - 181.fm"},
	{"http://www.181.fm/winamp.pls?station=181-hardrock&file=181-hardrock.pls", "The Rock! (Hard Rock) - 181.fm"},
	{"http://www.181.fm/winamp.pls?station=181-buzz&file=181-buzz.pls", "The Buzz (Alt Rock) - 181.fm"},
	{"http://www.181.fm/tuner.php?station=181-highway&file=181-highway.asx", "181.FM - Highway 181"},
	{"http://ophanim.net:7130/stream", "Ocean Beach Radio"},
	{"http://s18.myradiostream.com:9676/listen.pls", "Non Stop Oldies"},
	{"http://somafm.com/wma128/indiepop.asx", "Indie Pop Rocks!"},
	{"http://listen.radionomy.com/JazzRadioClassicJazz.m3u", "Classic Jazz Radio"},
	{"http://listen.radionomy.com/bestofjazz-ludwigradiocom.m3u", "Jazz Radio"},
	{"https://www.internet-radio.com/servers/tools/playlistgenerator/?u=http://37.187.79.56:5120/listen.pls?sid=1&t=.m3u", "Smooth Jazz Florida"},
	{"http://stream.mercyradio.eu/jimmy.mp3", "Magyar Király Rádió"},
	{"http://stream.mercyradio.eu/disco.mp3", "Magyar Disco Radio"},
	{"http://stream.mercyradio.eu/rap.mp3", "Magyar RAP Radio"},
	{"http://stream.mercyradio.eu/rock.mp3", "Magyar ROCK Radio"},
	{"http://stream.mercyradio.eu/90.mp3", "Magyar 90-es évek zenéi"},
	{"http://stream.mercyradio.eu/roma.mp3", "Romano Ungriko Discovo Radio"},
	{"http://stream.mercyradio.eu/romaaut.mp3", "Romano Ungriko Autentikus Radio"},
	{"http://stream.mercyradio.eu/mulatos.mp3", "Magyar Mulatós Radio"},
	{"http://online.radiorecord.ru:8102/hbass_320", "Hardbass FM"},
}
local soundMaxDistance = 30
local radioMusic = {}

local panelState = false
local panelWidth = 200
local panelHeight = 260
local panelPosX = (screenX / 2)
local panelPosY = (screenY / 2)
local panelMargin = 3
local hifiElement = false
local panelFont = false

local moveDifferenceX, moveDifferenceY = 0, 0
local isMoving = false

local clickTick = 0

function createFonts()
	destroyFonts()
	panelFont = dxCreateFont("files/roboto.ttf", 13, false, "antialiased")
end

function destroyFonts()
	if isElement(panelFont) then
		destroyElement(panelFont)
	end
end

local txd = engineLoadTXD("files/hifi.txd")
engineImportTXD(txd, 2103)

local soundLevel = {}
local noteSymbols = {}
local noteTextures = {
	dxCreateTexture("files/note1.png"),
	dxCreateTexture("files/note2.png")
}

local hifiOffsets = {
	[2099] = 0.94912501335144,
	[2226] = 0.32379854679108,
	[2101] = 0.5421282863617,
	[2103] = 0.46358762264252,
	[2225] = 0.85604564189911,
	[2227] = 1.0548736953735,
	[2100] = 1.073167514801
}

addEventHandler("onClientElementStreamIn", getResourceRootElement(),
	function ()
		if getElementType(source) == "object" then
			if getElementData(source, "radioId") or getElementData(source, "radioFurniture") then
				if isElement(radioMusic[source]) then
					destroyElement(radioMusic[source])
				end

				local radioState = getElementData(source, "radioState")
				if radioState then
					if availableStations[radioState] then
						local objPosX, objPosY, objPosZ = getElementPosition(source)
						radioMusic[source] = playSound3D(availableStations[radioState][1], objPosX, objPosY, objPosZ, true)
						if isElement(radioMusic[source]) then
							setElementInterior(radioMusic[source], getElementInterior(source))
							setElementDimension(radioMusic[source], getElementDimension(source))
							setSoundMaxDistance(radioMusic[source], soundMaxDistance)
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientElementStreamOut", getResourceRootElement(),
	function ()
		if isElement(radioMusic[source]) then
			destroyElement(radioMusic[source])
		end
	end
)

addEventHandler("onClientElementDestroy", getResourceRootElement(),
	function ()
		if isElement(radioMusic[source]) then
			destroyElement(radioMusic[source])
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "radioState" then
			if isElement(radioMusic[source]) then
				destroyElement(radioMusic[source])
			end

			local radioState = getElementData(source, "radioState")
			if radioState then
				if availableStations[radioState] then
					local objPosX, objPosY, objPosZ = getElementPosition(source)
					radioMusic[source] = playSound3D(availableStations[radioState][1], objPosX, objPosY, objPosZ, true)
					if isElement(radioMusic[source]) then
						setElementInterior(radioMusic[source], getElementInterior(source))
						setElementDimension(radioMusic[source], getElementDimension(source))
						setSoundMaxDistance(radioMusic[source], soundMaxDistance)
					end
				end
			end
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if state == "up" then
			if button == "right" then
				if not panelState then
					if isElement(clickedElement) then
						local radioId = getElementData(clickedElement, "radioId")

						if not radioId then
							radioId = getElementData(clickedElement, "radioFurniture")
						end

						if radioId then
							local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
							local targetPosX, targetPosY, targetPosZ = getElementPosition(clickedElement)

							if getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, targetPosX, targetPosY, targetPosZ) <= 4 then
								createFonts()
								
								panelState = true
								panelPosX = absoluteX
								panelPosY = absoluteY

								hifiElement = clickedElement

								playSound("files/hifiopen.mp3", false)
							end
						end
					end
				end
			else
				if button == "left" then
					isMoving = false

					if panelState then
						if isElement(hifiElement) then
							if clickTick + 500 <= getTickCount() then
								if absoluteX >= panelPosX + 5 and absoluteX <= panelPosX + 5 + panelWidth - 10 and absoluteY >= panelPosY + 40 and absoluteY <= panelPosY + 70 then
									local radioState = getElementData(hifiElement, "radioState")
									if radioState then
										setElementData(hifiElement, "radioState", false)
										exports.sm_chat:localActionC(localPlayer, "kikapcsolja a rádiót.")
									else
										setElementData(hifiElement, "radioState", 1)
										exports.sm_chat:localActionC(localPlayer, "bekapcsolja a rádiót.")
									end
									panelState = false
									playSound("files/hifibuttons.mp3", false)
									destroyFonts()
								elseif absoluteX >= panelPosX + 5 and absoluteX <= panelPosX + 5 + panelWidth - 10 and absoluteY >= panelPosY + 80 and absoluteY <= panelPosY + 110 then
									local radioState = getElementData(hifiElement, "radioState")
									if radioState then
										if availableStations[radioState + 1] then
											setElementData(hifiElement, "radioState", radioState + 1)
											playSound("files/hifibuttons.mp3", false)
										else
											setElementData(hifiElement, "radioState", 1)
											playSound("files/hifibuttons.mp3", false)
										end
									end
								elseif absoluteX >= panelPosX + 5 and absoluteX <= panelPosX + 5 + panelWidth - 10 and absoluteY >= panelPosY + 120 and absoluteY <= panelPosY + 150 then
									local radioState = getElementData(hifiElement, "radioState")
									if radioState then
										if availableStations[radioState - 1] then
											setElementData(hifiElement, "radioState", radioState - 1)
											playSound("files/hifibuttons.mp3", false)
										else
											setElementData(hifiElement, "radioState", #availableStations)
											playSound("files/hifibuttons.mp3", false)
										end
									end
								elseif absoluteX >= panelPosX + 5 and absoluteX <= panelPosX + 5 + panelWidth - 10 and absoluteY >= panelPosY + 160 and absoluteY <= panelPosY + 190 then
									if getElementModel(hifiElement) == 2103 then
										triggerServerEvent("pickupRadio", localPlayer, hifiElement)
										panelState = false
										playSound("files/hifibuttons.mp3", false)
										exports.sm_chat:localActionC(localPlayer, "felveszi a rádiót a földről.")
										destroyFonts()
									else
										panelState = false
										playSound("files/hificlose.mp3", false)
										destroyFonts()
									end
								elseif absoluteX >= panelPosX + 5 and absoluteX <= panelPosX + 5 + panelWidth - 10 and absoluteY >= panelPosY + 220 and absoluteY <= panelPosY + 250 then
									panelState = false
									playSound("files/hificlose.mp3", false)
									destroyFonts()
								end

								clickTick = getTickCount()
							end
						end
					end
				end
			end
		else
			if state == "down" then
				if button == "left" then
					if panelState then
						if absoluteX >= panelPosX and absoluteX <= panelPosX + panelWidth and absoluteY >= panelPosY and absoluteY <= panelPosY + 30 then
							moveDifferenceX = absoluteX - panelPosX
							moveDifferenceY = absoluteY - panelPosY

							isMoving = true
						end
					end
				end
			end
		end
	end
)

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

addEventHandler("onClientRender", getRootElement(),
	function ()
		local now = getTickCount()

		for objectElement, soundElement in pairs(radioMusic) do
			if isElement(objectElement) then
				if isElement(soundElement) then
					if isElementOnScreen(objectElement) then
						local soundFFT = getSoundFFTData(soundElement, 2048, 0)
						if soundFFT then
							soundFFT[1] = math.sqrt(soundFFT[1]) * 5
							
							soundFFT[1] = 0.75 + soundFFT[1] * 0.5 / 5

							local hifiModel = getElementModel(objectElement)

							if hifiModel == 2103 then
								setObjectScale(objectElement, soundFFT[1])
							end

							local leftData, rightData = getSoundLevelData(soundElement)
							if leftData then
								if not soundLevel[objectElement] then
									soundLevel[objectElement] = leftData / 32768 + rightData / 32768
								end

								soundLevel[objectElement] = soundLevel[objectElement] + (leftData / 32768 + rightData / 32768)

								if soundLevel[objectElement] > math.random(20, 35) then
									soundLevel[objectElement] = 0

									local objPosX, objPosY, objPosZ = getElementPosition(objectElement)

									if hifiOffsets[hifiModel] then
										objPosZ = objPosZ + hifiOffsets[hifiModel]
									else
										objPosZ = objPosZ + 0.25
									end

									if noteTextures[1] and noteTextures[2] then
										for i = 1, math.random(1, 3) do
											local rot = math.random(0, 180) * 2

											table.insert(noteSymbols, {
												noteTextures[math.random(1, 2)],
												objPosX + math.random(-2, 2) / 10,
												objPosY + math.random(-2, 2) / 10,
												objPosZ,
												objPosZ,
												now,
												rot,
												{
													math.cos(math.rad(rot)),
													-math.sin(math.rad(math.random(0, 360)))
												},
												math.random(7, 10),
												math.random(5, 15) / 10
											})
										end
									end
								end
							end
						end
					end
				end
			end
		end

		for k in pairs(noteSymbols) do
			local symbol = noteSymbols[k]

			if symbol then
				local elapsedTime = now - symbol[6]

				symbol[6] = now
				symbol[7] = symbol[7] % 360 + 0.1
				symbol[4] = symbol[4] + elapsedTime * 0.001 * symbol[10]

				if symbol[4] - symbol[5] > 2 then
					noteSymbols[k] = nil
				end

				local rot = math.cos(symbol[7]) / symbol[9]
				local alpha = 1 - (symbol[4] - symbol[5]) / 2

				if alpha < 0 then
					alpha = 0
				end

				dxDrawMaterialLine3D(
					symbol[2] + symbol[8][1] * rot,
					symbol[3] + symbol[8][2] * rot,
					symbol[4],
					symbol[2] + symbol[8][1] * rot,
					symbol[3] + symbol[8][2] * rot,
					symbol[4] - 0.1,
					symbol[1], 0.1, tocolor(0, 0, 0, 255 * alpha))
			end
		end

		if panelState then
			if isElement(hifiElement) then
				buttonsC = {}

				local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
				local targetPosX, targetPosY, targetPosZ = getElementPosition(hifiElement)

				if getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, targetPosX, targetPosY, targetPosZ) > 4 then
					panelState = false
					playSound("files/hificlose.mp3", false)
					destroyFonts()
					return
				end

				local absX, absY = 0, 0
				if isCursorShowing() then
					local relX, relY = getCursorPosition()

					absX = screenX * relX
					absY = screenY * relY
				end

				if isMoving then
					panelPosX = absX - moveDifferenceX
					panelPosY = absY - moveDifferenceY
				end

				-- ** Háttér
				dxDrawRectangle(panelPosX, panelPosY, panelWidth, panelHeight, tocolor(25, 25, 25))
				dxDrawRectangle(panelPosX + 3, panelPosY + 3, panelWidth - 6, 30, tocolor(45, 45, 45, 180))

				local stationText = "StrongMTA - Rádió"
				local radioState = getElementData(hifiElement, "radioState")
				if radioState then
					if availableStations[radioState] then
						stationText = availableStations[radioState][2]
					end
				end

				dxDrawText(stationText, panelPosX + 5 + 3, panelPosY + 10, panelPosX + panelWidth - 2, panelPosY + 45, tocolor(200, 200, 200, 200), 0.8, panelFont, "left", "top", true, false, false, false, false)

				-- Bekapcs/Kikapcs
				local toggleText = "Bekapcsolás"
				if isElement(radioMusic[hifiElement]) then
					toggleText = "Kikapcsolás"
				end

				local toggleColor = {60, 60, 60, 40}
				if absX >= panelPosX + 5 and absX <= panelPosX + 5 + panelWidth - 10 and absY >= panelPosY + 40 and absY <= panelPosY + 70 then
					toggleColor = {124, 197, 118, 140}

					if toggleText == "Kikapcsolás" then
						toggleColor = {215, 89, 89, 140}
					end
				end

				drawButton("toogleRadio", toggleText, panelPosX + 5, panelPosY + 40, panelWidth - 10, 30, toggleColor, false, panelFont, true)

				-- Következő
				local nextStationColor = {60, 60, 60, 40}
				if absX >= panelPosX + 5 and absX <= panelPosX + 5 + panelWidth - 10 and absY >= panelPosY + 80 and absY <= panelPosY + 110 then
					nextStationColor = {61, 123, 188, 140}
				end
				drawButton("nextStation", "Következő állomás", panelPosX + 5, panelPosY + 80, panelWidth - 10, 30, nextStationColor, false, panelFont, true)
	
				-- Előző
				local prevStationColor = {60, 60, 60, 40}
				if absX >= panelPosX + 5 and absX <= panelPosX + 5 + panelWidth - 10 and absY >= panelPosY + 120 and absY <= panelPosY + 150 then
					prevStationColor = {61, 123, 188, 140}
				end
				drawButton("prevStation", "Előző állomás", panelPosX + 5, panelPosY + 120, panelWidth - 10, 30, prevStationColor, false, panelFont, true)

				-- Felvétel
				local pickupColor = {60, 60, 60, 40}
				if absX >= panelPosX + 5 and absX <= panelPosX + 5 + panelWidth - 10 and absY >= panelPosY + 160 and absY <= panelPosY + 190 then
					pickupColor = {	186, 188, 61, 140}
				end
				drawButton("pickUp", "Felvétel", panelPosX + 5, panelPosY + 160, panelWidth - 10, 30, pickupColor, false, panelFont, true)

				-- Kilépés
				local closeColor = {60, 60, 60, 40}
				if absX >= panelPosX + 5 and absX <= panelPosX + 5 + panelWidth - 10 and absY >= panelPosY + 220 and absY <= panelPosY + 250 then
					closeColor = {215, 89, 89, 140}
				end
				drawButton("close", "Bezárás", panelPosX + 5, panelPosY + 220, panelWidth - 10, 30, closeColor, false, panelFont, true)
			
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
		end
	end
)