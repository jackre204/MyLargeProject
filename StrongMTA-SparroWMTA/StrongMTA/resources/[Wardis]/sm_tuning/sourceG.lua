tuningPositions = {
	{1580.6815185547, -1868.3905029297, 9.3828125+1, 0},
	{1905.0252685547, -1437.9879150391, 13.457517623901, 0},
	{414.8173828125, 2454.6396484375, 14.5, 0},
	{112.24678039551, -83.910179138184, 1.2973227500916, 0},
	{1814.7537841797, -2485.3139648438, 13.279396057129, 0},
	{-566.49993896484, 633.68115234375, 16.708896636963, 0}
}

performacePositions = {
	{85.830032348633, -59.996322631836, 0.39792490005493 - 1, 0},
}

wheelStates = {
	0, 0.05, 0.1, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1
}

wheelSizes = {
	0, -0.55, -0.50, -0.45, -0.40, -0.35, -0.30, -0.25, -0.20, -0.15, -0.10, -0.05, 0.05, 0.1, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.8, 0.85, 0.9, 0.95, 1, 1.1, 1.2, 1.3, 1.4, 1.5
}

allWheelSizes = {
	0, -0.55, -0.50, -0.45, -0.40, -0.35, -0.30, -0.25, -0.20, -0.15, -0.10, -0.05, 0.05, 0.1, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.8, 0.85, 0.9, 0.95, 1, 1.1, 1.2, 1.3, 1.4, 1.5
}

doubleExhaust = {
	[579] = true,
}

componentOffsets = {
	wheel_lf_dummy = {4, 0.25, 0, 0, -0.25, 0},
	FrontBump0 = {-0.25, 4, 0.15, -0.25, 0, 0},
	RearBump0 = {0.25, -4, 0.25, 0.25, 0, 0},
	bonnet_dummy = {0, 4, 2, 0, 0, 0},
	exhaust_ok = {0, -5, 1, 0, 0, 0},
	door_rf_dummy = {4, -0.75, -0.25, 0, -0.75, -0.5},
	boot_dummy = {0, -4.5, 1.25, 0, -1, 0},
	boot_dummy_excomp = {0, -5.25, 2.5, 0, -1, 0}
}

tuningEffect = {
	Engine = {
		--engineAcceleration = {5, 10, 17.5, 30},
		maxVelocity = {15, 25, 35, 45, 60, 75, 80, 85, 100}
	},
	Turbo = {
		engineAcceleration = {5, 10, 17.5, 30, 35, 45, 50, 60},
		--dragCoeff = {-5, -10, -20, -30}
	},
	ECU = {
		engineAcceleration = {5, 10, 17.5, 30, 35, 45, 50, 60},
		--maxVelocity = {5, 10, 20, 30}
	},
	Transmission = {
		engineAcceleration = {5, 10, 17.5, 30, 35, 45, 50, 60},
		--maxVelocity = {5, 10, 20, 30}
	},
	Suspension = {
		suspensionDamping = {90, 180, 260, 350}
	},
	Brakes = {
		brakeDeceleration = {5, 10, 20, 30, 40, 65, 75, 85, 100}
	},
	Tires = {
		tractionLoss = {5, 10, 20, 30, 40, 50, 60, 70},
		tractionMultiplier = {5, 10, 20, 30, 35, 40, 55, 60}
	},
	WeightReduction = {
		tractionLoss = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8}
	}
}

handlingFlags = {
	_1G_BOOST = 0x1,
	_2G_BOOST = 0x2,
	NPC_ANTI_ROLL = 0x4,
	NPC_NEUTRAL_HANDL = 0x8,
	NO_HANDBRAKE = 0x10,
	STEER_REARWHEELS = 0x20,
	HB_REARWHEEL_STEER = 0x40,
	ALT_STEER_OPT = 0x80,
	WHEEL_F_NARROW2 = 0x100,
	WHEEL_F_NARROW = 0x200,
	WHEEL_F_WIDE = 0x400,
	WHEEL_F_WIDE2 = 0x800,
	WHEEL_R_NARROW2 = 0x1000,
	WHEEL_R_NARROW = 0x2000,
	WHEEL_R_WIDE = 0x4000,
	WHEEL_R_WIDE2 = 0x8000,
	HYDRAULIC_GEOM = 0x10000,
	HYDRAULIC_INST = 0x20000,
	HYDRAULIC_NONE = 0x40000,
	NOS_INST = 0x80000,
	OFFROAD_ABILITY = 0x100000,
	OFFROAD_ABILITY2 = 0x200000,
	HALOGEN_LIGHTS = 0x400000,
	PROC_REARWHEEL_1ST = 0x800000,
	USE_MAXSP_LIMIT = 0x1000000,
	LOW_RIDER = 0x2000000,
	STREET_RACER = 0x4000000,
	SWINGING_CHASSIS = 0x10000000
}

modelFlags = {
	IS_VAN = 0x1,
	IS_BUS = 0x2,
	IS_LOW = 0x4,
	IS_BIG = 0x8,
	REVERSE_BONNET = 0x10,
	HANGING_BOOT = 0x20,
	TALIGATE_BOOT = 0x40,
	NOSWING_BOOT = 0x80,
	NO_DOORS = 0x100,
	TANDEM_SEATS = 0x200,
	SIT_IN_BOAT = 0x400,
	CONVERTIBLE = 0x800,
	NO_EXHAUST = 0x1000,
	DBL_EXHAUST = 0x2000,
	NO1FPS_LOOK_BEHIND = 0x4000,
	FORCE_DOOR_CHECK = 0x8000,
	AXLE_F_NOTILT = 0x10000,
	AXLE_F_SOLID = 0x20000,
	AXLE_F_MCPHERSON = 0x40000,
	AXLE_F_REVERSE = 0x80000,
	AXLE_R_NOTILT = 0x100000,
	AXLE_R_SOLID = 0x200000,
	AXLE_R_MCPHERSON = 0x400000,
	AXLE_R_REVERSE = 0x800000,
	IS_BIKE = 0x1000000,
	IS_HELI = 0x2000000,
	IS_PLANE = 0x4000000,
	IS_BOAT = 0x8000000,
	BOUNCE_PANELS = 0x10000000,
	DOUBLE_RWHEELS = 0x20000000,
	FORCE_GROUND_CLEARANCE = 0x40000000,
	IS_HATCHBACK = 0x80000000
}

componentNames = {
	[1025] = "Zender Dynamic",
	[1073] = "WedsSport TC105N",
	[1074] = "Vossen 305T",
	[1075] = "Ronal Turbo",
	[1076] = "Dayton 100 Spoke",
	[1077] = "Hamann Edition Race",
	[1078] = "Dunlop Drag",
	[1079] = "BBS Stance",
	[1080] = "Advan Racing RGII",
	[1081] = "Classic",
	[1082] = "Volk Racing TE37",
	[1083] = "Dub Bigchips",
	[1084] = "Borbet A",
	[1085] = "BBS RS",
	[1096] = "Fifteen52",
	[1097] = "AMG Monoblock",
	[1098] = "American Racing"
}

function isFlagSet(val, flag)
	return (bitAnd(val, flag) == flag)
end

function getVehicleHandlingFlags(vehicle)
	local flagBytes = getVehicleHandling(vehicle).handlingFlags
	local flagKeyed = {}

	for k, v in pairs(handlingFlags) do
		if isFlagSet(flagBytes, v) then
			flagKeyed[k] = true
		end
	end

	return flagKeyed, flagBytes
end

function getVehicleModelFlags(vehicle)
	local flagBytes = getVehicleHandling(vehicle).modelFlags
	local flagKeyed = {}

	for k, v in pairs(modelFlags) do
		if isFlagSet(flagBytes, v) then
			flagKeyed[k] = true
		end
	end

	return flagKeyed, flagBytes
end

tuningContainer = {
	[1] = {
		name = "Optika",
		icon = "files/icons/optika.png",
		subMenu = {
			[1] = {
				name = "Első lökhárító",
				icon = "files/icons/optical/elso.png",
				priceType = "money",
				price = 1000,
				camera = "FrontBump0",
				upgradeSlot = "FrontBump",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end,

				--[[serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Engine", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningEngine = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,]]
			},
			[2] = {
				name = "Hátsó lökhárító",
				icon = "files/icons/optical/hatso.png",
				priceType = "money",
				price = 1000,
				camera = "RearBump0",
				upgradeSlot = "RearBump",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Küszöb",
				icon = "files/icons/optical/kuszob.png",
				priceType = "money",
				price = 1000,
				camera = "door_rf_dummy",
				upgradeSlot = "SideSkirts",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Motorháztető",
				icon = "files/icons/optical/motorhaz.png",
				priceType = "money",
				price = 1000,
				camera = "bonnet_dummy",
				upgradeSlot = "Bonnets",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[5] = {
				name = "Légterelő",
				icon = "files/icons/optical/legterelo.png",
				priceType = "money",
				price = 1500,
				camera = "boot_dummy_excomp",
				upgradeSlot = "Spoilers",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[6] = {
				name = "Első sárvédő",
				icon = "files/icons/optical/tetolegterelo.png",
				priceType = "money",
				price = 1000,
				upgradeSlot = "FrontFends",
				camera = "door_rf_dummy",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[7] = {
				name = "Hátsó sárvédő",
				icon = "files/icons/optical/tetolegterelo.png",
				priceType = "money",
				price = 1000,
				upgradeSlot = "RearFends",
				camera = "door_rf_dummy",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[8] = {
				name = "Teljes sárvédők",
				icon = "files/icons/optical/kuszob.png",
				priceType = "money",
				price = 1000,
				camera = "door_rf_dummy",
				upgradeSlot = "AllFends",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[9] = {
				name = "Első lámpák",
				icon = "files/icons/optical/hatsolampa.png",
				priceType = "money",
				price = 1000,
				camera = "FrontBump0",
				upgradeSlot = "FrontLights",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[10] = {
				name = "Hátsó lámpák",
				icon = "files/icons/optical/hatsolampa.png",
				priceType = "money",
				price = 1000,
				camera = "RearBump0",
				upgradeSlot = "RearLights",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[11] = {
				name = "Kipufogó",
				icon = "files/icons/optical/kipufogo.png",
				priceType = "money",
				price = 1000,
				camera = "RearBump0",
				upgradeSlot = "Exhaust",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[12] = {
				name = "Splitter",
				icon = "files/icons/misc.png",
				priceType = "money",
				price = 1000,
				camera = "base",
				upgradeSlot = "Splitter",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[13] = {
				name = "Első lökhárító sárvédő",
				icon = "files/icons/misc.png",
				priceType = "money",
				price = 1000,
				camera = "base",
				upgradeSlot = "FrontDef",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[14] = {
				name = "Tető",
				icon = "files/icons/misc.png",
				priceType = "money",
				price = 1000,
				camera = "base",
				upgradeSlot = "Roof",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},


			[15] = {
				name = "Extrák",
				icon = "files/icons/misc.png",
				priceType = "money",
				price = 1000,
				camera = "base",
				upgradeSlot = "Acces",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},

			[16] = {
				name = "Izzó szín",
				icon = "files/icons/optical/izzo.png",
				priceType = "money",
				price = 2500,
				id = "color",
				id2 = "headLightColor",
				camera = "lightpaint",
				subMenu = {
					[1] = {
						name = "Izzó szín",
						icon = "files/icons/optical/izzo.png",
						colorPicker = true,
						colorId = 5,
						priceType = "money",
						price = 2500
					}
				}
			},

			[17] = {
				name = "Neon",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "door_rf_dummy",
				id = "neon",
				subMenu = {
					[1] = {
						name = "Piros",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14399
					},
					[2] = {
						name = "Kék",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14400
					},
					[3] = {
						name = "Zöld",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14401
					},
					[4] = {
						name = "Citromsárga",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14402
					},
					[5] = {
						name = "Rózsaszín",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14403
					},
					[6] = {
						name = "Fehér",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14404
					},
					[7] = {
						name = "Eltávolítás",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "tuning.neon", value)
					setElementData(vehicle, "tuning.neon.state", 0)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if neonId == value then
						return true
					else
						return false
					end
				end
			},

			[18] = {
				name = "Air-Ride",
				icon = "files/icons/optical/airride.png",
				priceType = "money",
				price = 20000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/optical/airride.png",
						priceType = "money",
						price = 20000,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/optical/airride.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local currUpgrades = (getElementData(vehicle, "vehicle.tuning.Optical") or ""):gsub("1087,", "")
					local hydraulicsUpgrade = getVehicleUpgradeOnSlot(vehicle, 9)

					if hydraulicsUpgrade then
						removeVehicleUpgrade(vehicle, hydraulicsUpgrade)
					end

					setElementData(vehicle, "vehicle.tuning.AirRide", value)
					setElementData(vehicle, "vehicle.tuning.Optical", currUpgrades)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningAirRide = ?, tuningOptical = ? WHERE vehicleId = ?", value, currUpgrades, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.AirRide") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},

			[19] = {
				name = "Spinner",
				icon = "files/icons/spinner.png",
				priceType = "premium",
				price = 1000,
				camera = "base",
				isSpinner = true,
				subMenu = {
					[1] = {
						name = "1. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 4812
					},
					[2] = {
						name = "1. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 4813,
						colorPicker = true,
						colorId = 6
					},
					[3] = {
						name = "2. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 4814
					},
					[4] = {
						name = "2. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 4817,
						colorPicker = true,
						colorId = 6
					},
					[5] = {
						name = "3. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 4816
					},
					[6] = {
						name = "3. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 4815,
						colorPicker = true,
						colorId = 6
					},
					[7] = {
						name = "4. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 4818
					},
					[8] = {
						name = "4. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 4819,
						colorPicker = true,
						colorId = 6
					},
					[9] = {
						name = "Leszerel",
						icon = "files/icons/spinner.png",
						priceType = "free",
						price = 0,
						isSpinnerItem = true,
						value = false
					}
				},
				clientFunction = function (vehicle, value)
					if exports.sm_spinner:getOriginalSpinner() == value then
						return true
					else
						return false
					end
				end
			},

			[20] = {
				name = "Első felni",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "wheel_lf_dummy",
				id = "frontWheel",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 0
					},

					[2] = {
						name = "#1",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 2
					},
					[3] = {
						name = "#2",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 3
					},
					[4] = {
						name = "#3",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 4
					},
					[5] = {
						name = "#4",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 5
					},
					[6] = {
						name = "#5",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6
					},
					[7] = {
						name = "#6",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7
					},
					[8] = {
						name = "#8",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8
					},
					[9] = {
						name = "#9",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 9
					},
					[10] = {
						name = "#10",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 10
					},
					[11] = {
						name = "#11",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 11
					},
					[12] = {
						name = "#12",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 12
					},
					[13] = {
						name = "#13",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 13
					},
					[14] = {
						name = "#14",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14
					},
					[15] = {
						name = "#15",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 15
					},
					[16] = {
						name = "#16",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 16
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "WheelsF", value)

					--if vehicleId then
						--dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					--end

					return true
				end,
				clientFunction = function (vehicle, value)
					if fWheelID == value then
						return true
					else
						return false
					end
				end
			},

			[21] = {
				name = "Első felni dőlése",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "wheel_lf_dummy",
				id = "frontWheelTilt",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 1
					},

					[2] = {
						name = "5 °",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 2
					},
					[3] = {
						name = "10°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 3
					},
					[4] = {
						name = "15°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 4
					},
					[5] = {
						name = "20°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 5
					},
					[6] = {
						name = "25°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6
					},
					[7] = {
						name = "30°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7
					},
					[8] = {
						name = "35°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8
					},
					[9] = {
						name = "40°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 9
					},
					[10] = {
						name = "45°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 10
					},
					[11] = {
						name = "50°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 11
					},
					[12] = {
						name = "55°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 12
					},
					[13] = {
						name = "60°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 13
					},
					[14] = {
						name = "65°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14
					},
					[15] = {
						name = "70°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 15
					},
					[16] = {
						name = "75°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 16
					},
					[17] = {
						name = "80°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 17
					},
					[18] = {
						name = "85°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 18
					},
					[19] = {
						name = "90°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 19
					},
					[20] = {
						name = "95°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 20
					},

					[21] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 21
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "WheelsAngleF", tonumber(wheelStates[value]))

					--if vehicleId then
						--dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					--end

					return true
				end,
				clientFunction = function (vehicle, value)
					if fWheelTiltID == wheelStates[value] then
						return true
					else
						return false
					end
				end
			},

			[22] = {
				name = "Első felni szélessége",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "wheel_lf_dummy",
				id = "frontWheelSize",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 1
					},

					[2] = {
						name = "5 °",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 2
					},
					[3] = {
						name = "10°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 3
					},
					[4] = {
						name = "15°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 4
					},
					[5] = {
						name = "20°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 5
					},
					[6] = {
						name = "25°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6
					},
					[7] = {
						name = "30°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7
					},
					[8] = {
						name = "35°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8
					},
					[9] = {
						name = "40°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 9
					},
					[10] = {
						name = "45°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 10
					},
					[11] = {
						name = "50°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 11
					},
					[12] = {
						name = "55°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 12
					},
					[13] = {
						name = "60°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 13
					},
					[14] = {
						name = "65°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14
					},
					[15] = {
						name = "70°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 15
					},
					[16] = {
						name = "75°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 16
					},
					[17] = {
						name = "80°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 17
					},
					[18] = {
						name = "85°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 18
					},
					[19] = {
						name = "90°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 19
					},
					[20] = {
						name = "95°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 20
					},

					[21] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 21
					},

					[22] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 22
					},

					[23] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 23
					},

					[24] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 24
					},

					[25] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 25
					},

					[26] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 26
					},

					[27] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 27
					},

					[28] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 28
					},

					[29] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 29
					},

					[30] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 30
					},

					[31] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 31
					},

					[32] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 32
					},

					[33] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 33
					},

					[34] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 34
					},

					[35] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 35
					},

					[36] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 36
					},

					[37] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 37
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "WheelsWidthF", tonumber(wheelSizes[value]))

					--if vehicleId then
						--dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					--end

					return true
				end,
				clientFunction = function (vehicle, value)
					if fWheelSizeID == wheelSizes[value] then
						return true
					else
						return false
					end
				end
			},

			[23] = {
				name = "Hátsó felni",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "door_rf_dummy",
				id = "reverseWheel",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 0
					},

					[2] = {
						name = "#1",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 2
					},
					[3] = {
						name = "#2",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 3
					},
					[4] = {
						name = "#3",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 4
					},
					[5] = {
						name = "#4",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 5
					},
					[6] = {
						name = "#5",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6
					},
					[7] = {
						name = "#6",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7
					},
					[8] = {
						name = "#8",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8
					},
					[9] = {
						name = "#9",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 9
					},
					[10] = {
						name = "#10",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 10
					},
					[11] = {
						name = "#11",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 11
					},
					[12] = {
						name = "#12",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 12
					},
					[13] = {
						name = "#13",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 13
					},
					[14] = {
						name = "#14",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14
					},
					[15] = {
						name = "#15",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 15
					},
					[16] = {
						name = "#16",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 16
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "WheelsR", value)

					--if vehicleId then
						--dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					--end

					return true
				end,
				clientFunction = function (vehicle, value)
					if rWheelID == value then
						return true
					else
						return false
					end
				end
			},

			[24] = {
				name = "Hátsó felni dőlése",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "door_rf_dummy",
				id = "reverseWheelTilt",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 1
					},

					[2] = {
						name = "5 °",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 2
					},
					[3] = {
						name = "10°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 3
					},
					[4] = {
						name = "15°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 4
					},
					[5] = {
						name = "20°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 5
					},
					[6] = {
						name = "25°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6
					},
					[7] = {
						name = "30°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7
					},
					[8] = {
						name = "35°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8
					},
					[9] = {
						name = "40°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 9
					},
					[10] = {
						name = "45°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 10
					},
					[11] = {
						name = "50°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 11
					},
					[12] = {
						name = "55°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 12
					},
					[13] = {
						name = "60°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 13
					},
					[14] = {
						name = "65°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14
					},
					[15] = {
						name = "70°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 15
					},
					[16] = {
						name = "75°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 16
					},
					[17] = {
						name = "80°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 17
					},
					[18] = {
						name = "85°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 18
					},
					[19] = {
						name = "90°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 19
					},
					[20] = {
						name = "95°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 20
					},

					[21] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 21
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "WheelsAngleR", tonumber(wheelStates[value]))

					--if vehicleId then
						--dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					--end

					return true
				end,
				clientFunction = function (vehicle, value)
					if rWheelTiltID == wheelStates[value] then
						return true
					else
						return false
					end
				end
			},

			[25] = {
				name = "Hátsó felni szélessége",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "wheel_lf_dummy",
				id = "rearWheelSize",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 1
					},

					[2] = {
						name = "5 °",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 2
					},
					[3] = {
						name = "10°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 3
					},
					[4] = {
						name = "15°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 4
					},
					[5] = {
						name = "20°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 5
					},
					[6] = {
						name = "25°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6
					},
					[7] = {
						name = "30°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7
					},
					[8] = {
						name = "35°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8
					},
					[9] = {
						name = "40°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 9
					},
					[10] = {
						name = "45°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 10
					},
					[11] = {
						name = "50°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 11
					},
					[12] = {
						name = "55°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 12
					},
					[13] = {
						name = "60°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 13
					},
					[14] = {
						name = "65°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14
					},
					[15] = {
						name = "70°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 15
					},
					[16] = {
						name = "75°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 16
					},
					[17] = {
						name = "80°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 17
					},
					[18] = {
						name = "85°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 18
					},
					[19] = {
						name = "90°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 19
					},
					[20] = {
						name = "95°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 20
					},

					[21] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 21
					},

					[22] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 22
					},

					[23] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 23
					},

					[24] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 24
					},

					[25] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 25
					},

					[26] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 26
					},

					[27] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 27
					},

					[28] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 28
					},

					[29] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 29
					},

					[30] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 30
					},

					[31] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 31
					},

					[32] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 32
					},

					[33] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 33
					},

					[34] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 34
					},

					[35] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 35
					},

					[36] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 36
					},

					[37] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 37
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "WheelsWidthR", tonumber(wheelSizes[value]))

					--if vehicleId then
						--dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					--end

					return true
				end,
				clientFunction = function (vehicle, value)
					if rWheelSizeID == wheelSizes[value] then
						return true
					else
						return false
					end
				end
			},

			[26] = {
				name = "Felni méretezés",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "wheel_lf_dummy",
				id = "allWheelSize",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 1
					},

					[2] = {
						name = "5 °",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 2
					},
					[3] = {
						name = "10°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 3
					},
					[4] = {
						name = "15°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 4
					},
					[5] = {
						name = "20°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 5
					},
					[6] = {
						name = "25°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6
					},
					[7] = {
						name = "30°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7
					},
					[8] = {
						name = "35°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8
					},
					[9] = {
						name = "40°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 9
					},
					[10] = {
						name = "45°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 10
					},
					[11] = {
						name = "50°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 11
					},
					[12] = {
						name = "55°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 12
					},
					[13] = {
						name = "60°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 13
					},
					[14] = {
						name = "65°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 14
					},
					[15] = {
						name = "70°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 15
					},
					[16] = {
						name = "75°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 16
					},
					[17] = {
						name = "80°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 17
					},
					[18] = {
						name = "85°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 18
					},
					[19] = {
						name = "90°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 19
					},
					[20] = {
						name = "95°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 20
					},

					[21] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 21
					},

					[22] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 22
					},

					[23] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 23
					},

					[24] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 24
					},

					[25] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 25
					},

					[26] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 26
					},

					[27] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 27
					},

					[28] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 28
					},

					[29] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 29
					},

					[30] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 30
					},

					[31] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 31
					},

					[32] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 32
					},

					[33] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 33
					},

					[34] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 34
					},

					[35] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 35
					},

					[36] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 36
					},

					[37] = {
						name = "100°",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 37
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "WheelsSize", tonumber(allWheelSizes[value]))

					--if vehicleId then
						--dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					--end

					return true
				end,
				clientFunction = function (vehicle, value)
					if wheelsSizeID == allWheelSizes[value] then
						return true
					else
						return false
					end
				end
			},


			
		--[[	[7] = {
				name = "Kerekek",
				icon = "files/icons/optical/felni.png",
				priceType = "money",
				isTheWheelTuning = true,
				price = 5000,
				upgradeSlot = 12,
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[8] = {
				name = "Kipufogó",
				icon = "files/icons/optical/kipufogo.png",
				priceType = "money",
				price = 2000,
				upgradeSlot = 13,
				camera = "exhaust_ok",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[9] = {
				name = "Hidraulika",
				icon = "files/icons/optical/hidra.png",
				priceType = "money",
				price = 15000,
				upgradeSlot = 9,
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			
			
			
			]]
		}
	},
	[2] = {
		name = "Fényezés",
		icon = "files/icons/fenyezes.png",
		subMenu = {
			[1] = {
				name = "Szín 1",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 1,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[2] = {
				name = "Szín 2",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 2,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[3] = {
				name = "Szín 3",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 3,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[4] = {
				name = "Szín 4",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 4,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[5] = {
				name = "Kilóméteróra 1",
				icon = "files/icons/speedo.png",
				id = "color",
				colorPicker = true,
				colorId = 7,
				priceType = "money",
				price = 2500,
				subMenu = false
			},
			[6] = {
				name = "Kilóméteróra 2",
				icon = "files/icons/speedo.png",
				id = "color",
				colorPicker = true,
				colorId = 8,
				priceType = "money",
				price = 2500,
				subMenu = false
			}
		}
	},
	[3] = {
		name = "Extrák",
		icon = "files/icons/extra.png",
		subMenu = {
			[1] = {
				name = "LSD ajtó",
				icon = "files/icons/optical/lsd.png",
				camera = "base",
				id = "door",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/lsd.png",
						priceType = "premium",
						price = 1000,
						value = "scissor"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/lsd.png",
						priceType = "free",
						price = 0,
						value = nil
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.DoorType", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningDoorType = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if originalDoor == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Lámpa csere",
				icon = "files/icons/optical/hatsolampa.png",
				id = "headlight",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalHeadLight == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Paintjob",
				icon = "files/icons/fenyezes.png",
				id = "paintjob",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalPaintjob == value then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Kerék paintjob",
				icon = "files/icons/fenyezes.png",
				id = "wheelPaintjob",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalWheelPaintjob == value then
						return true
					else
						return false
					end
				end
			},
			[5] = {
				name = "Első kerék szélessége",
				icon = "files/icons/optical/gumiszelesseg.png",
				camera = "bump_front_dummy",
				id = "handling",
				handlingPrefix = "WHEEL_F_",
				subMenu = {
					[1] = {
						name = "Extra keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NARROW2"
					},
					[2] = {
						name = "Keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 7500,
						value = "NARROW"
					},
					[3] = {
						name = "Normál",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NORMAL"
					},
					[4] = {
						name = "Széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 15000,
						value = "WIDE"
					},
					[5] = {
						name = "Extra széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 25000,
						value = "WIDE2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "WHEEL_F_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["WHEEL_F_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = originalHandling
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["WHEEL_F_NARROW2"]) then
						activeFlag = "NARROW2"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_NARROW"]) then
						activeFlag = "NARROW"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_WIDE"]) then
						activeFlag = "WIDE"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_WIDE2"]) then
						activeFlag = "WIDE2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[6] = {
				name = "Hátsó kerék szélessége",
				icon = "files/icons/optical/gumiszelesseg.png",
				camera = "RearBump0",
				id = "handling",
				handlingPrefix = "WHEEL_R_",
				subMenu = {
					[1] = {
						name = "Extra keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NARROW2"
					},
					[2] = {
						name = "Keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 7500,
						value = "NARROW"
					},
					[3] = {
						name = "Normál",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NORMAL"
					},
					[4] = {
						name = "Széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 15000,
						value = "WIDE"
					},
					[5] = {
						name = "Extra széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 25000,
						value = "WIDE2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "WHEEL_R_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["WHEEL_R_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = originalHandling
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["WHEEL_R_NARROW2"]) then
						activeFlag = "NARROW2"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_NARROW"]) then
						activeFlag = "NARROW"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_WIDE"]) then
						activeFlag = "WIDE"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_WIDE2"]) then
						activeFlag = "WIDE2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[7] = {
				name = "Meghajtás",
				icon = "files/icons/optical/meghajtas.png",
				subMenu = {
					[1] = {
						name = "Elsőkerék (FWD)",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "fwd"
					},
					[2] = {
						name = "Összkerék (AWD)",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "awd"
					},
					[3] = {
						name = "Hátsókerék (RWD)",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "rwd"
					},
					[4] = {
						name = "Kapcsolható (RWD/AWD)",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 50000,
						value = "tog"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					if value == "tog" then
						setVehicleHandling(vehicle, "driveType", "awd")
						setElementData(vehicle, "activeDriveType", "awd")
					else
						setVehicleHandling(vehicle, "driveType", value)
					end

					setElementData(vehicle, "vehicle.tuning.DriveType", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningDriveType = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.DriveType")

					if not current then
						current = getVehicleHandling(vehicle).driveType
					end

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[8] = {
				name = "Fordulókör",
				icon = "files/icons/slock.png",
				subMenu = {
					[1] = {
						name = "30°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 30
					},
					[2] = {
						name = "40°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 40
					},
					[3] = {
						name = "50°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 50
					},
					[4] = {
						name = "60°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 60
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setVehicleHandling(vehicle, "steeringLock", value)
					setElementData(vehicle, "vehicle.tuning.SteeringLock", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningSteeringLock = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if getVehicleHandling(vehicle).steeringLock == value then
						return true
					else
						return false
					end
				end
			},
			[9] = {
				name = "Önzáró differenciálmű",
				icon = "files/icons/diff.png",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/diff.png",
						priceType = "money",
						price = 10500,
						value = "SOLID"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/diff.png",
						priceType = "money",
						price = 10500,
						value = "NORMAL"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleModelFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "AXLE_R_") then
							flagBytes = flagBytes - modelFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + modelFlags["AXLE_R_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "modelFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.modelFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET modelFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = getVehicleHandling(vehicle).modelFlags
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, modelFlags["AXLE_R_SOLID"]) then
						activeFlag = "SOLID"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[10] = {
				name = "Offroad optimalizáció",
				icon = "files/icons/optical/offroad.png",
				subMenu = {
					[1] = {
						name = "Nincs optimalizálva",
						icon = "files/icons/optical/offroad.png",
						priceType = "free",
						price = 0,
						value = "NORMAL"
					},
					[2] = {
						name = "Terep beállítás",
						icon = "files/icons/optical/offroad.png",
						priceType = "money",
						price = 20000,
						value = "ABILITY"
					},
					[3] = {
						name = "Murva beállítás",
						icon = "files/icons/optical/offroad.png",
						priceType = "money",
						price = 20000,
						value = "ABILITY2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "OFFROAD_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["OFFROAD_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = getVehicleHandling(vehicle).handlingFlags
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["OFFROAD_ABILITY"]) then
						activeFlag = "ABILITY"
					elseif isFlagSet(flagBytes, handlingFlags["OFFROAD_ABILITY2"]) then
						activeFlag = "ABILITY2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[11] = {
				name = "Rendszám",
				icon = "files/icons/optical/plate.png",
				camera = "RearBump0",
				id = "licensePlate",
				subMenu = {
					[1] = {
						name = "Gyári rendszám",
						icon = "files/icons/free.png",
						priceType = "free",
						price = 0,
						value = "default"
					},
					[2] = {
						name = "Egyedi rendszám",
						icon = "files/icons/pp.png",
						licensePlate = true,
						priceType = "premium",
						price = 1200,
						value = "custom"
					}
				}
			},
			[12] = {
				name = "Traffipax radar",
				icon = "files/icons/optical/speedtrap.png",
				priceType = "money",
				price = 15000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/optical/speedtrap.png",
						priceType = "money",
						price = 15000,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/optical/speedtrap.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "traffipaxRadarInVehicle", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET traffipaxRadar = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "traffipaxRadarInVehicle") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[13] = {
				name = "Variáns",
				icon = "files/icons/variant.png",
				priceType = "money",
				price = 50000,
				camera = "base",
				variantEditor = true
			},
			[14] = {
				name = "GPS",
				icon = "files/icons/gps.png",
				priceType = "money",
				price = 3000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/gps.png",
						priceType = "money",
						price = 3000,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/gps.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.GPS", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET gpsNavigation = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.GPS") or 0

					if value == 1 and current >= 1 or current == value then
						return true
					else
						return false
					end
				end
			},
			[15] = {
				name = "Egyedi duda",
				icon = "files/icons/horn.png",
				priceType = "premium",
				price = 1200,
				camera = "base",
				hornSound = true,
				subMenu = {
					[1] = {
						name = "Kiszerelés",
						icon = "files/icons/horn.png",
						priceType = "free",
						price = 0,
						value = 0
					},
					[2] = {
						name = "Duda 1",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 1
					},
					[3] = {
						name = "Duda 2",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 2
					},
					[4] = {
						name = "Duda 3",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 3
					},
					[5] = {
						name = "Duda 4",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 4
					},
					[6] = {
						name = "Duda 5",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 5
					},
					[7] = {
						name = "Duda 6",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 6
					},
					[8] = {
						name = "Duda 7",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 7
					},
					[9] = {
						name = "Duda 8",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 8
					},
					[10] = {
						name = "Duda 9",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 9
					},
					[11] = {
						name = "Duda 10",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 10
					},
					[12] = {
						name = "Duda 11",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 11
					},
					[13] = {
						name = "Duda 12",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 12
					},
					[14] = {
						name = "Duda 13",
						icon = "files/icons/horn.png",
						priceType = "premium",
						price = 1200,
						value = 13
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "customHorn", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET customHorn = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "customHorn") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[16] = {
				name = "Backfire",
				icon = "files/icons/misc.png",
				priceType = "premium",
				price = 2000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/pp.png",
						priceType = "premium",
						price = 2000,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/free.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.backfire", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET backFire = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.backfire") or 0

					if value == 1 and current >= 1 or current == value then
						return true
					else
						return false
					end
				end
			},
		}
	}
}

componentsFromData = {
	["FrontBump"] 	= "Első lökös",
	["RearBump"]	= "hatso lokos", 
	["Bonnets"]		= "motorhaz",
	["Boots"]		= "Csomagtartó",
	["SideSkirts"]	= "Köszöb",
	["RearLights"] 	= "Hátsó lámpa",
	["FrontLights"] = "Első lámpa",
	["FrontFends"]	= "Első sárvédő",
	["RearFends"]	= "Hátsó sárvédő",
    ["AllFends"]	= "Teljes sárvédő",
	["Acces"]		= "Extra",
	["Spoilers"]	= "Légterelő",
	["Exhaust"]		= "Kipufogő",
	["RearDef"]		= "Hátsó lökhárító sárvédő",
	["FrontDef"]	= "Első lökhárító sárvédő",
	["FrontPDoors"]	= "Jobb ajtó",
	["FrontLDoors"]	= "Bal ajtó",
	["Roof"]	    = "Tető",
	["Splitter"]	= "Splitter",
	["Diffuser"]	= "Diffúzor",
    ["RearGlass"]	= "Hátsó üveg",
    ["FrontGlass"]	= "Első üveg",
	["Resh"]	    = "Rács",
	["Specific"]    = "Speciális",  
	["Mirrors"]    = "Tükrök", 
	["Turn"]    = "Irányjelzők", 	
	["Nameplate"]    = "Rendszám",
    ["Nozdri"]    = "Nozdri",
	
}