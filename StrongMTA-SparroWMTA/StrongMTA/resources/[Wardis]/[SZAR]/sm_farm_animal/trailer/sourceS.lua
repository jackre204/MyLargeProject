local vehicleHooks = {}

function callClientClickToTrailer(player,trailer)
    local veh = getPedOccupiedVehicle(
        player
    )
      if getVehicleTowedByVehicle(veh) == trailer then
        detachTrailerFromVehicle(veh)
     else
        attachTrailerToVehicle(
          veh,
          trailer
        )
    end
end
addEvent(
    "callClientClickToTrailer",
    true
)
addEventHandler(
    "callClientClickToTrailer",
    root,
    callClientClickToTrailer
)

function createHookToVehicle()
    for _,veh in ipairs(getElementsByType("vehicle")) do
        if compatibleVeh[getElementModel(veh)] then
            local pos = Vector3(
                unpack(
                    hookPos[
                        getElementModel(
                            veh
                        )
                    ]
                )
            )
            vehicleHooks[veh] = createObject(
                4244,
                getElementPosition(veh)
            )
            setElementCollisionsEnabled(
              vehicleHooks[veh],
              false
            )
            attachElements(
                vehicleHooks[veh],
                veh,
                pos.x,
                pos.y,
                pos.z
            )
        end
    end
end
addEventHandler("onResourceStart",resourceRoot,createHookToVehicle)

addEventHandler("onElementClicked",root,function(key,state,player)
    if getElementType(source) == "vehicle" then
        attachTrailerToVehicle(
            getPedOccupiedVehicle(player),
            source
        )
        setElementData(player, "player.trailer", source)
    end
end
)


