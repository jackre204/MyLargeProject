screenX, screenY = guiGetScreenSize()

function reMap(value, low1, high1, low2, high2)
 return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local responsiveMultiplier = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(value)
 return value * responsiveMultiplier
end

function respc(value)
 return math.ceil(value * responsiveMultiplier)
end

function dxDrawCorrectText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, hex)
	if not text then text = "-" end
	dxDrawText(text, left, top, left+right, top+bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, hex)
end

function dxDrawButtonWithText(x,y,w,h,color,activeColor,text,key)
  if isCursorInBox(x,y,w,h) then
    dxDrawRectangle(x,y,w,h,activeColor)
    if key then
      renderData.activeDirectX = key
    end
  else
    dxDrawRectangle(x,y,w,h,color)
  end
  if text then
    dxDrawCorrectText(text,x,y,w,h,tocolor(240,240,240,255), 1, robotoBoldFont10, "center", "center")
  end
end

function dxDrawImageButton(x,y,w,h,path,color,activeColor,rot,key)
  rot = rot or 0
  if isCursorInBox(x,y,w,h) then
    dxDrawImage(x,y,w,h,path,rot,0,0,activeColor)
    if key then
      renderData.activeDirectX = key
    end
  else
    dxDrawImage(x,y,w,h,path,rot,0,0,color)
  end
end

function dxDrawInnerBorder(thickness, x, y, w, h, color)
	thickness = thickness or 2

	dxDrawLine(x, y, x + w, y, color, thickness)
	dxDrawLine(x, y + h, x + w, y + h, color, thickness)
	dxDrawLine(x, y, x, y + h, color, thickness)
	dxDrawLine(x + w, y, x + w, y + h, color, thickness)
end

local stripeMinWidth = 1
local stripeMinHeight = 1
local stripeMaxWidth = 16
local stripeMaxHeight = 16

function makeNewStripe(x, y, z, width, height, resetRenderTarget, color, interior, dimension, type)
  local newStripe = {}

  if not resetRenderTarget then
    interior = interior or 0
    dimension = dimension or 0
    color = color or -1

    if width >= stripeMaxWidth then
      width = stripeMaxWidth
    end

    if height >= stripeMaxHeight then
      height = stripeMaxHeight
    end

    local halfWidth = width * 0.5
    local halfHeight = height * 0.5


    newStripe.x0 = x
    newStripe.y0 = y
    newStripe.z0 = z-0.999

    newStripe.x0mid = x + halfWidth
    newStripe.y0mid = y + halfHeight
    newStripe.z0mid = z-0.999

    newStripe.x1 = x + halfWidth
    newStripe.y1 = y
    newStripe.z1 = z-0.999

    newStripe.x2 = x + halfWidth
    newStripe.y2 = y + height
    newStripe.z2 = z-0.999

    newStripe.x3 = x + halfWidth
    newStripe.y3 = y + halfHeight
    newStripe.z3 = z + 10

    newStripe.width = width
    newStripe.height = height

    newStripe.color = color

    newStripe.interior = interior
    newStripe.dimension = dimension

    newStripe.type = type
  else
    newStripe = stripeMarks[resetRenderTarget]
  end

  if newStripe.width >= stripeMinWidth and newStripe.height >= stripeMinHeight then
    newStripe.renderTarget = dxCreateRenderTarget(newStripe.width * 48, newStripe.height * 48, true)

    dxSetRenderTarget(newStripe.renderTarget)

    for x = 0, newStripe.width * 2 do
      for y = 0, newStripe.height * 2 do
        dxDrawImage(x * 24, y * 24, 24, 24, "files/images/stripe.png", 0, 0, 0)
      end
    end

    dxDrawRectangle(0, 0, 8, newStripe.height * 48)
    dxDrawRectangle(newStripe.width * 48 - 8, 0, 8, newStripe.height * 48)
    dxDrawRectangle(0, 0, newStripe.width * 48, 8)
    dxDrawRectangle(0, newStripe.height * 48 - 8, newStripe.width * 48, 8)

    dxSetRenderTarget()
	end
  -- # Add the created table to the actual stripe array
  if not resetRenderTarget then
    table.insert(stripeMarks, newStripe)
  end
end

function isPlayerWithinStripe()
  local playerX, playerY, playerZ = getElementPosition(localPlayer)
  for k, v in pairs(stripeMarks) do
    if v.type == "destinations" then
      local stripeMinX, stripeMinY, stripeMaxX, stripeMaxY = v.x0, v.y0, v.x0+width, v.y0+height
      if (stripeMinX <= playerX and playerX <= stripeMaxX) and (stripeMinY <= playerY and playerY <= stripeMaxY) then
        return true, k
      end
    end
  end
  return false
end

addCommandHandler("createstripe", function(cmd, size1, size2)
  size1 = tonumber(size1)
  size2 = tonumber(size2)
  local x,y,z = getElementPosition(localPlayer)
  makeNewStripe(x,y,z, 5, 5)
end)


function isCursorInBox(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end
end

function isInBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

function getPositionByRelativeOffset(element, offsetX, offsetY, offsetZ)
	local matrixArray = getElementMatrix(element)
	return
	offsetX * matrixArray[1][1] + offsetY * matrixArray[2][1] + offsetZ * matrixArray[3][1] + matrixArray[4][1],
	offsetX * matrixArray[1][2] + offsetY * matrixArray[2][2] + offsetZ * matrixArray[3][2] + matrixArray[4][2],
	offsetX * matrixArray[1][3] + offsetY * matrixArray[2][3] + offsetZ * matrixArray[3][3] + matrixArray[4][3]
end

function getFacingRotation(playerElement, tableElement)
	local targetPosX, targetPosY = getElementPosition(tableElement)
	local playerPosX, playerPosY = getElementPosition(playerElement)
	local curRotZ = select(3, getElementRotation(playerElement))
	local newRotZ = -math.deg(math.atan2(targetPosX - playerPosX, targetPosY - playerPosY))

	if newRotZ < 0 then
		newRotZ = newRotZ + 360
	elseif newRotZ > 360 then
		newRotZ = newRotZ - 360
	end

	return newRotZ
end

function getPositionInfrontOfElement(x, y, z, rot, meters)
    if not meters then
        meters = 3
    end
    local posX , posY , posZ = x, y, z
    posX = posX - math.sin ( math.rad ( rot ) ) * meters
    posY = posY + math.cos ( math.rad ( rot ) ) * meters
    return posX , posY , posZ
end

function getFacingRotation(playerElement, targetX, targetY)
	local targetPosX, targetPosY = targetX, targetY
	local playerPosX, playerPosY = getElementPosition(playerElement)
	local curRotZ = select(3, getElementRotation(playerElement))
	local newRotZ = -math.deg(math.atan2(targetPosX - playerPosX, targetPosY - playerPosY))

	if newRotZ < 0 then
		newRotZ = newRotZ + 360
	elseif newRotZ > 360 then
		newRotZ = newRotZ - 360
	end

	return newRotZ
end

function boxesIntersect(x1, y1, w1, h1, x2, y2, w2, h2)
	local horizontal = (x1 < x2) ~= (x1 < x2 + w2) or (x1 + w1 < x2) ~= (x1 + w1 < x2 + w2) or (x1 < x2) ~= (x1 + w1 < x2) or (x1 < x2 + w2) ~= (x1 + w1 < x2 + w2)
	local vertical = (y1 < y2) ~= (y1 < y2 + h2) or (y1 + h1 < y2) ~= (y1 + h1 < y2 + h2) or (y1 < y2) ~= (y1 + h1 < y2) or (y1 < y2 + h2) ~= (y1 + h1 < y2 + h2)

	return (horizontal and vertical)
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

function getOffsetFromXYZ( mat, vec )
    -- make sure our matrix is setup correctly 'cos MTA used to set all of these to 1.
    mat[1][4] = 0
    mat[2][4] = 0
    mat[3][4] = 0
    mat[4][4] = 1
    mat = matrix.invert( mat )
    local offX = vec[1] * mat[1][1] + vec[2] * mat[2][1] + vec[3] * mat[3][1] + mat[4][1]
    local offY = vec[1] * mat[1][2] + vec[2] * mat[2][2] + vec[3] * mat[3][2] + mat[4][2]
    local offZ = vec[1] * mat[1][3] + vec[2] * mat[2][3] + vec[3] * mat[3][3] + mat[4][3]
    return {offX, offY, offZ}
end

function renderBetInformation(x, y, title, data)
  --player nev tétje: 500 Coin
	title = tostring(title)
	data = data and tostring(data)

  local sx = dxGetTextWidth(title, 1, "clear", true) + 20
  local sy = 30

	if title == data then
		data = nil
	end


	if data then
		sx = math.max(sx, dxGetTextWidth(data, 1, "clear", true) + 20)
		title = "#3d7abc" .. title .. "\n#ffffff" .. data
	end

	if data then
		local lines = select(2, string.gsub(data, "\n", "")) + 1
		sy = sy + 12 * lines
	end

	x = math.max(0, math.min(screenX - sx, x))
	y = math.max(0, math.min(screenY - sy, y))

	dxDrawRectangle(x, y, sx, sy, tocolor(30, 30, 30, 240), true)
	dxDrawText(title, x, y, x + sx, y + sy, tocolor(255, 255, 255), 1, robotoBoldFont9, "center", "center", false, false, true, true)
end

function table.empty( a )
    if type( a ) ~= "table" then
        return false
    end

    return not next( a )
end

addEventHandler("onClientPedDamage", resourceRoot, 
  function()
  	cancelEvent() 
  end
)