addCommandHandler("backon",
    function(player,cmd)
        setElementData(getPedOccupiedVehicle(player),"vehicle.backfire",1)
        outputChatBox("backfire berakva")
    end
)
addCommandHandler("backof",
    function(player,cmd)
        setElementData(getPedOccupiedVehicle(player),"vehicle.backfire",0)
        outputChatBox("backfire kiszedve")
    end
)

addEvent("onBackFire",true)
addEventHandler("onBackFire",getRootElement(),
    function(player)
        if isElement(source) and getElementType(source) == "vehicle" then
            triggerClientEvent(player, "onBackFire", source)
        end
    end
)
