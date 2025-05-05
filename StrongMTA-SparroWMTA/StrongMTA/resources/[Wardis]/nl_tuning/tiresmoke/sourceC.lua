local lastTick = getTickCount()
local lastTick2 = getTickCount()
local exhaustTick = getTickCount()
local concreteTypes = {
	[0]=true,[1]=true,[2]=true,[3]=true,
	[4]=true,[5]=true,[7]=true,[8]=true,
	[34]=true,[89]=true,[127]=true,[135]=true,
	[136]=true,[137]=true,[138]=true,[139]=true,
	[144]=true,[165]=true,
}


addEventHandler("onClientRender",root,
	function()
		--if getElementData(localPlayer,"reach->account->loggedin") then
			for _,vehicle in ipairs(getElementsByType("vehicle")) do
				if isElementStreamedIn(vehicle) then
					local vehicle_speed = getElementSpeed(vehicle,2)
					local angle,speed = calculateAngle(vehicle)
					local driver = getVehicleController(vehicle)
					if vehicle_speed > 10 then
						if speed > 0 and driver then
							if angle > 7 and not isVehicleReversing(vehicle) then
								createTiresmokes(vehicle)
							elseif (getPedControlState(driver,"brake_reverse") or getPedControlState(driver,"handbrake")) and not isVehicleReversing(vehicle) then
								createTiresmokes(vehicle)
							end
						end
					else
						if driver then
							local driveType = getVehicleHandling(vehicle)["driveType"]
							if driveType == "rwd" then
								if getPedControlState(driver,"accelerate") and getPedControlState(driver,"brake_reverse") and not getPedControlState(driver,"handbrake") then
									createTiresmokes(vehicle)
								elseif getPedControlState(driver,"accelerate") and isElementFrozen(vehicle) and not getPedControlState(driver,"handbrake") then
									createTiresmokes(vehicle)
								end
							elseif driveType == "fwd" then
								if getPedControlState(driver,"accelerate") and (getPedControlState(driver,"handbrake") or isElementFrozen(vehicle)) and not getPedControlState(driver,"brake_reverse") then
									createTiresmokes(vehicle,"wheel_rf_dummy","wheel_lf_dummy")
								end 
							elseif driveType == "awd" then
								if isElementFrozen(vehicle) and (getPedControlState(driver,"accelerate") and not getPedControlState(driver,"brake_reverse")) then
									createTiresmokes(vehicle,"wheel_rf_dummy","wheel_lf_dummy")
								elseif getPedControlState(driver,"accelerate") and getPedControlState(driver,"brake_reverse") then
									createTiresmokes(vehicle)
								elseif getPedControlState(driver,"accelerate") and getPedControlState(driver,"handbrake") then
									createTiresmokes(vehicle,"wheel_rf_dummy","wheel_lf_dummy")
								end
							end
						end
					end
				end
			end
		--end
	end
)

function createTiresmokes(vehicle,dummy1,dummy2)
	if not dummy1 then dummy1 = "wheel_rb_dummy" end
	if not dummy2 then dummy2 = "wheel_lb_dummy" end

	local size = 1.5
	local lifeTime = math.random(1000,1500)
	local nx,ny,nz = getPositionFromElementOffset(vehicle,0,-3,-0.2)

	local r,g,b = unpack(getElementData(vehicle,"danihe->tuning->tiresmokeRight") or {170,170,170})
	local x,y,z = getVehicleComponentPosition(vehicle,dummy1,"world")
	local surface = getSurfaceVehicleIsOn(vehicle,x,y,z)
	if surface then
		if concreteTypes[surface] then
			z = z - 0.5
			if x and y and z then
				if lastTick+40 < getTickCount() then
					exports.nl_particles:createParticle(x,y,z,nx,ny,nz,"smokes",size,lifeTime,{r,g,b},100)
					lastTick = getTickCount()
				end
			end
		end
	end

	local r,g,b = unpack(getElementData(vehicle,"danihe->tuning->tiresmokeLeft") or {170,170,170})
	local x,y,z = getVehicleComponentPosition(vehicle,dummy2,"world")
	local surface = getSurfaceVehicleIsOn(vehicle,x,y,z)
	if surface then
		if concreteTypes[surface] then
			z = z - 0.5
			if x and y and z then
				if lastTick2+40 < getTickCount() then
					exports.nl_particles:createParticle(x,y,z,nx,ny,nz,"smokes",size,lifeTime,{r,g,b},100)
					lastTick2 = getTickCount()
				end
			end
		end
	end
end


function getSurfaceVehicleIsOn(vehicle,x,y,z)
    if isElement(vehicle) and (isVehicleOnGround(vehicle) or isElementInWater(vehicle)) then
        local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight (x,y,z,x,y,z-4,true,false,false,false,false,false,false,false,nil,true) 
        if hit then
        	return material 
   		end
    end
    return false
end

function isVehicleReversing(theVehicle)
    local getMatrix = getElementMatrix (theVehicle)
    local getVelocity = Vector3 (getElementVelocity(theVehicle))
    local getVectorDirection = (getVelocity.x * getMatrix[2][1]) + (getVelocity.y * getMatrix[2][2]) + (getVelocity.z * getMatrix[2][3]) 
    if (getVectorDirection >= 0) then
        return false
    end
    return true
end

function calculateAngle(vehicle)
	if not isVehicleOnGround(vehicle) then return 0,0 end
	
	local vx,vy,vz = getElementVelocity(vehicle)
	local rx,ry,rz = getElementRotation(vehicle)
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
	local speed = (vx^2 + vy^2 + vz^2)^(0.5)
	local modV = math.sqrt(vx*vx + vy*vy)
	local cosX = (sn*vx + cs*vy)/modV
	
	--if modV <= 0.2 then return 0,0 end
	--if cosX > 0.966 or cosX < 0 then return 0,0 end
	
	return math.deg(math.acos(cosX))*0.5,speed
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end