local screenX, screenY = guiGetScreenSize()

local textFont = dxCreateFont("files/opensans_semibold.ttf", 28, true)

local maxDistance = 30
local minScale = 0.84
local maxScale = 0.2

local imageWidth = 256
local imageHeight = 256

local worldTexts = {}
local worldImages = {}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		worldTexts = {}
		worldImages = {}

		for k, v in pairs(getElementsByType("marker", getRootElement(), true)) do
			local visibleText = getElementData(v, "3DText")
			if visibleText then
				worldTexts[v] = visibleText
			end

			local imageDetails = getElementData(v, "3DImage")
			if imageDetails then
				worldImages[v] = imageDetails
			end
		end

		for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
			local visibleText = getElementData(v, "3DText")
			if visibleText then
				worldTexts[v] = visibleText
			end

			local imageDetails = getElementData(v, "3DImage")
			if imageDetails then
				worldImages[v] = imageDetails
			end
		end

		for k, v in pairs(getElementsByType("pickup", getRootElement(), true)) do
			local visibleText = getElementData(v, "3DText")
			if visibleText then
				worldTexts[v] = visibleText
			end

			local imageDetails = getElementData(v, "3DImage")
			if imageDetails then
				worldImages[v] = imageDetails
			end
		end

		for k, v in pairs(getElementsByType("object", getRootElement(), true)) do
			local visibleText = getElementData(v, "3DText")
			if visibleText then
				worldTexts[v] = visibleText
			end

			local imageDetails = getElementData(v, "3DImage")
			if imageDetails then
				worldImages[v] = imageDetails
			end
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		local visibleText = getElementData(source, "3DText")
		if visibleText then
			worldTexts[source] = visibleText
		end

		local imageDetails = getElementData(source, "3DImage")
		if imageDetails then
			worldImages[source] = imageDetails
		end
	end
)

addEventHandler("onClientElementStreamOut", getRootElement(),
	function ()
		if worldTexts[source] then
			worldTexts[source] = nil
		end

		if worldImages[source] then
			worldImages[source] = nil
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if worldTexts[source] then
			worldTexts[source] = nil
		end

		if worldImages[source] then
			worldImages[source] = nil
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if isElement(source) then
			local elementType = getElementType(source)

			if elementType == "marker" or elementType == "pickup" then
				if dataName == "3DText" then
					local visibleText = getElementData(source, "3DText")

					if visibleText then
						worldTexts[source] = visibleText
					else
						worldTexts[source] = nil
					end
				elseif dataName == "3DImage" then
					local imageDetails = getElementData(source, "3DImage")

					if imageDetails then
						worldImages[source] = imageDetails
					else
						worldImages[source] = nil
					end
				end
			elseif elementType == "vehicle" or elementType == "object" then
				if isElementStreamedIn(source) then
					if dataName == "3DText" then
						local visibleText = getElementData(source, "3DText")

						if visibleText then
							worldTexts[source] = visibleText
						else
							worldTexts[source] = nil
						end
					elseif dataName == "3DImage" then
						local imageDetails = getElementData(source, "3DImage")

						if imageDetails then
							worldImages[source] = imageDetails
						else
							worldImages[source] = nil
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		local cameraX, cameraY, cameraZ = getCameraMatrix()
		local localInterior = getElementInterior(localPlayer)
		local localDimension = getElementDimension(localPlayer)

		for ownerElement, visibleText in pairs(worldTexts) do
			local elementType = getElementType(ownerElement)
			local renderText = true

			if elementType ~= "marker" then
				if not isElementOnScreen(ownerElement) then
					renderText = false
				end
			end

			if renderText then
				if localInterior == getElementInterior(ownerElement) then
					if localDimension == getElementDimension(ownerElement) then
						local targetX, targetY, targetZ = getElementPosition(ownerElement)
						local distanceBetween = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, targetX, targetY, targetZ)

						if distanceBetween <= maxDistance then
							local onScreenX = 0
							local onScreenY = 0

							if elementType == "pickup" then
								onScreenX, onScreenY = getScreenFromWorldPosition(targetX, targetY, targetZ + 1, 0, false)
							else
								onScreenX, onScreenY = getScreenFromWorldPosition(targetX, targetY, targetZ + 1.5, 0, false)
							end

							if onScreenX and onScreenY then
								if isLineOfSightClear(cameraX, cameraY, cameraZ, targetX, targetY, targetZ + 1, true, false, false, true, false, true, false) then
									local scaleFactor = interpolateBetween(minScale, 0, 0, maxScale, 0, 0, distanceBetween / maxDistance, "OutQuad")

									if scaleFactor then
										local textWidth = dxGetTextWidth(visibleText:gsub("#%x%x%x%x%x%x", ""), scaleFactor, textFont)

										if textWidth then
											local textHeight = dxGetFontHeight(scaleFactor, textFont)

											onScreenX = onScreenX - textWidth / 2

											if textHeight then
												textHeight = countString(visibleText, "\n") * textHeight

												--dxDrawRectangle(onScreenX - 6, onScreenY - 3, textWidth + 9, textHeight + 6, tocolor(0, 0, 0, 150))
												--dxDrawRectangle(onScreenX - 6, onScreenY - 3, textWidth + 9, 3, tocolor(0, 0, 0, 150))
												--dxDrawRectangle(onScreenX - 6, onScreenY + textHeight, textWidth + 9, 3, tocolor(0, 0, 0, 150))
												--dxDrawRectangle(onScreenX - 6, onScreenY, 3, textHeight, tocolor(0, 0, 0, 150))
												--dxDrawRectangle(onScreenX + textWidth, onScreenY,, textHeight + 8, tocolor(0, 0, 0, 150))
												
												dxDrawRectangle(onScreenX - 6 - 3, onScreenY - 3 - 3, textWidth + 9 + 6, textHeight + 6 + 6, tocolor(25, 25, 25))
												dxDrawRectangle(onScreenX - 6, onScreenY - 3, textWidth + 9, textHeight + 6, tocolor(35, 35, 35))
											end

											dxDrawText(visibleText, onScreenX - 2, onScreenY, onScreenX - 2 + textWidth, 100, tocolor(255, 255, 255, 250), scaleFactor, textFont, "center", "top", false, false, false, true, true)
										end
									end
								end
							end
						end
					end
				end
			end
		end

		for ownerElement, imageDetails in pairs(worldImages) do
			local elementType = getElementType(ownerElement)
			local renderText = true

			if elementType ~= "marker" then
				if not isElementOnScreen(ownerElement) then
					renderText = false
				end
			end

			if renderText then
				if localInterior == getElementInterior(ownerElement) then
					if localDimension == getElementDimension(ownerElement) then
						local targetX, targetY, targetZ = getElementPosition(ownerElement)
						local distanceBetween = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, targetX, targetY, targetZ)

						if distanceBetween <= maxDistance then
							local onScreenX, onScreenY = getScreenFromWorldPosition(targetX, targetY, targetZ + (imageDetails[2] or 0), 0, false)

							if onScreenX and onScreenY then
								if isLineOfSightClear(cameraX, cameraY, cameraZ, targetX, targetY, targetZ + 1, true, false, false, true, false, true, false) then
									local scaleFactor = interpolateBetween(minScale, 0, 0, maxScale, 0, 0, distanceBetween / maxDistance, "OutQuad")

									if scaleFactor then
										local sizeOnScreenX = math.floor(scaleFactor * 2 * imageWidth)
										local sizeOnScreenY = math.floor(scaleFactor * 2 * imageHeight)

										onScreenX = onScreenX - sizeOnScreenX / 2
										onScreenY = onScreenY - sizeOnScreenY / 2

										dxDrawImage(onScreenX, onScreenY, sizeOnScreenX, sizeOnScreenY, "files/marker/" .. imageDetails[1])
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

function countString(base, pattern)
	local function replace(str)
		return "%" .. str
	end

	local count = select(2, string.gsub(base, string.gsub(pattern, "[%^%$%(%)%%%.%[%]%*%+%-%?]", replace), ""))

	if count > 1 then
		return count + 1
	else
		return 1
	end
end
