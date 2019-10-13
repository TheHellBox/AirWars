ENT.Base = "aw_base"
ENT.Type = "anim"
ENT.Author = "The HellBox"
ENT.Spawnable = false

function ENT:PostSetupDataTables()
	self:NetworkVar( "Int", 3, "Category" )
	self:NetworkVar( "Int", 4, "Prop" )
end
