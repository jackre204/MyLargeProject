packUpTime = 30

vehicleTaxAmount = 0.005

function getVehicleTax()
	return vehicleTaxAmount
end

startJobPeds = {
	[1] = {
        skin=105,
        pos={2504.6899414062, -2640.1442871094, 13.86225605011},
        int=0,
        dim=0,
        rot=240,
        name="Antony -Garázs Mester-"
    },

    [2] = {
        skin=105,
        pos={80.820037841797, -232.24871826172, 1.578125},
        int=0,
        dim=0,
        rot=240,
        name="Antony -Garázs Mester-"
    }

    
}
destroyVehicleMarker = {2507.1672363281, -2626.8046875, 13.646421432495}

spawnPoses = {
--[[]	{2460.4709472656, -2619.5517578125, 14.270444869995, 268},
    {2461.1848144531, -2614.3918457031, 14.270415306091, 268},
    {2462.0239257812, -2609.2138671875, 14.271265029907, 268},
    {2462.4086914062, -2604.4111328125, 14.268838882446, 268},
    {2463.1760253906, -2598.8513183594, 14.276604652405, 268},
    {2463.0581054688, -2593.9467773438, 14.265171051025, 268},
    {2463.0383300781, -2589.138671875, 14.265244483948, 268},
    {2463.0148925781, -2584.0151367188, 14.264203071594, 268},]]

    {58.900115966797, -239.83071899414, 1.578125, 50}
}


spawnPoses_trailer = { --// X,Y,Z, ROT
	{103.72019958496, -283.57528686523, 1.578125, 0},--1
	{90.023681640625, -284.68984985352, 1.578125, 0},--2
	{77.383766174316, -284.30389404297, 1.578125, 0},--3
	{65.031829833984, -284.31369018555, 1.578125, 0},--4
	{52.031829833984, -284.31369018555, 1.578125, 0},--5
	{39.031829833984, -284.31369018555, 1.578125, 0},--6
}

jobMarkers = {
	{80.95556640625, -241.17646789551, 1.578125}, --BlueBerry Main Telephely 
}

packMarkers = {
    {2496.8449707031, -2083.2724609375, 13.546875, "oil"}, --Bal 1 kis tartály
	{2489.5646972656, -2083.2407226562, 13.546875, "oil"}, --Bal 2 kicsi
	{2482.201171875, -2083.2194824219, 13.546875, "oil"},--Bal 3
	{2475.287109375, -2083.2194824219, 13.546875, "oil"},--1
	{-172.53695678711, -276.31530761719, 1.7712646722794, false},
	{-173.15286254883, -261.91201782227, 1.6297509670258, false},
	{-173.13919067383, -289.07672119141, 1.6328908205032, false},

	{-131.02310180664, -339.42755126953, 1.4296875, false, true, 356},
}

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix (element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

--function getVehicleTypeFromShop(vehicle)
--	return exports.danihe_carshop:getVehicleTypeFromShop(vehicle)
--end

function getVehicleTypeFromShop(vehicle)
	return "Furgon"
end

allJobs = { --// Egyértelmű
	["Furgon"] = {
		{name="Szilva",payment={30000,50000},weight={50,350}},
		{name="Alma",payment={30000,50000},weight={50,350}},
		{name="Tej",payment={30000,50000},weight={50,350}},
		{name="Kecske Sajt",payment={30000,50000},weight={50,350}},
		{name="Kenyér",payment={30000,50000},weight={50,350}},
		{name="Méz",payment={30000,50000},weight={50,350}},
		{name="Tojás",payment={30000,50000},weight={50,350}},
		{name="Konzervek",payment={30000,50000},weight={50,350}},
		{name="Szerszámok",payment={30000,50000},weight={50,350}},
		{name="Csavarok",payment={30000,50000},weight={50,350}},
		{name="Műtágya",payment={30000,50000},weight={50,350}},
		{name="Friss hús",payment={30000,50000},weight={50,350}},
		{name="Pékárú",payment={30000,50000},weight={50,350}},
		{name="Használt Abroncsok",payment={30000,50000},weight={50,350}},
		{name="Jármű Alkatrészek",payment={30000,50000},weight={50,350}},
		{name="Üres Rekeszek",payment={30000,50000},weight={50,350}},
		{name="Zsákok",payment={30000,50000},weight={50,350}},
		{name="Dobozok",payment={30000,50000},weight={50,350}},
		{name="palackozott Víz",payment={30000,50000},weight={50,350}},
		{name="Liszt",payment={30000,50000},weight={50,350}},
		{name="Búza",payment={30000,50000},weight={50,350}},
		{name="Üdítő",payment={30000,50000},weight={50,350}},
		{name="Játékok",payment={30000,50000},weight={50,350}},
		{name="Illegális Rakomány",payment={50000,75000},weight={350,400}},--Illegális
	},
	["Egyterű"] = {
		{name="Pékárú",payment={50000,75000},weight={550,850}},
		{name="Használt Abroncsok",payment={50000,75000},weight={550,850}},
		{name="Jármű Alkatrészek",payment={50000,75000},weight={550,850}},
		{name="Üres Rekeszek",payment={50000,75000},weight={550,850}},
		{name="Zsákok",payment={50000,75000},weight={550,850}},
		{name="Dobozok",payment={50000,75000},weight={550,850}},
		{name="palackozott Víz",payment={50000,75000},weight={550,850}},
		{name="Liszt",payment={50000,75000},weight={550,850}},
		{name="Búza",payment={50000,75000},weight={550,850}},
		{name="Üdítő",payment={50000,75000},weight={550,850}},
		{name="Játékok",payment={50000,75000},weight={550,850}},
		{name="Méz",payment={50000,75000},weight={550,850}},
		{name="Kézi szerszámok",payment={50000,75000},weight={550,850}},
		{name="Használt Abroncsok",payment={50000,75000},weight={550,850}},
		{name="Új Abroncsok",payment={50000,75000},weight={550,850}},
		{name="Jármű alkatrészek",payment={50000,75000},weight={550,850}},
		{name="Csomagolt motorolaj",payment={50000,75000},weight={550,850}},
		{name="Csempe",payment={50000,75000},weight={550,850}},
		{name="Gipszkarton",payment={50000,75000},weight={550,850}},
		{name="Iratok",payment={50000,75000},weight={550,850}},
		{name="Cukor",payment={50000,75000},weight={550,850}},
		{name="Rizs",payment={50000,75000},weight={550,850}},
		{name="Szépségápolási Termékek",payment={50000,75000},weight={550,850}},
		{name="Felnik",payment={50000,75000},weight={550,850}},
		{name="Függönyök",payment={50000,75000},weight={550,850}},
		{name="Redőnyök",payment={50000,75000},weight={550,850}},
		{name="használt Akkumlátorok",payment={50000,75000},weight={550,850}},
		{name="Cement",payment={50000,75000},weight={550,850}},
		{name="Fa forgács",payment={50000,75000},weight={550,850}},
		{name="Vegyi Anyagok",payment={50000,75000},weight={550,850}},
		{name="Orvosi Berendezések",payment={50000,75000},weight={550,850}},
		{name="Olajos Rongyok",payment={50000,75000},weight={550,850}},
		{name="Kávé",payment={50000,75000},weight={550,850}},
		{name="Állat eledel",payment={50000,75000},weight={550,850}},
		{name="Vasháló",payment={50000,75000},weight={550,850}},
		{name="Ajtók",payment={50000,75000},weight={550,850}},
		{name="Műanyag elemek",payment={50000,75000},weight={550,850}},
		{name="Iskolai Tanszerek",payment={50000,75000},weight={550,850}},
		{name="Növények",payment={50000,75000},weight={550,850}},
		{name="Szekrények",payment={50000,75000},weight={550,850}},
		{name="Felnik",payment={50000,75000},weight={550,850}},
		{name="Zuhanytálcák",payment={50000,75000},weight={550,850}},
		{name="Illegális Rakomány",payment={75000,90000},weight={850,950}}, ---Illegális fuvar
	},
	["Kis Teher Autó"] = {
		{name="Ruházat",payment={75000,115000},weight={2500,3500}},
		{name="Pékárú",payment={75000,115000},weight={2500,3500}},
		{name="Használt Abroncsok",payment={75000,115000},weight={2500,3500}},
		{name="Jármű Alkatrészek",payment={75000,115000},weight={2500,3500}},
		{name="Üres Rekeszek",payment={75000,115000},weight={2500,3500}},
		{name="Zsákok",payment={75000,115000},weight={2500,3500}},
		{name="Dobozok",payment={75000,115000},weight={2500,3500}},
		{name="palackozott Víz",payment={75000,115000},weight={2500,3500}},
		{name="Liszt",payment={75000,115000},weight={2500,3500}},
		{name="Búza",payment={75000,115000},weight={2500,3500}},
		{name="Üdítő",payment={75000,115000},weight={2500,3500}},
		{name="Játékok",payment={75000,115000},weight={2500,3500}},
		{name="Méz",payment={75000,115000},weight={2500,3500}},
		{name="Kézi szerszámok",payment={75000,115000},weight={2500,3500}},
		{name="Használt Abroncsok",payment={75000,115000},weight={2500,3500}},
		{name="Új Abroncsok",payment={75000,115000},weight={2500,3500}},
		{name="Jármű alkatrészek",payment={75000,115000},weight={2500,3500}},
		{name="Csomagolt motorolaj",payment={75000,115000},weight={2500,3500}},
		{name="Csempe",payment={75000,115000},weight={2500,3500}},
		{name="Gipszkarton",payment={75000,115000},weight={2500,3500}},
		{name="Iratok",payment={75000,115000},weight={2500,3500}},
		{name="Cukor",payment={75000,115000},weight={2500,3500}},
		{name="Rizs",payment={75000,115000},weight={2500,3500}},
		{name="Szépségápolási Termékek",payment={75000,115000},weight={2500,3500}},
		{name="Felnik",payment={75000,115000},weight={2500,3500}},
		{name="Függönyök",payment={75000,115000},weight={2500,3500}},
		{name="Redőnyök",payment={75000,115000},weight={2500,3500}},
		{name="használt Akkumlátorok",payment={75000,115000},weight={2500,3500}},
		{name="Cement",payment={75000,115000},weight={2500,3500}},
		{name="Fa forgács",payment={75000,115000},weight={2500,3500}},
		{name="Vegyi Anyagok",payment={75000,115000},weight={2500,3500}},
		{name="Orvosi Berendezések",payment={75000,115000},weight={2500,3500}},
		{name="Olajos Rongyok",payment={75000,115000},weight={2500,3500}},
		{name="Kávé",payment={75000,115000},weight={2500,3500}},
		{name="Állat eledel",payment={75000,115000},weight={2500,3500}},
		{name="Vasháló",payment={75000,115000},weight={2500,3500}},
		{name="Ajtók",payment={75000,115000},weight={2500,3500}},
		{name="Műanyag elemek",payment={75000,115000},weight={2500,3500}},
		{name="Iskolai Tanszerek",payment={75000,115000},weight={2500,3500}},
		{name="Növények",payment={75000,115000},weight={2500,3500}},
		{name="Szekrények",payment={75000,115000},weight={2500,3500}},
		{name="Felnik",payment={75000,115000},weight={2500,3500}},
		{name="Zuhanytálcák",payment={75000,115000},weight={2500,3500}},
		{name="Illegális Rakomány",payment={95000,150000},weight={3500,3900}},
	},
	["Teher Autó"] = {
	    {name="Ruházat",payment={150000,250000},weight={12500,3500}},
		{name="Pékárú",payment={150000,250000},weight={2500,3500}},
		{name="Használt Abroncsok",payment={150000,250000},weight={2500,3500}},
		{name="Jármű Alkatrészek",payment={150000,250000},weight={2500,3500}},
		{name="Üres Rekeszek",payment={150000,250000},weight={2500,3500}},
		{name="Zsákok",payment={150000,250000},weight={2500,3500}},
		{name="Dobozok",payment={150000,250000},weight={2500,3500}},
		{name="palackozott Víz",payment={150000,250000},weight={2500,3500}},
		{name="Liszt",payment={150000,250000},weight={2500,3500}},
		{name="Búza",payment={150000,250000},weight={2500,3500}},
		{name="Üdítő",payment={150000,250000},weight={2500,3500}},
		{name="Játékok",payment={150000,250000},weight={2500,3500}},
		{name="Méz",payment={150000,250000},weight={2500,3500}},
		{name="Kézi szerszámok",payment={150000,250000},weight={2500,3500}},
		{name="Használt Abroncsok",payment={150000,250000},weight={2500,3500}},
		{name="Új Abroncsok",payment={150000,250000},weight={2500,3500}},
		{name="Jármű alkatrészek",payment={150000,250000},weight={2500,3500}},
		{name="Csomagolt motorolaj",payment={150000,250000},weight={2500,3500}},
		{name="Csempe",payment={150000,250000},weight={2500,3500}},
		{name="Gipszkarton",payment={150000,250000},weight={2500,3500}},
		{name="Iratok",payment={150000,250000},weight={2500,3500}},
		{name="Cukor",payment={150000,250000},weight={2500,3500}},
		{name="Rizs",payment={150000,250000},weight={2500,3500}},
		{name="Szépségápolási Termékek",payment={150000,250000},weight={2500,3500}},
		{name="Felnik",payment={150000,250000},weight={2500,3500}},
		{name="Függönyök",payment={150000,250000},weight={2500,3500}},
		{name="Redőnyök",payment={150000,250000},weight={2500,3500}},
		{name="használt Akkumlátorok",payment={150000,250000},weight={2500,3500}},
		{name="Cement",payment={150000,250000},weight={2500,3500}},
		{name="Fa forgács",payment={150000,250000},weight={2500,3500}},
		{name="Vegyi Anyagok",payment={150000,250000},weight={2500,3500}},
		{name="Orvosi Berendezések",payment={150000,250000},weight={2500,3500}},
		{name="Olajos Rongyok",payment={150000,250000},weight={2500,3500}},
		{name="Kávé",payment={150000,250000},weight={2500,3500}},
		{name="Állat eledel",payment={150000,250000},weight={2500,3500}},
		{name="Vasháló",payment={150000,250000},weight={2500,3500}},
		{name="Ajtók",payment={150000,250000},weight={2500,3500}},
		{name="Műanyag elemek",payment={150000,250000},weight={2500,3500}},
		{name="Iskolai Tanszerek",payment={150000,250000},weight={2500,3500}},
		{name="Növények",payment={150000,250000},weight={2500,3500}},
		{name="Szekrények",payment={150000,250000},weight={2500,3500}},
		{name="Felnik",payment={150000,250000},weight={2500,3500}},
		{name="Zuhanytálcák",payment={150000,250000},weight={2500,3500}},
		{name="Illegális Rakomány",payment={250000,300000},weight={3500,3900}}, ---Illegális fuvar
	},
	["Nyerges Vontató"] = {
		{name="Ruházat",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Pékárú",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Használt Abroncsok",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Jármű Alkatrészek",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Üres Rekeszek",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Zsákok",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Dobozok",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="palackozott Víz",payment={250000,350000},weight={30500,40000},trailer=435},
		{name="Liszt",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Búza",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Üdítő",payment={250000,350000},weight={30500,40000},trailer=435},
		{name="Játékok",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Méz",payment={250000,350000},weight={30500,40000},trailer=435},
		{name="Kézi szerszámok",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Használt Abroncsok",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Új Abroncsok",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Jármű alkatrészek",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Csomagolt motorolaj",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Csempe",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Gipszkarton",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Iratok",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Cukor",payment={250000,350000},weight={30500,40000},trailer=435},
		{name="Rizs",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Szépségápolási Termékek",payment={250000,350000},weight={30500,40000},trailer=435},
		{name="Felnik",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Függönyök",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Redőnyök",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="használt Akkumlátorok",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Cement",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Fa forgács",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Vegyi Anyagok",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Orvosi Berendezések",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Olajos Rongyok",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Kávé",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Állat eledel",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Vasháló",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Ajtók",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Műanyag elemek",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Iskolai Tanszerek",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Növények",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Szekrények",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Felnik",payment={250000,350000},weight={30500,40000},trailer=591},
		{name="Zuhanytálcák",payment={250000,350000},weight={30500,40000},trailer=450},
		{name="Illegális Rakomány",payment={350000,450000},weight={40000,45000},trailer=450}, ---Illegális fuvar
		{name="Illegális Rakomány",payment={350000,450000},weight={40000,45000},trailer=591}, ---Illegális fuvar
		{name="Nyersolaj",payment={250000,350000},weight={30500,40000},trailer=584},
		{name="Finomított olaj",payment={250000,350000},weight={30500,40000},trailer=584},
		{name="Gázolaj",payment={250000,350000},weight={30500,40000},trailer=584},
		{name="Benzin",payment={250000,350000},weight={30500,40000},trailer=584},
		{name="Kőolaj",payment={250000,350000},weight={30500,40000},trailer=584},
		{name="Motorolaj",payment={250000,350000},weight={30500,40000},trailer=584},
	},
}
function getJobsByType(type)
	local jobs = {}
	if allJobs[type] then
		for i = 1,math.random(2,8) do
			local v = allJobs[type][math.random(1,#allJobs[type])]
			if not v.trailer then v.trailer = false end
			jobs[i] = {
				name = v.name,
				payment = math.random(v.payment[1],v.payment[2]),
				weight = math.random(tonumber(v.weight[1]),tonumber(v.weight[2])),
				trailer = v.trailer,
			} 
		end
	end
	return jobs
end

finishJob = {
	[1] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {-1213.6689453125, 1830.7377929688, 41.9296875},
			rot = 313
		},

		marker = {
			pos={-1209.0494384766, 1840.6506347656, 41.71875},
			color={173, 255, 0, 100},
			size=2,
		}, --LV 
    },


	[2] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {-1271.7561035156, 2712.5786132812, 50.26628112793},
			rot = 125
		},

		marker = {
			pos={-1273.4344482422, 2731.4411621094, 50.0625},
			color={173, 255, 0, 100},
			size=2,
		}, --LV 
    },

	[3] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {-2518.9516601562, 2340.2185058594, 4.984375},
			rot = 182
		},

		marker = {
			pos={-2526.8266601562, 2363.4396972656, 4.9861855506897},
			color={173, 255, 0, 100},
			size=2,
		}, --Bayside
    },

	[4] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {-859.08245849609, 1536.392578125, 22.587043762207},
			rot = 331
		},

		marker = {
			pos={-859.41021728516, 1548.2204589844, 23.28987121582},
			color={173, 255, 0, 100},
			size=2,
		}, --LV 
    },

	[5] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {2379.3291015625, -2264.6791992188, 13.546875},
			rot = 317
		},

		marker = {
			pos={2367.4228515625, -2246.0554199219, 13.546875},
			color={173, 255, 0, 100},
			size=2,
		}, --Dokkok 
    },

	[6] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {2747.3232421875, -2451.1159667969, 13.6484375},
			rot = 358
		},

		marker = {
			pos={2749.2172851562, -2442.7038574219, 13.64318561554},
			color={173, 255, 0, 100},
			size=2,
		}, --Dokkok 
    },

	[7] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {854.01336669922, -603.99090576172, 18.421875},
			rot = 0
		}, 

		marker = {
			pos={844.95666503906, -596.19262695313, 18.292293548584},
			color={173, 255, 0, 100},
			size=2,
		}, --Dillimore 
    },

	[8] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {2270.7075195313, -2037.1883544922, 13.546875},
			rot = 0
		},

		marker = {
			pos={2249.0444335938, -2018.4083251953, 13.546875},
			color={173, 255, 0, 100},
			size=2,
		}, --LS Willowfield 
    },

	[9] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {1138.5971679688, -1202.0405273438, 18.99739265441},
			rot = 180
		},

		marker = {
			pos={1151.6705322266, -1212.2984619141, 18.66986656189},
			color={173, 255, 0, 100},
			size=2,
		}, --Hospital 
    },

	[10] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {2243.9011230469, -2246.9060058594, 14.764669418335},
			rot = 0
		},

		marker = {
			pos={2230.5026855469, -2240.5842285156, 13.554685592651},
			color={173, 255, 0, 100},
			size=2,
		}, --LS DEPO 
    },

	[11] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {1766.7191162109, -1705.12890625, 13.479452133179},
			rot = 0
		},

		marker = {
			pos={1783.1336669922, -1695.6926269531, 13.471839904785},
			color={173, 255, 0, 100},
			size=2,
		}, --Next to ls fuel 
    },

	[12] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {2710.2082519531, -2384.4301757813, 13.6328125},
			rot = 313
		},

		marker = {
			pos={2699.9641113281, -2391.8979492188, 13.6328125},
			color={173, 255, 0, 100},
			size=2,
		}, --Dokkok 
    },

	[13] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {2322.7685546875, -62.87663269043, 26.484375},
			rot = 87
		},

		marker = {
			pos={2316.3850097656, -74.900779724121, 26.484375},
			color={173, 255, 0, 100},
			size=2,
		}, --Palomino
    },

	[14] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {1324.1638183594, 287.09286499023, 20.045194625854},
			rot = 336
		},

		marker = {
			pos={1335.4018554688, 286.34725952148, 19.561452865601},
			color={173, 255, 0, 100},
			size=2,
		}, --Montgomery
    },

	[15] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {-2281.3876953125, 2288.466796875, 4.9666080474854},
			rot = 270
		},

		marker = {
			pos={-2263.2512207031, 2290.7109375, 4.8202133178711},
			color={173, 255, 0, 100},
			size=2,
		}, --Bayside 
    },

	[16] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {-2455.8718261719, 2253.8957519531, 4.9836072921753},
			rot = 89
		},

		marker = {
			pos={-2453.9462890625, 2232.2299804688, 4.84375},
			color={173, 255, 0, 100},
			size=2,
		}, --Bayside 
    },

	[17] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {1036.8177490234, -1339.4908447266, 13.7265625},
			rot = 0
		},

		marker = {
			pos={1016.5546264648, -1354.0754394531, 13.376981735229},
			color={173, 255, 0, 100},
			size=2,
		}, --Market 
    },

	[18] = {
		ped = {
			name="Áruátvétel",
			skin = 70,
			pos = {979.95831298828, -1296.5648193359, 13.546875},
			rot = 180
		},

		marker = {
			pos={973.53833007812, -1284.3903808594, 13.553998947144},
			color={173, 255, 0, 100},
			size=2,
		}, --Market 
    },

}
finishJob_oil = {
	[1] = {
		ped = {name="Áruátvétel",skin=70,pos={2348.9431152344, -1355.5014648438, 24.00625038147},rot=0},
		marker = {pos={2352.0915527344, -1370.1669921875, 24.00625038147},color={173,255,0,100},size=2},--nyugati
    },
	[2] = {
		ped = {name="Áruátvétel",skin=70,pos={ 1927.2407226563, -1767.2576904297, 13.388124465942},rot=0},
		marker = {pos={1927.1607666016, -1789.5065917969, 14.490614891052},color={173,255,0,100},size=2},--Déli
    },
	[3] = {
		ped = {name="Áruátvétel",skin=70,pos={-1623.8395996094, -2693.6469726563, 48.742660522461},rot=0},
		marker = {pos={-1612.9345703125, -2702.7575683594, 48.5390625},color={173,255,0,100},size=2},--whetston
    },
	[4] = {
		ped = {name="Áruátvétel",skin=70,pos={-2231.4204101563, -2558.2065429688, 31.921875},rot=0},
		marker = {pos={-2245.8835449219, -2567.2431640625, 31.921875},color={173,255,0,100},size=2},--AngelPine
    },
	[5] = {
		ped = {name="Áruátvétel",skin=70,pos={-1710.8944091797, 399.41189575195, 7.1872444152832},rot=0},
		marker = {pos={-1706.9050292969, 384.56201171875, 7.1872444152832},color={173,255,0,100},size=2},--SF
    },
	[6] = {
		ped = {name="Áruátvétel",skin=70,pos={-78.977317810059, -1169.6630859375, 2.1512889862061},rot=0},
		marker = {pos={-98.954307556152, -1167.1961669922, 2.6169638633728},color={173,255,0,100},size=2},--Határ utáni benya
    },
	[7] = {
		ped = {name="Áruátvétel",skin=70,pos={1382.6306152344, 464.8049621582, 20.202850341797},rot=0},
		marker = {pos={1360.1265869141, 476.24899291992, 20.2109375},color={173,255,0,100},size=2},--Montgomery
    },
	[8] = {
		ped = {name="Áruátvétel",skin=70,pos={-2419.0791015625, 969.85375976563, 45.296875},rot=0},
		marker = {pos={-2416.5034179688, 953.21466064453, 45.296875},color={173,255,0,100},size=2},--SF Belső
    },
	[9] = {
		ped = {name="Áruátvétel",skin=70,pos={663.44085693359, -566.70373535156, 16.3359375},rot=0},
		marker = {pos={653.88134765625, -583.68511962891, 16.328144073486},color={173,255,0,100},size=2},--DiliMore
    },

}