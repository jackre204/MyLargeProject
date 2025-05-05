local lastTick = getTickCount()
local s = {guiGetScreenSize()}

local size = {1000,505}
local pos = {s[1]/2-size[1]/2,s[2]/2-size[2]/2-75}

local state = false
local category = 1
local categorySelect = false
local scroll = 0
local selected = {}
local textures = {}
local categoryTick = getTickCount()
local countX,countY = 7,3

addEventHandler("onClientRender",root,
	function()
		if state then
			local alpha = interpolateBetween(0,0,0,1,0,0,getProgress(750,lastTick),"InQuad")
			dxDrawRectangle(0,0,s[1],s[2],tocolor(30,30,30,165*alpha))

			dxDrawRectangle(pos[1],pos[2]+75,size[1],1,tocolor(150,150,150,150*alpha))
			dxDrawRectangle(pos[1],pos[2]+size[2],size[1],1,tocolor(150,150,150,150*alpha))

			--// Kategóriák
			for i = 1,#stickers do
				local circlesize = {52,52}
				local circlepos = {pos[1]+size[1]/2-circlesize[1]/2+(i-3)*(circlesize[1]+15),pos[2]+75/2-circlesize[2]/2}

				if category == i then
					dxDrawImage(circlepos[1],circlepos[2],circlesize[1],circlesize[2],"textures/stickers/circle_hover.dds",0,0,0,tocolor(116,179,71,175*alpha))
					dxDrawImage(circlepos[1]+12,circlepos[2]+12,circlesize[1]-24,circlesize[2]-24,textures["categoryIcon_" .. i],0,0,0,tocolor(200,200,200,200*alpha))

					local anim_y = -3
					if categorySelect then
						anim_y = interpolateBetween(-3,0,0,15,0,0,getProgress(2000,categoryTick),"SineCurve")
					end
					dxDrawText("",circlepos[1]+circlesize[1]/2,circlepos[2]+5-anim_y,nil,nil,tocolor(30,30,30,250*alpha),1,fonts["fontawsome_25"],"center","bottom",false,false,false,false,true)
					local textWidth = dxGetTextWidth(stickers[i].name,1,fonts["default_bold_10"],false)
					dxDrawCircleRectangle(circlepos[1]+circlesize[1]/2-(textWidth+25)/2,circlepos[2]-50-anim_y,textWidth+25,30,tocolor(30,30,30,250*alpha),7.5)
					dxDrawText(stickers[i].name,circlepos[1]+circlesize[1]/2,circlepos[2]-50+30/2-anim_y,nil,nil,tocolor(200,200,200,200*alpha),1,fonts["default_bold_10"],"center","center",false,false,false,false,true)
				else
					dxDrawImage(circlepos[1],circlepos[2],circlesize[1],circlesize[2],"textures/stickers/circle.dds",0,0,0,tocolor(10,10,10,100*alpha))
					dxDrawImage(circlepos[1]+12,circlepos[2]+12,circlesize[1]-24,circlesize[2]-24,textures["categoryIcon_" .. i],0,0,0,tocolor(200,200,200,200*alpha))
				end
				if categorySelect then
					local anim_x = interpolateBetween(12,0,0,0,0,0,getProgress(1350,lastTick),"SineCurve")
					dxDrawText("",pos[1]+250-anim_x,pos[2]+75/2,nil,nil,tocolor(160,160,160,160*alpha),1,fonts["fontawsome_18"],"center","center",false,false,false,true,true)
					dxDrawText("",pos[1]+size[1]-250+anim_x,pos[2]+75/2,nil,nil,tocolor(160,160,160,160*alpha),1,fonts["fontawsome_18"],"center","center",false,false,false,true,true)
				else
					dxDrawText("",pos[1]+250,pos[2]+75/2,nil,nil,tocolor(120,120,120,100*alpha),1,fonts["fontawsome_18"],"center","center",false,false,false,true,true)
					dxDrawText("",pos[1]+size[1]-250,pos[2]+75/2,nil,nil,tocolor(120,120,120,100*alpha),1,fonts["fontawsome_18"],"center","center",false,false,false,true,true)
				end
			end

			local column = 0
			local row = 0
			for i = 1,countX*countY do
				local boxsize = {121,121}
				local boxpos = {pos[1]+30+(row*(boxsize[1]+15)),pos[2]+90+(column*(boxsize[2]+15))}

				if selected.x == row+1 and selected.y == column+1 and not categorySelect then
					dxDrawImage(boxpos[1]-10,boxpos[2]-10,boxsize[1]+20,boxsize[2]+20,"textures/stickers/hover.dds",0,0,0,tocolor(255,255,255,85*alpha))
				end

				local imgPath = ":nl_vinyls/stickers/" .. stickers[category].dir .. "/" .. i+scroll .. ".dds"
				if fileExists(imgPath) then
					dxDrawImage(boxpos[1],boxpos[2],boxsize[1],boxsize[2],imgPath,0,0,0,tocolor(222,222,222,200*alpha))
				end

				column = column + 1
				if column == countY then
					column = 0
					row = row + 1
				end
			end
			if categorySelect then
				dxDrawText("",pos[1],pos[2]+75+(size[2]-75)/2,nil,nil,tocolor(120,120,120,100*alpha),1,fonts["fontawsome_22"],"center","center",false,false,false,true,true)
				dxDrawText("",pos[1]+size[1],pos[2]+75+(size[2]-75)/2,nil,nil,tocolor(120,120,120,100*alpha),1,fonts["fontawsome_22"],"center","center",false,false,false,true,true)
			else
				local anim_x = interpolateBetween(12,0,0,0,0,0,getProgress(1350,lastTick),"SineCurve")
				dxDrawText("",pos[1]-anim_x,pos[2]+75+(size[2]-75)/2,nil,nil,tocolor(160,160,160,160*alpha),1,fonts["fontawsome_22"],"center","center",false,false,false,true,true)
				dxDrawText("",pos[1]+size[1]+anim_x,pos[2]+75+(size[2]-75)/2,nil,nil,tocolor(160,160,160,160*alpha),1,fonts["fontawsome_22"],"center","center",false,false,false,true,true)
			end

			local stickerID = ((selected.x-1)*countY)+selected.y
			if not categorySelect and stickerID <= stickers[category].stickerCount then
				dxDrawText("Kiválasztott matrica ára: #74b347" .. format(stickers[category].price) .. "NL Coin",pos[1],pos[2]+size[2]+5,nil,nil,tocolor(200,200,200,200*alpha),1,fonts["default_bold_10"],"left","top",false,false,false,true)
			end

			dxDrawNavButton(pos[1]+size[1]-80-55,pos[2]+size[2]+5,55,25,"ENTER","default_bold_10",alpha)
			dxDrawText("Kiválasztás",pos[1]+size[1],pos[2]+size[2]+35/2,nil,nil,tocolor(200,200,200,200*alpha),1,fonts["default_10"],"right","center")

			dxDrawNavButton(pos[1]+size[1]-220-90,pos[2]+size[2]+5,90,25,"BACKSPACE","default_bold_10",alpha)
			dxDrawText("Visszalépés",pos[1]+size[1]-140,pos[2]+size[2]+35/2,nil,nil,tocolor(200,200,200,200*alpha),1,fonts["default_10"],"right","center")

			dxDrawNavButton(pos[1]+size[1]-70-25,pos[2]+size[2]+37.5,25,25,"","fontawsome_10",alpha)
			dxDrawNavButton(pos[1]+size[1]-70-25-30,pos[2]+size[2]+37.5,25,25,"","fontawsome_10",alpha)
			dxDrawNavButton(pos[1]+size[1]-70-25-30*2,pos[2]+size[2]+37.5,25,25,"","fontawsome_10",alpha)
			dxDrawNavButton(pos[1]+size[1]-70-25-30*3,pos[2]+size[2]+37.5,25,25,"","fontawsome_10",alpha)
			dxDrawText("Navigáció",pos[1]+size[1],pos[2]+size[2]+35+35/2,nil,nil,tocolor(200,200,200,200*alpha),1,fonts["default_10"],"right","center")
		end
	end
)

function dxDrawNavButton(x,y,w,h,text,font,alpha)
	dxDrawCircleRectangle(x,y+2,w,h,tocolor(80,80,80,255*alpha),3)
	dxDrawCircleRectangle(x,y,w,h,tocolor(150,150,150,255*alpha),3)
	dxDrawText(text,x+w/2,y+h/2,nil,nil,tocolor(30,30,30,230*alpha),1,fonts[font],"center","center",false,false,false,true)
end

addEventHandler("onClientKey",root,
	function(k,p)
		if state and p then
			if k == "arrow_r" then
				if categorySelect then
					if category < #stickers then
						category = category + 1
						scroll = 0
						selected.x,selected.y = 1,1
						categoryTick = getTickCount()
						playSound(":reach_core/sounds/ui_click.ogg")
					end
				else
					if selected.x < countX then
						selected.x = selected.x + 1
						playSound(":reach_inventory/sounds/hover.ogg")
					else
						if scroll < stickers[category].stickerCount-(countX*countY) then
							scroll = scroll + countY
							playSound(":reach_inventory/sounds/hover.ogg")
						else
							playSound(":reach_core/sounds/cant.ogg")
						end
					end
				end
			elseif k == "arrow_l" then
				if categorySelect then
					if category > 1 then
						category = category - 1
						scroll = 0
						selected.x,selected.y = 1,1
						categoryTick = getTickCount()
						playSound(":reach_core/sounds/ui_click.ogg")
					end
				else
					if selected.x > 1 then
						selected.x = selected.x - 1
						playSound(":reach_inventory/sounds/hover.ogg")
					else
						if scroll > 0 then
							scroll = scroll - countY
							playSound(":reach_inventory/sounds/hover.ogg")
						else
							playSound(":reach_core/sounds/cant.ogg")
						end
					end
				end
			elseif k == "arrow_d" then
				if categorySelect then 
					categorySelect = false
					playSound(":reach_core/sounds/ui_click.ogg")
				else
					if selected.y < countY then
						selected.y = selected.y + 1
						playSound(":reach_inventory/sounds/hover.ogg")
					end
				end
			elseif k == "arrow_u" then
				if not categorySelect then
					if selected.y > 1 then
						selected.y = selected.y - 1
						playSound(":reach_inventory/sounds/hover.ogg")
					else
						categorySelect = true
					end
				end
			elseif k == "enter" then
				local stickerID = (((selected.x-1)*countY)+selected.y)+scroll
				if not categorySelect and stickerID <= stickers[category].stickerCount then
					exports.nl_vinyls:addNewSticker(getPedOccupiedVehicle(localPlayer),stickers[category].dir,stickerID)
					toggleStickerBrowser(false)
					local x,y,rot = exports.nl_vinyls:getPaintjobDefaults(getPedOccupiedVehicle(localPlayer))
					succesStickerSelect(x,y,rot)
				end
			end
		end
	end
)

function toggleStickerBrowser(newState)
	state = newState
	scroll = 0
	category = 1
	selected.x = 1
	selected.y = 1
	categorySelect = true
	if newState then
		--core:createBlur("stickerBrowser",1)
	else
		--core:removeBlur("stickerBrowser")
	end
end


addEventHandler("onClientResourceStart",resourceRoot,
	function()
		for i = 1,#stickers do
			textures["categoryIcon_" .. i] = dxCreateTexture(stickers[i].icon,"argb",false,"clamp")
		end
	end
)