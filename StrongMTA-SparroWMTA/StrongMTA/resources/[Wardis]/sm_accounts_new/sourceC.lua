local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

function resp(x)
	return (x * responsiveMultipler)
end

local panelW, panelH = respc(400), respc(300)

addEventHandler("onClientResourceStart", resourceRoot,
	function(res)
		showLoginPanel()	
		loadFonts()

		startEditBox()

		changePage("login")
	end
)

renderData = {}

renderData.buttonSliderOffsets = {}
renderData.buttonStartSlider = {}
renderData.buttonSliderStates = {}

function drawButtonSlider(key, state, x, y, h, offColor, onColor)
	if not renderData.buttonSliderOffsets[key] then
		renderData.buttonSliderOffsets[key] = state and respc(45) or 0
		renderData.buttonSliderStates[key] = state
	end

	local buttonColor

	if state then
		buttonColor = {processColorSwitchEffect(key, {onColor[1], onColor[2], onColor[3], 0})}
	else
		buttonColor = {processColorSwitchEffect(key, {offColor[1], offColor[2], offColor[3], 200})}
	end

	if renderData.buttonSliderStates[key] ~= state then
		renderData.buttonSliderStates[key] = state
		renderData.buttonStartSlider[key] = {getTickCount(), state}
	end

	if renderData.buttonStartSlider[key] then
		local progress = (getTickCount() - renderData.buttonStartSlider[key][1]) / 1200

		if  renderData.buttonStartSlider[key][2] then
			renderData.buttonSliderOffsets[key] = interpolateBetween(renderData.buttonSliderOffsets[key], 0, 0, respc(45), 0, 0, progress, "Linear")
		else
			renderData.buttonSliderOffsets[key] = interpolateBetween(renderData.buttonSliderOffsets[key], 0, 0, 0, 0, 0, progress, "Linear")
		end

		if progress >= 1 then
			renderData.buttonStartSlider[key] = false
		end
	end

	local alphaDifference = 200 - buttonColor[4]

	buttonsC[key] = {x, y, respc(64), respc(32)}

	y = y

	dxDrawRectangle(x - 2, y + 2, respc(90) - 3, h - 3 - 4, tocolor(45, 45, 45, 200))
	dxDrawRectangle(x + renderData.buttonSliderOffsets[key], y + 2 + 2, respc(45) - 3 - 4, h - 3 - 4 - 4, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], 0 + alphaDifference))
	dxDrawRectangle(x + renderData.buttonSliderOffsets[key], y + 2 + 2, respc(45) - 3 - 4, h - 3 - 4 - 4, tocolor(55, 55, 55, 200))
end

function loadFonts()
	Raleway = exports.sm_core:loadFont("Raleway.ttf", respc(15), false, "antialiased")
end

addEventHandler("onAssetsLoaded", getRootElement(),
	function ()
		loadFonts()
	end
)

function showLoginPanel()
	addEventHandler("onClientRender", getRootElement(), renderLogin)
	addEventHandler("onClientClick", getRootElement(), clickOnLogin)

	setCameraMatrix(1965.7639160156, -1744.7449951172, 25.546875, 1941.5534667969, -1773.6271972656, 14.146897315979)
end

function startEditBox()
	addEventHandler("onClientKey", getRootElement(), editBoxesKey)
	addEventHandler("onClientCharacter", getRootElement(), editBoxesCharacter)
	addEventHandler("onClientRender", getRootElement(), renderEditBoxes)
end

function changePage(pageID, oldPage)
	if pageID == "login" then
        dxCreateEdit("userNameBox","","Felhasználónév", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(40) - 3, panelW - 6, respc(45) - 3, Raleway, 0.5)
        dxCreateEdit("passwordBox","","Jelszó", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(40), panelW - 6, respc(45) - 3, Raleway, 0.5)

        pageText = "Bejelentkezés"
    elseif pageID == "registerDatas" then
    	if oldPage == "login" then
    		dxDestroyEdit("userNameBox")
    		dxDestroyEdit("passwordBox")
    	end

    	pageText = "Regisztráció"

    	dxCreateEdit("userNameBox","","Felhasználónév", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(40) - 3, panelW - 6, respc(45) - 3, Raleway, 0.5)
        dxCreateEdit("passwordBox","","Jelszó", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(40), panelW - 6, respc(45) - 3, Raleway, 0.5)
        dxCreateEdit("passwordBox2","","Jelszó 2x", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(90) - 3 + respc(40), panelW - 6, respc(45) - 3, Raleway, 0.5)
        dxCreateEdit("passwordBox2","","Email", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(90) - 3 + respc(85), panelW - 6, respc(45) - 3, Raleway, 0.5)
    end

    currentPage = pageID
end

activeButtonC = false

addCommandHandler("asd", 
	function()
		state = not state
	end
)

function renderLogin()
	buttonsC = {}

	if currentPage == "login" or currentPage == "registerDatas" then
		dxDrawRectangle(0, 0, screenX, screenY, tocolor(10, 10, 10, 240))
		dxDrawRectangle(5, screenX-respc(30)-5, screenY-10, respc(30), tocolor(25, 25, 25))

		dxDrawRectangle(screenX / 2 - panelW / 2, screenY / 2 - panelH / 2, panelW, panelH, tocolor(25, 25, 25))
		dxDrawRectangle(screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3, panelW - 6, respc(40) - 6, tocolor(44, 44, 44, 180))
		dxDrawText("#3d7abcStrong#ffffffMTA - " .. pageText, screenX / 2 - panelW / 2 + 3 + respc(5), screenY / 2 - panelH / 2 + 3 + respc(20) - 6, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center", false, false, false, true)
	end

	if currentPage == "login" then
		drawButton("startLogin", "Bejelentkezés", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85) + respc(45), panelW - 6, respc(45) - 3, {61, 122, 188}, false, Raleway, true, 1)
		drawButton("startRegister", "Regisztráció", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85) + respc(90), panelW - 6, respc(45) - 3, {61, 122, 188}, false, Raleway, true, 1)
		
		dxDrawRectangle( screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85), panelW - 6, respc(45) - 3, tocolor(0, 0, 0, 70))
		dxDrawText("Jelszó megjegyzése", screenX / 2 - panelW / 2 + 3 + respc(5), screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85) + respc(45) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center")
		drawButtonSlider("rememberMe", state, screenX / 2 - panelW / 2 + 3 + panelW - respc(90) - 3, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85), respc(45), {61, 122, 188, 200}, {61, 122, 188, 200})
		
		dxDrawRectangle(screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85) + respc(135), panelW - 6, respc(35) - 3, tocolor(55, 55, 55, 180))

		dxDrawRectangle(screenX / 2 - panelW / 2 + 3 + 2, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85) + respc(135) + 2, panelW - 6 - 4, respc(35) - 3 - 4, tocolor(61, 122, 188, 120))
		dxDrawText("100%", screenX / 2 - panelW / 2 + 3 + 2 + (panelW - 6 - 4) / 2, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85) + respc(135) + 2 + (respc(35) - 3 - 4) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "center", "center")
	elseif currentPage == "registerDatas" then
		dxDrawRectangle( screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85), panelW - 6, respc(45) - 3, tocolor(0, 0, 0, 70))
		--dxDrawText("Jelszó megjegyzése", screenX / 2 - panelW / 2 + 3 + respc(5), screenY / 2 - panelH / 2 + 3 + respc(45) - 3 + respc(85) + respc(45) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, Raleway, "left", "center")
		drawButtonSlider("rememberMe", state, screenX / 2 - panelW / 2 + 3 + panelW - respc(90) - 3, screenY / 2 - panelH / 2 + 3 + respc(135) - 3 + respc(85) + respc(2), respc(30) - 3, {61, 122, 188, 200}, {61, 122, 188, 200})
		dxDrawText("Elfogadom az ÁSZF - et", screenX / 2 - panelW / 2 + 3 + respc(5), screenY / 2 - panelH / 2 + 3 + respc(135) - 3 + respc(85) + respc(2) + (respc(30)) / 2 - 3, nil, nil, tocolor(200, 200, 200, 200), 0.8, Raleway, "left", "center")
		drawButton("finalRegister", "Regisztráció", screenX / 2 - panelW / 2 + 3, screenY / 2 - panelH / 2 + 3 + respc(75) - 3 + respc(85) + respc(90), panelW - 6, respc(50) - 3, {61, 122, 188}, false, Raleway, true, 1)
	end

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

function clickOnLogin(sourceKey, keyState)
	if sourceKey == "left" and keyState == "down" then
		if activeButtonC then
			if activeButtonC == "startLogin" then
				print("login")
			elseif activeButtonC == "startRegister" then
				showRegisterPanel()
			end
		end
	end 
end

function showRegisterPanel()
	changePage("registerDatas", currentPage)
end