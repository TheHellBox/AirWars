AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
end

function ENT:Use(activator, caller)
	if IsValid(self:GetController()) then
		self:GetController():ExitControl()
	end
	activator:AWControl(self)
	activator.controller_angle = self:GetAngles()
	self.last_controller = activator
end

function ENT:OnRemove()
	if IsValid(self:GetController()) then
		self:GetController():ExitControl()
		world_ships[self:GetAWTeam()].velocity = Vector()
	end
end
