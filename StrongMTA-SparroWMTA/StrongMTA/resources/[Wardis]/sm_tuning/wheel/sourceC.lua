wheels = { --[id] = {id=objectid,texture=shadername}
	[1] = {id=1082,texture="te37"},
	[2] = {id=1077,texture="hamman_editrace"},
	[3] = {id=1079,texture="gram_t57"},
	[4] = {id=1075,texture="enkei_nt03"},
	[5] = {id=1081,texture="advan_rgii"},
	[6] = {id=1073,texture="wed_105"},
	[7] = {id=1098,texture="crkai"},
	[8] = {id=1096,texture="advan_racingv2"},
	[9] = {id=1025,texture="rota_tarmac3"},
	[10] = {id=1085,texture="wed_sa97"},
	[11] = {id=1080,texture="boyd_slayer"},
	[12] = {id=1078,texture="dub_president"},
	[13] = {id=1076,texture="dub_president"},
	[14] = {id=1074,texture="zen_dynm"},
	[15] = {id=1097,texture="gram_t57"},
	[16] = {id=932,texture="vs_kf"},
	[17] = {id=1369,texture="emzone_aliumas"},
	[18] = {id=3933,texture="g07bw"},
	[19] = {id=18005,texture="emzone_aliumas"},
	[20] = {id=18003,texture="b5"},
	[21] = {id=14725,texture="emzone_aliumas"},
	[22] = {id=14724,texture="vce"},
	[23] = {id=14723,texture="ssrp"},
	[24] = {id=14722,texture="borbeta"},
	[25] = {id=14727,texture="bbs_cm"},
	[26] = {id=14726,texture="blq"},
	[27] = {id=14715,texture="bbs_lm"},
	[28] = {id=16208,texture="grey2"},
	[29] = {id=16094,texture="advan_rg_ii"},
	[30] = {id=16649,texture="grey2"},  
	[31] = {id=16643,texture="grey2"}, 
	[32] = {id=16653,texture="grey2"}, 
	[33] = {id=16648,texture="grey2"}, 
	[34] = {id=16647,texture="grey2"}, 
	[35] = {id=16641,texture="grey2"}, 
	[36] = {id=3401,texture="grey2"},
	[37] = {id=3400,texture="rota_p45r_deaddrftr"},
	[38] = {id=16681,texture="grey2"}, 
	[39] = {id=16664,texture="bbsrs"}, 
	[40] = {id=16682,texture="panasport"}, 
	[41] = {id=16665,texture="grey2"}, 
	[42] = {id=16663,texture="te37tta"}, 
	[43] = {id=16203,texture="vs_kf"},
	[44] = {id=16656,texture="grey2"},
	[45] = {id=16651,texture="wed_105"},
	[46] = {id=16650,texture="wed_105"},
}

defualt_size = 0.7
wheel_size = {
	[540] = 0.8, -- BMW M4
	[579] = 0.94, -- Mercedes-Benz G63
	[518] = 0.79, -- Nissan 370z Nismo
}

function getVehicleWheelSize(vehicle)
	if isElement(vehicle) then
		if wheel_size[getElementModel(vehicle)] then
			return wheel_size[getElementModel(vehicle)]
		else
			return defualt_size
		end
	end
end

local vehicle_wheels = {}
local reflection_texture
local wheel_dummys = {"wheel_lf_dummy","wheel_rf_dummy","wheel_lb_dummy","wheel_rb_dummy"}

addEventHandler("onClientPreRender",root,
	function()
		if getElementData(localPlayer,"loggedIn") then
			for vehicle,data in pairs(vehicle_wheels) do
				if vehicle_wheels[vehicle] then
					local frontWheels = getElementData(vehicle,"vehicle.tuning.frontWheel")
					local backWheels = getElementData(vehicle,"vehicle.tuning.backWheel")
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
				local frontWheels = getElementData(vehicle,"vehicle.tuning.frontWheel") or {id=0,width=1,angle=0,color={255,255,255}}
				local backWheels = getElementData(vehicle,"vehicle.tuning.backWheel") or {id=0,width=1,angle=0,color={255,255,255}}
				
				vehicle_wheels[vehicle] = {
					wheel_lf_dummy = {},
					wheel_rf_dummy = {},
					wheel_lb_dummy = {},
					wheel_rb_dummy = {},
				}

				if frontWheels["id"] > 0 then
					vehicle_wheels[vehicle]["wheel_lf_dummy"] = {
						object = createObject(wheels[frontWheels["id"]].id,0,0,0),
						shader = dxCreateShader("assets/wheels.fx",0,0,false),
					}
					setElementCollisionsEnabled(vehicle_wheels[vehicle]["wheel_lf_dummy"].object,false)
					dxSetShaderValue(vehicle_wheels[vehicle]["wheel_lf_dummy"].shader,"sReflectionTexture",reflection_texture)
					

					engineApplyShaderToWorldTexture(vehicle_wheels[vehicle]["wheel_lf_dummy"].shader,wheels[frontWheels["id"]].texture,vehicle_wheels[vehicle]["wheel_lf_dummy"].object)


					vehicle_wheels[vehicle]["wheel_rf_dummy"] = {
						object = createObject(wheels[frontWheels["id"]].id,0,0,0),
						shader = dxCreateShader("assets/wheels.fx",0,0,false),
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
						shader = dxCreateShader("assets/wheels.fx",0,0,false),
					}
					setElementCollisionsEnabled(vehicle_wheels[vehicle]["wheel_lb_dummy"].object,false)
					dxSetShaderValue(vehicle_wheels[vehicle]["wheel_lb_dummy"].shader,"sReflectionTexture",reflection_texture)
					

					engineApplyShaderToWorldTexture(vehicle_wheels[vehicle]["wheel_lb_dummy"].shader,wheels[backWheels["id"]].texture,vehicle_wheels[vehicle]["wheel_lb_dummy"].object)


					vehicle_wheels[vehicle]["wheel_rb_dummy"] = {
						object = createObject(wheels[backWheels["id"]].id,0,0,0),
						shader = dxCreateShader("assets/wheels.fx",0,0,false),
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
		reflection_texture = dxCreateTexture("assets/reflection_cubemap.dds", "dxt5")
		for k,v in ipairs(getElementsByType("vehicle"), getRootElement(), true) do
			if getElementData(v,"vehicle.tuning.frontWheel") or getElementData(v,"vehicle.tuning.backWheel") then
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
				if data == "vehicle.tuning.frontWheel" then
					addCustomWheels(source)
				elseif data == "vehicle.tuning.backWheel" then
					addCustomWheels(source)
				end
			end
		end
	end
)


function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end