AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Use(activator, caller)
	if activator:IsSpectator() then return end
	activator:ExitControl()
	if self:GetAmmoAmount() < 1 then
		self:Reload(activator)
		return
	end
	self:SetController(activator)
	activator:AWControl(self)
end

function ENT:Reload(player)
	if !player then
		self:SetAmmoAmount(self.AmmoAmount)
		return
	elseif player:AWHasAmmo() then
		self:SetAmmoAmount(self.AmmoAmount)
		player:AWGiveAmmo(false)
	end
end

function ENT:Shoot(player)
	if CurTime() < (self.cooldown or 0) then return end
	local self_ship = world_ships[self:GetAWTeam()]
	AirWars:ShipShoot(self_ship, self_ship.parts[self.part_id], self.ShootingOffset, self.ShootingAngle, self)
	self:SetAmmoAmount(math.Clamp(self:GetAmmoAmount() - 1, 0, self.AmmoAmount))
	self.cooldown = CurTime() + self.Cooldown
	self:OnShoot(self_ship.parts[self.part_id])
	if self:GetAmmoAmount() < 1 then
		if IsValid(player) then
			player:ExitControl()
		end
		return
	end
end

function ENT:OnShoot()

end

function ENT:OnHit(ship)

end

function ENT:OnRemove()
	if IsValid(self:GetController()) then
		self:GetController():ExitControl()
	end
end
