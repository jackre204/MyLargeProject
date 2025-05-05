addEvent("addObjToTrailer", true)
function addObjToTrailer(player, trailer)
    for i = 1, getElementData(player, "farmOrdered")[2] do
        iprint(getElementData(player, "farmOrdered")[3])
        local obj = createObject(getElementData(player, "farmOrdered")[3], 0, 0, 0)
        if getElementData(player, "farmOrdered")[1] == "Szalma" then
            setObjectScale(obj, 2.1)
        end
        if i >= 3 then
            attachElements(obj, trailer, 0, - 0.7, (i - 3) / 2)
        else
            attachElements(obj, trailer, 0, 0, (i - 1) / 2)
        end
    end
end
addEventHandler("addObjToTrailer", root, addObjToTrailer)

addEvent("removeOrderedThings", true)
function removeOrderedThings(trailer, player)
    if trailer then
        local dimid = getElementData(trailer, "trailer.load")[4]
        local attachedElements = getAttachedElements(trailer)
        for k, v in pairs(attachedElements) do
            if getElementType(v) == "object" then
                destroyElement(v)
            end
        end
        triggerEvent("addCargoToFarm", player, getElementData(trailer, "trailer.load"), getElementData(trailer, "trailer.load")[4])
    end
end
addEventHandler("removeOrderedThings", root, removeOrderedThings)