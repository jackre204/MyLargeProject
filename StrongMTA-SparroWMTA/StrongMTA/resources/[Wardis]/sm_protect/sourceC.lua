local lockCode = "yy-8LG#H@yRgKQ-UpxCSMWgzu@LpVbW#uDuVnc*qc9h+_EtR@Vw#mAsF6yzv5u3jJqupMs$"
local lockString = 65536

function loadLockedFiles(path, key)
	local file = fileOpen(path)
	local size = fileGetSize(file)
	local FirstPart = fileRead(file, lockString+4)
	fileSetPos(file, lockString+4)
	local SecondPart = fileRead(file, size-(lockString+4))
	fileClose(file)
	return decodeString("tea", FirstPart, { key = key })..SecondPart
end
