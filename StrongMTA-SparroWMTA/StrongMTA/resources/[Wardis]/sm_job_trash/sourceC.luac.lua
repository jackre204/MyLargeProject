col = engineLoadCOL("files/kuka.col")
engineReplaceCOL(col, 1439)
txd = engineLoadTXD("files/kuka.txd")
engineImportTXD(txd, 1439)
dff = engineLoadDFF("files/kuka.dff")
engineReplaceModel(dff, 1439)
createMarker(2432.87109375, -2119.8564453125, 12.546875, "cylinder", 4, 124, 197, 118, 225)
createMarker(-2099.5380859375, 299.98828125, 34.263687133789, "cylinder", 4, 124, 197, 118, 225)
addEventHandler("onClientColShapeHit", getRootElement(), function(_ARG_0_, _ARG_1_)
  if _ARG_0_ == localPlayer and _ARG_1_ and _UPVALUE0_ then
    if source == _UPVALUE1_ or source == _UPVALUE2_ then
      if getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0 and getElementModel((getPedOccupiedVehicle(localPlayer))) == 408 then
        if getElementData(getPedOccupiedVehicle(localPlayer), "loadedTrashes") >= 25 then
          setElementData(getPedOccupiedVehicle(localPlayer), "trashAnimation", true)
          setElementFrozen(getPedOccupiedVehicle(localPlayer), true)
          setVehicleDoorOpenRatio(getPedOccupiedVehicle(localPlayer), 1, 0)
          setVehicleDoorOpenRatio(getPedOccupiedVehicle(localPlayer), 1, 0.85, 2000)
          setTimer(function()
            if isElement(_UPVALUE0_) then
              setElementData(_UPVALUE0_, "trashAnimation", false)
              setElementFrozen(_UPVALUE0_, false)
              setVehicleDoorOpenRatio(_UPVALUE0_, 1, 0, 2000)
              outputChatBox("#acd373[SeeMTA - Kukás]: #ffffffSikeresen kiürítheted a kocsidat! Kerestél 60 000 forintot.", 255, 255, 255, true)
              exports.v2_hud:showInfobox("s", "Sikeresen kiürítetted a kocsidat!")
              setElementData(_UPVALUE0_, "loadedTrashes", 0)
              triggerServerEvent("payTheTrashJob", localPlayer)
            end
          end, 4000, 1)
        else
          exports.v2_hud:showInfobox("e", "Nincs még tele ez a jármű! (" .. getElementData(getPedOccupiedVehicle(localPlayer), "loadedTrashes") .. "/25 kuka)")
        end
      end
    end
    if getElementData(source, "trashColOf") and not _UPVALUE3_ then
      _UPVALUE3_ = getElementData(source, "trashColOf")
      addEventHandler("onClientRender", getRootElement(), renderTrashTooltip)
      bindKey("e", "down", attachTheTrash)
    end
  end
end)
addEventHandler("onClientColShapeLeave", getRootElement(), function(_ARG_0_, _ARG_1_)
  if _ARG_0_ == localPlayer and _ARG_1_ and getElementData(source, "trashColOf") and _UPVALUE0_ == getElementData(source, "trashColOf") then
    _UPVALUE0_ = false
    removeEventHandler("onClientRender", getRootElement(), renderTrashTooltip)
    unbindKey("e", "down", attachTheTrash)
  end
end)
addEventHandler("onClientElementDestroy", getRootElement(), function(_ARG_0_, _ARG_1_)
  if getElementData(source, "trashColOf") and _UPVALUE0_ == getElementData(source, "trashColOf") then
    _UPVALUE0_ = false
    removeEventHandler("onClientRender", getRootElement(), renderTrashTooltip)
    unbindKey("e", "down", attachTheTrash)
  end
end)
function getPositionFromElementOffset(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_)
  return _ARG_1_ * getElementMatrix(_ARG_0_)[1][1] + _ARG_2_ * getElementMatrix(_ARG_0_)[2][1] + _ARG_3_ * getElementMatrix(_ARG_0_)[3][1] + getElementMatrix(_ARG_0_)[4][1], _ARG_1_ * getElementMatrix(_ARG_0_)[1][2] + _ARG_2_ * getElementMatrix(_ARG_0_)[2][2] + _ARG_3_ * getElementMatrix(_ARG_0_)[3][2] + getElementMatrix(_ARG_0_)[4][2], _ARG_1_ * getElementMatrix(_ARG_0_)[1][3] + _ARG_2_ * getElementMatrix(_ARG_0_)[2][3] + _ARG_3_ * getElementMatrix(_ARG_0_)[3][3] + getElementMatrix(_ARG_0_)[4][3]
end
function renderTrashTooltip()
  drawTooltip("Az #598ed7[E] #ffffffgombot megnyomásával #acd373megfoghatod#ffffff a kukát.")
end
function drawTooltip(_ARG_0_)
  dxDrawRectangle(_UPVALUE0_ / 2 - 250, _UPVALUE1_ - 122, 500, 50, tocolor(0, 0, 0, 150))
  dxDrawRectangle(_UPVALUE0_ / 2 - 250, _UPVALUE1_ - 72, 500, 2, tocolor(124, 197, 118))
  dxDrawText(_ARG_0_, _UPVALUE0_ / 2 - 250, _UPVALUE1_ - 122, _UPVALUE0_ / 2 - 250 + 500, _UPVALUE1_ - 72, tocolor(255, 255, 255, 255), 1, _UPVALUE2_, "center", "center", false, false, true, true, true)
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(_ARG_0_)
  if _UPVALUE0_[_ARG_0_] and _UPVALUE0_[_ARG_0_] >= 25 then
    exports.v2_hud:showInfobox("w", "Tele van a kukásautód! Vidd el kiüríteni!")
  end
end)
addEventHandler("onClientElementDataChange", getRootElement(), function(_ARG_0_)
  if source == localPlayer and _ARG_0_ == "carryingTrash" and getElementData(localPlayer, "carryingTrash") then
    addEventHandler("onClientRender", getRootElement(), processTrashRemove)
    _UPVALUE0_ = true
  else
  end
  if source == localPlayer and _ARG_0_ == "attachedToTrashtruck" then
    if getElementData(localPlayer, "attachedToTrashtruck") then
      setCameraClip(true, false)
    else
      setCameraClip(true, true)
    end
  end
  if _ARG_0_ == "outOfTrash" then
    if getElementData(source, "outOfTrash") then
      _UPVALUE1_[source] = tostring(getElementData(source, "outOfTrash"))
    else
      _UPVALUE1_[source] = nil
    end
    processEffect(source)
  end
  if _ARG_0_ == "loadedTrashes" then
    _UPVALUE2_[source] = getElementData(source, "loadedTrashes")
    if _UPVALUE2_[source] >= 25 and source == getPedOccupiedVehicle(localPlayer) then
      exports.v2_hud:showInfobox("w", "Tele van a kukásautód! Vidd el kiüríteni!")
    end
  end
  if _ARG_0_ == "insectPlayers" then
    if isElement(_UPVALUE3_[source]) then
      destroyElement(_UPVALUE3_[source])
    end
    if getElementData(source, _ARG_0_) then
      _UPVALUE3_[source] = createEffect("insects", 0, 0, 0)
      setEffectDensity(_UPVALUE3_[source], 2)
    else
      _UPVALUE3_[source] = nil
    end
  end
  if _ARG_0_ == "char.Job" and source == localPlayer then
    onJob()
  end
end)
addEventHandler("onClientRender", getRootElement(), function()
  for _FORV_3_, _FORV_4_ in pairs(_UPVALUE0_) do
    if not isElement(_FORV_3_) then
      if isElement(_FORV_4_) then
        destroyElement(_FORV_4_)
      end
      _UPVALUE0_[_FORV_3_] = nil
      return
    end
    setElementPosition(_FORV_4_, getElementPosition(_FORV_3_))
  end
end)
addEventHandler("onClientResourceStart", getResourceRootElement(), function(_ARG_0_)
  for _FORV_4_, _FORV_5_ in ipairs(getElementsByType("vehicle")) do
    if getElementData(_FORV_5_, "loadedTrashes") then
      _UPVALUE0_[_FORV_5_] = getElementData(_FORV_5_, "loadedTrashes")
    end
  end
  for _FORV_4_, _FORV_5_ in ipairs(getElementsByType("player")) do
    if isElement(_UPVALUE1_[_FORV_5_]) then
      destroyElement(_UPVALUE1_[_FORV_5_])
    end
    if getElementData(_FORV_5_, "insectPlayers") then
      _UPVALUE1_[_FORV_5_] = createEffect("insects", 0, 0, 0)
      setEffectDensity(_UPVALUE1_[_FORV_5_], 2)
    else
      _UPVALUE1_[_FORV_5_] = nil
    end
  end
  onJob()
end)
function processEffect(_ARG_0_)
  if isElement(_UPVALUE0_[_ARG_0_]) then
    destroyElement(_UPVALUE0_[_ARG_0_])
  end
  if isElement(_UPVALUE1_[_ARG_0_]) then
    destroyElement(_UPVALUE1_[_ARG_0_])
  end
  if _UPVALUE2_[_ARG_0_] ~= "true" and not getElementAttachedTo(_ARG_0_) and _UPVALUE3_ then
    _UPVALUE1_[_ARG_0_] = createBlip(getElementPosition(_ARG_0_))
  end
end
function renderTrashes()
  for _FORV_6_, _FORV_7_ in pairs(_UPVALUE0_) do
    if isElement(_FORV_6_) then
      if isElementStreamedIn(_FORV_6_) and getDistanceBetweenPoints2D(getElementPosition(_FORV_6_)) <= _UPVALUE1_ and getScreenFromWorldPosition(getElementPosition(_FORV_6_)) and getScreenFromWorldPosition(getElementPosition(_FORV_6_)) then
        if _FORV_7_ == "true" then
        else
        end
        dxDrawImage(getScreenFromWorldPosition(getElementPosition(_FORV_6_)) - 128 / (getScreenFromWorldPosition(getElementPosition(_FORV_6_)) / 3.5), getScreenFromWorldPosition(getElementPosition(_FORV_6_)) - 128 / (getScreenFromWorldPosition(getElementPosition(_FORV_6_)) / 3.5), 256 / (getScreenFromWorldPosition(getElementPosition(_FORV_6_)) / 3.5), 256 / (getScreenFromWorldPosition(getElementPosition(_FORV_6_)) / 3.5), "files/trash.png", 0, 0, 0, (tocolor(124, 197, 118, 255 * (_UPVALUE1_ - getDistanceBetweenPoints2D(getElementPosition(_FORV_6_))) / _UPVALUE1_)))
      end
    else
      _UPVALUE0_[_FORV_6_] = nil
    end
  end
end
function getElementSpeed(_ARG_0_, _ARG_1_)
  assert(isElement(_ARG_0_), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(_ARG_0_) .. ")")
  assert(getElementType(_ARG_0_) == "player" or getElementType(_ARG_0_) == "ped" or getElementType(_ARG_0_) == "object" or getElementType(_ARG_0_) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(_ARG_0_) .. ")")
  assert((_ARG_1_ == nil or type(_ARG_1_) == "string" or type(_ARG_1_) == "number") and (_ARG_1_ == nil or tonumber(_ARG_1_) and (tonumber(_ARG_1_) == 0 or tonumber(_ARG_1_) == 1 or tonumber(_ARG_1_) == 2) or _ARG_1_ == "m/s" or _ARG_1_ == "km/h" or _ARG_1_ == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
  _ARG_1_ = _ARG_1_ == nil and 0 or tonumber(_ARG_1_)
  return (Vector3(getElementVelocity(_ARG_0_)) * ((_ARG_1_ == 0 or _ARG_1_ == "m/s") and 50 or (_ARG_1_ == 1 or _ARG_1_ == "km/h") and 180 or 111.84681456)).length
end
function getPositionFromElementOffset(_ARG_0_, _ARG_1_, _ARG_2_, _ARG_3_)
  return _ARG_1_ * _ARG_0_[1][1] + _ARG_2_ * _ARG_0_[2][1] + _ARG_3_ * _ARG_0_[3][1] + _ARG_0_[4][1], _ARG_1_ * _ARG_0_[1][2] + _ARG_2_ * _ARG_0_[2][2] + _ARG_3_ * _ARG_0_[3][2] + _ARG_0_[4][2], _ARG_1_ * _ARG_0_[1][3] + _ARG_2_ * _ARG_0_[2][3] + _ARG_3_ * _ARG_0_[3][3] + _ARG_0_[4][3]
end
function checkWhenOnTrashVehBack()
  if not _UPVALUE0_ and not _UPVALUE1_ then
    for _FORV_7_ = 1, #getElementsByType("vehicle", getRootElement(), true) do
      if getElementModel(getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]) == 408 then
        if getDistanceBetweenPoints3D(getVehicleComponentPosition(getElementsByType("vehicle", getRootElement(), true)[_FORV_7_], "bump_rear_dummy", "world")) < 3 and getElementSpeed(getElementsByType("vehicle", getRootElement(), true)[_FORV_7_], 0) <= 0.1 then
          if getElementAttachedTo(localPlayer) == getElementsByType("vehicle", getRootElement(), true)[_FORV_7_] then
            drawTooltip("Az #598ed7[E] #ffffffgombot megnyomásával #acd373leszállhatsz#ffffff a kocsiról.")
            return
          end
          if not _UPVALUE2_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]] then
            _UPVALUE2_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]] = getElementMatrix(getElementsByType("vehicle", getRootElement(), true)[_FORV_7_])
            _UPVALUE3_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]] = createColSphere(getVehicleComponentPosition(getElementsByType("vehicle", getRootElement(), true)[_FORV_7_], "bump_rear_dummy", "world"))
          end
          if getDistanceBetweenPoints3D(getPositionFromElementOffset(_UPVALUE2_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]], -1, -5.25, -0.1)) < 1.25 then
            _UPVALUE4_ = {
              getElementsByType("vehicle", getRootElement(), true)[_FORV_7_],
              -1
            }
            drawTooltip("Az #598ed7[E] #ffffffgombot megnyomásával #acd373felszállhatsz#ffffff a kocsira.")
            return
          end
          if getDistanceBetweenPoints3D(getPositionFromElementOffset(_UPVALUE2_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]], 1, -5.25, -0.1)) < 1.25 then
            _UPVALUE4_ = {
              getElementsByType("vehicle", getRootElement(), true)[_FORV_7_],
              1
            }
            drawTooltip("Az #598ed7[E] #ffffffgombot megnyomásával #acd373felszállhatsz#ffffff a kocsira.")
            return
          end
        else
          _UPVALUE2_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]] = nil
          if isElement(_UPVALUE3_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]]) then
            destroyElement(_UPVALUE3_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]])
          end
          _UPVALUE4_ = false
          _UPVALUE3_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]] = nil
        end
      end
    end
  end
end
function attachToTruck()
  if not _UPVALUE0_ and _UPVALUE1_ then
    if getElementData(localPlayer, "attachedToTrashtruck") then
      if getElementSpeed(getElementData(localPlayer, "attachedToTrashtruck")[1], 0) <= 0.1 then
        triggerServerEvent("removePlayerFromTruck", localPlayer)
      end
    elseif _UPVALUE2_ and not _UPVALUE3_ then
      triggerServerEvent("attachThePlayerToTruck", localPlayer, _UPVALUE2_[1], _UPVALUE2_[2], getElementDistanceFromCentreOfMassToBaseOfModel(localPlayer))
    end
  end
end
bindKey("e", "down", attachToTruck)
addEventHandler("onClientRender", getRootElement(), renderTrashes)
addEventHandler("onClientRender", getRootElement(), checkWhenOnTrashVehBack)
function onJob()
  removeEventHandler("onClientRender", getRootElement(), renderTrashes)
  removeEventHandler("onClientRender", getRootElement(), checkWhenOnTrashVehBack)
  _UPVALUE0_ = false
  if getElementData(localPlayer, "char.Job") == 6 then
    _UPVALUE0_ = true
  end
  for _FORV_3_, _FORV_4_ in pairs(_UPVALUE1_) do
    if isElement(_FORV_4_) then
      destroyElement(_FORV_4_)
    end
  end
  if isElement(_UPVALUE2_) then
    destroyElement(_UPVALUE2_)
  end
  if isElement(_UPVALUE3_) then
    destroyElement(_UPVALUE3_)
  end
  _UPVALUE1_ = {}
  if _UPVALUE0_ then
    for _FORV_3_, _FORV_4_ in ipairs(getElementsByType("object")) do
      if getElementData(_FORV_4_, "outOfTrash") then
        _UPVALUE4_[_FORV_4_] = tostring((getElementData(_FORV_4_, "outOfTrash")))
        processEffect(_FORV_4_)
      end
    end
    _UPVALUE2_ = createBlip(2432.87109375, -2119.8564453125, 13.546875, 56, 2, 124, 197, 118)
    _UPVALUE3_ = createBlip(-2099.5380859375, 299.98828125, 35.263687133789, 56, 2, 124, 197, 118)
    setElementData(_UPVALUE2_, "tooltipText", "Kukásautó ürítése")
    setElementData(_UPVALUE3_, "tooltipText", "Kukásautó ürítése")
    addEventHandler("onClientRender", getRootElement(), checkWhenOnTrashVehBack)
    addEventHandler("onClientRender", getRootElement(), renderTrashes)
  end
end
function getTrashAttached(_ARG_0_)
  for _FORV_6_ = 1, #getAttachedElements(_ARG_0_) do
  end
  if _UPVALUE0_[_ARG_0_] then
    for _FORV_8_ = 1, #getElementsWithinColShape(_UPVALUE0_[_ARG_0_], "object") do
    end
  end
  return 0 + 1 + (getElementAttachedTo(getElementsWithinColShape(_UPVALUE0_[_ARG_0_], "object")[_FORV_8_]) or 0 + 1)
end
function processTrashRemove()
  if _UPVALUE0_ and _UPVALUE1_ then
    for _FORV_7_ = 1, #getElementsByType("vehicle", getRootElement(), true) do
      if getElementModel(getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]) == 408 and getDistanceBetweenPoints3D(getVehicleComponentPosition(getElementsByType("vehicle", getRootElement(), true)[_FORV_7_], "bump_rear_dummy", "world")) < 1.25 and 1 > getTrashAttached(getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]) then
        if (_UPVALUE2_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]] or 0) >= 25 then
          drawTooltip("Az autó kapacitása: #acd37325/25#ffffff kuka\nAz autó tele van.")
          return
        else
          drawTooltip("Az autó kapacitása: #acd373" .. (_UPVALUE2_[getElementsByType("vehicle", getRootElement(), true)[_FORV_7_]] or 0) .. "/25#ffffff kuka\nAz #598ed7[E] #ffffffgombot megnyomásával #acd373kiürítheted#ffffff a kukádat.")
        end
        if getKeyState("e") then
          _UPVALUE0_ = false
          removeEventHandler("onClientRender", getRootElement(), processTrashRemove)
          triggerServerEvent("removeTheTrash", localPlayer, getElementsByType("vehicle", getRootElement(), true)[_FORV_7_])
          break
        end
      end
    end
  end
end
function attachTheTrash()
  if _UPVALUE0_ and _UPVALUE1_ then
    triggerServerEvent("attachTheTrash", localPlayer, _UPVALUE0_)
  end
end
addEvent("trashMechaSound", true)
addEventHandler("trashMechaSound", getRootElement(), function()
  attachElements(playSound3D("files/trashmecha.mp3", 0, 0, 0), source)
  setSoundMaxDistance(playSound3D("files/trashmecha.mp3", 0, 0, 0), 100)
  _UPVALUE0_[source] = playSound3D("files/trashmecha.mp3", 0, 0, 0)
end)
addEventHandler("onClientElementDestroy", getRootElement(), function()
  if isElement(_UPVALUE0_[source]) then
    destroyElement(_UPVALUE0_[source])
  end
  _UPVALUE0_[source] = nil
  if isElement(_UPVALUE1_[source]) then
    destroyElement(_UPVALUE1_[source])
  end
  _UPVALUE1_[source] = nil
  if isElement(_UPVALUE2_[source]) then
    destroyElement(_UPVALUE2_[source])
  end
  _UPVALUE2_[source] = nil
end)
