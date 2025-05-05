local SizeX, SizeY = guiGetScreenSize()
local px,py = 1920,1080
local x,y = (SizeX/px), (SizeY/py)

local screenW, screenH = guiGetScreenSize()

local font1 = dxCreateFont('/assets/fonts/font1.ttf', 20, true)
local font2 = dxCreateFont('/assets/fonts/font2.ttf', 20, true)
local font3 = dxCreateFont('/assets/fonts/font1.ttf', 40, true)

local shaderMask = dxCreateShader('/assets/shaders/hud_mask.fx')
local shaderMask_2 = dxCreateShader('/assets/shaders/hud_mask.fx')
local shaderMask_3 = dxCreateShader('/assets/shaders/hud_mask.fx')

local speed_mask = dxCreateTexture('/assets/img/speed_mask.png')
local speed_mask_1 = dxCreateTexture('/assets/img/speed1_1.png')
local speed_mask_2 = dxCreateTexture('/assets/img/speed1_2.png')
local speed_mask_3 = dxCreateTexture('/assets/img/speed1_3.png')
local speed_mask_4 = dxCreateTexture('/assets/img/speed1_4.png')
local speed_mask_5 = dxCreateTexture('/assets/img/speed1_5.png')

local speed_mask2 = dxCreateTexture('/assets/img/speed2_mask.png')
local speed_mask_2_1 = dxCreateTexture('/assets/img/speed2_1.png')
local speed_mask_2_2 = dxCreateTexture('/assets/img/speed2_2.png')
local speed_mask_2_3 = dxCreateTexture('/assets/img/speed2_3.png')
local speed_mask_2_4 = dxCreateTexture('/assets/img/speed2_4.png')
local speed_mask_2_5 = dxCreateTexture('/assets/img/speed2_5.png')

local xs = nil
local tick = nil
local state = nil


dxSetShaderValue(shaderMask, 'sMaskTexture', speed_mask)
dxSetShaderValue(shaderMask_2, 'sMaskTexture', speed_mask2)

function getElementSpeed(vehicle, unit)
    if isElement(vehicle) then
        local vx, vy, vz = getElementVelocity(vehicle)
        return math.floor(math.sqrt(vx*vx + vy*vy + vz*vz) * 187.5)
    end
end

function drawSpeed ()
	local vehicle = getPedOccupiedVehicle (localPlayer)
	if not vehicle then return end
	if getVehicleOccupant (vehicle) ~= localPlayer then return end

	if state then
		if tick then
			xs = interpolateBetween(0,0,0,-100,0,0,(getTickCount()- tick)/500,  "OutQuad")
		end
	else
		if tick then
			xs = interpolateBetween(-100,0,0,0,0,0,(getTickCount()- tick)/500,  "OutQuad")
		end
	end
	local speed = math.floor( vehicle and isElement ( vehicle ) and getElementSpeed(vehicle, 'km/h') or 0 )
	dxDrawImage(SizeX - 260 + xs - (-100), SizeY - 253, 240, 235, 'assets/img/speed_main.png', 0, 0, 0, tocolor(255, 255, 255,255 *  xs / (-100)))
	dxDrawImage(SizeX - 260 + xs - (-100), SizeY - 253, 240, 226, shaderMask, 0, 0, 0, tocolor(255, 255, 255, 255 *  xs / (-100)))
	dxDrawText(speed, SizeX + xs - (-100),SizeY - 290, SizeX - 280 + xs - (-100), SizeY, tocolor(255,255,255,255 *  xs / (-100)), 0.7, font3, "center","center" )
	dxDrawImage(SizeX - 260 + xs - (-100), SizeY - 253, 240, 235, "assets/img/povor_no.png", 0, 0, 0, tocolor(255, 255, 255, 100 * xs / (-100)))

    if getElementData(vehicle, "turn_right") == true then
        if ( getTickCount () % 1400 >= 600 ) then
            dxDrawImage(SizeX - 260+ xs - (-100) , SizeY - 253, 240, 235, "assets/img/povor_right.png", 0, 0, 0, tocolor(255, 255, 255, 255 * xs / (-100)))
        end
    end
      
    if getElementData(vehicle, "turn_left") == true then
        if ( getTickCount () % 1400 >= 600 ) then
            dxDrawImage(SizeX - 260+ xs - (-100) , SizeY - 253, 240, 235, "assets/img/povor_left.png", 0, 0, 0, tocolor(255, 255, 255, 255 * xs / (-100)))
        end
    end
	
    if getElementData(vehicle, "emergency_light") == true then
        if ( getTickCount () % 1400 >= 600 ) then
            dxDrawImage(SizeX - 260+ xs - (-100) , SizeY - 253, 240, 235, "assets/img/povor_both.png", 0, 0, 0, tocolor(255, 255, 255, 255 * xs / (-100)))
        end
    end
	
	local rotspeed_shader = speed
	if rotspeed_shader <= 45 then
		dxSetShaderValue(shaderMask, 'sPicTexture', speed_mask_1)
		dxSetShaderValue(shaderMask_2, 'sPicTexture', speed_mask_2_1)
	elseif rotspeed_shader > 45 and rotspeed_shader < 110 then
		dxSetShaderValue(shaderMask, 'sPicTexture', speed_mask_2)
		dxSetShaderValue(shaderMask_2, 'sPicTexture', speed_mask_2_2)
	elseif rotspeed_shader > 110 and rotspeed_shader < 163 then
		dxSetShaderValue(shaderMask, 'sPicTexture', speed_mask_3)
		dxSetShaderValue(shaderMask_2, 'sPicTexture', speed_mask_2_3)
	elseif rotspeed_shader > 163 and rotspeed_shader < 220 then
		dxSetShaderValue(shaderMask, 'sPicTexture', speed_mask_4)
		dxSetShaderValue(shaderMask_2, 'sPicTexture', speed_mask_2_4)
	elseif rotspeed_shader > 220 and rotspeed_shader < 264 then
		dxSetShaderValue(shaderMask, 'sPicTexture', speed_mask_5)
		dxSetShaderValue(shaderMask_2, 'sPicTexture', speed_mask_2_4)
	elseif rotspeed_shader > 264 then
		rotspeed_shader = 264
	end
	if rotspeed_shader > 264 and rotspeed_shader < 264 then
		dxSetShaderValue(shaderMask_2, 'sPicTexture', speed_mask_2_5)
	end
	dxSetShaderValue(shaderMask, 'gUVRotAngle', (rotspeed_shader/-77.5)+1.15)
	dxSetShaderValue(shaderMask_2, 'gUVRotAngle', (rotspeed_shader/-77.5)+1.15)
	if rotspeed_shader < 40 then
		dxDrawImage(SizeX - 350,SizeY - 280, 300, 300, 'assets/img/strelka.png', (rotspeed_shader*0.73)-89, 0, 0)
	elseif rotspeed_shader > 39 and rotspeed_shader < 120 then
		dxDrawImage(SizeX - 350,SizeY - 280, 300, 300, 'assets/img/strelka.png', (rotspeed_shader*0.73)-89, 0, 0)
	elseif rotspeed_shader > 119 then
		dxDrawImage(SizeX - 350,SizeY - 280, 300, 300, 'assets/img/strelka.png', (rotspeed_shader*0.73)-89, 0, 0)
	end
	
	local fuel = math.floor(vehicle and isElement ( vehicle ) and getElementData(vehicle,'vehicle.fuel') or 0)
	
	dxDrawText(fuel.."l", SizeX+ xs - (-100),SizeY - 75, SizeX - 280 + xs - (-100), SizeY, tocolor(255,255,255,255 * xs / (-100)), 0.45, font1, "center","center" )

	if xs == 0 and state == nil then
		removeEventHandler ( 'onClientRender', getRootElement(), drawSpeed )
	end
end

addEventHandler ( 'onClientResourceStart', resourceRoot, function()
	local res = getResourceFromName ( 'car_benzin' )
	if res and getResourceState ( res ) == 'running' then
		setElementData(localPlayer, 'showSpeedometer', true)
	end
	if not isPedInVehicle ( localPlayer ) then return end
	local v = getPedOccupiedVehicle ( localPlayer )
	if getPedOccupiedVehicleSeat ( localPlayer ) ~= 0 then return end
	addEventHandler("onClientRender", getRootElement(), drawSpeed)
	tick = getTickCount ()
	state = true
end)

addEventHandler ( 'onClientVehicleEnter', root, function ( pl, seat )
	if pl ~= localPlayer then return end
	if seat ~= 0 then return end
	if not isEventHandlerAdded("onClientRender", getRootElement(), drawSpeed) then
     	addEventHandler("onClientRender", getRootElement(), drawSpeed)
	end
	tick = getTickCount ()
	state = true
end)

addEventHandler ( 'onClientVehicleStartExit', root, function ( pl, seat )
	if pl ~= localPlayer then return end
	if seat ~= 0 then return end
	tick = getTickCount ()
	state = nil
end )

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
               for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
                     return true
                end
           end
      end
     end
     return false
end
