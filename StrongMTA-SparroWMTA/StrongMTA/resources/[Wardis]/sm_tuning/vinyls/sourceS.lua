local core = exports.sm_core
local connection = exports.sm_database:getConnection()

addEvent("takeMoneyFromPlayer",true)
addEventHandler("takeMoneyFromPlayer",resourceRoot,
	function(player,dataend,amount)
		setElementData(player,"char." .. dataend,getElementData(player,"char." .. dataend)-amount)
	end
)
