local lastTick = getTickCount()
local s = {guiGetScreenSize()}

VehicleShaders = {}

local shaders = {}
local reflectionTexture

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		reflectionTexture = dxCreateTexture("textures/reflection.dds")
	end
)

function VehicleShaders.replaceTexture(vehicle, textureName, texture)
	if not isElement(vehicle) or type(textureName) ~= "string" or not isElement(texture) then
		return false
	end
	local shaderName = "texture_" .. tostring(textureName)
	if not shaders[shaderName] then
		shaders[shaderName] = {}
	end
	local shader = shaders[shaderName][vehicle]
	if isElement(shader) then
		destroyElement(shader) 
		shader = nil
	end
	if not isElement(shader) then
		shader = dxCreateShader("shaders/replace.fx")
	end
	if not shader then
		return false
	end
	engineApplyShaderToWorldTexture(shader,textureName,vehicle)
	dxSetShaderValue(shader,"gTexture",texture)
	setElementData(shader,"shader_type","texture",false)
	shaders[shaderName][vehicle] = shader
	return true
end

local function destroyVehicleShaders(vehicle)
	for shaderName in pairs(shaders) do
		local shader = shaders[shaderName][vehicle]
		if isElement(shader) then
			destroyElement(shader)
		end
	end
	triggerEvent("shadersDestroyed", vehicle)
end

addEventHandler("onClientElementDestroy",root,
	function()
		if getElementType(source) == "vehicle" then
			destroyVehicleShaders(source)
		end
	end
)

addEventHandler("onClientElementStreamOut",root,
	function()
		if getElementType(source) == "vehicle" then
			destroyVehicleShaders(source)
		end
	end
)

addEventHandler("onClientVehicleExplode",root,
	function()
		if getElementType(source) == "vehicle" then
			destroyVehicleShaders(source)
		end
	end
)

addEventHandler("onClientMinimize",root,
	function()
		for k,v in ipairs(getElementsByType("vehicle")) do
			if isElementStreamedIn(v) then
				destroyVehicleShaders(v)
			end
		end
	end
)