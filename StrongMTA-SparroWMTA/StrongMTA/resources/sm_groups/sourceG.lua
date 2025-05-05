groupTypes = {
	law_enforcement = "Rendvédelem",
	government = "Önkormányzat",
	mafia = "Maffia",
	gang = "Banda",
	organisation = "Szervezet",
	other = "Egyéb"
}

availableGroups = {
	[1] = {
		name = "Los Santos Police Department",
		prefix = "LSPD",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			bulletExamine = true,
			impoundTow = true,
			impoundTowFinal = true,
			megaPhone = true,
			roadBlock = true,
			cuff = true,
			graffitiClean = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			jail = true,
			doorRammer = true,
			wheelClamp = true
		},
		duty = {
			skins = {280, 281, 282, 283, 284, 71},
			positions = {
				{2266.06616, 2470.50146, 19995.85938, 0, 0}
			},
			armor = 100,
			items = {
				{78, 1},
				{109, 100},
				{69, 1},
				{118, 1},
				{155, 1},
				{79, 1},
				{114, 50},
				{314, 1, "pd"},
				{115, 1}
			}
		}
	},
	[2] = {
		name = "Los Santos Medical Services",
		prefix = "LSMS",
		type = "other",
		permissions = {
			megaPhone = true,
			tazer = true,
			ticket = true,
			heal = true,
			departmentRadio = true,
			gov = true
		},
		duty = {
			skins = {10, 274, 275, 276},
			positions = {
				{1443.1171875, -1790.3023681641, 32.933151245117, 0, 0},
				{-331.4267578125, 1050.8427734375, 19.739168167114, 0, 0}
			},
			armor = 0,
			items = {
			--	{15, 10},
				{124, 1},
				{125, 1}
			}
		}
	},
	[3] = {
		name = "Kormány",
		prefix = "gov",
		type = "government",
		permissions = {
			megaPhone = true,
			tazer = true,
			cuff = true,
			graffitiClean = true,
			departmentRadio = true,
			gov = true
		},
		duty = {
			skins = {0},
			positions = {
				{-2546.39453125, -656.8486328125, 10086.115234375, 0, 0}
			},
			armor = 0,
			items = {
				{155, 1},
				{118, 1},
				{69, 1},
				{109, 100},
				{77, 1}
			}
		}
	},
	[4] = {
		name = "THE ANARCHY SQUAD",
		prefix = "TAS",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {145, 178, 246, 252, 31},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[6] = {
		name = "Palm Tree Piru",
		prefix = "PTP",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {105, 106, 107, 270, 271, 311},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[9] = {
		name = "Rednecks",
		prefix = "Rednecks",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {34, 161, 159, 200, 158},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[10] = {
		name = "Russian Bratva",
		prefix = "RB",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {61, 126, 131, 189, 272},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[11] = {
		name = "Estates Boulevard Gangsters",
		prefix = "EBG",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {186, 196, 247, 248, 254},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[12] = {
		name = "Federal Bureau of Investigation",
		prefix = "FBI",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			trackPhone = true,
			bulletExamine = true,
			impoundTow = true,
			impoundTowFinal = true,
			megaPhone = true,
			roadBlock = true,
			graffitiClean = true,
			cuff = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			jail = true,
			hiddenName = true,
			doorRammer = true
		},
		duty = {
			skins = {163, 164, 286},
			positions = {
				{2419.873046875, 2374.5703125, 19995.76171875, 0, 0}
			},
			armor = 100,
			items = {
				{78, 1},
				{109, 100},
				{118, 1},
				{155, 1},
				{99, 1},
				{314, 1, "nni"}
			}
		}
	},
	[13] = {
		name = "San Andreas Sheriff's Department",
		prefix = "SASD",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			megaPhone = true,
			bulletExamine = true,
			impoundTow = true,
			impoundTowFinal = true,
			roadBlock = true,
			graffitiClean = true,
			cuff = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			jail = true,
			doorRammer = true
		},
		duty = {
			skins = {265, 266, 267, 277, 278, 288},
			positions = {
				{-215.4169921875, 966.490234375, 19998.562, 0, 0}
			},
			armor = 100,
			items = {
				{79, 1},
				{114, 50},
				{78, 1},
				{109, 100},
				{69, 1},
				{118, 1},
				{155, 1},
				{314, 1, "nav"}
			}
		}
	},
	[14] = {
		name = "Parasi Clan",
		prefix = "Parasi Clan",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {38, 39, 63, 140, 120},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[15] = {
		name = "Redline Auto Service",
		prefix = "RAS",
		type = "other",
		permissions = {
			repair = true,
			impoundTow = true
		},
		duty = {
			skins = {
				50,
				305,
				268,
				191
			},
			positions = {
				{2257.1875, -2538.7751464844, 8.2960109710693, 0, 0}
			},
			armor = 0,
			items = false
		}
	},
	[16] = {
		name = "Szabad maffia",
		prefix = "empty",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[17] = {
		name = "The Monolith",
		prefix = "TM",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {237, 205, 97, 77, 114},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[18] = {
		name = "Szabad maffia",
		prefix = "Yakuza",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[19] = {
		name = "Szabad maffia",
		prefix = "empty",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[20] = {
		name = "Szabad maffia",
		prefix = "empty",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[21] = {
		name = "Szabad rendvédelem",
		prefix = "empty",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			megaPhone = true,
			roadBlock = true,
			graffitiClean = true,
			cuff = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			jail = true
		},
		duty = {
			skins = {0},
			positions = {
				{264.384765625, 109.328125, 1004.6171875, 10, 1611}
			},
			armor = 100,
			items = {
				{78, 1},
				{109, 100},
				{86, 1},
				{113, 750},
				{88, 1},
				{111, 50},
				{69, 1},
				{118, 1},
				{155, 1},
				{93, 1},
				{314, 1, "army"}
			}
		}
	},
	[22] = {
		name = "RPM Hoonigans",
		prefix = "empty",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {85, 102, 103, 104, 117},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[23] = {
		name = "Almighty Latin King Nation",
		prefix = "ALKN",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {115, 116, 118},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[24] = {
		name = "Las Venturas Taxi",
		prefix = "LVT",
		type = "other",
		permissions = {
			gov = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[25] = {
		name = "Cartel De Jalisco Nueva Generación",
		prefix = "cartel",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {146, 75, 18, 138, 139},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[26] = {
		name = "Special Weapons And Tactics",
		prefix = "SWAT",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			megaPhone = true,
			roadBlock = true,
			graffitiClean = true,
			cuff = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			jail = true,
			doorRammer = true
		},
		duty = {
			skins = {279, 285, 287},
			positions = {
				{2471.70288, 2365.00977, 19998.56250, 0, 0}
			},
			armor = 100,
			items = {
				{78, 1},
				{109, 100},
				{83, 1},
				{112, 500},
				{69, 1},
				{118, 1},
				{155, 1},
				{93, 5},
				{314, 1, "swat"},
				{115, 1}
			}
		}
	},
	[29] = {
		name = "Berisha De Organization",
		prefix = "BDO",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {251, 18, 82, 81, 84},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[30] = {
		name = "Szabad banda",
		prefix = "empty",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[31] = {
		name = "Szabad banda",
		prefix = "empty",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[33] = {
		name = "Parkolási Felügyelet",
		prefix = "PF",
		type = "law_enforcement",
		permissions = {
			impoundTow = true,
			impoundTowFinal = true,
			departmentRadio = true,
			megaPhone = true,
			gov = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = {
				{99, 1}
			}
		}
	},
	[34] = {
		name = "Szabad maffia",
		prefix = "empty",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[35] = {
		name = "Szabad banda",
		prefix = "empty",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[36] = {
		name = "Szabad maffia",
		prefix = "empty",
		type = "mafia",
		permissions = {
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[37] = {
		name = "Szabad banda",
		prefix = "empty",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[38] = {
		name = "Szabad banda",
		prefix = "empty",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[39] = {
		name = "Roosevelt Auto Care Center",
		prefix = "RACC",
		type = "other",
		permissions = {
			repair = true
		},
		duty = {
			skins = {50, 305, 268, 191},
			positions = {
				{-210.080078125, 1214.5107421875, 19.91167449951, 0, 0}
			},
			armor = 0,
			items = false
		}
	},
	[40] = {
		name = "Hitman",
		prefix = "Hitman",
		type = "other",
		permissions = {
			unlockVehicle = true,
			doorRammer = true,
			canRobATM = true
		},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	},
	[41] = {
		name = "Admin Frakció",
		prefix = "Admin Frakció",
		type = "other",
		permissions = {},
		duty = {
			skins = {0},
			positions = {},
			armor = 0,
			items = false
		}
	}
}

for k, v in pairs(availableGroups) do
	if not availableGroups[k].balance then
		availableGroups[k].balance = 0
	end

	if not availableGroups[k].description then
		availableGroups[k].description = "leírás"
	end

	if not availableGroups[k].ranks then
		availableGroups[k].ranks = {}
	end

	for i = 1, 15 do
		if not availableGroups[k].ranks[i] then
			availableGroups[k].ranks[i] = {
				name = "rang " .. i,
				pay = 0
			}
		end
	end
end

function getGroups()
	return availableGroups
end

function getGroupTypes()
	return groupTypes
end

function getGroupData(groupId)
	return availableGroups[groupId]
end

function addPlayerGroup(playerElement, groupId, dutySkin)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if not playerGroups[groupId] then
						if not dutySkin then
							dutySkin = availableGroups[groupId].duty.skins[1]
						end

						playerGroups[groupId] = {1, dutySkin, "N"}
						setElementData(playerElement, "player.groups", playerGroups)

						return true
					end
				end
			end
		end
	end
	
	return false
end

function removePlayerGroup(playerElement, groupId)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if playerGroups[groupId] then
						playerGroups[groupId] = nil
						setElementData(playerElement, "player.groups", playerGroups)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function setPlayerLeader(playerElement, groupId, state)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if playerGroups[groupId] then
						playerGroups[groupId][3] = state
						setElementData(playerElement, "player.groups", playerGroups)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function isPlayerLeaderInGroup(playerElement, groupId)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if playerGroups[groupId] then
						if utf8.lower(playerGroups[groupId][3]) == "y" then
							return true
						end
					end
				end
			end
		end
	end

	return false
end

function isPlayerInGroup(playerElement, groups)
	if isElement(playerElement) then
		if groups then
			if type(groups) == "table" then
				local playerGroups = getElementData(playerElement, "player.groups") or {}

				if playerGroups then
					for i = 1, #groups do
						local groupId = groups[i]

						if availableGroups[groupId] then
							if playerGroups[groupId] then
								return groupId
							end
						end
					end
				end
			else
				local groupId = tonumber(groups)
				
				if availableGroups[groupId] then
					local playerGroups = getElementData(playerElement, "player.groups") or {}
					
					if playerGroups then
						if playerGroups[groupId] then
							return groupId
						end
					end
				end
			end
		end
	end

	return false
end

function getPlayerGroups(playerElement)
	if isElement(playerElement) then
		local playerGroups = getElementData(playerElement, "player.groups") or {}
		
		if playerGroups then
			return playerGroups
		end
	end
	
	return false
end

function getPlayerGroupCount(playerElement)
	if isElement(playerElement) then
		local playerGroups = getElementData(playerElement, "player.groups") or {}
		local groupCounter = 0
		
		for k, v in pairs(playerGroups) do
			groupCounter = groupCounter + 1
		end

		return groupCounter
	end
	
	return false
end

function setPlayerRank(playerElement, groupId, rankId)
	if isElement(playerElement) then
		groupId = tonumber(groupId)
		rankId = tonumber(rankId)

		if groupId and rankId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if playerGroups[groupId] then
						playerGroups[groupId][1] = rankId
						setElementData(playerElement, "player.groups", playerGroups)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function getPlayerRank(playerElement, groupId)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}

				if playerGroups then
					if playerGroups[groupId] then
						local rankId = playerGroups[groupId][1]

						if rankId then
							if availableGroups[groupId].ranks[rankId] then
								return rankId, availableGroups[groupId].ranks[rankId].name, availableGroups[groupId].ranks[rankId].pay
							end
						end
					end
				end
			end
		end
	end

	return false
end

function getGroupPrefix(groupId)
	if groupId then
		if availableGroups[groupId] then
			return availableGroups[groupId].prefix
		end
	end
	
	return false
end

function getGroupName(groupId)
	if groupId then
		if availableGroups[groupId] then
			return availableGroups[groupId].name
		end
	end
	
	return false
end

function getGroupType(groupId)
	if groupId then
		if availableGroups[groupId] then
			return availableGroups[groupId].type
		end
	end
	
	return false
end

function isPlayerHavePermission(playerElement, permission)
	if isElement(playerElement) and permission then
		local playerGroups = getElementData(playerElement, "player.groups") or {}

		if playerGroups then
			for k, v in pairs(playerGroups) do
				if availableGroups[k] and availableGroups[k].permissions[permission] then
					return k
				end
			end
		end
	end

	return false
end

function thousandsStepper(amount)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1 ")) .. right
end

function isPlayerOfficer(playerElement)
	return isPlayerInGroup(playerElement, {1, 26, 13, 12, 21})
end