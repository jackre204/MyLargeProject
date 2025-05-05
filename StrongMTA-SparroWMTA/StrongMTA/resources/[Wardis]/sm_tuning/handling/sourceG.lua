local properties = {
	"mass",
	"turnMass",
	"dragCoeff",
	"centerOfMass",
	"percentSubmerged",
	"tractionMultiplier",
	"tractionLoss",
	"tractionBias",
	"numberOfGears",
	"maxVelocity",
	"engineAcceleration",
	"engineInertia",
	"driveType",
	"engineType",
	"brakeDeceleration",
	"brakeBias",
	"ABS",
	"steeringLock",
	"suspensionForceLevel",
	"suspensionDamping",
	"suspensionHighSpeedDamping",
	"suspensionUpperLimit",
	"suspensionLowerLimit",
	"suspensionFrontRearBias",
	"suspensionAntiDiveMultiplier",
	"seatOffsetDistance",
	"collisionDamageMultiplier",
	"monetary",
	"modelFlags",
	"handlingFlags",
	"headLight",
	"tailLight",
	"animGroup"
}

customHandling = {
	[550] = {
		mass = 1600,
		turnMass = 3550,
		dragCoeff = 2,
		centerOfMass = {0, 0.2, 0},
		percentSubmerged = 70,
		tractionMultiplier = 0.7,
		tractionLoss = 0.8,
		tractionBias = 0.52,
		numberOfGears = 5,
		maxVelocity = 180,
		engineAcceleration = 8,
		engineInertia = 5,
		driveType = "rwd",
		engineType = "petrol",
		brakeDeceleration = 5.4,
		brakeBias = 0.6,
		ABS = false,
		steeringLock = 30,
		suspensionForceLevel = 1.4,
		suspensionDamping = 1,
		suspensionHighSpeedDamping = 0,
		suspensionUpperLimit = 0.3,
		suspensionLowerLimit = -0.12,
		suspensionFrontRearBias = 0.55,
		suspensionAntiDiveMultiplier = 0,
		seatOffsetDistance = 0.26,
		collisionDamageMultiplier = 0.54,
		monetary = 19000,
		modelFlags = 40000000,
		handlingFlags = 1,
		headLight = 0,
		tailLight = 3,
		animGroup = 0
	},
	[525] = {
		engineAcceleration = 5,
		maxVelocity = 95,
		suspensionForceLevel = 1
	},
	[462] = {
		mass = 350,
		turnMass = 119.6,
		dragCoeff = 5,
		centerOfMass = {0, 0.05, -0.1},
		percentSubmerged = 103,
		tractionMultiplier = 1.9,
		tractionLoss = 0.95,
		tractionBias = 0.5,
		numberOfGears = 3,
		maxVelocity = 225,
		engineAcceleration = 5,
		engineInertia = 3,
		driveType = "rwd",
		engineType = "petrol",
		brakeDeceleration = 14,
		brakeBias = 0.5,
		ABS = false,
		steeringLock = 35,
		suspensionForceLevel = 1,
		suspensionDamping = 0.15,
		suspensionHighSpeedDamping = 0,
		suspensionUpperLimit = 0.12,
		suspensionLowerLimit = -0.17,
		suspensionFrontRearBias = 0.5,
		suspensionAntiDiveMultiplier = 0,
		seatOffsetDistance = 0,
		collisionDamageMultiplier = 0.11,
		monetary = 10000,
		modelFlags = 0,
		handlingFlags = 262155,
		headLight = 1,
		tailLight = 1,
		animGroup = 5
	}
}

textHandling = {
	[579] = "HUNTLEY 2500 6000 2.5 0 0 -0.2 80 0.62 0.89 0.5 5 100 8 25 4 p 7 0.45 false 35 1 0.05 0 0.45 -0.21 0.45 0.3 0.44 0.35 40000 20 4404 0 1 0",
	[576] = "TORNADO 1700 4166.4 2 0 0 0 70 0.75 0.75 0.52 4 160 8 10 r p 6 0.55 false 35 0.8 0.1 0 0.3 -0.15 0.5 0.25 0.3 0.52 19000 220000 2010000 1 1 0",
	[567] = "SAVANNA 1500 2500 2 0 0 -0.1 70 0.7 0.84 0.55 4 160 9.6 5 r p 8.17 0.52 false 35 0.8 0.04 0 0.3 -0.2 0.4 0.25 0.3 0.52 19000 200000 2010000 1 1 0",
	[492] = "GREENWOO 1600 4000 2.5 0 0 -0.2 70 0.7 0.8 0.52 4 160 8 20 r p 5.4 0.7 false 30 0.6 0.08 5 0.32 -0.25 0.5 0 0.22 0.54 19000 0 10000001 0 3 0",
	[542] = "CLOVER 1600 3000 2.2 0 0.3 0 70 0.65 0.8 0.52 4 130 6 6 r p 8 0.5 false 35 1 0.1 0 0.3 -0.1 0.5 0.25 0.25 0.52 19000 40280000 10008004 1 1 0",
	[527] = "CADRONA 1200 2000 2.2 0 0 -0.25 70 0.7 1 0.48 4 220 10 5 r p 8 0.6 false 30 1 0.12 0 0.3 -0.08 0.5 0 0.26 0.5 9000 40000000 2 0 0 0",
	[426] = "PREMIER 1600 3921.3 1.8 0 0 -0.2 75 0.75 0.85 0.52 5 200 8.8 10 r p 10 0.53 false 35 1.1 0.1 0 0.28 -0.12 0.38 0 0.2 0.24 25000 40000000 10200008 0 1 0",
	[400] = "LANDSTAL 1700 5008.3 2.5 0 0 -0.15 85 0.75 0.85 0.5 5 160 10 20 4 d 6.2 0.6 false 35 1 0.07 0 0.28 -0.2 0.5 0.25 0.27 0.23 25000 20 504402 0 1 0",
	[589] = "CLUB 1600 3500 2.8 0 0 -0.3 80 0.75 0.9 0.49 5 200 12 10 4 p 11 0.45 false 30 1 0.1 0 0.28 -0.12 0.5 0 0.25 0.5 35000 2000 C00000 1 1 0",
	[587] = "EUROS 1500 3500 2.2 0 0.3 -0.15 75 0.65 1 0.5 5 200 12 5 4 p 8 0.5 false 35 1 0.2 0 0.28 -0.1 0.5 0.3 0.25 0.6 35000 40002804 4000001 1 1 0",
	[580] = "STAFFORD 2200 6000 2.5 0 0 -0.15 75 0.65 0.92 0.5 5 210 11 15 4 p 5 0.55 false 30 1 0.1 0 0.27 -0.1 0.5 0.3 0.2 0.56 35000 0 400000 0 1 0",
	[566] = "TAHOMA 1800 4000 2.3 0 0 -0.3 75 0.75 0.85 0.52 5 160 9.6 10 r p 7 0.5 false 35 1 0.15 0 0.28 -0.2 0.5 0.3 0.25 0.6 35000 0 12010000 1 1 0",
	[529] = "WILLARD 1800 4350 2 0 0 -0.2 70 0.7 0.9 0.52 4 180 8 15 f p 5.4 0.6 false 30 1 0.15 0 0.32 -0.12 0.5 0 0.26 0.54 19000 40002000 0 0 3 0",
	[506] = "SUPERGT 1700 2800 2 0 -0.2 -0.24 70 0.75 1.1 0.4 5 240 15.5 5 r p 8 0.52 false 30 1 0.2 0 0.25 -0.1 0.5 0.3 0.4 0.54 105000 40002004 208000 0 0 1",
	[502] = "HOTRING 1600 4500 1.4 0 0.2 -0.4 70 0.85 1 0.47 5 200 10 5 r p 10 0.52 false 30 1.5 0.1 10 0.29 -0.08 0.6 0.4 0.2 0.56 45000 40002004 C00000 1 1 0",
	[458] = "SOLAIR 2000 5500 2 0 0 -0.3 75 0.75 0.8 0.48 4 165 8 10 r p 5 0.5 false 30 1 0.12 0 0.27 -0.18 0.5 0.2 0.24 0.48 18000 20 0 1 1 0",
	[451] = "TURISMO 1800 3000 2 0 -0.2 -0.2 70 0.75 0.85 0.45 5 240 14 10 4 p 9 0.51 false 30 1 0.09 0 0.15 -0.1 0.5 0.3 0.17 0.72 95000 40002004 C00401 1 1 1",
	[420] = "TAXI 1450 4056.4 2.2 0 0.2 -0.25 75 0.8 0.75 0.45 5 180 9 10 r p 9.1 0.6 false 35 1.3 0.15 0 0.25 -0.15 0.54 0 0.2 0.51 20000 200000 200000 0 1 0",
	[415] = "CHEETAH 1200 3000 2 0 0 -0.2 70 0.8 1.05 0.45 5 260 17 10 4 p 6 0.6 false 35 0.8 0.1 0 0.1 -0.1 0.5 0.6 0.4 0.54 105000 C0002004 208800 0 0 1",
	[411] = "INFERNUS 1400 2725.3 1.5 0 0 -0.25 70 0.7 0.95 0.45 5 240 9 10 4 p 5 0.7 false 30 1.2 0.19 0 0.25 -0.1 0.5 0.4 0.37 0.72 95000 40002004 C04000 1 1 1",
	[401] = "BRAVURA 1300 2200 1.7 0 0.3 0 70 0.65 0.8 0.52 5 160 6 10 r p 8 0.8 false 30 1.3 0.08 0 0.31 -0.08 0.57 0 0.26 0.5 9000 1 1 0 0 0",
	[491] = "VIRGO 1700 3435.4 2 0 0 -0.1 70 0.7 0.86 0.5 4 160 7.2 15 r p 7 0.5 false 32 1.5 0.1 0 0.31 -0.05 0.5 0.5 0.26 0.85 9000 40000000 10000000 0 0 0",
	[603] = "PHOENIX 1500 4000 2.2 0 0.3 -0.15 85 0.7 0.9 0.52 5 180 8 4 r p 6 0.55 false 30 0.8 0.08 0 0.28 -0.15 0.59 0.4 0.25 0.5 35000 2800 200000 1 1 0",
	[600] = "PICADOR 1600 3800 2.7 0 -0.2 0 75 0.65 0.7 0.52 5 135 8 20 r p 8.5 0.5 false 35 1 1 2 0.2 -0.03 0.4 0.4 0.26 0.2 26000 40202040 104004 0 1 0",
	[410] = "MANANA 1000 1400 2.8 0 0 0 70 0.8 0.8 0.5 3 140 6 13 f p 8 0.8 false 30 1.2 0.1 5 0.31 -0.06 0.5 0.2 0.26 0.5 9000 0 8000 0 0 0",
	[402] = "BUFFALO 1500 4000 2 0 0 -0.1 85 0.7 0.9 0.5 5 200 11.2 5 r p 11 0.45 false 30 1.2 0.12 0 0.28 -0.1 0.5 0.4 0.25 0.5 35000 2800 10200000 1 1 0",
	[438] = "CABBIE 1600 4000 2.1 0 0.025 -0.15 75 0.65 0.9 0.51 5 220 8.8 4 r p 7 0.44 false 35 0.9 0.1 3 0.225 -0.175 0.5 0.5 0.2 0.4 10000 0 0 1 1 0",
	[436] = "PREVION 1400 3000 2 0 0 -0.2 70 0.7 0.8 0.45 4 160 7.2 7 f p 8 0.65 false 35 1 0.08 2 0.31 -0.18 0.46 0.2 0.21 0.5 9000 220000 0 0 0 0",
	[602] = "ALPHA 1500 3400 2 0 -0.3 -0.2 85 0.7 0.8 0.45 5 200 11 5 r p 12 0.5 false 30 1.5 0.12 0 0.3 -0.05 0.45 0 0.25 0.5 35000 40002800 208800 1 1 0",
	[562] = "ELEGY 1500 3500 2.2 0 0.3 -0.15 75 0.65 0.9 0.5 5 200 11.2 5 r p 8 0.5 false 35 1 0.15 0 0.28 -0.1 0.5 0.3 0.25 0.6 35000 40000804 4000001 1 1 1",
	[559] = "JESTER 1500 3600 2.2 0 0 -0.05 75 0.85 0.8 0.5 5 200 11.2 10 r p 10 0.45 false 30 1.1 0.1 0 0.28 -0.15 0.5 0.3 0.25 0.6 35000 C0002804 4000000 1 1 1",
	[547] = "PRIMO 1600 3300 2.2 0 0 -0.15 70 0.7 0.8 0.54 4 160 7.2 7 f p 5.4 0.7 false 30 1.1 0.14 0 0.32 -0.14 0.5 0 0.26 0.54 19000 0 0 0 3 0",
	[526] = "FORTUNE 1700 4166.4 2 0 0 -0.2 70 0.7 0.84 0.53 4 190 9 10 r p 8.17 0.52 false 35 1.2 0.09 0 0.3 -0.05 0.4 0.25 0.3 0.52 19000 40000000 4 1 1 0",
	[477] = "ZR350 1400 2979.7 2 0 0.2 -0.1 70 0.8 0.8 0.51 5 210 12 11 r p 11.1 0.52 false 30 1.7 0.1 0 0.31 -0.05 0.5 0.3 0.24 0.6 45000 0 C00000 1 1 0",
	[470] = "PATRIOT 3500 7968.7 2.5 0 -0.2 0 80 0.7 0.8 0.5 5 170 6 30 4 p 8 0.5 false 30 1.5 0.1 4 0.35 -0.35 0.5 0 0.28 0.25 40000 8 300000 0 1 0",
	[475] = "SABRE 1700 4000 2 0 0.1 0 70 0.7 0.8 0.53 4 140 7 7 r p 8 0.52 false 35 1.3 0.08 5 0.3 -0.06 0.5 0.25 0.25 0.52 19000 0 10000006 1 1 0",
	[412] = "VOODOO 1800 4411.5 2 0 0.1 0 70 0.95 0.8 0.45 4 120 6 4 r p 6.5 0.5 false 30 0.8 0.08 0 0.1 -0.1 0.5 0.6 0.26 0.41 30000 0 2410008 1 1 0",
	[540] = "VINCENT 1400 3400 2.4 0 0.1 -0.1 75 0.8 0.8 0.5 5 200 11.2 5 4 p 10 0.5 false 30 1.2 0.15 0 0.28 -0.2 0.5 0.3 0.25 0.6 19000 2800 4000002 0 3 0",
	[545] = "HUSTLER 1500 4000 2 0 0 -0.1 85 0.7 0.9 0.5 5 190 7 5 r p 11 0.45 false 35 1.2 0.12 0 0.28 -0.07 0.5 0.4 0.25 0.5 20000 2000 808000 2 1 0",
	[494] = "HOTRING 1400 2998.3 2.25 0 0.1 -0.3 75 0.8 0.7 0.47 5 245 13 4 r p 15 0.45 false 30 1.3 0.15 0 0.28 -0.06 0.35 0.3 0.25 0.6 45000 40002004 C00000 1 1 0",
	[480] = "COMET 1400 2200 2.2 0 0.1 -0.2 75 0.7 0.9 0.5 5 200 12 10 r p 14 0.45 false 30 1.8 0.14 3 0.28 -0.07 0.5 0.3 0.25 0.6 35000 40002800 0 1 1 19",
	[597] = "POLICE_SF 1600 4500 2 0 -0.3 0 75 0.75 0.85 0.52 5 120 8 8 4 p 10 0.53 false 35 1.7 0.12 0 0.28 -0.14 0.55 0 0.2 0.24 25000 40000000 10200008 0 1 0",
	[478] = "WALTON 1850 3534 2.5 0 0 0 75 0.7 0.7 0.5 4 150 5.6 25 r d 6.5 0.5 false 35 1.6 0.12 0 0.35 -0.05 0.4 0 0.26 0.19 26000 40 10000006 1 1 0",
	[474] = "HERMES 1950 4712.5 2 0 0.3 0 70 0.7 0.75 0.51 5 160 9 15 r p 6 0.6 false 28 1.5 0.05 0 0.35 -0.07 0.58 0 0.25 0.42 19000 40002000 8001 1 3 0",
	[454] = "TROPIC 2200 29333.301 1 0 -1 0 35 2.2 12 0.45 5 250 0.25 5 r p 0.05 0.01 false 6 1.8 3 0 0.1 0.1 0 0 0.2 0.33 73000 8000000 0 0 1 0",
	[462] = "MOPED 350 119.6 5 0 0.05 -0.1 103 1.8 0.9 0.48 1 50 7 1 r p 14 0.5 false 35 1 0.15 0 0.12 -0.17 0.5 0 0 0.11 10000 1000000 0 1 1 5",
	[495] = "SANDKING 3000 6000 3 0 0.35 0 80 0.6 0.8 0.4 5 150 11 13 4 p 10 0.3 false 30 1 0.12 0 0.3 -0.3 0.5 0.5 0.44 0.3 40000 222000 400000 0 1 22",
	[529] = "WILLARD 1600 4500 2 0 0.3 -0.1 75 0.75 0.85 0.52 5 200 10 10 r p 10 0.53 false 35 1.6 3 0 0.28 -0.05 0.55 0 0.2 0.24 19000 40000000 200008 0 3 0",
	[598] = "POLICE_VG 1600 4500 2 0 0.3 -0.1 75 0.75 0.85 0.52 5 200 13 10 r p 10 0.53 false 35 1.6 3 0 0.28 -0.05 0.55 0 0.2 0.24 25000 40000000 208008 0 1 0",
	[541] = "BULLET 1200 2500 1.8 0 -0.15 -0.2 70 0.75 0.8 0.48 5 230 12 10 r p 8 0.58 false 30 2 0.13 5 0.25 -0.06 0.45 0.3 0.15 0.54 105000 C0002004 204000 0 0 1",
	[445] = "ADMIRAL 1650 3851.4 2 0 0 -0.05 75 0.65 0.9 0.51 5 165 8.8 8 r p 8.5 0.52 false 30 2 0.15 0 0.27 -0.12 0.5 0.55 0.2 0.56 35000 2000 400000 0 1 0",
	[518] = "BUCCANEE 1700 4500 2.2 0 0.3 0 70 0.6 0.86 0.54 4 160 9.6 15 r p 8 0.52 false 35 1.3 0.08 0 0.2 -0.035 0.5 0.4 0.3 0.52 19000 40620004 4004 1 1 1",
	[516] = "NEBULA 1400 4000 2 0 0.3 -0.1 75 0.65 0.8 0.5 5 180 9.5 10 4 p 10 0.55 false 35 1.4 0.1 0 0.27 -0.17 0.5 0.3 0.2 0.4 35000 2000 408401 0 1 0",
	[533] = "FELTZER 1600 4500 2 0 0.1 -0.15 75 0.85 0.8 0.49 5 210 12 2 4 p 6 0.6 false 35 1.4 0.7 0 0.3 -0.1 0.6 0.3 0.25 0.6 35000 40002800 0 1 1 19",
	[558] = "URANUS 1400 2998.3 2 0 0.1 -0.3 75 0.8 0.75 0.47 5 230 11 3 r p 15 0.45 false 30 1.3 0.15 0 0.28 -0.05 0.5 0.3 0.25 0.6 35000 C0002800 4000001 1 1 0",
	[404] = "PEREN 1200 3000 2.5 0 0.1 0 70 0.7 0.9 0.48 5 180 10 20 r p 15 0.6 false 30 2 0.1 0 0.37 -0.08 0.45 0 0.2 0.6 10000 2020 0 1 1 0",
	[503] = "HOTRING 1700 2800 2 0 -0.2 -0.24 70 0.75 0.88 0.4 5 240 16.5 5 r p 10 0.55 false 33 1.3 0.2 0 0.3 -0.05 0.45 0.3 0.4 0.4 45000 40202004 200200 1 1 0",
	[443] = "PACKER 8000 48273.301 2 0 0 0 90 0.65 0.85 0.35 5 110 2 6 r d 5.7 0.35 false 40 1.5 0.04 0 0.5 -0.01 0.5 0 0.56 0.4 20000 4000 440000 0 1 2",
	[575] = "BROADWAY 1700 4166.4 2 0 0.1 0.1 70 0.65 0.75 0.46 4 140 7 10 r p 6 0.55 false 25 1.1 0.07 0 0.3 -0.1 0.5 0.25 0.3 0.52 19000 220000 8000 1 1 0",
	[429] = "BANSHEE 1400 3000 2 0 0 -0.2 70 0.75 0.97 0.5 5 200 10 10 r p 15 0.52 false 34 1.6 0.1 5 0.3 -0.08 0.5 0.3 0.15 0.49 45000 2004 200000 1 1 1",
	[561] = "STRATUM 1500 3500 2.2 0 0.3 -0.15 75 0.65 0.9 0.5 5 190 9 5 r p 9 0.5 false 35 1 0.15 0 0.28 -0.08 0.55 0.3 0.25 0.6 35000 40000004 4004001 1 1 0",
	[573] = "DUNE 6750 50000 2 0 0 -0.5 90 0.5 0.7 0.5 5 115 5 100 r d 5 0.5 false 32 1.2 0.05 0 0.47 -0.17 0.5 0 0.62 0.43 40000 440808 200000 0 1 2"
}

for model, text in pairs(textHandling) do
	local words = split(text, " ")
	local propertyId = 0

	customHandling[model] = {}

	for i, value in ipairs(words) do
		if i ~= 1 then
			if i == 5 then
				customHandling[model].centerOfMass = {value}
			elseif i > 5 and i <= 7 then
				table.insert(customHandling[model].centerOfMass, value)

				if i == 7 then
					propertyId = propertyId + 1
				end
			elseif i == 16 then
				propertyId = propertyId + 1

				if value == "r" then
					customHandling[model][properties[propertyId]] = "rwd"
				elseif value == "f" then
					customHandling[model][properties[propertyId]] = "fwd"
				else
					customHandling[model][properties[propertyId]] = "awd"
				end
			elseif i == 17 then
				propertyId = propertyId + 1

				if value == "p" then
					customHandling[model][properties[propertyId]] = "petrol"
				elseif value == "d" then
					customHandling[model][properties[propertyId]] = "diesel"
				else
					customHandling[model][properties[propertyId]] = "electric"
				end
			else
				propertyId = propertyId + 1
				customHandling[model][properties[propertyId]] = value
			end
		end
	end
end

customFlags = {}
textFlag = {
	[566] = " ; ;DBL_EXHAUST; ",
	[529] = " ; ;DBL_EXHAUST; ",
	[420] = " ; ;AXLE_R_SOLID,; ",
	[600] = " ; ;DBL_EXHAUST; ",
	[410] = "WHEEL_R_WIDE2; ; ; ",
	[436] = " ; ;AXLE_F_SOLID,AXLE_R_SOLID; ",
	[602] = "WHEEL_R_WIDE2,WHEEL_F_WIDE2; ; ; ",
	[562] = " ; ; ;DBL_EXHAUST",
	[477] = "WHEEL_R_WIDE; ;AXLE_R_SOLID,DBL_EXHAUST; ",
	[470] = "OFFROAD_ABILITY, OFFROAD_ABILITY2; ;IS_BIG; ",
	[475] = "WHEEL_R_WIDE; ;DBL_EXHAUST; ",
	[438] = " ; ;DBL_EXHAUST; ",
	[412] = " ; ;DBL_EXHAUST; ",
	[559] = " ; ; ;DBL_EXHAUST",
	[540] = " ; ; ;DBL_EXHAUST",
	[599] = "WHEEL_F_NARROW,WHEEL_R_NARROW;WHEEL_F_WIDE2,WHEEL_R_WIDE2"
}

for model, text in pairs(textFlag) do
	local sections = split(text, ";")

	customFlags[model] = {
		addHandling = {},
		removeHandling = {},
		addModel = {},
		removeModel = {}
	}

	for i = 1, 4 do
		local section = sections[i]

		if section and utf8.len(section) > 1 then
			local flags = split(section, ",")

			for k, flag in pairs(flags) do
				flag = flag:gsub(" ", "")

				if utf8.len(flag) > 1 then
					if i == 1 then
						customFlags[model].addHandling[flag] = true
					elseif i == 2 then
						customFlags[model].removeHandling[flag] = true
					elseif i == 3 then
						customFlags[model].addModel[flag] = true
					elseif i == 4 then
						customFlags[model].removeModel[flag] = true
					end
				end
			end
		end
	end
end

local function setVehicleHandlingFlag(vehicle, flag, set)
	local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
	local originalBytes = flagBytes

	for k in pairs(flagsKeyed) do
		if string.find(k, flag) then
			flagBytes = flagBytes - handlingFlags[k]
		end
	end

	if set then
		flagBytes = flagBytes + handlingFlags[flag]
	end

	if originalBytes ~= flagBytes then
		setVehicleHandling(vehicle, "handlingFlags", flagBytes)
	end
end

local function setVehicleModelFlag(vehicle, flag, set)
	local flagsKeyed, flagBytes = getVehicleModelFlags(vehicle)
	local originalBytes = flagBytes

	for k in pairs(flagsKeyed) do
		if string.find(k, flag) then
			flagBytes = flagBytes - modelFlags[k]
		end
	end

	if set then
		flagBytes = flagBytes + modelFlags[flag]
	end

	if originalBytes ~= flagBytes then
		setVehicleHandling(vehicle, "modelFlags", flagBytes)
	end
end

function applyHandling(vehicle, exceptions)
	if isElement(vehicle) then
		local model = getElementModel(vehicle)

		if customHandling[model] then
			for property, value in pairs(customHandling[model]) do
				if (exceptions and exceptions[property]) or not exceptions then
					if value == "true" then
						setVehicleHandling(vehicle, property, true)
					elseif value == "false" then
						setVehicleHandling(vehicle, property, false)
					elseif property == "modelFlags" or property == "handlingFlags" then
						setVehicleHandling(vehicle, property, tonumber("0x" .. value))
					else
						setVehicleHandling(vehicle, property, value)
					end
				end
			end
		end

		if customFlags[model] and not exceptions then
			if customFlags[model].removeHandling then
				for flag in pairs(customFlags[model].removeHandling) do
					setVehicleHandlingFlag(vehicle, flag, false)
				end
			end

			if customFlags[model].addHandling then
				for flag in pairs(customFlags[model].addHandling) do
					setVehicleHandlingFlag(vehicle, flag, true)
				end
			end

			if customFlags[model].removeModel then
				for flag in pairs(customFlags[model].removeModel) do
					setVehicleModelFlag(vehicle, flag, false)
				end
			end

			if customFlags[model].addModel then
				for flag in pairs(customFlags[model].addModel) do
					setVehicleModelFlag(vehicle, flag, true)
				end
			end
		end

		local currHandlingFlags = getElementData(vehicle, "vehicle.handlingFlags") or 0
		local currModelFlags = getElementData(vehicle, "vehicle.modelFlags") or 0
		local currDriveType = getElementData(vehicle, "vehicle.tuning.DriveType")
		local currSteeringLock = getElementData(vehicle, "vehicle.tuning.SteeringLock") or 0

		if currHandlingFlags ~= 0 then
			setVehicleHandling(vehicle, "handlingFlags", currHandlingFlags)
		end

		if currModelFlags ~= 0 then
			setVehicleHandling(vehicle, "modelFlags", currModelFlags)
		end

		if currDriveType == "fwd" or currDriveType == "rwd" or currDriveType == "awd" then
			setVehicleHandling(vehicle, "driveType", currDriveType)
		elseif currDriveType == "tog" then
			local activeDriveType = getElementData(vehicle, "activeDriveType") or "awd"

			setVehicleHandling(vehicle, "driveType", activeDriveType)

			if activeDriveType == "awd" then
				setVehicleHandling(vehicle, "maxVelocity", getVehicleHandling(vehicle).maxVelocity * 0.65)
			end
		end

		if currSteeringLock ~= 0 then
			setVehicleHandling(vehicle, "steeringLock", currSteeringLock)
		end
	end
end

function getHandlingTable(model)
	if isElement(model) then
		model = getElementModel(model)
	end

	if customHandling[model] then
		return customHandling[model]
	else
		return getOriginalHandling(model)
	end

	return false
end

function getHandlingProperty(model, property)
	if isElement(model) then
		model = getElementModel(model)
	end

	if customHandling[model] then
		if customHandling[model][property] then
			return customHandling[model][property]
		else
			return getOriginalHandling(model)[property]
		end
	else
		return getOriginalHandling(model)[property]
	end

	return false
end
