availableSkins = {
	["Férfi"] = {
		--{1, 150},
		{2, 150},
	--	{7, 150},
	--	{14, 150},
	--	{15, 150},
	--	{16, 150},
	--	{17, 150},
		{19, 150},
		{20, 150},
		{21, 150},
		{22, 150},
		{23, 150},
		{24, 150},
		{25, 150},
		{26, 150},
		{27, 150},
		{28, 150},
		{29, 150},
		{30, 150},
		{32, 150},
		{33, 150},
		{35, 150},
		{37, 150},
		{43, 150},
		{44, 150},
		{45, 150},
		{46, 150},
		{47, 150},
		{48, 150},
		{49, 150},
		{50, 150},
		{51, 150},
		{52, 150},
		{54, 150},
		{57, 150},
		{58, 150},
		{59, 150},
		{60, 150},
		{62, 150},
		{68, 150},
		{70, 150},
		{71, 150},
		{72, 150},
		{73, 150},
		{78, 150},
		{80, 150},
		{94, 150},
		{95, 150},
		{96, 150},
		{98, 150},
		{99, 150},
		{101, 150},
		{105, 150},
		{106, 150},
		{107, 150},
		{108, 150},
		{109, 150},
		{110, 150},
		{121, 150},
		{122, 150},
		{123, 150},
		{127, 150},
		{128, 150},
		{129, 150},
		{132, 150},
		{133, 150},
		{134, 150},
		{136, 150},
		{137, 150},
		{141, 150},
		{142, 150},
		{143, 150},
		{144, 150},
		{147, 150},
		{153, 150},
		{154, 150},
		{155, 150},
		{156, 150},
		{160, 150},
		{166, 150},
		{168, 150},
		{170, 150},
		{171, 150},
		{173, 150},
		{174, 150},
		{176, 150},
		{177, 150},
		{179, 150},
		{180, 150},
		{181, 150},
		{182, 150},
		{183, 150},
		{184, 150},
		{185, 150},
		{186, 150},
		{187, 150},
		{202, 150},
		{204, 150},
		{206, 150},
		{209, 150},
		{210, 150},
		{213, 150},
		{217, 150},
		{220, 150},
		{221, 150},
		{222, 150},
		{223, 150},
		{227, 150},
		{228, 150},
		{229, 150},
		{230, 150},
		{234, 150},
		{235, 150},
		{240, 150},
		{241, 150},
		{242, 150},
		{249, 150},
		{250, 150},
		{253, 150},
		{255, 150},
		{258, 150},
		{259, 150},
		{260, 150},
		{262, 150},
		{264, 150},
		{268, 150},
		{270, 150},
		{271, 150},
		{290, 150},
		{291, 150},
		{295, 150},
		{299, 150},
		{300, 150},
		{301, 150},
		{303, 150},
		{305, 150},
		{306, 150},
		{308, 150},
		{309, 150},
		{310, 150},
		{312, 150}
	},
	["Női"] = {
		{11, 150},
		{12, 150},
		{13, 150},
		{40, 150},
		{41, 150},
		{55, 150},
		{69, 150},
		{76, 150},
		{79, 150},
		{90, 150},
		{91, 150},
		{93, 150},
		{135, 150},
		{148, 150},
		{150, 150},
		{151, 150},
		{152, 150},
		{169, 150},
		{172, 150},
		{190, 150},
		{192, 150},
		{193, 150},
		{194, 150},
		{195, 150},
		{199, 150},
		{201, 150},
		{207, 150},
		{211, 150},
		{214, 150},
		{215, 150},
		{216, 150},
		{219, 150},
		{224, 150},
		{225, 150},
		{226, 150},
		{233, 150},
		{263, 150},
		{304, 150}
	}
}

availableShops = {
	{1317.7541503906, -870.65893554688, 39.578125 - 1, 290, 0, 0, "Női"},
	{1041.7506103516, -1443.0034179688, 13.554650306702 - 1, 200, 0, 0, "Férfi"}
}

function getSkinsByType(type)
	if type then
		if availableSkins[type] then
			return availableSkins[type]
		else
			return false
		end
	else
		return false
	end
end