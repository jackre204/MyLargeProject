local messages = {
	"asd tip",
}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		setTimer(doMsg, 1000 * 60 * 60, 0)
		doMsg()
	end
)

local doTips = true

addCommandHandler("togtips",
	function ()
		if doTips then
			doTips = false
			outputChatBox("#3d7abc[StrongMTA]: #ffffffKikapcsoltad a tippeket.", 255, 255, 255, true)
		else
			doTips = true
			outputChatBox("#3d7abc[StrongMTA]: #ffffffBekapcsoltad a tippeket.", 255, 255, 255, true)
		end
	end)

function doMsg()
	if doTips then
		local message = messages[math.random(1, #messages)]
		if message then
			outputChatBox("#3d7abc[StrongMTA - Segítség]: #ffffff" .. message, 255, 255, 255, true)
		end
	end
end