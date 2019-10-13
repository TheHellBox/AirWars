ENT.Base = "aw_weapon_base"
ENT.Type = "anim"
ENT.Author = "The HellBox"
ENT.Spawnable = false

ENT.ShootingAngle = Angle()
ENT.ShootingOffset = 30
ENT.AmmoAmount = 1
ENT.Cooldown = 3

function ENT:PostSetupDataTables()
	self:NetworkVar( "Int", 3, "HookState" )
end
