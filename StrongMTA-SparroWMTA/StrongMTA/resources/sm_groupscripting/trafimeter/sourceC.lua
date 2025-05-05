local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()


function resp(num)
    return num * responsiveMultipler
end

function respc(num)
    return math.ceil(num * responsiveMultipler)
end

local renderState = false

local vehicleDetails = {}

local meterPos = {
    x = screenX / 2 - (respc(935) - respc(150)) / 2,
    y = screenY / 2 - respc(130) / 2,
    w = respc(950) - respc(150),
    h = respc(130)
    
}

local maxRange = 30

local oldSpeed = 0

local numCalculate = 0
local staticY = 0

local targetImage = dxCreateTexture("files/images/target.png")

local vehicleElement = false
local oldPlate = "unknow"

addCommandHandler("trafi",
    function(theCommand)
        if renderState then
            renderState = false
            removeEventHandler("onClientRender", getRootElement(), renderTraffipaxMeter)
            removeEventHandler("onClientClick", getRootElement(), onTraffiMeterClick)
        else
            renderState = true
            addEventHandler("onClientRender", getRootElement(), renderTraffipaxMeter)
            addEventHandler("onClientClick", getRootElement(), onTraffiMeterClick)
        end       
    end
)

addCommandHandler("resetmeter",
    function(theCommand)
         meterPos = {
            x = screenX / 2 - (respc(935) - respc(150)) / 2,
            y = screenY / 2 - respc(130) / 2,
            w = respc(950) - respc(150),
            h = respc(130)

        }
    end
)

function renderTraffipaxMeter()
    local theVehicle = getPedOccupiedVehicle(localPlayer)
    if theVehicle then
        if renderMove and isCursorShowing() then
            local cursorX, cursorY = getCursorPosition()
            local posX, posY = cursorX * screenX - posOffSetX, cursorY * screenY - posOffSetY
            meterPos.x = posX
            meterPos.y = posY
        end

        --render
        dxDrawRectangle(meterPos.x, meterPos.y, meterPos.w, meterPos.h, tocolor(25, 25, 25))

        drawText("Target Speed:", (meterPos.x + (10)) + (0) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)) - respc(60), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(200, 200, 200, 200), 1, Raleway)
        dxDrawRectangle((meterPos.x + (10)) + (0) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(35, 35, 35))

        drawText("Range / Plate:", (meterPos.x + (10)) + (1) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)) - respc(60), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(200, 200, 200, 200), 1, Raleway)
        dxDrawRectangle((meterPos.x + (10)) + (1) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)), meterPos.w / 4 - (20), (meterPos.h / 2) / 3, tocolor(35, 35, 35))

        if vehicleDetails.distance then
            dxDrawRectangle((meterPos.x + (10)) + (1) * ((meterPos.w / 4 - (20)) + (20)) + 3, (meterPos.y + meterPos.h / 2 - (10)) + 3, ((meterPos.w / 4 - (20)) - 6) / (maxRange - 2) * vehicleDetails.distance, ((meterPos.h / 2) / 3) - 6, tocolor(200, 35, 35, 120))
        end

        for k = 1, 4 do
            dxDrawRectangle(((meterPos.x + (10)) + (1) * ((meterPos.w / 4 - (20)) + (20)) + 3) + (k - 1) * respc(40) + respc(26), ((meterPos.y + meterPos.h / 2 - (10)) + 3), 1, ((meterPos.h / 2) / 3) - 6, tocolor(200, 200, 200, 200))
        end

        dxDrawBorder((meterPos.x + (10)) + (1) * ((meterPos.w / 4 - (20)) + (20)) + 3, (meterPos.y + meterPos.h / 2 - (10)) + 3, ((meterPos.w / 4 - (20)) - 6), ((meterPos.h / 2) / 3) - 6, tocolor(200, 200, 200, 200))

        dxDrawRectangle((meterPos.x + (10)) + (1) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)) + (meterPos.h / 2) / 3 + 10, meterPos.w / 4 - (20), (meterPos.h / 2) / 2.1, tocolor(35, 35, 35))


        drawText("Lock:", (meterPos.x + (10)) + (2) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)) - respc(60), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(200, 200, 200, 200), 1, Raleway)
        dxDrawRectangle((meterPos.x + (10)) + (2) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(35, 35, 35))

        drawText("Patrol Speed:", (meterPos.x + (10)) + (3) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)) - respc(60), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(200, 200, 200, 200), 1, Raleway)
        dxDrawRectangle((meterPos.x + (10)) + (3) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(35, 35, 35))

        if vehicleDetails.speed then
            datasFromRender = {
                speed = vehicleDetails.speed,
                lockedSpeed = vehicleDetails.lockedSpeed,
                plate = vehicleDetails.plate
            }
        else
            datasFromRender = {
                speed = "0",
                lockedSpeed = vehicleDetails.lockedSpeed or oldSpeed,
                plate = vehicleDetails.plate or oldPlate
            }
        end

        drawText(datasFromRender.speed, (meterPos.x + (10)) + (0) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(200, 200, 200, 200), 1, LcdFont)
        drawText(datasFromRender.lockedSpeed, (meterPos.x + (10)) + (2) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(200, 200, 200, 200), 1, LcdFont)
        drawText(math.floor(getVehicleSpeed(theVehicle)), (meterPos.x + (10)) + (3) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)), meterPos.w / 4 - (20), meterPos.h / 2, tocolor(200, 200, 200, 200), 1, LcdFont)
        drawText(tostring(datasFromRender.plate), (meterPos.x + (10)) + (1) * ((meterPos.w / 4 - (20)) + (20)), (meterPos.y + meterPos.h / 2 - (10)) + (meterPos.h / 2) / 3 + 10, meterPos.w / 4 - (20), (meterPos.h / 2) / 2.1, tocolor(200, 200, 200, 200), 0.9, Raleway)

        --3d line, utils
        if getKeyState("num_9") then
            if staticY <= 4 then
                staticY = staticY + 0.1
            end
        end

        if getKeyState("num_7") then
            if staticY > -4 then
                staticY = staticY - 0.1
            end
        end
        local startX, startY, startZ = getPositionFromElementOffset(theVehicle, 0, 2.6, 0)
        local endX, endY, endZ = getPositionFromElementOffset(theVehicle, staticY, maxRange, 0)

        local isAnHit, hitX, hitY, hitZ, hitElement = processLineOfSight(startX, startY, startZ, endX, endY, endZ)

        local isThatVehicle = false

        if hitElement and isAnHit then
            if getElementType(hitElement) == "vehicle" then

                isThatVehicle = true

                local vehicleSpeed = math.floor(getVehicleSpeed(hitElement))
                if isElementOnScreen(hitElement) then
                    local x, y, z = getElementPosition(hitElement, 0, 0, 0)
                    local imageX, imageY = getScreenFromWorldPosition(x, y, z + 1.5)
                    if imageX and imageY then
                        dxDrawImage(imageX - respc(50), imageY - respc(50), respc(100), respc(100), targetImage)

                    end

                end

                if vehicleElement ~= hitElement then
                    oldSpeed = 0

                    local plateText = split(getVehiclePlateText(hitElement), "-")
                    local plateSections = {}

                    for i = 1, #plateText do
                        if utf8.len(plateText[i]) > 0 then
                            table.insert(plateSections, plateText[i])
                        end
                    end

                    oldPlate = table.concat(plateSections, "-")

                    vehicleElement = hitElement
                end

                if vehicleSpeed > oldSpeed then
                    oldSpeed = vehicleSpeed
                end

                vehicleDetails = {
                    speed = vehicleSpeed,
                    distance = getDistanceBetweenPoints3D(hitX, hitY, hitZ, startX, startY, startZ),
                    lockedSpeed = oldSpeed,
                    plate = oldPlate
                }

            end
        else
            local lastLockedSpeed = vehicleDetails.lockedSpeed
            local oldPlate = vehicleDetails.plate
            vehicleDetails = {
                lockedSpeed = lastLockedSpeed,
                plate = oldPlate
            }
        end
        if isThatVehicle then
            dxDrawLine3D(startX, startY, startZ, hitX, hitY, hitZ, tocolor(61, 122, 188, 180), 5)

        else
            dxDrawLine3D(startX, startY, startZ, endX, endY, endZ, tocolor(61, 122, 188, 180), 5)
        end
    end
end

function onTraffiMeterClick(button, state)
    if button == "left" and state == "down" then
        if isCursorInPos(meterPos.x, meterPos.y, meterPos.w, respc(40)) then
            local cursorX, cursorY = getCursorPosition()
            posOffSetX, posOffSetY = cursorX * screenX - meterPos.x, cursorY * screenY - meterPos.y
            renderMove = true
        end
    elseif button == "left" and state == "up" then
        renderMove = false
    end
end

function getPositionFromElementOffset(element, x, y, z)
    if element then
        m = getElementMatrix(element)
        return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1], x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2], x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
    end
end

function getVehicleSpeed(vehicle)
    if isElement(vehicle) then
        local vx, vy, vz = getElementVelocity(vehicle)
        return math.floor(math.sqrt(vx*vx + vy*vy + vz*vz) * 187.5)
    end
end

addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePed, seat)
        if thePed == localPlayer then
            if renderState then
                renderState = false
                removeEventHandler("onClientRender", getRootElement(), renderTraffipaxMeter)
                removeEventHandler("onClientClick", getRootElement(), onTraffiMeterClick)
            end
        end
    end
)

function drawText(text ,x, y, w, h, color, size, font)
    if text then
        dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, size, font, "center", "center", false, false, false, true)
    end 
end

function isCursorInPos(posX, posY, width, height)
    if isCursorShowing() then
        local mouseX, mouseY = getCursorPosition()
        local clientW, clientH = guiGetScreenSize()
        local mouseX, mouseY = mouseX * clientW, mouseY * clientH
        if (mouseX > posX and mouseX < (posX+width) and mouseY > posY and mouseY < (posY+height)) then
            return true
        end
    end
    return false
end

function dxDrawBorder(x, y, width, height, color, _width, postGUI)
    _width = _width or 1
    dxDrawLine(x, y, x + width, y, color, _width, postGUI ) -- Top
    dxDrawLine(x, y, x, y + height, color, _width, postGUI ) -- Left
    dxDrawLine(x, y+height, x + width, y+height, color, _width, postGUI ) -- Bottom
    return dxDrawLine ( x + width, y, x + width, y + height, color, _width, postGUI ) -- Right
end