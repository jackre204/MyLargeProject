local playerActiveJobs = {}

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		if playerActiveJobs[source] then
			playerActiveJobs[source] = nil
		end
	end
)

addEvent("startFuelJob", true)
addEventHandler("startFuelJob", getRootElement(),
	function ()
		if isElement(client) then
			local activeJob = playerActiveJobs[client]

			if not activeJob then
				playerActiveJobs[client] = {}

				playerActiveJobs[client].startDestinationId = math.random(1, #startDestinations)
				playerActiveJobs[client].finalDestinationId = math.random(1, #finalDestinations)

				activeJob = playerActiveJobs[client]
			end

			triggerClientEvent(client, "receiveFuelDeliveryJob", client, activeJob)
		end
	end
)
