addEventHandler("onClientCharacter", getRootElement(), function(_ARG_0_)
  if _UPVALUE0_.phoneState and _UPVALUE0_.phoneMode == "phone:unLocked" then
    if _UPVALUE1_.actualEditing == "callMessageInput" or _UPVALUE1_.actualEditing == "smsText" or _UPVALUE1_.actualEditing == "realSMSText" then
      _UPVALUE2_ = 25
    elseif _UPVALUE1_.actualEditing == "contactName" then
      _UPVALUE2_ = 17
    elseif _UPVALUE1_.actualEditing == "illegalad" or _UPVALUE1_.actualEditing == "advertisement" then
      _UPVALUE2_ = 200
    end
    if _UPVALUE1_.actualEditing ~= "" then
      if _UPVALUE1_.actualEditing ~= "contactNumber" and _UPVALUE1_.actualEditing ~= "messageNumber" then
        if string.len(_UPVALUE1_.invitingText) <= _UPVALUE2_ then
          _UPVALUE1_.invitingText = _UPVALUE1_.invitingText .. _ARG_0_
        end
      elseif tonumber(_UPVALUE1_.invitingText .. _ARG_0_) and tonumber(_UPVALUE1_.invitingText .. _ARG_0_) >= 1 and not string.find(_UPVALUE1_.invitingText .. _ARG_0_, "e") and tonumber(_UPVALUE1_.invitingText .. _ARG_0_) <= 100000000000 then
        _UPVALUE1_.invitingText = _UPVALUE1_.invitingText .. _ARG_0_
      end
    end
  end
end)
addEventHandler("onClientKey", getRootElement(), function(_ARG_0_, _ARG_1_)
  if _ARG_0_ == "backspace" and _ARG_1_ then
    if _UPVALUE0_.phoneState and _UPVALUE0_.phoneMode == "phone:unLocked" and _UPVALUE1_.actualEditing ~= "" and string.len(_UPVALUE1_.invitingText) >= 1 then
      _UPVALUE1_.invitingText = string.sub(_UPVALUE1_.invitingText, 1, string.len(_UPVALUE1_.invitingText) - 1)
    end
  elseif _ARG_1_ and _UPVALUE1_.actualEditing ~= "" and (_ARG_0_ ~= "mouse_wheel_up" or _ARG_0_ ~= "mouse_wheel_down") then
    cancelEvent()
  end
end)
function phoneClientRender()
  if _UPVALUE0_.phoneState and (exports.lsmta_hud:getNode(3, "showing") or getElementData(localPlayer, "valaszto")) then
    if getRealTime().hour < 10 then
    end
    if getRealTime().minute < 10 then
    end
    if getTickCount() - _UPVALUE1_ >= 500 then
      _UPVALUE2_ = not _UPVALUE2_
      _UPVALUE1_ = getTickCount()
    end
    phoneX, phoneY = exports.lsmta_hud:getNode(3, "x"), exports.lsmta_hud:getNode(3, "y")
    _UPVALUE0_.activeDirectX = ""
    dxDrawImage(phoneX, phoneY, _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, "files/wallpapers/" .. getElementData(localPlayer, "settings:Wallpaper") .. ".png")
    if _UPVALUE0_.phoneMode == "phone:locked" then
      if _UPVALUE0_.indicatorPressed then
        _UPVALUE0_.indicatorY = ({
          getCursorPosition()
        })[2] * screenY - _UPVALUE0_.movingOffsetY
        _UPVALUE0_.wallPaperY = ({
          getCursorPosition()
        })[2] * screenY - _UPVALUE0_.wallPaperOffsetY - phoneY
        if _UPVALUE0_.indicatorY >= phoneY + _UPVALUE0_.phoneH - respc(30) then
          _UPVALUE0_.indicatorY = phoneY + _UPVALUE0_.phoneH - respc(30)
          _UPVALUE0_.wallPaperY = 0
        elseif _UPVALUE0_.indicatorY <= phoneY + respc(15) then
          _UPVALUE0_.indicatorY = phoneY + respc(15)
        end
      elseif _UPVALUE0_.moveState == "" then
        _UPVALUE0_.indicatorY = phoneY + _UPVALUE0_.phoneH - respc(30)
      end
      if _UPVALUE0_.moveState == "close" then
        _UPVALUE0_.indicatorY = interpolateBetween(_UPVALUE0_.indicatorY, 0, 0, phoneY + _UPVALUE0_.phoneH - respc(30), 0, 0, (getTickCount() - _UPVALUE0_.closeTick) / 1000, "Linear")
        _UPVALUE0_.wallPaperY = interpolateBetween(_UPVALUE0_.wallPaperY, 0, 0, 0, 0, 0, (getTickCount() - _UPVALUE0_.closeTick) / 1000, "Linear")
        if _UPVALUE0_.indicatorY >= phoneY + _UPVALUE0_.phoneH - respc(30) then
          _UPVALUE0_.moveState = ""
        end
      elseif _UPVALUE0_.moveState == "open" then
        _UPVALUE0_.indicatorY = interpolateBetween(_UPVALUE0_.indicatorY, 0, 0, phoneY + respc(15), 0, 0, (getTickCount() - _UPVALUE0_.closeTick) / 1000, "Linear")
        _UPVALUE0_.wallPaperY = interpolateBetween(_UPVALUE0_.wallPaperY, 0, 0, -respc(546), 0, 0, (getTickCount() - _UPVALUE0_.closeTick) / 1000, "Linear")
        if _UPVALUE0_.indicatorY <= phoneY + respc(16) then
          _UPVALUE0_.moveState = ""
          _UPVALUE0_.alphaTick = getTickCount()
          _UPVALUE0_.phoneMode = "phone:unLocked"
        end
      end
      for _FORV_8_, _FORV_9_ in pairs(_UPVALUE3_) do
        if not _FORV_9_.opened then
        end
      end
      dxSetRenderTarget(_UPVALUE4_, true)
      dxSetBlendMode("modulate_add")
      dxDrawImage(0, _UPVALUE0_.wallPaperY - respc(10), _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, "files/wallpapers/" .. getElementData(localPlayer, "settings:lockedWallpaper") .. ".png")
      dxDrawImage(0, _UPVALUE0_.wallPaperY - respc(10), _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, "files/lock.png")
      dxDrawImage(0, _UPVALUE0_.wallPaperY - respc(10), _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, "files/statusbar.png")
      if 0 < 0 + 1 then
        dxDrawRoundedCornersRectangle("full", 8, _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.wallPaperY + respc(170), respc(230), respc(45), _UPVALUE5_, tocolor(0, 0, 0, 180))
        dxDrawImage(_UPVALUE0_.phoneW / 2 - respc(110), _UPVALUE0_.wallPaperY + respc(175), respc(15), respc(15), "files/apps/messages.png")
        dxDrawCorrectText("Üzenetek", _UPVALUE0_.phoneW / 2 - respc(90), _UPVALUE0_.wallPaperY + respc(175), respc(15), respc(15), white, 1, _UPVALUE6_, "left", "center")
        dxDrawCorrectText(0 + 1 .. " új üzeneted érkezett", _UPVALUE0_.phoneW / 2 - respc(110), _UPVALUE0_.wallPaperY + respc(195), respc(15), respc(15), white, 0.9, _UPVALUE6_, "left", "top")
      end
      dxDrawText(("0" .. getRealTime().hour) .. ":" .. "0" .. getRealTime().minute, 0, _UPVALUE0_.wallPaperY + respc(80), _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, white, 1, _UPVALUE7_, "center", "top")
      dxDrawText(exports.lsmta_system:formatDate("W") .. ", " .. convertMonthToName() .. " " .. exports.lsmta_system:formatDate("d."), 0, _UPVALUE0_.wallPaperY + respc(135), _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, white, 1, _UPVALUE6_, "center", "top")
      dxDrawText("Húzd fel a feloldáshoz", 0, _UPVALUE0_.wallPaperY + respc(485), _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, white, 1, _UPVALUE6_, "center", "top")
      dxSetBlendMode("blend")
      dxSetRenderTarget()
      dxDrawImage(phoneX, phoneY + respc(10), _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, _UPVALUE4_)
      dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), _UPVALUE0_.indicatorY, respc(120), respc(5), "files/home_indicator.png")
    else
      alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - _UPVALUE0_.alphaTick) / 250, "Linear")
      dxDrawImage(phoneX, phoneY, _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, "files/statusbar.png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha), true)
      dxDrawText(("0" .. getRealTime().hour) .. ":" .. "0" .. getRealTime().minute, phoneX + respc(19), phoneY + respc(23), phoneX + respc(71), phoneY + respc(36), tocolor(255, 255, 255, 200 * alpha), 1, _UPVALUE8_, "center", "center", false, false, true)
      if _UPVALUE0_.selectedMenu ~= "" then
        menuAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - _UPVALUE0_.menuAlphaTick) / 250, "Linear")
      else
        menuAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - _UPVALUE0_.menuAlphaTick) / 250, "Linear")
      end
      if _UPVALUE0_.selectedMenu == "headMenu" then
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(110), phoneY + _UPVALUE0_.phoneH - respc(85), respc(220), respc(60), "files/bottom_bg.png", 0, 0, 0, tocolor(0, 0, 0, 180 * alpha))
        for _FORV_9_, _FORV_10_ in pairs(_UPVALUE9_) do
          dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(101) + (_FORV_9_ - 1) * respc(55), phoneY + _UPVALUE0_.phoneH - respc(74), respc(38), respc(38), "files/apps/" .. _FORV_10_.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))
          if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(101) + (_FORV_9_ - 1) * respc(55), phoneY + _UPVALUE0_.phoneH - respc(74), respc(38), respc(38)) then
            drawImageByState("bottomHover" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(101) + (_FORV_9_ - 1) * respc(55), phoneY + _UPVALUE0_.phoneH - respc(74), respc(38), respc(38), {
              0,
              0,
              0,
              100
            }, true, "files/apps/hover.png")
            _UPVALUE0_.activeDirectX = _FORV_10_.icon
          else
            drawImageByState("bottomHover" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(101) + (_FORV_9_ - 1) * respc(55), phoneY + _UPVALUE0_.phoneH - respc(74), respc(38), respc(38), {
              0,
              0,
              0,
              100
            }, false, "files/apps/hover.png")
          end
        end
        for _FORV_9_, _FORV_10_ in pairs(_UPVALUE10_) do
          dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(101) + (_FORV_9_ - 1) * respc(55), phoneY + respc(55), respc(38), respc(38), "files/apps/" .. _FORV_10_.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))
          dxDrawText(_FORV_10_.name, phoneX + _UPVALUE0_.phoneW / 2 - respc(106) + (_FORV_9_ - 1) * respc(55), phoneY + respc(100), phoneX + _UPVALUE0_.phoneW / 2 - respc(106) + (_FORV_9_ - 1) * respc(55) + respc(45), 0, tocolor(255, 255, 255, 255 * alpha), 1, _UPVALUE11_, "center", "top")
          if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(101) + (_FORV_9_ - 1) * respc(55), phoneY + respc(55), respc(38), respc(38)) then
            drawImageByState("topHover" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(101) + (_FORV_9_ - 1) * respc(55), phoneY + respc(55), respc(38), respc(38), {
              0,
              0,
              0,
              100
            }, true, "files/apps/hover.png")
            _UPVALUE0_.activeDirectX = _FORV_10_.icon
          else
            drawImageByState("topHover" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(101) + (_FORV_9_ - 1) * respc(55), phoneY + respc(55), respc(38), respc(38), {
              0,
              0,
              0,
              100
            }, false, "files/apps/hover.png")
          end
        end
      elseif _UPVALUE0_.selectedMenu == "settings" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255 * menuAlpha))
        dxDrawText("Beállítások", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "center", "center")
        drawImageHover("backHoverSettings", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
        if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
          _UPVALUE0_.activeDirectX = "headMenu"
        end
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(69), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        for _FORV_9_, _FORV_10_ in pairs(_UPVALUE12_) do
          drawButtonByState("settingsHoverBG" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(240), respc(30), {
            27,
            28,
            30,
            255 * menuAlpha
          }, {
            44,
            44,
            46,
            255
          })
          dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(112), phoneY + respc(75) + (_FORV_9_ - 1) * respc(30), respc(20), respc(20), "files/settings/" .. _FORV_10_.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
          dxDrawText(_FORV_10_.name, phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(75) + (_FORV_9_ - 1) * respc(30), 0, phoneY + respc(95) + (_FORV_9_ - 1) * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
          if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(240), respc(30)) then
            _UPVALUE0_.activeDirectX = _FORV_10_.icon
          end
          dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 + respc(90), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(30), respc(30), "files/settings/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
          if _FORV_9_ < 3 then
            dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(99) + (_FORV_9_ - 1) * respc(30), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
          end
        end
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + #_UPVALUE12_ * respc(30), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(69) + respc(120), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        for _FORV_9_, _FORV_10_ in pairs(_UPVALUE13_) do
          drawButtonByState("secondSettingsHoverBG" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30) + respc(120), respc(240), respc(30), {
            27,
            28,
            30,
            255 * menuAlpha
          }, {
            44,
            44,
            46,
            255
          })
          dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(112), phoneY + respc(75) + (_FORV_9_ - 1) * respc(30) + respc(120), respc(20), respc(20), "files/settings/" .. _FORV_10_.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
          dxDrawText(_FORV_10_.name, phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(75) + (_FORV_9_ - 1) * respc(30) + respc(120), 0, phoneY + respc(95) + (_FORV_9_ - 1) * respc(30) + respc(120), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
          if _FORV_9_ == 1 then
            drawButtonSlider("slider" .. _FORV_9_, getElementData(localPlayer, "settings:Sound"), phoneX + _UPVALUE0_.phoneW / 2 + respc(80), phoneY + respc(205) + (_FORV_9_ - 1) * respc(30), respc(13), {
              52,
              52,
              55,
              255
            }, {
              48,
              209,
              88,
              255
            })
            dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(99) + (_FORV_9_ - 1) * respc(30) + respc(120), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
          elseif _FORV_9_ == 2 then
            drawButtonSlider("slider" .. _FORV_9_, getElementData(localPlayer, "settings:Vibration"), phoneX + _UPVALUE0_.phoneW / 2 + respc(80), phoneY + respc(205) + (_FORV_9_ - 1) * respc(30), respc(13), {
              52,
              52,
              55,
              255
            }, {
              48,
              209,
              88,
              255
            })
            dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(99) + (_FORV_9_ - 1) * respc(30) + respc(120), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
          else
            dxDrawText(actualPhoneID, phoneX + _UPVALUE0_.phoneW / 2, phoneY + respc(75) + (_FORV_9_ - 1) * respc(30) + respc(120), 0, phoneY + respc(95) + (_FORV_9_ - 1) * respc(30) + respc(120), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
          end
        end
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + #_UPVALUE12_ * respc(30) + respc(120), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
      elseif _UPVALUE0_.selectedMenu == "wallpaper" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        dxDrawText("Háttérképek", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "center", "center")
        drawImageHover("backHoverWallpaper", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
        for _FORV_9_ = 1, _UPVALUE0_.numberOfWallpapers do
          drawButtonByState("wallPaperHoverBG" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(240), respc(30), {
            27,
            28,
            30,
            255
          }, {
            44,
            44,
            46,
            255
          })
          dxDrawText("Háttérkép " .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(105), phoneY + respc(75) + (_FORV_9_ - 1) * respc(30), 0, phoneY + respc(95) + (_FORV_9_ - 1) * respc(30), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "left", "center")
          if getElementData(localPlayer, "settings:Wallpaper") == _FORV_9_ then
            dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 + respc(90), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(30), respc(30), "files/settings/tick.png")
          end
        end
        if _FOR_.approveState then
          _UPVALUE0_.approveY = interpolateBetween(_UPVALUE0_.approveY, 0, 0, _UPVALUE0_.phoneH - respc(185), 0, 0, (getTickCount() - _UPVALUE0_.approveTick) / 1000, "Linear")
        else
          _UPVALUE0_.approveY = interpolateBetween(_UPVALUE0_.approveY, 0, 0, _UPVALUE0_.phoneH, 0, 0, (getTickCount() - _UPVALUE0_.approveTick) / 1000, "Linear")
        end
        dxSetRenderTarget(_UPVALUE14_, true)
        dxSetBlendMode("modulate_add")
        dxDrawImage(_UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY, respc(230), respc(90), "files/settings/approvebg.png", 0, 0, 0, tocolor(27, 28, 30, 255))
        dxDrawImage(_UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY + respc(95), respc(230), respc(30), "files/settings/approve_bottonbg.png", 0, 0, 0, tocolor(27, 28, 30, 255))
        drawImageByHover("approveUp1", _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY, respc(230), respc(30), phoneX + _UPVALUE0_.phoneW / 2 - respc(115), phoneY + _UPVALUE0_.approveY, respc(230), respc(30), {
          44,
          44,
          46,
          255
        }, "files/settings/approve_up_hover.png")
        drawHoverButton("approveMiddle", _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY + respc(30), respc(230), respc(30), phoneX + _UPVALUE0_.phoneW / 2 - respc(115), phoneY + _UPVALUE0_.approveY + respc(30), respc(230), respc(30), {
          44,
          44,
          46,
          0
        }, {
          44,
          44,
          46,
          255
        })
        drawImageByHover("approveUp2", _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY + respc(60), respc(230), respc(30), phoneX + _UPVALUE0_.phoneW / 2 - respc(115), phoneY + _UPVALUE0_.approveY + respc(60), respc(230), respc(30), {
          44,
          44,
          46,
          255
        }, "files/settings/approve_up_hover.png", 500, false, -180)
        drawImageByHover("approveDown", _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY + respc(95), respc(230), respc(30), phoneX + _UPVALUE0_.phoneW / 2 - respc(115), phoneY + _UPVALUE0_.approveY + respc(95), respc(230), respc(30), {
          44,
          44,
          46,
          255
        }, "files/settings/approve_bottonbg.png")
        dxDrawText("Zárolt képernyő", _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY, _UPVALUE0_.phoneW / 2 - respc(115) + respc(230), _UPVALUE0_.approveY + respc(30), tocolor(61, 108, 165, 255), 1, _UPVALUE6_, "center", "center")
        dxDrawText("Főképernyő", _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY + respc(30), _UPVALUE0_.phoneW / 2 - respc(115) + respc(230), _UPVALUE0_.approveY + respc(60), tocolor(61, 108, 165, 255), 1, _UPVALUE6_, "center", "center")
        dxDrawText("Mindkettő", _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY + respc(60), _UPVALUE0_.phoneW / 2 - respc(115) + respc(230), _UPVALUE0_.approveY + respc(90), tocolor(61, 108, 165, 255), 1, _UPVALUE6_, "center", "center")
        dxDrawText("Mégse", _UPVALUE0_.phoneW / 2 - respc(115), _UPVALUE0_.approveY + respc(95), _UPVALUE0_.phoneW / 2 - respc(115) + respc(230), _UPVALUE0_.approveY + respc(95) + respc(30), tocolor(61, 108, 165, 255), 1, _UPVALUE6_, "center", "center")
        dxSetBlendMode("blend")
        dxSetRenderTarget()
        dxDrawImage(phoneX, phoneY, _UPVALUE0_.phoneW, _UPVALUE0_.phoneH - respc(10), _UPVALUE14_)
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "ringtone" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        dxDrawText("Csengőhangok", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "center", "center")
        drawImageHover("backHoverRingtone", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
        for _FORV_9_, _FORV_10_ in pairs(_UPVALUE15_) do
          drawButtonByState("ringtoneHoverBG" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(240), respc(30), {
            27,
            28,
            30,
            255
          }, {
            44,
            44,
            46,
            255
          })
          dxDrawText("Csengőhang " .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(105), phoneY + respc(75) + (_FORV_9_ - 1) * respc(30), 0, phoneY + respc(95) + (_FORV_9_ - 1) * respc(30), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "left", "center")
          if getElementData(localPlayer, "settings:Ringtone") == "ring" .. _FORV_10_ then
            dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 + respc(90), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(30), respc(30), "files/settings/tick.png")
          end
        end
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "notification" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        dxDrawText("Értesítések", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "center", "center")
        drawImageHover("backHoverNotification", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
        for _FORV_9_, _FORV_10_ in pairs(_UPVALUE16_) do
          drawButtonByState("notificationHoverBG" .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(240), respc(30), {
            27,
            28,
            30,
            255
          }, {
            44,
            44,
            46,
            255
          })
          dxDrawText("Értesítés " .. _FORV_9_, phoneX + _UPVALUE0_.phoneW / 2 - respc(105), phoneY + respc(75) + (_FORV_9_ - 1) * respc(30), 0, phoneY + respc(95) + (_FORV_9_ - 1) * respc(30), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "left", "center")
          if getElementData(localPlayer, "settings:Notice") == "sms" .. _FORV_10_ then
            dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 + respc(90), phoneY + respc(70) + (_FORV_9_ - 1) * respc(30), respc(30), respc(30), "files/settings/tick.png")
          end
        end
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "advertisement" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        dxDrawText("Hirdetések", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "center", "center")
        drawImageHover("backHoverAdvertisement", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
        drawButtonByState("advertisementsState", phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + 0 * respc(30), respc(240), respc(30), {
          27,
          28,
          30,
          255 * menuAlpha
        }, {
          44,
          44,
          46,
          255
        })
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(112), phoneY + respc(75) + 0 * respc(30), respc(20), respc(20), "files/settings/ad.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
        dxDrawText("Hirdetések", phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(75) + 0 * respc(30), 0, phoneY + respc(95) + 0 * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        drawButtonSlider("showAdsSlider", getElementData(localPlayer, "settings:advertsShowing"), phoneX + _UPVALUE0_.phoneW / 2 + respc(80), phoneY + respc(85) + 0 * respc(30), respc(13), {
          52,
          52,
          55,
          255
        }, {
          48,
          209,
          88,
          255
        })
        drawButtonByState("showNumberState", phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + 1 * respc(30), respc(240), respc(30), {
          27,
          28,
          30,
          255 * menuAlpha
        }, {
          44,
          44,
          46,
          255
        })
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(112), phoneY + respc(75) + 1 * respc(30), respc(20), respc(20), "files/settings/number.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
        dxDrawText("Telefonszám kijelzése", phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(75) + 1 * respc(30), 0, phoneY + respc(95) + 1 * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        drawButtonSlider("showNumberSlider", getElementData(localPlayer, "settings:numberShowing"), phoneX + _UPVALUE0_.phoneW / 2 + respc(80), phoneY + respc(87) + 1 * respc(30), respc(13), {
          52,
          52,
          55,
          255
        }, {
          48,
          209,
          88,
          255
        })
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(69), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(99) + 0 * respc(30), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + respc(60), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        dxDrawImage(phoneX + respc(22), phoneY + respc(78) + 2 * respc(30), respc(230), respc(150), "files/advertisementbg.png", 0, 0, 0, tocolor(27, 28, 30, 255 * menuAlpha))
        drawImageHover("sendButton", phoneX + _UPVALUE0_.phoneW / 2 + respc(85), phoneY + respc(80) + 2 * respc(30), respc(25), respc(25), {
          61,
          108,
          165,
          255 * menuAlpha
        }, "files/send.png")
        dxDrawText("Hirdetés szövege:", phoneX + respc(30), phoneY + respc(80) + 2 * respc(30), 0, phoneY + respc(107) + 2 * respc(30), tocolor(255, 255, 255, 170 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        if _UPVALUE17_.actualEditing == "advert" then
          _UPVALUE17_.advertEdit = _UPVALUE17_.invitingText
        end
        dxDrawText(_UPVALUE17_.advertEdit, phoneX + respc(30), phoneY + respc(105) + 2 * respc(30), phoneX + _UPVALUE0_.phoneW / 2 + respc(110), phoneY + respc(270) + 2 * respc(30), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "left", "top", false, true, true)
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "illegalad" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        dxDrawText("Illegál hirdetések", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "center", "center")
        drawImageHover("backHoverIllegalAdvertisement", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
        drawButtonByState("illegalAdvertisementsState", phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + 0 * respc(30), respc(240), respc(30), {
          27,
          28,
          30,
          255 * menuAlpha
        }, {
          44,
          44,
          46,
          255
        })
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(112), phoneY + respc(75) + 0 * respc(30), respc(20), respc(20), "files/apps/illegalad.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
        dxDrawText("Illegális hirdetések", phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(75) + 0 * respc(30), 0, phoneY + respc(95) + 0 * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        drawButtonSlider("showIllegalAdsSlider", getElementData(localPlayer, "settings:illegalAdvertsShowing"), phoneX + _UPVALUE0_.phoneW / 2 + respc(80), phoneY + respc(85) + 0 * respc(30), respc(13), {
          52,
          52,
          55,
          255
        }, {
          48,
          209,
          88,
          255
        })
        drawButtonByState("showNumberState", phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + 1 * respc(30), respc(240), respc(30), {
          27,
          28,
          30,
          255 * menuAlpha
        }, {
          44,
          44,
          46,
          255
        })
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(112), phoneY + respc(75) + 1 * respc(30), respc(20), respc(20), "files/settings/number.png", 0, 0, 0, tocolor(255, 255, 255, 255 * menuAlpha))
        dxDrawText("Telefonszám kijelzése", phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(75) + 1 * respc(30), 0, phoneY + respc(95) + 1 * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        drawButtonSlider("showNumberSlider", getElementData(localPlayer, "settings:illegalNumberShowing"), phoneX + _UPVALUE0_.phoneW / 2 + respc(80), phoneY + respc(87) + 1 * respc(30), respc(13), {
          52,
          52,
          55,
          255
        }, {
          48,
          209,
          88,
          255
        })
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(69), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(72), phoneY + respc(99) + 0 * respc(30), respc(192), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + respc(60), respc(240), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        dxDrawImage(phoneX + respc(22), phoneY + respc(78) + 2 * respc(30), respc(230), respc(150), "files/advertisementbg.png", 0, 0, 0, tocolor(27, 28, 30, 255 * menuAlpha))
        drawImageHover("sendIllegalButton", phoneX + _UPVALUE0_.phoneW / 2 + respc(85), phoneY + respc(80) + 2 * respc(30), respc(25), respc(25), {
          61,
          108,
          165,
          255 * menuAlpha
        }, "files/send.png")
        dxDrawText("Hirdetés szövege:", phoneX + respc(30), phoneY + respc(80) + 2 * respc(30), 0, phoneY + respc(107) + 2 * respc(30), tocolor(255, 255, 255, 170 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        if _UPVALUE17_.actualEditing == "illegalad" then
          _UPVALUE17_.illegalEdit = _UPVALUE17_.invitingText
        end
        dxDrawText(_UPVALUE17_.illegalEdit, phoneX + respc(30), phoneY + respc(105) + 2 * respc(30), phoneX + _UPVALUE0_.phoneW / 2 + respc(110), phoneY + respc(270) + 2 * respc(30), tocolor(255, 255, 255, 255), 1, _UPVALUE6_, "left", "top", false, true, true)
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "phone" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255 * menuAlpha))
        for _FORV_11_, _FORV_12_ in pairs(_UPVALUE18_) do
          if 0 + 1 == 4 then
          end
          drawImageWithHover("keypadCircles" .. _FORV_11_, phoneX + respc(50) + (1 - 1) * respc(65), phoneY + respc(165) + (0 + 1) * respc(60), respc(45), respc(45), {
            51,
            51,
            51,
            255 * menuAlpha
          }, {
            166,
            166,
            166,
            255 * menuAlpha
          }, "files/dialer/circle.png")
          dxDrawText(_FORV_12_, phoneX + respc(52) + (1 - 1) * respc(65), phoneY + respc(165) + (0 + 1) * respc(60), phoneX + respc(50) + (1 - 1) * respc(65) + respc(45), phoneY + respc(165) + (0 + 1) * respc(60) + respc(45), tocolor(255, 255, 255, 170 * menuAlpha), 1, _UPVALUE19_, "center", "center")
        end
        drawImageWithHover("phoneButton", phoneX + respc(50) + 1 * respc(65), phoneY + respc(165) + 4 * respc(60), respc(45), respc(45), {255, 255, 255, 255 * menuAlpha}, {255, 255, 255, 170 * menuAlpha}, "files/dialer/call.png")
        drawImageWithHover("deleteButton", phoneX + respc(50) + 2 * respc(65), phoneY + respc(165) + 4 * respc(60), respc(45), respc(45), {255, 255, 255, 255 * menuAlpha}, {255, 255, 255, 170 * menuAlpha}, "files/dialer/delete.png")
        if #_UPVALUE20_ > 9 then
        end
        dxDrawText(table.concat(_UPVALUE20_), phoneX + respc(30), phoneY + respc(80), phoneX + _UPVALUE0_.phoneW - respc(30), 0, tocolor(255, 255, 255, 255 * menuAlpha), 1 / #_UPVALUE20_ * 9, _UPVALUE21_, "center", "top")
        drawImageHover("backHoverPhone", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {61, 108, 165, 255}, "files/back.png")
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "call:Caller" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 190))
        drawImageWithHover("cancelCallingButton", phoneX + _UPVALUE0_.phoneW / 2 - respc(45) / 2, phoneY + _UPVALUE0_.phoneH - respc(140), respc(45), respc(45), {
          255,
          255,
          255,
          255
        }, {
          255,
          255,
          255,
          170
        }, "files/dialer/cancel.png")
        dxDrawText(_UPVALUE22_.calledNumber, phoneX + respc(30), phoneY + respc(80), phoneX + _UPVALUE0_.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, _UPVALUE23_, "center", "top")
        dxDrawText("Hívás folyamatban...", phoneX + respc(30), phoneY + respc(115), phoneX + _UPVALUE0_.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, _UPVALUE24_, "center", "top")
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "call:Called" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 190))
        dxDrawText(_UPVALUE22_.calledNumber, phoneX + respc(30), phoneY + respc(80), phoneX + _UPVALUE0_.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, _UPVALUE23_, "center", "top")
        dxDrawText("Bejövő hívás", phoneX + respc(30), phoneY + respc(115), phoneX + _UPVALUE0_.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, _UPVALUE24_, "center", "top")
        drawImageWithHover("cancelInComingCallButton", phoneX + respc(50), phoneY + _UPVALUE0_.phoneH - respc(140), respc(45), respc(45), {
          255,
          255,
          255,
          255
        }, {
          255,
          255,
          255,
          170
        }, "files/dialer/cancel.png")
        drawImageWithHover("acceptInComingCallButton", phoneX + _UPVALUE0_.phoneW - respc(95), phoneY + _UPVALUE0_.phoneH - respc(140), respc(45), respc(45), {
          255,
          255,
          255,
          255
        }, {
          255,
          255,
          255,
          170
        }, "files/dialer/call.png")
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "call:inCall" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        for _FORV_10_, _FORV_11_ in ipairs(_UPVALUE25_) do
          if _FORV_10_ > _UPVALUE26_ and 0 < 8 then
            callY = phoneY + respc(180) + 0 * respc(30)
            if tonumber(_FORV_11_[2]) == tonumber(actualPhoneID) then
              dxDrawText("Te: " .. _FORV_11_[1], phoneX + respc(25), callY, 0, 0, tocolor(255, 255, 255, 255), 1, _UPVALUE8_, "left", "top", false, false, true, true)
            else
              dxDrawText("Hívott: " .. _FORV_11_[1], phoneX + _UPVALUE0_.phoneW / 2, callY, phoneX + _UPVALUE0_.phoneW - respc(40), 0, tocolor(255, 255, 255, 255), 1, _UPVALUE8_, "right", "top", false, false, true, true)
            end
          end
        end
        dxDrawText(_UPVALUE22_.calledNumber, phoneX + respc(30), phoneY + respc(55), phoneX + _UPVALUE0_.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, _UPVALUE23_, "center", "top")
        dxDrawText("Hívásban", phoneX + respc(30), phoneY + respc(90), phoneX + _UPVALUE0_.phoneW - respc(30), 0, tocolor(255, 255, 255, 255), 1, _UPVALUE24_, "center", "top")
        drawImageWithHover("cancelInCallButton", phoneX + _UPVALUE0_.phoneW / 2 - respc(45) / 2, phoneY + _UPVALUE0_.phoneH - respc(100), respc(45), respc(45), {
          255,
          255,
          255,
          255
        }, {
          255,
          255,
          255,
          170
        }, "files/dialer/cancel.png")
        drawImageHover("sendMessageButton", phoneX + respc(230), phoneY + respc(120), respc(25), respc(25), {
          61,
          108,
          165,
          255
        }, "files/send.png")
        drawImageWithHover("callMessageInput", phoneX + respc(20), phoneY + respc(120), respc(200), respc(25), {
          21,
          21,
          21,
          255
        }, {
          30,
          30,
          30,
          255
        }, "files/dialer/messagebg.png")
        if _UPVALUE17_.actualEditing == "callMessageInput" then
          _UPVALUE17_.callInputMessage = _UPVALUE17_.invitingText
          if _UPVALUE2_ then
            dxDrawLine(phoneX + respc(28) + dxGetTextWidth(_UPVALUE17_.callInputMessage, 1, _UPVALUE8_), phoneY + respc(125), phoneX + respc(28) + dxGetTextWidth(_UPVALUE17_.callInputMessage, 1, _UPVALUE8_), phoneY + respc(140), tocolor(255, 255, 255, 255), 1)
          end
        end
        dxDrawText(_UPVALUE17_.callInputMessage, phoneX + respc(25), phoneY + respc(120), phoneX + respc(220), phoneY + respc(145), tocolor(255, 255, 255, 255), 1, _UPVALUE8_, "left", "center")
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "contacts" then
        if _UPVALUE0_.deleteNotification then
          _UPVALUE0_.notificationAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - _UPVALUE0_.notificationTick) / 250, "Linear")
        else
          _UPVALUE0_.notificationAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - _UPVALUE0_.notificationTick) / 250, "Linear")
        end
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255 * menuAlpha))
        for _FORV_10_, _FORV_11_ in pairs(_UPVALUE27_) do
          if _FORV_10_ > _UPVALUE0_.scrollContact and 0 < 14 then
            drawImageWithHover("callContact" .. _FORV_10_, phoneX + _UPVALUE0_.phoneW - respc(110), phoneY + respc(70) + (0 + 1 - 1) * respc(30), respc(30), respc(30), {
              255,
              255,
              255,
              255 * menuAlpha
            }, {
              115,
              185,
              24,
              255
            }, "files/contacts/call.png")
            drawImageWithHover("messageContact" .. _FORV_10_, phoneX + _UPVALUE0_.phoneW - respc(80), phoneY + respc(70) + (0 + 1 - 1) * respc(30), respc(30), respc(30), {
              255,
              255,
              255,
              255 * menuAlpha
            }, {
              104,
              170,
              249,
              255
            }, "files/contacts/message.png")
            drawImageWithHover("deleteContact" .. _FORV_10_, phoneX + _UPVALUE0_.phoneW - respc(50), phoneY + respc(70) + (0 + 1 - 1) * respc(30), respc(30), respc(30), {
              255,
              255,
              255,
              255 * menuAlpha
            }, {
              176,
              44,
              54,
              255
            }, "files/contacts/delete.png")
            dxDrawText(_FORV_11_.name, phoneX + respc(25), phoneY + respc(75) + (0 + 1 - 1) * respc(30), 0, phoneY + respc(95) + (0 + 1 - 1) * respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
            dxDrawRectangle(phoneX + respc(25), phoneY + respc(99) + (0 + 1 - 1) * respc(30), respc(235), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
          end
        end
        exports.lsmta_system:gorgetesRajzolas(phoneX + _UPVALUE0_.phoneW - respc(21), phoneY + respc(75), respc(2), respc(415), #_UPVALUE27_, 14, _UPVALUE0_.scrollContact, tocolor(31, 31, 31, 255))
        if #_UPVALUE27_ < 1 then
          dxDrawText("Nincs névjegy", phoneX, phoneY, phoneX + _UPVALUE0_.phoneW, phoneY + _UPVALUE0_.phoneH, tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "center", "center")
        end
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(183) / 2, phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2, respc(183), respc(96), "files/contacts/notification.png", 0, 0, 0, tocolor(255, 255, 255, 255 * _UPVALUE0_.notificationAlpha))
        if _UPVALUE0_.deleteNotification then
          drawImageWithHover("cancelDeleteContactHover", phoneX + _UPVALUE0_.phoneW / 2 - respc(185) / 2, phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2 + respc(66), respc(94), respc(30), {
            27,
            28,
            30,
            0
          }, {
            44,
            44,
            46,
            255
          }, "files/contacts/cancel_hover.png")
          drawImageWithHover("acceptDeleteContactHover", phoneX + _UPVALUE0_.phoneW / 2 - respc(183) / 2 + respc(90), phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2 + respc(66), respc(94), respc(30), {
            27,
            28,
            30,
            0
          }, {
            44,
            44,
            46,
            255
          }, "files/contacts/accept_hover.png")
        end
        dxDrawText("Mégsem", phoneX + _UPVALUE0_.phoneW / 2 - respc(185) / 2, phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2 + respc(66), phoneX + _UPVALUE0_.phoneW / 2 - respc(185) / 2 + respc(94), phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2 + respc(66) + respc(30), tocolor(10, 132, 255, 255 * _UPVALUE0_.notificationAlpha), 1, _UPVALUE6_, "center", "center")
        dxDrawText("Törlés", phoneX + _UPVALUE0_.phoneW / 2 - respc(185) / 2 + respc(90), phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2 + respc(66), phoneX + _UPVALUE0_.phoneW / 2 - respc(185) / 2 + respc(94) + respc(90), phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2 + respc(66) + respc(30), tocolor(10, 132, 255, 255 * _UPVALUE0_.notificationAlpha), 1, _UPVALUE6_, "center", "center")
        dxDrawCorrectText("Névjegy Törlése", phoneX + _UPVALUE0_.phoneW / 2 - respc(183) / 2, phoneY + _UPVALUE0_.phoneH / 2 - respc(35), respc(183), respc(96), tocolor(255, 255, 255, 255 * _UPVALUE0_.notificationAlpha), 1, _UPVALUE24_, "center", "top")
        dxDrawCorrectText("Biztosan törölni szeretnéd ezt a\nnévjegyet?", phoneX + _UPVALUE0_.phoneW / 2 - respc(183) / 2, phoneY + _UPVALUE0_.phoneH / 2 - respc(15), respc(183), respc(96), tocolor(255, 255, 255, 255 * _UPVALUE0_.notificationAlpha), 1, _UPVALUE11_, "center", "top")
        dxDrawText("Névjegyzék", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "center", "center")
        drawImageWithHover("newContactButton", phoneX + _UPVALUE0_.phoneW - respc(45), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, {
          61,
          108,
          165,
          155
        }, "files/contacts/plus.png")
        drawImageHover("backHoverContacts", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
        if _UPVALUE0_.newContactState then
          dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2, phoneY + respc(43), respc(236), respc(485), "files/contacts/newcontactbg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
          if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(10), phoneY + respc(55), respc(50), respc(25)) then
            dxDrawCorrectText("Mégsem", phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(10), phoneY + respc(55), 0, respc(25), tocolor(10, 132, 255, 150), 1, _UPVALUE6_, "left", "center")
          else
            dxDrawCorrectText("Mégsem", phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(10), phoneY + respc(55), 0, respc(25), tocolor(10, 132, 255, 255), 1, _UPVALUE6_, "left", "center")
          end
          if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(200), phoneY + respc(55), respc(50), respc(25)) then
            dxDrawCorrectText("Kész", phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(200), phoneY + respc(55), 0, respc(25), tocolor(10, 132, 255, 150), 1, _UPVALUE6_, "left", "center")
          else
            dxDrawCorrectText("Kész", phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(200), phoneY + respc(55), 0, respc(25), tocolor(10, 132, 255, 255), 1, _UPVALUE6_, "left", "center")
          end
          if _UPVALUE17_.actualEditing == "contactName" then
            _UPVALUE17_.contactName = _UPVALUE17_.invitingText
            if _UPVALUE2_ then
              dxDrawLine(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(103) + dxGetTextWidth(_UPVALUE17_.contactName, 1, _UPVALUE6_), phoneY + respc(120), phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(103) + dxGetTextWidth(_UPVALUE17_.contactName, 1, _UPVALUE6_), phoneY + respc(135), tocolor(255, 255, 255, 255), 1)
            end
          end
          if _UPVALUE17_.actualEditing == "contactNumber" then
            _UPVALUE17_.contactNumber = _UPVALUE17_.invitingText
            if _UPVALUE2_ then
              dxDrawLine(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(53) + dxGetTextWidth(_UPVALUE17_.contactNumber, 1, _UPVALUE6_), phoneY + respc(155), phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(53) + dxGetTextWidth(_UPVALUE17_.contactNumber, 1, _UPVALUE6_), phoneY + respc(170), tocolor(255, 255, 255, 255), 1)
            end
          end
          dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(85), phoneY + respc(140), respc(150), respc(1), tocolor(48, 49, 51, 255))
          dxDrawRectangle(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(25), phoneY + respc(175), respc(210), respc(1), tocolor(48, 49, 51, 255))
          dxDrawText(_UPVALUE17_.contactName, phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(100), phoneY + respc(120), respc(150), respc(1), tocolor(255, 255, 255, 200), 1, _UPVALUE6_, "left", "top")
          dxDrawText(_UPVALUE17_.contactNumber, phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(50), phoneY + respc(155), respc(150), respc(1), tocolor(255, 255, 255, 200), 1, _UPVALUE6_, "left", "top")
        end
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
      elseif _UPVALUE0_.selectedMenu == "messages" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        if 1 > _UPVALUE0_.selectedMessageContact then
          dxDrawText("Üzenetek", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "center", "center")
          drawImageWithHover("newSMSButton", phoneX + _UPVALUE0_.phoneW - respc(45), phoneY + respc(37), respc(30), respc(30), {
            61,
            108,
            165,
            255
          }, {
            61,
            108,
            165,
            155
          }, "files/contacts/plus.png")
          for _FORV_10_, _FORV_11_ in pairs(_UPVALUE3_) do
            if _FORV_10_ > _UPVALUE0_.scrollSelectableMessages and 10 > 0 then
              drawButtonByState("hoverSMSButton" .. _FORV_10_, phoneX + respc(20), phoneY + respc(75) + (0 + 1 - 1) * respc(35), respc(250), respc(30), {
                44,
                44,
                46,
                0
              }, {
                44,
                44,
                46,
                255
              })
              if findContactByNumber(_FORV_11_.number) then
                dxDrawText(findContactByNumber(_FORV_11_.number), phoneX + respc(75), phoneY + respc(75) + (0 + 1 - 1) * respc(35), 0, phoneY + respc(95) + (0 + 1 - 1) * respc(35), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
                dxDrawText(_FORV_11_.number, phoneX + respc(75), phoneY + respc(75) + (0 + 1 - 1) * respc(35), 0, phoneY + respc(120) + (0 + 1 - 1) * respc(35), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE11_, "left", "center")
              else
                dxDrawText("Ismeretlen", phoneX + respc(75), phoneY + respc(75) + (0 + 1 - 1) * respc(35), 0, phoneY + respc(95) + (0 + 1 - 1) * respc(35), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
                dxDrawText(_FORV_11_.number, phoneX + respc(75), phoneY + respc(75) + (0 + 1 - 1) * respc(35), 0, phoneY + respc(120) + (0 + 1 - 1) * respc(35), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE11_, "left", "center")
              end
              drawImageWithHover("deleteConversation" .. _FORV_10_, phoneX + _UPVALUE0_.phoneW - respc(50), phoneY + respc(75) + (0 + 1 - 1) * respc(35), respc(30), respc(30), {
                255,
                255,
                255,
                255 * menuAlpha
              }, {
                176,
                44,
                54,
                255
              }, "files/contacts/delete.png")
              dxDrawImage(phoneX + respc(20), phoneY + respc(75) + (0 + 1 - 1) * respc(35), respc(30), respc(30), "files/sms/profile.png")
            end
          end
        else
          dxDrawText(findContactByNumber(_UPVALUE3_[_UPVALUE0_.selectedMessageContact].number) or _UPVALUE3_[_UPVALUE0_.selectedMessageContact].number, phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "center", "center")
          for _FORV_11_, _FORV_12_ in pairs(_UPVALUE3_[_UPVALUE0_.selectedMessageContact].messages) do
            if _FORV_11_ > #_UPVALUE3_[_UPVALUE0_.selectedMessageContact].messages - 13 and 0 < 13 then
              callY = phoneY + respc(430) + (_FORV_11_ - #_UPVALUE3_[_UPVALUE0_.selectedMessageContact].messages) * respc(30)
              if tonumber(_FORV_12_[2]) == tonumber(actualPhoneID) then
                dxDrawText(_FORV_12_[1], phoneX + _UPVALUE0_.phoneW / 2, callY, phoneX + _UPVALUE0_.phoneW - respc(40), 0, tocolor(255, 255, 255, 255), 1, _UPVALUE8_, "right", "top", false, false, true, true)
                dxDrawRoundedCornersRectangle("full", 8, phoneX + _UPVALUE0_.phoneW - respc(45) - dxGetTextWidth(_FORV_12_[1], 1, _UPVALUE8_), callY - respc(7), dxGetTextWidth(_FORV_12_[1], 1, _UPVALUE8_) + respc(10), respc(25), _UPVALUE5_, tocolor(61, 100, 253, 255))
              else
                dxDrawText(_FORV_12_[1], phoneX + respc(25), callY, 0, 0, tocolor(255, 255, 255, 255), 1, _UPVALUE8_, "left", "top", false, false, true, true)
                dxDrawRoundedCornersRectangle("full", 8, phoneX + respc(25) - respc(5), callY - respc(7), dxGetTextWidth(_FORV_12_[1], 1, _UPVALUE8_) + respc(10), respc(25), _UPVALUE5_, tocolor(41, 41, 41, 255))
              end
            end
          end
          drawImageHover("sendSMSButton", phoneX + respc(230), phoneY + respc(460), respc(25), respc(25), {
            61,
            108,
            165,
            255
          }, "files/send.png")
          drawImageWithHover("newSMSInput", phoneX + respc(20), phoneY + respc(460), respc(200), respc(25), {
            21,
            21,
            21,
            255
          }, {
            30,
            30,
            30,
            255
          }, "files/dialer/messagebg.png")
          if _UPVALUE17_.actualEditing == "realSMSText" then
            _UPVALUE17_.realSMSText = _UPVALUE17_.invitingText
            if _UPVALUE2_ then
              dxDrawLine(phoneX + respc(33) + dxGetTextWidth(_UPVALUE17_.realSMSText, 1, _UPVALUE6_), phoneY + respc(465), phoneX + respc(33) + dxGetTextWidth(_UPVALUE17_.realSMSText, 1, _UPVALUE6_), phoneY + respc(480), tocolor(255, 255, 255, 255), 1)
            end
          end
          dxDrawCorrectText(_UPVALUE17_.realSMSText, phoneX + respc(30), phoneY + respc(460), respc(200), respc(25), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        end
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        drawImageHover("backHoverContacts", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
      elseif _UPVALUE0_.selectedMenu == "newMessage" then
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        dxDrawText("Új üzenet", phoneX, phoneY + respc(35), phoneX + _UPVALUE0_.phoneW, phoneY + respc(70), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "center", "center")
        drawButtonByState("newContactNameInput", phoneX + respc(20), phoneY + respc(65) + 0 * respc(35), respc(250), respc(30), {
          44,
          44,
          46,
          150
        }, {
          44,
          44,
          46,
          200
        })
        dxDrawRectangle(phoneX + respc(20), phoneY + respc(65) + 0 * respc(35), respc(250), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        dxDrawRectangle(phoneX + respc(20), phoneY + respc(64) + respc(30), respc(250), respc(1), tocolor(48, 49, 51, 255 * menuAlpha))
        if _UPVALUE17_.actualEditing == "messageNumber" then
          _UPVALUE17_.newMessageNumber = _UPVALUE17_.invitingText
          if _UPVALUE2_ then
            dxDrawLine(phoneX + respc(93) + dxGetTextWidth(_UPVALUE17_.newMessageNumber, 1, _UPVALUE6_), phoneY + respc(72), phoneX + respc(93) + dxGetTextWidth(_UPVALUE17_.newMessageNumber, 1, _UPVALUE6_), phoneY + respc(87), tocolor(255, 255, 255, 255), 1)
          end
        end
        dxDrawCorrectText("Címzett:", phoneX + respc(30), phoneY + respc(65) + 0 * respc(35), respc(250), respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        dxDrawCorrectText(_UPVALUE17_.newMessageNumber, phoneX + respc(90), phoneY + respc(65) + 0 * respc(35), respc(250), respc(30), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        drawImageHover("sendSMSButton", phoneX + respc(230), phoneY + respc(460), respc(25), respc(25), {
          61,
          108,
          165,
          255
        }, "files/send.png")
        drawImageWithHover("newSMSInput", phoneX + respc(20), phoneY + respc(460), respc(200), respc(25), {
          21,
          21,
          21,
          255
        }, {
          30,
          30,
          30,
          255
        }, "files/dialer/messagebg.png")
        if _UPVALUE17_.actualEditing == "smsText" then
          _UPVALUE17_.smsText = _UPVALUE17_.invitingText
          if _UPVALUE2_ then
            dxDrawLine(phoneX + respc(33) + dxGetTextWidth(_UPVALUE17_.smsText, 1, _UPVALUE6_), phoneY + respc(465), phoneX + respc(33) + dxGetTextWidth(_UPVALUE17_.smsText, 1, _UPVALUE6_), phoneY + respc(480), tocolor(255, 255, 255, 255), 1)
          end
        end
        dxDrawCorrectText(_UPVALUE17_.smsText, phoneX + respc(30), phoneY + respc(460), respc(200), respc(25), tocolor(255, 255, 255, 255 * menuAlpha), 1, _UPVALUE6_, "left", "center")
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        drawImageHover("backHoverContacts", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
      elseif _UPVALUE0_.selectedMenu == "camera" then
        if _UPVALUE0_.flashState then
          _UPVALUE0_.flashAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - _UPVALUE0_.flashTick) / 300, "Linear")
        else
          _UPVALUE0_.flashAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - _UPVALUE0_.flashTick) / 300, "Linear")
        end
        dxDrawRectangle(0, 0, screenX, screenY, tocolor(255, 255, 255, 255 * _UPVALUE0_.flashAlpha), true)
        dxDrawRectangle(phoneX + respc(16), phoneY + respc(15), respc(240), respc(518), tocolor(0, 0, 0, 255))
        if _UPVALUE28_ then
          dxUpdateScreenSource(_UPVALUE28_)
          dxDrawImage(phoneX + respc(3), phoneY + respc(115), respc(253), respc(280), _UPVALUE28_, 0, 0, 0, tocolor(255, 255, 255, 255))
        end
        drawImageHover("takePicture", phoneX + _UPVALUE0_.phoneW / 2 - respc(22), phoneY + respc(430), respc(44), respc(44), {
          255,
          255,
          255,
          255
        }, "files/camera/circle.png")
        dxDrawImage(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5), "files/home_indicator.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        drawImageHover("backHoverContacts", phoneX + respc(15), phoneY + respc(37), respc(30), respc(30), {
          61,
          108,
          165,
          255
        }, "files/back.png")
      end
    end
    dxDrawImage(phoneX, phoneY, _UPVALUE0_.phoneW, _UPVALUE0_.phoneH, "files/iphonex.png")
  end
end
addEventHandler("onClientRender", getRootElement(), phoneClientRender)
function clickHandler(_ARG_0_, _ARG_1_)
  if _ARG_0_ == "left" and _ARG_1_ == "down" then
    cursorW = {
      getCursorPosition()
    }
    if _UPVALUE0_.phoneState then
      if _UPVALUE0_.phoneMode == "phone:locked" then
        if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(60), phoneY + _UPVALUE0_.phoneH - respc(30), respc(120), respc(5)) then
          _UPVALUE0_.closeTick = getTickCount()
          _UPVALUE0_.indicatorY = phoneY + _UPVALUE0_.phoneH - respc(30)
          _UPVALUE0_.absolutWallPaperY = phoneY
          cursorW = {
            getCursorPosition()
          }
          cursorPosY = cursorW[2] * screenY
          _UPVALUE0_.movingOffsetY = cursorPosY - _UPVALUE0_.indicatorY
          _UPVALUE0_.wallPaperOffsetY = cursorPosY - _UPVALUE0_.absolutWallPaperY
          _UPVALUE0_.indicatorPressed = true
        end
      else
        if _UPVALUE0_.activeDirectX ~= "" and _UPVALUE0_.activeDirectX ~= "calculator" then
          _UPVALUE0_.selectedMenu = _UPVALUE0_.activeDirectX
          _UPVALUE0_.menuAlphaTick = getTickCount()
          if _UPVALUE0_.selectedMenu == "camera" then
            exports.lsmta_global:toggleFirstPersonExport(true)
          end
          return
        end
        if _UPVALUE0_.selectedMenu == "settings" then
          for _FORV_5_, _FORV_6_ in pairs(_UPVALUE1_) do
            if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_5_ - 1) * respc(30) + respc(120), respc(240), respc(30)) then
              if _FORV_5_ == 1 then
                setElementData(localPlayer, "settings:Sound", not getElementData(localPlayer, "settings:Sound"))
              elseif _FORV_5_ == 2 then
                setElementData(localPlayer, "settings:Vibration", not getElementData(localPlayer, "settings:Vibration"))
              end
            end
          end
        elseif _UPVALUE0_.selectedMenu == "wallpaper" then
          for _FORV_5_ = 1, _UPVALUE0_.numberOfWallpapers do
            if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_5_ - 1) * respc(30), respc(240), respc(30)) and not _UPVALUE0_.approveState then
              _UPVALUE0_.approveState = true
              _UPVALUE0_.approveTick = getTickCount()
              _UPVALUE0_.selectedWallpaper = _FORV_5_
            end
          end
          if _FOR_.approveState then
            if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(115), phoneY + _UPVALUE0_.approveY + respc(95), respc(230), respc(30)) then
              _UPVALUE0_.approveState = false
              _UPVALUE0_.approveTick = getTickCount()
            elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(115), phoneY + _UPVALUE0_.approveY + respc(60), respc(230), respc(30)) then
              _UPVALUE0_.approveState = false
              _UPVALUE0_.approveTick = getTickCount()
              setElementData(localPlayer, "settings:lockedWallpaper", _UPVALUE0_.selectedWallpaper)
              setElementData(localPlayer, "settings:Wallpaper", _UPVALUE0_.selectedWallpaper)
            elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(115), phoneY + _UPVALUE0_.approveY + respc(30), respc(230), respc(30)) then
              _UPVALUE0_.approveState = false
              _UPVALUE0_.approveTick = getTickCount()
              setElementData(localPlayer, "settings:Wallpaper", _UPVALUE0_.selectedWallpaper)
            elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(115), phoneY + _UPVALUE0_.approveY, respc(230), respc(30)) then
              _UPVALUE0_.approveState = false
              _UPVALUE0_.approveTick = getTickCount()
              setElementData(localPlayer, "settings:lockedWallpaper", _UPVALUE0_.selectedWallpaper)
            end
          end
          if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            if _UPVALUE0_.approveState then
              _UPVALUE0_.approveState = false
              _UPVALUE0_.approveTick = getTickCount()
            end
            _UPVALUE0_.selectedMenu = "settings"
          end
        elseif _UPVALUE0_.selectedMenu == "ringtone" then
          for _FORV_5_, _FORV_6_ in pairs(_UPVALUE2_) do
            if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_5_ - 1) * respc(30), respc(240), respc(30)) then
              playPreviewSound("ring" .. _FORV_6_)
              setElementData(localPlayer, "settings:Ringtone", "ring" .. _FORV_6_)
            end
          end
          if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            if isElement(_UPVALUE0_.previewSound) then
              stopSound(_UPVALUE0_.previewSound)
            end
            _UPVALUE0_.selectedMenu = "settings"
          end
        elseif _UPVALUE0_.selectedMenu == "notification" then
          for _FORV_5_, _FORV_6_ in pairs(_UPVALUE3_) do
            if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + (_FORV_5_ - 1) * respc(30), respc(240), respc(30)) then
              playPreviewSound("sms" .. _FORV_6_)
              setElementData(localPlayer, "settings:Notice", "sms" .. _FORV_6_)
            end
          end
          if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            if isElement(_UPVALUE0_.previewSound) then
              stopSound(_UPVALUE0_.previewSound)
            end
            _UPVALUE0_.selectedMenu = "settings"
          end
        elseif _UPVALUE0_.selectedMenu == "advertisement" then
          if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            _UPVALUE0_.selectedMenu = "headMenu"
            _UPVALUE4_.invitingText = ""
            _UPVALUE4_.actualEditing = ""
            _UPVALUE4_.advertEdit = ""
          elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 + respc(85), phoneY + respc(80) + 2 * respc(30), respc(25), respc(25)) then
            if string.len(_UPVALUE4_.advertEdit) > 10 then
              if string.len(_UPVALUE4_.advertEdit) * 0.58 <= getElementData(localPlayer, "money") then
                if not isTimer(_UPVALUE5_) then
                  triggerServerEvent("placeAdvertServer", localPlayer, localPlayer, _UPVALUE4_.advertEdit, string.len(_UPVALUE4_.advertEdit) * 0.58, actualPhoneID, getElementData(localPlayer, "settings:numberShowing"))
                  _UPVALUE4_.actualEditing = ""
                  _UPVALUE4_.advertEdit = ""
                  _UPVALUE5_ = setTimer(function()
                    _UPVALUE0_ = nil
                  end, 60000, 1)
                else
                  outputChatBox("#d9534f[LSRP]: #FFFFFFCsak percenként adhatsz fel hirdetést!", 255, 0, 0, true)
                end
              else
                outputChatBox("#d9534f[LSRP]: #FFFFFFNincs elegendő egyenleged!", 255, 0, 0, true)
              end
            else
              outputChatBox("#d9534f[LSRP]: #FFFFFFNem elegendő hosszúságú a hirdetésed!", 255, 0, 0, true)
            end
          elseif isInSlot(phoneX + respc(22), phoneY + respc(78) + 2 * respc(30), respc(230), respc(150)) then
            _UPVALUE4_.invitingText = _UPVALUE4_.advertEdit
            _UPVALUE4_.actualEditing = "advert"
          elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + 1 * respc(30), respc(240), respc(30)) then
            setElementData(localPlayer, "settings:numberShowing", not getElementData(localPlayer, "settings:numberShowing"))
          elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + 0 * respc(30), respc(240), respc(30)) then
            setElementData(localPlayer, "settings:advertsShowing", not getElementData(localPlayer, "settings:advertsShowing"))
          end
        elseif _UPVALUE0_.selectedMenu == "illegalad" then
          if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            _UPVALUE0_.selectedMenu = "headMenu"
            _UPVALUE4_.invitingText = ""
            _UPVALUE4_.actualEditing = ""
            _UPVALUE4_.illegalEdit = ""
          elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 + respc(85), phoneY + respc(80) + 2 * respc(30), respc(25), respc(25)) then
            if 10 < string.len(_UPVALUE4_.illegalEdit) then
              if string.len(_UPVALUE4_.illegalEdit) * 0.58 <= getElementData(localPlayer, "money") then
                if not isTimer(_UPVALUE6_) then
                  triggerServerEvent("placeAdvertServer", localPlayer, localPlayer, _UPVALUE4_.illegalEdit, string.len(_UPVALUE4_.illegalEdit) * 0.58, actualPhoneID, getElementData(localPlayer, "settings:illegalNumberShowing"), "illegal")
                  _UPVALUE4_.actualEditing = ""
                  _UPVALUE4_.illegalEdit = ""
                  _UPVALUE6_ = setTimer(function()
                    _UPVALUE0_ = nil
                  end, 60000, 1)
                else
                  outputChatBox("#d9534f[LSRP]: #FFFFFFCsak percenként adhatsz fel hirdetést!", 255, 0, 0, true)
                end
              else
                outputChatBox("#d9534f[LSRP]: #FFFFFFNincs elegendő egyenleged!", 255, 0, 0, true)
              end
            else
              outputChatBox("#d9534f[LSRP]: #FFFFFFNem elegendő hosszúságú a hirdetésed!", 255, 0, 0, true)
            end
          elseif isInSlot(phoneX + respc(22), phoneY + respc(78) + 2 * respc(30), respc(230), respc(150)) then
            _UPVALUE4_.invitingText = _UPVALUE4_.illegalEdit
            _UPVALUE4_.actualEditing = "illegalad"
          elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + 1 * respc(30), respc(240), respc(30)) then
            setElementData(localPlayer, "settings:illegalNumberShowing", not getElementData(localPlayer, "settings:illegalNumberShowing"))
          elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(120), phoneY + respc(70) + 0 * respc(30), respc(240), respc(30)) then
            setElementData(localPlayer, "settings:illegalAdvertsShowing", not getElementData(localPlayer, "settings:illegalAdvertsShowing"))
          end
        elseif _UPVALUE0_.selectedMenu == "phone" then
          for _FORV_7_, _FORV_8_ in pairs(_UPVALUE7_) do
            if 0 + 1 == 4 then
            end
            if isInSlot(phoneX + respc(50) + (1 - 1) * respc(65), phoneY + respc(165) + (0 + 1) * respc(60), respc(45), respc(45)) and #_UPVALUE8_ + 1 <= 16 then
              table.insert(_UPVALUE8_, _FORV_8_)
              if _FORV_8_ == "1" or _FORV_8_ == "4" or _FORV_8_ == "7" then
                playSound("files/sounds/2/mobile147.mp3")
              elseif _FORV_8_ == "2" or _FORV_8_ == "5" or _FORV_8_ == "8" or _FORV_8_ == "0" then
                playSound("files/sounds/2/mobile258.mp3")
              elseif _FORV_8_ == "3" or _FORV_8_ == "6" or _FORV_8_ == "9" then
                playSound("files/sounds/2/mobile369.mp3")
              end
            end
          end
          if isInSlot(phoneX + respc(50) + 1 * respc(65), phoneY + respc(165) + 4 * respc(60), respc(45), respc(45)) then
            if #_UPVALUE8_ > 2 then
              callMemberClient(table.concat(_UPVALUE8_))
            else
              outputChatBox("#e63946[LSRP]: #ffffffÉrvénytelen telefonszám!", 0, 0, 0, true)
            end
          elseif isInSlot(phoneX + respc(50) + 2 * respc(65), phoneY + respc(165) + 4 * respc(60), respc(45), respc(45)) then
            if #_UPVALUE8_ > 0 then
              _UPVALUE8_[#_UPVALUE8_] = nil
            end
          elseif isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            if #_UPVALUE8_ > 0 then
              for _FORV_7_ = 1, #_UPVALUE8_ do
                _UPVALUE8_[_FORV_7_] = nil
              end
            end
            _FOR_.selectedMenu = "headMenu"
          end
        elseif _UPVALUE0_.selectedMenu == "call:Caller" then
          if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(45) / 2, phoneY + _UPVALUE0_.phoneH - respc(140), respc(45), respc(45)) then
            triggerServerEvent("cancelCallServer", localPlayer, localPlayer, _UPVALUE9_.callMember)
          end
        elseif _UPVALUE0_.selectedMenu == "call:Called" then
          if isInSlot(phoneX + respc(50), phoneY + _UPVALUE0_.phoneH - respc(140), respc(45), respc(45)) then
            triggerServerEvent("cancelCallServer", localPlayer, localPlayer, _UPVALUE9_.callMember)
          elseif isInSlot(phoneX + _UPVALUE0_.phoneW - respc(95), phoneY + _UPVALUE0_.phoneH - respc(140), respc(45), respc(45)) then
            triggerServerEvent("acceptCallServer", localPlayer, localPlayer, _UPVALUE9_.callMember)
          end
        elseif _UPVALUE0_.selectedMenu == "call:inCall" then
          if isInSlot(phoneX + respc(20), phoneY + respc(120), respc(200), respc(25)) then
            _UPVALUE4_.invitingText = _UPVALUE4_.callInputMessage
            _UPVALUE4_.actualEditing = "callMessageInput"
          else
            _UPVALUE4_.actualEditing = ""
          end
          if isInSlot(phoneX + respc(230), phoneY + respc(120), respc(25), respc(25)) then
            sendCallMessageClient()
          elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(45) / 2, phoneY + _UPVALUE0_.phoneH - respc(100), respc(45), respc(45)) then
            triggerServerEvent("cancelCallServer", localPlayer, localPlayer, _UPVALUE9_.callMember)
          end
        elseif _UPVALUE0_.selectedMenu == "contacts" then
          if isInSlot(phoneX + _UPVALUE0_.phoneW - respc(45), phoneY + respc(37), respc(30), respc(30)) then
            _UPVALUE0_.newContactState = true
          end
          if _UPVALUE0_.newContactState then
            if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(85), phoneY + respc(120), respc(150), respc(20)) then
              if _UPVALUE4_.contactName == "Név" then
                _UPVALUE4_.contactName = ""
              end
              _UPVALUE4_.invitingText = _UPVALUE4_.contactName
              _UPVALUE4_.actualEditing = "contactName"
            elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(85), phoneY + respc(155), respc(210), respc(20)) then
              if _UPVALUE4_.contactNumber == "Telefonszám" then
                _UPVALUE4_.contactNumber = ""
              end
              _UPVALUE4_.invitingText = _UPVALUE4_.contactNumber
              _UPVALUE4_.actualEditing = "contactNumber"
            elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(10), phoneY + respc(55), respc(50), respc(25)) then
              _UPVALUE4_.invitingText = ""
              _UPVALUE4_.actualEditing = ""
              _UPVALUE4_.contactNumber = "Telefonszám"
              _UPVALUE4_.contactName = "Név"
              _UPVALUE0_.newContactState = false
            elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(236) / 2 + respc(200), phoneY + respc(55), respc(50), respc(25)) then
              if 1 < string.len(_UPVALUE4_.contactName) and 1 < string.len(_UPVALUE4_.contactNumber) and _UPVALUE4_.contactName ~= "Név" and _UPVALUE4_.contactNumber ~= "Telefonszám" then
                table.insert(_UPVALUE10_, {
                  name = _UPVALUE4_.contactName,
                  number = tonumber(_UPVALUE4_.contactNumber)
                })
                _UPVALUE4_.invitingText = ""
                _UPVALUE4_.actualEditing = ""
                _UPVALUE4_.contactNumber = "Telefonszám"
                _UPVALUE4_.contactName = "Név"
                _UPVALUE0_.newContactState = false
              else
                outputChatBox("#d9534f[LSRP]: #FFFFFFHiányos adatokkal nem mentheted el a névjegyet!", 255, 0, 0, true)
              end
            end
          else
            if #_UPVALUE10_ > 0 then
              for _FORV_6_, _FORV_7_ in pairs(_UPVALUE10_) do
                if _FORV_6_ > _UPVALUE0_.scrollContact and 0 < 14 then
                  if isInSlot(phoneX + _UPVALUE0_.phoneW - respc(110), phoneY + respc(70) + (0 + 1 - 1) * respc(30), respc(30), respc(30)) then
                    callMemberClient(_FORV_7_.number)
                  elseif isInSlot(phoneX + _UPVALUE0_.phoneW - respc(80), phoneY + respc(70) + (0 + 1 - 1) * respc(30), respc(30), respc(30)) then
                    _UPVALUE0_.selectedMenu = "newMessage"
                    _UPVALUE4_.newMessageNumber = tostring(_FORV_7_.number)
                  end
                  if not _UPVALUE0_.deleteNotification and isInSlot(phoneX + _UPVALUE0_.phoneW - respc(50), phoneY + respc(70) + (0 + 1 - 1) * respc(30), respc(30), respc(30)) then
                    _UPVALUE0_.notificationTick = getTickCount()
                    _UPVALUE0_.selectedContact = _FORV_6_
                    _UPVALUE0_.deleteNotification = true
                  end
                end
              end
              if _UPVALUE0_.deleteNotification then
                if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(185) / 2, phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2 + respc(66), respc(94), respc(30)) then
                  _UPVALUE0_.notificationTick = getTickCount()
                  _UPVALUE0_.deleteNotification = false
                elseif isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(183) / 2 + respc(90), phoneY + _UPVALUE0_.phoneH / 2 - respc(94) / 2 + respc(66), respc(94), respc(30)) then
                  _UPVALUE0_.notificationTick = getTickCount()
                  _UPVALUE0_.deleteNotification = false
                  table.remove(_UPVALUE10_, _UPVALUE0_.selectedContact)
                end
              end
            end
            if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
              _UPVALUE0_.selectedMenu = "headMenu"
              _UPVALUE0_.deleteNotification = false
            end
          end
        elseif _UPVALUE0_.selectedMenu == "messages" then
          if 1 > _UPVALUE0_.selectedMessageContact then
            for _FORV_6_, _FORV_7_ in pairs(_UPVALUE11_) do
              if _FORV_6_ > _UPVALUE0_.scrollSelectableMessages and 10 > 0 then
                if isInSlot(phoneX + _UPVALUE0_.phoneW - respc(50), phoneY + respc(75) + (0 + 1 - 1) * respc(35), respc(30), respc(30)) then
                  table.remove(_UPVALUE11_, _FORV_6_)
                elseif isInSlot(phoneX + respc(20), phoneY + respc(75) + (0 + 1 - 1) * respc(35), respc(250), respc(30)) then
                  _UPVALUE0_.selectedMessageContact = _FORV_6_
                  _UPVALUE11_[_UPVALUE0_.selectedMessageContact].opened = true
                end
              end
            end
            if isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
              _UPVALUE0_.selectedMenu = "headMenu"
            elseif isInSlot(phoneX + _UPVALUE0_.phoneW - respc(45), phoneY + respc(37), respc(30), respc(30)) then
              _UPVALUE0_.selectedMenu = "newMessage"
            end
          elseif isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            _UPVALUE0_.selectedMessageContact = 0
          elseif isInSlot(phoneX + respc(20), phoneY + respc(460), respc(200), respc(25)) then
            _UPVALUE4_.invitingText = _UPVALUE4_.realSMSText
            _UPVALUE4_.actualEditing = "realSMSText"
          elseif isInSlot(phoneX + respc(230), phoneY + respc(460), respc(25), respc(25)) then
            if 0 < string.len(_UPVALUE4_.realSMSText) then
              if getElementData(localPlayer, "money") >= 8 then
                triggerServerEvent("sendMessageServer", localPlayer, localPlayer, _UPVALUE4_.realSMSText, actualPhoneID, _UPVALUE11_[_UPVALUE0_.selectedMessageContact].number)
                _UPVALUE4_.realSMSText = ""
                _UPVALUE4_.invitingText = ""
                _UPVALUE4_.actualEditing = ""
              else
                outputChatBox("#d9534f[LSRP]: #FFFFFFNincs elég pénzed, hogy elküldhesd az SMS-t!", 255, 0, 0, true)
              end
            else
              outputChatBox("#d9534f[LSRP]: #FFFFFFNem elég hosszúságú az SMS szövege!", 255, 0, 0, true)
            end
          end
        elseif _UPVALUE0_.selectedMenu == "newMessage" then
          if isInSlot(phoneX + respc(20), phoneY + respc(65) + 0 * respc(35), respc(250), respc(30)) then
            _UPVALUE4_.invitingText = _UPVALUE4_.newMessageNumber
            _UPVALUE4_.actualEditing = "messageNumber"
          elseif isInSlot(phoneX + respc(20), phoneY + respc(460), respc(200), respc(25)) then
            _UPVALUE4_.invitingText = _UPVALUE4_.smsText
            _UPVALUE4_.actualEditing = "smsText"
          elseif isInSlot(phoneX + respc(230), phoneY + respc(460), respc(25), respc(25)) then
            if 0 < string.len(_UPVALUE4_.smsText) and 2 < string.len(_UPVALUE4_.newMessageNumber) then
              triggerServerEvent("sendMessageServer", localPlayer, localPlayer, _UPVALUE4_.smsText, actualPhoneID, tonumber(_UPVALUE4_.newMessageNumber))
              _UPVALUE4_.smsText = ""
              _UPVALUE4_.invitingText = ""
              _UPVALUE4_.actualEditing = ""
            else
              outputChatBox("#d9534f[LSRP]: #FFFFFFÉrvénytelen szám és vagy szöveg!", 255, 0, 0, true)
            end
          elseif isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            _UPVALUE0_.selectedMenu = "messages"
            _UPVALUE4_.smsText = ""
            _UPVALUE4_.actualEditing = ""
            _UPVALUE4_.newMessageNumber = ""
          end
        elseif _UPVALUE0_.selectedMenu == "camera" then
          if isInSlot(phoneX + _UPVALUE0_.phoneW / 2 - respc(22), phoneY + respc(430), respc(44), respc(44)) then
            pixels = dxGetTexturePixels(_UPVALUE12_)
            pixels = dxConvertPixels(pixels, "png")
            fh = fileCreate("pictures/" .. (getRealTime().year + 1900 .. "-" .. getRealTime().month + 1 .. "-" .. getRealTime().monthday .. "-" .. getRealTime().hour .. "-" .. getRealTime().minute .. "-" .. getRealTime().second) .. ".png")
            fileWrite(fh, pixels)
            fileClose(fh)
            _UPVALUE0_.flashState = true
            _UPVALUE0_.flashTick = getTickCount()
            setTimer(function()
              _UPVALUE0_.flashState = false
              _UPVALUE0_.flashTick = getTickCount()
            end, 300, 1)
            playSound("files/sounds/2/mobilecam.mp3", false)
          elseif isInSlot(phoneX + respc(15), phoneY + respc(37), respc(30), respc(30)) then
            _UPVALUE0_.selectedMenu = "headMenu"
            exports.lsmta_global:toggleFirstPersonExport(false)
          end
        end
      end
    end
  elseif _ARG_0_ == "left" and _ARG_1_ == "up" and _UPVALUE0_.indicatorPressed then
    _UPVALUE0_.closeTick = getTickCount()
    _UPVALUE0_.indicatorPressed = false
    if _UPVALUE0_.indicatorY <= (phoneY + _UPVALUE0_.phoneH) / 1.5 then
      _UPVALUE0_.moveState = "open"
    else
      _UPVALUE0_.moveState = "close"
    end
  end
end
addEventHandler("onClientClick", getRootElement(), clickHandler)
function callMemberClient(_ARG_0_)
  if tonumber(_ARG_0_) then
    triggerServerEvent("callTargetInServer", localPlayer, localPlayer, _ARG_0_, actualPhoneID)
  end
end
function findContactByNumber(_ARG_0_)
  for _FORV_4_, _FORV_5_ in pairs(_UPVALUE0_) do
    if _FORV_5_.number == _ARG_0_ then
      return _FORV_5_.name
    end
  end
  return false
end
bindKey("mouse_wheel_down", "down", function()
  if _UPVALUE0_.selectedMenu == "contacts" then
    if _UPVALUE0_.scrollContact < #_UPVALUE1_ - 14 then
      _UPVALUE0_.scrollContact = _UPVALUE0_.scrollContact + 1
    end
  elseif _UPVALUE0_.selectedMenu == "messages" and _UPVALUE0_.selectedMessageContact > 0 and 0 > _UPVALUE0_.scrollSMS then
    _UPVALUE0_.scrollSMS = _UPVALUE0_.scrollSMS + 1
  end
end)
bindKey("mouse_wheel_up", "down", function()
  if _UPVALUE0_.selectedMenu == "contacts" and _UPVALUE0_.scrollContact > 0 then
    _UPVALUE0_.scrollContact = _UPVALUE0_.scrollContact - 1
  end
  if _UPVALUE0_.selectedMenu == "messages" and 0 < _UPVALUE0_.selectedMessageContact then
    _UPVALUE0_.scrollSMS = _UPVALUE0_.scrollSMS - 1
  end
end)
function showSound()
  if getElementData(localPlayer, "settings:Sound") then
    if isElement(_UPVALUE0_.callSound) then
      stopSound(_UPVALUE0_.callSound)
    end
    _UPVALUE0_.callSound = playSound("files/sounds/" .. getElementData(localPlayer, "settings:Ringtone") .. ".mp3", true)
  end
  if getElementData(localPlayer, "settings:Vibration") then
    if isElement(_UPVALUE0_.callVibration) then
      stopSound(_UPVALUE0_.callVibration)
    end
    _UPVALUE0_.callVibration = playSound("files/sounds/vibrate.mp3", true)
  end
end
addEvent("showSound", true)
addEventHandler("showSound", getRootElement(), showSound)
function showMenu(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_)
  setElementData(_ARG_1_, "inCall", true)
  _UPVALUE0_.callMember = _ARG_1_
  _UPVALUE0_.calledNumber = _ARG_0_
  _UPVALUE1_.phoneState = true
  _UPVALUE1_.phoneMode = "phone:unLocked"
  if _ARG_2_ then
    _UPVALUE1_.selectedMenu = "call:Caller"
  else
    _UPVALUE1_.selectedMenu = "call:Called"
    actualPhoneID = _ARG_3_
  end
end
addEvent("showMenu", true)
addEventHandler("showMenu", getRootElement(), showMenu)
function clientAcceptCall(_ARG_0_)
  _UPVALUE0_ = {}
  _UPVALUE1_.selectedMenu = "call:inCall"
  if isElement(_UPVALUE2_.callSound) then
    stopSound(_UPVALUE2_.callSound)
  end
  if isElement(_UPVALUE2_.callVibration) then
    stopSound(_UPVALUE2_.callVibration)
  end
end
addEvent("clientAcceptCall", true)
addEventHandler("clientAcceptCall", getRootElement(), clientAcceptCall)
function clientCancelCall(_ARG_0_)
  setElementData(_ARG_0_, "inCall", false)
  _UPVALUE0_.callMember = nil
  _UPVALUE0_.calledNumber = ""
  _UPVALUE1_.phoneMode = "phone:unLocked"
  _UPVALUE1_.selectedMenu = "headMenu"
  outputChatBox("#d9534f[LSRP]: #FFFFFFA hívás véget ért.", 255, 0, 0, true)
  if isElement(_UPVALUE0_.callSound) then
    stopSound(_UPVALUE0_.callSound)
  end
  if isElement(_UPVALUE0_.callVibration) then
    stopSound(_UPVALUE0_.callVibration)
  end
end
addEvent("clientCancelCall", true)
addEventHandler("clientCancelCall", getRootElement(), clientCancelCall)
function sendCallMessageClient()
  if string.len(_UPVALUE0_.callInputMessage) > 1 then
    triggerServerEvent("sendCallMessages", localPlayer, localPlayer, _UPVALUE1_.callMember, _UPVALUE0_.callInputMessage, actualPhoneID)
    _UPVALUE0_.callInputMessage = ""
  else
    outputChatBox("#d9534f[LSRP]: #FFFFFFTúl rövid a begépelt szöveged!", 0, 0, 0, true)
  end
end
function insertMessages(_ARG_0_, _ARG_1_)
  _UPVALUE0_[#_UPVALUE0_ + 1] = {_ARG_0_, _ARG_1_}
  _UPVALUE1_ = _UPVALUE1_ + 1
  if _UPVALUE1_ > 8 then
    _UPVALUE2_ = _UPVALUE2_ + 1
  end
end
addEvent("insertMessages", true)
addEventHandler("insertMessages", getRootElement(), insertMessages)
function syncContactTableClient(_ARG_0_, _ARG_1_)
  if _ARG_1_ then
    _UPVALUE0_ = _ARG_0_
  else
    _UPVALUE0_ = {}
  end
end
addEvent("syncContactTableClient", true)
addEventHandler("syncContactTableClient", getRootElement(), syncContactTableClient)
function syncMessageTableClient(_ARG_0_, _ARG_1_)
  if _ARG_1_ then
    _UPVALUE0_ = _ARG_0_
  else
    _UPVALUE0_ = {}
  end
end
addEvent("syncMessageTableClient", true)
addEventHandler("syncMessageTableClient", getRootElement(), syncMessageTableClient)
function syncSentMessageToClient(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_)
  for _FORV_8_, _FORV_9_ in pairs(_UPVALUE0_) do
  end
  if not _FORV_8_ then
    _UPVALUE0_[#_UPVALUE0_ + 1] = {
      number = _ARG_2_,
      messages = {},
      opened = true
    }
    _UPVALUE0_[#_UPVALUE0_].messages[1] = {_ARG_0_, _ARG_1_}
  else
    _UPVALUE0_[_FORV_8_].messages[#_UPVALUE0_[_FORV_8_].messages + 1] = {_ARG_0_, _ARG_1_}
    _UPVALUE0_[_FORV_8_].opened = true
  end
  if _ARG_1_ == actualPhoneID then
    _UPVALUE1_.selectedMenu = "messages"
    _UPVALUE1_.selectedMessageContact = #_UPVALUE0_
  else
    playSound("files/sounds/" .. getElementData(localPlayer, "settings:Notice") .. ".mp3", false)
    if _UPVALUE1_.selectedMessageContact ~= #_UPVALUE0_ then
      if not _FORV_8_ then
        _UPVALUE0_[#_UPVALUE0_].opened = false
      else
        _UPVALUE0_[_FORV_8_].opened = false
      end
      if not _UPVALUE1_.phoneState then
        showPhoneFunction(_ARG_3_, true)
      end
    end
  end
end
addEvent("syncSentMessageToClient", true)
addEventHandler("syncSentMessageToClient", getRootElement(), syncSentMessageToClient)
addEventHandler("onClientElementDataChange", getRootElement(), function(_ARG_0_, _ARG_1_, _ARG_2_)
  if source == localPlayer and getElementType(source) == "player" and _ARG_0_ == "adminjailed" and getElementData(source, "adminjailed") then
    outputChatBox("chat")
    if _UPVALUE0_.phoneState then
      showPhoneFunction(actualPhoneID, false)
    end
  end
end)
function showPhoneFunction(_ARG_0_, _ARG_1_)
  if _UPVALUE0_.phoneState then
    exports.lsmta_global:toggleFirstPersonExport(false)
    _UPVALUE0_.phoneState = false
    _UPVALUE0_.phoneMode = "phone:locked"
    triggerServerEvent("saveContactTableServer", localPlayer, localPlayer, _ARG_0_, _UPVALUE1_)
    triggerServerEvent("saveMessageTableServer", localPlayer, localPlayer, _ARG_0_, _UPVALUE2_)
    exports.lsmta_global:sendLocalMeAction(localPlayer, "elrakja a telefonját.")
  else
    if getElementData(localPlayer, "adminjailed") then
      outputChatBox("#d9534f[LSRP]: #FFFFFFBörtönben nem veheted elő a telefonodat!", 255, 0, 0, true)
      return
    end
    exports.lsmta_global:sendLocalMeAction(localPlayer, "előveszi a telefonját.")
    if not _ARG_1_ then
      triggerServerEvent("getContactTableServer", localPlayer, localPlayer, _ARG_0_)
      triggerServerEvent("getMessageTableServer", localPlayer, localPlayer, _ARG_0_)
    end
    phoneX, phoneY = exports.lsmta_hud:getNode(3, "x"), exports.lsmta_hud:getNode(3, "y")
    _UPVALUE0_.indicatorY = phoneY + _UPVALUE0_.phoneH - respc(30)
    _UPVALUE0_.selectedMenu = "headMenu"
    _UPVALUE0_.absolutWallPaperY = phoneY
    _UPVALUE0_.wallPaperY = 0
    _UPVALUE0_.phoneState = true
    actualPhoneID = _ARG_0_
  end
end
function playPreviewSound(_ARG_0_)
  if isElement(_UPVALUE0_.previewSound) then
    stopSound(_UPVALUE0_.previewSound)
  end
  _UPVALUE0_.previewSound = playSound("files/sounds/" .. _ARG_0_ .. ".mp3", false)
end
function clientPlaceAdvertisement(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_)
  if getElementData(source, "loggedin") > 0 then
    if _ARG_4_ == "illegal" then
      if getElementData(source, "settings:illegalAdvertsShowing") then
        outputChatBox("#e63946[Darknet]: #cc9999" .. _ARG_1_ .. " ((" .. getPlayerName(_ARG_0_):gsub("_", " ") .. "))", 0, 0, 0, true)
        if _ARG_3_ then
          outputChatBox("#e63946[Telefonszám]: #cc9999" .. _ARG_2_, 0, 0, 0, true)
        end
      end
    elseif getElementData(source, "settings:advertsShowing") then
      outputChatBox("#ff9933[Hírdetés]: #cc6600" .. _ARG_1_ .. " ((" .. getPlayerName(_ARG_0_):gsub("_", " ") .. "))", 0, 0, 0, true)
      if _ARG_3_ then
        outputChatBox("#ff9933[Telefonszám]: #cc6600" .. _ARG_2_, 0, 0, 0, true)
      end
    end
  end
end
addEvent("clientPlaceAdvertisement", true)
addEventHandler("clientPlaceAdvertisement", getRootElement(), clientPlaceAdvertisement)
alapBeallitasok = {
  {
    true,
    true,
    true,
    true,
    1,
    "ringatria",
    "smsariel",
    true,
    true,
    2
  }
}
function saveSettings()
  if xmlLoadFile("settings.xml") then
    for _FORV_4_, _FORV_5_ in pairs(alapBeallitasok) do
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "numberShowing", 0), tostring(getElementData(localPlayer, "settings:numberShowing")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "advertsShowing", 0), tostring(getElementData(localPlayer, "settings:advertsShowing")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "illegalAdvertsShowing", 0), tostring(getElementData(localPlayer, "settings:illegalAdvertsShowing")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "illegalNumberShowing", 0), tostring(getElementData(localPlayer, "settings:illegalNumberShowing")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Wallpaper", 0), tonumber(getElementData(localPlayer, "settings:Wallpaper")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Ringtone", 0), tostring(getElementData(localPlayer, "settings:Ringtone")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Notice", 0), tostring(getElementData(localPlayer, "settings:Notice")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Sound", 0), tostring(getElementData(localPlayer, "settings:Sound")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Vibration", 0), tostring(getElementData(localPlayer, "settings:Vibration")))
      xmlNodeSetValue(xmlFindChild(xmlLoadFile("settings.xml"), "lockedWallpaper", 0), tonumber(getElementData(localPlayer, "settings:lockedWallpaper")))
    end
    xmlSaveFile((xmlLoadFile("settings.xml")))
  end
end
addEventHandler("onClientResourceStop", getRootElement(), saveSettings)
addEventHandler("onClientPlayerQuit", getRootElement(), saveSettings)
addEventHandler("onClientResourceStart", resourceRoot, function()
  _UPVALUE0_ = dxCreateScreenSource(respc(1920), respc(1080))
  if not xmlLoadFile("settings.xml") then
    for _FORV_4_, _FORV_5_ in ipairs(alapBeallitasok) do
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "numberShowing"), tostring(_FORV_5_[1]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "advertsShowing"), tostring(_FORV_5_[2]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "illegalAdvertsShowing"), tostring(_FORV_5_[3]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "illegalNumberShowing"), tostring(_FORV_5_[4]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "Wallpaper"), tonumber(_FORV_5_[5]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "Ringtone"), tostring(_FORV_5_[6]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "Notice"), tostring(_FORV_5_[7]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "Sound"), tostring(_FORV_5_[8]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "Vibration"), tostring(_FORV_5_[9]))
      xmlNodeSetValue(xmlCreateChild(xmlCreateFile("settings.xml", "root"), "lockedWallpaper"), tonumber(_FORV_5_[10]))
    end
    setElementData(localPlayer, "settings:numberShowing", true)
    setElementData(localPlayer, "settings:advertsShowing", true)
    setElementData(localPlayer, "settings:illegalAdvertsShowing", true)
    setElementData(localPlayer, "settings:illegalNumberShowing", true)
    setElementData(localPlayer, "settings:Wallpaper", 1)
    setElementData(localPlayer, "settings:lockedWallpaper", 2)
    setElementData(localPlayer, "settings:Ringtone", "ringatria")
    setElementData(localPlayer, "settings:Notice", "smsariel")
    setElementData(localPlayer, "settings:Sound", true)
    setElementData(localPlayer, "settings:Vibration", true)
    xmlSaveFile((xmlCreateFile("settings.xml", "root")))
  else
    if tostring(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "numberShowing", 0))) == "true" then
    else
    end
    if tostring(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "advertsShowing", 0))) == "true" then
    else
    end
    if tostring(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "illegalAdvertsShowing", 0))) == "true" then
    else
    end
    if tostring(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "illegalNumberShowing", 0))) == "true" then
    else
    end
    if tostring(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Sound", 0))) == "true" then
    else
    end
    if tostring(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Vibration", 0))) == "true" then
    else
    end
    setElementData(localPlayer, "settings:numberShowing", false)
    setElementData(localPlayer, "settings:advertsShowing", false)
    setElementData(localPlayer, "settings:illegalAdvertsShowing", false)
    setElementData(localPlayer, "settings:illegalNumberShowing", false)
    setElementData(localPlayer, "settings:Wallpaper", tonumber(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Wallpaper", 0))))
    setElementData(localPlayer, "settings:lockedWallpaper", tonumber(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "lockedWallpaper", 0))))
    setElementData(localPlayer, "settings:Ringtone", tostring(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Ringtone", 0))))
    setElementData(localPlayer, "settings:Notice", tostring(xmlNodeGetValue(xmlFindChild(xmlLoadFile("settings.xml"), "Notice", 0))))
    setElementData(localPlayer, "settings:Sound", false)
    setElementData(localPlayer, "settings:Vibration", false)
  end
end)
