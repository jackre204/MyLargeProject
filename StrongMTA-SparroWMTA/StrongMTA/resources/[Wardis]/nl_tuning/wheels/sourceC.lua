local vehicle_wheels = {}
local reflection_texture
local wheel_dummys = {"wheel_lf_dummy","wheel_rf_dummy","wheel_lb_dummy","wheel_rb_dummy"}

addEventHandler("onClientPreRender",root,
	function()
		if getElementData(localPlayer,"loggedIn") then
			for vehicle,data in pairs(vehicle_wheels) do
				if vehicle_wheels[vehicle] then
					local frontWheels = getElementData(vehicle,"danihe->vehicles->wheelsFront")
					local backWheels = getElementData(vehicle,"danihe->vehicles->wheelsBack")
					for k,v in ipairs(wheel_dummys) do
						if isElement(vehicle_wheels[vehicle][v].object) then --// Van-e egyedi felni object
							local x,y,z = getVehicleComponentPosition(vehicle,v,"parent")

							local rx,ry,rz = getVehicleComponentRotation(vehicle,v,"world")

							local int,dim = getElementInterior(vehicle),getElementDimension(vehicle)
							setElementInterior(vehicle_wheels[vehicle][v].object,int)
							setElementDimension(vehicle_wheels[vehicle][v].object,dim)

							if k < 3 then --// Első felnik
								local offset = frontWheels["offset"]
								if string.find(v,"wheel_l") then --// Bal oldali felnik
									x,y,z = getPositionFromElementOffset(vehicle,x+0.05-(offset/10),y,z)
								else
									x,y,z = getPositionFromElementOffset(vehicle,x-0.05+(offset/10),y,z)
								end
								setElementPosition(vehicle_wheels[vehicle][v].object,x,y,z)

								setElementRotation(vehicle_wheels[vehicle][v].object,rx,ry-frontWheels["angle"],rz,"ZYX")
								setObjectScale(vehicle_wheels[vehicle][v].object,frontWheels["width"],getVehicleWheelSize(vehicle),getVehicleWheelSize(vehicle))
								
								dxSetShaderValue(vehicle_wheels[vehicle][v].shader,"sColor",frontWheels["color"][1]/255,frontWheels["color"][2]/255,frontWheels["color"][3]/255,255/255)

								setVehicleComponentVisible(vehicle,"wheel_lf_dummy",false)
								setVehicleComponentVisible(vehicle,"wheel_rf_dummy",false)
							else --// Hátsó felnik
								local offset = backWheels["offset"]
								if string.find(v,"wheel_l") then --// Bal oldali felnik
									x,y,z = getPositionFromElementOffset(vehicle,x+0.05-(offset/10),y,z)
								else
									x,y,z = getPositionFromElementOffset(vehicle,x-0.05+(offset/10),y,z)
								end
								setElementPosition(vehicle_wheels[vehicle][v].object,x,y,z)

								setElementRotation(vehicle_wheels[vehicle][v].object,rx,ry-backWheels["angle"],rz,"ZYX")
								setObjectScale(vehicle_wheels[vehicle][v].object,backWheels["width"],getVehicleWheelSize(vehicle),getVehicleWheelSize(vehicle))
								
								dxSetShaderValue(vehicle_wheels[vehicle][v].shader,"sColor",backWheels["color"][1]/255,backWheels["color"][2]/255,backWheels["color"][3]/255,255/255)

								setVehicleComponentVisible(vehicle,"wheel_lb_dummy",false)
								setVehicleComponentVisible(vehicle,"wheel_rb_dummy",false)
							end
						end
					end
				end
			end
		end
	end
)

function addCustomWheels(vehicle)
	if vehicle then
		if isElementStreamedIn(vehicle) then
			if not vehicle_wheels[vehicle] then
				local frontWheels = getElementData(vehicle,"danihe->vehicles->wheelsFront") or {id=0,width=1,angle=0,color={255,255,255}}
				local backWheels = getElementData(vehicle,"danihe->vehicles->wheelsBack") or {id=0,width=1,angle=0,color={255,255,255}}
				vehicle_wheels[vehicle] = {
					wheel_lf_dummy = {},
					wheel_rf_dummy = {},
					wheel_lb_dummy = {},
					wheel_rb_dummy = {},
				}
				if frontWheels["id"] > 0 then
					vehicle_wheels[vehicle]["wheel_lf_dummy"] = {
						object = createObject(wheels[frontWheels["id"]].id,0,0,0),
						shader = dxCreateShader("shaders/wheels.fx",0,0,false),
					}
					setElementCollisionsEnabled(vehicle_wheels[vehicle]["wheel_lf_dummy"].object,false)
					dxSetShaderValue(vehicle_wheels[vehicle]["wheel_lf_dummy"].shader,"sReflectionTexture",reflection_texture)
					

					engineApplyShaderToWorldTexture(vehicle_wheels[vehicle]["wheel_lf_dummy"].shader,wheels[frontWheels["id"]].texture,vehicle_wheels[vehicle]["wheel_lf_dummy"].object)


					vehicle_wheels[vehicle]["wheel_rf_dummy"] = {
						object = createObject(wheels[frontWheels["id"]].id,0,0,0),
						shader = dxCreateShader("shaders/wheels.fx",0,0,false),
					}
					setElementCollisionsEnabled(vehicle_wheels[vehicle]["wheel_rf_dummy"].object,false)
					dxSetShaderValue(vehicle_wheels[vehicle]["wheel_rf_dummy"].shader,"sReflectionTexture",reflection_texture)
					
					
					engineApplyShaderToWorldTexture(vehicle_wheels[vehicle]["wheel_rf_dummy"].shader,wheels[frontWheels["id"]].texture,vehicle_wheels[vehicle]["wheel_rf_dummy"].object)

					
					setVehicleComponentVisible(vehicle,"wheel_lf_dummy",false)
					setVehicleComponentVisible(vehicle,"wheel_rf_dummy",false)
				else
					setVehicleComponentVisible(vehicle,"wheel_lf_dummy",true)
					setVehicleComponentVisible(vehicle,"wheel_rf_dummy",true)
				end

				if backWheels["id"] > 0 then
					vehicle_wheels[vehicle]["wheel_lb_dummy"] = {
						object = createObject(wheels[backWheels["id"]].id,0,0,0),
						shader = dxCreateShader("shaders/wheels.fx",0,0,false),
					}
					setElementCollisionsEnabled(vehicle_wheels[vehicle]["wheel_lb_dummy"].object,false)
					dxSetShaderValue(vehicle_wheels[vehicle]["wheel_lb_dummy"].shader,"sReflectionTexture",reflection_texture)
					

					engineApplyShaderToWorldTexture(vehicle_wheels[vehicle]["wheel_lb_dummy"].shader,wheels[backWheels["id"]].texture,vehicle_wheels[vehicle]["wheel_lb_dummy"].object)


					vehicle_wheels[vehicle]["wheel_rb_dummy"] = {
						object = createObject(wheels[backWheels["id"]].id,0,0,0),
						shader = dxCreateShader("shaders/wheels.fx",0,0,false),
					}
					setElementCollisionsEnabled(vehicle_wheels[vehicle]["wheel_rb_dummy"].object,false)
					dxSetShaderValue(vehicle_wheels[vehicle]["wheel_rb_dummy"].shader,"sReflectionTexture",reflection_texture)
					

					engineApplyShaderToWorldTexture(vehicle_wheels[vehicle]["wheel_rb_dummy"].shader,wheels[backWheels["id"]].texture,vehicle_wheels[vehicle]["wheel_rb_dummy"].object)


					setVehicleComponentVisible(vehicle,"wheel_lb_dummy",false)
					setVehicleComponentVisible(vehicle,"wheel_rb_dummy",false)
				else
					setVehicleComponentVisible(vehicle,"wheel_lb_dummy",true)
					setVehicleComponentVisible(vehicle,"wheel_rb_dummy",true)
				end
			else
				removeCustomWheels(vehicle)
				addCustomWheels(vehicle)
			end
		end
	end
end


function removeCustomWheels(vehicle)
	if isElement(vehicle) then
		if vehicle_wheels[vehicle] then
			for k,v in ipairs(wheel_dummys) do
				if isElement(vehicle_wheels[vehicle][v].object) then
					destroyElement(vehicle_wheels[vehicle][v].object)
				end
			end
			vehicle_wheels[vehicle] = nil
		end
	end
end

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		reflection_texture = dxCreateTexture("textures/reflection_cubemap.dds", "dxt5")
		for k,v in ipairs(getElementsByType("vehicle")) do
			if getElementData(v,"danihe->vehicles->wheelsFront") or getElementData(v,"danihe->vehicles->wheelsBack") then
				addCustomWheels(v)
			end
		end
	end
)

addEventHandler("onClientElementStreamIn",root,
	function()
		if getElementType(source) == "vehicle" then
			addCustomWheels(source)
		end
	end
)

addEventHandler("onClientElementStreamOut",root,
	function()
		if getElementType(source) == "vehicle" then
			removeCustomWheels(source)
		end
	end
)

addEventHandler("onClientElementDestroy",root,
	function()
		if getElementType(source) == "vehicle" then
			removeCustomWheels(source)
		end
	end
)


addEventHandler("onClientElementDataChange",root,
	function(data,old,new)
		if getElementType(source) == "vehicle" then
			if isElementStreamedIn(source) then
				if data == "danihe->vehicles->wheelsFront" then
					addCustomWheels(source)
				elseif data == "danihe->vehicles->wheelsBack" then
					addCustomWheels(source)
				end
			end
		end
	end
)