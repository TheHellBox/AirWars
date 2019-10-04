SWEP.Base = "aw_weapon_base"
SWEP.PrintName = "Melee"
SWEP.Slot      = 0
SWEP.HoldType = "melee"
SWEP.ViewModel = "models/aw_wrench_a/aw_wrench_a.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

local sound = Sound("Weapon_Crowbar.Single")

function SWEP:PrimaryAttack()
	if self.Owner:IsInControl() then return end

	if ( self.Owner:IsPlayer() ) then
		self.Owner:LagCompensation( true )
	end
	self:SetNextPrimaryFire( CurTime() + 0.5 )
	if CLIENT then
		self.Weapon:EmitSound(sound)
	end
	local trace = self:MakeTrace()
	if ( self.Owner:IsPlayer() ) then
		self.Owner:LagCompensation( false )
	end

	if !IsValid(trace.Entity) then
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		return
	end
	local entity = trace.Entity
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER  )

	if !CLIENT then
		self:SendWeaponEffect(trace, entity)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self:ApplyDamage(entity, 20)
	else
		self:MakeClientEffect(trace, entity)
	end
end
