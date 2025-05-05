addEvent("setPedAnimationPanel", true)
addEventHandler("setPedAnimationPanel", getRootElement(),
	function (block, anim, loop)
		if isElement(source) then
			if loop then
				setPedAnimation(source, block, anim, -1, true, false, false)
			else
				setPedAnimation(source, block, anim, 0, false, false, false)
			end
		end
	end
)

addEvent("stopThePanelAnimation", true)
addEventHandler("stopThePanelAnimation", getRootElement(),
	function ()
		if isElement(source) then
			setPedAnimation(source, false)
			setPedAnimation(source, "bd_fire", "bd_fire1", 0, false, false, false)
		end
	end
)

