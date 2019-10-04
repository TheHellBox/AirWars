AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	self:SetAmmoAmount(1)
end

function ENT:Think()
	local controller = self:GetNWEntity("aw_controller")
	local enabled = self:GetNWBool("aw_enabled")
	if IsValid(controller) and enabled then
		local angle =(-controller:EyeAngles():Forward()):Angle().x
		world_ships[self:GetAWTeam()].parts[self.part_id].angle.x = angle
	end
end

function ENT:Use(activator, caller)
	activator:ExitControl()
	if self:GetAmmoAmount() < 1 then
		self:Reload(activator)
		return
	end
	self:Shoot()
end

function ENT:OnShoot(part)
	part:AddHealth(-part.health)
end
