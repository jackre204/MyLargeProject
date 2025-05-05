worldX, worldY = -25.6328125, -364.9140625 -- # DO NOT TOUCH IT!
farmInteriorPosition = {-23.140625, -367.431640625, 5.4296875} -- # DO NOT TOUCH IT!

-- NOTE: zCorrection: sets the start position of the plant on the Z-Axis
-- NOTE: growZ: sets the growing position on the Z-Axis
-- NOTE: If growZ is not set, the plant only grows by scale
seedTable = {
	{name = "Kender", modelID = 859, seedImage = "seed", seedID = 11, itemID = 14, zCorrection = 0},
	{name = "Sárgarépa", modelID = 16192, seedImage = "seed", seedID = 399, itemID = 10, zCorrection = 0},
	{name = "Retek", modelID = 16193, seedImage = "seed", seedID = 398, itemID = 383, zCorrection = 0},
	{name = "Petrezselyem", modelID = 16675, seedImage = "seed", seedID = 397, itemID = 385, zCorrection = 0.1},
	{name = "Saláta", modelID = 16676, seedImage = "seed", seedID = 398, itemID = 383, zCorrection = 0},
	{name = "Vöröshagyma", modelID = 16134, seedImage = "seed", seedID = 392, itemID = 11, zCorrection = 0, growZ = 0.26},
}

-- NOTE: Seed index corresponds to the index of the plant in the seedTable
seedSellTable = {
	{
		skinID = 73,
		position = {823.912109375, -1841.6513671875, 12.634986877441, 270},
		seedIndex = 2,
	},
	{
		skinID = 15,
		position = {823.912109375, -1845.6513671875, 12.634986877441, 270},
		seedIndex = 3,
	},
	{
		skinID = 31,
		position = {823.912109375, -1849.6513671875, 12.634986877441, 270},
		seedIndex = 4,
	},
	{
		skinID = 161,
		position = {823.912109375, -1853.6513671875, 12.634986877441, 270},
		seedIndex = 5,
	},
	{
		skinID = 162,
		position = {823.912109375, -1857.6513671875, 12.634986877441, 270},
		seedIndex = 6,
	},
}

permissionMenu = {"Cultivate", "Digging", "Watering", "Plant seeds", "Harvest plants", "Farm nyitás/zárás"}

-- # Marker Colors RGBA
farmMarkerColor = {197, 172, 119, 100}
farmRentMarkerColor = {124, 197, 118, 100}

-- # Tools
numberOfSpadesAllowedInFarm = 2 -- # Sets how many spades can be taken in the farm
numberOfHoesAllowedInFarm = 2 -- # Sets how many hoes can be taken in the farm

-- # Element Datas
characterIDElementData = "char.ID"
moneyElementData = "char.Money"
premiumElementData = "acc.premiumPoints"
playerNameElementData = "char.Name"

-- # Renting
rentPrice = 5000
rentPricePremium = 2000
defaultRentTime = 60000*60*24*7 -- # The renting time / in milliseconds /

-- # Times
healthTime = 1000*60*60 -- # The time until the plant's health goes to 0 / in milliseconds /
growingTime = 1000*60*35 -- # The time until the plant is growing / in milliseconds /
waterLosingTime = 1000*60*60 -- # The time until the water level goes back to 0 / in milliseconds /
cultivateTime = 1000 -- # The time of the cultivating animation  / in milliseconds /
diggingTime = 4500 -- # The time of the digging animation  / in milliseconds /
plantingTime = 3000 -- # The time of the planting animation  / in milliseconds /
harvestTime = 10000 -- # The time of the harvesting animation  / in milliseconds /
wateringTime = 10000 -- # The time of the watering animation  / in milliseconds /


-- # Languages
selectedLanguage = "hu" -- NOTE: available languades: en - english; de - german; hu - hungarian
farmPrefix = "#d9534f[StrongMTA - Farm]: #ffffff"


translationTable = {
	["en"] = {
		["harvest_button"] = "Harvest plant",
		["wateringLevel"] = "Moisture",
		["changeFarmName_button"] = "Change",
		["editFarmName_button"] = "Edit",
		["farmManagementTitle"] = "Farm Management",
		["permission_button"] = "Permissions",
		["permission_addNewMember"] = "Add new member",
		["permission_save"] = "Save",
		["permission_add"] = "Add",
		["permission_noPlayerFound"] = "Player not found.",
		["permission_morePlayerFound"] = " such player found",
		["permission_selfAdding"] = "You can not add yourself.",
		["tools_hoe"] = "Hoe",
		["tools_shovel"] = "Shovel",
		["tools_wateringCan"] = "Water can",
		["ground_wateringLevel"] = "Moisture:",
		["ground_state"] = "State:",
		["ground_uncultivated"] = "Uncultivated",
		["ground_cultivating"] = "Cultivating",
		["ground_cultivated"] = "Cultivated",
		["ground_planting"] = "Planting",
		["ground_digging"] = "Digging",
		["ground_readyForPlanting"] = "Ready for planting",
		["ground_growing"] = "Growth:",
		["ground_fillTheHole"] = "Fill the hole",
		["ground_plantTheSeed"] = "Plant seed",
		["ground_seedMenu"] = "Seeds",
		["chatbox_hoeDown"] = "First you have to put down the hoe!",
		["chatbox_shovelDown"] = "First you have to put down the shovel!",
		["chatbox_toolDown"] = "First you have to put down the tool that you are carrying!",
		["chatbox_tryHarvest"] = "You can not harvest this plant yet.",
		["chatbox_alreadyCultivated"] = "This block is already cultivated.",
		["chatbox_canNotCultivate"] = "You can not cultivate this block while the plant is growing.",
		["chatbox_notEnoughCultivation"] = "This block is not cultivated enough",
		["chatbox_rentFarmCommand1"] = "Use the command #7cc576/rentfarm #ffffff or #6699ff/rentfarm pp #ffffffto rent this farm.",
		["chatbox_rentFarmCommand2"] = "Price for a week: #7cc576$"..rentPrice.." #ffffffor #6699ff"..rentPricePremium.." Premium Point",
		["chatbox_farmLocked"] = "This farm is locked.",
		["chatbox_openFarmDoor"] = "You opened the farm's door.",
		["chatbox_closeFarmDoor"] = "You closed the farm's door.",
		["chatbox_notEnoughPP"] = "You do not have enough Premium Point.",
		["chatbox_notEnoughMoney"] = "You do not have enough money.",
		["chatbox_alreadyOwned"] = "This farm is already rented by someone else.",
		["chatbox_rentSuccess"] = "You successfully rented this farm.",
		["chatbox_canNotReach"] = "You can not reach this block.",
		["chatbox_noSeed"] = "You don't have that many pieces of this plant.",
		["chatbox_plantSold"] = "You have successfully sold the selected plant.",
		["chatbox_minigame_amount"] = "Amount:",
		["chatbox_minigame_price"] = "Price:",
		["chatbox_minigame_total"] = "Total:",
		["chatbox_minigame_description"] = "Hold ‘#99cc99Space#ffffff’ until the arrow reaches \nthe green section.",
		["minigameTitle"] = "Farm - Sell",
		["board_forRentText"] = "FOR RENT!",
		["board_enterInterior"] = "Press 'E' to enter the farm",
		["piecesShortly"] = "pcs",
	},
	["de"] = {
		["harvest_button"] = "Pflanze ernten",
		["wateringLevel"] = "Nässe",
		["changeFarmName_button"] = "Ändern",
		["editFarmName_button"] = "Bearbeiten",
		["farmManagementTitle"] = "Farm Management",
		["permission_button"] = "Rechte",
		["permission_addNewMember"] = "Neuer Spieler",
		["permission_save"] = "Speichern",
		["permission_add"] = "Hinfügen",
		["permission_noPlayerFound"] = "Spieler wurde nicht gefunden.",
		["permission_morePlayerFound"] = " Mehr Spieler wurden gefunden.",
		["permission_selfAdding"] = "Du kannst dich selbst nicht hinzufügen.",
		["tools_hoe"] = "Hacke",
		["tools_shovel"] = "Schaufel",
		["tools_wateringCan"] = "Wasserkanister",
		["ground_wateringLevel"] = "Nässe:",
		["ground_state"] = "Zustand:",
		["ground_uncultivated"] = "Unkultiviert",
		["ground_cultivating"] = "Wird kultiviert",
		["ground_cultivated"] = "Kultiviert",
		["ground_planting"] = "Wird gepflanzt",
		["ground_digging"] = "Wird gegraben",
		["ground_readyForPlanting"] = "Bereit für Pflanzen",
		["ground_growing"] = "Wachstum:",
		["ground_fillTheHole"] = "Das Loch füllen",
		["ground_plantTheSeed"] = "Pflanzen",
		["ground_seedMenu"] = "Saaten",
		["chatbox_hoeDown"] = "Du musst zuerst die Hacke ablegen!",
		["chatbox_shovelDown"] = "Du musst zuerst die Schaufel ablegen!",
		["chatbox_toolDown"] = "Du musst zuerst das andere Werkzeug ablegen.",
		["chatbox_tryHarvest"] = "Du kannst diese Pflanze noch nicht ernten.",
		["chatbox_alreadyCultivated"] = "Dieser Block ist schon kultiviert.",
		["chatbox_canNotCultivate"] = "Du kannst diesen Block nicht kultivieren.",
		["chatbox_notEnoughCultivation"] = "Dieser Block ist noch nicht genug kultiviert",
		["chatbox_rentFarmCommand1"] = "Nutze #7cc576/rentfarm #ffffff oder #6699ff/rentfarm pp #ffffffum die Farm zu mieten.",
		["chatbox_rentFarmCommand2"] = "Preis für eine Woche: #7cc576$"..rentPrice.." #ffffffoder #6699ff"..rentPricePremium.." Premium Point",
		["chatbox_farmLocked"] = "Diese Farm ist geschlossen.",
		["chatbox_openFarmDoor"] = "Du hast die Tür der Farm geöffnet.",
		["chatbox_closeFarmDoor"] = "Du hast die Tür der Farm geschlossen.",
		["chatbox_notEnoughPP"] = "Du hast nicht genug Premium Point.",
		["chatbox_notEnoughMoney"] = "Du hast nicht genug Geld.",
		["chatbox_alreadyOwned"] = "Diese Farm ist schon gemietet.",
		["chatbox_rentSuccess"] = "Du hast diese Farm erfolgreich gemietet.",
		["chatbox_canNotReach"] = "Du kannst diesen Block nicht erreichen.",
		["chatbox_noSeed"] = "Du hast nicht so viele Stücke von dieser Pflanze.",
		["chatbox_plantSold"] = "Die ausgewählte Pflanze wurde erfolgreich verkauft.",
		["chatbox_minigame_amount"] = "Anzahl:",
		["chatbox_minigame_price"] = "Preis:",
		["chatbox_minigame_total"] = "Insgesamt:",
		["chatbox_minigame_description"] = "Hält ‘#99cc99Space#ffffff’ bis der Pfeil \nden grünen Bereich erreicht.",
		["minigameTitle"] = "Farm - Verkauf",
		["board_forRentText"] = "ZU VERMIETEN!",
		["board_enterInterior"] = "Drück 'E' um die Farm beizutreten",
		["piecesShortly"] = "Stück",
	},
	["hu"] = {
		["harvest_button"] = "Növény aratása",
		["wateringLevel"] = "Nedvesség",
		["changeFarmName_button"] = "Módosítás",
		["editFarmName_button"] = "Szerkesztés",
		["farmManagementTitle"] = "Farm tábla:",
		["permission_button"] = "Jogosultságok",
		["permission_addNewMember"] = "Új tag hozzáadása",
		["permission_save"] = "Mentés",
		["permission_add"] = "Hozzáad",
		["permission_noPlayerFound"] = "Játékos nem található",
		["permission_morePlayerFound"] = " ilyen nevű játékos találva.",
		["permission_selfAdding"] = " Magadat nem tudod hozzáadni.",
		["tools_hoe"] = "Kapa",
		["tools_shovel"] = "Ásó",
		["tools_wateringCan"] = "Kanna",
		["ground_wateringLevel"] = "Nedvesség:",
		["ground_state"] = "Állapot:",
		["ground_uncultivated"] = "Műveletlen",
		["ground_cultivating"] = "művelés alatt",
		["ground_cultivated"] = "Megkapálva",
		["ground_planting"] = "művelés alatt",
		["ground_digging"] = "művelés alatt",
		["ground_readyForPlanting"] = "Ültetésre kész",
		["ground_growing"] = "Növekedés:",
		["ground_fillTheHole"] = "Lyuk betömése",
		["ground_plantTheSeed"] = "Növény ültetése",
		["ground_seedMenu"] = "Vetőmagok",
		["chatbox_hoeDown"] = "Előbb tedd le a kapát!",
		["chatbox_shovelDown"] = "Előbb tedd le az ásót!",
		["chatbox_toolDown"] = "Előbb tedd le az eszközt, ami a kezedben van!",
		["chatbox_tryHarvest"] = "Még nem fejlődött ki eléggé a növény.",
		["chatbox_alreadyCultivated"] = "Már teljesen meg van kapálva.",
		["chatbox_canNotCultivate"] = "Ameddig be van ültetve a föld, addig nem kapálhatod.",
		["chatbox_notEnoughCultivation"] = "Nincs eléggé megkapálva a föld.",
		["chatbox_rentFarmCommand1"] = "Use the command #7cc576/rentfarm #ffffff or #6699ff/rentfarm pp #ffffffto rent this farm.",
		["chatbox_rentFarmCommand2"] = "Price for a week: #7cc576$"..rentPrice.." #ffffffor #6699ff"..rentPricePremium.." Premium Point",
		["chatbox_farmLocked"] = "Ez a farm zárva van",
		["chatbox_openFarmDoor"] = "Kinyitottad a farm ajtaját.",
		["chatbox_closeFarmDoor"] = "Bezártad a farm ajtaját.",
		["chatbox_notEnoughPP"] = "Nincs elég Prémium Pontod.",
		["chatbox_notEnoughMoney"] = "Nincs elég pénzed.",
		["chatbox_alreadyOwned"] = "Ezt a farmot már valaki bérli.",
		["chatbox_rentSuccess"] = "Sikeresen kibérelted a farmot.",
		["chatbox_canNotReach"] = "Nem éred el ezt a blokkot.",
		["chatbox_noSeed"] = "Nincs nálad ilyen vetőmag.",
		["chatbox_plantSold"] = "Sikeresen eladtad a kiválasztott növényt.",
		["chatbox_minigame_amount"] = "Mennyiség:",
		["chatbox_minigame_price"] = "Darabár:",
		["chatbox_minigame_total"] = "Összesen:",
		["chatbox_minigame_description"] = "Tartsd lenyomva a ‘#99cc99Space#ffffff’ billentyűt, \nameddig a nyíl el nem éri a zöld mezőt.",
		["minigameTitle"] = "Eladás - ",
		["board_forRentText"] = "KIADÓ!",
		["board_enterInterior"] = "Nyomj 'E' billentyűt a belépéshez.",
		["piecesShortly"] = "db",
	},
}


function getTranslatedText(index)
	if translationTable[selectedLanguage] then
		if translationTable[selectedLanguage][index] then
			return translationTable[selectedLanguage][index]
		else
			return "No matching text"
		end
	else
		return "This language is not supported."
	end
end

-- # Item functions

function hasPlayerItem(itemID)
	if exports.saw_item:hasItem(itemID) then
		return true
	else
		return false
	end
end

function getItemCount(itemID)
	local hasItem, _, _, _, _, _,itemCount = exports.saw_item:hasItem(itemID)
	if not hasItem then
		return 0
	else
		return itemCount
	end
end

function takeSeedFromPlayer(itemID)
	exports.saw_item:takeItemMinusCount(itemID)
end

function takePlantFromPlayer(itemID)
	exports.saw_item:takeItem(itemID)
end

function givePlayerHarvestedPlant(itemID, health)
	if health > 10 then
		exports.saw_item:giveItem(itemID, 1, 1, 0)
	end
end
