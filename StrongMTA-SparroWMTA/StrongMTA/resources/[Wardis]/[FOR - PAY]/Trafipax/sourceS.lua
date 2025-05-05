addEvent("syncSpeedCameras", true)
addEventHandler("syncSpeedCameras", getRootElement(),
    function(sourcePlayer, posX, posY, posZ, rotZ)
        if posX and posY and posZ and rotZ then
            local traffiObject = createObject(951, posX, posY, posZ - 1, 0, 0, rotZ)
            setElementData(traffiObject, "isCustomSpeedCam", true)

            setElementData(traffiObject, "player", sourcePlayer)
            
            local traffiCol = createColSphere(posX, posY, posZ, 0.5)
            attachElements(traffiCol, traffiObject, 0, - 0.85, 1)
            setElementData(traffiCol, "speedCamera", traffiObject)

            setElementData(traffiObject, "speedCameraCol", traffiCol)
        end
    end
)

addEvent("removeCamera", true)
addEventHandler("removeCamera", getRootElement(),
    function(sourcePlaye, sourceSpeedCam)
        if sourceSpeedCam and isElement(sourceSpeedCam) then
            local speedCamCol = getElementData(sourceSpeedCam, "speedCameraCol")

            if speedCamCol and isElement(speedCamCol) then 
                destroyElement(speedCamCol)
            end

            destroyElement(sourceSpeedCam)
        end
    end
)

addEvent("speedCameraFine", true)
addEventHandler("speedCameraFine", getRootElement(),
    function(vehController, vehSpeed, speedLimit, occupantCount)
        if occupantCount and occupantCount > 1 then
            beltPayTax = occupantCount * 50
        end

        local vehSpeed = 200
        if vehController and vehSpeed and speedLimit then
            local speedTicket = math.ceil((math.floor(vehSpeed * 10) / 10 - speedLimit) * 5) * 5
            
            setElementData(vehController, serverDatas.money, getElementData(vehController, serverDatas.money) - speedTicket)
            
            if beltPayTax then
                triggerClientEvent(vehController, "speedAlertFromServer", vehController, vehSpeed, speedLimit, formatNumber(speedTicket), occupantCount)
                setElementData(vehController, serverDatas.money, getElementData(vehController, serverDatas.money) - beltPayTax)
            else
                triggerClientEvent(vehController, "speedAlertFromServer", vehController, vehSpeed, speedLimit, formatNumber(speedTicket))
            end
        end
    end
)


function formatNumber(amount) 
    local formatted = amount 
    while true do   
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') 
      if (k==0) then 
        break 
      end 
    end 
    return formatted 
  end 