local lastTick = getTickCount()
local s = {guiGetScreenSize()}
local sliders = {}

local fonts = {}
fonts["default_10"] = dxCreateFont("fonts/roboto.ttf",10)
fonts["default_11"] = dxCreateFont("fonts/roboto.ttf",11)
fonts["default_bold_10"] = dxCreateFont("fonts/roboto_bold.ttf",10)
fonts["default_bold_11"] = dxCreateFont("fonts/roboto_bold.ttf",11)
fonts["bebasnue_14"] = dxCreateFont("fonts/bebasnue.ttf",14)
fonts["fontawsome_15"] = dxCreateFont("fonts/fontawesome.otf",15)
fonts["fontawsome_12"] = dxCreateFont("fonts/fontawesome.otf",12)

local slider_max = 1

local hovered = 1
local scroll = 0
local max_row = 6
local row_size = 55

local size = {330,35+max_row*row_size+0.5}
local pos = {100,s[2]-145-90-50-size[2]}

function togSliders(type,datas,editSticker)
	if not editSticker then editSticker = false end
	hovered = 1
	scroll = 0
	if type then
		sliders = {}
		sliders.name = "Testreszabás"
		if type == "wheel" then
			if datas then
				sliders[1] = {name="Színárnyalat",data=datas[1],image="textures/hue.dds",image_rot=0,type="slider",moving=false}
				sliders[2] = {name="Telítettség",data=datas[2],image="textures/saturation.dds",image_rot=180,type="slider",moving=false}
				sliders[3] = {name="Fényesség",data=datas[3],image="textures/brightness.dds",image_rot=0,type="slider",moving=false}
				sliders[4] = {name="Szélesítés",data=datas[4],type="slider",moving=false}
				sliders[5] = {name="Dőlésszög",data=datas[5],type="slider",moving=false}
				sliders[6] = {name="Eltolás",data=datas[6],type="slider",moving=false}
			else
				sliders[1] = {name="Színárnyalat",data=0,image="textures/hue.dds",image_rot=0,type="slider",moving=false}
				sliders[2] = {name="Telítettség",data=0,image="textures/saturation.dds",image_rot=180,type="slider",moving=false}
				sliders[3] = {name="Fényesség",data=1,image="textures/brightness.dds",image_rot=0,type="slider",moving=false}
				sliders[4] = {name="Szélesítés",data=0.5,type="slider",moving=false}
				sliders[5] = {name="Dőlésszög",data=0,type="slider",moving=false}
				sliders[6] = {name="Eltolás",data=0.5,type="slider",moving=false}
			end
		elseif type == "sticker" then
			if editSticker then
				sliders[1] = {name="Színárnyalat",data=datas[1],image="textures/hue.dds",image_rot=0,type="slider",moving=false}
				sliders[2] = {name="Telítettség",data=datas[2],image="textures/saturation.dds",image_rot=180,type="slider",moving=false}
				sliders[3] = {name="Fényesség",data=datas[3],image="textures/brightness.dds",image_rot=0,type="slider",moving=false}
				sliders[4] = {name="Áttetszőség",data=datas[4],image="textures/transparency.dds",image_rot=0,type="slider",moving=false}
				sliders[5] = {name="X Pozíció",data=datas[5],type="slider",moving=false}
				sliders[6] = {name="Y Pozíció",data=datas[6],type="slider",moving=false}
				sliders[7] = {name="X Méret",data=datas[7],type="slider",moving=false}
				sliders[8] = {name="Y Méret",data=datas[8],type="slider",moving=false}
				sliders[9] = {name="Forgatás",data=datas[9],type="slider",moving=false}
				sliders[10] = {name="Körvonalazás",data=datas[10],type="switch",moving=false}
				sliders[11] = {name="Vízszintes tükrözés",data=datas[11],type="switch",moving=false}
				sliders[12] = {name="Függőleges tükrözés",data=datas[12],type="switch",moving=false}
			else
				sliders[1] = {name="Színárnyalat",data=0,image="textures/hue.dds",image_rot=0,type="slider",moving=false}
				sliders[2] = {name="Telítettség",data=0,image="textures/saturation.dds",image_rot=180,type="slider",moving=false}
				sliders[3] = {name="Fényesség",data=1,image="textures/brightness.dds",image_rot=0,type="slider",moving=false}
				sliders[4] = {name="Áttetszőség",data=1,image="textures/transparency.dds",image_rot=0,type="slider",moving=false}
				sliders[5] = {name="X Pozíció",data=datas[1],type="slider",moving=false}
				sliders[6] = {name="Y Pozíció",data=datas[2],type="slider",moving=false}
				sliders[7] = {name="X Méret",data=datas[3],type="slider",moving=false}
				sliders[8] = {name="Y Méret",data=datas[4],type="slider",moving=false}
				sliders[9] = {name="Forgatás",data=datas[5],type="slider",moving=false}
				sliders[10] = {name="Körvonalazás",data=0,type="switch",moving=false}
				sliders[11] = {name="Vízszintes tükrözés",data=0,type="switch",moving=false}
				sliders[12] = {name="Függőleges tükrözés",data=0,type="switch",moving=false}
			end
		elseif type == "hsv" then
			sliders[1] = {name="Színárnyalat",data=datas[1],image="textures/hue.dds",image_rot=0,type="slider",moving=false}
			sliders[2] = {name="Telítettség",data=datas[2],image="textures/saturation.dds",image_rot=180,type="slider",moving=false}
			sliders[3] = {name="Fényesség",data=datas[3],image="textures/brightness.dds",image_rot=0,type="slider",moving=false}
		end
	else
		sliders = {}
	end
end

function getSliderData(id)
	if sliders[id] then
		return sliders[id].data
	else
		return false
	end
end

function anySliderMoving()
	local moving = false
	for k,v in ipairs(sliders) do
		if v.moving then
			moving = true
			break
		end
	end
	return moving
end

addEventHandler("onClientRender",root,
	function()
		if #sliders > 0 then
			if #sliders < max_row then
				size = {330,35+#sliders*row_size+0.5}
				pos = {100,s[2]-145-90-50-size[2]}
			else
				size = {330,35+max_row*row_size+0.5}
				pos = {100,s[2]-145-90-50-size[2]}
			end

			dxDrawRectangle(pos[1],pos[2],size[1],size[2],tocolor(140,140,140,75))
			dxDrawBorder(pos[1],pos[2],size[1],size[2],0.75,tocolor(222,222,222,175))
			dxDrawBorder(pos[1]-0.75,pos[2]-0.75,size[1]+1.5,size[2]+1.5,0.75,tocolor(222,222,222,70))
			dxDrawRectangle(pos[1],pos[2],size[1],35,tocolor(222,222,222,222))

			dxDrawText(string.upper(sliders.name),pos[1]+10,pos[2]+35/2,nil,nil,tocolor(70,70,70,222),1,fonts["bebasnue_14"],"left","center",false,false,false,true)
		
			for i = 1,max_row do
				local row = sliders[i+scroll]
				if row then
					local boxS = {size[1],row_size}
					local boxP = {pos[1],pos[2]+35+(i-1)*row_size}

					if hovered == i then
						dxDrawImage(boxP[1],boxP[2],boxS[1],10,"textures/shadow.dds",0,0,0,tocolor(255,255,255,75))
						dxDrawRectangle(boxP[1],boxP[2],boxS[1],boxS[2],tocolor(200,200,200,70))
						if hovered < max_row then
							dxDrawImage(boxP[1],boxP[2]+boxS[2],boxS[1],10,"textures/shadow.dds",0,0,0,tocolor(255,255,255,50))
						end

						local anim_x = interpolateBetween(7,0,0,0,0,0,getProgress(1350,lastTick),"SineCurve")
						dxDrawText("",boxP[1]-7-anim_x,boxP[2]+boxS[2]/2,nil,nil,tocolor(200,200,200,200),1,fonts["fontawsome_12"],"right","center",false,false,false,false,true)
						dxDrawText("",boxP[1]+boxS[1]+7+anim_x,boxP[2]+boxS[2]/2,nil,nil,tocolor(200,200,200,200),1,fonts["fontawsome_12"],"left","center",false,false,false,false,true)
						
						if row.type == "slider" then
							local offset = 0.003
							if getKeyState("lshift") or getKeyState("rshift") then offset = 0.015 end
							if getKeyState("lalt") or getKeyState("ralt") then offset = 0.00015 end

							if getKeyState("arrow_r") or getKeyState("arrow_l") then
								row.moving = true
								if getKeyState("arrow_r") then
									row.data = row.data + offset
								end
								if getKeyState("arrow_l") then
									row.data = row.data - offset
								end
							else
								row.moving = false
							end

							if row.data > 1 then row.data = 1 end
							if row.data < 0 then row.data = 0 end
						end
					end

					if row.name == "Szélesítés" then
						dxDrawText(( 75 + roundNumber(row.data*50) )/100 .. "x",boxP[1]+boxS[1]-5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"right","top")
					elseif row.name == "Dőlésszög" then
						dxDrawText(roundNumber(row.data*10,1) .. "°",boxP[1]+boxS[1]-5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"right","top")
					elseif row.name == "Eltolás" then
						dxDrawText(roundNumber(row.data*100) .. "%",boxP[1]+boxS[1]-5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"right","top")
					elseif row.name == "X Pozíció" then
						dxDrawText(roundNumber(row.data*1024) .. "px/1024px",boxP[1]+boxS[1]-5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"right","top")
					elseif row.name == "Y Pozíció" then
						dxDrawText(roundNumber(row.data*1024) .. "px/1024px",boxP[1]+boxS[1]-5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"right","top")
					elseif row.name == "X Méret" then
						dxDrawText(roundNumber(row.data*1024) .. "px/1024px",boxP[1]+boxS[1]-5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"right","top")
					elseif row.name == "Y Méret" then
						dxDrawText(roundNumber(row.data*1024) .. "px/1024px",boxP[1]+boxS[1]-5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"right","top")
					elseif row.name == "Forgatás" then
						dxDrawText(roundNumber(row.data*360) .. "°/360°",boxP[1]+boxS[1]-5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"right","top")
					end
					if row.type == "slider" then
						dxDrawText(row.name,boxP[1]+5,boxP[2]+10,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"left","top")
						dxDrawBorder(boxP[1]+15,boxP[2]+boxS[2]-20,boxS[1]-30,10,1.5,tocolor(222,222,222,222))
						if row.image then
							if row.image == "textures/saturation.dds" then
								local r,g,b = hsvToRgb(sliders[1].data,1,1,1)
								local r2,g2,b2 = hsvToRgb(sliders[1].data,0,sliders[3].data,1)
								dxDrawRectangle(boxP[1]+15,boxP[2]+boxS[2]-20,boxS[1]-30,10,tocolor(r2,g2,b2,255))
								dxDrawImage(boxP[1]+15,boxP[2]+boxS[2]-20,boxS[1]-30,10,row.image,row.image_rot,0,0,tocolor(r,g,b,255))
							else
								dxDrawImage(boxP[1]+15,boxP[2]+boxS[2]-20,boxS[1]-30,10,row.image,row.image_rot,0,0,tocolor(255,255,255,255))
							end

							local slider_pos = (boxS[1]-30-4)*row.data
							dxDrawRectangle(boxP[1]+15+slider_pos,boxP[2]+boxS[2]-20-5,4,10+10,tocolor(255,255,255,255))
						else
							dxDrawRectangle(boxP[1]+15,boxP[2]+boxS[2]-20,boxS[1]-30,10,tocolor(30,30,30,60))

							local slider_pos = (boxS[1]-30-4)*row.data
							dxDrawRectangle(boxP[1]+15,boxP[2]+boxS[2]-20,(boxS[1]-30)*row.data,10,tocolor(116,179,71,255))
							dxDrawRectangle(boxP[1]+15+slider_pos,boxP[2]+boxS[2]-20-5,4,10+10,tocolor(255,255,255,255))
						end
					elseif row.type == "switch" then
						dxDrawText(row.name,boxP[1]+5,boxP[2]+boxS[2]/2,nil,nil,tocolor(222,222,222,222),1,fonts["default_10"],"left","center")
						dxDrawCircleRectangle(boxP[1]+boxS[1]-5-44,boxP[2]+boxS[2]/2-22/2,44,22,tocolor(222,222,222,222),11)
						if row.data == 0 then
							dxDrawCircleRectangle(boxP[1]+boxS[1]-5-44+1,boxP[2]+boxS[2]/2-22/2+1,20,20,tocolor(214,76,69,255),10)
						else
							dxDrawCircleRectangle(boxP[1]+boxS[1]-5-44+22+1,boxP[2]+boxS[2]/2-22/2+1,20,20,tocolor(116,179,71,255),10)
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientKey",root,
	function(k,p)
		if #sliders > 0 then
			if p then
				if k == "arrow_d" then
					if hovered < max_row then
						if sliders[hovered+1] then
							hovered = hovered + 1
							playSound("sounds/hover.ogg")
						end
					else
						if #sliders > max_row then
							if #sliders-max_row > scroll then
								scroll = scroll + 1
								playSound("sounds/hover.ogg")
							end
						end
					end
				elseif k == "arrow_u" then
					if hovered > 1 then
						hovered = hovered - 1
						playSound("sounds/hover.ogg")
					else
						if scroll > 0 then
							scroll = scroll - 1
							playSound("sounds/hover.ogg")
						end
					end
				elseif k == "arrow_r" then
					local row = sliders[hovered+scroll]
					if row.type == "switch" then
						if row.data == 0 then
							row.data = 1
							row.moving = true
							setTimer(function() row.moving = false end,50,1)
						end
					end
				elseif k == "arrow_l" then
					local row = sliders[hovered+scroll]
					if row.type == "switch" then
						if row.data == 1 then
							row.data = 0
							row.moving = true
							setTimer(function() row.moving = false end,50,1)
						end
					end
				end
			end
		end
	end
)