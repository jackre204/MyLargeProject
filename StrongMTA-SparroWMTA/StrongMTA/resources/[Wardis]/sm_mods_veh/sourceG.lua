vehicleDataTable = {
	[445] = {modelPatch = "admiral", vehicleName = "Dodge Charger", vehicleBrand = "Dodge"},
	[479] = {modelPatch = "regina", vehicleName = "Mercedes-Benz 500 E", vehicleBrand = "Mercedes"},
	[439] = {modelPatch = "stallion", vehicleName = "Acura NSX", vehicleBrand = "Acura"},
	[402] = {modelPatch = "buffalo", vehicleName = "Dodge Demon", vehicleBrand = "Dodge"},
	[405] = {modelPatch = "sentinel", vehicleName = "Subaru Legacy", vehicleBrand = "Subaru"},
	[438] = {modelPatch = "cabbie", vehicleName = "BMW M5 F10", vehicleBrand = "BMW"},
	[573] = {modelPatch = "dune", vehicleName = "Dune", vehicleBrand = "Dune"},
	--[547] = {modelPatch = "primo", vehicleName = "Buick Century 1983", vehicleBrand = "Buick"},
	[566] = {modelPatch = "tahoma", vehicleName = "Honda Civic Type R", vehicleBrand = "Honda"},
	[602] = {modelPatch = "alpha", vehicleName = "Audi R8 V10", vehicleBrand = "Audi"},
	[453] = {modelPatch = "reefer", vehicleName = "Reefer", vehicleBrand = "Reefer"},
	[454] = {modelPatch = "tropic", vehicleName = "Tropic", vehicleBrand = "Tropic"},
	[587] = {modelPatch = "euros", vehicleName = "Volkswagen Scirocco", vehicleBrand = "Volkswagen"},
	[576] = {modelPatch = "tornado", vehicleName = "Cserélhető modell", vehicleBrand = "ASD"},
	[401] = {modelPatch = "bravura", vehicleName = "Mercedes-Benz AMG GT", vehicleBrand = "Mercedes"},
	[579] = {modelPatch = "huntley", vehicleName = "Jeep Grand Cherokee", vehicleBrand = "Jeep"},
	[411] = {modelPatch = "infernus", vehicleName = "Ford Mustang 2019 Radmir", vehicleBrand = "Ford"},
	[521] = {modelPatch = "fcr-900", vehicleName = "BMW S-1000", vehicleBrand = "BMW"},
	[431] = {modelPatch = "bus", vehicleName = "Bus", vehicleBrand = "Bus"},
	[498] = {modelPatch = "boxville", vehicleName = "Boxville", vehicleBrand = "Boxville"},
	[540] = {modelPatch = "vincent", vehicleName = "Tesla Model X", vehicleBrand = "Tesla"},
	[502] = {modelPatch = "hotr2", vehicleName = "Ferrari 480 Pista", vehicleBrand = "Ferrari"},
	[426] = {modelPatch = "premier", vehicleName = "BMW M5 e34", vehicleBrand = "BMW"},
	[526] = {modelPatch = "fortune", vehicleName = "Nissan Silvia", vehicleBrand = "BMW"},
	[503] = {modelPatch = "hotr3", vehicleName = "Bugatti Chiron", vehicleBrand = "Bugatti"},
	[475] = {modelPatch = "sabre", vehicleName = "BMW M4 e85", vehicleBrand = "ASD"},
	[575] = {modelPatch = "broadway", vehicleName = "Cadillac", vehicleBrand = "Cadillac"},
	[585] = {modelPatch = "emperor", vehicleName = "Mercedes", vehicleBrand = "Mercedes"},
	[541] = {modelPatch = "bullet", vehicleName = "Ford GT", vehicleBrand = "Ford"},

	[422] = {modelPatch = "bobcat", vehicleName = "Zsombor anyujanak kocsija", vehicleBrand = "90 el kanyarban"},
	[507] = {modelPatch = "elegant", vehicleName = "Dodge Dart", vehicleBrand = "Dodge"},
	[527] = {modelPatch = "cadrona", vehicleName = "BMW M4 2021", vehicleBrand = "BMW"},
	[603] = {modelPatch = "phoenix", vehicleName = "Dodge Charger R/T", vehicleBrand = "Dodge"},

	[491] = {modelPatch = "virgo", vehicleName = "Buick Regal", vehicleBrand = "Buick"},

	[408] = {modelPatch = "trash", vehicleName = "trash", vehicleBrand = "trash"},

	[443] = {modelPatch = "packer", vehicleName = "packer", vehicleBrand = "packer"},

	[596] = {modelPatch = "copcarla", vehicleName = "Chevrolet Caprice 1992", vehicleBrand = "Chevrolet"},

	[611] = {modelPatch = "utiltr1", vehicleName = "Trailer", vehicleBrand = "Chevrolet"},

}

function getCustomVehicleName(sourceVehModel)
	if sourceVehModel then
		if vehicleDataTable[sourceVehModel] and vehicleDataTable[sourceVehModel].vehicleName then
			return vehicleDataTable[sourceVehModel].vehicleName
		else
			return getVehicleNameFromModel(sourceVehModel)
		end
	else
		return "Invalid modelId"
	end
end

function getCustomVehicleNameFromVehicle(sourceVehicle)
	if isElement(sourceVehicle) then
		local sourceVehModel = getElementModel(sourceVehicle)

		if vehicleDataTable[sourceVehModel] and vehicleDataTable[sourceVehModel].vehicleName then
			return vehicleDataTable[sourceVehModel].vehicleName 
		else
			return getVehicleNameFromModel(sourceVehModel)
		end
	else
		return "Invalid modelId"
	end
end

function getCustomVehicleManufacturer(sourceVehModel)
	if sourceVehModel then
		if vehicleDataTable[sourceVehModel] and vehicleDataTable[sourceVehModel].vehicleBrand then
			return vehicleDataTable[sourceVehModel].vehicleBrand
		else
			return "GTA-SA"
		end
	else
		return "Invalid modelId"
	end
end


function splitEx(inputstr, sep)
	if not sep then
		sep = "%s"
	end

	local t = {}
	local i = 1

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end