addEvent("onLightning", true)
addEventHandler("onLightning", getRootElement(), function(boltX, boltY, boltZ)
	triggerClientEvent("onLightning", source, boltX, boltY, boltZ)
end)