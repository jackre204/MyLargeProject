local lastTick = getTickCount()
local s = {guiGetScreenSize()}
local ar_timer

function toggleAirride(cmd,level)
	if isTimer(ar_timer) then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local airride = getElementData(vehicle,"danihe->tuning->airride") or 0
		local airride_level = getElementData(vehicle,"danihe->tuning->airride_level") or 3
		if airride > 0 then
			if tonumber(level) then
				level = tonumber(level)
				if level >= 0 and level <= 5 then
					if level == airride_level then
						outputChatBox("#d64c45[Hiba történt]:#dedede Jelenleg is ezen az #d6af42airride#dedede szinten van a járműved! #d6af42(" .. level .. ")",0,0,0,true)
					else
						if getElementSpeed(vehicle,2) > 0 then
							outputChatBox("#d64c45[Hiba történt]:#dedede Nem állíthatsz  #d6af42airride#dedede-ot menet közben!",0,0,0,true)
						else
							if getElementData(vehicle,"vehicle.handbrake") then
								outputChatBox("#d64c45[Hiba történt]:#dedede Behúzott #d6af42kézifékkel#dedede nem használható az #d6af42airride!",0,0,0,true)
							else
								triggerServerEvent("changeAirrideLevel",resourceRoot,localPlayer,vehicle,airride_level,level)
								ar_timer = setTimer(function() end,2000,1)
							end
						end
					end
				else
					outputChatBox("#d64c45[Hiba történt]:#dedede Hibás #d6af42airride#dedede szint lett megadva! #d6af42(" .. level .. ")",0,0,0,true)
				end
			else
				outputChatBox("#d6af42[Használat]:#dedede /" .. cmd .. " [Szint (0-5)]",0,0,0,true)
				outputChatBox("#dededeJelenlegi #d6af42airride#dedede szint: #d6af42" .. airride_level,0,0,0,true)
			end
		end
	end
end
addCommandHandler("airride",toggleAirride)
addCommandHandler("ar",toggleAirride)
addCommandHandler("air",toggleAirride)

addEvent("playbackAirride",true)
addEventHandler("playbackAirride",localPlayer,
	function(vehicle)
		playSound3D("sounds/airride.ogg",Vector3(getElementPosition(vehicle)))
	end
)