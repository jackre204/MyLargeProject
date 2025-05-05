addEventHandler("onResourceStart", getResourceRootElement(),
    function()
        for k, v in ipairs(trashPositions) do
            local trashOBJ = createObject(1439, v[1], v[2], v[3] - 1.07)
            local trashCol = createColSphere(v[1], v[2], v[3], 0.8)

            attachElements(trashCol, trashOBJ, 0, 0.5, 1)
            --setElementData(trashCol, "trashColOf", true)
            setElementData(trashCol, "trashColOf", trashOBJ)
        end
    end
)

addEvent("attachTheTrash", true)
addEventHandler("attachTheTrash", getRootElement(),
    function(trashObject)
        if trashObject then
            if isElement(trashObject) then
                attachElements(trashObject, source, 0, 1, - 1, 0, 0, 180)
            end
        end
    end
)