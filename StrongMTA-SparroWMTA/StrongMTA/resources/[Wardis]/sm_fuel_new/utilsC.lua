screenX, screenY = guiGetScreenSize()

-- the efect settings
local colorizePed = {50 / 255, 179 / 255, 239 / 255, 1} -- rgba colors 
local specularPower = 1.3
local effectMaxDistance = 10
local isPostAura = true

-- don't touch
local scx, scy = guiGetScreenSize ()
local effectOn = nil
local myRT = nil
local myShader = nil
local isMRTEnabled = false
local outlineEffect = {}
local PWTimerUpdate = 110

-----------------------------------------------------------------------------------
-- enable/disable
-----------------------------------------------------------------------------------
function enableOutline(isMRT)
	if isMRT and isPostAura then 
		myRT = dxCreateRenderTarget(scx, scy, true)
		myShader = dxCreateShader("files/fx/edge.fx")
		if not myRT or not myShader then 
			outputChatBox('Outline: Out of memory!',255,0,0)
			isMRTEnabled = false
			return
		else
			--outputDebugString('Outline: Enabled MRT variant')
			dxSetShaderValue(myShader, "sTex0", myRT)
			dxSetShaderValue(myShader, "sRes", scx, scy)
			isMRTEnabled = true
		end
	else
		--outputDebugString('Outline: Enabled non MRT variant')
		isMRTEnabled = false
	end
	pwEffectEnabled = true
	--enableOutlineTimer(isMRTEnabled)
	--outputChatBox('Outline turned on',255,128,0)
	--outputChatBox('Press '..actKey..' for x-ray vision',255,128,0)
end

function disableOutline()
	if isElement(myRT) then
		destroyElement(myRT)
	end
    if isElement(myShader) then
        destroyElement(myShader)
    end

    myRT = nil
    myShader = nil
end


-----------------------------------------------------------------------------------
-- create/destroy per player
-----------------------------------------------------------------------------------
function createElementOutlineEffect(element, isMRT)
    if not myRT or not myShader then
        enableOutline(isMRT)
    end

    effectOn = true
    if not outlineEffect[element] then
		if isMRT then 
			outlineEffect[element] = dxCreateShader("files/fx/wall_mrt.fx", 1, 0, true, "all")
		else
			outlineEffect[element] = dxCreateShader("files/fx/wall.fx", 1, 0, true, "all")
		end
		if not outlineEffect[element] then return false
		else
			if myRT then
				dxSetShaderValue (outlineEffect[element], "secondRT", myRT)
			end
			dxSetShaderValue(outlineEffect[element], "sColorizePed",colorizePed)
			dxSetShaderValue(outlineEffect[element], "sSpecularPower",specularPower)
			engineApplyShaderToWorldTexture ( outlineEffect[element], "*" , element )
			engineRemoveShaderFromWorldTexture(outlineEffect[element],"muzzle_texture*", element)
			if not isMRT then
				if getElementAlpha(element)==255 then setElementAlpha(element, 254) end
			end
		return true
		end
    end
end

function destroyElementOutlineEffect(element)
    if outlineEffect[element] then
		--engineRemoveShaderFromWorldTexture(outlineEffect[element], "*", element)
		destroyElement(outlineEffect[element])
		outlineEffect[element] = nil
        disableOutline()
	end
end

addCommandHandler("out", function()
    --for k, v in pairs(getElementsByType("player"))
    createElementOutlineEffect(localPlayer, true)
end)

-----------------------------------------------------------------------------------
-- onClientPreRender
-----------------------------------------------------------------------------------
addEventHandler( "onClientPreRender", root,
    function()
		if not pwEffectEnabled or not isMRTEnabled or not effectOn then return end
		-- Clear secondary render target
		dxSetRenderTarget( myRT, true )
		dxSetRenderTarget()
    end
, true, "high" )


-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------
addEventHandler( "onClientHUDRender", root,
    function()
		if not pwEffectEnabled or not isMRTEnabled or not effectOn or not myShader then return end
		-- Show contents of secondary render target
		dxDrawImage( 0, 0, scx, scy, myShader )
    end
)
--[[]]
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		local isMRT = false
		if dxGetStatus().VideoCardNumRenderTargets > 1 then 
			isMRT = true 
			--outputDebugString('pedWall: MRT in shaders enabled') 
		end
		--triggerEvent("switchOutline", resourceRoot, true, isMRT) -- default on
	end
)

--------------------------------
-- Switch effect on or off
--------------------------------
function switchOutline(pwOn, isMRT)
	--outputDebugString("switchOutline: " .. tostring(pwOn)..' MRT: '..tostring(isMRT))
	if pwOn then
		enableOutline(isMRT)
	else
		disableOutline()
	end
end

addEvent("switchOutline", true)
addEventHandler("switchOutline", resourceRoot, switchOutline)