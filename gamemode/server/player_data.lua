local meta = FindMetaTable("Player")
local path = "aw_player_data/"

-- Called every time player gets spawned
function meta:InitializeData()
	if !file.Exists(path, "DATA") then
		file.CreateDir( path )
	end
	if !self:CheckDataFile() then
		self:CreateDataFile()
	end
	self.player_data = self:LoadData()
end

function meta:CreateEmptyData()
	return {
		points = 0,
		wearables = {},
		unlocked = {}
	}
end

function meta:DataToString(data)
	return util.TableToJSON(data) or "{}"
end

function meta:DataStringToTable(data)
	return util.JSONToTable(data) or {}
end

function meta:SIDToFilePath()
	return path..(self:SteamID64() or "local")..".json"
end

-- Check if players save file exists
function meta:CheckDataFile()
	return file.Exists( self:SIDToFilePath(), "DATA" )
end

function meta:CreateDataFile()
	file.Write( self:SIDToFilePath(), self:DataToString(self:CreateEmptyData()) )
end

function meta:LoadData()
	local file = file.Read(self:SIDToFilePath(), "DATA")
	return self:DataStringToTable(file)
end

function meta:SaveData()
	file.Write( self:SIDToFilePath(), self:DataToString(self.player_data) )
end

function meta:GetDataValue(value_name)
	if !self.player_data then return nil end
	return self.player_data[value_name]
end

function meta:SetDataValue(value_name, value)
	self.player_data[value_name] = value
	self:SaveData()
end
