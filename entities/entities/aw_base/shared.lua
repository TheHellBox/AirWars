ENT.Type = "anim"
ENT.Author = "The HellBox"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "AWTeamRaw" )
	self:NetworkVar( "Int", 1, "PartID" )
	self:NetworkVar( "Entity", 2, "Controller" )
	self:PostSetupDataTables()
end

function ENT:PostSetupDataTables()

end
