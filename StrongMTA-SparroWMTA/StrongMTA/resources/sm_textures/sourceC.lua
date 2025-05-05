local texturesTable = {
	bloodpool_64 = dxCreateTexture("files/bloodpool_64.png", "dxt3"),
	BLUE_FABRIC = dxCreateTexture("files/BLUE_FABRIC.png", "dxt3"),
	bubbles = dxCreateTexture("files/bubbles.png", "dxt3"),
	cj_sheetmetal2 = dxCreateTexture("files/cj_sheetmetal2.png", "dxt3"),
	collisionsmoke = dxCreateTexture("files/collisionsmoke.png", "dxt3"),
	conc_slabgrey_256128 = dxCreateTexture("files/conc_slabgrey_256128.png", "dxt3"),
	coronastar = dxCreateTexture("files/coronastar.png", "dxt3"),
	fireball6 = dxCreateTexture("files/fireball6.png", "dxt3"),
	headlight = dxCreateTexture("files/headlight.png", "dxt3"),
	headlight1 = dxCreateTexture("files/headlight1.png", "dxt3"),
	lamp_shad_64 = dxCreateTexture("files/lamp_shad_64.png", "dxt3"),
	mp_cop_ceilingtile = dxCreateTexture("files/mp_cop_ceilingtile.png", "dxt3"),
	mp_cop_tile = dxCreateTexture("files/mp_cop_tile.png", "dxt3"),
	mp_cop_wall = dxCreateTexture("files/mp_cop_wall.png", "dxt3"),
	mp_cop_wallpink = dxCreateTexture("files/mp_cop_wallpink.png", "dxt3"),
	particleskid = dxCreateTexture("files/particleskid.png", "dxt3"),
	siteM16 = dxCreateTexture("files/siteM16.png", "dxt3"),
	sjmlode93 = dxCreateTexture("files/sjmlode93.png", "dxt3"),
	smoke = dxCreateTexture("files/smoke.png", "dxt3"),
	smokeII_3 = dxCreateTexture("files/smokeII_3.png", "dxt3"),
	SNIPERcrosshair = dxCreateTexture("files/SNIPERcrosshair.png", "dxt3"),
	vehiclegrunge256 = dxCreateTexture("files/vehiclegrunge256.png", "dxt3"),
	vehiclelights128 = dxCreateTexture("files/vehiclelights128.png", "dxt3"),
	vehiclelightson128 = dxCreateTexture("files/vehiclelightson128.png", "dxt3"),
	vehicleshatter128 = dxCreateTexture("files/vehicleshatter128.png", "dxt3"),
	waterclear256 = dxCreateTexture("files/waterclear256.png", "dxt3"),
	roulette_surf1 = dxCreateTexture("files/roulette_surf1.png", "dxt3"),
	roulette_surf2 = dxCreateTexture("files/roulette_surf2.png", "dxt3"),
	roulette_4_256 = dxCreateTexture("files/roulette_4_256.png", "dxt3"),
	green_beize_128 = dxCreateTexture("files/green_beize_128.png", "dxt3")
}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for k, v in pairs(texturesTable) do
			local shaderElement = dxCreateShader("files/texturechanger.fx")

			if shaderElement then
				dxSetShaderValue(shaderElement, "gTexture", v)
				engineApplyShaderToWorldTexture(shaderElement, k)
			end
		end
	end
)

