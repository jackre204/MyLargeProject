
addEventHandler("onClientResourceStart",resourceRoot,
	function()
		setOcclusionsEnabled(false)


		for id,model in pairs(models) do
			if model.txd then
				local path = model.txd .. ".txd"
				if fileExists(path) then
					engineImportTXD( engineLoadTXD(path),id)
				end
			end
			if model.dff then
				local path = model.dff .. ".dff"
				if fileExists(path) then
					engineReplaceModel( engineLoadDFF(path,0),id)
					engineSetModelLODDistance(id,300)
				end
			end
			if model.col then
				local path = model.col .. ".col"
				if fileExists(path) then
					engineReplaceCOL( engineLoadCOL(path),id)
				end
			end
		end
	end
)