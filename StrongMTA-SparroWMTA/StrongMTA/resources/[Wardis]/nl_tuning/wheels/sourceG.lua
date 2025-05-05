-- PIROS = 214,76,69 #d64c45
-- SÁRGA = 214,175,66 #d6af42
-- ZÖLD = 116,179,71 #74b347
-- KÉK = 84,144,196 #5490c4

wheels = { --[id] = {id=objectid,texture=shadername}
	[1] = {id=1082,texture="te37"},
	[2] = {id=1077,texture="hamman_editrace"},
	[3] = {id=1079,texture="gram_t57"},
	[4] = {id=1075,texture="enkei_nt03"},
	[5] = {id=1081,texture="advan_rgii"},
	[6] = {id=1073,texture="wed_105"},
	[7] = {id=1098,texture="crkai"},
	[8] = {id=1096,texture="advan_racingv2"},
	[9] = {id=1025,texture="rota_tarmac3"},
	[10] = {id=1085,texture="wed_sa97"},
	[11] = {id=1080,texture="boyd_slayer"},
	[12] = {id=1078,texture="dub_president"},
	[13] = {id=1076,texture="dub_president"},
	[14] = {id=1074,texture="zen_dynm"},
	[15] = {id=1097,texture="gram_t57"},
	[16] = {id=932,texture="vs_kf"},
	[17] = {id=1369,texture="emzone_aliumas"},
	[18] = {id=3933,texture="g07bw"},
	[19] = {id=18005,texture="emzone_aliumas"},
	[20] = {id=18003,texture="b5"},
	[21] = {id=14725,texture="emzone_aliumas"},
	[22] = {id=14724,texture="vce"},
	[23] = {id=14723,texture="ssrp"},
	[24] = {id=14722,texture="borbeta"},
	[25] = {id=14727,texture="bbs_cm"},
	[26] = {id=14726,texture="blq"},
	[27] = {id=14715,texture="bbs_lm"},
	[28] = {id=16208,texture="grey2"},
	[29] = {id=16094,texture="advan_rg_ii"},
	[30] = {id=16649,texture="grey2"},  
	[31] = {id=16643,texture="grey2"}, 
	[32] = {id=16653,texture="grey2"}, 
	[33] = {id=16648,texture="grey2"}, 
	[34] = {id=16647,texture="grey2"}, 
	[35] = {id=16641,texture="grey2"}, 
	[36] = {id=3401,texture="grey2"},
	[37] = {id=3400,texture="rota_p45r_deaddrftr"},
	[38] = {id=16681,texture="grey2"}, 
	[39] = {id=16664,texture="bbsrs"}, 
	[40] = {id=16682,texture="panasport"}, 
	[41] = {id=16665,texture="grey2"}, 
	[42] = {id=16663,texture="te37tta"}, 
	[43] = {id=16203,texture="vs_kf"},
	[44] = {id=16656,texture="grey2"},
	[45] = {id=16651,texture="wed_105"},
	[46] = {id=16650,texture="wed_105"},
}

defualt_size = 0.7
wheel_size = {
	[401] = 0.8, -- BMW M4
	[579] = 0.94, -- Mercedes-Benz G63
	[518] = 0.79, -- Nissan 370z Nismo
}
function getVehicleWheelSize(vehicle)
	if isElement(vehicle) then
		if wheel_size[getElementModel(vehicle)] then
			return wheel_size[getElementModel(vehicle)]
		else
			return defualt_size
		end
	end
end