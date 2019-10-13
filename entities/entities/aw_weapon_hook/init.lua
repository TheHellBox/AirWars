AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	self:SetUseType( SIMPLE_USE )
	local part = world_ships[self:GetAWTeam()].parts[self.part_id]
	part.model = "models/aw_hook/aw_hook.mdl"
	part.position = part.position + Vector(0, 0, 50)
	self:Reload()
end

function ENT:Think()
	local controller = self:GetController()
	if IsValid(controller) then
		world_ships[self:GetAWTeam()].parts[self.part_id].angle = (-controller:EyeAngles():Forward()):Angle()
	end
end

function ENT:OnShoot()
	self:SetHookState(1)
	timer.Simple(self.Cooldown, function()
		if !IsValid(self) then return end
		if self.hit then return end
		self:SetHookState(0)
	end)
end
