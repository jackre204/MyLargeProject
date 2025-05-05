local lastTick = getTickCount()
local s = {guiGetScreenSize()}

local vehicle_neons = {}

addEventHandler("onClientRender",root,
	function()
		for vehicle,table in pairs(vehicle_neons) do
			local int,dim = getElementInterior(vehicle),getElementDimension(vehicle)
			--local int2,dim2 = getElementInterior(object["left"])
			--outputChatBox(object["left"])
			for name,object in pairs(table) do
				local int2,dim2 = getElementInterior(object),getElementDimension(object)
				if int ~= int2 then
					setElementInterior(object,int)
				end
				if dim ~= dim2 then
					setElementDimension(object,dim)
				end
			end
		end
	end
)

function addNeon(vehicle)
	if vehicle then
		if isElementStreamedIn(vehicle) then
			local neon_id = getElementData(vehicle,"danihe->vehicles->neon") or 0
			if neon_objects[neon_id] then
				if vehicle_neons[vehicle] then
					removeNeon(vehicle)
					addNeon(vehicle)
				else
					vehicle_neons[vehicle] = {}

					local pos = Vector3(getElementPosition(vehicle))

					vehicle_neons[vehicle]["left"] = createObject(neon_objects[neon_id],pos.x,pos.y,pos.z)
					setElementInterior(vehicle_neons[vehicle]["left"],getElementInterior(vehicle))
					setElementDimension(vehicle_neons[vehicle]["left"],getElementDimension(vehicle))
					setElementCollisionsEnabled(vehicle_neons[vehicle]["left"],false)
					attachElements(vehicle_neons[vehicle]["left"],vehicle,-0.9,0,-0.5,0,0,0)

					vehicle_neons[vehicle]["right"] = createObject(neon_objects[neon_id],pos.x,pos.y,pos.z)
					setElementInterior(vehicle_neons[vehicle]["right"],getElementInterior(vehicle))
					setElementDimension(vehicle_neons[vehicle]["right"],getElementDimension(vehicle))
					setElementCollisionsEnabled(vehicle_neons[vehicle]["right"],false)
					attachElements(vehicle_neons[vehicle]["right"],vehicle,0.9,0,-0.5,0,0,0)
				end
			else
				if vehicle_neons[vehicle] then
					removeNeon(vehicle)
				end
			end
		end
	end
end

function removeNeon(vehicle)
	if vehicle then
		if vehicle_neons[vehicle] then
			destroyElement(vehicle_neons[vehicle]["left"])
			destroyElement(vehicle_neons[vehicle]["right"])
			vehicle_neons[vehicle] = nil
		end
	end
end

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		for k,v in ipairs(getElementsByType("vehicle")) do
			if isElementStreamedIn(v) then
				addNeon(v)
			end
		end
	end
)

addEventHandler("onClientElementStreamIn",root,
	function()
		if getElementType(source) == "vehicle" then
			addNeon(source)
		end
	end
)

addEventHandler("onClientElementStreamOut",root,
	function()
		if getElementType(source) == "vehicle" then
			removeNeon(source)
		end
	end
)

addEventHandler("onClientElementDestroy",root,
	function()
		if getElementType(source) == "vehicle" then
			removeNeon(source)
		end
	end
)


addEventHandler("onClientElementDataChange",root,
	function(data)
		if getElementType(source) == "vehicle" and isElementStreamedIn(source) then
			if data == "danihe->vehicles->neon" then
				addNeon(source)
			end
		end
	end
)