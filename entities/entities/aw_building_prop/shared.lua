ENT.Base = "aw_base"
ENT.Type = "anim"
ENT.Author = "The HellBox"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Category" )
	self:NetworkVar( "Int", 1, "Prop" )
	self:NetworkVar( "Int", 2, "AWTeam" )
end
