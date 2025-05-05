local lastTick = getTickCount()
local s = {guiGetScreenSize()}

fonts = {}
fonts["default_10"] = dxCreateFont("fonts/roboto.ttf",10)
fonts["default_11"] = dxCreateFont("fonts/roboto.ttf",11)
fonts["default_bold_10"] = dxCreateFont("fonts/roboto_bold.ttf",10)
fonts["default_bold_11"] = dxCreateFont("fonts/roboto_bold.ttf",11)
fonts["bebasnue_14"] = dxCreateFont("fonts/bebasnue.ttf",14)
fonts["fontawsome_10"] = dxCreateFont("fonts/fontawesome.otf",10)
fonts["fontawsome_15"] = dxCreateFont("fonts/fontawesome.otf",15)
fonts["fontawsome_18"] = dxCreateFont("fonts/fontawesome.otf",18)
fonts["fontawsome_22"] = dxCreateFont("fonts/fontawesome.otf",22)
fonts["fontawsome_25"] = dxCreateFont("fonts/fontawesome.otf",25)


local box_size = 100
local size = {s[1],170}
local pos = {0,s[2]-size[2]}
local loopedTable = tuning_options
local tuning = false
function isTuningActive()
	return tuning
end
local enteredTuning = 0
local enteredVehicle = getPedOccupiedVehicle(localPlayer)
local cameraSettings = {}
local mouseTable = {
	["speed"] = {0, 0},
	["last"] = {0, 0},
	["move"] = {0, 0}
}
local hovered = 1
local scroll = 0
local storedTuning = false
local compatibleUpgrades = {}
local category = 0
local sub_category = 0
local sub_sub_category = 0
local upgrade = {
	["state"] = false,
	["text"] = "",
	["tick"] = getTickCount(),
	["sound"] = "",
	["soundElement"] = nil,
}
local promptbox = {
	["state"] = false,
	["text"] = "",
	["priceText"] = "",
	["tick"] = getTickCount(),
	["selected"] = 1,
	["select_tick"] = getTickCount(),
}
local stickerSelect = false

local hoverTick = getTickCount()-500000

local old_categorys = false

local plate_text = ""
local plate_selected = false

--// Ideiglenes
if enteredVehicle then
	setElementFrozen(enteredVehicle,false)
	--setElementData(localPlayer,"reach->settings->showInterface",true)
	showChat(true)
	showCursor(false)
	setCameraTarget(localPlayer)
	exports.aprp_hud:toggleHUD(true)
end

addEventHandler("onClientRender",root,
	function()
		if stickerSelect then return end
		if upgrade["state"] then
			local animation = interpolateBetween(0.02,0,0,1,0,0,getProgress(timeBySound[upgrade["sound"]],upgrade["tick"]),"Linear")
			local psize = {420,10}
			local ppos = {s[1]/2-psize[1]/2,s[2]/2-psize[2]/2}

			dxDrawRectangle(0,0,s[1],s[2],tocolor(0,0,0,200),true)

			dxDrawCircleRectangle(ppos[1],ppos[2],psize[1],psize[2],tocolor(30,30,30,250),5,true)
			dxDrawCircleRectangle(ppos[1]+1,ppos[2]+1,(psize[1]-2)*animation,psize[2]-2,tocolor(116,179,71,125),4,true)
			dxDrawText(upgrade["text"],ppos[1]+5,ppos[2]-20,nil,nil,tocolor(222,222,222,222),1,fonts["default_bold_10"],"left","top",false,false,true,true)
			dxDrawText(roundNumber(animation*100) .. "%",ppos[1]+psize[1]-5,ppos[2]-20,nil,nil,tocolor(222,222,222,222),1,fonts["default_bold_10"],"right","top",false,false,true,true)

			if animation == 1 then
				upgrade["state"] = false
				if isElement(upgrade["soundElement"]) then
					stopSound(upgrade["soundElement"])
				end
			end
		end
		if promptbox["state"] then
			local alpha = interpolateBetween(0,0,0,1,0,0,getProgress(500,promptbox["tick"]),"Linear")
			local anim_y = interpolateBetween(100,0,0,0,0,0,getProgress(500,promptbox["tick"]),"OutQuad")

			dxDrawRectangle(0,0,s[1],s[2],tocolor(0,0,0,200*alpha),true)

			dxDrawText("Valóban szeretnéd megvásárolni a kiválasztott element a járművedre?",s[1]/2,s[2]/2-100+anim_y,nil,nil,tocolor(222,222,222,222*alpha),1,fonts["default_bold_11"],"center","top",false,false,true,true)
			dxDrawText(promptbox["text"] .. " (" ..  promptbox["priceText"] .. "#b9b9b9)",s[1]/2,s[2]/2-80+anim_y,nil,nil,tocolor(185,185,185,200*alpha),1,fonts["default_10"],"center","top",false,false,true,true)


			dxDrawCircleRectangle(s[1]/2-350/2,s[2]/2-30-30/2+anim_y,350,35,tocolor(116,179,71,150*alpha),9,true)
			dxDrawText("Vásárlás (Enter)",s[1]/2,s[2]/2-30-30/2+30/2+2+anim_y,nil,nil,tocolor(185,185,185,200*alpha),1,fonts["default_bold_10"],"center","center",false,false,true,true)

			dxDrawCircleRectangle(s[1]/2-350/2,s[2]/2+20-30/2+anim_y,350,35,tocolor(214,76,69,150*alpha),9,true)
			dxDrawText("Mégse (Backspace)",s[1]/2,s[2]/2+20-30/2+30/2+2+anim_y,nil,nil,tocolor(185,185,185,200*alpha),1,fonts["default_bold_10"],"center","center",false,false,true,true)
		end
		if tuning then
			local animY = interpolateBetween(size[2],0,0,0,0,0,getProgress(500,lastTick),"InOutQuad")
			boxS = {size[2]-25,size[2]-25}
			size = {s[1],170}
			pos = {80,s[2]-boxS[2]-90+animY}

			logoS = {360*0.9,161*0.9}

			for i = 1,max_box do
				local boxP = {100+(i-1)*(boxS[1]+1.5),s[2]-boxS[2]-90+animY}
				if hovered ~= i then
					dxDrawImage(boxP[1],boxP[2],boxS[1],boxS[2],"textures/stickers/hover.dds",0,0,0,tocolor(255,255,255,35))
				end
			end

			for k,v in ipairs(loopedTable) do
				if k <= max_box then
					local box_id = k+scroll
					local boxP = {100+(k-1)*(boxS[1]+1.5),s[2]-boxS[2]-90+animY}

					if hovered == k then
						local bg_alpha = interpolateBetween(35,0,0,85,0,0,getProgress(300,hoverTick),"OutQuad")
						local hover_alpha = interpolateBetween(0,0,0,1,0,0,getProgress(300,hoverTick),"OutQuad")
						local size_anim = interpolateBetween(0,0,0,15,0,0,getProgress(300,hoverTick),"OutQuad")
						local r,g,b = interpolateBetween(200,200,200,30,30,30,getProgress(300,hoverTick),"OutQuad")
						local icon_alpha = interpolateBetween(200,0,0,175,0,0,getProgress(300,hoverTick),"OutQuad")

						dxDrawImage(boxP[1]-(size_anim/2),boxP[2]-(size_anim/2),boxS[1]+size_anim,boxS[2]+size_anim,"textures/stickers/hover.dds",0,0,0,tocolor(255,255,255,bg_alpha))
						dxDrawImage(boxP[1]+30-(size_anim/2),boxP[2]+30-(size_anim/2),boxS[1]-60+size_anim,boxS[2]-60+size_anim,loopedTable[box_id].icon,0,0,0,tocolor(r,g,b,icon_alpha))
						dxDrawText(loopedTable[box_id].name,boxP[1]+boxS[1]/2,boxP[2]-(size_anim/2)+10,nil,nil,tocolor(30,30,30,175),1,fonts["default_10"],"center",nil,false,false,false,true)
						dxDrawImage(boxP[1]-size_anim,boxP[2]-size_anim,boxS[1]+(size_anim*2),boxS[2]+(size_anim*2),"textures/hover.dds",0,0,0,tocolor(240,240,240,255*hover_alpha))
					else
						if loopedTable[box_id].icon then
							dxDrawImage(boxP[1]+30,boxP[2]+30,boxS[1]-60,boxS[2]-60,loopedTable[box_id].icon,0,0,0,tocolor(200,200,200,200))
						end
						dxDrawText(loopedTable[box_id].name,boxP[1]+boxS[1]/2,boxP[2]+10,nil,nil,tocolor(200,200,200,200),1,fonts["default_10"],"center",nil,false,false,false,true)
					end

					--// Leírás
					if loopedTable[box_id].desc and hovered == k then
						local descS = {270,330}
						local descP = {100,s[2]-boxS[2]-90-50-descS[2]}

						dxDrawRectangle(descP[1],descP[2],descS[1],descS[2],tocolor(140,140,140,75))
						dxDrawBorder(descP[1],descP[2],descS[1],descS[2],0.75,tocolor(222,222,222,175))
						dxDrawBorder(descP[1]-0.75,descP[2]-0.75,descS[1]+1.5,descS[2]+1.5,0.75,tocolor(222,222,222,70))
						dxDrawRectangle(descP[1],descP[2],descS[1],35,tocolor(222,222,222,222))
						dxDrawImage(descP[1],descP[2]+35,descS[1],15,"textures/shadow.dds",0,0,0,tocolor(255,255,255,100))
						dxDrawText(string.upper(loopedTable[box_id].name),descP[1]+10,descP[2]+35/2,nil,nil,tocolor(70,70,70,222),1,fonts["bebasnue_14"],"left","center",false,false,false,true)
						dxDrawText(loopedTable[box_id].desc,descP[1]+20,descP[2]+55,descP[1]+20+(descS[1]-40),descP[2]+40+(descS[2]-40),tocolor(200,200,200,222),1,fonts["default_10"],"left","top",true,true,false,false)
					end

					--// Teljesítmény sorok
					if loopedTable[box_id].handling and hovered == k then
						local perf_data = {
							[1] = {text="Végsebesség",handlingData={"maxVelocity"},maxAmount=360.5},
							[2] = {text="Irányítás",handlingData={"tractionMultiplier","tractionLoss"},maxAmount=2.3},
							[3] = {text="Gyorsulás",handlingData={"engineAcceleration"},maxAmount=43.5},
							[4] = {text="Fékezés",handlingData={"brakeDeceleration","brakeBias"},maxAmount=250},
						}
						local descS = {310,#perf_data*40-30}
						local descP = {100,s[2]-boxS[2]-90-50-descS[2]}

						for i,row in ipairs(perf_data) do
							local handlingCount = 0
							for _,h in ipairs(row.handlingData) do
								local vehHandling = getVehicleHandling(enteredVehicle)[h]
								handlingCount = handlingCount + vehHandling
							end

							local installed = tonumber(getElementData(enteredVehicle,loopedTable.data) or 0) + 1

							local handlingWhitout = 0
							if row.handlingData[1] == loopedTable[1].handling[1] or row.handlingData[2] == loopedTable[1].handling[1] then
								handlingWhitout = handlingCount - loopedTable[installed].handling[2]
							end

							dxDrawText(row.text,descP[1],descP[2]-20+(i-1)*40,nil,nil,tocolor(200,200,200,255),1,fonts["default_bold_10"],"left","top")
							local row_width = descS[1]-40
							dxDrawRectangle(descP[1],descP[2]+(i-1)*40,row_width,12,tocolor(200,200,200,30))
							dxDrawBorder(descP[1],descP[2]+(i-1)*40,row_width,12,1.5,tocolor(100,100,100,50))

							if handlingWhitout > 0 then
								if handlingWhitout+loopedTable[box_id].handling[2] > handlingCount then
									dxDrawRectangle(descP[1],descP[2]+(i-1)*40,(row_width/row.maxAmount)*(handlingWhitout+loopedTable[box_id].handling[2]),12,tocolor(116,179,71,255))
									dxDrawRectangle(descP[1],descP[2]+(i-1)*40,(row_width/row.maxAmount)*handlingCount,12,tocolor(200,200,200,255))
								
									local perfNumber = roundNumber((10/row.maxAmount*(handlingWhitout+loopedTable[box_id].handling[2])),1)
									dxDrawCircleRectangle(descP[1]+descS[1]-30,descP[2]+(i-1)*40-30+12,30,30,tocolor(116,179,71,200),5)
									dxDrawText(perfNumber,descP[1]+descS[1]-30/2,descP[2]+(i-1)*40-30+12+31/2,nil,nil,tocolor(30,30,30,222),1,fonts["default_bold_10"],"center","center",false,false,false,true)
								elseif handlingWhitout+loopedTable[box_id].handling[2] < handlingCount then
									dxDrawRectangle(descP[1],descP[2]+(i-1)*40,(row_width/row.maxAmount)*handlingCount,12,tocolor(200,200,200,255))
									local minusWidth = math.abs(((row_width/row.maxAmount)*(handlingWhitout+loopedTable[box_id].handling[2])) - ((row_width/row.maxAmount)*handlingCount))
									dxDrawRectangle(descP[1]+(row_width/row.maxAmount)*handlingCount-minusWidth,descP[2]+(i-1)*40,minusWidth,12,tocolor(214,76,69,255))
								
									local perfNumber = roundNumber((10/row.maxAmount*(handlingWhitout+loopedTable[box_id].handling[2])),1)
									dxDrawCircleRectangle(descP[1]+descS[1]-30,descP[2]+(i-1)*40-30+12,30,30,tocolor(214,76,69,200),5)
									dxDrawText(perfNumber,descP[1]+descS[1]-30/2,descP[2]+(i-1)*40-30+12+31/2,nil,nil,tocolor(30,30,30,222),1,fonts["default_bold_10"],"center","center",false,false,false,true)
								else
									dxDrawRectangle(descP[1],descP[2]+(i-1)*40,(row_width/row.maxAmount)*handlingCount,12,tocolor(200,200,200,255))
							
									local perfNumber = roundNumber((10/row.maxAmount*handlingCount),1)
									dxDrawCircleRectangle(descP[1]+descS[1]-30,descP[2]+(i-1)*40-30+12,30,30,tocolor(200,200,200,200),5)
									dxDrawText(perfNumber,descP[1]+descS[1]-30/2,descP[2]+(i-1)*40-30+12+31/2,nil,nil,tocolor(30,30,30,222),1,fonts["default_bold_10"],"center","center",false,false,false,true)
								end
							else
								dxDrawRectangle(descP[1],descP[2]+(i-1)*40,(row_width/row.maxAmount)*handlingCount,12,tocolor(200,200,200,255))
							
								local perfNumber = roundNumber((10/row.maxAmount*handlingCount),1)
								dxDrawCircleRectangle(descP[1]+descS[1]-30,descP[2]+(i-1)*40-30+12,30,30,tocolor(200,200,200,200),5)
								dxDrawText(perfNumber,descP[1]+descS[1]-30/2,descP[2]+(i-1)*40-30+12+31/2,nil,nil,tocolor(30,30,30,222),1,fonts["default_bold_10"],"center","center",false,false,false,true)
							end
						end
					end


					if loopedTable[box_id].price then
						if loopedTable.data then
							local data = getElementData(enteredVehicle,loopedTable.data) or 0
							data = data + 1
							if data == box_id then
								dxDrawText("Felszerelve",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
							else
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						elseif loopedTable.wheelType then
							if storedTuning["id"] == loopedTable[box_id].wheelID then
								dxDrawText("Felszerelve",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
							else
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						elseif loopedTable[box_id].exhaust_id then
							if storedTuning == loopedTable[box_id].exhaust_id then
								dxDrawText("Felszerelve",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
							else
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						elseif loopedTable.neon then
							if storedTuning == box_id-1 then
								dxDrawText("Felszerelve",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
							else
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						elseif loopedTable.variant then
							if storedTuning == box_id-1 then
								dxDrawText("Felszerelve",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
							else
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						elseif loopedTable[box_id].steer then
							if getVehicleHandling(enteredVehicle)["steeringLock"] == loopedTable[box_id].steer then
								dxDrawText("Felszerelve",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
							else
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						elseif loopedTable[box_id].drivetype then
							if getVehicleHandling(enteredVehicle)["driveType"] == loopedTable[box_id].drivetype then
								dxDrawText("Felszerelve",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
							else
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						elseif loopedTable.upgradeSlot then
							if storedTuning == compatibleUpgrades[box_id-1] then
								dxDrawText("Felszerelve",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
							else
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						else
							if #loopedTable[box_id] == 0 then
								if loopedTable[box_id].price == 0 then
									dxDrawText("Ingyenes",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
								else
									if loopedTable[box_id].priceType == "Money" then
										dxDrawText("#74b347" .. format(loopedTable[box_id].price) .. "FT",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									else
										dxDrawText("#5490c4" .. format(loopedTable[box_id].price) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
									end
								end
							end
						end
					elseif loopedTable[box_id].stickerEditing then
						local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
						dxDrawText("#74b347" .. format(getStickerPrice(stickers[#stickers][5])) .. "NL Coin",boxP[1]+boxS[1]/2,boxP[2]+boxS[2]-10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","bottom",false,false,false,true)
					end		
				end
			end

			local scrollWitdh = max_box*(boxS[1]+1.5)
			dxDrawCircleRectangle(pos[1]+17,pos[2]+boxS[2]+20,scrollWitdh,13,tocolor(155,155,155,100),5)
			if #loopedTable > max_box then
				local visiblefactor = math.min(max_box/#loopedTable, 1.0) 
				local scrollbarSize = (max_box*(boxS[1]+1.5)) * visiblefactor 
				local scrollbarPosition = math.min(scroll / #loopedTable, 1.0 - visiblefactor) * (max_box*(boxS[1]+1.5)) 
				-- Scrollbar
				dxDrawCircleRectangle(pos[1]+17+scrollbarPosition,pos[2]+boxS[2]+20,scrollbarSize,13,tocolor(155,155,155,255),5)
			end

			local vehicle_name = exports.sm_mods_veh:getCustomVehicleNameFromVehicle(enteredVehicle)
			local width = dxGetTextWidth(vehicle_name,1,fonts["default_bold_10"],false)+30
			dxDrawCircleRectangle(pos[1],40,width,30,tocolor(20,20,20,140),5)
			dxDrawText(vehicle_name,pos[1]+width/2,40+30/2,nil,nil,tocolor(200,200,200,200),1,fonts["default_bold_10"],"center","center",false,false,false,true)

			local money = format(getElementData(localPlayer,"char.Money")) .. "Ft"
			local width = dxGetTextWidth(money,1,fonts["default_bold_10"],false)+30
			dxDrawCircleRectangle(s[1]-80-width,40,width,30,tocolor(20,20,20,140),5)
			dxDrawText("#74b347" .. money,s[1]-80-width/2,40+30/2,nil,nil,tocolor(200,200,200,200),1,fonts["default_bold_10"],"center","center",false,false,false,true)

			local pp = format(getElementData(localPlayer,"char.PP")) .. "PP"
			local width = dxGetTextWidth(pp,1,fonts["default_bold_10"],false)+30
			dxDrawCircleRectangle(s[1]-80-width,80,width,30,tocolor(20,20,20,140),5)
			dxDrawText("#5490c4" .. pp,s[1]-80-width/2,80+30/2,nil,nil,tocolor(200,200,200,200),1,fonts["default_bold_10"],"center","center",false,false,false,true)


			dxDrawCircleRectangle(pos[1],pos[2]+boxS[2]/2-60/2,30,60,tocolor(155,155,155,255),5)
			dxDrawText("",pos[1]+30/2,pos[2]+boxS[2]/2,nil,nil,tocolor(30,30,30,175),1,fonts["fontawsome_15"],"center","center",false,false,false,true)

			dxDrawCircleRectangle(pos[1]+((boxS[1]+1.5)*max_box)+5,pos[2]+boxS[2]/2-60/2,30,60,tocolor(155,155,155,255),5)
			dxDrawText("",pos[1]+((boxS[1]+1.5)*max_box)+5+30/2,pos[2]+boxS[2]/2,nil,nil,tocolor(30,30,30,175),1,fonts["fontawsome_15"],"center","center",false,false,false,true)

			--// Színezés
			if loopedTable.paintID then
				if anySliderMoving() then
					local h,s,v = getSliderData(1),getSliderData(2),getSliderData(3)
					local r,g,b = hsvToRgb(h,s,v,1)
					if loopedTable.paintID == 1 then
						setElementData(enteredVehicle,"danihe->vehicles->bodyColor",{r,g,b})
					elseif loopedTable.paintID == 2 then
						local r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(enteredVehicle,true)
						setVehicleColor(enteredVehicle,r1,g1,b1,r,g,b,r3,g3,b3,r4,g4,b4)
					elseif loopedTable.paintID == 3 then
						local r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(enteredVehicle,true)
						setVehicleColor(enteredVehicle,r1,g1,b1,r2,g2,b2,r,g,b,r4,g4,b4)
					elseif loopedTable.paintID == 4 then
						local r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(enteredVehicle,true)
						setVehicleColor(enteredVehicle,r1,g1,b1,r2,g2,b2,r3,g3,b3,r,g,b)
					elseif loopedTable.paintID == 5 then
						setVehicleHeadLightColor(enteredVehicle,r,g,b)
					end
				end
			elseif loopedTable.wheelID then
				local data = getElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType)

				local h,s,v = getSliderData(1),getSliderData(2),getSliderData(3)
				local r,g,b = hsvToRgb(h,s,v,1)
				data.color = {r,g,b}

				data.width = (75+getSliderData(4)*50)/100
				data.angle = getSliderData(5)*10
				data.offset = getSliderData(6)

				if anySliderMoving() then
					setElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType,data)
				end
			elseif loopedTable.tiredata then
				if anySliderMoving() then
					local h,s,v = getSliderData(1),getSliderData(2),getSliderData(3)
					local r,g,b = hsvToRgb(h,s,v,1)
					setElementData(enteredVehicle,"danihe->tuning->tiresmoke" .. loopedTable.tiredata,{r,g,b})
				end
			end

			--// Egyedi rendszám edit box
			if loopedTable.plate then
				dxDrawRectangle(s[1]/2-240/2,pos[2]-60,240,40,tocolor(30,30,30,250))
				dxDrawBorder(s[1]/2-240/2,pos[2]-60,240,40,1.5,tocolor(25,25,25,250))

				if plate_selected then
					local length = dxGetTextWidth(plate_text,1,fonts["default_10"])
					dxDrawRectangle(s[1]/2+length/2+3,pos[2]-60+5,1.5,30,tocolor(222,222,222,222))
				end
				dxDrawText(plate_text,s[1]/2,pos[2]-60+40/2,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"center","center")
			end

			--// Gumifüst amikor állítgatja a színt
			if loopedTable.tiredata then
				createTiresmokes(enteredVehicle)
			end

			--// Matrica szerkeztéshez
			if loopedTable[hovered+scroll].stickerEditing or loopedTable[hovered+scroll].editStickerLive then
				local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
				local ls = #stickers
				if loopedTable[hovered+scroll].editStickerLive then
					ls = storedTuning.id
				end

				--x,y,w,h,stickerDir,stickerId,rotation,color,selected,border,mirrorX,mirrorY = unpack(stickers[#stickers])

				if anySliderMoving() then
					local h,s,v,a = getSliderData(1),getSliderData(2),getSliderData(3),getSliderData(4)
					local r,g,b,a = hsvToRgb(h,s,v,a)
					stickers[ls][8] = tocolor(r,g,b,a)

					stickers[ls][1] = getSliderData(5)*1024
					stickers[ls][2] = getSliderData(6)*1024
					stickers[ls][3] = getSliderData(7)*1024
					stickers[ls][4] = getSliderData(8)*1024
					stickers[ls][7] = getSliderData(9)*360

					local sb = getSliderData(10)
					if sb == 0 then sb = false
					elseif sb == 1 then sb = true end
					stickers[ls][10] = sb

					local sb = getSliderData(11)
					if sb == 0 then sb = false
					elseif sb == 1 then sb = true end
					stickers[ls][11] = sb

					local sb = getSliderData(12)
					if sb == 0 then sb = false
					elseif sb == 1 then sb = true end
					stickers[ls][12] = sb

					setElementData(enteredVehicle,"danihe->vehicles->stickers",stickers)
				end
			end

			if string.find(loopedTable[hovered+scroll].name,"Matrica #") then
				dxDrawText("Törléshez nyomd meg a '[DELETE]' billentyűt!",pos[1]+10+1,pos[2]-30+1,nil,nil,tocolor(0,0,0,100),1,fonts["default_bold_10"],"left","top",false,false,false,true)
				dxDrawText("Törléshez nyomd meg a '[DELETE]' billentyűt!",pos[1]+10-1,pos[2]-30+1,nil,nil,tocolor(0,0,0,100),1,fonts["default_bold_10"],"left","top",false,false,false,true)
				dxDrawText("Törléshez nyomd meg a '[DELETE]' billentyűt!",pos[1]+10+1,pos[2]-30-1,nil,nil,tocolor(0,0,0,100),1,fonts["default_bold_10"],"left","top",false,false,false,true)
				dxDrawText("Törléshez nyomd meg a '[DELETE]' billentyűt!",pos[1]+10-1,pos[2]-30-1,nil,nil,tocolor(0,0,0,100),1,fonts["default_bold_10"],"left","top",false,false,false,true)
				dxDrawText("Törléshez nyomd meg a #d64c45'[DELETE]' billentyűt!",pos[1]+10,pos[2]-30,nil,nil,tocolor(222,222,222,222),1,fonts["default_bold_10"],"left","top",false,false,false,true)
			end
		end
	end
)

addEventHandler("onClientCharacter",root,
	function(key)
		if loopedTable.plate and plate_selected then
			if string.len(plate_text) < 8 then
				plate_text = plate_text .. key
				setElementData(enteredVehicle,"danihe->vehicles->plate",plate_text)
			end
		end
	end
)

addEventHandler("onClientKey",root,
	function(k,p)
		if not tuning or upgrade["state"] then return end

		if k == "mouse1" and p and not stickerSelect then
			if not promptbox["state"] then
				if loopedTable.plate then
					plate_selected = false
					if isCursorOnBox(s[1]/2-240/2,pos[2]-60,240,40) then
						plate_selected = true
					end
				end
			end
		elseif k == "delete" and p and not stickerSelect then
			if not promptbox["state"] then
				if string.find(loopedTable[hovered+scroll].name,"Matrica #") then
					local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
					table.remove(stickers,hovered+scroll)
					table.remove(loopedTable,hovered+scroll)
					setElementData(enteredVehicle,"danihe->vehicles->stickers",stickers)
					hovered = 1
					scroll = 0
					exports.aprp_hud:showInfobox("info","Sikeresen eltávolítottad a kiválasztott matricát!")
				end
			end
		elseif k == "enter" and p and not stickerSelect then 
			if not promptbox["state"] then
				if #loopedTable[hovered+scroll] > 0 then
					if loopedTable[hovered+scroll].wheelID then
						if loopedTable[hovered+scroll].wheelID == storedTuning.id then
							--exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
							--return
						end
					end

					--// Matricázás
					if loopedTable[hovered+scroll].newSticker then
						if exports.nl_vinyls:isVehicleCompatibleWithStickers(enteredVehicle) then
							stickerSelect = true
							toggleStickerBrowser(true)
						else
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, nem kompatibilis a járműveddel.")
							return
						end
					elseif loopedTable[hovered+scroll].listStickers then
						if exports.nl_vinyls:isVehicleCompatibleWithStickers(enteredVehicle) then
							local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
							if #stickers > 0 then
								for k,v in ipairs(stickers) do
									loopedTable[hovered+scroll][k] = {name="Matrica #" .. k,icon=":nl_vinyls/stickers/" .. v[5] .. "/" .. v[6] .. ".dds",price=0,priceType=loopedTable[hovered+scroll].priceType,editSticker=true,
										[1] = {name = "Megvásárlás",icon = "textures/icons/sticker_new.dds",editStickerLive = true},
									}
								end
							else
								exports.aprp_hud:showInfobox("error","Nincs matrica a járműveden")
								return
							end
						else
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, nem kompatibilis a járműveddel.")
							return
						end
					elseif loopedTable[hovered+scroll].editSticker then
						local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
						local x,y,w,h,stickerDir,stickerId,rotation,color,selected,border,mirrorX,mirrorY = unpack(stickers[hovered+scroll])
						local hc,sc,vc,ac = rgbToHsv(255,255,255,255)

						if border then border = 1 else border = 0 end
						if mirrorX then mirrorX = 1 else mirrorX = 0 end
						if mirrorY then mirrorY = 1 else mirrorY = 0 end

						storedTuning = {
							id = hovered+scroll,
							sticker = stickers[hovered+scroll],
						}

						togSliders("sticker",{hc,sc,vc,ac,x/1024,y/1024,w/1024,h/1024,rotation/360,border,mirrorX,mirrorY},true)
					end

					--// Alap gta-s optikai tuningok
					if loopedTable[hovered+scroll].upgradeSlot then
						compatibleUpgrades = getVehicleCompatibleUpgrades(enteredVehicle,loopedTable[hovered+scroll].upgradeSlot)
						compatibleUpgrades[0] = 0
						if #compatibleUpgrades > 0 then
							storedTuning = getVehicleUpgradeOnSlot(enteredVehicle,loopedTable[hovered+scroll].upgradeSlot)
							if storedTuning ~= 0 then
								removeVehicleUpgrade(enteredVehicle,storedTuning)
							end
							loopedTable[hovered+scroll][1] = {name="Gyári",icon=loopedTable[hovered+scroll].icon,price=0,priceType="Money"}
							for newid,upgradeid in ipairs(compatibleUpgrades) do
								loopedTable[hovered+scroll][newid+1] = {name=loopedTable[hovered+scroll].name .. " #" .. newid,icon=loopedTable[hovered+scroll].icon,price=loopedTable[hovered+scroll].price,priceType=loopedTable[hovered+scroll].priceType}
							end
						else
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, nem kompatibilis a járműveddel.")
							return
						end
					end

					if loopedTable[hovered+scroll].plate then
						storedTuning = {style=getElementData(enteredVehicle,"danihe->vehicles->plateStyle") or 1,text=getElementData(enteredVehicle,"danihe->vehicles->plate") or "DANIHE"}
						setElementData(enteredVehicle,"danihe->vehicles->plateStyle",1)
					
						plate_selected = true
						plate_text = storedTuning.text
					end
					--// Neon
					if loopedTable[hovered+scroll].neon then
						storedTuning = getElementData(enteredVehicle,"danihe->vehicles->neon") or 0
						setElementData(enteredVehicle,"danihe->vehicles->neon",0)
					end
					if loopedTable[hovered+scroll].variant then
						storedTuning = getElementData(enteredVehicle,"danihe->vehicles->variant") or 0
						setElementData(enteredVehicle,"danihe->vehicles->variant",0)
					end

					loopedTable = loopedTable[hovered+scroll]
					playSound("sounds/enter.ogg")

					if loopedTable.paintID then
						if loopedTable.paintID == 1 then
							local r,g,b = getElementData(enteredVehicle,"danihe->vehicles->bodyColor")[1],getElementData(enteredVehicle,"danihe->vehicles->bodyColor")[2],getElementData(enteredVehicle,"danihe->vehicles->bodyColor")[3]
							storedTuning = {r,g,b}
							local h,s,v = rgbToHsv(r,g,b,255)
							togSliders("hsv",{h,s,v})
						elseif loopedTable.paintID == 2 then
							local _,_,_,r,g,b = getVehicleColor(enteredVehicle,true)
							storedTuning = {r,g,b}
							local h,s,v = rgbToHsv(r,g,b,255)
							togSliders("hsv",{h,s,v})
						elseif loopedTable.paintID == 3 then
							local _,_,_,_,_,_,r,g,b = getVehicleColor(enteredVehicle,true)
							storedTuning = {r,g,b}
							local h,s,v = rgbToHsv(r,g,b,255)
							togSliders("hsv",{h,s,v})
						elseif loopedTable.paintID == 4 then
							local _,_,_,_,_,_,_,_,_,r,g,b = getVehicleColor(enteredVehicle,true)
							storedTuning = {r,g,b}
							local h,s,v = rgbToHsv(r,g,b,255)
							togSliders("hsv",{h,s,v})
						elseif loopedTable.paintID == 5 then
							local r,g,b = getVehicleHeadLightColor(enteredVehicle)
							storedTuning = {r,g,b}
							local h,s,v = rgbToHsv(r,g,b,255)
							togSliders("hsv",{h,s,v})
						end
					end
					if loopedTable.wheelType and not loopedTable.wheelID then
						storedTuning = getElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType)
						setElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType,{id=0,width=1,angle=0,offset=0.5,color={255,255,255}})
					end
					if loopedTable.wheelID then
						if storedTuning.id == loopedTable.wheelID then
							local r,g,b = unpack(storedTuning.color)
							local h,s,v = rgbToHsv(r,g,b,255)

							setElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType,{id=loopedTable.wheelID,width=storedTuning.width,angle=storedTuning.angle,offset=storedTuning.offset,color=storedTuning.color})

							togSliders("wheel",{h,s,v,storedTuning.width-0.25,storedTuning.angle/10,(storedTuning.offset)})
						else
							togSliders("wheel")
						end
					end
					if loopedTable.tiredata then
						local r,g,b = unpack(getElementData(enteredVehicle,"danihe->tuning->tiresmoke" .. loopedTable.tiredata) or {170,170,170})
						storedTuning = {r,g,b}
						local h,s,v = rgbToHsv(r,g,b,255)
						togSliders("hsv",{h,s,v})
					end

					if loopedTable.cameraSettings then
						local cameraSettings = loopedTable.cameraSettings
					
						if isValidComponent(enteredVehicle, cameraSettings[1]) then
							moveCameraToComponent(cameraSettings[1], cameraSettings[2], cameraSettings[3], cameraSettings[4])
						end
						
						if cameraSettings[5] then
							setVehicleComponentVisible(enteredVehicle, cameraSettings[1], false)
						end
					end
					old_categorys = {hovered,scroll}

					if category == 0 then
						category = hovered+scroll
					else
						if sub_category == 0 then
							sub_category = hovered+scroll
						else
							if sub_sub_category == 0 then
								sub_sub_category = hovered+scroll
							end
						end
					end

					hovered = 1
					scroll = 0
				else --// Megvásárlás
					if loopedTable.data then --// Teljesítmény tuning
						local data = getElementData(enteredVehicle,loopedTable.data) or 0
						data = data + 1
						if data == hovered+scroll then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable[hovered+scroll].delteStickers then --// Matricák törlése
						local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
						if #stickers > 0 then
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						else
							exports.aprp_hud:showInfobox("error","Nincs egyetlen matrica sem a járműveden!")
						end
					elseif loopedTable[hovered+scroll].stickerEditing or loopedTable[hovered+scroll].editStickerLive then --// Matrica Megvásárlás
						promptbox["state"] = true
						promptbox["tick"] = getTickCount()
						promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
						promptbox["selected"] = 1
						promptbox["select_tick"] = getTickCount()
						local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
						promptbox["priceText"] = "#74b347" .. format(getStickerPrice(stickers[#stickers][5])) .. "NL Coin"
						playSound("sounds/prompt.ogg")
						loopedTable[hovered+scroll].price = getStickerPrice(stickers[#stickers][5])
						loopedTable[hovered+scroll].priceType = "PP"
					elseif loopedTable.neon then
						if getElementData(enteredVehicle,"danihe->vehicles->neon") == storedTuning then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable.variant then
						if getElementData(enteredVehicle,"danihe->vehicles->variant") == storedTuning then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable.variant then
						if getElementData(enteredVehicle,"danihe->vehicles->variant") == storedTuning then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable.plate then
						if getElementData(enteredVehicle,"danihe->vehicles->plateStyle") == storedTuning.style and getElementData(enteredVehicle,"danihe->vehicles->plate") == storedTuning.text then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							--promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name .. " (" .. string.upper(core:dxGetEditText("plate")) .. ")"
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name .. " (" .. string.upper(plate_text) .. ")"
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable.tiredata then --// Gumifüst
						local h,s,v = getSliderData(1),getSliderData(2),getSliderData(3)
						local r,g,b = hsvToRgb(h,s,v,1)
						if storedTuning == {r,g,b} then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable[hovered+scroll].steer then --// Fordulókör
						if getVehicleHandling(enteredVehicle)["steeringLock"] == loopedTable[hovered+scroll].steer then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable[hovered+scroll].drivetype then --// Meghajtás
						if getVehicleHandling(enteredVehicle)["driveType"] == loopedTable[hovered+scroll].drivetype then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable.upgradeSlot then --// Sima gta-s optikai tuning
						if storedTuning == compatibleUpgrades[hovered+scroll-1] then
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						else
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						end
					elseif loopedTable[hovered+scroll].exhaust_id then --// Egyedi kipufogó
						if storedTuning ~= loopedTable[hovered+scroll].exhaust_id then
							promptbox["state"] = true
							promptbox["tick"] = getTickCount()
							promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
							promptbox["selected"] = 1
							promptbox["select_tick"] = getTickCount()
							if loopedTable[hovered+scroll].price == 0 then
								promptbox["priceText"] = "Ingyenes"
							else
								if loopedTable[hovered+scroll].priceType == "Money" then
									promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
								else
									promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
								end
							end
							playSound("sounds/prompt.ogg")
						else
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						end
					elseif loopedTable.wheelType then --// Egyedi felni
						if storedTuning["id"] ~= loopedTable[hovered+scroll].wheelID then
							if loopedTable[hovered+scroll].wheelID == 0 then
								promptbox["state"] = true
								promptbox["tick"] = getTickCount()
								promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
								promptbox["selected"] = 1
								promptbox["select_tick"] = getTickCount()
								if loopedTable[hovered+scroll].price == 0 then
									promptbox["priceText"] = "Ingyenes"
								else
									if loopedTable[hovered+scroll].priceType == "Money" then
										promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
									else
										promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
									end
								end
								playSound("sounds/prompt.ogg")
							else
								--if loopedTable.wheelID ~= storedTuning.id then
									promptbox["state"] = true
									promptbox["tick"] = getTickCount()
									promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
									promptbox["selected"] = 1
									promptbox["select_tick"] = getTickCount()
									if loopedTable[hovered+scroll].price == 0 then
										promptbox["priceText"] = "Ingyenes"
									else
										if loopedTable[hovered+scroll].priceType == "Money" then
											promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
										else
											promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
										end
									end
									playSound("sounds/prompt.ogg")
								--else
									--exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
								--end
							end
						else
							exports.aprp_hud:showInfobox("error","A kiválasztott elem, jelenleg is fel van szerelve a járművedre.")
						end
					elseif loopedTable.paintID then --// Festés
						promptbox["state"] = true
						promptbox["tick"] = getTickCount()
						promptbox["text"] = loopedTable.name .. " - " .. loopedTable[hovered+scroll].name
						promptbox["selected"] = 1
						promptbox["select_tick"] = getTickCount()
						if loopedTable[hovered+scroll].price == 0 then
							promptbox["priceText"] = "Ingyenes"
						else
							if loopedTable[hovered+scroll].priceType == "Money" then
								promptbox["priceText"] = "#74b347" .. format(loopedTable[hovered+scroll].price) .. "FT"
							else
								promptbox["priceText"] = "#5490c4" .. format(loopedTable[hovered+scroll].price) .. "NL Coin"
							end
						end
						playSound("sounds/prompt.ogg")
					else
						playSound(":reach_core/sounds/cant.ogg")
					end
				end
			else --// Ha van megerősítő doboz
				local price = loopedTable[hovered+scroll].price
				if getElementData(localPlayer,"char." .. loopedTable[hovered+scroll].priceType) >= price then
					if loopedTable[hovered+scroll].exhaust_id then --// Egyedi kipufogó
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						triggerServerEvent("addCustomExhaust",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType,loopedTable[hovered+scroll].exhaust_id)
						category = 2
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						moveCameraToDefaultPosition()
						compatibleUpgrades = {}
						hovered = 1
						scroll = 0
					elseif loopedTable[hovered+scroll].delteStickers then --// Matricák leszedeése
						toggleUpgradeLine("Matricák eltávolítása..","sounds/paint.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						category = 5
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						moveCameraToDefaultPosition()
						hovered = 1
						scroll = 0
						togSliders()

						setElementData(enteredVehicle,"danihe->vehicles->stickers",{})
					elseif loopedTable[hovered+scroll].stickerEditing or loopedTable[hovered+scroll].editStickerLive then --// Matrica felragasztása
						toggleUpgradeLine("Felragasztás..","sounds/paint.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						category = 5
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						moveCameraToDefaultPosition()
						hovered = 1
						scroll = 0
						togSliders()

						local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
						stickers[#stickers][9] = false
						--print(stickers[#stickers][5] .. " - " .. stickers[#stickers][6])
						triggerServerEvent("removePP",resourceRoot,localPlayer,getStickerPrice(stickers[#stickers][5]))
						setElementData(enteredVehicle,"danihe->vehicles->stickers",stickers)
					elseif loopedTable.neon then --// Neon
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						triggerServerEvent("buyTuning",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType,"danihe->vehicles->neon",hovered+scroll-1)
						category = 4
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						moveCameraToDefaultPosition()
						compatibleUpgrades = {}
						hovered = 1
						scroll = 0
					elseif loopedTable.variant then --// Variáns
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						triggerServerEvent("buyTuning",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType,"danihe->vehicles->variant",hovered+scroll-1)
						category = 4
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						moveCameraToDefaultPosition()
						compatibleUpgrades = {}
						hovered = 1
						scroll = 0
					elseif loopedTable.plate then --// Rendszámtábla
						--triggerServerEvent("tryBuyPlate",resourceRoot,localPlayer,enteredVehicle,storedTuning.text,string.upper(core:dxGetEditText("plate")),hovered+scroll)
						triggerServerEvent("tryBuyPlate",resourceRoot,localPlayer,enteredVehicle,storedTuning.text,string.upper(plate_text),hovered+scroll)
					elseif loopedTable.tiredata then --// Gumifüst
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						local h,s,v = getSliderData(1),getSliderData(2),getSliderData(3)
						local r,g,b = hsvToRgb(h,s,v,1)
						triggerServerEvent("buyTuning",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType,"danihe->tuning->tiresmoke" .. loopedTable.tiredata,{r,g,b})
						
						togSliders()
						category = 4
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						moveCameraToDefaultPosition()
						hovered = 1
						scroll = 1
					elseif loopedTable[hovered+scroll].drivetype then --// Meghajtás
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						triggerServerEvent("buyTuning",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType,"danihe->vehicles->drivetype",loopedTable[hovered+scroll].drivetype)
					elseif loopedTable[hovered+scroll].steer then --// Fordulókör
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						triggerServerEvent("changeSteering",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType,loopedTable[hovered+scroll].steer)
					elseif loopedTable.upgradeSlot then --// Alap gta-s optikai tuning
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						triggerServerEvent("addOpticalTuning",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType,loopedTable.upgradeSlot,compatibleUpgrades[hovered+scroll-1])
						category = 2
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						moveCameraToDefaultPosition()
						compatibleUpgrades = {}
						hovered = 1
						scroll = 0
					elseif loopedTable.data == "danihe->tuning->nitro" and hovered+scroll == 3 then --// Nitro feltöltés
						if getElementData(enteredVehicle,loopedTable.data) == 1 then
							local nitroprecent = getElementData(enteredVehicle,"danihe->tuning->nitroprecent") or 0
							if nitroprecent < 100 then
								toggleUpgradeLine("Palack feltöltése..","sounds/upgrade.ogg")

								exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
								triggerServerEvent("fillNitro",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType)
							else
								exports.aprp_hud:showInfobox("error","A nitro palack teljesen felvan töltve!")
							end
						else
							exports.aprp_hud:showInfobox("error","Nincs nitro palack szerelve a járművedbe!")
						end
					elseif loopedTable.paintID then
						toggleUpgradeLine("Fényezés..","sounds/paint.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						local r,g,b = hsvToRgb(getSliderData(1),getSliderData(2),getSliderData(3),1)
						storedTuning = false
						triggerServerEvent("recolorVehicle",resourceRoot,localPlayer,enteredVehicle,loopedTable.paintID,r,g,b)
						triggerServerEvent("buyTuning",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType)

						category = 3
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						moveCameraToDefaultPosition()
						compatibleUpgrades = {}
						hovered = 1
						scroll = 0
						togSliders()
					elseif loopedTable.wheelType then
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						triggerServerEvent("buyTuning",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType)
						category = 2
						sub_category = 0
						sub_sub_category = 0
						loopedTable = tuning_options[category]
						togSliders()
						moveCameraToDefaultPosition()

						hovered = 1
						scroll = 0
					else
						toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

						exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
						triggerServerEvent("buyTuning",resourceRoot,localPlayer,enteredVehicle,price,loopedTable[hovered+scroll].priceType,loopedTable.data,hovered+scroll-1)
					end
				else
					if loopedTable[hovered+scroll].priceType == "Money" then
						exports.aprp_hud:showInfobox("error","Nincs elegendő készpénzed a vásárláshoz!")
					else
						exports.aprp_hud:showInfobox("error","Nincs elegendő prémium pontod a vásárláshoz!")
					end
				end

				promptbox["state"] = false
				playSound("sounds/promptdecline.ogg")
			end
		elseif k == "backspace" and p then
			if not promptbox["state"] then
				if loopedTable.plate then
					if plate_selected then
						if string.len(plate_text) > 0 then
							plate_text = plate_text:sub(1,#plate_text-1)
							setElementData(enteredVehicle,"danihe->vehicles->plate",plate_text)
						end
					end
				end

				if plate_selected then return end

				if category > 0 then
					if storedTuning then
						if loopedTable.paintID then
							if loopedTable.paintID == 1 then
								setElementData(enteredVehicle,"danihe->vehicles->bodyColor",{storedTuning[1],storedTuning[2],storedTuning[3]})
							elseif loopedTable.paintID == 2 then
								local r,g,b,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(enteredVehicle,true)
								setVehicleColor(enteredVehicle,r,g,b,storedTuning[1],storedTuning[2],storedTuning[3],r3,g3,b3,r4,g4,b4)
							elseif loopedTable.paintID == 3 then
								local r,g,b,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(enteredVehicle,true)
								setVehicleColor(enteredVehicle,r,g,b,r2,g2,b2,storedTuning[1],storedTuning[2],storedTuning[3],r4,g4,b4)
							elseif loopedTable.paintID == 4 then
								local r,g,b,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(enteredVehicle,true)
								setVehicleColor(enteredVehicle,r,g,b,r2,g2,b2,r3,g3,b3,storedTuning[1],storedTuning[2],storedTuning[3])
							elseif loopedTable.paintID == 5 then
								setVehicleHeadLightColor(enteredVehicle,storedTuning[1],storedTuning[2],storedTuning[3])
							end
						end
						if loopedTable.wheelType and loopedTable.wheelID then
							setElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType,storedTuning)
							category = 2
							sub_category = 1
							sub_sub_category = 0
							loopedTable = tuning_options[category][sub_category]
							hovered = 1
							scroll = 0
						elseif loopedTable.wheelType then
							setElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType,storedTuning)
						elseif loopedTable[hovered+scroll].editStickerLive then
							local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}

							stickers[storedTuning.id] = storedTuning.sticker

							setElementData(enteredVehicle,"danihe->vehicles->stickers",stickers)
 						end
						if loopedTable.tiredata then
							setElementData(enteredVehicle,"danihe->tuning->tiresmoke" .. loopedTable.tiredata,storedTuning)
						end
						if loopedTable.plate then
							setElementData(enteredVehicle,"danihe->vehicles->plateStyle",storedTuning.style)
							setElementData(enteredVehicle,"danihe->vehicles->plate",storedTuning.text)
							--core:dxDestroyEdit("plate")
						end
						if loopedTable.neon then
							setElementData(enteredVehicle,"danihe->vehicles->neon",storedTuning)
						end
						if loopedTable.variant then
							setElementData(enteredVehicle,"danihe->vehicles->variant",storedTuning)
						end
						if loopedTable[hovered+scroll].exhaust_id then
							setElementData(enteredVehicle,"danihe->tuning->customexhaust",storedTuning)
						end
						if loopedTable.upgradeSlot then
							if storedTuning == 0 then
								removeVehicleUpgrade(enteredVehicle,getVehicleUpgradeOnSlot(enteredVehicle,loopedTable.upgradeSlot))
							else
								addVehicleUpgrade(enteredVehicle,storedTuning)
							end
						end
					end
					if loopedTable.newSticker and not stickerSelect then
						exports.nl_vinyls:removeLastSticker(enteredVehicle)
						stickerSelect = true
						toggleStickerBrowser(true)
						togSliders()
						return
					elseif loopedTable.newSticker and stickerSelect then
						stickerSelect = false
						toggleStickerBrowser(false)
					end

					if loopedTable.wheelType then
						if old_categorys then old_categorys = false end
					end

					if loopedTable == tuning_options[category] then
						loopedTable = tuning_options
						playSound(":reach_core/sounds/change.ogg")
						category = 0
					elseif loopedTable == tuning_options[category][sub_category] then
						loopedTable = tuning_options[category]
						playSound(":reach_core/sounds/change.ogg")
						sub_category = 0
					elseif loopedTable == tuning_options[category][sub_category][sub_sub_category] then
						loopedTable = tuning_options[category][sub_category]
						playSound(":reach_core/sounds/change.ogg")
						sub_sub_category = 0
					end

					if old_categorys then
						hovered = old_categorys[1]
						scroll = old_categorys[2]
						old_categorys = false
					else
						hovered = 1
						scroll = 0
					end
					if not loopedTable.wheelType then
						moveCameraToDefaultPosition()
					end
					togSliders()
				else
					exitTuning()
				end
				storedTuning = false
				compatibleUpgrades = {}
			else
				promptbox["state"] = false
				playSound("sounds/promptdecline.ogg")
			end
		elseif k == "arrow_r" and p and not stickerSelect then
			if promptbox["state"] then return end
			if hovered == max_box then
				if #loopedTable > max_box then
					if hovered+scroll == #loopedTable then
						hovered = 1
						scroll = 0
						playSound("sounds/hover.ogg")
						hoverTick = getTickCount()
					else
						scroll = scroll + 1
						playSound("sounds/hover.ogg")
						hoverTick = getTickCount()
					end
				else
					hovered = 1
					playSound("sounds/hover.ogg")
					hoverTick = getTickCount()
				end
			else
				if hovered < #loopedTable then
					hovered = hovered + 1
					playSound("sounds/hover.ogg")
					hoverTick = getTickCount()
				else
					hovered = 1
					playSound("sounds/hover.ogg")
					hoverTick = getTickCount()
				end
			end
			if loopedTable[hovered+scroll].wheelID then
				setElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType,{id=loopedTable[hovered+scroll].wheelID,width=1,angle=0,offset=0.5,color={255,255,255}})
			end
			if loopedTable[hovered+scroll].exhaust_id then
				setElementData(enteredVehicle,"danihe->tuning->customexhaust",loopedTable[hovered+scroll].exhaust_id)
			end
			if loopedTable.plate then
				setElementData(enteredVehicle,"danihe->vehicles->plateStyle",hovered+scroll)
			end
			if loopedTable.neon then
				setElementData(enteredVehicle,"danihe->vehicles->neon",hovered+scroll-1)
			end
			if loopedTable.variant then
				setElementData(enteredVehicle,"danihe->vehicles->variant",hovered+scroll-1)
			end
			if #compatibleUpgrades > 0 then
				if hovered+scroll == 1 then
					removeVehicleUpgrade(enteredVehicle,getVehicleUpgradeOnSlot(enteredVehicle,loopedTable.upgradeSlot))
				else
					addVehicleUpgrade(enteredVehicle,compatibleUpgrades[hovered+scroll-1])
				end
			end
		elseif k == "arrow_l" and p and not stickerSelect then
			if promptbox["state"] then return end
			if scroll > 0 then
				scroll = scroll - 1
				playSound("sounds/hover.ogg")
				hoverTick = getTickCount()
			else
				if hovered > 1 then
					hovered = hovered - 1
					playSound("sounds/hover.ogg")
					hoverTick = getTickCount()
				else
					if #loopedTable > max_box then
						hovered = max_box
						scroll = #loopedTable-max_box
						playSound("sounds/hover.ogg")
						hoverTick = getTickCount()
					else
						hovered = #loopedTable
						playSound("sounds/hover.ogg")
						hoverTick = getTickCount()
					end
				end
			end
			if loopedTable[hovered+scroll].wheelID then
				setElementData(enteredVehicle,"danihe->vehicles->wheels" .. loopedTable.wheelType,{id=loopedTable[hovered+scroll].wheelID,width=1,angle=0,offset=0.5,color={255,255,255}})
			end
			if loopedTable[hovered+scroll].exhaust_id then
				setElementData(enteredVehicle,"danihe->tuning->customexhaust",loopedTable[hovered+scroll].exhaust_id)
			end
			if loopedTable.plate then
				setElementData(enteredVehicle,"danihe->vehicles->plateStyle",hovered+scroll)
			end
			if loopedTable.neon then
				setElementData(enteredVehicle,"danihe->vehicles->neon",hovered+scroll-1)
			end
			if loopedTable.variant then
				setElementData(enteredVehicle,"danihe->vehicles->variant",hovered+scroll-1)
			end
			if #compatibleUpgrades > 0 then
				if hovered+scroll == 1 then
					removeVehicleUpgrade(enteredVehicle,getVehicleUpgradeOnSlot(enteredVehicle,loopedTable.upgradeSlot))
				else
					addVehicleUpgrade(enteredVehicle,compatibleUpgrades[hovered+scroll-1])
				end
			end
		elseif k == "mouse_wheel_up" and tuning and not stickerSelect then
			if isCursorShowing() and not isMTAWindowActive() then
				cameraSettings["zoom"] = math.max(cameraSettings["zoom"] - 5, 30)
				cameraSettings["zoomTick"] = getTickCount()
			end
		elseif k == "mouse_wheel_down" and tuning and not stickerSelect then
			if isCursorShowing() and not isMTAWindowActive() then
				cameraSettings["zoom"] = math.min(cameraSettings["zoom"] + 5, 60)
				cameraSettings["zoomTick"] = getTickCount()
			end
		elseif k == "mouse1" and p and not stickerSelect then
			if not promptbox["state"] then
				if loopedTable[hovered+scroll].stickerEditing then
					local bs = 32.5
					local stickers = getElementData(enteredVehicle,"danihe->vehicles->stickers") or {}
					local ls = #stickers
					if isCursorOnBox(pos[1]+520+350+(241+bs+1)+238+bs+2-5-(bs-5)*2,pos[2]+35+1+2.5+(bs+1)*1,(bs-5)*2,bs-5) then
						stickers[ls][10] = not stickers[ls][10]
						playSound(":reach_core/sounds/ui_click.ogg")
						setElementData(enteredVehicle,"danihe->vehicles->stickers",stickers)
					elseif isCursorOnBox(pos[1]+520+350+(241+bs+1)+238+bs+2-5-(bs-5)*2,pos[2]+35+1+2.5+(bs+1)*2,(bs-5)*2,bs-5) then
						stickers[ls][11] = not stickers[ls][11]
						playSound(":reach_core/sounds/ui_click.ogg")
						setElementData(enteredVehicle,"danihe->vehicles->stickers",stickers)
					elseif isCursorOnBox(pos[1]+520+350+(241+bs+1)+238+bs+2-5-(bs-5)*2,pos[2]+35+1+2.5+(bs+1)*3,(bs-5)*2,bs-5) then
						stickers[ls][12] = not stickers[ls][12]
						playSound(":reach_core/sounds/ui_click.ogg")
						setElementData(enteredVehicle,"danihe->vehicles->stickers",stickers)
					end
				end
			end
		end
	end
)

function succesStickerSelect(x,y,rot)
	stickerSelect = false
	togSliders("sticker",{x/1024,y/1024,256/1024,256/1024,rot/360})
end

addEvent("succesPlateBuy",true)
addEventHandler("succesPlateBuy",localPlayer,
	function()
		toggleUpgradeLine("Felszerelés..","sounds/upgrade.ogg")

		exports.aprp_hud:showInfobox("info","Sikeresen megvásároltad a kiválasztott elemet.(" .. promptbox["text"] .. ")")
		--core:dxDestroyEdit("plate")
		plate_selected = false
		category = 4
		sub_category = 0
		sub_sub_category = 0
		loopedTable = tuning_options[category]
		moveCameraToDefaultPosition()
		compatibleUpgrades = {}
		hovered = 1
		scroll = 0
	end
)

function exitTuning()
	tuning = false
	--setElementData(localPlayer,"reach->settings->showInterface",true)
	exports.aprp_hud:toggleHUD(true)
	showChat(true)
	showCursor(false)

	triggerServerEvent("exitTuning",resourceRoot,localPlayer,enteredVehicle)
	triggerServerEvent("createTuningMarker",resourceRoot,enteredTuning)

	setCameraTarget(localPlayer)

	enteredTuning = 0
	enteredVehicle = false

	togSliders()

	setElementData(localPlayer,"activeTuning",false)
end

addEventHandler("onClientMarkerHit",root,
	function(hitPlayer,matchingDimension)
		if hitPlayer == localPlayer and matchingDimension then
			if getElementData(source,"danihe->tuning->isMarker") then
				if getPedOccupiedVehicle(localPlayer) then
					if getPedOccupiedVehicleSeat(localPlayer) == 0 then
						enteredVehicle = getPedOccupiedVehicle(localPlayer)
						if (getElementData(enteredVehicle,"vehicle.owner") == getElementData(localPlayer,"char.ID")) or getElementData(localPlayer,"acc.adminLevel") >= 9 then
							tuning = true
							lastTick = getTickCount()
							enteredTuning = getElementData(source,"danihe->tuning->marker_id")

							setElementData(localPlayer,"activeTuning",enteredTuning)

							showChat(false)
							showCursor(true)

							exports.aprp_hud:toggleHUD(false)

							old_categorys = false

							triggerServerEvent("enterTuning",resourceRoot,localPlayer,enteredVehicle,enteredTuning)
							triggerServerEvent("destroyTuningMarker",resourceRoot,enteredTuning)

							local vehicleRotation = tuning_markers[enteredTuning].pos[4]
							local cameraRotation = vehicleRotation + 110

							cameraSettings = {
								["distance"] = 8,
								["movingSpeed"] = 2,
								["currentX"] = math.rad(cameraRotation),
								["defaultX"] = math.rad(cameraRotation),
								["currentY"] = math.rad(cameraRotation),
								["currentZ"] = math.rad(5),
								["maximumZ"] = math.rad(35),
								["minimumZ"] = math.rad(0),
								["freeModeActive"] = false,
							}
							moveCameraToDefaultPosition()
							cameraSettings["moveState"] = "freeMode"

							hovered = 1
							scroll = 0
						else
							exports.aprp_hud:showInfobox("error","Ezt a járművet nem tuningolhatod, mert nem a tied!")
						end
					end
				end
			end
		end
	end
)






addEventHandler("onClientPreRender", root, function(timeSlice)
	--<< Egérrel mozgatás >>--
	if isCursorShowing() then
		local cursorX, cursorY = getCursorPosition()
		
		mouseTable["speed"][1] = math.sqrt(math.pow((mouseTable["last"][1] - cursorX) / timeSlice, 2))
		mouseTable["speed"][2] = math.sqrt(math.pow((mouseTable["last"][2] - cursorY) / timeSlice, 2))
		
		mouseTable["last"][1] = cursorX
		mouseTable["last"][2] = cursorY
	end
	--< Kamera >--
	if tuning and enteredVehicle then
		local _, _, _, _, _, _, roll, fov = getCameraMatrix()
		local cameraZoomProgress = (getTickCount() - cameraSettings["zoomTick"]) / 500
		local cameraZoomAnimation = interpolateBetween(fov, 0, 0, cameraSettings["zoom"], 0, 0, cameraZoomProgress, "Linear")
		
		if cameraSettings["moveState"] == "moveToElement" then
			local currentCameraX, currentCameraY, currentCameraZ, currentCameraRotX, currentCameraRotY, currentCameraRotZ = getCameraMatrix()
			local cameraProgress = (getTickCount() - cameraSettings["moveTick"]) / 5000
			local cameraX, cameraY, cameraZ, componentX, componentY, componentZ = getCameraPosition("component")
			local newCameraX, newCameraY, newCameraZ = interpolateBetween(currentCameraX, currentCameraY, currentCameraZ, cameraX, cameraY, cameraZ, cameraProgress, "Linear")
			local newCameraRotX, newCameraRotY, newCameraRotZ = interpolateBetween(currentCameraRotX, currentCameraRotY, currentCameraRotZ, componentX, componentY, componentZ, cameraProgress, "Linear")
			local newCameraZoom = interpolateBetween(fov, 0, 0, 60, 0, 0, cameraProgress, "Linear")
			
			setCameraMatrix(newCameraX, newCameraY, newCameraZ, newCameraRotX, newCameraRotY, newCameraRotZ, roll, newCameraZoom)
			
			if cameraProgress > 0.5 then
				cameraSettings["moveState"] = "freeMode"
				cameraSettings["zoom"] = 60
			end
		elseif cameraSettings["moveState"] == "backToVehicle" then
			local currentCameraX, currentCameraY, currentCameraZ, currentCameraRotX, currentCameraRotY, currentCameraRotZ = getCameraMatrix()
			local cameraProgress = (getTickCount() - cameraSettings["moveTick"]) / 1000
			local cameraX, cameraY, cameraZ, vehicleX, vehicleY, vehicleZ = getCameraPosition("vehicle")
			local newCameraX, newCameraY, newCameraZ = interpolateBetween(currentCameraX, currentCameraY, currentCameraZ, cameraX, cameraY, cameraZ, cameraProgress, "Linear")
			local newCameraRotX, newCameraRotY, newCameraRotZ = interpolateBetween(currentCameraRotX, currentCameraRotY, currentCameraRotZ, vehicleX, vehicleY, vehicleZ, cameraProgress, "Linear")
			local newCameraZoom = interpolateBetween(fov, 0, 0, 60, 0, 0, cameraProgress, "Linear")
			
			setCameraMatrix(newCameraX, newCameraY, newCameraZ, newCameraRotX, newCameraRotY, newCameraRotZ, roll, newCameraZoom)
			
			if cameraProgress > 0.5 then
				cameraSettings["moveState"] = "freeMode"
				cameraSettings["zoom"] = 60
			end
		elseif cameraSettings["moveState"] == "freeMode" then
			local cameraX, cameraY, cameraZ, elementX, elementY, elementZ = getCameraPosition("both")
			
			setCameraMatrix(cameraX, cameraY, cameraZ, elementX, elementY, elementZ, roll, cameraZoomAnimation)
		end
	end
end)

addEventHandler("onClientCursorMove", root, function(cursorX, cursorY, absoluteX, absoluteY)
	if tuning and enteredVehicle then
		if getKeyState("mouse1") then
			if not isCursorOnBox(pos[1],pos[2],size[1],size[2]) then
				lastCursorX = mouseTable["move"][1]
				lastCursorY = mouseTable["move"][2]
				
				mouseTable["move"][1] = cursorX
				mouseTable["move"][2] = cursorY
				
				if cursorX > lastCursorX then
					cameraSettings["currentX"] = cameraSettings["currentX"] - (mouseTable["speed"][1] * 30)
				elseif cursorX < lastCursorX then
					cameraSettings["currentX"] = cameraSettings["currentX"] + (mouseTable["speed"][1] * 30)
				end
				
				if cursorY > lastCursorY then
					cameraSettings["currentZ"] = cameraSettings["currentZ"] + (mouseTable["speed"][2] * 30)
				elseif cursorY < lastCursorY then
					cameraSettings["currentZ"] = cameraSettings["currentZ"] - (mouseTable["speed"][2] * 30)
				end
				
				cameraSettings["currentY"] = cameraSettings["currentX"]
				cameraSettings["currentZ"] = math.max(cameraSettings["minimumZ"], math.min(cameraSettings["maximumZ"], cameraSettings["currentZ"]))
			end
		end
	end
end)

function moveCameraToComponent(component, offsetX, offsetZ, zoom)
	if component then
		local _, _, vehicleRotation = getElementRotation(enteredVehicle)
		
		offsetX = offsetX or cameraSettings["defaultX"]
		offsetZ = offsetZ or 15
		zoom = zoom or 9
		
		local cameraRotation = vehicleRotation + offsetX
		
		cameraSettings["moveState"] = "moveToElement"
		cameraSettings["moveTick"] = getTickCount()
		camSound = playSound("sounds/cammove.ogg")
		setSoundVolume(camSound,8.0)
		cameraSettings["viewingElement"] = component
		cameraSettings["currentX"] = math.rad(cameraRotation)
		cameraSettings["currentY"] = math.rad(cameraRotation)
		cameraSettings["currentZ"] = math.rad(offsetZ)
		cameraSettings["distance"] = zoom
	end
end

function moveCameraToDefaultPosition()
	cameraSettings["moveState"] = "backToVehicle"
	cameraSettings["moveTick"] = getTickCount()
	camSound = playSound("sounds/cammove.ogg")
	setSoundVolume(camSound,8.0)
	cameraSettings["viewingElement"] = enteredVehicle
	
	cameraSettings["currentX"] = cameraSettings["defaultX"]
	cameraSettings["currentY"] = cameraSettings["defaultX"]
	cameraSettings["currentZ"] = math.rad(5)
	cameraSettings["distance"] = 7
	cameraSettings["zoomTick"] = 0
	cameraSettings["zoom"] = 60

	--[[local execptVariants = exports.remover:getComplainedVariants()
	for component in pairs(getVehicleComponents(enteredVehicle)) do
		if not execptVariants[component] then
			setVehicleComponentVisible(enteredVehicle, component, true)
		end
	end]]
end


function getCameraPosition(element)
	if element == "component" then
		local componentX, componentY, componentZ = getVehicleComponentPosition(enteredVehicle, cameraSettings["viewingElement"])
		local elementX, elementY, elementZ = getPositionFromElementOffset(enteredVehicle, componentX, componentY, componentZ)
		local elementZ = elementZ - 0.2
		
		local cameraX = elementX + math.cos(cameraSettings["currentX"]) * cameraSettings["distance"]
		local cameraY = elementY + math.sin(cameraSettings["currentY"]) * cameraSettings["distance"]
		local cameraZ = elementZ + math.sin(cameraSettings["currentZ"]) * cameraSettings["distance"]
		
		return cameraX, cameraY, cameraZ, elementX, elementY, elementZ
	elseif element == "vehicle" then
		local elementX, elementY, elementZ = getElementPosition(enteredVehicle)
		local elementZ = elementZ - 0.2
		
		local cameraX = elementX + math.cos(cameraSettings["currentX"]) * cameraSettings["distance"]
		local cameraY = elementY + math.sin(cameraSettings["currentY"]) * cameraSettings["distance"]
		local cameraZ = elementZ + math.sin(cameraSettings["currentZ"]) * cameraSettings["distance"]
		
		return cameraX, cameraY, cameraZ, elementX, elementY, elementZ
	elseif element == "both" then
		if type(cameraSettings["viewingElement"]) == "string" then
			local componentX, componentY, componentZ = getVehicleComponentPosition(enteredVehicle, cameraSettings["viewingElement"])
			
			elementX, elementY, elementZ = getPositionFromElementOffset(enteredVehicle, componentX, componentY, componentZ)
		else
			elementX, elementY, elementZ = getElementPosition(enteredVehicle)
		end
		
		local elementZ = elementZ - 0.2
		
		local cameraX = elementX + math.cos(cameraSettings["currentX"]) * cameraSettings["distance"]
		local cameraY = elementY + math.sin(cameraSettings["currentY"]) * cameraSettings["distance"]
		local cameraZ = elementZ + math.sin(cameraSettings["currentZ"]) * cameraSettings["distance"]
		
		return cameraX, cameraY, cameraZ, elementX, elementY, elementZ
	end
end
function isValidComponent(vehicle, componentName)
	if vehicle and componentName then
		if isElement(vehicle) then
			for component in pairs(getVehicleComponents(vehicle)) do
				if componentName == component then
					return true
				end
			end
		end
	end
	
	return false
end


local logoDistance = 25
addEventHandler("onClientRender",root,
	function()
		--if getElementData(localPlayer,"reach->settings->showInterface") then
			for k,v in ipairs(getElementsByType("marker")) do
				if getElementData(v,"danihe->tuning->isMarker") then
					local x,y,z = getElementPosition(v)
					local px,py,pz = getElementPosition(localPlayer)
					if getDistanceBetweenPoints3D(x,y,z,px,py,pz) < logoDistance then
						if isElementStreamedIn(v) then
							local sx,sy = getScreenFromWorldPosition(x,y,z+2,0.06,false) 
							if sx and sy then
								local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
								local scale = 0.9-(distance/logoDistance)*0.5
								local alphaScale = 255-(distance/logoDistance)*1
								local size = {360,161}
								local image = getElementData(v,"danihe->tuning->marker_logo")
								if image then
									dxDrawImage(sx-(size[1]*scale)/2,sy-(size[2]*scale)/2,size[1]*scale,size[2]*scale,image,0,0,0,tocolor(222,222,222,255*alphaScale))
								end
							end
						end
					end
				end
			end
		--end
	end
)

function toggleUpgradeLine(text,sound)
	if text and sound then
		upgrade["state"] = true
		upgrade["text"] = text
		upgrade["tick"] = getTickCount()
		upgrade["sound"] = sound
		upgrade["soundElement"] = playSound(upgrade["sound"])
	end
end


local blowOff = {}

addEventHandler("onClientRender",root,
	function()
		for k,vehicle in ipairs(getElementsByType("vehicle",root,true)) do
			local p = Vector3(getElementPosition(vehicle))
			local p2 = Vector3(getElementPosition(localPlayer))
			if getDistanceBetweenPoints3D(p,p2) < 50 then
				if not blowOff[vehicle] then
					blowOff[vehicle] = {
						old_gear = getVehicleCurrentGear(vehicle),
						effect = false,
						effect2 = false,
						timer = false,
					}
				end
			else
				if blowOff[vehicle] then
					blowOff[vehicle] = nil
				end
			end
		end

		for vehicle,data in pairs(blowOff) do
			if not isElement(vehicle) then blowOff[vehicle] = nil end
			if getVehicleCurrentGear(vehicle) ~= data.old_gear then
				if getElementData(vehicle,"danihe->tuning->turbo") == 4 then
					local p = Vector3(getElementPosition(vehicle))
					data.old_gear = getVehicleCurrentGear(vehicle)
					local sound = playSound3D("sounds/turbo_blowoff.wav",p)
					attachElements(sound,vehicle)
				end
				if getElementData(vehicle,"danihe->tuning->ecu") == 4 then
					if not isTimer(data.timer) then
						if isElement(data.effect) then destroyElement(data.effect) end
						local offset = {getVehicleModelExhaustFumesPosition(getElementModel(vehicle))}
						local x,y,z = getPositionFromElementOffset(vehicle,offset[1],offset[2],offset[3])
						data.effect = createEffect("gunflash",x,y,z, 90, 0, 180)
						setEffectSpeed(data.effect, 1.5) 
						setEffectDensity(data.effect, 1)

						data.old_gear = getVehicleCurrentGear(vehicle)

						local sound = playSound3D("sounds/backfire.ogg",x,y,z)
						attachElements(sound,vehicle)

						--if isElement(data.effect2) then destroyElement(data.effect2) end
						if exports.nl_handling:getDefaultHandling(getElementModel(vehicle))["modelFlags"] == "0x2000" then
							local offset = {getVehicleModelExhaustFumesPosition(getElementModel(vehicle))}
							local x,y,z = getPositionFromElementOffset(vehicle,-offset[1],offset[2],offset[3])
							data.effect2 = createEffect("gunflash",x,y,z, 90, 0, 180)
							setEffectSpeed(data.effect2, 1.5)
							setEffectDensity(data.effect2, 1)
						end

						data.timer = setTimer( function() end,500,1)
					end
				end
			end
			if isElement(data.effect) then
				local offset = {getVehicleModelExhaustFumesPosition(getElementModel(vehicle))}
				local x,y,z = getPositionFromElementOffset(vehicle,offset[1],offset[2],offset[3])
				setElementPosition(data.effect,x,y,z)

				local rx,ry,rz = getElementRotation(vehicle)

				setElementRotation(data.effect,90-rx,0-ry,180-rz)
			end

			if isElement(data.effect2) then
				local offset = {getVehicleModelExhaustFumesPosition(getElementModel(vehicle))}
				local x,y,z = getPositionFromElementOffset(vehicle,-offset[1],offset[2],offset[3])
				setElementPosition(data.effect2,x,y,z)

				local rx,ry,rz = getElementRotation(vehicle)

				setElementRotation(data.effect2,90-rx,0-ry,180-rz)
			end
		end
	end
)

addEventHandler("onClientElementDestroy",root,
	function()
		if blowOff[source] then
			blowOff[source] = nil
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




--[[
addEventHandler("onClientResourceStop",resourceRoot,
	function()
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if vehicle then
			local stickers = getElementData(vehicle,"danihe->vehicles->stickers") or {}
			for k,v in ipairs(stickers) do
				if v[9] then
					table.remove(stickers,k)
				end
			end
			setElementData(vehicle,"danihe->vehicles->stickers",stickers)
		end
	end
) ]]--