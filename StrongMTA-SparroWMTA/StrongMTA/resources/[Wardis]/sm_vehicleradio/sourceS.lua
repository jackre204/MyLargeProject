registerEvent("playVehicleMovie", getRootElement(),
	function (url, fromMovieList)
		if isElement(source) and url then
			local defaultURL = url
			local url = url:gsub("&list=(.+)", "") or url
			local id = url:match("v=(.+)&") or url:match("v=(.+)#") or url:match("v=(.+)") or url:match("tu.be/(.+)#") or url:match("tu.be/(.+)?") or url:match("tu.be/(.+)")

			--id = url

			if url and id then
				local affected = {}

				for k, v in pairs(getElementsByType("player")) do
					table.insert(affected, v)
				end

				setElementData(source, "vehicleStreamURL", id, false)
				setElementData(source, "vehicleStartTime", getRealTime().timestamp, false)
				triggerClientEvent(affected, "playVehicleMovie", source, id, true)
				--
				fetchRemote("https://noembed.com/embed?url=" .. defaultURL, nameCallBack, "", false, source)
			else
				outputChatBox("Érvénytelen URL! Kérlek próbálj másikat.")
			end
		end
	end
)

function nameCallBack(responseData, error, vehicleElement)
    if error == 0 then
		local dataTable = (responseData)

		local nameData = {fromJSON(dataTable).author_name, fromJSON(dataTable).title}
		setElementData(vehicleElement, "vehicle.ytMusicName", nameData)
        --triggerClientEvent( playerToReceive, "onClientGotImage", resourceRoot, responseData )
    end
end

registerEvent("requestVehicleMovie", getRootElement(),
	function ()
		if isElement(source) then
			local streamURL = getElementData(source, "vehicleStreamURL")
			local startTime = getElementData(source, "vehicleStartTime") or getRealTime().timestamp

			if streamURL and startTime then
				triggerClientEvent(client, "playVehicleMovie", source, streamURL, getRealTime().timestamp - startTime)
			end
		end
	end
)

registerEvent("stopVehicleMovie", getRootElement(),
	function()
		if isElement(source) then
			local affected = {}

			for k, v in pairs(getElementsByType("player")) do
                table.insert(affected, v)
            end

			removeElementData(source, "vehicleStreamURL")
			removeElementData(source, "vehicleStartTime")
			removeElementData(source, "vehicle.ytMusicName")

			triggerClientEvent(affected, "playVehicleMovie", source, false, false)
		end
	end
)