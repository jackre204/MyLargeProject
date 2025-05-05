local resources = {
	"sm_database",
	"sm_logs",
	"sm_anticheat",
	"sm_core",
	"sm_remove",
	"sm_object",
	"sm_water",
	-- "sm_maps",
	"sm_accounts",
	"sm_binco",
	"sm_controls",
	"sm_boneattach",
	"sm_administration",
	"sm_newdebug",
	"sm_workaround",
	"sm_hud",
	-- "sm_dynamicsky",
	"sm_weather",
	"sm_vehiclenames",
	"sm_drm",
	-- "sm_mods_veh",
	-- "sm_mods_skin",
	"sm_names",
	"sm_chat",
	"sm_items",
	"sm_jobhandler",
	"sm_jobvehicle",
	"sm_groups",
	"sm_weapontuning",
	-- "sm_weaponmods",
	-- "sm_weaponsounds",
	"sm_weaponnew",
	"sm_glue",
	"sm_interiors",
	"sm_interioredit",
	"sm_regoffice",
	"sm_vehiclepanel",
	"sm_vehicles",
	"sm_fuel",
	"sm_minigames",
	"sm_damage",
	"sm_death",
	"sm_mods_obj",
	"sm_tempomat",
	"sm_killmsg",
	"sm_notifications",
	"sm_radio",
	"sm_3dtext",
	"sm_shader",
	"sm_dashboard",
	"sm_autobroadcast",
	"sm_premiumshop",
	"sm_carshop",
	"sm_boatshop",
	"sm_animals",
	"sm_borders",
	"sm_jail",
	"sm_burnout",
	-- "sm_windmill",
	"sm_job_factory",
	"sm_job_truck",
	"sm_job_post",
	"sm_job_pizza",
	"sm_job_bus",
	"sm_license",
	"sm_speedbump",
	-- "sm_kresztablak",
	"sm_textures",
	"sm_impound",
	"sm_peds",
	"sm_tuning",
	-- "sm_tuningcomp",
	"sm_spinner",
	"sm_paintjob",
	"sm_headlight",
	"sm_wheels",
	"sm_wheeltexture",
	"sm_customhorn",
	"sm_mdc",
	"sm_groupscripting",
	"sm_groupradio",
	"sm_sound",
	"sm_billiard",
	"sm_casino",
	"sm_roulette",
	"sm_fortunewheel",
	"sm_blackjack",
	"sm_poker",
	"sm_lottery",
	"sm_cveh",
	"sm_shootingrange",
	"sm_weaponskill",
	"sm_clothesshop",
	"sm_animations",
	"sm_bank",
	"sm_mechanic",
	"sm_gates",
	"sm_shark",
	"sm_crosshair",
	"sm_ad",
	"sm_drag",
	"sm_fishing"
}

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		local connection = false
		local started = 0

		outputDebugString("[StrongMTA]: Starting resources...")

		for k, v in ipairs(resources) do
			local resname = getResourceFromName(v)
			local state = startResource(resname)

			--if string.find(v, "database") and state then
				connection = exports.sm_database:getConnection()
			--end

			if not connection then
				break
			end

			if state then
				started = started + 1
			end
		end

		if not connection then
			outputDebugString("[StrongMTA]: Unable to connect to the database, operation canceled!")
			cancelEvent(true, "Unable to connect to the database")
		else
			outputDebugString("[StrongMTA]: " .. started .. " resource(s) started.")
		end
	end
)

function getResourceList()
	return resources
end
