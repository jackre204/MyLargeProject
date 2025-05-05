maxItems = {}

local nonStackableItems = exports.sm_items:getNonStackableItems()

for i = 1, #nonStackableItems do
	maxItems[nonStackableItems[i]] = 1
end

mainTypes = {
	[0] = {1, 3},
	[1] = {7, 8, 9},
	[2] = {7, 8, 9, 10},
	[3] = {6, 8, 9},
	[4] = {6, 8, 9, 10},
	[5] = {7, 6, 8, 9},
	[6] = {7, 6, 8, 9, 10},
	[7] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
	[8] = {3, 8, 9, 4, 5},
	[9] = {2, 3},
	[10] = {11},
	[11] = {12},
	[12] = {13},
	[13] = {14},
	[14] = {15}
}

categories = {
	"Műszaki",			-- 1
	"Szerszámok",		-- 2
	"Hobby",			-- 3
	"Kisállat",			-- 4
	"Egészség",			-- 5
	"Gyorsételek",		-- 6
	"Főtt ételek",		-- 7
	"Üditők",			-- 8
	"Forró italok",		-- 9
	"Alkohol/Cigaretta",-- 10
	"Fegyver",			-- 11
	"Pirotechnika",		-- 12
	"Horgászos",		-- 13
	"Tombola árus",		-- 14
	"Sorsjegy"			-- 15
}

itemsForChoosePlain = {
	{44, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{44, 9},
	{}
}

itemBasePrices = {
	[44] = 70,
	[9] = 600,
	[10] = 10,
	[11] = 10,
	[12] = 10,
	[13] = 10,
	[14] = 10,
	[15] = 10,
	[16] = 10,
	[17] = 10,
	[18] = 10,
	[19] = 10,
	[20] = 10,
	[21] = 10,
}

scratchItems = {}

function addScratchItems()
	itemsForChoosePlain[15] = {}

	for k, v in pairs(scratchItems) do
		maxItems[k] = 1
		itemBasePrices[k] = 5
		table.insert(itemsForChoosePlain[15], k)
	end
end

function resourceStart(res)
	if getResourceName(res) == "sm_lottery" then
		scratchItems = exports.sm_lottery:getScratchItems()
		addScratchItems()
	else
		if source == resourceRoot then
			local sm_lottery = getResourceFromName("sm_lottery")

			if sm_lottery and getResourceState(sm_lottery) == "running" then
				scratchItems = exports.sm_lottery:getScratchItems()
				addScratchItems()
			end
		end
	end
end
addEventHandler("onResourceStart", root, resourceStart)
addEventHandler("onClientResourceStart", root, resourceStart)