pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local windowlessModels = {
	[424] = true,
	[457] = true,
	[486] = true,
	[500] = true,
	[504] = true,
	[530] = true,
	[531] = true,
	[539] = true,
	[568] = true,
	[571] = true,
	[572] = true
}

local windowIds = {3, 1, 4, 2}
local seatWindows = {
	[0] = 4,
	[1] = 2,
	[2] = 5,
	[3] = 3
}

local windowTick = {}
local windowNames = {
	"Jobb első ablak",
	"Jobb hátsó ablak",
	"Bal első (sofőr) ablak",
	"Bal hátsó ablak"
}

local doorTick = {}
local doorNames = {
	"Motorháztető",
	"Csomagtartó",
	"Balelső ajtó",
	"Jobbelső ajtó",
	"Balhátsó ajtó",
	"Jobbhátsó ajtó"
}

local panelState = false
local panelStage = false

local panelWidth = respc(275)
local panelHeight = respc(375)

local panelPosX = screenX / 2 - panelWidth / 2
local panelPosY = screenY / 2 - panelHeight / 2

local titleHeight = respc(30)

local activeButton = false

local panelIsMoving = false
local moveDifferenceX = 0
local moveDifferenceY = 0

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		local vehicles = getElementsByType("vehicle")

		for i = 1, #vehicles do
			local vehicle = vehicles[i]

			if isElement(vehicle) then
				for j = 2, 5 do
					local windowState = getElementData(vehicle, "vehicle.window." .. j)

					setVehicleWindowOpen(vehicle, 5, windowState)
				end
			end
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if string.find(dataName, "vehicle.window.") then
			local windowId = tonumber(gettok(dataName, 3, "."))

			if windowId then
				setVehicleWindowOpen(source, windowId, getElementData(source, dataName))
			end
		end
	end
)

addEvent("playWindowSound", true)
addEventHandler("playWindowSound", getRootElement(),
	function (state)
		if state == "2d" then
			playSound("cveh/files/window.mp3")
		else
			local vehX, vehY, vehZ = getElementPosition(source)
			local soundEffect = playSound3D("cveh/files/window.mp3", vehX, vehY, vehZ)

			attachElements(soundEffect, source)
			setElementInterior(soundEffect, getElementInterior(source))
			setElementDimension(soundEffect, getElementDimension(source))
			setSoundMaxDistance(soundEffect, 5)
		end
	end
)

addCommandHandler("ablak",
	function ()
		local currentVehicle = getPedOccupiedVehicle(localPlayer)

		if currentVehicle then
			if getVehicleType(currentVehicle) == "Automobile" then
				local vehicleModel = getElementModel(currentVehicle)

				if not windowlessModels[vehicleModel] then
					local currentSeat = getPedOccupiedVehicleSeat(localPlayer)

					if currentSeat ~= 0 then
						local window = tonumber(seatWindows[currentSeat]) or 2

						if not windowTick[window] then
							windowTick[window] = 0
						end

						if getTickCount() - windowTick[window] > 4000 then
							setElementData(currentVehicle, "vehicle.window." .. window, not getElementData(currentVehicle, "vehicle.window." .. window))

							if getElementData(currentVehicle, "vehicle.window." .. window) then
								exports.sm_chat:localActionC(localPlayer, "lehúzza a " .. utf8.lower(windowNames[window - 1]) .. "ot.")
							else
								exports.sm_chat:localActionC(localPlayer, "felhúzza a " .. utf8.lower(windowNames[window - 1]) .. "ot.")
							end

							local windowState = false

							for i = 2, 5 do
								if getElementData(currentVehicle, "vehicle.window." .. i) then
									windowState = true
									break
								end
							end

							setElementData(currentVehicle, "vehicle.windowState", not windowState)

							local playerX, playerY, playerZ = getElementPosition(localPlayer)
							local players = getElementsByType("player", getRootElement(), true)
							local affected = {}

							for i = 1, #players do
								local player = players[i]

								if player ~= localPlayer then
									if getPedOccupiedVehicle(player) == currentVehicle then
										table.insert(affected, {player, "2d"})
									else
										local targetX, targetY, targetZ = getElementPosition(player)

										if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 10 then
											table.insert(affected, {player, "3d"})
										end
									end
								end
							end

							if #affected > 0 then
								triggerServerEvent("playWindowSound", currentVehicle, affected)
							end

							playSound("cveh/files/window.mp3")

							windowTick[window] = getTickCount()
						end
					else
						if panelStage ~= "cveh" then
							panelState = not panelState

							if panelState then
								panelStage = "window"
								
								addEventHandler("onClientRender", getRootElement(), onRender)
								addEventHandler("onClientClick", getRootElement(), onClick)
							else
								panelStage = false

								removeEventHandler("onClientRender", getRootElement(), onRender)
								removeEventHandler("onClientClick", getRootElement(), onClick)
							end
						end
					end
				end
			end
		end
	end
)
bindKey("F4", "down", "ablak")

addCommandHandler("cveh",
	function ()
		if isPedInVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			if panelStage ~= "window" then
				panelState = not panelState

				if panelState then
					panelStage = "cveh"
					
					addEventHandler("onClientRender", getRootElement(), onRender)
					addEventHandler("onClientClick", getRootElement(), onClick)
				else
					panelStage = false

					removeEventHandler("onClientRender", getRootElement(), onRender)
					removeEventHandler("onClientClick", getRootElement(), onClick)
				end
			end
		end
	end
)

local logoRaw = [[
   <svg class="img-fluid" id="outputsvg" xmlns="http://www.w3.org/2000/svg" style="transform: matrix(1.32068, 0, 0, 1.32068, 0.493701, 17.5607); transform-origin: 50% 50%; cursor: move; max-height: none; transition: none 0s ease 0s;" width="693" height="693" viewBox="0 0 6930 6930"><g id="l62Mit2wNyeWmtOgIpCepuS" fill="rgb(0,0,0)" style="transform: none;"><g><path id="pLQiRzZWv" d="M2173 6173 c-31 -6 -83 -68 -83 -100 0 -55 54 -226 80 -251 14 -13 419 -212 900 -441 l875 -416 127 -304 126 -303 -31 -29 c-38 -34 -51 -35 -110 -10 l-45 20 1 63 c2 56 -7 87 -81 288 -46 123 -90 237 -98 252 -17 32 25 11 -794 388 -464 214 -624 283 -653 283 -51 0 -84 -32 -93 -89 -7 -52 6 -91 44 -127 15 -14 304 -157 642 -318 338 -160 620 -296 626 -300 12 -9 89 -208 83 -213 -2 -2 -19 -1 -37 1 -31 5 -37 13 -73 87 -21 44 -47 87 -58 93 -11 7 -244 117 -518 244 -341 159 -507 231 -531 231 -21 0 -42 -8 -58 -23 -47 -44 -43 -67 51 -346 54 -158 96 -266 109 -280 11 -12 183 -113 380 -224 197 -112 355 -204 350 -206 -184 -65 -1033 -406 -1049 -421 -48 -46 -72 45 305 -1195 123 -404 169 -544 186 -561 13 -12 511 -263 1106 -557 1018 -501 1086 -534 1135 -533 93 0 128 60 97 164 -22 73 -78 182 -101 196 -10 6 -416 192 -903 413 -487 222 -894 413 -906 424 -11 12 -65 129 -119 261 -84 204 -104 244 -139 277 -22 22 -44 39 -48 39 -13 0 -9 34 7 57 9 13 33 27 55 33 34 9 46 7 87 -12 l48 -23 5 -105 6 -105 92 -205 c51 -113 103 -215 115 -226 12 -12 337 -158 722 -325 535 -232 709 -303 738 -302 67 1 114 63 102 135 -13 76 -27 83 -698 373 l-625 269 -45 103 -45 103 32 0 c29 0 36 -7 84 -88 29 -49 62 -98 75 -109 35 -32 906 -405 946 -405 23 0 42 8 59 25 48 49 41 75 -142 491 -91 209 -173 387 -182 397 -9 10 -106 71 -215 136 -109 64 -196 120 -191 124 4 4 241 89 527 189 557 195 575 204 575 268 0 77 -495 1625 -530 1657 -25 23 -2211 1062 -2247 1068 -15 2 -38 2 -50 0z m1303 -737 l901 -428 141 -432 c141 -428 347 -1095 340 -1100 -1 -2 -263 -94 -580 -205 -538 -190 -577 -205 -588 -231 -6 -15 -10 -42 -8 -60 3 -31 14 -39 263 -186 l260 -154 51 -117 c185 -424 232 -533 228 -533 -3 0 -121 50 -262 111 -141 61 -313 136 -382 165 l-125 54 -64 108 c-36 59 -69 110 -75 114 -6 4 -70 8 -142 8 -129 0 -132 -1 -148 -25 -9 -13 -16 -35 -16 -48 0 -13 29 -90 65 -172 36 -81 64 -149 62 -151 -8 -9 -27 20 -62 96 -143 314 -136 295 -138 411 -2 125 -6 133 -103 180 -60 30 -69 31 -152 27 -77 -3 -93 -8 -132 -33 -53 -36 -79 -99 -79 -190 l0 -60 57 -46 57 -46 104 -252 c75 -181 112 -258 131 -275 15 -12 432 -206 927 -431 l900 -409 20 -53 21 -52 -117 58 c-64 32 -534 264 -1046 516 -511 251 -935 462 -941 468 -6 7 -71 210 -143 452 -73 242 -144 474 -156 515 -13 41 -38 122 -55 180 -58 192 -92 304 -111 364 -11 33 -18 60 -17 61 3 1 281 109 1008 391 144 55 147 58 149 130 1 30 -5 34 -427 272 l-427 242 -64 190 c-35 105 -62 192 -60 194 2 1 204 -91 449 -205 l445 -208 36 -78 c58 -123 58 -123 223 -123 l139 0 -6 78 -6 77 26 -65 c20 -50 25 -80 24 -133 -1 -48 4 -80 18 -111 17 -40 28 -48 98 -82 49 -24 97 -39 130 -42 53 -4 53 -4 143 68 83 68 90 76 90 109 0 20 -11 56 -25 80 -14 24 -62 132 -106 240 -145 350 -161 386 -177 403 -10 9 -255 130 -547 268 -1276 606 -1227 582 -1240 615 -38 93 -42 92 147 2 95 -46 578 -276 1074 -511z"></path></g></g><g id="l40fr3WsuMGagS2r8uDMyYw" fill="rgb(3,5,104)" style="transform: none;"><g><path id="px6yXTyDw" d="M2186 6071 c-3 -5 -2 -22 3 -37 6 -16 17 -55 26 -87 l16 -59 185 -89 c102 -49 187 -89 190 -89 12 0 2 49 -11 54 -10 4 -15 19 -15 48 0 24 4 38 8 32 13 -20 50 -34 92 -34 83 0 43 29 -215 151 -137 65 -255 119 -262 119 -6 0 -14 -4 -17 -9z"></path><path id="pLEgzZF4M" d="M2384 5505 c-10 -25 12 -42 123 -95 111 -52 177 -66 171 -33 -2 10 -53 40 -138 79 -74 35 -139 63 -143 63 -4 1 -10 -6 -13 -14z"></path><path id="p1whkY3VI" d="M2538 4930 c40 -120 72 -200 79 -200 20 0 15 46 -12 135 -14 44 -25 95 -25 113 0 31 1 32 45 32 75 0 58 25 -51 76 -52 24 -97 44 -99 44 -2 0 27 -90 63 -200z"></path><path id="pONKwKtr6" d="M2503 3731 c-95 -37 -175 -70 -179 -73 -6 -7 10 -64 100 -360 70 -229 108 -355 148 -490 26 -89 46 -138 55 -138 20 0 16 45 -17 155 l-30 100 0 388 c0 337 2 387 15 387 8 0 15 4 15 8 0 4 16 14 35 21 29 10 35 17 35 42 0 16 -1 29 -2 28 -2 0 -81 -31 -175 -68z"></path></g></g><g id="l2e2TtKb38OcFsqHi473pV0" fill="rgb(9,18,113)" style="transform: none;"><g><path id="p18ISLLZe8" d="M2578 5883 c-27 -4 -28 -6 -28 -73 l0 -69 38 -21 c20 -12 98 -50 172 -86 129 -62 135 -64 138 -43 2 13 -3 26 -12 31 -9 5 -16 22 -16 41 l0 32 50 -3 c41 -3 50 -1 50 13 0 18 -265 149 -282 139 -14 -9 -68 16 -68 32 0 8 -3 13 -7 13 -5 -1 -20 -4 -35 -6z"></path><path id="p1Z71UlNt" d="M2550 5401 c0 -5 75 -46 168 -91 116 -58 177 -82 201 -82 80 3 52 29 -110 104 -112 51 -151 65 -176 61 -21 -3 -33 -1 -33 6 0 6 -11 11 -25 11 -14 0 -25 -4 -25 -9z"></path><path id="p5nDHUSHg" d="M2550 4989 c0 -71 4 -86 73 -312 11 -35 22 -44 132 -106 l121 -67 -4 188 -4 188 42 0 c34 0 41 3 38 17 -4 23 -270 145 -323 148 -22 1 -48 6 -57 10 -16 6 -18 0 -18 -66z"></path><path id="pZjTHI5Ql" d="M2795 3845 c-77 -31 -142 -60 -143 -65 -2 -6 -8 -8 -13 -4 -5 3 -9 0 -9 -6 0 -6 -5 -8 -10 -5 -5 3 -10 1 -10 -5 0 -7 -7 -10 -15 -6 -9 3 -15 0 -15 -9 0 -8 -7 -15 -15 -15 -13 0 -15 -53 -15 -416 l0 -417 65 -221 c35 -121 93 -315 128 -431 l64 -210 39 -22 c21 -13 42 -23 47 -23 14 0 7 48 -8 54 -13 4 -15 36 -15 201 0 186 1 195 19 195 19 0 19 2 3 41 -11 29 -35 57 -74 88 -58 46 -58 46 -54 91 10 96 59 156 144 175 44 9 42 35 -3 35 l-35 0 0 469 0 469 35 16 c28 14 35 23 35 46 0 17 -1 30 -2 30 -2 -1 -66 -25 -143 -55z"></path></g></g><g id="l1XfNlDizxXI9Gs1J6xqlYa" fill="rgb(14,28,121)" style="transform: none;"><g><path id="p1HtBwz1AD" d="M2840 5671 l0 -72 123 -59 122 -60 3 60 3 60 34 0 c25 0 35 4 35 16 0 18 -178 105 -225 110 -16 2 -45 6 -62 10 l-33 6 0 -71z"></path><path id="pJox4q9fi" d="M2842 5268 c2 -7 62 -43 133 -79 108 -55 136 -65 168 -61 23 3 37 9 37 18 0 18 -203 115 -250 119 -19 2 -48 6 -63 9 -21 5 -28 3 -25 -6z"></path><path id="p1FIM6GzIb" d="M2840 4727 c0 -172 2 -196 18 -209 19 -17 215 -128 225 -128 4 0 7 90 7 200 l0 200 25 0 c16 0 25 6 25 16 0 24 -181 106 -246 110 l-54 4 0 -193z"></path><path id="pPXgWNF0b" d="M3040 3940 c-69 -27 -126 -54 -128 -60 -2 -5 -19 -17 -38 -26 l-34 -16 0 -504 c0 -378 3 -505 12 -510 6 -4 14 -2 16 4 6 20 131 14 181 -8 24 -11 44 -20 45 -20 0 0 0 244 -2 542 l-3 541 28 23 c15 13 34 23 41 24 7 0 12 13 12 30 0 17 -1 30 -2 30 -2 0 -59 -23 -128 -50z"></path><path id="pTeHQORVa" d="M2843 2260 l2 -245 120 -62 c66 -34 124 -63 129 -63 5 0 6 18 2 40 -5 32 -3 40 9 40 20 0 19 13 -4 34 -10 9 -60 118 -112 241 -60 147 -98 225 -107 225 -8 0 -21 8 -28 18 -11 14 -13 -22 -11 -228z"></path></g></g><g id="l35x2PPbLMQELtcQjYWJ7tC" fill="rgb(19,38,127)" style="transform: none;"><g><path id="pqjRBkwvJ" d="M3060 5565 l0 -71 88 -43 c48 -24 102 -50 120 -58 31 -13 32 -12 32 10 0 16 -9 28 -25 35 -20 9 -25 19 -25 47 0 32 2 35 19 25 32 -17 101 -13 101 6 0 24 -203 116 -262 118 l-48 2 0 -71z"></path><path id="pkJbW7lRO" d="M3060 5166 c0 -10 35 -33 98 -64 78 -40 104 -48 135 -44 24 3 37 9 37 19 0 17 -141 85 -185 89 -16 1 -42 6 -57 9 -22 6 -28 4 -28 -9z"></path><path id="pVrfjWHSj" d="M3087 4823 l-27 -4 2 -211 3 -211 85 -48 c47 -27 88 -49 93 -49 4 0 7 90 7 200 0 193 1 200 20 200 11 0 20 -4 20 -10 0 -5 20 -10 45 -10 77 0 57 24 -70 84 -129 61 -139 64 -178 59z"></path><path id="pjtS2W2XF" d="M3245 4019 c-55 -22 -102 -44 -103 -49 -2 -6 -7 -8 -12 -5 -4 3 -22 -8 -39 -24 l-31 -29 0 -545 0 -545 49 -35 c58 -42 66 -67 57 -171 -7 -70 -6 -73 46 -190 57 -127 78 -152 78 -92 0 20 -4 36 -8 36 -28 0 -32 105 -32 838 l0 749 25 13 c14 7 25 17 25 22 0 4 11 8 25 8 21 0 25 5 25 30 0 17 -1 30 -2 29 -2 0 -48 -18 -103 -40z"></path><path id="pvDZbGo0O" d="M3077 2002 c-15 -3 -17 -12 -15 -50 l3 -46 85 -42 c97 -49 100 -49 100 -29 0 11 12 15 45 15 77 0 58 25 -62 81 -60 28 -115 56 -123 63 -8 7 -23 11 -33 8z"></path></g></g><g id="l17RzNsNoan4LTIHfbhekJx" fill="rgb(23,45,133)" style="transform: none;"><g><path id="p08FZ25i0" d="M3220 5495 l0 -75 100 -50 c55 -27 102 -50 105 -50 12 0 3 48 -10 54 -10 3 -15 19 -15 46 0 36 2 40 25 40 15 0 25 6 25 15 0 18 -93 67 -113 59 -9 -3 -33 4 -56 15 -22 12 -45 21 -51 21 -6 0 -10 -30 -10 -75z"></path><path id="p1Fa0lUdAP" d="M3220 5090 c0 -28 173 -108 223 -102 24 3 37 9 37 19 0 16 -165 97 -180 88 -5 -3 -26 -2 -45 4 -31 8 -35 7 -35 -9z"></path><path id="pADpUyySA" d="M3250 4751 c-8 -6 -18 -7 -22 -5 -5 3 -7 -94 -6 -216 l3 -222 100 -59 c55 -32 103 -58 108 -59 4 0 7 11 7 25 0 15 -6 25 -14 25 -23 0 -26 24 -26 211 l0 179 40 0 c41 0 46 5 31 28 -13 21 -108 61 -130 55 -17 -4 -20 -2 -15 11 5 14 2 16 -20 10 -20 -5 -26 -2 -26 10 0 18 -8 20 -30 7z"></path><path id="pZRGTuUAX" d="M3400 4079 c-41 -16 -76 -33 -78 -38 -2 -6 -9 -8 -16 -5 -8 3 -21 -2 -30 -11 -9 -9 -16 -14 -16 -11 0 3 -9 -3 -20 -14 -20 -20 -20 -30 -18 -813 l3 -792 30 -65 c17 -36 44 -95 60 -132 27 -61 35 -69 77 -88 56 -24 108 -27 108 -5 0 9 -11 20 -24 26 -26 12 -23 7 -111 204 -57 130 -61 143 -47 163 10 15 24 22 48 22 l34 0 0 741 0 742 26 23 c14 13 32 24 40 24 9 0 14 10 14 30 0 17 -1 30 -2 29 -2 0 -37 -13 -78 -30z"></path><path id="pRM4CV8Ab" d="M3220 1865 c0 -34 2 -36 90 -80 49 -25 92 -45 95 -45 3 0 5 11 5 25 0 21 5 25 30 25 20 0 30 5 30 16 0 18 -119 77 -164 80 -17 1 -43 5 -58 8 -26 6 -28 4 -28 -29z"></path></g></g><g id="l4ZKmuObocEA7SpwBVrPLqN" fill="rgb(27,53,139)" style="transform: none;"><g><path id="p1G1ZRQVxo" d="M3397 5493 c-28 -4 -28 -4 -25 -76 l3 -72 85 -42 c47 -23 89 -42 93 -43 4 0 5 27 1 60 l-7 60 37 0 c60 0 44 26 -41 69 -89 44 -107 49 -146 44z"></path><path id="p1F5YDCwLd" d="M3370 5019 c0 -29 153 -98 203 -92 61 8 48 33 -38 71 -42 18 -80 30 -85 27 -5 -3 -26 -2 -45 4 -31 8 -35 7 -35 -10z"></path><path id="pfVKlcDB4" d="M3400 4681 c-8 -6 -18 -7 -22 -5 -4 3 -8 -96 -8 -221 l0 -226 58 -37 c44 -28 57 -42 54 -57 -5 -23 -37 -57 -45 -48 -4 3 -20 -8 -37 -25 l-30 -30 0 -756 0 -755 90 -3 90 -3 0 958 0 957 30 0 c23 0 30 4 30 20 0 11 -6 20 -12 20 -27 1 -58 40 -93 117 -30 67 -40 80 -56 76 -13 -4 -19 0 -19 11 0 18 -8 20 -30 7z"></path><path id="pkrfSwERn" d="M3370 2182 c0 -67 -10 -57 135 -121 89 -40 104 -40 105 -3 0 19 -122 72 -150 65 -16 -4 -21 -3 -16 6 13 20 -3 49 -24 44 -21 -6 -29 12 -9 19 19 6 0 48 -22 48 -17 0 -19 -7 -19 -58z"></path><path id="pc6RzuIvR" d="M3372 1791 c3 -35 6 -38 103 -88 55 -29 103 -52 108 -53 4 0 7 11 7 25 0 23 4 25 40 25 70 0 50 26 -57 76 -70 33 -113 47 -151 49 l-53 2 3 -36z m208 -76 c0 -9 -6 -12 -15 -9 -8 4 -15 10 -15 15 0 5 7 9 15 9 8 0 15 -7 15 -15z"></path></g></g><g id="l4d3hQsmDIp7p0PVFNwcNOq" fill="rgb(31,62,145)" style="transform: none;"><g><path id="p14iSBGmWW" d="M3522 5345 l3 -70 80 -41 c44 -23 91 -45 103 -49 23 -7 24 -6 17 49 l-7 56 46 0 c75 0 60 24 -49 77 -70 34 -108 46 -145 47 l-51 2 3 -71z"></path><path id="p9z7ixPG2" d="M3520 4947 c0 -12 26 -30 84 -59 83 -41 84 -42 108 -101 13 -33 29 -62 36 -65 17 -5 16 50 -3 95 -18 44 -18 43 1 43 37 0 5 37 -61 69 -82 40 -165 49 -165 18z"></path><path id="plOw2fRxt" d="M3533 4493 c-10 -4 -13 -211 -13 -988 0 -928 1 -984 17 -989 10 -4 47 -56 83 -116 35 -60 69 -111 75 -114 5 -2 27 -11 48 -20 37 -16 37 -16 37 8 0 17 -8 27 -30 36 l-30 12 0 299 c0 292 0 299 20 299 28 0 25 25 -6 47 -24 18 -25 22 -14 44 7 13 20 29 29 36 14 11 13 12 -6 13 l-23 0 0 674 0 675 23 3 c16 2 23 11 25 32 l4 29 -116 -5 c-109 -4 -116 -3 -110 14 3 10 4 18 2 17 -2 0 -9 -3 -15 -6z"></path><path id="p17Q1zNNPi" d="M3520 2067 c0 -9 175 -94 200 -97 33 -5 50 1 50 18 0 23 -148 85 -207 86 -23 1 -43 -3 -43 -7z"></path><path id="phmT6OEbH" d="M3548 1763 c-25 -4 -28 -9 -28 -42 0 -38 0 -38 100 -90 l100 -52 0 30 c0 29 2 31 40 31 30 0 40 4 40 16 0 21 -139 85 -168 77 -18 -4 -21 -2 -16 11 3 9 2 16 -4 16 -6 0 -16 2 -24 3 -7 2 -25 2 -40 0z"></path></g></g><g id="l3e4P4nLag0FzWHeW5OKa6V" fill="rgb(35,70,150)" style="transform: none;"><g><path id="p1HuoYpzBz" d="M3688 5271 c-2 -44 -1 -79 2 -78 3 0 42 -18 87 -41 46 -23 85 -42 88 -42 3 0 5 11 5 25 0 14 -4 25 -10 25 -5 0 -10 20 -10 45 0 45 0 45 35 45 19 0 35 5 35 11 0 16 -110 61 -160 65 -24 1 -46 8 -48 13 -11 32 -21 2 -24 -68z"></path><path id="p9AMJokeF" d="M3730 4902 c0 -7 -9 -12 -20 -12 -29 0 -26 -19 29 -170 26 -74 51 -161 55 -192 l6 -58 -29 0 c-16 0 -31 -6 -35 -15 -3 -8 -15 -15 -26 -15 -20 0 -20 -3 -20 -710 0 -612 2 -710 14 -710 8 0 17 4 21 10 3 5 37 19 75 31 52 17 70 27 70 41 0 10 -4 18 -10 18 -7 0 -10 228 -10 665 l0 665 30 0 c17 0 30 4 30 10 0 21 -152 426 -166 440 -10 10 -14 11 -14 2z"></path><path id="pRTnoTUe6" d="M3730 2959 c0 -5 -9 -9 -20 -9 -20 0 -20 -7 -20 -328 l0 -329 78 -36 77 -37 3 305 c2 262 4 305 17 305 8 0 15 -7 15 -15 0 -11 12 -15 45 -15 32 0 45 4 45 14 0 7 -54 45 -120 84 -66 39 -120 66 -120 61z"></path><path id="prWBRyqJO" d="M3718 2003 c-16 -2 -28 -8 -28 -12 0 -5 46 -29 102 -54 73 -32 107 -43 122 -37 39 14 21 33 -68 71 -49 22 -92 38 -95 38 -3 -1 -18 -4 -33 -6z"></path><path id="plm88xxF9" d="M3690 1642 l0 -48 77 -35 c42 -19 81 -36 86 -38 5 -2 8 10 5 28 -4 30 -3 31 34 31 30 0 38 4 38 18 0 23 -133 81 -177 77 -18 -2 -33 1 -33 6 0 5 -7 9 -15 9 -11 0 -15 -12 -15 -48z"></path></g></g><g id="l499fO0LQvjKiDYVtF3CEKh" fill="rgb(39,77,156)" style="transform: none;"><g><path id="pwTU2YOV5" d="M3860 5289 c0 -5 -9 -9 -20 -9 -18 0 -20 -7 -20 -74 l0 -74 88 -42 c48 -23 97 -51 110 -63 l22 -20 0 36 c0 30 -4 37 -20 37 -17 0 -20 7 -20 45 0 43 1 45 30 45 59 0 33 29 -70 80 -55 27 -100 44 -100 39z"></path><path id="pGDK6fXQy" d="M3821 3849 l-1 -766 23 1 c41 2 197 60 197 73 0 7 -9 13 -20 13 -20 0 -20 7 -20 500 l0 500 45 0 c68 0 57 23 -31 65 -66 32 -78 42 -95 78 -23 51 -24 83 -4 94 21 12 -2 73 -27 73 -19 0 -25 16 -8 22 6 2 8 16 4 34 -5 25 -10 31 -25 27 -21 -6 -27 12 -6 20 7 4 6 6 -5 6 -9 1 -19 7 -21 14 -3 6 -6 -333 -6 -754z"></path><path id="pmmWUqqoM" d="M3818 2551 l-3 -316 84 -37 c121 -54 121 -54 121 -24 0 14 -4 26 -10 26 -6 0 -10 97 -10 270 l0 270 45 0 c25 0 45 3 45 8 0 16 -139 90 -159 85 -17 -4 -20 -2 -15 11 3 9 2 16 -2 17 -5 1 -28 2 -51 3 l-43 2 -2 -315z"></path><path id="p1HZ0GuT2Y" d="M3820 1941 c0 -13 20 -25 108 -64 84 -37 178 -51 170 -25 -6 16 -179 89 -198 83 -8 -3 -30 -1 -48 4 -17 5 -32 6 -32 2z"></path><path id="pxAvybHHb" d="M3822 1590 l3 -55 80 -42 c44 -23 83 -42 88 -43 4 0 7 16 7 35 0 32 2 35 30 35 22 0 30 5 30 18 0 24 -120 76 -179 78 -24 1 -47 8 -52 15 -6 9 -8 -6 -7 -41z"></path></g></g><g id="l35Z6WVZLfLma3v5ctMgPwI" fill="rgb(42,85,161)" style="transform: none;"><g><path id="p18V0WJU2Q" d="M3953 5145 c0 -44 2 -61 4 -37 2 23 2 59 0 80 -2 20 -4 1 -4 -43z"></path><path id="pNcgZY9oK" d="M3970 5133 c0 -66 2 -75 20 -80 23 -6 41 -43 125 -246 34 -83 67 -153 73 -155 19 -6 14 51 -8 108 -16 42 -20 74 -20 184 l0 133 55 -5 c46 -4 55 -2 55 12 0 24 -191 117 -251 121 l-49 4 0 -76z"></path><path id="pWqxbQNaS" d="M4185 4224 c-33 -29 -45 -34 -70 -28 -16 3 -46 7 -65 8 -20 2 -46 8 -58 15 l-22 12 0 -551 c0 -302 3 -550 8 -550 4 0 58 17 120 37 106 36 144 63 87 63 l-25 0 0 450 c0 301 3 450 10 450 6 0 15 12 20 26 6 14 19 28 30 31 15 4 20 14 20 39 0 19 -3 34 -7 34 -5 -1 -26 -16 -48 -36z"></path><path id="pL7DS3QoQ" d="M3955 3680 c0 -305 1 -430 2 -277 2 152 2 402 0 555 -1 152 -2 27 -2 -278z"></path><path id="pdVid6Lqn" d="M4000 2801 c0 -6 -7 -11 -15 -11 -13 0 -15 -42 -17 -307 l-3 -308 -5 315 -5 315 -3 -312 -2 -313 86 -40 c47 -23 107 -50 135 -60 l49 -20 0 24 c0 17 -9 27 -30 36 l-30 12 0 259 0 259 31 0 c52 0 31 29 -59 80 -51 29 -91 46 -103 43 -14 -4 -18 -1 -13 10 3 8 1 18 -5 22 -6 3 -11 1 -11 -4z"></path><path id="pCKe16yRH" d="M3950 1878 c0 -6 3 -9 6 -5 3 3 14 -2 24 -10 31 -27 211 -101 231 -96 10 3 19 13 19 22 0 25 -163 90 -207 84 -21 -3 -33 -1 -33 6 0 6 -9 11 -20 11 -11 0 -20 -5 -20 -12z"></path><path id="pD0mjwQwC" d="M3953 1520 c0 -30 2 -43 4 -27 2 15 2 39 0 55 -2 15 -4 2 -4 -28z"></path><path id="p1GzsAaOjT" d="M4030 1558 c0 -5 -12 -7 -30 -3 l-30 7 0 -51 0 -51 110 -55 c60 -30 112 -55 115 -55 3 0 5 11 5 24 0 16 -7 27 -20 31 -41 13 -21 30 30 27 43 -3 50 -1 50 15 -1 13 -30 31 -115 70 -63 28 -115 47 -115 41z"></path></g></g><g id="l2UwUCSRxpNzBT7yvtPAhsW" fill="rgb(47,94,168)" style="transform: none;"><g><path id="pf7PHW8me" d="M4130 4959 l0 -181 69 -171 c38 -95 81 -192 95 -217 14 -25 26 -48 26 -51 0 -3 -25 -26 -55 -50 -30 -24 -55 -50 -55 -58 0 -8 -3 -11 -7 -8 -9 9 -43 -23 -43 -40 0 -7 -7 -16 -15 -19 -13 -5 -15 -69 -15 -490 0 -380 3 -484 13 -484 6 0 63 17 124 37 87 29 113 42 113 55 0 10 -7 18 -15 18 -13 0 -15 103 -14 845 0 731 2 845 15 845 7 0 14 -4 14 -10 0 -5 11 -10 24 -10 23 0 24 2 14 34 -9 30 -21 39 -89 71 -43 20 -83 34 -88 31 -12 -8 -91 16 -91 26 0 5 -4 8 -10 8 -6 0 -10 -67 -10 -181z"></path><path id="pbz5cRjLg" d="M4143 2704 c-10 -10 -13 -86 -13 -307 l0 -294 108 -50 107 -50 3 108 3 108 39 3 40 3 -51 115 c-28 63 -70 162 -95 220 -49 113 -64 133 -101 124 -18 -5 -22 -3 -17 9 7 20 -8 28 -23 11z"></path><path id="pic9EGe0Q" d="M4132 1804 c3 -14 266 -140 274 -131 2 2 5 14 6 26 3 21 -9 29 -104 71 -60 27 -108 44 -108 39 0 -5 -11 -9 -25 -9 -14 0 -25 5 -25 10 0 6 -5 10 -11 10 -6 0 -9 -7 -7 -16z"></path><path id="p1A13wDyDJ" d="M4130 1437 l0 -54 109 -56 c60 -32 112 -57 116 -57 4 0 4 20 1 45 -7 41 -5 45 13 45 12 0 21 -7 21 -15 0 -12 13 -15 61 -15 40 0 59 4 57 11 -2 6 -58 36 -123 66 -84 39 -135 56 -170 58 -27 2 -51 8 -53 14 -2 6 -10 11 -18 11 -10 0 -14 -14 -14 -53z"></path></g></g><g id="l7UibmtYpLsoYV8Z0wExin5" fill="rgb(51,102,173)" style="transform: none;"><g><path id="pCy9gXxQC" d="M4331 5047 c-16 -21 -15 -1783 2 -1789 19 -7 270 85 275 101 3 10 -5 12 -37 9 l-41 -4 1 581 c1 319 3 572 6 563 3 -11 14 -18 28 -18 23 0 22 5 -68 275 -51 151 -93 270 -95 265 -2 -6 -13 -10 -24 -10 -15 0 -19 5 -15 20 6 23 -14 27 -32 7z"></path><path id="pe8ubasCk" d="M4321 2200 l-1 -185 120 -52 c66 -28 120 -48 120 -45 0 4 -33 81 -72 173 -60 136 -76 165 -90 161 -20 -5 -25 14 -6 20 19 7 -10 68 -32 68 -9 0 -22 10 -28 23 -8 17 -11 -23 -11 -163z"></path><path id="pUpZuUjEQ" d="M4350 1730 c-8 -5 -18 -6 -22 -4 -4 3 -8 2 -8 -3 0 -10 58 -40 199 -103 88 -39 116 -48 123 -38 18 28 -2 44 -117 94 -144 62 -156 66 -175 54z"></path><path id="p11bFT8Zhl" d="M4355 1399 c-4 -6 -14 -8 -22 -5 -11 5 -13 -5 -11 -52 l3 -57 115 -57 c63 -31 118 -57 123 -57 4 -1 7 10 7 23 0 16 -7 27 -20 31 -30 9 -26 45 4 45 35 0 56 -10 56 -26 0 -10 16 -14 61 -14 41 0 59 4 57 11 -7 20 -260 129 -286 122 -16 -4 -21 -1 -17 8 3 8 -6 19 -22 27 -33 15 -40 15 -48 1z"></path></g></g><g id="lWT41wXhozGsGQQLz0uD5v" fill="rgb(55,110,179)" style="transform: none;"><g><path id="p1Che6mr7A" d="M4500 3981 l0 -658 39 7 c78 14 321 104 321 119 0 11 -11 12 -50 8 l-50 -6 0 154 c0 131 2 155 15 155 8 0 15 -4 15 -10 0 -5 -4 -10 -10 -10 -5 0 -10 -16 -10 -35 0 -33 2 -35 35 -35 19 0 35 2 35 4 0 9 -230 754 -252 816 -18 50 -27 65 -41 62 -19 -4 -24 14 -4 21 7 3 5 6 -5 6 -21 1 -24 17 -5 24 7 3 5 6 -5 6 -21 1 -24 17 -5 24 7 3 5 6 -5 6 -17 1 -18 -37 -18 -658z"></path><path id="p7SAaoSFe" d="M4503 2013 c-18 -7 -16 -23 2 -23 8 0 15 7 15 15 0 8 -1 15 -2 14 -2 0 -9 -3 -15 -6z"></path><path id="p1BpErwCRQ" d="M4492 1954 c-10 -11 -10 -14 0 -14 7 0 23 -3 36 -6 13 -4 22 -2 22 5 0 6 -9 11 -19 11 -11 0 -21 4 -23 9 -1 5 -9 3 -16 -5z"></path><path id="p8c1X87vF" d="M4496 1647 c3 -8 42 -31 87 -52 126 -58 148 -67 164 -61 43 17 -84 102 -134 90 -17 -5 -23 -2 -23 10 0 12 -7 14 -29 10 -16 -3 -38 -1 -50 5 -16 9 -20 9 -15 -2z"></path><path id="p19C9Xb2w0" d="M4500 1262 l0 -59 139 -72 c76 -39 142 -71 145 -71 13 0 5 48 -9 54 -8 3 -15 17 -15 31 0 20 5 25 25 25 15 0 25 -6 25 -14 0 -18 22 -26 71 -26 31 0 39 4 39 18 0 23 -225 124 -258 115 -16 -4 -21 -2 -17 8 3 9 -9 20 -30 30 -19 9 -35 13 -35 8 0 -12 -37 -11 -61 1 -18 10 -19 7 -19 -48z"></path></g></g><g id="l3Lnn9RZXXTpNfvNCKfXAf3" fill="rgb(59,118,185)" style="transform: none;"><g><path id="p02xavSAw" d="M4730 3661 c0 -186 3 -262 12 -267 6 -4 8 -3 5 3 -4 7 20 17 66 27 39 9 77 20 83 24 9 5 1 41 -25 127 -28 92 -41 121 -55 123 -14 3 -15 6 -6 12 21 13 4 80 -20 80 -22 0 -27 16 -7 23 7 3 5 6 -5 6 -10 1 -18 4 -18 7 0 4 8 13 18 20 15 12 15 12 -5 7 -14 -3 -23 -1 -23 6 0 6 5 11 10 11 6 0 10 11 10 25 0 18 -5 25 -20 25 -19 0 -20 -7 -20 -259z"></path><path id="puJC5CNyQ" d="M4732 1145 l3 -60 110 -57 c115 -60 155 -71 155 -40 0 21 -61 164 -75 175 -5 4 -20 5 -32 2 -28 -6 -53 3 -53 21 0 16 2 15 -63 18 l-48 2 3 -61z"></path></g></g></svg>
]]

local logoImage = svgCreate(titleHeight-4, titleHeight-4, logoRaw)

function onRender()
	local currentVehicle = getPedOccupiedVehicle(localPlayer)

	if not currentVehicle then
		panelState = false
		panelStage = false

		removeEventHandler("onClientRender", getRootElement(), onRender)
		removeEventHandler("onClientClick", getRootElement(), onClick)


		return
	end

	
	-- ** Háttér
	dxDrawRectangle(panelPosX, panelPosY, panelWidth, panelHeight, tocolor(25, 25, 25))
	dxDrawImage(panelPosX, panelPosY + titleHeight, panelWidth, panelHeight - titleHeight, ":sm_hud/files/images/vin.png")

	-- ** Cím
	dxDrawRectangle(panelPosX+2, panelPosY+2, panelWidth-4, titleHeight-4, tocolor(35,35,35))
	dxDrawImage(panelPosX, panelPosY, titleHeight-4, titleHeight-4, logoImage)


	if panelStage == "window" then
		dxDrawText("#3d7abcStrong#ffffffMTA", panelPosX + respc(30), panelPosY-respc(3), panelPosX + panelWidth, panelPosY-respc(3) + titleHeight, tocolor(200, 200, 200, 200), 0.9, Raleway, "left", "center", false, false, false, true)
	elseif panelStage == "cveh" then
		dxDrawText("#3d7abcStrong#ffffffMTA", panelPosX + respc(30), panelPosY-respc(3), panelPosX + panelWidth, panelPosY-respc(3) + titleHeight, tocolor(200, 200, 200, 200), 0.9, Raleway, "left", "center", false, false, false, true)
	end

	-- ** Content
	local buttons = {}
	buttonsC = {}

	buttons.exit = {panelPosX + panelWidth - respc(28) - respc(5), panelPosY + titleHeight / 2 - respc(14), respc(28), respc(28)}

	if activeButton == "exit" then
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "cveh/files/close.png", 0, 0, 0, tocolor(215, 89, 89))
	else
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "cveh/files/close.png", 0, 0, 0, tocolor(200, 200, 200,200))
	end

	if panelStage == "window" then
		local oneButtonHeight = (panelHeight - titleHeight) / 4

		for i = 1, 4 do
			local buttonName = "openWindow_" .. i + 1
			local buttonY = panelPosY + titleHeight + oneButtonHeight * (i - 1)

			if i % 2 == 1 then
				dxDrawRectangle(panelPosX, buttonY, panelWidth, oneButtonHeight, tocolor(35, 35, 35,200))
			else
				dxDrawRectangle(panelPosX, buttonY, panelWidth, oneButtonHeight, tocolor(45, 45, 45,200))
			end

			dxDrawText(windowNames[i], panelPosX + respc(10), buttonY, 0, buttonY + oneButtonHeight, tocolor(200, 200, 200, 200), 0.75, Raleway, "left", "center")

			buttons[buttonName] = {panelPosX + panelWidth - respc(100), buttonY + respc(10), respc(90), oneButtonHeight - respc(20)}

			if isVehicleWindowOpen(currentVehicle, i + 1) then
				drawButton(buttonName, "Felhúz", buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], {215, 89, 89, 170}, false, Raleway)
			else
				drawButton(buttonName, "Lehúz", buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], {61, 122, 188, 170}, false, Raleway)
			end
		end
	elseif panelStage == "cveh" then
		local oneButtonHeight = (panelHeight - titleHeight) / 6

		for i = 1, 6 do
			local buttonName = "openDoor_" .. i
			local buttonY = panelPosY + titleHeight + oneButtonHeight * (i - 1)

			if i % 2 == 1 then
				dxDrawRectangle(panelPosX, buttonY, panelWidth, oneButtonHeight, tocolor(35, 35, 35,200))
			else
				dxDrawRectangle(panelPosX, buttonY, panelWidth, oneButtonHeight, tocolor(45, 45, 45,200))
			end

			dxDrawText(doorNames[i], panelPosX + respc(10), buttonY, 0, buttonY + oneButtonHeight, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center")

			buttons[buttonName] = {panelPosX + panelWidth - respc(100), buttonY + respc(10), respc(90), oneButtonHeight - respc(20)}

			if getVehicleDoorOpenRatio(currentVehicle, i - 1) > 0.1 then
				drawButton(buttonName, "Becsuk", buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], {215, 89, 89, 170}, false, Raleway)
			else
				drawButton(buttonName, "Kinyit", buttons[buttonName][1], buttons[buttonName][2], buttons[buttonName][3], buttons[buttonName][4], {61, 122, 188, 170}, false, Raleway)
			end
		end
	end

	-- ** Button handler
	activeButton = false
	activeButtonC = false

	if isCursorShowing() then
		local relX, relY = getCursorPosition()
		local absX, absY = relX * screenX, relY * screenY

		if panelIsMoving then
			panelPosX = absX - moveDifferenceX
			panelPosY = absY - moveDifferenceY
		else
			for k, v in pairs(buttons) do
				if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
					activeButton = k
					break
				end
			end
			for k, v in pairs(buttonsC) do
				if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
					activeButtonC = k
					break
				end
			end
		end
	end
end

function onClick(button, state, absX, absY)
	if button == "left" then
		if state == "down" then
			if absX >= panelPosX and absX <= panelPosX + panelWidth - respc(28) - respc(5) and absY >= panelPosY and absY <= panelPosY + titleHeight then
				panelIsMoving = true
				moveDifferenceX = absX - panelPosX
				moveDifferenceY = absY - panelPosY
			else
				if activeButton then
					if activeButton == "exit" then
						panelState = false
						panelStage = false

						removeEventHandler("onClientRender", getRootElement(), onRender)
						removeEventHandler("onClientClick", getRootElement(), onClick)

					else
						local button = split(activeButton, "_")

						if button[1] == "openWindow" then
							local window = tonumber(button[2])

							if window then
								local currentVehicle = getPedOccupiedVehicle(localPlayer)

								if currentVehicle then
									if not windowTick[window] then
										windowTick[window] = 0
									end

									if getTickCount() - windowTick[window] > 4000 then
										setElementData(currentVehicle, "vehicle.window." .. window, not getElementData(currentVehicle, "vehicle.window." .. window))

										if getElementData(currentVehicle, "vehicle.window." .. window) then
											exports.sm_chat:localActionC(localPlayer, "lehúzza a " .. utf8.lower(windowNames[window - 1]) .. "ot.")
										else
											exports.sm_chat:localActionC(localPlayer, "felhúzza a " .. utf8.lower(windowNames[window - 1]) .. "ot.")
										end

										local windowState = false

										for i = 2, 5 do
											if getElementData(currentVehicle, "vehicle.window." .. i) then
												windowState = true
												break
											end
										end

										setElementData(currentVehicle, "vehicle.windowState", not windowState)

										local playerX, playerY, playerZ = getElementPosition(localPlayer)
										local players = getElementsByType("player", getRootElement(), true)
										local affected = {}

										for i = 1, #players do
											local player = players[i]

											if player ~= localPlayer then
												if getPedOccupiedVehicle(player) == currentVehicle then
													table.insert(affected, {player, "2d"})
												else
													local targetX, targetY, targetZ = getElementPosition(player)

													if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 10 then
														table.insert(affected, {player, "3d"})
													end
												end
											end
										end

										if #affected > 0 then
											triggerServerEvent("playWindowSound", currentVehicle, affected)
										end

										playSound("cveh/files/window.mp3")

										windowTick[window] = getTickCount()
									end
								end
							end
						elseif button[1] == "openDoor" then
							local door = tonumber(button[2])

							if door then
								local currentVehicle = getPedOccupiedVehicle(localPlayer)

								if currentVehicle then
									local players = getElementsByType("player", getRootElement(), true)
									local occupants = {}
									local affected = {}

									for i = 1, #players do
										local player = players[i]

										if getPedOccupiedVehicle(player) == currentVehicle then
											table.insert(occupants, player)
										else
											table.insert(affected, player)
										end
									end

									if not doorTick[door] then
										doorTick[door] = 0
									end

									if getTickCount() - doorTick[door] >= 750 then
										triggerServerEvent("openTheVehicleDoor", currentVehicle, door - 1, occupants, affected)

										if getVehicleDoorOpenRatio(currentVehicle, door - 1) > 0 then
											exports.sm_chat:localActionC(localPlayer, "becsukja a " .. utf8.lower(doorNames[door]) .. "t.")
										else
											exports.sm_chat:localActionC(localPlayer, "kinyitja a " .. utf8.lower(doorNames[door]) .. "t.")
										end

										doorTick[door] = getTickCount()
									end
								end
							end
						end
					end
				end
			end
		else
			if state == "up" then
				panelIsMoving = false
				moveDifferenceX = 0
				moveDifferenceY = 0
			end
		end
	end
end

addEvent("playDoorSound", true)
addEventHandler("playDoorSound", getRootElement(),
	function (vehicleElement, doorRatio, inVehicle)
		if doorRatio > 0 then
			setTimer(
				function (sourceElement)
					local soundPath = exports.sm_vehiclepanel:getDoorCloseSound(getElementModel(sourceElement))

					if soundPath then
						if inVehicle and not isElement(vehicleElement) then
							playSound(soundPath)
						else
							local vehX, vehY, vehZ = getElementPosition(vehicleElement)
							local soundEffect = playSound3D(soundPath, vehX, vehY, vehZ)

							attachElements(soundEffect, vehicleElement)
							setElementInterior(soundEffect, getElementInterior(vehicleElement))
							setElementDimension(soundEffect, getElementDimension(vehicleElement))
						end
					end
				end,
			250, 1, source)
		else
			local soundPath = exports.sm_vehiclepanel:getDoorOpenSound(getElementModel(source))

			if soundPath then
				if inVehicle and not isElement(vehicleElement) then
					playSound(soundPath)
				else
					local vehX, vehY, vehZ = getElementPosition(vehicleElement)
					local soundEffect = playSound3D(soundPath, vehX, vehY, vehZ)

					attachElements(soundEffect, vehicleElement)
					setElementInterior(soundEffect, getElementInterior(vehicleElement))
					setElementDimension(soundEffect, getElementDimension(vehicleElement))
				end
			end
		end
	end
)