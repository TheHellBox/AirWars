AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	self:SetAmmoAmount(20)
	self.next_reload_time = CurTime()
end

function ENT:Use(activator, caller)
	local ammo_amount = self:GetAmmoAmount()
	if ammo_amount < 1 then return end
	if activator:AWHasAmmo() then return end
	activator:AWGiveAmmo()
	self:SetAmmoAmount(math.Clamp(self:GetAmmoAmount() - 1, 0, math.huge))
end

function ENT:Think(activator, caller)
	local ammo_amount = self:GetAmmoAmount()
	if CurTime() > self.next_reload_time then
		self:SetAmmoAmount(math.Clamp(self:GetAmmoAmount() + 1, 0, 20))
		self.next_reload_time = self.next_reload_time + 30
	end
end
