registerEvent("vehicle:playTvMovie", getRootElement(),
	function (url, vehicle, fromMovieList)
		if isElement(source) and url and vehicle then
			local url = url:gsub("&list=(.+)", "") or url
			local id = url:match("v=(.+)&") or url:match("v=(.+)#") or url:match("v=(.+)") or url:match("tu.be/(.+)#") or url:match("tu.be/(.+)?") or url:match("tu.be/(.+)")

			if fromMovieList then
				id = url
			end

			if url and id then
				local affected = {}

				for k, v in pairs(getElementsByType("player")) do
					if getPedOccupiedVehicle(v) == vehicle then
						table.insert(affected, v)
					end
				end

				setElementData(source, "tvStreamURL", id, false)
				setElementData(source, "tvStartTime", getRealTime().timestamp, false)

				triggerClientEvent(affected, "vehicle:playTvMovie", source, id, true)
			else
				--exports.sm_hud:showInfobox(client, "e", "Érvénytelen URL! Kérlek próbálj másikat.")

                print("Érvénytelen URL! Kérlek próbálj másikat.")
			end
		end
	end
)

registerEvent("vehicle:requestTvMovie", getRootElement(),
	function ()
		if isElement(source) then
			local streamURL = getElementData(source, "tvStreamURL")
			local startTime = getElementData(source, "tvStartTime") or getRealTime().timestamp

			if streamURL and startTime then
				triggerClientEvent(client, "vehicle:playTvMovie", source, streamURL, getRealTime().timestamp - startTime)
			end
		end
	end
)

registerEvent("vehicle:stopTvMovie", getRootElement(),
	function (interiorId)
		if isElement(source) and interiorId then
			local affected = {}

			for k, v in pairs(getElementsByType("player")) do
				if getPedOccupiedVehicle(v) == vehicle then
					table.insert(affected, v)
				end
			end

			removeElementData(source, "tvStreamURL")
			removeElementData(source, "tvStartTime")

			triggerClientEvent(affected, "vehicle:playTvMovie", source, false, false)
		end
	end
)