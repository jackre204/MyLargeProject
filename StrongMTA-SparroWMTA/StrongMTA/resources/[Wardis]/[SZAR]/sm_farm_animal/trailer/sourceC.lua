local lockImage = dxCreateTexture(
    "files/lock.png"
)
local unlockImage = dxCreateTexture(
    "files/unlock.png"
)

function renderTrailerDX()
    if getPedOccupiedVehicleSeat(localPlayer) == 0 then
        if getElementSpeed(getPedOccupiedVehicle(localPlayer)) == 0 then
            for _,veh in pairs(getElementsByType("vehicle",root,true)) do
                if trailerTable[getElementModel(veh)] then
                    if compatibleVeh[getElementModel(getPedOccupiedVehicle(localPlayer))] then
                        w = Vector3(
                            getVehicleComponentPosition(
                                veh,
                                "misc_a",
                                "world"
                            )
                        )
                        p = Vector3(
                            getVehicleComponentPosition(
                                getPedOccupiedVehicle(
                                    localPlayer
                                ),
                                "bump_rear_dummy",
                                "world"
                            )
                        )
                        if w.x and w.y and w.z then 
                            pos = Vector2(
                                getScreenFromWorldPosition(
                                    w.x,
                                    w.y,
                                    w.z+1
                                )
                            )
                            if getDistanceBetweenPoints3D(w.x,w.y,w.z,p.x,p.y,p.z) <= 3 then
                                if pos.x and pos.y then
                                    dxDrawRectangle(
                                        pos.x,
                                        pos.y,
                                        50,
                                        50,
                                        tocolor(25,25,25,255)
                                    )
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
addEventHandler(
    "onClientRender",
    root,
    renderTrailerDX
)
local clickTimer = false


function trailerClick(key,state)
    if key == "left" and state == "down" then
        if getPedOccupiedVehicleSeat(localPlayer) == 0 then
            if getElementSpeed(getPedOccupiedVehicle(localPlayer)) == 0 then
                for _,veh in pairs(getElementsByType("vehicle",root,true)) do
                    if trailerTable[getElementModel(veh)] then
                        if compatibleVeh[getElementModel(getPedOccupiedVehicle(localPlayer))] then
                            w = Vector3(
                                getVehicleComponentPosition(
                                    veh,
                                    "misc_a",
                                    "world"
                                )
                            )
                            p = Vector3(
                                getVehicleComponentPosition(
                                    getPedOccupiedVehicle(
                                        localPlayer
                                    ),
                                    "bump_rear_dummy",
                                    "world"
                                )
                            )
                            if w.x and w.y and w.z then 
                                pos = Vector2(
                                    getScreenFromWorldPosition(
                                        w.x,
                                        w.y,
                                        w.z+1
                                    )
                                )
                                if getDistanceBetweenPoints3D(w.x,w.y,w.z,p.x,p.y,p.z) <= 3 then
                                    if pos.x and pos.y then
                                        if isMouseInPosition(pos.x,pos.y,50,50) then
                                            triggerServerEvent(
                                                "callClientClickToTrailer",
                                                root,
                                                localPlayer,
                                                veh
                                            )
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
addEventHandler(
    "onClientClick",
    root,
    trailerClick
)