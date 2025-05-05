pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function resp(value)
    return value * responsiveMultipler
end
local renderTarget = dxCreateRenderTarget(180, 90)
function respc(value)
    return math.ceil(value * responsiveMultipler)
end
local cryptoElement = false
local screenX, screenY = guiGetScreenSize()
local computerPos = {
    x = screenX / 2 - respc(600) / 2,
    y = screenY / 2 - respc(130) / 2,
    w = respc(600),
    h = respc(130)
    
}

local liftZ ={
    13.99945 + 1,
    13.99945 + 0.5 + 6.25,
    25,
    13.99945 + 2 + 14.07,
}


local lifthivo = false
local gui

local sx, sy = guiGetScreenSize()
local butt = {}
local clos
local lunabar = dxCreateFont("lunabar.ttf",12)


local panelSize = {
    x = respc(200),
    y = respc(400)
}


function render()
    if getElementData(localPlayer, "inlift") then 
        return 
    end

    local playerX, playerY, playerZ = getElementPosition(localPlayer)

    if playerZ then
        local sx, sy = getScreenFromWorldPosition(1445.8690185547, -1793.3524169922 - 1, playerZ + 0.5) 

        if not sx and sy then 
            return 
        end 

        local panelPos = {
            x = sx - panelSize.x / 2, 
            y = sy - panelSize.y / 2
        }

        dxDrawRectangle(panelPos.x, panelPos.y, panelSize.x, panelSize.y-respc(200), tocolor(35, 35, 35))
        buttonsC = {}
        drawButton("0", "Földszint", panelPos.x + 4, panelPos.y + 4, panelSize.x - 8, respc(50) - 8, {61, 122, 188}, false, lunabar)
        drawButton("1","1. emelet",panelPos.x + 4, panelPos.y + respc(54), panelSize.x - 8, respc(50) - 8,{61, 122, 188},false,lunabar)
        drawButton("2","2. emelet",panelPos.x + 4, panelPos.y + respc(104), panelSize.x - 8, respc(50) - 8,{61, 122, 188},false,lunabar)
        drawButton("3","3. emelet",panelPos.x + 4, panelPos.y + respc(154), panelSize.x - 8, respc(50) - 8,{61, 122, 188},false,lunabar)
        local relX, relY = getCursorPosition()

        activeButtonC = false

        if relX and relY then
            relX = relX * screenX
            relY = relY * screenY

            for k, v in pairs(buttonsC) do
                if relX >= v[1] and relY >= v[2] and relX <= v[1] + v[3] and relY <= v[2] + v[4] then
                    activeButtonC = k
                    break
                end
            end
            
        end
    end
end

function handleClick (button,state)
if button =="left" and state =="down" then 
    if getElementData(localPlayer,"inlift") then return end
		if activeButtonC == "0" and lift ~= 1 then
		triggerServerEvent("moveLift", root, 1, localPlayer)
        setElementData(localPlayer, "inlift", true)
        elseif activeButtonC == "1" and lift ~= 2 then
            triggerServerEvent("moveLift", root, 2, localPlayer)
            setElementData(localPlayer, "inlift", true)
        elseif activeButtonC =="2" and lift ~= 3  then
            triggerServerEvent("moveLift", root, 3, localPlayer)
            setElementData(localPlayer, "inlift", true)
        elseif activeButtonC =="3" and lift ~= 4  then
            triggerServerEvent("moveLift", root, 4, localPlayer)
            setElementData(localPlayer, "inlift", true)
        elseif activeButtonC =="lift" and lifthivo2 then
            if tonumber(lift2) == tonumber(lift) then
                return
            end
            triggerServerEvent("moveLift",root,lift2,localPlayer)
            removeEventHandler("onClientRender", root, renderText)
            lifthivo2 = false
        end
	end
end
addEventHandler("onClientClick",getRootElement(),handleClick)
function onClientColShapeHit( theElement, matchingDimension )
    if ( theElement == getLocalPlayer() ) and getElementData(source,"id2") then
		local id = tonumber(getElementData(source, "id2"))
        lifthivo2 = true
		lift2 = id
		addEventHandler("onClientRender", root, renderText)
    elseif ( theElement == getLocalPlayer() ) then
        local id = tonumber(getElementData(source, "id"))
        addEventHandler("onClientRender", getRootElement(), render)
		lift = id
    end
end
addEventHandler("onClientColShapeHit",resourceRoot,onClientColShapeHit)

function renderText()
    local playerX, playerY, playerZ = getElementPosition(localPlayer)

    if playerZ then
        local sx, sy = getScreenFromWorldPosition(1442.2279052734, -1793.0145263672 - 2, playerZ + 0.5) 

        if not sx and sy then 
            return 
        end 

        local panelPos = {
            x = sx - panelSize.x / 2, 
            y = sy - panelSize.y / 2
        }
    buttonsC = {}
    dxDrawRectangle(panelPos.x, panelPos.y+respc(50), panelSize.x, panelSize.y-respc(350), tocolor(35, 35, 35))
   -- drawButton("lift","Lift hívása",computerPos.x + respc(250), computerPos.y + respc(16), computerPos.w - respc(506), respc(20),{61, 122, 188},false,lunabar)
    drawButton("lift","Lift hívása",panelPos.x + 4, panelPos.y + respc(54), panelSize.x - 8, respc(50) - 8,{61, 122, 188},false,lunabar)
    local relX, relY = getCursorPosition()

    activeButtonC = false

    if relX and relY then
        relX = relX * screenX
        relY = relY * screenY

        for k, v in pairs(buttonsC) do
            if relX >= v[1] and relY >= v[2] and relX <= v[1] + v[3] and relY <= v[2] + v[4] then
                activeButtonC = k
                break
            end
        end
    end
end
end

function onClientColShapeLeave( theElement, matchingDimension )
    if ( theElement == getLocalPlayer() ) then
		removeEventHandler("onClientRender", getRootElement(), render)
		lift = nil
		removeEventHandler("onClientRender", root, renderText)
    end
end
addEventHandler("onClientColShapeLeave",resourceRoot,onClientColShapeLeave)


function playS3D(s,x,y,z)
	playSound3D(s, x,y,z, false)
end
addEvent("playS3D", true)
addEventHandler("playS3D", root, playS3D)

function attachElevatorSoundForElevator(element)
	sound = playSound3D("elevator.ogg", 0,0,0, true)
	attachElements ( sound, element, 0, 0, 2 )
end
addEvent("attachElevatorSoundForElevator", true)
addEventHandler("attachElevatorSoundForElevator", root, attachElevatorSoundForElevator)

function detachElevatorSoundForElevator(element)
	detachElements ( sound, element )
	destroyElement(sound)
end
addEvent("detachElevatorSoundForElevator", true)
addEventHandler("detachElevatorSoundForElevator", root, detachElevatorSoundForElevator)