local screenSizeX, screenSizeY = guiGetScreenSize()
local shaderElement = dxCreateShader("shader.hlsl")

dxSetShaderValue(shaderElement, "sColor", 1, 0, 0, 1)

local carPaints = {}

addEventHandler("onClientRender", root,
	function ()
		local cursorX, cursorY = getCursorPosition()

		if cursorX then
			cursorX = cursorX * screenSizeX
			cursorY = cursorY * screenSizeY

			local originX, originY, originZ = getElementPosition(getCamera())
			local targetX, targetY, targetZ = getWorldFromScreenPosition(cursorX, cursorY, 100)
			local gotHit, hitX, hitY, hitZ, hitElement = processLineOfSight(originX, originY, originZ, targetX, targetY, targetZ, false, true, false, false, false)


			for k, v in pairs(carPaints) do

				dxSetShaderValue(shaderElement, "sCoordinate", v[1], v[2], v[3])

				print(v[1] .. " | " .. v[2] .. " | " .. v[3])
			end

			if gotHit then
				if getKeyState("mouse1") then
					local carX, carY, carZ = getElementPosition(hitElement)

				
					table.insert(carPaints, {hitX, hitY, hitZ})

					if not appliedToVehicle then
						appliedToVehicle = true
						engineApplyShaderToWorldTexture(shaderElement, "vehiclegrunge256", hitElement)
					end
				end
			end
		end

		dxDrawImage(0, 0, 512, 512, shaderElement)
	end
)

addCommandHandler("asd",
	function()
		iprint(carPaints)
	end
)