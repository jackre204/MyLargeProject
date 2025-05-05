local renderTarget = dxCreateRenderTarget(128 * 5, 128 * 10)

worldX, worldY = -25.6328125, -364.9140625 

addEventHandler("onClientRender", getRootElement(),
	function()
		dxSetRenderTarget(renderTarget, true)
			 for k = 0, 10 do
			 	for k2 = 0, 4 do
					dxDrawImage(k2 * 128, k * 128, 128, 128,":sm_farm_animal/files/images/land.png")
					if selected
					dxDrawImage(k2 * 128, k * 128, 128, 128,":sm_farm_animal/files/images/selection.png")
				end
			 end
		dxSetRenderTarget()

		dxDrawImage(0, 0, 128 * 5 / 2, 128 * 10 / 2, renderTarget)

		dxDrawImage3D(worldX, worldY, 4.45, 10, 1, renderTarget, tocolor(255, 255, 255, 255))
	end
)

function dxDrawImage3D( x, y, z, width, height, material, color, rotation, ... )
  return dxDrawMaterialLine3D( x+2.5, y, z, x+2.5, y+width, z + tonumber( rotation or 0 ), material, -5, color or 0xFFFFFFFF, -8.927734375, -367.939453125,10000)
end
--[[
local scaleFactor = 3

addEventHandler("onClientPreRender", root,
    function ()
		for k, v in ipairs(getElementsByType("player"), root, true) do
			local localPlayer = v
			local pedMatrix = getElementMatrix(localPlayer)

			-- debug begin
			scaleFactor = 1 + math.sin(getTickCount() / 250) * 0.2
			-- debug end

			for i = 1, 3 do
				for j = 1, 3 do
					pedMatrix[i][j] = pedMatrix[i][j] * scaleFactor
				end
			end

			setElementMatrix(localPlayer, pedMatrix)
		end
	end
)

local boneIds = {0, 1, 2, 3, 4, 5, 6, 7, 8, 21, 22, 23, 24, 25, 26, 31, 32, 33, 34, 35, 36, 41, 42, 43, 44, 51, 52, 53, 54, 201, 301, 302}

addEventHandler("onClientPedsProcessed", root,
    function ()
        for i = 1, #boneIds do
            local bonePosX, bonePosY, bonePosZ = getElementBonePosition(localPlayer, boneIds[i])

            bonePosZ = bonePosZ + (1 - scaleFactor) * -1

            setElementBonePosition(localPlayer, boneIds[i], bonePosX, bonePosY, bonePosZ)
        end
    end
)


function respc(x)
	return x 
end

local sliderWidth = 200
local sliderHeight = 20

local screenX, screenY = guiGetScreenSize()

set = {"name", 0, {0, 5}}

addEventHandler("onClientRender", getRootElement(),
	function()
		buttonsC = {}
		
		local cursorX, cursorY = getCursorPosition()

		if tonumber(cursorX) and tonumber(cursorY) then
			cursorX = cursorX * screenX
			cursorY = cursorY * screenY
		end

		local lineY = 500

		sliderBaseX = 500
		local sliderBaseY = lineY + (sliderHeight - respc(10)) / 2

		sliderX = sliderBaseX + reMap(tonumber(set[2]), set[3][1], set[3][2], 0, sliderWidth - respc(15))
		sliderY = lineY - sliderHeight / 2

		dxDrawRectangle(sliderBaseX, sliderBaseY, sliderWidth, sliderHeight, tocolor(55, 55, 55, 200))
		dxDrawRectangle(sliderX, sliderBaseY, respc(15), sliderHeight, tocolor(61, 122, 188, 210))

		if getKeyState("mouse1") and sliderMoveX then
			if activeSlider == set[1] then
				local sliderValue = (cursorX - sliderMoveX - sliderBaseX) / (sliderWidth - respc(15))

				if sliderValue < 0 then
					sliderValue = 0
				end

				if sliderValue > 1 then
					sliderValue = 1
				end

				--set[2] = reMap(sliderValue, 0, 1, set[4][1], set[4][2])
			end
		else
			sliderMoveX = false
			activeSlider = false
		end

		if not sliderMoveX and activeButtonC == "setting_slider:" .. set[1] then
			sliderMoveX = cursorX - sliderX
			activeSlider = set[1]
			
		end

		buttonsC["setting_slider:" .. set[1]] --= {sliderX, sliderY, respc(15), sliderHeight}

		--[[if tonumber(cursorX) and tonumber(cursorY) then
			activeButtonC = false
			
			if not buttonsC then
				return
			end
		
			for k, v in pairs(buttonsC) do
				if cursorX >= v[1] and cursorY >= v[2] and cursorX <= v[1] + v[3] and cursorY <= v[2] + v[4] then
					activeButtonC = k
					break
				end
			end
		else
			activeButtonC = false
		end
	end
)

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end
]]
