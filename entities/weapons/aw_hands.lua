SWEP.PrintName = "Hands"
SWEP.Slot      = 0
SWEP.HoldType = "normal"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.WorldModel = ""
SWEP.UseHands = true

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

function SWEP:PreDrawViewModel()
    return true
end

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()

end
