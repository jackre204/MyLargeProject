function loadSkinMod(path, model)
	if fileExists(path .. "/" .. model .. ".txd") then
		local txd = engineLoadTXD(path .. "/" .. model .. ".txd")

		if txd then
			engineImportTXD(txd, model)
		end
	end

	if fileExists(path .. "/" .. model .. ".dff") then
		local dff = engineLoadDFF(path .. "/" .. model .. ".dff")

		if fileExists(path .. "/" .. model .. ".dff") then
			engineReplaceModel(dff, model)
		end
	end
end

loadSkinMod("dogs", 256)
loadSkinMod("dogs", 257)
loadSkinMod("dogs", 296)
loadSkinMod("dogs", 297)
loadSkinMod("dogs", 298)
loadSkinMod("dogs", 9)