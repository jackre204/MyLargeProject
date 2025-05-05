phoneX, phoneY = screenX - respc(274) - 100, 200

local editBox = {}

local phoneData = {
    phoneW = respc(274),
    phoneH = respc(546),
    phoneMode = "phone.Locked",
    indicatorPressed = false,
    wallPaperY = 0,
    indicatorY = phoneY + respc(546) - respc(30),
    phoneState = true,

    settings = {
        sound = true,
        wallpaper = 1,
        lockscreen = 1,
        ringote = 1,
        vibrate = true,
        notiSound = 1,
        showAds = true,
        numberShow = true
    },

    actualPhoneID = 2324242424,

    numberOfWallpapers = 7, 
    approveTick = 0,
    approveY = 0,

    deleteNotification = false,
    notificationAlpha = false,
    notificationTick = getTickCount(),

    newContactState = true,
    selectedMessageContact = 0
}

local sanFranciscoFontBig = dxCreateFont("files/fonts/sanFrancisco.otf", respc(30))
local sanFranciscoFontSmall = dxCreateFont("files/fonts/sanFrancisco.otf", respc(10))
local montSerratFont = dxCreateFont("files/fonts/montSerrat.otf", respc(9))
local montSerratBoldFont = dxCreateFont("files/fonts/montSerratBold.ttf", respc(30))

local monthNames = {
	[0] = "Január",
	[1] = "Február",
	[2] = "Március",
	[3] = "Április",
	[4] = "Május",
	[5] = "Június",
	[6] = "Július",
	[7] = "Augusztus",
	[8] = "Szeptember",
	[9] = "Október",
	[10] = "November",
	[11] = "December"
}

local dayNames = {
	[0] = "Vasárnap",
	[1] = "Hétfő",
	[2] = "Kedd",
	[3] = "Szerda",
	[4] = "Csütörtök",
	[5] = "Péntek",
	[6] = "Szombat"
}

local lockRenderTarget = dxCreateRenderTarget(phoneData.phoneW, phoneData.phoneH, true)
local settingRenderTarget = dxCreateRenderTarget(phoneData.phoneW, phoneData.phoneH, true)
local myScreenSource = dxCreateScreenSource(screenX, screenY)

local contactIcon = svgCreate(respc(38), respc(38), "files/apps/contacts.svg")
local messageIcon = svgCreate(respc(38), respc(38), "files/apps/messages.svg")
local cameraIcon = svgCreate(respc(38), respc(38), "files/apps/camera.svg")
local phoneIcon = svgCreate(respc(38), respc(38), "files/apps/phone.svg")

local calculatorIcon = svgCreate(respc(38), respc(38), "files/apps/calculator.svg")
local advertisementIcon = svgCreate(respc(38), respc(38), "files/apps/advertisement.svg")
local settingIcon = svgCreate(respc(38), respc(38), "files/apps/settings.svg")
local hoverTexture = svgCreate(respc(38), respc(38), "files/apps/hover.svg")
local notesIcon = svgCreate(respc(38), respc(38), "files/apps/notes.svg")
local stocksIcon = svgCreate(respc(38), respc(38), "files/apps/stocks.svg")

local bottonApps = {
    [1] = {icon = "phone"},
    [2] = {icon = "contacts"},
    [3] = {icon = "messages"},
    [4] = {icon = "camera"}
}

appIcons = {
	bottonApps = {
		[1] = phoneIcon,
		[2] = contactIcon,
		[3] = messageIcon,
		[4] = cameraIcon,
	},

	upperApps = {
		[1] = calculatorIcon,
		[2] = advertisementIcon,
		[3] = settingIcon,
        --[4] = notesIcon,
        [4] = stocksIcon
	}
	
}

local upperApps = {
    [1] = {icon = "calculator", name = "Számológép"},
    --[2] = {icon = "illegalad", name = "Szar \n nem kell"},
    [2] = {icon = "advertisement", name = "Hirdetés"},
    [3] = {icon = "settings", name = "Beállítások"},
    --[4] = {icon = "notes", name = "Jegyzetek"},
    [4] = {icon = "stocks", name = "Részvények"},
}


local defaultSettings = {
    [1] = {icon = "wallpaper", name = "Háttérképek"},
    [2] = {icon = "ringtone", name = "Csengőhangok"},
    [3] = {icon = "notification", name = "Értesítések"}
}

local slideBarSetttings = {
    [1] = {icon = "sound", name = "Hang"},
    [2] = {icon = "number", name = "Rezgés"},
    [3] = {icon = "vibration", name = "Saját szám:"}
}

local ringotesTable = {
    [1] = {patch = "atria", name = "Hang"},
    [2] = {patch = "callisto", name = "Rezgés"},
    [3] = {patch = "dione", name = "Saját szám:"},
    [4] = {patch = "ganymede", name = "Saját szám:"},
    [5] = {patch = "luna", name = "Saját szám:"},
    [6] = {patch = "oberon", name = "Saját szám:"},
    [7] = {patch = "phobos", name = "Saját szám:"},
    [8] = {patch = "pyxis", name = "Saját szám:"},
    [9] = {patch = "sedna", name = "Saját szám:"},
    [10] = {patch = "titania", name = "Saját szám:"},
    [11] = {patch = "triton", name = "Saját szám:"},
    [12] = {patch = "umbriel", name = "Saját szám:"},
}

local notificationsTable = {
    [1] = {patch = "ariel", name = "Megjegyzés"},
    [2] = {patch = "carme", name = "Hang"},
    [3] = {patch = "ceres", name = "Hang"},
    [4] = {patch = "elara", name = "Hang"},
    [5] = {patch = "europa", name = "Hang"},
    [6] = {patch = "lapetus", name = "Hang"},
    [7] = {patch = "lo", name = "Hang"},
    [8] = {patch = "rhea", name = "Hang"},
    [9] = {patch = "salacia", name = "Hang"},
    [10] = {patch = "tethys", name = "Hang"},
    [11] = {patch = "titan", name = "Hang"},
}

local phoneNumbers = {
    {"1","2","3"},
    {"4","5","6"},
    {"7","8","9"},
    {"*","0","#"},
}

local actualCallMessages = {
	{"apad", 212121212},
	{"a te apadat te csoves kutya", 2324242424}
}

local mobileContacts = {
	{name = "asd123", number = "342343242342"},
	{name = "asdd123", number = "342343242342"},
	{name = "asdwd123", number = "342343242342"},
	{name = "a2sd123", number = "342343242342"},
}

local currentTick = 0
local tickState = true

function phoneClientRender()
    local realTime = getRealTime()

    if realTime.hour < 10 then
        realTime.hour = "0" .. realTime.hour
    end 

    if realTime.minute < 10 then
        realTime.minute = "0" .. realTime.minute
    end

    if getTickCount() - currentTick >= 500 then
      	tickState = not tickState
      	currentTick = getTickCount()
    end
    phoneData.activeDirectX = ""
    dxDrawImage(phoneX, phoneY, phoneData.phoneW, phoneData.phoneH, "files/wallpapers/" .. phoneData.settings.wallpaper .. ".png")

    if phoneData.phoneMode == "phone.Locked" then
        if phoneData.indicatorPressed then
            cursorX, cursorY = getCursorPosition()
            phoneData.indicatorY = cursorY * screenY - phoneData.movingOffsetY

            phoneData.wallPaperY = cursorY * screenY - phoneData.wallPaperOffsetY - phoneY

            if phoneData.indicatorY >= phoneY + phoneData.phoneH - respc(30) then
                phoneData.indicatorY = phoneY + phoneData.phoneH - respc(30)
                phoneData.wallPaperY = 0
            elseif phoneData.indicatorY <= phoneY + respc(15) then
                phoneData.indicatorY = phoneY + respc(15)
            end
        elseif phoneData.moveState == "" then
            phoneData.indicatorY = phoneY + phoneData.phoneH - respc(30)
        end

        if phoneData.moveState == "close" then
            local progress = (getTickCount() - phoneData.closeTick) / 1000

            phoneData.indicatorY = interpolateBetween(phoneData.indicatorY, 0, 0, phoneY + phoneData.phoneH - respc(30), 0, 0, progress, "Linear")
            phoneData.wallPaperY = interpolateBetween(phoneData.wallPaperY, 0, 0, 0, 0, 0, progress, "Linear")
            
            if phoneData.indicatorY >= phoneY + phoneData.phoneH - respc(30) then
                phoneData.moveState = ""
            end
        elseif phoneData.moveState == "open" then
            local progress = (getTickCount() - phoneData.closeTick) / 1000

            phoneData.indicatorY = interpolateBetween(phoneData.indicatorY, 0, 0, phoneY + respc(15), 0, 0, progress, "Linear")
            phoneData.wallPaperY = interpolateBetween(phoneData.wallPaperY, 0, 0, -respc(546), 0, 0, progress, "Linear")
        
            if phoneData.indicatorY <= phoneY + respc(16) then
                phoneData.moveState = ""
                phoneData.alphaTick = getTickCount()
                phoneData.phoneMode = "phone.UnLocked"
                phoneData.selectedMenu = "headMenu"
                --phoneData.selectedMenu = "messages"
            end
        end

        dxSetRenderTarget(lockRenderTarget, true)
            dxSetBlendMode("modulate_add")
                dxDrawImage(0, phoneData.wallPaperY - respc(10), phoneData.phoneW, phoneData.phoneH, "files/wallpapers/" .. phoneData.settings.lockscreen .. ".png")
                dxDrawImage(0, phoneData.wallPaperY - respc(10), phoneData.phoneW, phoneData.phoneH, "files/lock.png")
                dxDrawImage(0, phoneData.wallPaperY - respc(10), phoneData.phoneW, phoneData.phoneH, "files/statusbar.png")
                dxDrawText(realTime.hour .. ":" .. realTime.minute, 0, phoneData.wallPaperY + respc(80), phoneData.phoneW, phoneData.phoneH, tocolor(255, 255, 255, 200), 1, sanFranciscoFontBig, "center", "top")
                dxDrawText(dayNames[realTime.weekday] .. ", " .. monthNames[realTime.month] .. " " .. realTime.monthday, 0, phoneData.wallPaperY + respc(135), phoneData.phoneW, phoneData.phoneH, tocolor(255, 255, 255, 200), 1, sanFranciscoFontSmall, "center", "top")
                dxDrawText("Húzd fel a feloldáshoz", 0, phoneData.wallPaperY + respc(485), phoneData.phoneW, phoneData.phoneH, tocolor(255, 255, 255, 200), 1, sanFranciscoFontSmall, "center", "top")
            dxSetBlendMode("blend")
        dxSetRenderTarget()
 
        dxDrawImage(phoneX, phoneY + respc(10), phoneData.phoneW, phoneData.phoneH, lockRenderTarget)
        dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneData.indicatorY, respc(120), respc(5), "files/home_indicator.png")
    else
        local progress = (getTickCount() - phoneData.alphaTick) / 250
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "Linear")

        dxDrawImage(phoneX, phoneY, phoneData.phoneW, phoneData.phoneH, "files/statusbar.png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha), true)
        dxDrawText((realTime.hour) .. ":" .. realTime.minute, phoneX + respc(19), phoneY + respc(23), phoneX + respc(71), phoneY + respc(36), tocolor(255, 255, 255, 200 * alpha), 1, sanFranciscoFontSmall, "center", "center", false, false, true)
    
        if phoneData.selectedMenu ~= "" then
            menuAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "Linear")
        else
            menuAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, progress, "Linear")
        end

        if phoneData.selectedMenu == "headMenu" then
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(110), phoneY + phoneData.phoneH - respc(85), respc(220), respc(60), "files/bottom_bg.png", 0, 0, 0, tocolor(0, 0, 0, 180 * alpha))
        
            for k, v in pairs(bottonApps) do
                dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(101) + (k - 1) * respc(55), phoneY + phoneData.phoneH - respc(74), respc(38), respc(38), appIcons.bottonApps[k], 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))
            
                if isInSlot(phoneX + phoneData.phoneW / 2 - respc(101) + (k - 1) * respc(55), phoneY + phoneData.phoneH - respc(74), respc(38), respc(38)) then
                    drawImageByState("bottomHover" .. v.icon, phoneX + phoneData.phoneW / 2 - respc(101) + (k - 1) * respc(55), phoneY + phoneData.phoneH - respc(74), respc(38), respc(38), {0, 0, 0, 100}, true, hoverTexture)
                      phoneData.activeDirectX = v.icon
                else
                    drawImageByState("bottomHover" .. v.icon, phoneX + phoneData.phoneW / 2 - respc(101) + (k - 1) * respc(55), phoneY + phoneData.phoneH - respc(74), respc(38), respc(38), {0, 0, 0, 100}, false, hoverTexture)
                end
            end

            for k, v in pairs(upperApps) do
                dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(101) + (k - 1) * respc(55), phoneY + respc(55), respc(38), respc(38), appIcons.upperApps[k], 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))
                dxDrawText(v.name, phoneX + phoneData.phoneW / 2 - respc(106) + (k - 1) * respc(55), phoneY + respc(100), phoneX + phoneData.phoneW / 2 - respc(106) + (k - 1) * respc(55) + respc(45), 0, tocolor(255, 255, 255, 255 * alpha), 0.6, sanFranciscoFontSmall, "center", "top")
            
                if isInSlot(phoneX + phoneData.phoneW / 2 - respc(101) + (k - 1) * respc(55), phoneY + respc(55), respc(38), respc(38)) then
                    drawImageByState("topHover" .. k, phoneX + phoneData.phoneW / 2 - respc(101) + (k - 1) * respc(55), phoneY + respc(55), respc(38), respc(38), {0, 0, 0, 100}, true, hoverTexture)
                    phoneData.activeDirectX = v.icon
                else
                    drawImageByState("topHover" .. k, phoneX + phoneData.phoneW / 2 - respc(101) + (k - 1) * respc(55), phoneY + respc(55), respc(38), respc(38), {0, 0, 0, 100}, false, hoverTexture)
                end
            end
        elseif phoneData.selectedMenu == "settings" then
            dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255 * menuAlpha))
            dxDrawText("Beállítások", phoneX, phoneY + respc(35), phoneX + phoneData.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "center", "center")
        
            drawImageHover("backHoverSettings", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")

            if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
                phoneData.activeDirectX = "headMenu"
            end

            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
            dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(69), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        
            for k, v in pairs(defaultSettings) do
                drawButtonByState("settingsHoverBG" .. k, phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30), respc(240), respc(30), {27, 28, 30, 255 * menuAlpha}, {44, 44, 46, 255})
                dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(112), phoneY + respc(75) + (k - 1) * respc(30), respc(20), respc(20), "files/settings/" .. v.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
                dxDrawText(v.name, phoneX + phoneData.phoneW / 2 - respc(72), phoneY + respc(75) + (k - 1) * respc(30), 0, phoneY + respc(95) + (k - 1) * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "left", "center")
            
                if isInSlot(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30), respc(240), respc(30)) then
                    phoneData.activeDirectX = v.icon
                end

                dxDrawImage(phoneX + phoneData.phoneW / 2 + respc(90), phoneY + respc(70) + (k - 1) * respc(30), respc(30), respc(30), "files/settings/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
            
                if k < 3 then
                    dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(72), phoneY + respc(99) + (k - 1) * respc(30), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
                end
            end

            dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + #defaultSettings * respc(30), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
            dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(69) + respc(120), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
       
            for k, v in pairs(slideBarSetttings) do
                drawButtonByState("secondSettingsHoverBG" .. k, phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30) + respc(120), respc(240), respc(30), {27, 28, 30, 255 * menuAlpha}, {44, 44, 46, 255})
                dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(112), phoneY + respc(75) + (k - 1) * respc(30) + respc(120), respc(20), respc(20), "files/settings/" .. v.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
                dxDrawText(v.name, phoneX + phoneData.phoneW / 2 - respc(72), phoneY + respc(75) + (k - 1) * respc(30) + respc(120), 0, phoneY + respc(95) + (k - 1) * respc(30) + respc(120), tocolor(255, 255, 255, 255 * menuAlpha), 0.9, sanFranciscoFontSmall, "left", "center")
            
                if k == 1 then
                    drawButtonSlider("slider" .. k, phoneData.settings.sound, phoneX + phoneData.phoneW / 2 + respc(80), phoneY + respc(205) + (k - 1) * respc(30), respc(13), {52, 52, 55, 255}, {48, 209, 88, 255})
                    dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(72), phoneY + respc(99) + (k - 1) * respc(30) + respc(120), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))          
                elseif k == 2 then
                    drawButtonSlider("slider" .. k, phoneData.settings.vibrate, phoneX + phoneData.phoneW / 2 + respc(80), phoneY + respc(205) + (k - 1) * respc(30), respc(13), {52, 52, 55, 255}, {48, 209, 88, 255})
                    dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(72), phoneY + respc(99) + (k - 1) * respc(30) + respc(120), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
                else
                    dxDrawText(phoneData.actualPhoneID, phoneX + phoneData.phoneW / 2, phoneY + respc(75) + (k - 1) * respc(30) + respc(120), 0, phoneY + respc(95) + (k - 1) * respc(30) + respc(120), tocolor(255, 255, 255, 255 * menuAlpha), 0.9, sanFranciscoFontSmall, "left", "center")
                end
            end
            dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + #slideBarSetttings * respc(30) + respc(120), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        elseif phoneData.selectedMenu == "wallpaper" then
            dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
            dxDrawText("Háttérképek", phoneX, phoneY + respc(35), phoneX + phoneData.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "center")
            drawImageHover("backHoverWallpaper", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")
        
            for k = 1, phoneData.numberOfWallpapers do
                drawButtonByState("wallPaperHoverBG" .. k, phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30), respc(240), respc(30), {27, 28, 30, 255}, {44, 44, 46, 255})
                dxDrawText("Háttérkép " .. k, phoneX + phoneData.phoneW / 2 - respc(105), phoneY + respc(75) + (k - 1) * respc(30), 0, phoneY + respc(95) + (k - 1) * respc(30), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "left", "center")
            
                if phoneData.settings.wallpaper == k then
                    dxDrawImage(phoneX + phoneData.phoneW / 2 + respc(90), phoneY + respc(70) + (k - 1) * respc(30), respc(30), respc(30), "files/settings/tick.png")
                end
            end

            if phoneData.approveState then
                phoneData.approveY = interpolateBetween(phoneData.approveY, 0, 0, phoneData.phoneH - respc(185), 0, 0, (getTickCount() - phoneData.approveTick) / 1000, "Linear")
            else
                phoneData.approveY = interpolateBetween(phoneData.approveY, 0, 0, phoneData.phoneH, 0, 0, (getTickCount() - phoneData.approveTick) / 1000, "Linear")
            end

            dxSetRenderTarget(settingRenderTarget, true)
                dxSetBlendMode("modulate_add")
                dxDrawImage(phoneData.phoneW / 2 - respc(115), phoneData.approveY, respc(230), respc(90), "files/settings/approvebg.png", 0, 0, 0, tocolor(27, 28, 30, 255))
                dxDrawImage(phoneData.phoneW / 2 - respc(115), phoneData.approveY + respc(95), respc(230), respc(30), "files/settings/approve_bottonbg.png", 0, 0, 0, tocolor(27, 28, 30, 255))
                
                drawImageByHover("approveUp1", phoneData.phoneW / 2 - respc(115), phoneData.approveY, respc(230), respc(30), phoneX + phoneData.phoneW / 2 - respc(115), phoneY + phoneData.approveY, respc(230), respc(30), {44, 44, 46, 255}, "files/settings/approve_up_hover.png")
                drawHoverButton("approveMiddle", phoneData.phoneW / 2 - respc(115), phoneData.approveY + respc(30), respc(230), respc(30), phoneX + phoneData.phoneW / 2 - respc(115), phoneY + phoneData.approveY + respc(30), respc(230), respc(30), {44, 44, 46, 0}, {44, 44, 46, 255})
                drawImageByHover("approveUp2", phoneData.phoneW / 2 - respc(115), phoneData.approveY + respc(60), respc(230), respc(30), phoneX + phoneData.phoneW / 2 - respc(115), phoneY + phoneData.approveY + respc(60), respc(230), respc(30), {44, 44, 46, 255}, "files/settings/approve_up_hover.png", 500, false, -180)
                drawImageByHover("approveDown", phoneData.phoneW / 2 - respc(115), phoneData.approveY + respc(95), respc(230), respc(30), phoneX + phoneData.phoneW / 2 - respc(115), phoneY + phoneData.approveY + respc(95), respc(230), respc(30), {44, 44, 46, 255}, "files/settings/approve_bottonbg.png")

                dxDrawText("Zárolt képernyő", phoneData.phoneW / 2 - respc(115), phoneData.approveY, phoneData.phoneW / 2 - respc(115) + respc(230), phoneData.approveY + respc(30), tocolor(61, 108, 165, 255), 1, sanFranciscoFontSmall, "center", "center")
                dxDrawText("Főképernyő", phoneData.phoneW / 2 - respc(115), phoneData.approveY + respc(30), phoneData.phoneW / 2 - respc(115) + respc(230), phoneData.approveY + respc(60), tocolor(61, 108, 165, 255), 1, sanFranciscoFontSmall, "center", "center")
                dxDrawText("Mindkettő", phoneData.phoneW / 2 - respc(115), phoneData.approveY + respc(60), phoneData.phoneW / 2 - respc(115) + respc(230), phoneData.approveY + respc(90), tocolor(61, 108, 165, 255), 1, sanFranciscoFontSmall, "center", "center")
                dxDrawText("Mégse", phoneData.phoneW / 2 - respc(115), phoneData.approveY + respc(95), phoneData.phoneW / 2 - respc(115) + respc(230), phoneData.approveY + respc(95) + respc(30), tocolor(61, 108, 165, 255), 1, sanFranciscoFontSmall, "center", "center")
                dxSetBlendMode("blend")
            dxSetRenderTarget()

            dxDrawImage(phoneX, phoneY, phoneData.phoneW, phoneData.phoneH - respc(10), settingRenderTarget)
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        
        elseif phoneData.selectedMenu == "ringtone" then
            dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
            dxDrawText("Csengőhangok", phoneX, phoneY + respc(35), phoneX + phoneData.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "center")
            drawImageHover("backHoverRingtone", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")
        
            for k, v in pairs(ringotesTable) do
                drawButtonByState("ringtoneHoverBG" .. k, phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30), respc(240), respc(30), {27, 28, 30, 255}, { 44, 44, 46, 255})
                dxDrawText("Csengőhang " .. k, phoneX + phoneData.phoneW / 2 - respc(105), phoneY + respc(75) + (k - 1) * respc(30), 0, phoneY + respc(95) + (k - 1) * respc(30), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "left", "center")
            
                if phoneData.settings.ringote == k then
                    dxDrawImage(phoneX + phoneData.phoneW / 2 + respc(90), phoneY + respc(70) + (k - 1) * respc(30), respc(30), respc(30), "files/settings/tick.png")
                end
            end
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        elseif phoneData.selectedMenu == "notification" then
            dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
            dxDrawText("Értesítések", phoneX, phoneY + respc(35), phoneX + phoneData.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "center")
            drawImageHover("backHoverNotification", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")
            
            for k, v in pairs(notificationsTable) do
                drawButtonByState("notificationHoverBG" .. k, phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30), respc(240), respc(30), {27, 28, 30, 255}, {44, 44, 46, 255})
            
                dxDrawText(v.name, phoneX + phoneData.phoneW / 2 - respc(105), phoneY + respc(75) + (k - 1) * respc(30), 0, phoneY + respc(95) + (k - 1) * respc(30), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "left", "center")
            
                if phoneData.settings.notiSound == k then
                    dxDrawImage(phoneX + phoneData.phoneW / 2 + respc(90), phoneY + respc(70) + (k - 1) * respc(30), respc(30), respc(30), "files/settings/tick.png")
                end
            end
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        elseif phoneData.selectedMenu == "advertisement" then
            dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
            dxDrawText("Hirdetések", phoneX, phoneY + respc(35), phoneX + phoneData.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "center")
            drawImageHover("backHoverAdvertisement", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")
            drawButtonByState("advertisementsState", phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + 0 * respc(30), respc(240), respc(30), {27, 28, 30, 255 * menuAlpha}, {44, 44, 46, 255})
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(112), phoneY + respc(75) + 0 * respc(30), respc(20), respc(20), "files/settings/ad.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
            
            dxDrawText("Hirdetések", phoneX + phoneData.phoneW / 2 - respc(72), phoneY + respc(75) + 0 * respc(30), 0, phoneY + respc(95) + 0 * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "left", "center")
            drawButtonSlider("showAdsSlider", phoneData.settings.showAds, phoneX + phoneData.phoneW / 2 + respc(80), phoneY + respc(85) + 0 * respc(30), respc(13), {52, 52, 55, 255}, {48, 209, 88, 255})
            drawButtonByState("showNumberState", phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + 1 * respc(30), respc(240), respc(30), {27, 28, 30, 255 * menuAlpha}, {44, 44, 46, 255})
            
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(112), phoneY + respc(75) + 1 * respc(30), respc(20), respc(20), "files/settings/number.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
            dxDrawText("Telefonszám kijelzése", phoneX + phoneData.phoneW / 2 - respc(72), phoneY + respc(75) + 1 * respc(30), 0, phoneY + respc(95) + 1 * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "left", "center")
            drawButtonSlider("showNumberSlider", phoneData.settings.numberShow, phoneX + phoneData.phoneW / 2 + respc(80), phoneY + respc(87) + 1 * respc(30), respc(13), {52, 52, 55, 255}, {48, 209, 88, 255})
        
            dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(69), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
            dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(72), phoneY + respc(99) + 0 * respc(30), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
            dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + respc(60), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
            dxDrawImage(phoneX + respc(22), phoneY + respc(78) + 2 * respc(30), respc(230), respc(150), "files/advertisementbg.png", 0, 0, 0, tocolor(27, 28, 30, 255 * menuAlpha))
            
            drawImageHover("sendButton", phoneX + phoneData.phoneW / 2 + respc(85), phoneY + respc(80) + 2 * respc(30), respc(25), respc(25), {61, 108, 165, 255 * menuAlpha}, "files/send.png")
            dxDrawText("Hirdetés szövege:", phoneX + respc(30), phoneY + respc(80) + 2 * respc(30), 0, phoneY + respc(107) + 2 * respc(30), tocolor(255, 255, 255, 170 * menuAlpha), 1, sanFranciscoFontSmall, "left", "center")
        
            dxDrawText("Editbox Text", phoneX + respc(30), phoneY + respc(105) + 2 * respc(30), phoneX + phoneData.phoneW / 2 + respc(110), phoneY + respc(270) + 2 * respc(30), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "left", "top", false, true, true)
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        
        elseif phoneData.selectedMenu == "call.Caller" then
			dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 190))
        	drawImageWithHover("cancelCallingButton", phoneX + phoneData.phoneW / 2 - respc(45) / 2, phoneY + phoneData.phoneH - respc(140), respc(45), respc(45), {255, 255, 255, 255}, {255, 255, 255, 170}, "files/dialer/cancel.png")
       		--_UPVALUE22_.calledNumber
       		dxDrawText("+3630123434", phoneX + respc(30), phoneY + respc(80), phoneX + phoneData.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "top")
        	
        	dxDrawText("Hívás folyamatban...", phoneX + respc(30), phoneY + respc(115), phoneX + phoneData.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "top")
        	dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        
        elseif phoneData.selectedMenu == "call.Called" then
			dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 190))
        	--_UPVALUE22_.calledNumber
        	dxDrawText("+343023242442", phoneX + respc(30), phoneY + respc(80), phoneX + phoneData.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "top")
        	dxDrawText("Bejövő hívás", phoneX + respc(30), phoneY + respc(115), phoneX + phoneData.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "top")
        	
        	drawImageWithHover("cancelInComingCallButton", phoneX + respc(50), phoneY + phoneData.phoneH - respc(140), respc(45), respc(45), {255, 255, 255, 255}, {255, 255, 255, 170}, "files/dialer/cancel.png")
        	drawImageWithHover("acceptInComingCallButton", phoneX + phoneData.phoneW - respc(95), phoneY + phoneData.phoneH - respc(140), respc(45), respc(45), {255, 255, 255, 255}, {255, 255, 255, 170}, "files/dialer/call.png")
       		
       		dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        elseif phoneData.selectedMenu == "call.inCall" then
        	dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        	
        	for k, v in ipairs(actualCallMessages) do
        		--if k > _UPVALUE26_ and 0 < 8 then
        			callY = phoneY + respc(180) + (k - 1) * respc(30)

        			if tonumber(v[2]) == tonumber(phoneData.actualPhoneID) then
        				 dxDrawText("Te: " .. v[1], phoneX + respc(25), callY, 0, 0, tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "left", "top", false, false, true, true)
        			else
              			dxDrawText("Hívott: " .. v[1], phoneX + phoneData.phoneW / 2, callY, phoneX + phoneData.phoneW - respc(40), 0, tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "right", "top", false, false, true, true)
           	 		end
        		--end
        	end

        	--_UPVALUE22_.calledNumber
        	dxDrawText("+36434323232", phoneX + respc(30), phoneY + respc(55), phoneX + phoneData.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "top")
        	dxDrawText("Hívásban", phoneX + respc(30), phoneY + respc(90), phoneX + phoneData.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "center", "top")

        	drawImageWithHover("cancelInCallButton", phoneX + phoneData.phoneW / 2 - respc(45) / 2, phoneY + phoneData.phoneH - respc(100), respc(45), respc(45), {255, 255, 255, 255}, {255, 255, 255, 170}, "files/dialer/cancel.png")
        	drawImageHover("sendMessageButton", phoneX + respc(230), phoneY + respc(120), respc(25), respc(25), {61, 108, 165, 255}, "files/send.png")
        	drawImageWithHover("callMessageInput", phoneX + respc(20), phoneY + respc(120), respc(200), respc(25), {21, 21, 21, 255}, {30, 30, 30, 255}, "files/dialer/messagebg.png")
        	
        	--editBox.callInputMessage
        	dxDrawText("IDK", phoneX + respc(25), phoneY + respc(120), phoneX + respc(220), phoneY + respc(145), tocolor(255, 255, 255, 255), 1, sanFranciscoFontSmall, "left", "center")
        	dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        elseif phoneData.selectedMenu == "phone" then
            dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255 * menuAlpha))
            local aY = 0
            for i, v in pairs(phoneNumbers) do 
                for k, j in pairs(v) do
                    drawImageWithHover("keypadCircles" .. j, phoneX + respc(50) + (k - 1) * respc(65), phoneY + respc(165) + (i - 1) * respc(60), respc(45), respc(45), {51, 51, 51, 255 * menuAlpha}, {166, 166, 166, 255 * menuAlpha}, "files/dialer/circle.png")
                    dxDrawText(j, phoneX + respc(52) + (k - 1) * respc(65), phoneY + respc(165) + (i - 1) * respc(60), phoneX + respc(50) + (k - 1) * respc(65) + respc(45), phoneY + respc(165) + (i - 1) * respc(60) + respc(45), tocolor(255, 255, 255, 170 * menuAlpha), 1, sanFranciscoFontSmall, "center", "center")
                end
            end

            drawImageWithHover("phoneButton", phoneX + respc(50) + 1 * respc(65), phoneY + respc(165) + 4 * respc(60), respc(45), respc(45), {255, 255, 255, 255 * menuAlpha}, {255, 255, 255, 170 * menuAlpha}, "files/dialer/call.png")
            drawImageWithHover("deleteButton", phoneX + respc(50) + 2 * respc(65), phoneY + respc(165) + 4 * respc(60), respc(45), respc(45), {255, 255, 255, 255 * menuAlpha}, {255, 255, 255, 170 * menuAlpha}, "files/dialer/delete.png")
            
            drawImageHover("backHoverPhone", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        
        elseif phoneData.selectedMenu == "contacts" then
        	if phoneData.deleteNotification then
	          	phoneData.notificationAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - phoneData.notificationTick) / 250, "Linear")
	        else
	        	phoneData.notificationAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - phoneData.notificationTick) / 250, "Linear")
	        end
	        
	        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255 * menuAlpha))
       
	       	for k, v in pairs(mobileContacts) do
	     		drawImageWithHover("callContact" .. k, phoneX + phoneData.phoneW - respc(110), phoneY + respc(70) + (k - 1) * respc(30), respc(30), respc(30), {255, 255, 255, 255 * menuAlpha}, {115, 185, 24, 255}, "files/contacts/call.png")
	     		drawImageWithHover("messageContact" .. k, phoneX + phoneData.phoneW - respc(80), phoneY + respc(70) + (k - 1) * respc(30), respc(30), respc(30), {255, 255, 255, 255 * menuAlpha}, {104, 170, 249, 255}, "files/contacts/message.png")
	     		drawImageWithHover("deleteContact" .. k, phoneX + phoneData.phoneW - respc(50), phoneY + respc(70) + (k - 1) * respc(30), respc(30), respc(30), {255, 255, 255, 255 * menuAlpha}, {176, 44, 54, 255}, "files/contacts/delete.png")
	       		dxDrawText(v.name, phoneX + respc(25), phoneY + respc(75) + (k - 1) * respc(30), 0, phoneY + respc(95) + (k - 1) * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "left", "center")
	       		dxDrawRectangle(phoneX + respc(25), phoneY + respc(99) + (k - 1) * respc(30), respc(235), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
	       	end

	       	if #mobileContacts < 1 then
          		dxDrawText("Nincs névjegy", phoneX, phoneY, phoneX + phoneData.phoneW, phoneY + phoneData.phoneH, tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "center", "center")
        	end

        	dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(183) / 2, phoneY + phoneData.phoneH / 2 - respc(94) / 2, respc(183), respc(96), "files/contacts/notification.png", 0, 0, 0, tocolor(255, 255, 255, 255 * phoneData.notificationAlpha))
        
        	if phoneData.deleteNotification then
        		drawImageWithHover("cancelDeleteContactHover", phoneX + phoneData.phoneW / 2 - respc(185) / 2, phoneY + phoneData.phoneH / 2 - respc(94) / 2 + respc(66), respc(94), respc(30), {27, 28, 30, 0}, {44, 44, 46, 255}, "files/contacts/cancel_hover.png")
        		drawImageWithHover("acceptDeleteContactHover", phoneX + phoneData.phoneW / 2 - respc(183) / 2 + respc(90), phoneY + phoneData.phoneH / 2 - respc(94) / 2 + respc(66), respc(94), respc(30), {27, 28, 30, 0}, {44, 44, 46, 255}, "files/contacts/accept_hover.png")
        	end

        	dxDrawText("Mégsem", phoneX + phoneData.phoneW / 2 - respc(185) / 2, phoneY + phoneData.phoneH / 2 - respc(94) / 2 + respc(66), phoneX + phoneData.phoneW / 2 - respc(185) / 2 + respc(94), phoneY + phoneData.phoneH / 2 - respc(94) / 2 + respc(66) + respc(30), tocolor(10, 132, 255, 255 * phoneData.notificationAlpha), 1, sanFranciscoFontSmall, "center", "center")
        	dxDrawText("Törlés", phoneX + phoneData.phoneW / 2 - respc(185) / 2 + respc(90), phoneY + phoneData.phoneH / 2 - respc(94) / 2 + respc(66), phoneX + phoneData.phoneW / 2 - respc(185) / 2 + respc(94) + respc(90), phoneY + phoneData.phoneH / 2 - respc(94) / 2 + respc(66) + respc(30), tocolor(10, 132, 255, 255 * phoneData.notificationAlpha), 1, sanFranciscoFontSmall, "center", "center")
        	
       		dxDrawCorrectText("Névjegy Törlése", phoneX + phoneData.phoneW / 2 - respc(183) / 2, phoneY + phoneData.phoneH / 2 - respc(35), respc(183), respc(96), tocolor(255, 255, 255, 255 * phoneData.notificationAlpha), 1, sanFranciscoFontSmall, "center", "top")
       		dxDrawCorrectText("Biztosan törölni szeretnéd ezt a\nnévjegyet?", phoneX + phoneData.phoneW / 2 - respc(183) / 2, phoneY + phoneData.phoneH / 2 - respc(15), respc(183), respc(96), tocolor(255, 255, 255, 255 * phoneData.notificationAlpha), 1, sanFranciscoFontSmall, "center", "top")
       		dxDrawText("Névjegyzék", phoneX, phoneY + respc(35), phoneX + phoneData.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "center", "center")

       		drawImageWithHover("newContactButton", phoneX + phoneData.phoneW - respc(45), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, {61, 108, 165, 155}, "files/contacts/plus.png")
        	drawImageHover("backHoverContacts", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")
        	
        	if phoneData.newContactState then
        		dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(236) / 2, phoneY + respc(43), respc(236), respc(485), "files/contacts/newcontactbg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        	
        		if isInSlot(phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(10), phoneY + respc(55), respc(50), respc(25)) then
		            dxDrawCorrectText("Mégsem", phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(10), phoneY + respc(55), 0, respc(25), tocolor(10, 132, 255, 150), 1, sanFranciscoFontSmall, "left", "center")
		        else
		            dxDrawCorrectText("Mégsem", phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(10), phoneY + respc(55), 0, respc(25), tocolor(10, 132, 255, 255), 1, sanFranciscoFontSmall, "left", "center")
		        end

		        if isInSlot(phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(200), phoneY + respc(55), respc(50), respc(25)) then
		            dxDrawCorrectText("Kész", phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(200), phoneY + respc(55), 0, respc(25), tocolor(10, 132, 255, 150), 1, sanFranciscoFontSmall, "left", "center")
		       	else
		            dxDrawCorrectText("Kész", phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(200), phoneY + respc(55), 0, respc(25), tocolor(10, 132, 255, 255), 1, sanFranciscoFontSmall, "left", "center")
		        end

		        if editBox.actualEditing == "contactName" then
		            editBox.contactName = editBox.invitingText
		            
		            if tickState then
		            	dxDrawLine(phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(103) + dxGetTextWidth(editBox.contactName, 1, sanFranciscoFontSmall), phoneY + respc(120), phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(103) + dxGetTextWidth(editBox.contactName, 1, sanFranciscoFontSmall), phoneY + respc(135), tocolor(255, 255, 255, 255), 1)
		            end
		        end

		        if editBox.actualEditing == "contactNumber" then
		            editBox.contactNumber = editBox.invitingText
		           
		            if tickState then
		              	dxDrawLine(phoneX + editBox.phoneW / 2 - respc(236) / 2 + respc(53) + dxGetTextWidth(editBox.contactNumber, 1, sanFranciscoFontSmall), phoneY + respc(155), phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(53) + dxGetTextWidth(editBox.contactNumber, 1, sanFranciscoFontSmall), phoneY + respc(170), tocolor(255, 255, 255, 255), 1)
		            end
		        end

		        dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(85), phoneY + respc(140), respc(150), respc(1), tocolor(48, 49, 51, 255))
          		dxDrawRectangle(phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(25), phoneY + respc(175), respc(210), respc(1), tocolor(48, 49, 51, 255))
          		--editBox.contactName
          		dxDrawText("Wradis", phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(100), phoneY + respc(120), respc(150), respc(1), tocolor(255, 255, 255, 200), 1, sanFranciscoFontSmall, "left", "top")
          		--editBox.contactNumber
          		dxDrawText("0620823471239496294", phoneX + phoneData.phoneW / 2 - respc(236) / 2 + respc(50), phoneY + respc(155), respc(150), respc(1), tocolor(255, 255, 255, 200), 1, sanFranciscoFontSmall, "left", "top")
        	end
        	dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        elseif phoneData.selectedMenu == "messages" then
        	dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        
        	if 1 > phoneData.selectedMessageContact then
        		dxDrawText("Üzenetek", phoneX, phoneY + respc(35), phoneX + phoneData.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "center", "center")
        		drawImageWithHover("newSMSButton", phoneX + phoneData.phoneW - respc(45), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, {61, 108, 165, 155}, "files/contacts/plus.png")
        	else
        		--dxDrawText(findContactByNumber(_UPVALUE3_[_UPVALUE0_.selectedMessageContact].number) or _UPVALUE3_[_UPVALUE0_.selectedMessageContact].number, phoneX, phoneY + respc(35), phoneX + phoneData.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, sanFranciscoFontSmall, "center", "center")
        	end

        elseif phoneData.selectedMenu == "camera" then
            dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
            if myScreenSource then
                dxUpdateScreenSource(myScreenSource)
                dxDrawImage(phoneX + respc(3), phoneY + respc(115), respc(253), respc(280), myScreenSource, 0, 0, 0, tocolor(255, 255, 255, 255))
            end

            drawImageHover("takePicture", phoneX + phoneData.phoneW / 2 - respc(22), phoneY + respc(430), respc(44), respc(44), {255, 255, 255, 255}, "files/camera/circle.png")
        
            dxDrawImage(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
            drawImageHover("backHoverContacts", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")
        end
    end
    
    dxDrawImage(phoneX, phoneY, phoneData.phoneW, phoneData.phoneH, "files/iphonex.png")
end

addEventHandler("onClientRender", getRootElement(), phoneClientRender)

function clickOnMobile(sourceKey, keyState)
    if sourceKey == "left" and keyState == "down" then
        if phoneData.phoneState then
            if phoneData.phoneMode == "phone.Locked" then
                if isInSlot(phoneX + phoneData.phoneW / 2 - respc(60), phoneY + phoneData.phoneH - respc(30), respc(120), respc(5)) then
                    phoneData.closeTick = getTickCount()
                    phoneData.indicatorY = phoneY + phoneData.phoneH - respc(30)
                    phoneData.absolutWallPaperY = phoneY

                    cursorW = {
                        getCursorPosition()
                    }

                    cursorPosY = cursorW[2] * screenY
                    phoneData.movingOffsetY = cursorPosY - phoneData.indicatorY
                    phoneData.wallPaperOffsetY = cursorPosY - phoneData.absolutWallPaperY
                    phoneData.indicatorPressed = true
                end
            else
                if phoneData.activeDirectX ~= "" and phoneData.activeDirectX ~= "calculator" then
                    phoneData.selectedMenu = phoneData.activeDirectX
                    phoneData.menuAlphaTick = getTickCount()

                    return
                end

                if phoneData.selectedMenu == "settings" then
                	for k, v in pairs(slideBarSetttings) do
                		if isInSlot(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30) + respc(120), respc(240), respc(30)) then
                			if k == 1 then
                				phoneData.settings.sound = not phoneData.settings.sound
                			elseif k == 2 then
                				phoneData.settings.vibrate = not phoneData.settings.vibrate
                			end
                		end
                	end
                elseif phoneData.selectedMenu == "wallpaper" then
                    for k = 1, phoneData.numberOfWallpapers do
                        if isInSlot(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30), respc(240), respc(30)) and not phoneData.approveState then
                            phoneData.approveState = true
                            phoneData.approveTick = getTickCount()
                            phoneData.selectedWallpaper = k
                        end
                    end

                    if phoneData.approveState then
                         if isInSlot(phoneX + phoneData.phoneW / 2 - respc(115), phoneY + phoneData.approveY + respc(95), respc(230), respc(30)) then
                            phoneData.approveState = false
                            phoneData.approveTick = getTickCount()
                        elseif isInSlot(phoneX + phoneData.phoneW / 2 - respc(115), phoneY + phoneData.approveY + respc(60), respc(230), respc(30)) then
                            phoneData.approveState = false
                            phoneData.approveTick = getTickCount()

                            phoneData.settings.wallpaper = phoneData.selectedWallpaper
                            phoneData.settings.lockscreen = phoneData.selectedWallpaper
                        elseif isInSlot(phoneX + phoneData.phoneW / 2 - respc(115), phoneY + phoneData.approveY + respc(30), respc(230), respc(30)) then
                            phoneData.approveState = false
                            phoneData.approveTick = getTickCount()

                            phoneData.settings.wallpaper = phoneData.selectedWallpaper
                        elseif isInSlot(phoneX + phoneData.phoneW / 2 - respc(115), phoneY + phoneData.approveY, respc(230), respc(30)) then
                            phoneData.approveState = false
                            phoneData.approveTick = getTickCount()
                            
                            phoneData.settings.lockscreen = phoneData.selectedWallpaper
                        end
                    end

                    if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
                        if phoneData.approveState then
                            phoneData.approveState = false
                            phoneData.approveTick = getTickCount()
                        end

                        phoneData.selectedMenu = "settings"
                    end
                elseif phoneData.selectedMenu == "ringtone" then
                    for k, v in pairs(ringotesTable) do
                        if isInSlot(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30), respc(240), respc(30)) then
                            playPreviewSound("ring" .. v.patch)
                            phoneData.settings.ringote = k
                        end
                    end

                    if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
                        if isElement(previewSound) then
                            stopSound(previewSound)
                        end
                        phoneData.selectedMenu = "settings"
                    end
                elseif phoneData.selectedMenu == "notification" then
                    for k, v in pairs(notificationsTable) do
                        if isInSlot(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + (k - 1) * respc(30), respc(240), respc(30)) then
                            playPreviewSound("sms" .. v.patch)
                        
                            phoneData.settings.notiSound = k
                        end
                    end

                    if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
                        if isElement(previewSound) then
                            stopSound(previewSound)
                        end

                        phoneData.selectedMenu = "settings"
                    end
                elseif phoneData.selectedMenu == "advertisement" then
                    if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
                        phoneData.selectedMenu = "headMenu"
                        editBox.invitingText = ""
                        editBox.actualEditing = ""
                        editBox.advertEdit = ""
                    elseif isInSlot(phoneX + phoneData.phoneW / 2 + respc(85), phoneY + respc(80) + 2 * respc(30), respc(25), respc(25)) then
                        if string.len(editBox.advertEdit) > 10 then
                             if math.floor(string.len(editBox.advertEdit) * 0.58) <= getElementData(localPlayer, "char.Money") then
                                editBox.actualEditing = ""
                                editBox.advertEdit = ""

                                playerAdvertTick = getTickCount()
                            else
                                outputChatBox("#d9534f[StrongMTA]: #FFFFFFNincs elegendő egyenleged!", 255, 0, 0, true)
                            end
                        else
                            outputChatBox("#d9534f[StrongMTA]: #FFFFFFNem elegendő hosszúságú a hirdetésed!", 255, 0, 0, true)
                        end
                    elseif isInSlot(phoneX + respc(22), phoneY + respc(78) + 2 * respc(30), respc(230), respc(150)) then
                        editBox.invitingText = editBox.advertEdit
                        editBox.actualEditing = "advert"
                    elseif isInSlot(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + 1 * respc(30), respc(240), respc(30)) then
                        --numberShowing
                    elseif isInSlot(phoneX + phoneData.phoneW / 2 - respc(120), phoneY + respc(70) + 0 * respc(30), respc(240), respc(30)) then
                        --advertsShowing
                    end
                end
            end
        end
    elseif sourceKey == "left" and keyState == "up" and phoneData.indicatorPressed then
        phoneData.closeTick = getTickCount()
        phoneData.indicatorPressed = false

        if phoneData.indicatorY <= (phoneY + phoneData.phoneH) / 1.5 then
            phoneData.moveState = "open"
        else
            phoneData.moveState = "close"
        end
    end
end

addEventHandler("onClientClick", getRootElement(), clickOnMobile)

function playPreviewSound(soundPath)
    if isElement(previewSound) then
        stopSound(previewSound)
    end

    previewSound = playSound("files/sounds/" .. soundPath .. ".mp3", false)
end