local fileType = ".dff"

local toLockTable = {
	--"1st",
	"1",
	--"plaza",

}

local dStorage = "files/"
local lockCode = "yy-8LG#H@yRgKQ-UpxCSMWgzu@LpVbW#uDuVnc*qc9h+_EtR@Vw#mAsF6yzv5u3jJqupMs$"
local lockString = 655

function lockFile(path, key)
	local file = fileOpen(path)
	local size = fileGetSize(file)
	local FirstPart = fileRead(file, lockString)
	fileSetPos(file, lockString)
	local SecondPart = fileRead(file, size-lockString)
	fileClose(file)
	file = fileCreate(utf8.gsub(path, fileType, "")..".strong")
	fileWrite(file, encodeString("tea", FirstPart, { key = key })..SecondPart)
	fileClose(file)
	return true
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		for k,v in pairs(toLockTable) do
			lockFile(dStorage..v..fileType, lockCode)
		end
	end
)
