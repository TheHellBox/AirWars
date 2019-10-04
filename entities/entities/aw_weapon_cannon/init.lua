AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	self:SetUseType( SIMPLE_USE )
	local part = world_ships[self:GetAWTeam()].parts[self.part_id]
	part.model = "models/aw_cannon/aw_cannon_gun.mdl"
	part.position = LocalToWorld( Vector(0, 20, 18), Angle(), part.position, part.angle)
end

function ENT:Think()
	local controller = self:GetController()
	if IsValid(controller) then
		local angle =(-controller:EyeAngles():Forward()):Angle().x
		world_ships[self:GetAWTeam()].parts[self.part_id].angle.x = angle
	end
end
