availableGates = {
	--				   1  2  3  4   5   6          7  8  9  10  11  12      13        14      15                16                17       18
	-- [KAPUID] = {Nyitott X, Y, Z, RX, RY, RZ), (Zárt X, Y, Z, RX, RY, RZ), Interior, Dimenzió, Model, Nyitás/zárás sebessége (ms), Scale, Collision}
}

prisonGates = {72, 104}

function getPrisonGateIDs()
	return prisonGates
end

function getGateDetails(gateID)
	return availableGates[gateID]
end