addEvent("cryptoAddItem", true)
function cryptoAddItem(item, player, money, performance, tdp, name)
    if item and player and money then
        if getElementData(player, "char.Money") >= money then
            if exports.sm_items:hasSpaceForItem(player, item, 1) then
                exports.sm_items:giveItem(player, item, 1, false, toJSON({performance, tdp, name}))
                exports.sm_core:takeMoney(player, money)
            else
                outputChatBox("#3d7abc[StrongMTA]#ffffff A kiválasztott alkatrész nem fért el nálad!", player, 255, 255, 255, true)
            end
        else
            outputChatBox("#3d7abc[StrongMTA]#ffffff Nincs elég pénzed!", player, 255, 255, 255, true)
        end
    end
end
addEventHandler("cryptoAddItem", root, cryptoAddItem)