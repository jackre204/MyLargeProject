function registerEvent(eventName, attachedTo, handlerFunction)
	addEvent(eventName, true)
	addEventHandler(eventName, attachedTo, handlerFunction)
end