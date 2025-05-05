addEvent("returnModelLockCode", true)
addEventHandler("returnModelLockCode", getRootElement(),
	function(webCode, webString)
		lockCode = webCode
		lockString = webString
		lockCode = "yy-8LG#H@yRgKQ-UpxCSMWgzu@LpVbW#uDuVnc*qc9h+_EtR@Vw#mAsF6yzv5u3jJqupMs$"
		lockString = 655
		if lockString and lockCode then
			loadMods()
		end
	end
)

local modelsTable = {
	{"bank/lift", 18216, "bank/bank"},
	{"bank/liftdoor", 3281, "bank/bank"},
	{"bank/ora", 18321, "bank/bank"},
	{"bank/perc", 7009, "bank/bank"},
	{"bank/safedoor", 18267, "bank/bank"},
	{"bank/bank", 6152, "bank/bank", true},
	{"bank/gold", 17144, "bank/bank"},
	
	{"lvroads/s_bit_14", 16224},
	{"lvroads/s_bit_15", 16225},
	{"lvroads/s_bit_17", 16227},
	{"lvroads/s_bit_18", 16228},
	{"lvroads/se_bit_17", 16246},
	
	{"houses/CEhillhouse01", 13755, "houses/CEhillhouse01", true},	
	
	{"lsfd/lsfd", 4011},
	{"lsfd/lsfd2", 7983, "lsfd/lsfd"},
	{"lsfd/lsfd_door", 8397, "lsfd/lsfd"},
	
	{"roadfix/6118", 6118},
	{"roadfix/6116", 6116},
	{"roadfix/6309", 6309},
	{"roadfix/6310", 6310},
	{"roadfix/6127", 6127},
	{"roadfix/6122", 6122},
	{"roadfix/13752", 13752},
	{"roadfix/5489", 5489},
	{"roadfix/5750", 5750},
	{"roadfix/6508", 6508},
	{"roadfix/4108", 4108},
	{"roadfix/5021", 5021},
	{"roadfix/9529", 9529},
	
	{"hospital/hosp", 5708},
	
	{"cityhall/1", 3980, "cityhall/1", true},


	{"plaza/plaza", 6061, "plaza/shops2_law"},
	{"plaza/plazasecondfloor", 6060, "plaza/shops2_law"},
}

local lvModels = {
	{16224, -428.6406000, 604.6250000, 1.9609000},
	{16225, -232.3906, 597.2344, 0.0391},
	{16227, -4.3438, 611.3906, -0.6406},
	{16228, 176.7422, 639.3438, -1.9297},
	{16246, 336.0781, 676.3594, -6.0703},
}

function loadMods()
	for k, v in pairs(modelsTable) do

		if v[3] then
			if fileExists("files/"..v[3]..".txd") then
				local txd = engineLoadTXD("files/"..v[3]..".txd")
				engineImportTXD(txd, v[2])
			end
		else
			if fileExists("files/"..v[1]..".txd") then
				local txd = engineLoadTXD("files/"..v[1]..".txd")
				engineImportTXD(txd, v[2])
			end
		end

		if fileExists("files/"..v[1]..".col") then
			local col = engineLoadCOL("files/"..v[1]..".col")
			engineReplaceCOL(col, v[2])
			--outputChatBox(v[1])
		end
		
		if fileExists("files/"..v[1]..".strong") then
			local dff = engineLoadDFF(loadLockedFiles("files/"..v[1]..".strong", lockCode))
			if v[4] then
				engineReplaceModel(dff, v[2], true)
			else
				engineReplaceModel(dff, v[2])
			end
		end
		
		engineSetModelLODDistance(v[2], 5000)
	end
	
	for k, v in ipairs(lvModels) do
		local modelObject = createObject(v[1], v[2], v[3], v[4])
		local modelObjectLoad = createObject(v[1], v[2], v[3], v[4], 0, 0, 0, true)
		setLowLODElement(modelObject, modelObjectLoad)
		setElementDimension(modelObject, -1)
	end
	
	createMapObject()
end
--addEventHandler("onClientResourceStart", resourceRoot, loadMods)

function createMapObject()
	local bankObj = createObject(6152, 990.0859, -1450.0859, 12.7734)
	local bankObjLoad = createObject(6152, 990.0859, -1450.0859, 12.7734, 0, 0, 0, true)
	setLowLODElement(bankObj, bankObjLoad)
	setElementDoubleSided(bankObj, true)
	setElementDimension(bankObj, -1)
	setElementDimension(bankObjLoad, -1)

	createObject(4831, 1756.0898, -2286.5, 16.3984, 0, 0, 0, true)
	createObject(4846, 1827.1299, -2158.8604, 14.5156, 0, 0, 0, true)
	createObject(6122, 798.08984, -1763.0996, 12.6953, 0, 0, 0, true)
	createObject(13752, 1210.7, -625.62, 78.7109, 0, 0, 10.448, true)
end

setOcclusionsEnabled(false)
engineSetAsynchronousLoading(true, true)

function loadLockedFiles(path, key)
	local file = fileOpen(path)
	local size = fileGetSize(file)
	local FirstPart = fileRead(file, lockString+6)
	fileSetPos(file, lockString+6)
	local SecondPart = fileRead(file, size-(lockString+6))
	fileClose(file)
	return decodeString("tea", FirstPart, { key = key })..SecondPart
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		triggerServerEvent("getServerString", localPlayer)
		for k, v in pairs(getElementsByType("object", resourceRoot)) do
			local breakable = getElementData(v, "breakable")
			if breakable then
				setObjectBreakable(v, breakable == "true")

				if breakable ~= "true" then
					setElementFrozen(v, true)
				end
			end
		end
	end
)

addEventHandler("onClientObjectDamage", getResourceRootElement(),
	function ()
		cancelEvent()
	end
)

local mods = {}

local function registerMod(fileName, model)
	local id = #mods + 1

	model = model or fileName

	mods[id] = {}
	mods[id].model = tonumber(model)
	mods[id].path = fileName
end

registerMod("horgaszbot", 2993)
registerMod("barrier", 981)
registerMod("kanna", 363)
registerMod("pump", 3465)
registerMod("pisztoly", 330)
registerMod("emelo_block", 16139)
registerMod("emelo_kar", 16148)
registerMod("traffi_allo", 13759)
registerMod("uszo", 3917)
registerMod("int3int_carupg_int", 14776)
registerMod("int_kbsgarage05b", 14796)
registerMod("int_kbsgarage2", 14826)
registerMod("int3int_kbsgarage", 14783)
registerMod("int_kbsgarage3b", 14797)
registerMod("int_kbsgarage3", 14798)
registerMod("cellphone", 2967)
registerMod("axe", 321)
registerMod("speed_bump01", 10117)
registerMod("kb_tr_main", 14385)
registerMod("traffi", 951)
registerMod("slotm", 1515)
registerMod("slotm2", 2618)
registerMod("slotm3", 2640)
registerMod("slotm4", 1948)
registerMod("rbs1", 10139)
registerMod("rbs2", 10138)
registerMod("rbs3", 10137)
registerMod("rbs4", 10136)
registerMod("boja", 10135)
registerMod("flex", 1636)
registerMod("hajobelso", 9494)
registerMod("cj_money_bags", 1550)
registerMod("letter", 8583)
registerMod("parcel", 2694)

local function loadMod(id)
	if id then
		if mods and mods[id] then
			if fileExists("files/unprotectModels/" .. mods[id].path .. ".txd") then
				local txd = engineLoadTXD("files/unprotectModels/" .. mods[id].path .. ".txd", true)

				if txd then
					engineImportTXD(txd, mods[id].model)
				end
			end

			if fileExists("files/unprotectModels/" .. mods[id].path .. ".col") then
				local col = engineLoadCOL("files/unprotectModels/" .. mods[id].path .. ".col")

				if col then
					engineReplaceCOL(col, mods[id].model)
				end
			end

			if fileExists("files/unprotectModels/" .. mods[id].path .. ".dff") then
				local dff = engineLoadDFF("files/unprotectModels/" .. mods[id].path .. ".dff", mods[id].model)

				if dff then
					engineReplaceModel(dff, mods[id].model)
				end
			end
		end
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for k in pairs(mods) do
			loadMod(k)
		end
	end
)


addEventHandler("onClientResourceStart", resourceRoot,
	function()
        removeWorldModel(16224, 2.5, -428.6406000, 604.6250000, 1.9609000)
        removeWorldModel(16417, 2.5, -428.6406000, 604.6250000, 1.9609000)
            
        removeWorldModel(16225, 2.5, -232.3906000, 597.2344000, 0.0391000)
        removeWorldModel(16418, 2.5, -232.3906000, 597.2344000, 0.0391000)
            
        removeWorldModel(16227, 2.5, -4.3438000, 611.3906000, -0.6406000)
        removeWorldModel(16490, 2.5, -4.3438000, 611.3906000, -0.6406000)
            
        removeWorldModel(16228, 2.5, 176.7422000, 639.3438000, -1.9297000)
        removeWorldModel(16489, 2.5, 176.7422000, 639.3438000, -1.9297000)
        
        removeWorldModel(16246, 2.5, 336.0781000, 676.3594000, -6.0703000)    
        removeWorldModel(16493, 2.5, 336.0781000, 676.3594000, -6.0703000)    
        
        removeWorldModel(16308, 2.5, 318.1797000, 765.0391000, 7.6328000)
            
        removeWorldModel(1676, 50, 1941.6563000, -1771.3438000, 14.1406000)
        removeWorldModel(1676, 50, 1941.6563000, -1767.2891000, 14.1406000)
        removeWorldModel(1676, 50, 1941.6563000, -1778.4531000, 14.1406000)
        removeWorldModel(1676, 50, 1941.6563000, -1774.3125000, 14.1406000)
        removeWorldModel(6905, 2.5, 2447.3906000, 2198.7188000, 9.8125000)
        removeWorldModel(6906, 2.5, 2244.8906000, 2183.2266000, 9.8203000)
        removeWorldModel(7392, 2.5, 2320.4609000, 2128.8047000, 35.4375000)
        removeWorldModel(7388, 2.5, 2616.6172000, 2245.2656000, 10.0547000)
        removeWorldModel(7266, 2.5, 2447.3906000, 2198.7188000, 9.8125000)
        removeWorldModel(7071, 2.5, 2247.5547000, 2200.2500000, 22.3359000)
        removeWorldModel(7265, 2.5, 2447.3906000, 2198.7188000, 9.8125000)
        removeWorldModel(7220, 2.5, 2247.5547000, 2200.2500000, 22.3359000)
        removeWorldModel(7265, 2.5, 2447.3906000, 2198.7188000, 9.8125000)
        removeWorldModel(9192, 2.5, 2136.1641000, 944.1328000, 15.0547000)
        removeWorldModel(7389, 2.5, 2464.2500000, 2030.9609000, 11.0859000)
        removeWorldModel(7972, 2.5, 1880.8438000, 2075.1016000, 11.0859000)
        removeWorldModel(7390, 2.5, 2214.9063000, 2465.6875000, 14.8281000)
        removeWorldModel(7391, 2.5, 2143.3828000, 2761.9688000, 14.8281000)
        removeWorldModel(7289, 2.5, 2412.4922000, 2124.5156000, 19.3125000)
        removeWorldModel(7971, 2.5, 1602.4219000, 2199.1563000, 14.6484000)
        removeWorldModel(3426, 2.5, 353.7031000, 1302.0391000, 11.5625000)
        removeWorldModel(3426, 2.5, 491.0234000, 1306.9141000, 8.2656000)
        removeWorldModel(3426, 2.5, 563.0156000, 1308.9922000, 9.4688000)
        removeWorldModel(3426, 2.5, 628.1484000, 1354.4063000, 11.3828000)
        removeWorldModel(3426, 2.5, 419.4453000, 1411.8750000, 6.7656000)
        removeWorldModel(3426, 2.5, 405.5938000, 1463.8359000, 6.3906000)
        removeWorldModel(3426, 2.5, 433.9688000, 1565.9688000, 10.9844000)
        removeWorldModel(7314, 2.5, 2489.2500000, 2126.1875000, 19.8594000)
        removeWorldModel(3426, 2.5, 578.5078000, 1424.6172000, 10.5313000)
        removeWorldModel(3426, 2.5, 534.6875000, 1471.1094000, 3.8047000)
        removeWorldModel(3426, 2.5, 600.8438000, 1500.1484000, 7.2578000)
        removeWorldModel(3427, 2.5, 375.0391000, 1335.0547000, 10.2188000)
        removeWorldModel(3427, 2.5, 588.1641000, 1340.9609000, 9.8594000)
        removeWorldModel(3427, 2.5, 500.1953000, 1389.7969000, 3.5703000)
        removeWorldModel(3427, 2.5, 422.9141000, 1513.4141000, 10.7188000)
        removeWorldModel(3427, 2.5, 487.1016000, 1528.2266000, 0.1250000)
        removeWorldModel(3427, 2.5, 648.9375000, 1471.3828000, 8.3672000)
        removeWorldModel(3427, 2.5, 375.0391000, 1335.0547000, 10.2188000)
        removeWorldModel(3427, 2.5, 435.0547000, 1269.6875000, 8.6953000)
        removeWorldModel(3428, 2.5, 628.1484000, 1354.4063000, 11.3828000)
        removeWorldModel(3428, 2.5, 353.7031000, 1302.0391000, 11.5625000)
        removeWorldModel(3428, 2.5, 419.4453000, 1411.8750000, 6.7656000)
        removeWorldModel(3428, 2.5, 491.0234000, 1306.9141000, 8.2656000)
        removeWorldModel(3428, 2.5, 534.6875000, 1471.1094000, 3.8047000)
        removeWorldModel(3428, 2.5, 578.5078000, 1424.6172000, 10.5313000)
        removeWorldModel(3428, 2.5, 563.0156000, 1308.9922000, 9.4688000)
        removeWorldModel(3428, 2.5, 433.9688000, 1565.9688000, 10.9844000)
        removeWorldModel(3428, 2.5, 600.8438000, 1500.1484000, 7.2578000)
        removeWorldModel(3428, 2.5, 405.5938000, 1463.8359000, 6.3906000)
        removeWorldModel(7183, 2.5, 2247.5547000, 2200.2500000, 22.3359000)
        removeWorldModel(7263, 2.5, 2246.7891000, 2080.2031000, 23.5781000)
        removeWorldModel(7279, 2.5, 2246.7891000, 2080.2031000, 23.5781000)
        removeWorldModel(16776, 2.5, -237.0234000, 2662.8359000, 62.6094000)
        removeWorldModel(16781, 2.5, -144.0547000, 1227.3047000, 18.8984000)
        removeWorldModel(16777, 2.5, -105.3594000, 1212.0703000, 18.7344000)
        removeWorldModel(7387, 2.5, 2178.0078000, 2799.0703000, 10.8438000)
        setOcclusionsEnabled(false)
		engineSetAsynchronousLoading(true, false)
        setWaterLevel(0)
		for i = 1, #list do
			removeWorldModel(unpack(list[i]))
		end
	end
)

height = 0
SizeVal = 2998
southWest_X = -SizeVal
southWest_Y = 500
southEast_X = SizeVal
southEast_Y = 500
northWest_X = -SizeVal
northWest_Y = SizeVal
northEast_X = SizeVal
northEast_Y = SizeVal

function thaResourceStarting( )
	water = createWater(southWest_X, southWest_Y, height, southEast_X, southEast_Y, height, northWest_X, northWest_Y, height, northEast_X, northEast_Y, height)
	water1 = createWater(-1190.4129638672, -2896.4516601562, 0, -1198.7435302734, -2751.3388671875, 0, -1521.1312255859, -2896.216796875, 0)
	--local water2 = createWater(-1598.8287353516, 500.61123657227, -0.55000001192093, -1617.5070800781, 502.24963378906, -0.55000001192093, -1597.6948242188, 470.1604309082, -0.55000001192093)
	--setWaterColor(0, 150, 150)
    setWaterLevel ( height )
    --createWater(1309.34765625, 572.4345703125, 0, 2925.056640625, 572.4345703125, 0, 2925.056640625, 32015.7744140625, 0, 1309.34765625, 3000, 0)
end
addEventHandler("onClientResourceStart", resourceRoot, thaResourceStarting)


createWater(-139.28067016602, -2910.8220214844, 0.29313659667969, -134.46507263184, -2839.9780273438, 0.29313659667969, -186.51150512695, -2912.6228027344, 0.29313659667969)