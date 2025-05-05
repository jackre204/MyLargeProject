local adminTitles = {
	[1] = "Game Admin [1]",
	[2] = "Game Admin [2]",
	[3] = "Game Admin [3]",
	[4] = "Game Admin [4]",
	[5] = "Game Admin [5]",
	[6] = "Main Admin",
	[7] = "Super Admin",
	[8] = "Developer",
	[9] = "Project Owner",
	[10] = "NULL",
	[11] = "Main Developer"
}

local levelColors = {
	[1] = "#7CC576",
	[2] = "#7CC576",
	[3] = "#7CC576",
	[4] = "#7CC576",
	[5] = "#7CC576",
	[6] = "#a28340",
	[7] = "#a24040",
	[8] = "#406ca2",
	[9] = "#d23131",
	[10] = "#01650f",
	[11] = "#bced4a"
}

function getPlayerAdminTitle(player)
	return adminTitles[getPlayerAdminLevel(player)] or false
end

function getAdminLevelColor(adminLevel)
	return levelColors[tonumber(adminLevel)] or "#7CC576"
end

function getPlayerAdminLevel(player)
	return isElement(player) and tonumber(getElementData(player, "acc.adminLevel")) or 0
end

function getPlayerAdminNick(player,val)

	playerName = isElement(player) and getElementData(player, "acc.adminNick")

	if val then
		if (getElementData(player, "adminDuty") or 0) == 1 then
			playerName = isElement(player) and getElementData(player, "acc.adminNick")
		else
			playerName = isElement(player) and getElementData(player, "char.Name")
		end
	end
	
	return playerName
end