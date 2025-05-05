screenX, screenY = guiGetScreenSize()
function reMap(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_)
  return _ARG_3_ + (_ARG_0_ - _ARG_1_) * (_ARG_4_ - _ARG_3_) / (_ARG_2_ - _ARG_1_)
end
function resp(_ARG_0_)
  return _ARG_0_ * responsiveMultiplier
end
function respc(_ARG_0_)
  return math.ceil(_ARG_0_ * responsiveMultiplier)
end
responsiveMultiplier = math.min(1, reMap(screenX, 1024, 1920, 0.75, 1))
function dxDrawCorrectText(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_, _ARG_13_)
  dxDrawText(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_1_ + _ARG_3_, _ARG_2_ + _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_, _ARG_13_)
end
function dxDrawTooltip(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_)
  if isCursorShowing() and isInSlot(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_) then
    _ARG_8_ = _ARG_8_ or tocolor(0, 0, 0, 200)
    _ARG_9_ = _ARG_9_ or tocolor(255, 255, 255, 200)
    dxDrawRectangle(getCursorPosition() * screenX, getCursorPosition() * screenY, dxGetTextWidth(_ARG_5_, _ARG_7_, _ARG_6_) + respc(10), _ARG_4_, _ARG_8_)
    dxDrawCorrectText(_ARG_5_, getCursorPosition() * screenX + respc(5), getCursorPosition() * screenY, dxGetTextWidth(_ARG_5_, _ARG_7_, _ARG_6_), _ARG_4_, _ARG_9_, _ARG_7_, _ARG_6_, "left", "center")
  end
end
function dxDrawToolTipImage(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_)
  if isInSlot(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_) then
    dxDrawImage(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_9_, postGui)
  else
    dxDrawImage(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, postGui)
  end
  dxDrawTooltip(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, respc(25), _ARG_10_, _ARG_11_, _ARG_12_)
end
function dxDrawImageButton(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_)
  if isInSlot(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_) then
    renderData.activeDirectX = _ARG_10_
    dxDrawImage(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_9_, postGui)
  else
    dxDrawImage(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, postGui)
  end
end
function dxDrawImageButtonWithText(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_, _ARG_13_, _ARG_14_)
  _ARG_14_ = _ARG_14_ or _ARG_11_
  if isInSlot(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_) then
    renderData.activeDirectX = _ARG_14_
    dxDrawImage(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_9_, postGui)
  else
    dxDrawImage(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, postGui)
  end
  dxDrawCorrectText(_ARG_11_, _ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_10_, _ARG_12_, _ARG_13_, "center", "center")
end
function dxDrawImageOnElement(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_)
  if getScreenFromWorldPosition(getElementPosition(_ARG_0_)) and getScreenFromWorldPosition(getElementPosition(_ARG_0_)) then
    dxDrawMaterialLine3D(getElementPosition(_ARG_0_))
  end
end
function drawImageByState(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_, _ARG_13_)
  _ARG_9_ = _ARG_9_ or false
  _ARG_13_ = _ARG_13_ or false
  _ARG_10_ = _ARG_10_ or 0
  _ARG_11_ = _ARG_11_ or 0
  _ARG_12_ = _ARG_12_ or 0
  if _ARG_6_ then
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_5_[1],
        _ARG_5_[2],
        _ARG_5_[3],
        _ARG_5_[4]
      }, _ARG_8_)
    }
  else
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_5_[1],
        _ARG_5_[2],
        _ARG_5_[3],
        0
      }, _ARG_8_)
    }
  end
  dxDrawImage(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_7_, _ARG_10_, _ARG_11_, _ARG_12_, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], _ARG_5_[4] - (_ARG_5_[4] - buttonColor[4])), _ARG_13_)
  if _ARG_9_ then
    renderData.buttons[_ARG_0_] = {
      _ARG_1_,
      _ARG_2_,
      _ARG_3_,
      _ARG_4_
    }
  end
end
function drawImageByHover(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_, _ARG_13_, _ARG_14_, _ARG_15_, _ARG_16_)
  _ARG_12_ = _ARG_12_ or false
  _ARG_16_ = _ARG_16_ or false
  _ARG_13_ = _ARG_13_ or 0
  _ARG_14_ = _ARG_14_ or 0
  _ARG_15_ = _ARG_15_ or 0
  if isInSlot(_ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_) then
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_9_[1],
        _ARG_9_[2],
        _ARG_9_[3],
        _ARG_9_[4]
      }, _ARG_11_)
    }
  else
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_9_[1],
        _ARG_9_[2],
        _ARG_9_[3],
        0
      }, _ARG_11_)
    }
  end
  dxDrawImage(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_10_, _ARG_13_, _ARG_14_, _ARG_15_, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], _ARG_9_[4] - (_ARG_9_[4] - buttonColor[4])), _ARG_16_)
  if _ARG_12_ then
    renderData.buttons[_ARG_0_] = {
      _ARG_1_,
      _ARG_2_,
      _ARG_3_,
      _ARG_4_
    }
  end
end
function drawImageWithHover(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_, _ARG_13_)
  _ARG_9_ = _ARG_9_ or false
  _ARG_13_ = _ARG_13_ or false
  _ARG_10_ = _ARG_10_ or 0
  _ARG_11_ = _ARG_11_ or 0
  _ARG_12_ = _ARG_12_ or 0
  if isInSlot(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_) then
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_6_[1],
        _ARG_6_[2],
        _ARG_6_[3],
        _ARG_6_[4]
      }, time)
    }
  else
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_5_[1],
        _ARG_5_[2],
        _ARG_5_[3],
        _ARG_5_[4]
      }, time)
    }
  end
  dxDrawImage(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_7_, _ARG_10_, _ARG_11_, _ARG_12_, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], _ARG_5_[4] - (_ARG_5_[4] - buttonColor[4])), _ARG_13_)
  if _ARG_9_ then
    renderData.buttons[_ARG_0_] = {
      _ARG_1_,
      _ARG_2_,
      _ARG_3_,
      _ARG_4_
    }
  end
end
function drawImageHover(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_)
  _ARG_8_ = _ARG_8_ or false
  _ARG_12_ = _ARG_12_ or false
  _ARG_9_ = _ARG_9_ or 0
  _ARG_10_ = _ARG_10_ or 0
  _ARG_11_ = _ARG_11_ or 0
  if isInSlot(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_) then
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_5_[1],
        _ARG_5_[2],
        _ARG_5_[3],
        _ARG_5_[4] - 100
      }, _ARG_7_)
    }
  else
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_5_[1],
        _ARG_5_[2],
        _ARG_5_[3],
        _ARG_5_[4]
      }, _ARG_7_)
    }
  end
  dxDrawImage(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_6_, _ARG_9_, _ARG_10_, _ARG_11_, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], _ARG_5_[4] - (_ARG_5_[4] - buttonColor[4])), _ARG_12_)
  if _ARG_8_ then
    renderData.buttons[_ARG_0_] = {
      _ARG_1_,
      _ARG_2_,
      _ARG_3_,
      _ARG_4_
    }
  end
end
function drawHoverButton(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_, _ARG_9_, _ARG_10_, _ARG_11_, _ARG_12_)
  button = button or false
  _ARG_11_ = _ARG_11_ or false
  _ARG_12_ = _ARG_12_ or 800
  if isInSlot(_ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_) then
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_10_[1],
        _ARG_10_[2],
        _ARG_10_[3],
        _ARG_10_[4]
      }, _ARG_12_)
    }
  else
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_9_[1],
        _ARG_9_[2],
        _ARG_9_[3],
        _ARG_9_[4]
      }, _ARG_12_)
    }
  end
  dxDrawRectangle(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], _ARG_9_[4] - (_ARG_9_[4] - buttonColor[4])), _ARG_11_)
end
function drawButtonByState(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, _ARG_7_, _ARG_8_)
  button = button or false
  _ARG_7_ = _ARG_7_ or false
  _ARG_8_ = _ARG_8_ or 800
  if isInSlot(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_) then
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_6_[1],
        _ARG_6_[2],
        _ARG_6_[3],
        _ARG_6_[4]
      }, _ARG_8_)
    }
  else
    buttonColor = {
      processColorSwitchEffect(_ARG_0_, {
        _ARG_5_[1],
        _ARG_5_[2],
        _ARG_5_[3],
        _ARG_5_[4]
      }, _ARG_8_)
    }
  end
  dxDrawRectangle(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], _ARG_5_[4] - (_ARG_5_[4] - buttonColor[4])), _ARG_7_)
end
;({}).storedColors = {}
;({}).lastColors = {}
;({}).startInterpolation = {}
;({}).lastColorConcat = {}
function processColorSwitchEffect(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_)
  if not _UPVALUE0_.storedColors[_ARG_0_] then
    if not _ARG_1_[4] then
      _ARG_1_[4] = 255
    end
    _UPVALUE0_.storedColors[_ARG_0_] = _ARG_1_
    _UPVALUE0_.lastColors[_ARG_0_] = _ARG_1_
    _UPVALUE0_.lastColorConcat[_ARG_0_] = table.concat(_ARG_1_)
  end
  _ARG_2_ = _ARG_2_ or 500
  _ARG_3_ = _ARG_3_ or "Linear"
  if _UPVALUE0_.lastColorConcat[_ARG_0_] ~= table.concat(_ARG_1_) then
    _UPVALUE0_.lastColorConcat[_ARG_0_] = table.concat(_ARG_1_)
    _UPVALUE0_.lastColors[_ARG_0_] = _ARG_1_
    _UPVALUE0_.startInterpolation[_ARG_0_] = getTickCount()
  end
  if _UPVALUE0_.startInterpolation[_ARG_0_] then
    _UPVALUE0_.storedColors[_ARG_0_][1] = interpolateBetween(_UPVALUE0_.storedColors[_ARG_0_][1], _UPVALUE0_.storedColors[_ARG_0_][2], _UPVALUE0_.storedColors[_ARG_0_][3], _ARG_1_[1], _ARG_1_[2], _ARG_1_[3], (getTickCount() - _UPVALUE0_.startInterpolation[_ARG_0_]) / _ARG_2_, _ARG_3_)
    _UPVALUE0_.storedColors[_ARG_0_][2] = interpolateBetween(_UPVALUE0_.storedColors[_ARG_0_][1], _UPVALUE0_.storedColors[_ARG_0_][2], _UPVALUE0_.storedColors[_ARG_0_][3], _ARG_1_[1], _ARG_1_[2], _ARG_1_[3], (getTickCount() - _UPVALUE0_.startInterpolation[_ARG_0_]) / _ARG_2_, _ARG_3_)
    _UPVALUE0_.storedColors[_ARG_0_][3] = interpolateBetween(_UPVALUE0_.storedColors[_ARG_0_][1], _UPVALUE0_.storedColors[_ARG_0_][2], _UPVALUE0_.storedColors[_ARG_0_][3], _ARG_1_[1], _ARG_1_[2], _ARG_1_[3], (getTickCount() - _UPVALUE0_.startInterpolation[_ARG_0_]) / _ARG_2_, _ARG_3_)
    _UPVALUE0_.storedColors[_ARG_0_][4] = interpolateBetween(_UPVALUE0_.storedColors[_ARG_0_][4], 0, 0, _ARG_1_[4], 0, 0, (getTickCount() - _UPVALUE0_.startInterpolation[_ARG_0_]) / _ARG_2_, _ARG_3_)
    if (getTickCount() - _UPVALUE0_.startInterpolation[_ARG_0_]) / _ARG_2_ >= 1 then
      _UPVALUE0_.startInterpolation[_ARG_0_] = false
    end
  end
  return _UPVALUE0_.storedColors[_ARG_0_][1], _UPVALUE0_.storedColors[_ARG_0_][2], _UPVALUE0_.storedColors[_ARG_0_][3], _UPVALUE0_.storedColors[_ARG_0_][4]
end
;({}).buttonSliderOffsets = {}
;({}).buttonStartSlider = {}
;({}).buttonSliderStates = {}
function drawButtonSlider(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_)
  if not _UPVALUE0_.buttonSliderOffsets[_ARG_0_] then
    _UPVALUE0_.buttonSliderOffsets[_ARG_0_] = _ARG_1_ and respc(16) or 0
    _UPVALUE0_.buttonSliderStates[_ARG_0_] = _ARG_1_
  end
  if _ARG_1_ then
  else
  end
  if _UPVALUE0_.buttonSliderStates[_ARG_0_] ~= _ARG_1_ then
    _UPVALUE0_.buttonSliderStates[_ARG_0_] = _ARG_1_
    _UPVALUE0_.buttonStartSlider[_ARG_0_] = {
      getTickCount(),
      _ARG_1_
    }
  end
  if _UPVALUE0_.buttonStartSlider[_ARG_0_] then
    if _UPVALUE0_.buttonStartSlider[_ARG_0_][2] then
      _UPVALUE0_.buttonSliderOffsets[_ARG_0_] = interpolateBetween(_UPVALUE0_.buttonSliderOffsets[_ARG_0_], 0, 0, respc(16), 0, 0, (getTickCount() - _UPVALUE0_.buttonStartSlider[_ARG_0_][1]) / 500, "Linear")
    else
      _UPVALUE0_.buttonSliderOffsets[_ARG_0_] = interpolateBetween(_UPVALUE0_.buttonSliderOffsets[_ARG_0_], 0, 0, 0, 0, 0, (getTickCount() - _UPVALUE0_.buttonStartSlider[_ARG_0_][1]) / 500, "Linear")
    end
    if 1 <= (getTickCount() - _UPVALUE0_.buttonStartSlider[_ARG_0_][1]) / 500 then
      _UPVALUE0_.buttonStartSlider[_ARG_0_] = false
    end
  end
  _ARG_3_ = _ARG_3_ + (_ARG_4_ - 32) / 2
  dxDrawImage(_ARG_2_, _ARG_3_, respc(32), respc(16), "files/off.png", 0, 0, 0, tocolor(({
    processColorSwitchEffect(_ARG_0_, {
      _ARG_5_[1],
      _ARG_5_[2],
      _ARG_5_[3],
      255
    })
  })[1], ({
    processColorSwitchEffect(_ARG_0_, {
      _ARG_5_[1],
      _ARG_5_[2],
      _ARG_5_[3],
      255
    })
  })[2], ({
    processColorSwitchEffect(_ARG_0_, {
      _ARG_5_[1],
      _ARG_5_[2],
      _ARG_5_[3],
      255
    })
  })[3], 255))
  dxDrawImage(_ARG_2_, _ARG_3_, respc(32), respc(16), "files/on.png", 0, 0, 0, tocolor(({
    processColorSwitchEffect(_ARG_0_, {
      _ARG_5_[1],
      _ARG_5_[2],
      _ARG_5_[3],
      255
    })
  })[1], ({
    processColorSwitchEffect(_ARG_0_, {
      _ARG_5_[1],
      _ARG_5_[2],
      _ARG_5_[3],
      255
    })
  })[2], ({
    processColorSwitchEffect(_ARG_0_, {
      _ARG_5_[1],
      _ARG_5_[2],
      _ARG_5_[3],
      255
    })
  })[3], 255))
  dxDrawImage(_ARG_2_ + _UPVALUE0_.buttonSliderOffsets[_ARG_0_], _ARG_3_, respc(32), respc(16), "files/switch.png", 0, 0, 0, tocolor(255, 255, 255, 255))
end
function dobozbaVan(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_)
  if _ARG_0_ <= _ARG_4_ and _ARG_4_ <= _ARG_0_ + _ARG_2_ and _ARG_1_ <= _ARG_5_ and _ARG_5_ <= _ARG_1_ + _ARG_3_ then
    return true
  else
    return false
  end
end
function isInSlot(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_)
  if isCursorShowing() then
    XY = {
      guiGetScreenSize()
    }
    if dobozbaVan(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, getCursorPosition() * XY[1], getCursorPosition() * XY[2]) then
      return true
    else
      return false
    end
  end
end
function convertMonthToName()
  getRealTime(timestamp).year = getRealTime(timestamp).year + 1900
  getRealTime(timestamp).month = getRealTime(timestamp).month + 1
  return _UPVALUE0_[getRealTime(timestamp).month]
end
function dxDrawRoundedCornersRectangle(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, _ARG_6_, ...)
  if not _ARG_0_ or not _ARG_1_ or not _ARG_2_ or not _ARG_3_ or not _ARG_4_ or not _ARG_5_ or not _ARG_6_ then
    return
  end
  if _ARG_4_ < _ARG_1_ * 2 then
    _ARG_4_ = _ARG_1_ * 2
  end
  if _ARG_5_ < _ARG_1_ * 2 then
    _ARG_5_ = _ARG_1_ * 2
  end
  if not isElement(_ARG_6_) then
    dxDrawRectangle(_ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, ...)
    return
  end
  if _ARG_0_ == "full" or _ARG_0_ == "top" then
    dxDrawImage(_ARG_2_, _ARG_3_, _ARG_1_, _ARG_1_, _ARG_6_, 0, 0, 0, ...)
    dxDrawImage(_ARG_2_ + _ARG_1_ + (_ARG_4_ - _ARG_1_ * 2), _ARG_3_, _ARG_1_, _ARG_1_, _ARG_6_, 90, 0, 0, ...)
    dxDrawRectangle(_ARG_2_ + _ARG_1_, _ARG_3_, _ARG_4_ - _ARG_1_ * 2, _ARG_1_, ...)
  end
  if _ARG_0_ == "top" then
    dxDrawRectangle(_ARG_2_, _ARG_3_ + _ARG_1_, _ARG_4_, _ARG_5_ - _ARG_1_, ...)
  end
  if _ARG_0_ == "full" or _ARG_0_ == "bottom" then
    dxDrawImage(_ARG_2_, _ARG_3_ + _ARG_5_ - _ARG_1_, _ARG_1_, _ARG_1_, _ARG_6_, 270, 0, 0, ...)
    dxDrawImage(_ARG_2_ + _ARG_1_ + (_ARG_4_ - _ARG_1_ * 2), _ARG_3_ + _ARG_5_ - _ARG_1_, _ARG_1_, _ARG_1_, _ARG_6_, 180, 0, 0, ...)
    dxDrawRectangle(_ARG_2_ + _ARG_1_, _ARG_3_ + _ARG_5_ - _ARG_1_, _ARG_4_ - _ARG_1_ * 2, _ARG_1_, ...)
  end
  if _ARG_0_ == "bottom" then
    dxDrawRectangle(_ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_ - _ARG_1_, ...)
  end
  if _ARG_0_ == "full" then
    dxDrawRectangle(_ARG_2_, _ARG_3_ + _ARG_1_, _ARG_4_, _ARG_5_ - _ARG_1_ * 2, ...)
  end
end
function dxDrawRoundedRectangle(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, _ARG_5_, ...)
  if _ARG_0_ == "horizontal" then
    if _ARG_3_ < _ARG_4_ then
      _ARG_3_ = _ARG_4_
    end
    if isElement(_ARG_5_) then
      dxDrawImageSection(_ARG_1_, _ARG_2_, _ARG_4_ / 2, _ARG_4_, 0, 0, 400, 800, _ARG_5_, 0, 0, 0, ...)
      dxDrawImageSection(_ARG_1_ + _ARG_4_ / 2, _ARG_2_, _ARG_3_ - _ARG_4_, _ARG_4_, 400, 0, 1, 800, _ARG_5_, 0, 0, 0, ...)
      dxDrawImageSection(_ARG_1_ + _ARG_3_ - _ARG_4_ / 2, _ARG_2_, _ARG_4_ / 2, _ARG_4_, 400, 0, 400, 800, _ARG_5_, 0, 0, 0, ...)
    else
      dxDrawRectangle(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, ...)
    end
  end
  if _ARG_0_ == "vertical" then
    if _ARG_4_ < _ARG_3_ then
      _ARG_4_ = _ARG_3_
    end
    if isElement(_ARG_5_) then
      dxDrawImageSection(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_3_ / 2, 0, 0, 800, 400, _ARG_5_, 0, 0, 0, ...)
      dxDrawImageSection(_ARG_1_, _ARG_2_ + _ARG_3_ / 2, _ARG_3_, _ARG_4_ - _ARG_3_, 0, 400, 800, 1, _ARG_5_, 0, 0, 0, ...)
      dxDrawImageSection(_ARG_1_, _ARG_2_ + _ARG_4_ - _ARG_3_ / 2, _ARG_3_, _ARG_3_ / 2, 0, 400, 800, 400, _ARG_5_, 0, 0, 0, ...)
    else
      dxDrawRectangle(_ARG_1_, _ARG_2_, _ARG_3_, _ARG_4_, ...)
    end
  end
end
