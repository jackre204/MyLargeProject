pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.sm_core:getInterfaceElements())));end)

local baseCategories = {
	{"Sapkák/Kalapok", "caps"},
	{"Szemüvegek", "glasses"},
	{"Maszkok", "masks"},
	{"Karórák", "watches"},
	{"Táskák", "bags"},
	{"Nyakláncok", "necklaces"},
	{"Egyéb kiegészítők", "misc"}
}

local subCategories = {
	caps = true,
	glasses = true,
	watches = true,
	necklaces = true
}

local boneCategories = {
	caps = 1,
	glasses = 1,
	masks = 1,
	watches = 11,
	bags = 3,
	necklaces = 3,
	misc = 3
}

local subTitles = {}
local categorizedItems = {}
local subCategorizedItems = {}

local itemMods = {}
local itemNames = {}
local itemPrices = {}
local itemIndexes = {}
local itemFlags = {}
local itemCounter = 0

local starterCount = 18365
local modeCount = starterCount

function addAnItem(model, name, category, price, mods, doublesided)
	starterCount = modeCount
	modeCount = starterCount + 1
	model = modeCount
	itemMods[model] = mods

	for i = 1, #baseCategories do
		if baseCategories[i][2] == category then
			categorizedItems[model] = i
			break
		end
	end

	itemCounter = itemCounter + 1

	itemNames[model] = name
	itemPrices[model] = math.floor(price)
	itemIndexes[model] = itemCounter
	itemFlags[model] = doublesided

	if subCategories[category] then
		subCategorizedItems[model] = #subTitles
	end
end

table.insert(subTitles, "Baseball sapkák")
addAnItem(9491, "Kamionos sapka #1", "caps", 2000, {"CapTrucker", "MatClothes"})
addAnItem(9606, "Kamionos sapka #2", "caps", 2250, {"CapTrucker", "hatnew1"})
addAnItem(9732, "Kamionos sapka #3", "caps", 2250, {"CapTrucker", "hatnew2"})
addAnItem(9747, "Kamionos sapka #4", "caps", 2250, {"CapTrucker", "hatnew3"})
addAnItem(1695, "Kamionos sapka #5", "caps", 2250, {"CapTrucker", "hatnew4"})
addAnItem(9605, "Kamionos sapka #6", "caps", 2250, {"CapTrucker", "hatnew5"})
addAnItem(9518, "Kamionos sapka #7", "caps", 2250, {"CapTrucker", "hatnew6"})
addAnItem(9521, "Gucci sapka", "caps", 1500, {"guccicap", "guccicap"})
addAnItem(9522, "Jordan sapka", "caps", 1500, {"jordan", "jordan"})
addAnItem(9520, "Terepmintás baseball sapka", "caps", 1625, {"Hat1", "MatClothes"})
addAnItem(9895, "Kék baseball sapka", "caps", 1500, {"Hat2", "MatClothes"})
addAnItem(9493, "Lila baseball sapka", "caps", 1500, {"Hat3", "MatClothes"})
addAnItem(9827, "Sötétszürke baseball sapka", "caps", 1250, {"Hat4", "MatClothes"})
addAnItem(9576, "Barna baseball sapka", "caps", 1250, {"Hat5", "MatClothes"})
addAnItem(3852, "Kék-fehér baseball sapka", "caps", 1500, {"Hat6", "MatClothes"})
addAnItem(9517, "Fekete baseball sapka", "caps", 1625, {"Hat7", "MatClothes"})
addAnItem(9575, "Los Santos baseball sapka", "caps", 1625, {"Hat8", "MatClothes"})
addAnItem(9519, "Piros baseball sapka", "caps", 1250, {"Hat9", "MatClothes"})
addAnItem(9731, "Világosbarna baseball sapka", "caps", 1250, {"Hat10", "MatClothes"})
addAnItem(9708, "New Era Baseball Sapka (Piros)", "caps", 1500, {"Sapka_1", "Sapka_1"}, true)
addAnItem(9496, "Los Angeles Kings Sapka (Fekete)", "caps", 1500, {"Sapka_3", "Sapka_3"}, true)
addAnItem(9607, "Chicago Bulls Baseball Sapka (Piros)", "caps", 1500, {"Sapka_4", "Sapka_4"}, true)
addAnItem(9899, "Chicago Blackhawks Baseball Sapka (Fekete)", "caps", 1500, {"Sapka_6", "Sapka_6"}, true)
addAnItem(9724, "FTP snapback #1", "caps", 3250, {"ftpsapka", "ftpsapka"}, true)
addAnItem(9737, "FTP snapback #2", "caps", 3250, {"ftpsapka2", "ftpsapka2"}, true)
addAnItem(9730, "New Era LA", "caps", 2000, {"Sapka_7", "Sapka_7"}, true)
addAnItem(9733, "New Era NY Black", "caps", 2000, {"Sapka_8", "Sapka_8"}, true)
addAnItem(9727, "New Era NY Grey", "caps", 2000, {"Sapka_9", "Sapka_9"}, true)
addAnItem(9516, "New Era Raiders", "caps", 2000, {"Sapka_10", "Sapka_10"}, true)

table.insert(subTitles, "Kalapok")
addAnItem(8873, "Fekete kalap", "caps", 2500, {"HatBowler1", "MatClothes"})
addAnItem(8867, "Sötétkék kalap", "caps", 2500, {"HatBowler2", "MatClothes"})
addAnItem(8874, "Zöld kalap", "caps", 2000, {"HatBowler3", "MatClothes"})
addAnItem(1365, "Piros kalap", "caps", 2500, {"HatBowler4", "MatClothes"})
addAnItem(8561, "Sárga kalap", "caps", 2000, {"HatBowler5", "MatClothes"})
addAnItem(8868, "Nike kanji kalap", "caps", 4000, {"sadsapka", "sadsapka"}, true)
addAnItem(8462, "Pork pie kalap #1", "caps", 3000, {"hut", "hut"}, true)
addAnItem(8869, "Pork pie kalap #2", "caps", 3000, {"hut", "hut2"}, true)
addAnItem(8880, "Pork pie kalap #3", "caps", 3000, {"hut", "hut3"}, true)

table.insert(subTitles, "Cowboy kalapok")
addAnItem(9726, "Barna cowboy kalap", "caps", 2750, {"cow", "cow1"})
addAnItem(9624, "Fehér cowboy kalap", "caps", 2750, {"cow", "cow2"})
addAnItem(9509, "Lila cowboy kalap", "caps", 2750, {"cow", "cow3"})
addAnItem(9728, "Sötétbarna cowboy kalap", "caps", 2750, {"cow", "cow4"})
addAnItem(9511, "Narancs cowboy kalap", "caps", 2750, {"cow", "cow5"})
addAnItem(9497, "Világosbarna cowboy kalap", "caps", 2750, {"cow", "cow6"})
addAnItem(9500, "Fekete cowboy kalap", "caps", 2750, {"cow", "cow7"})

table.insert(subTitles, "Egyéb")
addAnItem(9498, "Munkavédelmi sisak", "caps", 500, {"HardHat1", "HardHat1"})

table.insert(subTitles, "Halászkalapok")
addAnItem(9891, "Világos terepmintás halászkalap", "caps", 750, {"HatCool1", "MatClothes"})
addAnItem(9725, "Szürke halászkalap", "caps", 500, {"HatCool2", "MatClothes"})
addAnItem(9824, "Sötét terepmintás halászkalap", "caps", 750, {"HatCool3", "MatClothes"})
addAnItem(9608, "Chicago Bulls Camouflage Sapka (Piros)", "caps", 1000, {"Sapka_2", "Sapka_2"}, true)
addAnItem(9508, "Kangool Sapka (Fekete)", "caps", 1000, {"Sapka_5", "Sapka_5"}, true)

table.insert(subTitles, "Téli sapkák")
addAnItem(9572, "Szürke téli sapka", "caps", 1500, {"SkullyCap1", "MatClothes"})
addAnItem(9547, "Zöld téli sapka", "caps", 1500, {"SkullyCap2", "MatClothes"})
addAnItem(9577, "Csíkos téli sapka", "caps", 1600, {"SkullyCap3", "MatClothes"})

table.insert(subTitles, "Bukósisakok")
addAnItem(9816, "Piros-kék mintás bukósisak", "caps", 3000, {"MotorcycleHelmet1", "MatClothes"})
addAnItem(9510, "Rózsaszín-fehér bukósisak", "caps", 3000, {"MotorcycleHelmet2", "MatClothes"})
addAnItem(9499, "Barna-fehér bukósisak", "caps", 3000, {"MotorcycleHelmet3", "MatClothes"})
addAnItem(9492, "Sárga-piros bukósisak", "caps", 3000, {"MotorcycleHelmet4", "MatClothes"})
addAnItem(9601, "Cross #1 bukósisak", "caps", 3500, {"cross", "cross"})
addAnItem(9507, "Cross #2 bukósisak", "caps", 3500, {"cross", "cross2"})
addAnItem(9557, "Cross #3 bukósisak", "caps", 3500, {"cross", "cross3"})
addAnItem(9864, "Cross #4 bukósisak", "caps", 3500, {"cross", "cross4"})
addAnItem(9765, "Chopper bukósisak", "caps", 4250, {"ArmyHelmet", "ArmyHelmet"})
---
table.insert(subTitles, "Napszemüveg")
addAnItem(9653, "Fekete napszemüveg", "glasses", 2000, {"GlassesType1", "MatGlasses"})
addAnItem(9555, "Barna napszemüveg", "glasses", 2000, {"GlassesType2", "MatGlasses"})
addAnItem(9566, "Fekete lekerekített napszemüveg", "glasses", 2125, {"GlassesType5", "MatGlasses"})
addAnItem(9617, "Téglalap alakú fekete napszemüveg", "glasses", 2250, {"GlassesType10", "MatGlasses"})
addAnItem(9512, "Téglalap alakú szürke napszemüveg", "glasses", 2250, {"GlassesType11", "MatGlasses"})
addAnItem(6877, "Négyzet alakú fekete szemüveg", "glasses", 2200, {"GlassesType12", "MatGlasses"})
addAnItem(8954, "Síszemüveg", "glasses", 2500, {"GlassesType13", "MatGlasses"})
addAnItem(8575, "Fekete pilóta szemüveg", "glasses", 2250, {"GlassesType14", "MatGlasses"})
addAnItem(8401, "Szürke kerek lencsés napszemüveg", "glasses", 2250, {"GlassesType16", "MatGlasses"})
addAnItem(8473, "Barna kerek lencsés napszemüveg", "glasses", 2250, {"GlassesType17", "MatGlasses"})
addAnItem(6981, "Sárga lencsés napszemüveg", "glasses", 2500, {"GlassesType19", "MatGlasses"})
addAnItem(3521, "Narancssárga lencsés napszemüveg", "glasses", 2500, {"GlassesType20", "MatGlasses"})
addAnItem(8443, "Szürke lencsés napszemüveg", "glasses", 2500, {"GlassesType21", "MatGlasses"})
addAnItem(8474, "Régies napszemüveg", "glasses", 1750, {"GlassesType23", "MatGlasses"})
addAnItem(3494, "Arany díszes napszemüveg", "glasses", 5000, {"Szemuveg_1", "Szemuveg_1"}, true)

table.insert(subTitles, "Normál szemüveg")
addAnItem(6922, "Régies szemüveg", "glasses", 1750, {"GlassesType8", "MatGlasses"})

table.insert(subTitles, "Egyéb szemüveg")
addAnItem(7029, "Fekete party szemüveg", "glasses", 1750, {"GlassesType6", "MatGlasses"})
addAnItem(6961, "Szürke party szemüveg", "glasses", 1750, {"GlassesType7", "MatGlasses"})

table.insert(subTitles, "Luxus órák")
addAnItem(6926, "Fekete számlapú aranyóra", "watches", 7500, {"WatchType4", "MatWatches"})
addAnItem(6963, "Fehér számlapú aranyóra", "watches", 7500, {"WatchType1", "MatWatches"})
addAnItem(8399, "Fekete számlapú ezüstóra", "watches", 6250, {"WatchType2", "MatWatches"})
addAnItem(8463, "Fehér számlapú ezüstóra", "watches", 6250, {"WatchType5", "MatWatches"})
addAnItem(8476, "Sötét aranyóra", "watches", 7750, {"WatchType3", "MatWatches"})
addAnItem(8400, "Sárgaréz Óra", "watches", 8750, {"Ora_1", "Ora_1"})
addAnItem(8688, "24 Karátos Arany Óra", "watches", 10000, {"Ora_2", "Ora_2"})

table.insert(subTitles, "Normál órák")
addAnItem(8425, "Hagyományos bőrszíjas óra", "watches", 5000, {"Ora_3", "Ora_3"})
addAnItem(3519, "Lila karóra", "watches", 3500, {"WatchType6", "MatWatches"})
addAnItem(7347, "Piros karóra", "watches", 3500, {"WatchType7", "MatWatches"})
addAnItem(8395, "Zöld karóra", "watches", 3500, {"WatchType8", "MatWatches"})
addAnItem(9104, "Sötétlila karóra", "watches", 3750, {"WatchType9", "MatWatches"})
addAnItem(8449, "Világoskék-fekete karóra", "watches", 3750, {"WatchType10", "MatWatches"})
addAnItem(7069, "Kék-fekete karóra", "watches", 3750, {"WatchType12", "MatWatches"})
addAnItem(7263, "Piros-fekete karóra", "watches", 3875, {"WatchType11", "MatWatches"})
addAnItem(7075, "Narancs-fekete karóra", "watches", 3875, {"WatchType13", "MatWatches"})
addAnItem(7208, "Rózsaszín-fehér karóra", "watches", 3750, {"WatchType14", "MatWatches"})
addAnItem(16064, "Terepmintás karóra", "watches", 4250, {"WatchType15", "MatWatches"})
addAnItem(16423, "Casio GST-W100G-1B", "watches", 7500, {"Ora_4", "Ora_4"})

addAnItem(9000, "Yoban hátizsák", "bags", 3500, {"BackPack1", "BackPack1"})
addAnItem(8246, "Vivic hátizsák", "bags", 3450, {"BackPack2", "BackPack2"})
addAnItem(7731, "Star hátizsák", "bags", 3625, {"BackPack3", "BackPack3"})
addAnItem(7993, "Rip Curl hátizsák", "bags", 4000, {"BackPack4", "BackPack4"})
addAnItem(8169, "GStyle Curl hátizsák", "bags", 4250, {"BackPack5", "BackPack5"})
addAnItem(8314, "Ollies hátizsák", "bags", 2750, {"BackPack6", "BackPack6"})
addAnItem(7730, "Zöld sporttáska", "bags", 1000, {"duffelbag", "duffelbag"})
addAnItem(8421, "Fekete sporttáska", "bags", 1000, {"duffelbag", "duffelbag2"})
addAnItem(7987, "Túratáska", "bags", 1000, {"HikerBackpack1", "HikerBackpack1"})
addAnItem(9173, "Adidas iskolatáska", "bags", 4000, {"SchoolPack", "SchoolPack1"})
addAnItem(9052, "Nike oldaltáska", "bags", 5000, {"oldaltaska", "oldaltaska"})

addAnItem(7651, "Fekete-fehér maszk", "masks", 1250, {"Mask2", "MatClothes"})
addAnItem(3458, "Zöld-fehér maszk", "masks", 1250, {"Mask3", "MatClothes"})
addAnItem(8440, "Lila-fehér maszk", "masks", 1250, {"Mask5", "MatClothes"})
addAnItem(9001, "Kék-fehér", "masks", 1250, {"Mask7", "MatClothes"})
addAnItem(3434, "Szürke-fehér maszk", "masks", 1250, {"Mask8", "MatClothes"})
addAnItem(8371, "Piros-fehér maszk", "masks", 1250, {"Mask9", "MatClothes"})
addAnItem(8370, "Koponyás maszk", "masks", 2000, {"Mask1", "MatClothes"})
addAnItem(8044, "Terepmintás maszk", "masks", 2125, {"Mask4", "MatClothes"})
addAnItem(7435, "Világos terepmintás maszk", "masks", 2125, {"Mask10", "MatClothes"})
addAnItem(9118, "Aranymintás maszk", "masks", 1750, {"Mask6", "MatClothes"})
addAnItem(8372, "Símaszk", "masks", 6000, {"maskshit", "maskshit"}, true)
addAnItem(7580, "Tök maszk", "masks", 3000, {"tok", "tok"})
addAnItem(8171, "Zombi #1 maszk", "masks", 3000, {"zombi", "zombi"})
addAnItem(8305, "Zombi #2 maszk", "masks", 3000, {"zombi", "zombi2"})
addAnItem(8445, "Szakáll", "masks", 30000, {"JESSE_Szakall", "JESSE_Szakall"})

table.insert(subTitles, "Arany nyakláncok")
addAnItem(7972, "Nyaklánc kereszttel", "necklaces", 15000, {"NeckLace", "NeckLace1"}, true)
addAnItem(8851, "Nyaklánc medállal", "necklaces", 17500, {"NeckLace", "NeckLace3"}, true)
addAnItem(8486, "Vastag lánc", "necklaces", 20000, {"NeckLace", "NeckLace6"}, true)
addAnItem(9070, "Vastag lánc kereszttel", "necklaces", 22500, {"NeckLace", "NeckLace7"}, true)
addAnItem(3454, "Luxury Egypt Arany Nyaklánc", "necklaces", 25000, {"Nyaklanc_2", "Nyaklanc_2"})
addAnItem(3444, "Silver Cross Fehérarany Nyaklánc", "necklaces", 25000, {"Nyaklanc_3", "Nyaklanc_3"})
addAnItem(8343, "Gyémánt berakásos Nyaklánc", "necklaces", 37500, {"Nyaklanc_4", "Nyaklanc_4"})

table.insert(subTitles, "Ezüst nyakláncok")
addAnItem(9117, "Aszték Nyaklánc", "necklaces", 12500, {"Nyaklanc_1", "Nyaklanc_1"})
addAnItem(8610, "Nyaklánc medállal", "necklaces", 11250, {"NeckLace", "NeckLace9"}, true)
addAnItem(7550, "Nyaklánc két medállal", "necklaces", 10000, {"NeckLace", "NeckLace4"}, true)
addAnItem(7433, "Rózsafüzér", "necklaces", 7500, {"NeckLace", "NeckLace2"}, true)
addAnItem(3438, "Fekete lánc", "necklaces", 5000, {"NeckLace", "NeckLace8"}, true)

addAnItem(7631, "Police golyóálló mellény", "misc", 1000, {"armor", "armor"}, true)
addAnItem(8979, "Sheriff golyóálló mellény", "misc", 1000, {"armor", "armor2"}, true)
addAnItem(8619, "SWAT golyóálló mellény", "misc", 1000, {"armor", "armor3"}, true)
addAnItem(9123, "FBI golyóálló mellény", "misc", 10000, {"armor", "armor4"}, true)
addAnItem(8487, "Terpemintás golyóálló mellény", "misc", 1000, {"armor", "armor5"}, true)
addAnItem(7522, "Láthatósági mellény", "misc", 500, {"trafficvest", "trafficvest"}, true)
addAnItem(8355, "Kockás ing", "misc", 1750, {"trafficvest", "trafficvest7"}, true)
addAnItem(8501, "Harley farmer mellény", "misc", 1850, {"trafficvest", "trafficvest3"}, true)
addAnItem(7606, "SOA motoros mellény", "misc", 2000, {"trafficvest", "trafficvest2"}, true)
addAnItem(8664, "Block motoros mellény", "misc", 2000, {"trafficvest", "trafficvest4"}, true)
addAnItem(8357, "Harley motoros mellény", "misc", 2000, {"trafficvest", "trafficvest5"}, true)
addAnItem(7574, "Lost MC motoros mellény", "misc", 2000, {"trafficvest", "trafficvest6"}, true)
addAnItem(9037, "Pizzás mellény", "misc", 600, {"trafficvest", "trafficvest8"}, true)
addAnItem(6040, "Pizzás #2 mellény", "misc", 600, {"trafficvest", "trafficvest9"}, true)
addAnItem(6035, "Jumbo mellény", "misc", 700, {"trafficvest", "trafficvest10"}, true)
addAnItem(6869, "Vadász mellény", "misc", 800, {"trafficvest", "trafficvest11"}, true)
addAnItem(8247, "Horgász mellény", "misc", 800, {"trafficvest", "trafficvest12"}, true)
addAnItem(8249, "Camo mellény", "misc", 800, {"trafficvest", "trafficvest13"}, true)
addAnItem(7482, "GPMC mellény #1", "misc", 800, {"trafficvest", "trafficvest14"}, true)
addAnItem(8842, "GPMC mellény #2", "misc", 800, {"trafficvest", "trafficvest15"}, true)
addAnItem(7997, "Piros kockás ing", "misc", 650, {"trafficvest", "vestnew1"}, true)
addAnItem(8155, "Kék kockás ing", "misc", 650, {"trafficvest", "vestnew2"}, true)
addAnItem(7280, "Farmering", "misc", 700, {"trafficvest", "vestnew3"}, true)
addAnItem(7465, "Papagáj", "misc", 999999999, {"TheParrot1", "TheParrot1"}, true)
addAnItem(8468, "Nyakkendő #1", "misc", 700, {"nyakkendo", "nyakkendo"}, true)
addAnItem(9076, "Nyakkendő #2", "misc", 700, {"nyakkendo", "nyakkendo1"}, true)
addAnItem(8396, "Nyakkendő #3", "misc", 700, {"nyakkendo", "nyakkendo2"}, true)
addAnItem(7880, "Csokornyakkendő #1", "misc", 400, {"csokor", "csokor"}, true)
addAnItem(3453, "Csokornyakkendő #2", "misc", 400, {"csokor", "csokor1"}, true)
addAnItem(8034, "Csokornyakkendő #3", "misc", 400, {"csokor", "csokor2"}, true)

local groupClothes = {
	[7251] = {1},
	[8979] = {1},
	[8619] = {1},
	[9123] = {1},
	[8487] = {1},
	[7631] = {1},
	[7465] = {41},
}

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = exports.sm_hud:getResponsiveMultipler()

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local shopColshape = false
local shopMarker = false

local Roboto = false

local shopPanel = false
local clothesPanel = false
local outfitsPanel = false
local presetsPanel = false

local itemList = {}
local visibleItems = 0
local offsetItems = 0
local openCategories = {}

local activeButton = false
local activeFakeInput = false
local fakeInputText = ""

local cursorStateChange = 0
local cursorState = false

local myClothesLimit = 2
local myCurrentClothes = {}
local myClothes = {}
local myBoughtClothes = {}
local myGroupClothes = {}
local myOutfits = {}
local myPresets = {}
local myLastPresets = {}
local clothObjects = {}
local clothSlotInUse = {}

local canBuyCloth = true
local buyClothTick = 0
local delClothTick = 0

local previewModel = false
local previewDatas = false

local interiorObject = false
local previewObject = false

local previewZoom = 1
local previewRotating = false

local previewTarget = false
local previewScreen = false
local previewSize = respc(1000)
local previewSection = respc(250)

local unlockSlotPrompt = false
local buySlotProcessing = false
local selectedSlot = false
local delClothPrompt = false

local editorFont = false
local editorType = false
local editorSlot = false

local editorMainObject = false
local editorDummyObject = false

local editorScaleX, editorScaleY, editorScaleZ = 1, 1, 1

local activeMode = "move"
local activeAxis = false
local moveOffset = 0
local attachmentDetails = {}

local sniperAim = false
local loadedTXDs = {}

function adminClothes(commandName, partialNick, mode, slotName)
	if getElementData(localPlayer, "acc.adminLevel") >= 3 then
		if not partialNick then
			outputChatBox("#3d7abc[Használat]: #FFFFFF/" .. commandName .. " [Név / ID]", 255, 255, 255, true)
		else
			local targetPlayer, targetName = exports.sm_core:findPlayer(localPlayer, partialNick)

			if isElement(targetPlayer) then
				local currentClothes = getElementData(targetPlayer, "currentClothes") or ""

				currentClothes = fromJSON(currentClothes) or {}

				if mode ~= "levesz" or not slotName then
					if mode == "levesz" and not slotName then
						outputChatBox("#3d7abc[StrongMTA - Adminruha]:#ffffff Használd a #32b3ef/" .. commandName .. " " .. partialNick .. " levesz [slot név]", 255, 255, 255, true)
					else
						outputChatBox("#3d7abc[StrongMTA - Adminruha]:#ffffff Használd a #32b3ef/" .. commandName .. " " .. partialNick .. " levesz [slot név] #FFFFFFparancsot egy ruhadarab levételéhez!", 255, 255, 255, true)
					end

					outputChatBox("#3d7abc[StrongMTA - Adminruha]:#ffffff " .. targetName .. " ruhadarabjai:", 255, 255, 255, true)

					for k, v in pairs(baseCategories) do
						local slot = v[2]

						if currentClothes[slot] and currentClothes[slot][1] then
							outputChatBox("  - " .. v[1] .. ": #3d7abc" .. itemNames[currentClothes[slot][1]] .. "#ffffff (slot név: #3d7abc" .. slot .. "#ffffff)", 255, 255, 255, true)
						else
							outputChatBox("  - " .. v[1] .. ": #d75959Nem található ruhadarab", 255, 255, 255, true)
						end
					end
				end

				if mode == "levesz" and slotName then
					if getTickCount() - delClothTick >= 5000 then
						if currentClothes[slotName] then
							triggerServerEvent("onTryToRemoveCloth", localPlayer, targetPlayer, slotName)

							delClothTick = getTickCount()
						else
							exports.sm_hud:showInfobox("e", "Ezen a sloton (" .. slotName .. ") nem található ruhadarab!")
						end
					else
						exports.sm_hud:showInfobox("e", "Ilyen gyorsan nem kéne!")
					end
				end
			end
		end
	end
end
addCommandHandler("adminruha", adminClothes)
addCommandHandler("acuccaim", adminClothes)

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedResource)
		if getResourceName(startedResource) == "sm_boneattach" then
			local players = getElementsByType("player")

			for i = 1, #players do
				local player = players[i]

				if player then
					processClothes(player)
				end
			end
		elseif getResourceName(startedResource) == "sm_clothesshop" then
			shopColshape = createColSphere(977.60308837891, -1400.8293457031, 13.197308158875, 1)

			if isElement(shopColshape) then
				shopMarker = createMarker(977.60308837891, -1400.8293457031, 12.197308158875, "cylinder", 1.5, 61, 122, 188, 155)

				if isElement(shopMarker) then
					setElementData(shopMarker, "3DText", "Kiegészítők", false)
					setElementInterior(shopMarker, 0)
					setElementDimension(shopMarker, 0)
				end

				setElementInterior(shopColshape, 0)
				setElementDimension(shopColshape, 0)
			end

			for k, v in pairs(itemMods) do
				local dffName = v[1]
				local txdName = v[2]

				if txdName then
					if not loadedTXDs[txdName] then
						loadedTXDs[txdName] = engineLoadTXD("mods/" .. txdName .. ".txd")
					end

					if loadedTXDs[txdName] then
						engineImportTXD(loadedTXDs[txdName], k)
					end
				end

				if dffName then
					local dff = engineLoadDFF("mods/" .. dffName .. ".dff")

					if dff then
						engineReplaceModel(dff, k)
					end
				end
			end

			for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
				processClothes(v)
			end

			myClothesLimit = getElementData(localPlayer, "clothesLimit") or 2

			processBought()
			processOutfits()
			checkGroups()

			local xmlFile = xmlLoadFile("presets.xml")

			if xmlFile then
				local lastPresetsNode = xmlFindChild(xmlFile, "lastPresets", 0)

				if lastPresetsNode then
					local childNodes = xmlNodeGetChildren(lastPresetsNode)

					for i = 1, #childNodes do
						local name = xmlNodeGetName(childNodes[i])
						local value = xmlNodeGetValue(childNodes[i])

						myLastPresets[name] = fromJSON(value)
					end
				end

				local presetsNode = xmlFindChild(xmlFile, "presets", 0)

				if presetsNode then
					local childNodes = xmlNodeGetChildren(presetsNode)

					for i = 1, #childNodes do
						local name = xmlNodeGetName(childNodes[i])
						local childs = xmlNodeGetChildren(childNodes[i])

						for j = 1, #childs do
							local value = xmlNodeGetValue(childs[j])

							if not myPresets[name] then
								myPresets[name] = {}
							end

							table.insert(myPresets[name], fromJSON(value))
						end
					end
				end

				xmlUnloadFile(xmlFile)
			end
		end
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		local xmlFile = xmlCreateFile("presets.xml", "presets")

		if xmlFile then
			local lastPresetsNode = xmlCreateChild(xmlFile, "lastPresets")

			if lastPresetsNode then
				for k, v in pairs(myLastPresets) do
					local childNode = xmlCreateChild(lastPresetsNode, k)

					if childNode then
						xmlNodeSetValue(childNode, toJSON(v, true))
					end
				end
			end

			local presetsNode = xmlCreateChild(xmlFile, "presets")

			if presetsNode then
				for k, v in pairs(myPresets) do
					local childNode = xmlCreateChild(presetsNode, k)

					for k2, v2 in pairs(myPresets[k]) do
						local presetNode = xmlCreateChild(childNode, "preset")

						if presetNode then
							xmlNodeSetValue(presetNode, toJSON(v2, true))
						end
					end
				end
			end

			local outfitsNode = xmlCreateChild(xmlFile, "outfits")

			if outfitsNode then
				for k, v in pairs(myOutfits) do
					local childNode = xmlCreateChild(outfitsNode, "outfit")

					if childNode then
						xmlNodeSetValue(childNode, v[2])
						xmlNodeSetAttribute(childNode, "name", v[1])
						xmlNodeSetAttribute(childNode, "id", k)
					end
				end
			end

			xmlSaveFile(xmlFile)
			xmlUnloadFile(xmlFile)
		end
	end
)

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (enterPlayer, sameDimension)
		if source == shopColshape then
			if enterPlayer == localPlayer then
				if sameDimension then
					openClothesShop()
				end
			end
		end
	end
)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (enterPlayer, sameDimension)
		if source == shopColshape then
			if enterPlayer == localPlayer then
				if sameDimension then
					openClothesShop("off")
				end
			end
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if source == localPlayer then
			if dataName == "player.groups" then
				checkGroups()
			elseif dataName == "boughtClothes" then
				processBought()
				processOutfits()
			elseif dataName == "clothesLimit" then
				myClothesLimit = getElementData(source, "clothesLimit") or 2
			end
		end

		if dataName == "currentClothes" then
			processClothes(source)
		elseif dataName == "adminDuty" then
			processClothes(source)
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "player" then
			processClothes(source)
		end
	end
)

addEvent("clothBuyProcessed", true)
addEventHandler("clothBuyProcessed", localPlayer,
	function (infoType, infoText)
		if infoType and infoText then
			exports.sm_hud:showInfobox(infoType, infoText)
		end

		canBuyCloth = true
	end
)

addEvent("buyTheClothesSlot", true)
addEventHandler("buyTheClothesSlot", localPlayer,
	function (infoType, infoText)
		if infoType and infoText then
			exports.sm_hud:showInfobox(infoType, infoText)
		end

		buySlotProcessing = false
	end
)

function processOutfits()
	local xmlFile = xmlLoadFile("presets.xml")

	if xmlFile then
		local outfitsNode = xmlFindChild(xmlFile, "outfits", 0)

		if outfitsNode then
			local clothesLimit = getElementData(localPlayer, "clothesLimit") or 2
			local childNodes = xmlNodeGetChildren(outfitsNode)

			myOutfits = {}

			for i = 1, #childNodes do
				local value = xmlNodeGetValue(childNodes[i])
				local data = fromJSON(value) or {}
				local update = false

				for k, v in pairs(data) do
					if not myBoughtClothes[v[1]] or not tonumber(v[11]) or clothesLimit < v[11] then
						update = true
						break
					end
				end

				if not update then
					local id = xmlNodeGetAttribute(childNodes[i], "id")
					local name = xmlNodeGetAttribute(childNodes[i], "name")

					myOutfits[tonumber(id)] = {name, value}
				end
			end
		end

		xmlUnloadFile(xmlFile)
	end
end

function processBought()
	local boughtClothes = getElementData(localPlayer, "boughtClothes")

	if boughtClothes then
		boughtClothes = fromJSON(boughtClothes) or {}
		myClothes = {}

		for model in pairs(boughtClothes) do
			model = tonumber(model)

			local categoryId = categorizedItems[model]

			if categoryId then
				if not myClothes[categoryId] then
					myClothes[categoryId] = {}
				end

				table.insert(myClothes[categoryId], model)

				myBoughtClothes = {}

				for k, v in pairs(myClothes) do
					for k2, v2 in pairs(v) do
						myBoughtClothes[v2] = true
					end
				end
			end
		end
	end
end

function checkGroups()
	local clothes = getElementData(localPlayer, "boughtClothes") or ""
	local boughtClothes = {}

	clothes = fromJSON(clothes) or {}

	for k, v in pairs(clothes) do
		boughtClothes[tonumber(k)] = true
	end

	for k, v in pairs(groupClothes) do
		local inGroup = false

		for i, groupId in ipairs(v) do
			if exports.sm_groups:isPlayerInGroup(localPlayer, groupId) then
				inGroup = true
				break
			end
		end

		local model = tonumber(k)

		if inGroup then
			boughtClothes[model] = true
			myGroupClothes[model] = true
		else
			boughtClothes[model] = nil
			myGroupClothes[model] = false
		end
	end

	setElementData(localPlayer, "boughtClothes", toJSON(boughtClothes, true))

	local currentClothes = getElementData(localPlayer, "currentClothes") or ""
	local clothesChanged = false

	currentClothes = fromJSON(currentClothes) or {}

	for k, v in pairs(currentClothes) do
		local model = tonumber(v[1])

		if not myGroupClothes[model] and groupClothes[model] then
			currentClothes[k] = nil
			clothesChanged = true
		end
	end

	if clothesChanged then
		setElementData(localPlayer, "currentClothes", toJSON(currentClothes, true))
	end
end

addEventHandler("onClientElementStreamOut", getRootElement(),
	function ()
		if clothObjects[source] then
			for i = 1, #clothObjects[source] do
				local objectElement = clothObjects[source][i]

				if isElement(objectElement) then
					destroyElement(objectElement)
				end
			end
		end

		clothObjects[source] = nil
	end
)

addEventHandler("onClientPlayerQuit", getRootElement(),
	function ()
		if clothObjects[source] then
			for i = 1, #clothObjects[source] do
				local objectElement = clothObjects[source][i]

				if isElement(objectElement) then
					destroyElement(objectElement)
				end
			end
		end

		clothObjects[source] = nil
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if clothObjects[source] then
			for i = 1, #clothObjects[source] do
				local objectElement = clothObjects[source][i]

				if isElement(objectElement) then
					destroyElement(objectElement)
				end
			end
		end

		clothObjects[source] = nil
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if getPedWeapon(localPlayer) == 34 then
			if getControlState("aim_weapon") then
				if not sniperAim then
					sniperAim = true
					processClothes(localPlayer)
				end
			elseif sniperAim then
				sniperAim = false
				processClothes(localPlayer)
			end
		elseif sniperAim then
			sniperAim = false
			processClothes(localPlayer)
		end
	end
)

function processClothes(player, category)
	if clothObjects[player] then
		for i = 1, #clothObjects[player] do
			local objectElement = clothObjects[player][i]

			if isElement(objectElement) then
				destroyElement(objectElement)
			end
		end

		clothObjects[player] = nil
	end

	if player == localPlayer then
		clothSlotInUse = {}
	end

	if isElementStreamedIn(player) then
		clothObjects[player] = {}

		if player == localPlayer and sniperAim then
			return
		end

		local adminDuty = getElementData(player, "adminDuty") or 0

		if adminDuty ~= 1 then
			local currentClothes = getElementData(player, "currentClothes")

			if currentClothes then
				local clothesLimit = getElementData(player, "clothesLimit") or 2

				currentClothes = fromJSON(currentClothes)

				if clothesLimit then
					local x, y, z = getElementPosition(player)
					local interior = getElementInterior(player)
					local dimension = getElementDimension(player)

					for k, v in pairs(currentClothes) do
						if k ~= category and tonumber(v[11]) and clothesLimit >= v[11] then
							local objectModelId = v[1]
							local objectElement = createObject(objectModelId, x, y, z, 0, 0, 0)

							if isElement(objectElement) then
								setElementFrozen(objectElement, true)
								setElementDoubleSided(objectElement, itemFlags[objectModelId] or false)
								setElementCollisionsEnabled(objectElement, false)

								setElementInterior(objectElement, interior)
								setElementDimension(objectElement, dimension)
								setTimer(setObjectScaleEx, 100, 1, objectElement, v[8], v[9], v[10])

								exports.sm_boneattach:attachElementToBone(objectElement, player, boneCategories[k], v[2], v[3], v[4], v[5], v[6], v[7])

								table.insert(clothObjects[player], objectElement)

								if player == localPlayer then
									clothSlotInUse[v[11]] = v[1]
								end
							end
						end
					end
				end
			end
		end
	end
end

function setObjectScaleEx(objectElement, scaleX, scalY, scalZ)
	if isElement(objectElement) then
		setObjectScale(objectElement, scaleX, scalY, scalZ)
	end
end

function openMyClothes(state)
	if not shopPanel and not previewScreen and not editorType then
		if isElement(Roboto) then
			destroyElement(Roboto)
		end

		clothesPanel = not clothesPanel

		if state == "off" then
			clothesPanel = false
		end

		itemList = {}
		visibleItems = 0
		offsetItems = 0
		openCategories = {}
		activeFakeInput = false

		if clothesPanel then
			Roboto = dxCreateFont("files/Roboto.ttf", respc(14), false, "antialiased")

			outfitsPanel = false
			unlockSlotPrompt = false
			selectedSlot = false
			delClothPrompt = false

			addEventHandler("onClientRender", getRootElement(), renderMyClothes)

			playSound("files/sounds/open.mp3")
		else
			removeEventHandler("onClientRender", getRootElement(), renderMyClothes)

			playSound("files/sounds/close.mp3")
		end
	end
end
addCommandHandler("cuccaim", openMyClothes)

function openClothesShop(state)
	if not clothesPanel and not previewScreen and not editorType then
		if isElement(Roboto) then
			destroyElement(Roboto)
		end

		if state == "off" then
			if not shopPanel then
				return
			end

			shopPanel = false
		else
			shopPanel = not shopPanel
		end

		itemList = {}
		visibleItems = 0
		offsetItems = 0
		openCategories = {}
		activeFakeInput = false

		if shopPanel then
			Roboto = dxCreateFont("files/Roboto.ttf", respc(14), false, "antialiased")

			addEventHandler("onClientRender", getRootElement(), renderClothesShop)
			loadShopDatas()

			playSound("files/sounds/open.mp3")
		else
			removeEventHandler("onClientRender", getRootElement(), renderClothesShop)

			playSound("files/sounds/close.mp3")
		end
	end
end

function spairs(t, order)
	local keys = {}

	for k in pairs(t) do
		keys[#keys+1] = k
	end

	if order then
		table.sort(keys,
			function (a, b)
				return order(t, a, b)
			end
		)
	else
		table.sort(keys)
	end

	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

function loadShopDatas()
	local currentClothes = getElementData(localPlayer, "currentClothes") or ""

	myBoughtClothes = {}
	myCurrentClothes = fromJSON(currentClothes) or {}

	local cats = {}
	local subs = {}
	local items = {}

	itemList = {}
	visibleItems = 0

	for k, v in pairs(categorizedItems) do
		table.insert(items, {k, v})
	end

	local function sortFunction(array, a, b)
		return itemIndexes[array[b][1]] > itemIndexes[array[a][1]]
	end

	for k, v in spairs(items, sortFunction) do
		local model = v[1]
		local id = v[2]

		if not cats[id] then
			cats[id] = true
			table.insert(itemList, {"cat", id})
		end

		if openCategories[id] and not groupClothes[model] then
			local name = baseCategories[id][2]

			if subCategories[name] then
				local index = subCategorizedItems[model]

				if not subs[index] then
					subs[index] = true
					table.insert(itemList, {"sub", subTitles[index]})
				end
			end

			table.insert(itemList, {"item", model})
		end
	end

	visibleItems = #itemList

	if visibleItems > 15 then
		if offsetItems > visibleItems - 15 then
			offsetItems = visibleItems - 15
		end
	else
		offsetItems = 0
	end

	for k, v in pairs(myClothes) do
		for k2, v2 in pairs(v) do
			myBoughtClothes[v2] = true
		end
	end
end

function currentSlotSelected()
	local clothesLimit = getElementData(localPlayer, "clothesLimit") or 2
	local currentClothes = getElementData(localPlayer, "currentClothes") or ""

	myCurrentClothes = fromJSON(currentClothes) or {}

	for k, v in pairs(myCurrentClothes) do
		if not tonumber(v[11]) or clothesLimit < v[11] then
			myCurrentClothes[k] = nil
		end
	end

	local items = {}
	local cats = {}
	local subs = {}

	for i = 1, #baseCategories do
		local cat = baseCategories[i][2]

		if myCurrentClothes[cat] then
			table.insert(items, {"haveitem" .. i, i})
		else
			if myClothes[i] then
				local clothes = {}

				for j = 1, #myClothes[i] do
					table.insert(clothes, myClothes[i][j])
				end

				table.sort(clothes,
					function (a, b)
						return itemIndexes[b] > itemIndexes[a]
					end
				)

				for j = 1, #clothes do
					table.insert(items, {clothes[j], i})
				end
			else
				table.insert(items, {"noitem" .. i, i})
			end
		end
	end

	itemList = {}
	visibleItems = 0

	for i = 1, #items do
		local text = items[i][1]
		local id = items[i][2]

		if not cats[id] then
			cats[id] = true
			table.insert(itemList, {"cat", id})
		end

		if openCategories[id] then
			if text == "noitem" .. id then
				table.insert(itemList, {"noitem", id})
			elseif text == "haveitem" .. id then
				table.insert(itemList, {"haveitem", id})
			else
				local name = baseCategories[id][2]

				if subCategories[name] then
					local index = subCategorizedItems[text]

					if not subs[index] then
						subs[index] = true
						table.insert(itemList, {"sub", subTitles[index]})
					end
				end

				table.insert(itemList, {"item", text})
			end
		end
	end

	visibleItems = #itemList

	if visibleItems > 15 then
		if offsetItems > visibleItems - 15 then
			offsetItems = visibleItems - 15
		end
	else
		offsetItems = 0
	end
end

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if previewScreen then
			return
		end

		if clothesPanel then
			if activeButton then
				if button == "left" then
					if state == "up" then
						local selected = split(activeButton, ":")

						if selected[1] == "exit" then
							openMyClothes("off")
						elseif selected[1] == "unlockSlot" then
							if not buySlotProcessing then
								if unlockSlotPrompt then
									buySlotProcessing = true
									triggerServerEvent("tryToBuyClothSlot", localPlayer)

									unlockSlotPrompt = false
									playSound("files/sounds/promptaccept.mp3")
								else
									unlockSlotPrompt = true
									playSound("files/sounds/prompt.mp3")
								end
							end
						elseif selected[1] == "cancelUnlockSlot" then
							if unlockSlotPrompt then
								unlockSlotPrompt = false
								playSound("files/sounds/promptdecline.mp3")
							end
						elseif selected[1] == "selectSlot" then
							local slot = tonumber(selected[2])

							if slot then
								selectedSlot = slot
								currentSlotSelected()
								playSound("files/sounds/notification.mp3")
							end
						elseif selected[1] == "openCategory" then
							local cat = tonumber(selected[2])

							if cat then
								openCategories[cat] = not openCategories[cat]

								currentSlotSelected()

								playSound("files/sounds/category.mp3")
							end
						elseif selected[1] == "previewCloth" then
							local model = tonumber(selected[2])

							if model then
								previewCloth(model)
								playSound("files/sounds/notification.mp3")
							end
						elseif selected[1] == "delCloth" then
							local model = tonumber(selected[2])

							if model then
								delClothPrompt = model
								playSound("files/sounds/prompt.mp3")
							end
						elseif selected[1] == "cancelDelCloth" then
							if delClothPrompt then
								delClothPrompt = false
								playSound("files/sounds/promptdecline.mp3")
							end
						elseif selected[1] == "acceptDelCloth" then
							if delClothPrompt then
								local boughtClothes = getElementData(localPlayer, "boughtClothes") or ""

								boughtClothes = fromJSON(boughtClothes) or {}
								boughtClothes[tostring(delClothPrompt)] = nil

								setElementData(localPlayer, "boughtClothes", toJSON(boughtClothes, true))
								currentSlotSelected()
							end

							delClothPrompt = false
							playSound("files/sounds/promptaccept.mp3")
						elseif selected[1] == "removeCloth" then
							local cat = selected[2]

							if cat then
								local currentClothes = getElementData(localPlayer, "currentClothes") or ""

								myCurrentClothes = fromJSON(currentClothes) or {}
								myCurrentClothes[cat] = nil

								setElementData(localPlayer, "currentClothes", toJSON(myCurrentClothes, true))

								if selectedSlot then
									currentSlotSelected()
								end

								playSound("files/sounds/notification.mp3")
							end
						elseif selected[1] == "outfits" then
							outfitsPanel = not outfitsPanel
							playSound("files/sounds/switchoption.mp3")
						elseif selected[1] == "saveOutfitTo" then
							local id = tonumber(selected[2])

							if id then
								local currentClothes = getElementData(localPlayer, "currentClothes") or ""

								myOutfits[id] = {"Öltözék " .. id, currentClothes}

								playSound("files/sounds/notification.mp3")
							end
						elseif selected[1] == "delOutfit" then
							local id = tonumber(selected[2])

							if id then
								myOutfits[id] = nil
								playSound("files/sounds/notification.mp3")
							end
						elseif selected[1] == "renameOutfit" then
							local id = tonumber(selected[2])

							if id then
								if activeFakeInput == "outfit:" .. id then
									myOutfits[id][1] = fakeInputText
									activeFakeInput = false

									playSound("files/sounds/promptaccept.mp3")
								else
									cursorStateChange = getTickCount()
									cursorState = true

									fakeInputText = myOutfits[id][1]
									activeFakeInput = "outfit:" .. id

									playSound("files/sounds/prompt.mp3")
								end
							end
						elseif selected[1] == "useOutfit" then
							local id = tonumber(selected[2])

							if id then
								if myOutfits[id] then
									local outfits = fromJSON(myOutfits[id][2])

									if outfits then
										local clothesLimit = getElementData(localPlayer, "clothesLimit") or 2
										local same = false

										for k, v in pairs(outfits) do
											if not myBoughtClothes[v[1]] or not tonumber(v[11]) or clothesLimit < v[11] then
												same = true
												break
											end
										end

										if not same then
											setElementData(localPlayer, "currentClothes", myOutfits[id][2])
											playSound("files/sounds/notification.mp3")
										end
									end
								end
							end
						elseif selected[1] == "addCloth" then
							local model = tonumber(selected[2])

							if model then
								local id = categorizedItems[model]
								local cat = baseCategories[id][2]

								if cat then
									if not myLastPresets[cat] then
										myLastPresets[cat] = {}
									end

									myLastPresets[cat][1] = model

									openMyClothes("off")
									openTheEditor(cat, myLastPresets[cat], selectedSlot)

									playSound("files/sounds/notification.mp3")
								end
							end
						elseif selected[1] == "editCloth" then
							local cat = selected[2]

							if cat then
								local currentClothes = getElementData(localPlayer, "currentClothes") or ""

								myCurrentClothes = fromJSON(currentClothes) or {}

								openMyClothes("off")
								openTheEditor(cat, myCurrentClothes[cat])

								playSound("files/sounds/notification.mp3")
							end
						end
					end
				end
			end
		elseif shopPanel then
			if activeButton then
				if button == "left" then
					if state == "up" then
						local selected = split(activeButton, ":")

						if selected[1] == "exit" then
							openClothesShop("off")
						elseif selected[1] == "openCategory" then
							local cat = tonumber(selected[2])

							if cat then
								openCategories[cat] = not openCategories[cat]

								loadShopDatas()

								playSound("files/sounds/category.mp3")
							end
						elseif selected[1] == "previewCloth" then
							local model = tonumber(selected[2])

							if model then
								previewCloth(model)
								playSound("files/sounds/notification.mp3")
							end
						elseif selected[1] == "buyCloth" then
							if canBuyCloth then
								local model = tonumber(selected[2])

								if model then
									if getTickCount() - buyClothTick <= 2000 then
										exports.sm_hud:showInfobox("e", "Ilyen gyorsan nem kéne!")
										return
									end

									buyClothTick = getTickCount()
									canBuyCloth = false

									triggerServerEvent("tryToBuyCloth", localPlayer, model, itemPrices[model])

									playSound("files/sounds/switchoption.mp3")
								end
							end
						end
					end
				end
			end
		end
	end
)

function previewCloth(modelId)
	previewDatas = {getElementInterior(localPlayer), isElementFrozen(localPlayer)}
	previewModel = tonumber(modelId)
	previewZoom = 1
	previewTarget = dxCreateScreenSource(screenX, screenY)
	previewScreen = dxCreateScreenSource(previewSize, previewSize)

	dxUpdateScreenSource(previewTarget)

	local x, y, z = getElementPosition(localPlayer)
	local dimension = getElementDimension(localPlayer)

	setElementInterior(localPlayer, 255)
	setCameraMatrix(x + 1, y + 0.93, z + 10 + 0.45, x - 1, y - 0.93, z + 10 - 0.45, 0, 70)

	interiorObject = createObject(18088, x - 1, y - 0.93, z + 10 - 0.45)
	previewObject = createObject(previewModel, x - 1, y - 0.93, z + 10 - 0.45)

	setElementDoubleSided(previewObject, true)
	setElementFrozen(previewObject, true)

	setElementCollisionsEnabled(interiorObject, false)
	setElementCollisionsEnabled(previewObject, false)

	setElementInterior(interiorObject, 255)
	setElementInterior(previewObject, 255)

	setElementDimension(interiorObject, dimension)
	setElementDimension(previewObject, dimension)

	previewRotating = false

	showCursor(true)
	setElementFrozen(localPlayer, true)

	addEventHandler("onClientHUDRender", getRootElement(), renderPreviewBCG, true, "high+99999")
	addEventHandler("onClientRender", getRootElement(), renderPreview, true, "low")
	addEventHandler("onClientRestore", getRootElement(), restoreThePreview)
end

function restoreThePreview()
	setCameraTarget(localPlayer)

	removeEventHandler("onClientHUDRender", getRootElement(), renderPreviewBCG)
	removeEventHandler("onClientRender", getRootElement(), renderPreview)
	removeEventHandler("onClientRestore", getRootElement(), restoreThePreview)

	if isElement(previewScreen) then
		destroyElement(previewScreen)
	end

	if isElement(previewTarget) then
		destroyElement(previewTarget)
	end

	if isElement(interiorObject) then
		destroyElement(interiorObject)
	end

	if isElement(previewObject) then
		destroyElement(previewObject)
	end

	previewScreen = nil
	previewTarget = nil
	interiorObject = nil
	previewObject = nil
	previewRotating = false

	showCursor(false)
	setCursorAlpha(255)

	setElementInterior(localPlayer, previewDatas[1])
	setElementFrozen(localPlayer, previewDatas[2])
end

function renderPreviewBCG()
	dxDrawImage(0, 0, screenX, screenY, previewTarget)
end

function renderPreview()
	local sx = respc(500)
	local sy = respc(400)

	local x = math.floor(screenX / 2 - respc(550) / 2 + respc(550) + 10)
	local y = math.floor(screenY / 2 - respc(550) / 2 + 5)

	dxUpdateScreenSource(previewScreen)

	dxDrawText(itemNames[previewModel], x + 1, y - respc(40) + 1, x + sx + 1, y + 1, tocolor(0, 0, 0), 1, Roboto, "center", "center")
	dxDrawText(itemNames[previewModel], x, y - respc(40), x + sx, y, tocolor(200, 200, 200, 200), 1, Roboto, "center", "center")

	dxDrawRectangle(x - 5, y - 5, sx + 10, sy + 10, tocolor(25, 25, 25))
	dxDrawImageSection(x, y, sx, sy, previewSection * (previewZoom - 1), previewSection * (previewZoom - 1), previewSize - previewSection * (previewZoom - 1) * 2, previewSize - previewSection * (previewZoom - 1) * 2, previewScreen)

	dxDrawText("Forgatás: egér | Kilépés: Backspace | Nagyítás: görgő", x + 1, y + sy + 1, x + sx + 1, y + sy + respc(40) + 1, tocolor(0, 0, 0), 0.75, Roboto, "center", "center")
	dxDrawText("Forgatás: egér | Kilépés: Backspace | Nagyítás: görgő", x, y + sy, x + sx, y + sy + respc(40), tocolor(200, 200, 200, 200), 0.75, Roboto, "center", "center")

	local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		if previewRotating then
			local rx, ry, rz = getElementRotation(previewObject)

			setElementRotation(previewObject, rx, ry, (rz - (0.5 - cx) * 75) % 360)
			setCursorPosition(screenX / 2, screenY / 2)

			if not getKeyState("mouse1") then
				previewRotating = false
				setCursorAlpha(255)
			end
		else
			cx = cx * screenX
			cy = cy * screenY

			if cx >= x and cx <= x + sx and cy >= y and cy <= y + sy then
				if getKeyState("mouse1") then
					previewRotating = true
					setCursorAlpha(0)
					setCursorPosition(screenX / 2, screenY / 2)
				end
			end
		end
	end
end

addEventHandler("onClientCharacter", getRootElement(),
	function (character)
		if activeFakeInput then
			fakeInputText = fakeInputText .. character
		end
	end
)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if activeFakeInput then
			cancelEvent()

			if press and key == "backspace" then
				fakeInputText = utf8.sub(fakeInputText, 1, -2)
			end
		end

		if previewScreen then
			if key == "backspace" then
				cancelEvent()

				if not press then
					restoreThePreview()
				end
			end

			if press then
				if key == "mouse_wheel_down" then
					if previewZoom > 1 then
						previewZoom = previewZoom - 0.1
					end
				elseif key == "mouse_wheel_up" then
					if previewZoom < 1.75 then
						previewZoom = previewZoom + 0.1
					end
				end
			end
		elseif shopPanel then
			if key == "mouse_wheel_up" then
				if offsetItems > 0 then
					offsetItems = offsetItems - 1
				end
			elseif key == "mouse_wheel_down" then
				if offsetItems < visibleItems - 15 then
					offsetItems = offsetItems + 1
				end
			end
		elseif selectedSlot then
			if key == "mouse_wheel_up" then
				if offsetItems > 0 then
					offsetItems = offsetItems - 1
				end
			elseif key == "mouse_wheel_down" then
				if offsetItems < visibleItems - 15 then
					offsetItems = offsetItems + 1
				end
			end
		end
	end
)

function renderClothesShop()
	local sx = respc(550)
	local sy = respc(550)

	--renderPreview

	local x = math.floor(screenX / 2 - sx / 2)
	local y = math.floor(screenY / 2 - sy / 2)

	dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))
	--dxDrawImage(x, y + respc(40), sx, sy - respc(40), ":sm_hud/files/images/vin.png")

	-- ** Cím
	dxDrawRectangle(x + 4, y + 4, sx - 8, respc(40) - 4, tocolor(45, 45, 45, 180))
	dxDrawText("#3d7abcStrong#ffffffMTA #ffffff- Ruha bolt", x + respc(7.5), y, x + sx, y + respc(40), tocolor(200, 200, 200, 200), 1, Roboto, "left", "center", false, false, false, true)

	-- ** Content
	local buttons = {}
	buttonsC = {}

	buttons.exit = {x + sx - respc(28) - respc(5), y + respc(40) / 2 - respc(14), respc(28), respc(28)}

	if activeButton == "exit" then
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/images/close.png", 0, 0, 0, tocolor(215, 89, 89, 200))
	else
		dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/images/close.png", 0, 0, 0, tocolor(200, 200, 200, 200))
	end

	-- Lista
	y = y + respc(40) + respc(5)

	local itemSizeX = sx - respc(10)
	local itemSizeY = (sy - respc(40) - respc(10)) / 15

	for i = 1, 15 do
		local itemX = x + respc(5)
		local itemY = y + itemSizeY * (i - 1)

		if i % 2 ~= offsetItems % 2 then
			dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY, tocolor(45, 45, 45, 125))
		else
			dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY, tocolor(55, 55, 55, 150))
		end

		local item = itemList[i + offsetItems]

		if item then
			if item[1] == "cat" then
				local cat = item[2]

				if baseCategories[cat] then
					if activeButton == "openCategory:" .. cat then
						dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY, tocolor(61, 122, 188, 120))
					end

					if openCategories[cat] then
						dxDrawImage(itemX + respc(10), itemY + itemSizeY / 2 - respc(8), respc(16), respc(16), "files/images/arrow.png", 90, 0, 0, tocolor(200, 200, 200))
					else
						dxDrawImage(itemX + respc(10), itemY + itemSizeY / 2 - respc(8), respc(16), respc(16), "files/images/arrow.png", 0, 0, 0, tocolor(200, 200, 200))
					end

					dxDrawText(baseCategories[cat][1], itemX + respc(10) + respc(20), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")

					buttons["openCategory:" .. cat] = {itemX, itemY, itemSizeX, itemSizeY}
				end
			else
				if item[1] == "sub" then
					dxDrawText(item[2], itemX + respc(20), itemY, 0, itemY + itemSizeY, tocolor(61, 122, 188, 200), 0.75, Roboto, "left", "center")
				else
					local model = item[2]

					if itemMods[model] then
						local id = categorizedItems[model]
						local cat = baseCategories[id][2]

						if subCategories[cat] then
							dxDrawText(itemNames[model], itemX + respc(30), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")
						else
							dxDrawText(itemNames[model], itemX + respc(20), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")
						end

						if myBoughtClothes[model] then
							-- Előnézet
							local btnSize = dxGetTextWidth("Előnézet", 0.7, Roboto) + respc(7)
							local btnName = "previewCloth:" .. model

							buttons[btnName] = {itemX + itemSizeX - respc(10) - btnSize, itemY + itemSizeY / 2 - (itemSizeY - respc(8)) / 2, btnSize, itemSizeY - respc(8)}

							drawButton(btnName, "Előnézet", buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], {61, 122, 188}, false, Roboto, true, 0.7)
							-- Információ
							dxDrawText("Megvéve", itemX, itemY, buttons[btnName][1] - respc(5), itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.7, Roboto, "right", "center")
						else
							-- Előnézet
							local previewSize = dxGetTextWidth("Előnézet", 0.7, Roboto) + respc(7)
							local previewName = "previewCloth:" .. model

							buttons[previewName] = {itemX + itemSizeX - respc(10) - previewSize, itemY + itemSizeY / 2 - (itemSizeY - respc(8)) / 2, previewSize, itemSizeY - respc(8)}
							drawButton(previewName, "Előnézet", buttons[previewName][1], buttons[previewName][2], buttons[previewName][3], buttons[previewName][4], {61, 122, 188}, false, Roboto, true, 0.7)
							-- Vásárlás
							local buySize = dxGetTextWidth("Megvétel", 0.7, Roboto) + respc(7)
							local buyName = "buyCloth:" .. model

							buttons[buyName] = {buttons[previewName][1] - respc(5) - buySize, buttons[previewName][2], buySize, buttons[previewName][4]}

							drawButton(buyName, "Megvétel", buttons[buyName][1], buttons[buyName][2], buttons[buyName][3], buttons[buyName][4], {61, 122, 188}, false, Roboto, true, 0.7)

							-- Ár
							dxDrawText("Ár: " .. itemPrices[item[2]] .. "$", itemX, itemY, buttons[buyName][1] - respc(5), itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.7, Roboto, "right", "center")
						end
					end
				end
			end
		end
	end

	if visibleItems > 15 then
		local trackHeight = itemSizeY * 15
		local contentRatio = trackHeight / visibleItems

		dxDrawRectangle(x + sx - respc(10), y, respc(5), trackHeight, tocolor(0, 0, 0, 200))
		dxDrawRectangle(x + sx - respc(10), y + offsetItems * contentRatio, respc(5), contentRatio * 15, tocolor(61, 122, 188, 150))
	end

	-- ** Button handler
	activeButton = false
	activeButtonC = false

	if isCursorShowing() then
		local relX, relY = getCursorPosition()
		local absX, absY = relX * screenX, relY * screenY

		for k, v in pairs(buttons) do
			if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
				activeButton = k
				activeButtonC = k
				break
			end
		end
	end
end

function renderMyClothes()
	local buttons = {}
	buttonsC = {}

	if delClothPrompt then
		local sx = respc(600)
		local sy = respc(100)

		local x = math.floor(screenX / 2 - sx / 2)
		local y = math.floor(screenY / 2 - sy / 2) - respc(50) / 2

		-- ** Háttér
		dxDrawRectangle(x, y, sx, sy + respc(50), tocolor(25, 25, 25))
		--dxDrawImage(x, y + respc(40), sx, sy - respc(40), ":sm_hud/files/images/vin.png")

		-- ** Content
		dxDrawText("Ténylegesen szeretnéd törölni a következő kiegészítőt?\n#ADADAD" .. itemNames[delClothPrompt], x, y, x + sx, y + sy, tocolor(200, 200, 200, 200), 0.85, Roboto, "center", "center", false, false, false, true)

		-- Elfogadás
		buttons.acceptDelCloth = {x + respc(3), y + sy - resp(3), sx / 2 - resp(6), respc(50)}

		drawButton("acceptDelCloth", "Igen", buttons.acceptDelCloth[1], buttons.acceptDelCloth[2], buttons.acceptDelCloth[3], buttons.acceptDelCloth[4], {215, 89, 89}, false, Roboto, true, 0.7)
		--drawButton(acceptDelCloth, "Átnevezés", buttons[renameName][1], buttons[renameName][2], buttons[renameName][3], buttons[renameName][4], {61, 122, 188}, false, Roboto, true, 0.7)
		-- Elutasítás
		buttons.cancelDelCloth = {x + sx / 2 + respc(3), y + sy - resp(3), sx / 2 - resp(6), respc(50)}

		drawButton("cancelDelCloth", "Nem", buttons.cancelDelCloth[1], buttons.cancelDelCloth[2], buttons.cancelDelCloth[3], buttons.cancelDelCloth[4], {61, 122, 188}, false, Roboto, true, 0.7)
	
	elseif not selectedSlot then
		local sx = respc(550)
		local sy = respc(450)

		local x = math.floor(screenX / 2 - sx / 2)
		local y = math.floor(screenY / 2 - sy / 2)

		-- ** Háttér
		dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))

		-- ** Cím
		dxDrawRectangle(x + 4, y + 4, sx - 8, respc(40) - 4, tocolor(45, 45, 45, 180))

		if outfitsPanel then
			dxDrawText("#3d7abcStrong#ffffffMTA #ffffff- Öltözékek", x + respc(7.5), y + 2, x + sx, y + 2 + respc(40), tocolor(200, 200, 200, 200), 1, Roboto, "left", "center", false, false, false, true)
		else
			dxDrawText("#3d7abcStrong#ffffffMTA #ffffff- Kiegészítőid", x + respc(7.5), y + 2, x + sx, y + 2 + respc(40), tocolor(200, 200, 200, 200), 1, Roboto, "left", "center", false, false, false, true)
		end

		-- ** Content
		buttons.exit = {x + sx - respc(28) - respc(5), y + respc(40) / 2 - respc(14), respc(28), respc(28)}

		if activeButton == "exit" then
			dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/images/close.png", 0, 0, 0, tocolor(215, 89, 89))
		else
			dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/images/close.png", 0, 0, 0, tocolor(200, 200, 200, 200))
		end

		-- Lista
		if outfitsPanel then
			local y = y + respc(40) + respc(5)

			local itemSizeX = sx - respc(10)
			local itemSizeY = (sy - respc(40) - respc(10) - respc(25)) / 8

			for i = 1, 8 do
				local itemX = x + respc(5)
				local itemY = y + itemSizeY * (i - 1) + respc(5)

				if not myOutfits[i] then
					dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(35, 35, 35, 180))

					if activeButton == "saveOutfitTo:" .. i then
						dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(61, 122, 188, 100))
					end

					dxDrawText("Jelenlegi öltözék mentése", itemX, itemY, itemX + itemSizeX, itemY + itemSizeY - respc(10), tocolor(200, 200, 200, 200), 0.7, Roboto, "center", "center")

					buttons["saveOutfitTo:" .. i] = {itemX, itemY, itemSizeX, itemSizeY - respc(10)}
				else
					dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(35, 35, 35, 180))

					if activeFakeInput == "outfit:" .. i then
						if cursorState then
							dxDrawText(fakeInputText .. "|", itemX + respc(10), itemY, 0, itemY + itemSizeY - respc(10), tocolor(200, 200, 200, 200), 0.7, Roboto, "left", "center")
						else
							dxDrawText(fakeInputText, itemX + respc(10), itemY, 0, itemY + itemSizeY - respc(10), tocolor(200, 200, 200, 200), 0.7, Roboto, "left", "center")
						end

						if getTickCount() - cursorStateChange > 500 then
							cursorStateChange = getTickCount()
							cursorState = not cursorState
						end

						-- Átnevezés
						local btnSize = dxGetTextWidth("Átnevezés", 0.7, Roboto) + respc(12)
						local btnName = "renameOutfit:" .. i

						buttons[btnName] = {itemX + itemSizeX - respc(10) - btnSize, itemY + respc(8), btnSize, itemSizeY - respc(10) - respc(16)}

						--if activeButton == btnName then
						--	dxDrawRectangle(buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], tocolor(61, 122, 188))
						--else
						--	dxDrawRectangle(buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], tocolor(61, 122, 188, 180))
						--end
						drawButton(btnName, "Átnevezés", buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], {61, 122, 188}, false, Roboto, true, 0.7)
						--dxDrawText("Átnevezés", buttons[btnName][1], buttons[btnName][2], buttons[btnName][1] + buttons[btnName][3], buttons[btnName][2] + buttons[btnName][4], tocolor(0, 0, 0), 0.7, Roboto, "center", "center")
					else
						if activeButton == "useOutfit:" .. i then
							dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(61, 122, 188, 100))
						end

						-- Törlés
						local delSize = dxGetTextWidth("Törlés", 0.7, Roboto) + respc(12)
						local delName = "delOutfit:" .. i

						buttons[delName] = {itemX + itemSizeX - respc(10) - delSize, itemY + respc(8), delSize, itemSizeY - respc(10) - respc(16)}

						drawButton(delName, "Törlés", buttons[delName][1], buttons[delName][2], buttons[delName][3], buttons[delName][4], {215, 89, 89}, false, Roboto, true, 0.7)
						-- Átnevezés
						local renameSize = dxGetTextWidth("Átnevezés", 0.7, Roboto) + respc(12)
						local renameName = "renameOutfit:" .. i

						buttons[renameName] = {buttons[delName][1] - respc(5) - renameSize, buttons[delName][2], renameSize, buttons[delName][4]}

						drawButton(renameName, "Átnevezés", buttons[renameName][1], buttons[renameName][2], buttons[renameName][3], buttons[renameName][4], {61, 122, 188}, false, Roboto, true, 0.7)
						-- Item
						dxDrawText(myOutfits[i][1], itemX + respc(10), itemY, 0, itemY + itemSizeY - respc(10), tocolor(200, 200, 200, 200), 0.7, Roboto, "left", "center")

						buttons["useOutfit:" .. i] = {itemX, itemY, itemSizeX - buttons[delName][3] - buttons[renameName][3] - respc(10) * 3, itemSizeY - respc(10)}
					end
				end
			end
		else
			local y = y + respc(40) + respc(5)

			local categoryNum = #baseCategories
			local itemSizeX = sx - respc(10)
			local itemSizeY = (sy - respc(40) - respc(10) - respc(25)) / categoryNum

			for i = 1, categoryNum do
				local itemX = x + respc(5)
				local itemY = y + itemSizeY * (i - 1) + respc(5)

				if i == myClothesLimit + 1 then
					dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(45, 45, 45, 180))

					if unlockSlotPrompt then
						dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(35, 35, 35, 180))
						dxDrawText("Megveszed a slotot #4aabd01000 PP#ffffff-ért?", itemX + respc(10), itemY, 0, itemY + itemSizeY - respc(10), tocolor(200, 200, 200, 200), 0.7, Roboto, "left", "center", false, false, false, true)

						-- Mégsem
						local cancelWidth = dxGetTextWidth("Nem", 0.7, Roboto) + respc(20)

						buttons.cancelUnlockSlot = {itemX + itemSizeX - respc(10) - cancelWidth, itemY + respc(8), cancelWidth, itemSizeY - respc(10) - respc(16)}


						drawButton("cancelUnlockSlot", "Nem", buttons.cancelUnlockSlot[1], buttons.cancelUnlockSlot[2], buttons.cancelUnlockSlot[3], buttons.cancelUnlockSlot[4], {215, 89, 89}, false, Roboto, true, 0.7)

						-- Vásárlás
						local acceptWidth = dxGetTextWidth("Igen", 0.7, Roboto) + respc(20)

						buttons.unlockSlot = {buttons.cancelUnlockSlot[1] - acceptWidth - respc(10), buttons.cancelUnlockSlot[2], buttons.cancelUnlockSlot[3], buttons.cancelUnlockSlot[4]}

						drawButton("unlockSlot", "Igen", buttons.unlockSlot[1], buttons.unlockSlot[2], buttons.unlockSlot[3], buttons.unlockSlot[4], {61, 122, 188}, false, Roboto, true, 0.7)
						--dxDrawText("Igen", buttons.unlockSlot[1], buttons.unlockSlot[2], buttons.unlockSlot[1] + buttons.unlockSlot[3], buttons.unlockSlot[2] + buttons.unlockSlot[4], tocolor(0, 0, 0), 0.7, Roboto, "center", "center")
					else
						if activeButton == "unlockSlot" then
							dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(61, 122, 188, 100))
						end

						dxDrawText("#ADADADZárolt slot - #ffffffSlot megvásárlása #4aabd01000 PP#ADADAD-ért", itemX, itemY, itemX + itemSizeX, itemY + itemSizeY - respc(10), tocolor(200, 200, 200, 200), 0.7, Roboto, "center", "center", false, false, false, true)

						buttons["unlockSlot"] = {itemX, itemY, itemSizeX, itemSizeY - respc(10)}
					end
				elseif i > myClothesLimit + 1 then
					dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(188, 64, 61, 100))
					dxDrawText("Zárolt slot", itemX, itemY, itemX + itemSizeX, itemY + itemSizeY - respc(10), tocolor(173, 173, 173), 0.7, Roboto, "center", "center")
				else
					dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(35, 35, 35, 180))

					if clothSlotInUse[i] then
						local cat = baseCategories[categorizedItems[clothSlotInUse[i]]][2]

						dxDrawText(itemNames[clothSlotInUse[i]], itemX + respc(10), itemY, 0, itemY + itemSizeY - respc(10), tocolor(200, 200, 200, 200), 0.7, Roboto, "left", "center")

						-- Levétel
						local removeSize = dxGetTextWidth("Levétel", 0.7, Roboto) + respc(20)
						local removeName = "removeCloth:" .. cat

						buttons[removeName] = {itemX + itemSizeX - respc(10) - removeSize, itemY + respc(8), removeSize, itemSizeY - respc(10) - respc(16)}

						drawButton(removeName, "Levétel", buttons[removeName][1], buttons[removeName][2], buttons[removeName][3], buttons[removeName][4], {215, 89, 89}, false, Roboto, true, 0.7)

						-- Szerkesztés
						local moveSize = dxGetTextWidth("Mozgatás", 0.7, Roboto) + respc(20)
						local moveName = "editCloth:" .. cat

						buttons[moveName] = {buttons[removeName][1] - moveSize - respc(10), buttons[removeName][2], moveSize, buttons[removeName][4]}

						drawButton(moveName, "Mozgatás", buttons[moveName][1], buttons[moveName][2], buttons[moveName][3], buttons[moveName][4], {61, 122, 188}, false, Roboto, true, 0.7)
					else
						if activeButton == "selectSlot:" .. i then
							dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY - respc(10), tocolor(61, 122, 188, 100))
						end

						dxDrawText("Üres slot", itemX, itemY, itemX + itemSizeX, itemY + itemSizeY - respc(10), tocolor(200, 200, 200, 200), 0.7, Roboto, "center", "center")

						buttons["selectSlot:" .. i] = {itemX, itemY, itemSizeX, itemSizeY - respc(10)}
					end
				end
			end
		end

		-- Öltözékek
		buttons.outfits = {x, y + sy - respc(25), sx, respc(25)}

		if activeButton == "outfits" then
			dxDrawRectangle(buttons.outfits[1], buttons.outfits[2], buttons.outfits[3], buttons.outfits[4], tocolor(0, 0, 0, 200))
		else
			dxDrawRectangle(buttons.outfits[1], buttons.outfits[2], buttons.outfits[3], buttons.outfits[4], tocolor(0, 0, 0, 100))
		end

		if outfitsPanel then
			dxDrawText("Kiegészítőim", buttons.outfits[1], buttons.outfits[2], buttons.outfits[1] + buttons.outfits[3], buttons.outfits[2] + buttons.outfits[4], tocolor(200, 200, 200, 200), 0.7, Roboto, "center", "center")
		else
			dxDrawText("Öltözékek", buttons.outfits[1], buttons.outfits[2], buttons.outfits[1] + buttons.outfits[3], buttons.outfits[2] + buttons.outfits[4], tocolor(200, 200, 200, 200), 0.7, Roboto, "center", "center")
		end
	else
		local sx = respc(550)
		local sy = respc(550)

		local x = math.floor(screenX / 2 - sx / 2)
		local y = math.floor(screenY / 2 - sy / 2)

		-- ** Háttér
		dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))

		-- ** Cím
		dxDrawRectangle(x + 3, y + 3, sx - 6, respc(40) - 3, tocolor(45, 45, 45, 170))
		dxDrawText("#3d7abcStrong#ffffffMTA #ffffff- Ruházat", x + respc(7.5), y, x + sx, y + respc(40), tocolor(200, 200, 200, 200), 1, Roboto, "left", "center", false, false, false, true)

		-- ** Content
		buttons.exit = {x + sx - respc(28) - respc(5), y + respc(40) / 2 - respc(14), respc(28), respc(28)}

		if activeButton == "exit" then
			dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/images/close.png", 0, 0, 0, tocolor(215, 89, 89))
		else
			dxDrawImage(buttons.exit[1], buttons.exit[2], buttons.exit[3], buttons.exit[4], "files/images/close.png", 0, 0, 0, tocolor(200, 200, 200, 200))
		end

		-- Lista
		y = y + respc(40) + respc(5)

		local itemSizeX = sx - respc(10)
		local itemSizeY = (sy - respc(40) - respc(10)) / 15

		for i = 1, 15 do
			local itemX = x + respc(5)
			local itemY = y + itemSizeY * (i - 1)

			if i % 2 ~= offsetItems % 2 then
				dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY, tocolor(35, 35, 35, 125))
			else
				dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY, tocolor(45, 45, 45, 150))
			end

			local item = itemList[i + offsetItems]

			if item then
				if item[1] == "cat" then
					local cat = item[2]

					if baseCategories[cat] then
						if activeButton == "openCategory:" .. cat then
							dxDrawRectangle(itemX, itemY, itemSizeX, itemSizeY, tocolor(0, 0, 0, 100))
						end

						if openCategories[cat] then
							dxDrawImage(itemX + respc(10), itemY + itemSizeY / 2 - respc(8), respc(16), respc(16), "files/images/arrow.png", 90, 0, 0, tocolor(200, 200, 200))
						else
							dxDrawImage(itemX + respc(10), itemY + itemSizeY / 2 - respc(8), respc(16), respc(16), "files/images/arrow.png", 0, 0, 0, tocolor(200, 200, 200))
						end

						dxDrawText(baseCategories[cat][1], itemX + respc(10) + respc(20), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")

						buttons["openCategory:" .. cat] = {itemX, itemY, itemSizeX, itemSizeY}
					end
				else
					if item[1] == "noitem" then
						local cat = item[2]

						if baseCategories[cat] then
							dxDrawText("Nincsenek kiegészítőid ebben a kategóriában", itemX + respc(20), itemY, 0, itemY + itemSizeY, tocolor(150, 150, 150, 200), 0.75, Roboto, "left", "center")
						end
					elseif item[1] == "haveitem" then
						local cat = item[2]

						if baseCategories[cat] then
							dxDrawText("Már van felvéve ebből a kategóriából.", itemX + respc(20) + respc(16), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")

							-- Levétel
							local btnSize = dxGetTextWidth("Levétel", 0.7, Roboto) + respc(12)
							local btnName = "removeCloth:" .. baseCategories[cat][2]

							buttons[btnName] = {itemX + itemSizeX - respc(10) - btnSize, itemY + itemSizeY / 2 - (itemSizeY - respc(8)) / 2, btnSize, itemSizeY - respc(8)}

							drawButton(btnName, "Levétel", buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], {215, 89, 89}, false, Roboto, true, 0.7)
						end
					elseif item[1] == "sub" then
						dxDrawText(item[2], itemX + respc(20), itemY, 0, itemY + itemSizeY, tocolor(61, 122, 188, 160), 0.75, Roboto, "left", "center")
					else
						local model = item[2]

						if itemMods[model] and itemIndexes[model] then
							local id = categorizedItems[model]
							local cat = baseCategories[id][2]

							if subCategories[cat] then
								if not groupClothes[model] then
									local btnName = "delCloth:" .. model

									buttons[btnName] = {itemX + respc(30), itemY + itemSizeY / 2 - respc(5), respc(12), respc(10)}

									if activeButton == btnName then
										dxDrawImage(buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], "files/images/reset.png", 0, 0, 0, tocolor(215, 89, 89))
									else
										dxDrawImage(buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], "files/images/reset.png")
									end

									dxDrawText(itemNames[model], itemX + respc(30) + respc(16), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")
								else
									dxDrawText(itemNames[model], itemX + respc(30), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")
								end
							else
								if not groupClothes[model] then
									local btnName = "delCloth:" .. model

									buttons[btnName] = {itemX + respc(20), itemY + itemSizeY / 2 - respc(5), respc(12), respc(10)}

									if activeButton == btnName then
										dxDrawImage(buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], "files/images/reset.png", 0, 0, 0, tocolor(215, 89, 89))
									else
										dxDrawImage(buttons[btnName][1], buttons[btnName][2], buttons[btnName][3], buttons[btnName][4], "files/images/reset.png")
									end

									dxDrawText(itemNames[model], itemX + respc(20) + respc(16), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")
								else
									dxDrawText(itemNames[model], itemX + respc(20), itemY, 0, itemY + itemSizeY, tocolor(200, 200, 200, 200), 0.75, Roboto, "left", "center")
								end
							end

							-- Előnézet
							local addSize = dxGetTextWidth("Kiválaszt", 0.7, Roboto) + respc(12)
							local addName = "addCloth:" .. model

							buttons[addName] = {itemX + itemSizeX - respc(10) - addSize, itemY + itemSizeY / 2 - (itemSizeY - respc(8)) / 2, addSize, itemSizeY - respc(8)}


							drawButton(addName, "Kiválaszt", buttons[addName][1], buttons[addName][2], buttons[addName][3], buttons[addName][4], {61, 122, 188}, false, Roboto, true, 0.7)

							-- Előnézet
							local previewSize = dxGetTextWidth("Előnézet", 0.7, Roboto) + respc(12)
							local previewName = "previewCloth:" .. model

							buttons[previewName] = {buttons[addName][1] - respc(5) - previewSize, buttons[addName][2], previewSize, buttons[addName][4]}

							drawButton(previewName, "Előnézet", buttons[previewName][1], buttons[previewName][2], buttons[previewName][3], buttons[previewName][4], {61, 122, 188}, false, Roboto, true, 0.7)
						end
					end
				end
			end
		end

		if visibleItems > 15 then
			local trackHeight = itemSizeY * 15
			local contentRatio = trackHeight / visibleItems

			dxDrawRectangle(x + sx - respc(10), y, respc(5), trackHeight, tocolor(0, 0, 0, 200))
			dxDrawRectangle(x + sx - respc(10), y + offsetItems * contentRatio, respc(5), contentRatio * 15, tocolor(61, 122, 188, 150))
		end
	end

	-- ** Button handler
	activeButton = false
	activeButtonC = false

	if isCursorShowing() then
		local relX, relY = getCursorPosition()
		local absX, absY = relX * screenX, relY * screenY

		for k, v in pairs(buttons) do
			if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
				activeButton = k
				activeButtonC = k
				break
			end
		end
	end
end

function openTheEditor(category, datas, slot)
	editorFont = dxCreateFont("files/Roboto.ttf", respc(10), false, "antialiased")
	editorType = category

	if category == "watches" then
		triggerServerEvent("onNeededForWaitAim", localPlayer)
	end

	processClothes(localPlayer, category)

	local x, y, z = getElementPosition(localPlayer)
	local interior = getElementInterior(localPlayer)
	local dimension = getElementDimension(localPlayer)

	editorMainObject = createObject(datas[1] or 1242, x, y, z)
	editorDummyObject = createObject(datas[1] or 1242, x, y, z)

	setElementFrozen(editorMainObject, true)
	setElementFrozen(editorDummyObject, true)

	setElementCollisionsEnabled(editorMainObject, false)
	setElementCollisionsEnabled(editorDummyObject, false)

	setElementInterior(editorMainObject, interior)
	setElementInterior(editorDummyObject, interior)

	setElementDimension(editorMainObject, dimension)
	setElementDimension(editorDummyObject, dimension)

	setElementDoubleSided(editorMainObject, itemFlags[datas[1]] or false)
	setElementAlpha(editorDummyObject, 0)

	exports.sm_boneattach:attachElementToBone(editorMainObject, localPlayer, boneCategories[category], datas[2] or 0, datas[3] or 0, datas[4] or 0, datas[5] or 0, datas[6] or 0, datas[7] or 0)
	--exports.sm_core:toggleHeadMove(0)

	setElementPosition(localPlayer, x, y, z)

	addEventHandler("onClientRender", getRootElement(), moveObjectRender)
	addEventHandler("onClientClick", getRootElement(), moveObjectClick)

	editorScaleX, editorScaleY, editorScaleZ = datas[8] or 1, datas[9] or 1, datas[10] or 1
	setTimer(setObjectScale, 100, 1, editorMainObject, editorScaleX, editorScaleY, editorScaleZ)

	editorSlot = slot or datas[11] or 0
end

function elementOffset(m, x, y, z)
	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
			x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
			x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end

function moveObjectClick(button, state)
	if button == "left" then
		if state == "up" then
			if activeButton == "moveObject:move" then
				if activeMode ~= "move" then
					activeMode = "move"
					playSound("files/sounds/switchoption.mp3")
				end
			elseif activeButton == "moveObject:rotate" then
				if activeMode ~= "rotate" then
					activeMode = "rotate"
					playSound("files/sounds/switchoption.mp3")
				end
			elseif activeButton == "moveObject:scale" then
				if activeMode ~= "scale" then
					activeMode = "scale"
					playSound("files/sounds/switchoption.mp3")
				end
			elseif activeButton == "moveObject:reset" then
				if editorType then
					local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)

					myLastPresets[editorType] = {getElementModel(editorMainObject), x, y, z, rx, ry, rz, 1, 1, 1}

					exports.sm_boneattach:setElementBonePositionOffset(editorMainObject, 0, 0, 0)
					exports.sm_boneattach:setElementBoneRotationOffset(editorMainObject, 0, 0, 0)

					editorScaleX, editorScaleY, editorScaleZ = 1, 1, 1
					setObjectScale(editorMainObject, editorScaleX, editorScaleY, editorScaleZ)

					playSound("files/sounds/switchoption.mp3")
				end
			elseif activeButton == "moveObject:save" then
				if editorType == "watches" then
					triggerServerEvent("onNeededForWaitAim", localPlayer, "off")
				end

				removeEventHandler("onClientRender", getRootElement(), moveObjectRender)
				removeEventHandler("onClientClick", getRootElement(), moveObjectClick)

				if editorType then
					local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)
					local currentClothes = getElementData(localPlayer, "currentClothes") or ""

					currentClothes = fromJSON(currentClothes) or {}
					currentClothes[editorType] = {getElementModel(editorMainObject), x, y, z, rx, ry, rz, editorScaleX, editorScaleY, editorScaleZ, editorSlot}
					myCurrentClothes[editorType] = currentClothes[editorType]

					if getElementData(localPlayer, "currentClothes") == toJSON(currentClothes, true) then
						processClothes(localPlayer)
					else
						setElementData(localPlayer, "currentClothes", toJSON(currentClothes, true))
					end

					destroyElement(editorMainObject)
					destroyElement(editorDummyObject)
					destroyElement(editorFont)

					editorType = false
					--exports.sm_core:toggleHeadMove(1)

					playSound("files/sounds/promptaccept.mp3")
				end
			elseif activeButton == "moveObject:presets" then
				if editorType then
					presetsPanel = not presetsPanel
					playSound("files/sounds/switchoption.mp3")
				end
			elseif activeButton == "preset:loadTheDef" then
				if presetsPanel then
					local clothData = myCurrentClothes[editorType]
					local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)

					myLastPresets[editorType] = {getElementModel(editorMainObject), x, y, z, rx, ry, rz, editorScaleX, editorScaleY, editorScaleZ, editorSlot}

					exports.sm_boneattach:setElementBonePositionOffset(editorMainObject, clothData[2] or 0, clothData[3] or 0, clothData[4] or 0)
					exports.sm_boneattach:setElementBoneRotationOffset(editorMainObject, clothData[5] or 0, clothData[6] or 0, clothData[7] or 0)

					editorScaleX, editorScaleY, editorScaleZ = clothData[8] or 1, clothData[9] or 1, clothData[10] or 1
					setObjectScale(editorMainObject, editorScaleX, editorScaleY, editorScaleZ)

					playSound("files/sounds/switchoption.mp3")
				end
			elseif activeButton == "preset:loadTheLast" then
				if presetsPanel then
					local clothData = myLastPresets[editorType]
					local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)

					if not clothData then
						clothData = myCurrentClothes[editorType]
					end

					myLastPresets[editorType] = {getElementModel(editorMainObject), x, y, z, rx, ry, rz, editorScaleX, editorScaleY, editorScaleZ, editorSlot}

					exports.sm_boneattach:setElementBonePositionOffset(editorMainObject, clothData[2] or 0, clothData[3] or 0, clothData[4] or 0)
					exports.sm_boneattach:setElementBoneRotationOffset(editorMainObject, clothData[5] or 0, clothData[6] or 0, clothData[7] or 0)

					editorScaleX, editorScaleY, editorScaleZ = clothData[8] or 1, clothData[9] or 1, clothData[10] or 1
					setObjectScale(editorMainObject, editorScaleX, editorScaleY, editorScaleZ)

					playSound("files/sounds/switchoption.mp3")
				end
			elseif activeButton == "preset:new" then
				if presetsPanel then
					local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)

					if not myPresets[editorType] then
						myPresets[editorType] = {}
					end

					table.insert(myPresets[editorType], {getElementModel(editorMainObject), x, y, z, rx, ry, rz, editorScaleX, editorScaleY, editorScaleZ, false})

					playSound("files/sounds/switchoption.mp3")
				end
			elseif activeButton then
				if presetsPanel then
					local selected = split(activeButton, ":")

					if selected[2] == "rename" then
						local id = tonumber(selected[3])

						if id then
							if activeFakeInput == "preset:" .. id then
								if fakeInputText ~= "Elrendezés #" .. id then
									myPresets[editorType][id][11] = fakeInputText
								end

								activeFakeInput = false
								playSound("files/sounds/promptaccept.mp3")
							else
								cursorStateChange = getTickCount()
								cursorState = true

								fakeInputText = myPresets[editorType][id][11] or "Elrendezés #" .. id
								activeFakeInput = "preset:" .. id

								playSound("files/sounds/switchoption.mp3")
							end
						end
					elseif selected[2] == "load" then
						local id = tonumber(selected[3])

						if id then
							local clothData = myPresets[editorType][id]
							local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)

							if not clothData then
								clothData = myCurrentClothes[editorType]
							end

							myLastPresets[editorType] = {getElementModel(editorMainObject), x, y, z, rx, ry, rz, editorScaleX, editorScaleY, editorScaleZ}

							exports.sm_boneattach:setElementBonePositionOffset(editorMainObject, clothData[2] or 0, clothData[3] or 0, clothData[4] or 0)
							exports.sm_boneattach:setElementBoneRotationOffset(editorMainObject, clothData[5] or 0, clothData[6] or 0, clothData[7] or 0)

							editorScaleX, editorScaleY, editorScaleZ = clothData[8] or 1, clothData[9] or 1, clothData[10] or 1
							setObjectScale(editorMainObject, editorScaleX, editorScaleY, editorScaleZ)

							playSound("files/sounds/switchoption.mp3")
						end
					elseif selected[2] == "del" then
						local id = tonumber(selected[3])

						if id then
							myPresets[editorType][id] = nil

							local temp = {}
							local biggest = 0

							for k, v in pairs(myPresets[editorType]) do
								if k > biggest then
									biggest = k
								end
							end

							for i = 1, biggest do
								if myPresets[editorType][i] then
									table.insert(temp, myPresets[editorType][i])
								end
							end

							myPresets[editorType] = temp
						end
					end
				end
			end
		end
	end
end

setCursorAlpha(255)

function moveObjectRender()
	local dummyPosX, dummyPosY, dummyPosZ = getElementPosition(editorDummyObject)
	local dummyRotX, dummyRotY, dummyRotZ = getElementRotation(editorDummyObject)

	local mainPosX, mainPosY, mainPosZ = getElementPosition(editorMainObject)
	local mainRotX, mainRotY, mainRotZ = getElementRotation(editorMainObject)

	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local playerRotX, playerRotY, playerRotZ = getElementRotation(localPlayer)

	local objectMatrix = getElementMatrix(editorDummyObject)

	setElementPosition(editorDummyObject, mainPosX, mainPosY, mainPosZ)
	setElementRotation(editorDummyObject, playerRotX, playerRotY, playerRotZ)

	local cursorX, cursorY = getCursorPosition()

	if not cursorX and not cursorY and activeAxis then
		activeAxis = false
		setCursorAlpha(255)
	end

	-- ** Menü
	local obj2dX, obj2dY = getScreenFromWorldPosition(dummyPosX, dummyPosY, dummyPosZ)
	local menu2dX, menu2dY = getScreenFromWorldPosition(elementOffset(objectMatrix, 0, 0, -0.25))

	activeButton = false

	if menu2dX and menu2dY and not activeAxis then
		menu2dX = math.floor(menu2dX)
		menu2dY = math.floor(menu2dY)

		-- Mozgatás
		if activeMode ~= "move" then
			dxDrawRectangle(menu2dX - 8, menu2dY - 8, 16, 16, tocolor(61, 122, 188))
		else
			dxDrawRectangle(menu2dX - 8, menu2dY - 8, 16, 16, tocolor(215, 89, 89))
		end

		dxDrawImage(menu2dX - 8, menu2dY - 8, 16, 16, "files/images/move.png", 0, 0, 0, tocolor(0, 0, 0))

		-- Forgatás
		if activeMode ~= "rotate" then
			dxDrawRectangle(menu2dX - 8 + 20, menu2dY - 8, 16, 16, tocolor(61, 122, 188))
		else
			dxDrawRectangle(menu2dX - 8 + 20, menu2dY - 8, 16, 16, tocolor(215, 89, 89))
		end

		dxDrawImage(menu2dX - 8 + 20, menu2dY - 8, 16, 16, "files/images/rotate.png", 0, 0, 0, tocolor(0, 0, 0))

		-- Méretezés
		if activeMode ~= "scale" then
			dxDrawRectangle(menu2dX - 8 + 40, menu2dY - 8, 16, 16, tocolor(61, 122, 188))
		else
			dxDrawRectangle(menu2dX - 8 + 40, menu2dY - 8, 16, 16, tocolor(215, 89, 89))
		end

		dxDrawImage(menu2dX - 8 + 40, menu2dY - 8, 16, 16, "files/images/scale.png", 0, 0, 0, tocolor(0, 0, 0))

		-- Alapállapot
		dxDrawRectangle(menu2dX - 8 + 60, menu2dY - 8, 16, 16, tocolor(61, 122, 188))
		dxDrawImage(menu2dX - 8 + 60, menu2dY - 8, 16, 16, "files/images/reset.png", 0, 0, 0, tocolor(0, 0, 0))

		-- Mentés
		dxDrawRectangle(menu2dX - 8 + 80, menu2dY - 8, 16, 16, tocolor(61, 122, 188))
		dxDrawImage(menu2dX - 8 + 80, menu2dY - 8, 16, 16, "files/images/save.png", 0, 0, 0, tocolor(0, 0, 0))

		-- Mentések
		dxDrawRectangle(menu2dX - 8 + 100, menu2dY - 8, 16, 16, tocolor(61, 122, 188))
		dxDrawImage(menu2dX - 8 + 100, menu2dY - 8, 16, 16, "files/images/folder.png", 0, 0, 0, tocolor(0, 0, 0))

		-- ** Tooltip
		local tooltipText = false
		local absX, absY = -1, -1

		if cursorX and cursorY then
			absX = cursorX * screenX
			absY = cursorY * screenY
		end

		if presetsPanel then
			local x = menu2dX - 8 + 100
			local y = menu2dY + 8 + 4

			local sx = respc(200)
			local sy = respc(150)

			-- ** Keret
			--dxDrawRectangle(x - 2, y, 2, sy, tocolor(0, 0, 0, 255)) -- bal
			--dxDrawRectangle(x + sx, y, 2, sy, tocolor(0, 0, 0, 255)) -- jobb
			--dxDrawRectangle(x - 2, y - 2, sx + 4, 2, tocolor(0, 0, 0, 255)) -- felső
			--dxDrawRectangle(x - 2, y + sy, sx + 4, 2, tocolor(0, 0, 0, 255)) -- alsó

			-- ** Háttér
			dxDrawRectangle(x, y, sx, sy, tocolor(25, 25, 25))

			-- ** Cím
			dxDrawRectangle(x, y, sx, respc(22), tocolor(0, 0, 0, 200))
			dxDrawText("Mentett elrendezések", x, y, x + sx, y + respc(22), tocolor(200, 200, 200, 200), 1, editorFont, "center", "center")

			y = y + respc(22)
			
			-- ** Content
			local oneSize = (sy - respc(22)) / 7

			for i = 1, 7 do
				local y2 = y + oneSize * (i - 1)
				local hover = false
				local color = tocolor(200, 200, 200, 200)

				if absX >= x and absX <= x + sx and absY >= y2 and absY <= y2 + oneSize then
					hover = true
					color = tocolor(61, 122, 188)
				end

				if hover then
					dxDrawRectangle(x, y2, sx, oneSize, tocolor(0, 0, 0, 200))
				elseif i % 2 == 0 then
					dxDrawRectangle(x, y2, sx, oneSize, tocolor(0, 0, 0, 175))
				else
					dxDrawRectangle(x, y2, sx, oneSize, tocolor(0, 0, 0, 125))
				end

				if i == 1 then
					dxDrawText("Mentett elrendezés", x + respc(5), y2, x + sx, y2 + oneSize, color, 1, editorFont, "left", "center", true)
					dxDrawImage(x + sx - oneSize, y2 + respc(2), oneSize - respc(4), oneSize - respc(4), "files/images/folder.png", 0, 0, 0, color)

					if hover then
						tooltipText = "Mentés betöltése"
						activeButton = "preset:loadTheDef"
					end
				elseif i == 2 then
					dxDrawText("Előző elrendezés", x + respc(5), y2, x + sx, y2 + oneSize, color, 1, editorFont, "left", "center", true)
					dxDrawImage(x + sx - oneSize, y2 + respc(2), oneSize - respc(4), oneSize - respc(4), "files/images/folder.png", 0, 0, 0, color)

					if hover then
						tooltipText = "Mentés betöltése"
						activeButton = "preset:loadTheLast"
					end
				elseif i > 2 then
					local id = i - 2
					local presets = myPresets[editorType]

					if presets and presets[id] then
						if activeFakeInput == "preset:" .. id then
							if cursorState then
								dxDrawText(fakeInputText .. "|", x + respc(5), y2, x + sx, y2 + oneSize, color, 1, editorFont, "left", "center", true)
							else
								dxDrawText(fakeInputText, x + respc(5), y2, x + sx, y2 + oneSize, color, 1, editorFont, "left", "center", true)
							end

							if getTickCount() - cursorStateChange >= 500 then
								cursorStateChange = getTickCount()
								cursorState = not cursorState
							end

							dxDrawImage(x + sx - oneSize, y2 + respc(2), oneSize - respc(4), oneSize - respc(4), "files/images/save.png", 0, 0, 0, color)

							if hover then
								tooltipText = "Átnevezés mentése"
								activeButton = "preset:rename:" .. id
							end
						else
							dxDrawText(presets[id][11] or "Elrendezés #" .. id, x + respc(5), y2, x + sx, y2 + oneSize, color, 1, editorFont, "left", "center", true)

							local removecolor = color
							local renamecolor = color

							if hover then
								tooltipText = "Mentés betöltése"
								activeButton = "preset:load:" .. id

								if absX >= x + sx - oneSize * 2 and absX <= x + sx - oneSize and absY >= y2 and absY <= y2 + oneSize then
									removecolor = tocolor(215, 89, 89)
									tooltipText = "Mentés törlése"
									activeButton = "preset:del:" .. id
								elseif absX >= x + sx - oneSize * 3 and absX <= x + sx - oneSize * 2 and absY >= y2 and absY <= y2 + oneSize then
									renamecolor = tocolor(50, 179, 239)
									tooltipText = "Átnevezés"
									activeButton = "preset:rename:" .. id
								end
							end

							dxDrawImage(x + sx - oneSize, y2 + respc(2), oneSize - respc(4), oneSize - respc(4), "files/images/folder.png", 0, 0, 0, color)
							dxDrawImage(x + sx - oneSize * 2, y2 + respc(2), oneSize - respc(4), oneSize - respc(4), "files/images/reset.png", 0, 0, 0, removecolor)
							dxDrawImage(x + sx - oneSize * 3, y2 + respc(2), oneSize - respc(4), oneSize - respc(4), "files/images/rename.png", 0, 0, 0, renamecolor)
						end
					else
						local lastid = 1

						if presets then
							lastid = #presets + 1
						end

						if id == lastid then
							dxDrawText("Új...", x + respc(5), y2, x + sx, y2 + oneSize, color, 1, editorFont, "left", "center", true)

							if hover then
								activeButton = "preset:new"
							end
						end
					end
				end
			end
		end

		if absX >= menu2dX - 8 and absX <= menu2dX + 8 and absY >= menu2dY - 8 and absY <= menu2dY + 8 then
			tooltipText = "Mozgatás mód"
			activeButton = "moveObject:move"
		elseif absX >= menu2dX - 8 + 20 and absX <= menu2dX + 8 + 20 and absY >= menu2dY - 8 and absY <= menu2dY + 8 then
			tooltipText = "Forgatás mód"
			activeButton = "moveObject:rotate"
		elseif absX >= menu2dX - 8 + 40 and absX <= menu2dX + 8 + 40 and absY >= menu2dY - 8 and absY <= menu2dY + 8 then
			tooltipText = "Méretezés mód"
			activeButton = "moveObject:scale"
		elseif absX >= menu2dX - 8 + 60 and absX <= menu2dX + 8 + 60 and absY >= menu2dY - 8 and absY <= menu2dY + 8 then
			tooltipText = "Alapállapot visszaállítása"
			activeButton = "moveObject:reset"
		elseif absX >= menu2dX - 8 + 80 and absX <= menu2dX + 8 + 80 and absY >= menu2dY - 8 and absY <= menu2dY + 8 then
			tooltipText = "Elmentés"
			activeButton = "moveObject:save"
		elseif absX >= menu2dX - 8 + 100 and absX <= menu2dX + 8 + 100 and absY >= menu2dY - 8 and absY <= menu2dY + 8 then
			tooltipText = "Mentett elrendezések"
			activeButton = "moveObject:presets"
		end

		if tooltipText then
			local textWidth = dxGetTextWidth(tooltipText, 1, editorFont) + respc(10)
			local textHeight = dxGetFontHeight(1, editorFont) + respc(5)

			dxDrawRectangle(absX + 5, absY, textWidth, textHeight, tocolor(0, 0, 0, 200))
			dxDrawText(tooltipText, absX + 5, absY, absX + 5 + textWidth, absY + textHeight, tocolor(200, 200, 200, 200), 0.95, editorFont, "center", "center")
		end
	end

	-- ** Tengelyek
	-- X tengely
	if activeAxis == "x" and cursorX and cursorY then
		local offset = 0

		if activeMode == "rotate" then
			offset = (0.5 - cursorX) * 25
		else
			local camX, camY, camZ, lookX, lookY, lookZ = getCameraMatrix()
			local angle = math.atan2(lookX - camX, lookY - camY) + math.rad(playerRotZ)

			offset = (0.5 - cursorY) * math.sin(angle) + (0.5 - cursorX) * -math.cos(angle)
		end

		setCursorPosition(screenX / 2, screenY / 2)
		moveOffset = moveOffset + offset

		if activeMode == "move" then
			exports.sm_boneattach:setElementBonePositionOffset(editorMainObject, attachmentDetails[1] + moveOffset, attachmentDetails[2], attachmentDetails[3])
		elseif activeMode == "rotate" then
			if attachmentDetails[1] + moveOffset > 360 then
				moveOffset = 0
			end

			exports.sm_boneattach:setElementBoneRotationOffset(editorMainObject, attachmentDetails[1] + moveOffset, attachmentDetails[2], attachmentDetails[3])
		elseif activeMode == "scale" then
			if editorScaleY + moveOffset > 2 then
				moveOffset = 0
				editorScaleY = 2
			elseif editorScaleY + moveOffset < 0.5 then
				moveOffset = 0
				editorScaleY = 0.5
			end

			setObjectScale(editorMainObject, editorScaleX, editorScaleY + moveOffset, editorScaleZ)
		end
	end

	if obj2dX and obj2dY then
		local axis2dX, axis2dY = getScreenFromWorldPosition(elementOffset(objectMatrix, 0.25, 0, 0))

		if axis2dX and axis2dY then
			if activeMode then
				if activeAxis == "x" then
					if not getKeyState("mouse1") then
						activeAxis = false

						setCursorPosition(axis2dX, axis2dY)
						setCursorAlpha(255)

						if activeMode == "scale" then
							editorScaleX, editorScaleY, editorScaleZ = editorScaleX, editorScaleY + moveOffset, editorScaleZ
						end

						return
					end
				end
			end

			if not activeAxis then
				if getKeyState("mouse1") then
					if cursorX and cursorY then
						local absX = cursorX * screenX
						local absY = cursorY * screenY

						if absX >= axis2dX - 8 and absY >= axis2dY - 8 and absX <= axis2dX + 8 and absY <= axis2dY + 8 then
							local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)

							activeAxis = "x"

							if activeMode == "move" then
								attachmentDetails = {x, y, z}
							elseif activeMode == "rotate" then
								attachmentDetails = {rx, ry, rz}
							elseif activeMode == "scale" then
								attachmentDetails = {}
							end

							moveOffset = 0

							setCursorPosition(screenX / 2, screenY / 2)
							setCursorAlpha(0)
						end
					end
				end
			end

			dxDrawLine(obj2dX, obj2dY, axis2dX, axis2dY, tocolor(215, 89, 89))
			dxDrawRectangle(math.floor(axis2dX - 8), math.floor(axis2dY - 8), 16, 16, tocolor(215, 89, 89))
			dxDrawImage(math.floor(axis2dX - 8), math.floor(axis2dY - 8), 16, 16, "files/images/" .. activeMode .. ".png", 0, 0, 0, tocolor(0, 0, 0))
		end
	end

	-- Y tengely
	if activeAxis == "y" and cursorX and cursorY then
		local offset = 0

		if activeMode == "rotate" then
			offset = (0.5 - cursorX) * 25
		else
			local camX, camY, camZ, lookX, lookY, lookZ = getCameraMatrix()
			local angle = math.atan2(lookX - camX, lookY - camY) + math.rad(playerRotZ)

			offset = (0.5 - cursorX) * math.sin(angle) + (0.5 - cursorY) * math.cos(angle)
		end

		setCursorPosition(screenX / 2, screenY / 2)
		moveOffset = moveOffset + offset

		if activeMode == "move" then
			exports.sm_boneattach:setElementBonePositionOffset(editorMainObject, attachmentDetails[1], attachmentDetails[2] + moveOffset, attachmentDetails[3])
		elseif activeMode == "rotate" then
			if attachmentDetails[1] + moveOffset > 360 then
				moveOffset = 0
			end

			exports.sm_boneattach:setElementBoneRotationOffset(editorMainObject, attachmentDetails[1], attachmentDetails[2] + moveOffset, attachmentDetails[3])
		elseif activeMode == "scale" then
			if editorScaleX + moveOffset > 2 then
				moveOffset = 0
				editorScaleX = 2
			elseif editorScaleX + moveOffset < 0.5 then
				moveOffset = 0
				editorScaleX = 0.5
			end

			setObjectScale(editorMainObject, editorScaleX + moveOffset, editorScaleY, editorScaleZ)
		end
	end

	if obj2dX and obj2dY then
		local axis2dX, axis2dY = getScreenFromWorldPosition(elementOffset(objectMatrix, 0, 0.25, 0))

		if axis2dX and axis2dY then
			if activeMode then
				if activeAxis == "y" then
					if not getKeyState("mouse1") then
						activeAxis = false

						setCursorPosition(axis2dX, axis2dY)
						setCursorAlpha(255)

						if activeMode == "scale" then
							editorScaleX, editorScaleY, editorScaleZ = editorScaleX + moveOffset, editorScaleY, editorScaleZ
						end

						return
					end
				end
			end

			if not activeAxis then
				if getKeyState("mouse1") then
					if cursorX and cursorY then
						local absX = cursorX * screenX
						local absY = cursorY * screenY

						if absX >= axis2dX - 8 and absY >= axis2dY - 8 and absX <= axis2dX + 8 and absY <= axis2dY + 8 then
							local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)

							activeAxis = "y"

							if activeMode == "move" then
								attachmentDetails = {x, y, z}
							elseif activeMode == "rotate" then
								attachmentDetails = {rx, ry, rz}
							elseif activeMode == "scale" then
								attachmentDetails = {}
							end

							moveOffset = 0

							setCursorPosition(screenX / 2, screenY / 2)
							setCursorAlpha(0)
						end
					end
				end
			end

			dxDrawLine(obj2dX, obj2dY, axis2dX, axis2dY, tocolor(61, 122, 188))
			dxDrawRectangle(math.floor(axis2dX - 8), math.floor(axis2dY - 8), 16, 16, tocolor(61, 122, 188))
			dxDrawImage(math.floor(axis2dX - 8), math.floor(axis2dY - 8), 16, 16, "files/images/" .. activeMode .. ".png", 0, 0, 0, tocolor(0, 0, 0))
		end
	end

	-- Z tengely
	if activeAxis == "z" and cursorX and cursorY then
		local offset = 0

		if activeMode == "move" then
			offset = 0.5 - cursorY
		elseif activeMode == "rotate" then
			offset = (0.5 - cursorX) * 25
		elseif activeMode == "scale" then
			offset = (0.5 - cursorY) * 15
		end

		setCursorPosition(screenX / 2, screenY / 2)
		moveOffset = moveOffset + offset

		if activeMode == "move" then
			exports.sm_boneattach:setElementBonePositionOffset(editorMainObject, attachmentDetails[1], attachmentDetails[2], attachmentDetails[3] + moveOffset)
		elseif activeMode == "rotate" then
			if attachmentDetails[1] + moveOffset > 360 then
				moveOffset = 0
			end

			exports.sm_boneattach:setElementBoneRotationOffset(editorMainObject, attachmentDetails[1], attachmentDetails[2], attachmentDetails[3] + moveOffset)
		elseif activeMode == "scale" then
			if editorScaleZ + moveOffset > 2 then
				moveOffset = 0
				editorScaleZ = 2
			elseif editorScaleZ + moveOffset < 0.5 then
				moveOffset = 0
				editorScaleZ = 0.5
			end

			setObjectScale(editorMainObject, editorScaleX, editorScaleY, editorScaleZ + moveOffset)
		end
	end

	if obj2dX and obj2dY then
		local axis2dX, axis2dY = getScreenFromWorldPosition(elementOffset(objectMatrix, 0, 0, 0.25))

		if axis2dX and axis2dY then
			if activeMode then
				if activeAxis == "z" then
					if not getKeyState("mouse1") then
						activeAxis = false

						setCursorPosition(axis2dX, axis2dY)
						setCursorAlpha(255)

						if activeMode == "scale" then
							editorScaleX, editorScaleY, editorScaleZ = editorScaleX, editorScaleY, editorScaleZ + moveOffset
						end

						return
					end
				end
			end

			if not activeAxis then
				if getKeyState("mouse1") then
					if cursorX and cursorY then
						local absX = cursorX * screenX
						local absY = cursorY * screenY

						if absX >= axis2dX - 8 and absY >= axis2dY - 8 and absX <= axis2dX + 8 and absY <= axis2dY + 8 then
							local ped, bone, x, y, z, rx, ry, rz = exports.sm_boneattach:getElementBoneAttachmentDetails(editorMainObject)

							activeAxis = "z"

							if activeMode == "move" then
								attachmentDetails = {x, y, z}
							elseif activeMode == "rotate" then
								attachmentDetails = {rx, ry, rz}
							elseif activeMode == "scale" then
								attachmentDetails = {}
							end

							moveOffset = 0

							setCursorPosition(screenX / 2, screenY / 2)
							setCursorAlpha(0)
						end
					end
				end
			end

			dxDrawLine(obj2dX, obj2dY, axis2dX, axis2dY, tocolor(89, 142, 215))
			dxDrawRectangle(math.floor(axis2dX - 8), math.floor(axis2dY - 8), 16, 16, tocolor(89, 142, 215))
			dxDrawImage(math.floor(axis2dX - 8), math.floor(axis2dY - 8), 16, 16, "files/images/" .. activeMode .. ".png", 0, 0, 0, tocolor(0, 0, 0))
		end
	end
end
