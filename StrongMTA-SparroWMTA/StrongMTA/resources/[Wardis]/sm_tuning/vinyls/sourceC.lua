local lastTick = getTickCount()
local s = {guiGetScreenSize()}

local texture_size = 512 -- Kocsira ráhúzandó UV-Map méret

local main_render_target = dxCreateRenderTarget(texture_size,texture_size,true)
local vehicle_render_target

local stickersTextures = {}
local selectionTexture
-- renderTarget pool a gyorsabb matrica rendereléshez
local poolSize = 10
local renderTargetPool = {}
local usedRenderTargets = {}

function getVehicleRenderTarget(vehicle)
	if not vehicle then
		-- Nem létező jármű
		return false
	end

	if isElement(usedRenderTargets[vehicle]) then
		return usedRenderTargets[vehicle]
	end
	
	if #renderTargetPool == 0 then
		outputDebugString("UV-Map: renderTargetPool tábla üres. Alap render_target használata.")
		return mainRenderTarget
	end

	usedRenderTargets[vehicle] = table.remove(renderTargetPool, 1)
	return usedRenderTargets[vehicle]
end

function freeVehicleRenderTarget(vehicle)
	if not vehicle then
		return false
	end
	if usedRenderTargets[vehicle] then
		table.insert(renderTargetPool, usedRenderTargets[vehicle])
		usedRenderTargets[vehicle] = nil
		return true
	end
	return false
end

function removeLastSticker(vehicle)
	if isElement(vehicle) then
		local stickers = getElementData(vehicle,"danihe->vehicles->stickers") or {}
		if #stickers > 0 then
			table.remove(stickers,#stickers)
		end
		setElementData(vehicle,"danihe->vehicles->stickers",stickers)
	end
end

function addNewSticker(vehicle,dir,id)
	if isElement(vehicle) then
		local stickers = getElementData(vehicle,"danihe->vehicles->stickers") or {}
		local x,y,rot = defPaintjob.x,defPaintjob.y,defPaintjob.rot
		if paintjobDefaults[getElementModel(vehicle)] then
			x,y,rot = paintjobDefaults[getElementModel(vehicle)].x,paintjobDefaults[getElementModel(vehicle)].y,paintjobDefaults[getElementModel(vehicle)].rot
		end
		table.insert(stickers,#stickers+1,
			{
				x,
				y,
				256,
				256,
				dir,
				id,
				rot,
				tocolor(255,255,255),
				true,
				false,
				false,
				false,
			}
		)
		setElementData(vehicle,"danihe->vehicles->stickers",stickers)
	end
end

local function drawSticker(sticker)
	local x,y,w,h,stickerDir,stickerId,rotation,color,selected,border,mirrorX,mirrorY = unpack(sticker)
	local texture = stickersTextures[tostring(stickerDir) .. "/" .. tostring(stickerId)]
	if not isElement(texture) then
		stickersTextures[tostring(stickerDir) .. "/" .. tostring(stickerId)] = dxCreateTexture("stickers/" .. tostring(stickerDir) .. "/" .. tostring(stickerId) .. ".dds","dxt5",true,"clamp")
		texture = stickersTextures[tostring(stickerDir) .. "/" .. tostring(stickerId)]
	end

	if mirrorX then
		if mirrorY then
			if border then
				dxDrawImage(x+w/2+1,y+h/2+1,-w,-h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x+w/2+1,y+h/2-1,-w,-h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x+w/2-1,y+h/2+1,-w,-h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x+w/2-1,y+h/2-1,-w,-h,texture,rotation,0,0,tocolor(0,0,0,255))
			end
			dxDrawImage(x+w/2,y+h/2,-w,-h,texture,rotation,0,0,color)
		else
			if border then
				dxDrawImage(x+w/2+1,y-h/2+1,-w,h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x+w/2+1,y-h/2-1,-w,h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x+w/2-1,y-h/2+1,-w,h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x+w/2-1,y-h/2-1,-w,h,texture,rotation,0,0,tocolor(0,0,0,255))
			end
			dxDrawImage(x+w/2,y-h/2,-w,h,texture,rotation,0,0,color)
		end
	else
		if mirrorY then
			if border then
				dxDrawImage(x-w/2+1,y+h/2+1,w,-h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x-w/2+1,y+h/2-1,w,-h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x-w/2-1,y+h/2+1,w,-h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x-w/2-1,y+h/2-1,w,-h,texture,rotation,0,0,tocolor(0,0,0,255))
			end
			dxDrawImage(x-w/2,y+h/2,w,-h,texture,rotation,0,0,color)
		else
			if border then
				dxDrawImage(x-w/2+1,y-h/2+1,w,h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x-w/2+1,y-h/2-1,w,h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x-w/2-1,y-h/2+1,w,h,texture,rotation,0,0,tocolor(0,0,0,255))
				dxDrawImage(x-w/2-1,y-h/2-1,w,h,texture,rotation,0,0,tocolor(0,0,0,255))
			end
			dxDrawImage(x-w/2,y-h/2,w,h,texture,rotation,0,0,color)
		end
	end

	if selected then
		w = w+15
		h = h+15
		dxDrawImage(x-w/2,y-h/2,w,h,selectionTexture,rotation,0,0,tocolor(255,255,255,255))
	end
end
	
function redrawBodyRenderTarget(renderTarget, bodyColor, bodyTexture, stickers, selected)
	if not isElement(renderTarget) then
		return
	end
	if not selected then
		selected = 0
	end
	dxSetRenderTarget(renderTarget, true)
	if bodyColor then
		dxDrawRectangle(0,0,texture_size,texture_size,tocolor(bodyColor[1], bodyColor[2], bodyColor[3]))
	end
	if type(stickers) == "table" then
		for i,sticker in ipairs(stickers) do
			drawSticker(sticker, selected == i)
		end
	end
	dxSetRenderTarget()
end

function setupVehicleTexture(vehicle)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) or isElementLocal(vehicle) then
		return
	end

	local bodyColor = getElementData(vehicle,"danihe->vehicles->bodyColor") or {255,255,255}
	local bodyTexture = false
	local stickers = getElementData(vehicle,"danihe->vehicles->stickers") or {}

	local renderTarget = getVehicleRenderTarget(vehicle)
	-- Matricák kirajzolása render targetből
	redrawBodyRenderTarget(renderTarget, bodyColor, bodyTexture, stickers)
	local texture
	if renderTarget == mainRenderTarget then
		-- Alap rendertarget használat. Másoljuk a tartalmát textúrába
		local pixels = dxGetTexturePixels(mainRenderTarget)
		local texture = dxCreateTexture(texture_size, texture_size)
		dxSetTexturePixels(texture, pixels)
		VehicleShaders.replaceTexture(vehicle,avaiblePaintjobs[getElementModel(vehicle)],texture)
		destroyElement(texture)
	else
		VehicleShaders.replaceTexture(vehicle,avaiblePaintjobs[getElementModel(vehicle)],renderTarget)
	end
end

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		selectionTexture = dxCreateTexture("textures/selection.dds")

		local dxStatus = dxGetStatus()
		--dxStatus.VideoMemoryFreeForMTA = 100

		if dxStatus.VideoMemoryFreeForMTA >= 300 then
			for i = 1,poolSize do
				local renderTarget = dxCreateRenderTarget(texture_size, texture_size)
				if isElement(renderTarget) then
					table.insert(renderTargetPool, renderTarget)
				else
					break
				end
			end
		else
			renderTargetPool = {}
		end
		--<< UV-Map betöltése járművekre (Autókra..) >>--
		for i, vehicle in ipairs(getElementsByType("vehicle")) do
			if getVehicleType(vehicle) == "Automobile" then
				if avaiblePaintjobs[getElementModel(vehicle)] then -- Ha van rá elérhető UV-Map-olási lehetőség
					setupVehicleTexture(vehicle)
				end
			end
		end
	end
)

addEventHandler("onClientElementDataChange",root,
	function(dataName,oldValue)
		if getElementType(source) ~= "vehicle" then
			return
		end
		if isElement(vehicleRenderTarget) then
			return
		end
		if dataName == "danihe->vehicles->stickers" or dataName == "danihe->vehicles->bodyColor" then
			if avaiblePaintjobs[getElementModel(source)] then
				setupVehicleTexture(source)
			end
		end
	end
)

addEventHandler("onClientRestore",root,
	function()
		for i, vehicle in ipairs(getElementsByType("vehicle")) do
			if avaiblePaintjobs[getElementModel(vehicle)] then
				setupVehicleTexture(vehicle)
			end
		end
	end
)

addEventHandler("onClientElementStreamIn",root,
	function()
		if getElementType(source) == "vehicle" then
			if avaiblePaintjobs[getElementModel(source)] then
				setupVehicleTexture(source)
			end
		end
	end
)

addEvent("shadersDestroyed", false)
addEventHandler("shadersDestroyed", root, function ()
	freeVehicleRenderTarget(source)
end)