addEvent("giveMoney", true)
addEventHandler("giveMoney", resourceRoot, function(money)
    exports.sm_core:giveMoney(client, money, "cashierJob")
end)