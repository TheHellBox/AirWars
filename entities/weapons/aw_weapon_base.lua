SWEP.PrintName = "AW Weapon Base"
SWEP.Slot      = 0
SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:SendWeaponEffect(trace, entity)
	net.Start("aw_weapon_effect")
	net.WriteVector(trace.HitPos)
	net.WriteVector(trace.Normal)
	net.WriteInt(trace.SurfaceProps, 32)
	net.WriteInt(trace.HitBox, 32)
	net.WriteEntity(entity)
	net.SendOmit(self.Owner)
end

function SWEP:MakeClientEffect(trace, entity)
	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetNormal( trace.Normal )
	effectdata:SetSurfaceProp( trace.SurfaceProps )
	effectdata:SetHitBox( trace.HitBox )
	effectdata:SetEntity( entity )
	util.Effect( "Impact", effectdata)
end

function SWEP:ApplyDamage(entity, amount)
	if entity.part_id then
		local part = world_ships[entity:GetAWTeam()].parts[entity.part_id]
		if part ~= nil then
			if SERVER then
				part:AddHealth(-amount / 5)
				return
			end
		end
	end
	if !entity:IsPlayer() then return end

	local damage = DamageInfo()
	damage:SetDamage(amount)
	damage:SetAttacker(self.Owner)
	damage:SetInflictor(self.Weapon)
	damage:SetDamageForce(self.Owner:GetAimVector() * 1500)
	damage:SetDamagePosition(self.Owner:GetPos())
	damage:SetDamageType(DMG_CLUB)
	entity:TakeDamageInfo(damage)
end

function SWEP:MakeTrace()
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector() * 75)
	trace.filter = function(ent)
		if ent:IsPlayer() and ent:GetCurrentShip() == self.Owner:GetCurrentShip() then
			return ent != self.Owner
		end
		if ent:GetAWTeam() == self.Owner:GetCurrentShip() then
			return ent != self.Owner
		end
		return false
	end
	trace = util.TraceLine(trace)
	return trace
end

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()

end
