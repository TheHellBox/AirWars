AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	self:SetUseType( SIMPLE_USE )
	local part = world_ships[self:GetAWTeam()].parts[self.part_id]
	part.model = "models/aw_rifle/aw_rifle_gun.mdl"
	part.position = part.position + Vector(0, 0, 50)
end

function ENT:Think()
	local controller = self:GetController()
	if IsValid(controller) then
		world_ships[self:GetAWTeam()].parts[self.part_id].angle = (-controller:EyeAngles():Forward()):Angle()
	end
end
