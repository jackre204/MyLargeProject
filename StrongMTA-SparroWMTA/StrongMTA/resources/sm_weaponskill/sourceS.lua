local connection = false

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.sm_database:getConnection()
	end
)

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end
)

addEvent("downgradeWeaponSkill", true)
addEventHandler("downgradeWeaponSkill", getRootElement(),
	function (statId)
		if isElement(source) then
			local characterId = getElementData(source, "char.ID")

			if characterId then
				local skillLevel = getPedStat(source, statId)
				local skillTable = {}

				if skillLevel - 1 > 0 then
					setPedStat(source, statId, skillLevel - 1)
				else
					setPedStat(source, statId, 0)
				end

				for i = 69, 79 do
					table.insert(skillTable, getPedStat(source, i))
				end

				skillTable = table.concat(skillTable, ",")

				if skillTable then
					dbExec(connection, "UPDATE characters SET weaponSkills = ? WHERE characterId = ?", skillTable, characterId)
				end

				exports.sm_hud:showInfobox(source, "s", "Sikeresen csökkentetted a kiválasztott fegyver skillpontját.")
			end
		end
	end
)