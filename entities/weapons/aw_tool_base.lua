SWEP.PrintName = "Tool Base"
SWEP.Slot      = 5
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_toolgun.mdl"
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

if CLIENT then
	matScreen = Material( "models/weapons/v_toolgun/screen" )
	RTTexture = GetRenderTarget( "GModToolgunScreen", 256, 256 )
	txBackground = surface.GetTextureID( "models/weapons/v_toolgun/screen_bg" )

	surface.CreateFont( "GModToolScreen", {
		font	= "Helvetica",
		size	= 60,
		weight	= 900
	} )
end

function SWEP:MakeTrace()
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + (self.Owner:GetAimVector() * 2048)
	trace.filter = function(ent)
		if ent.GetAWTeam and ent:GetAWTeam() == self.Owner:GetAWTeam() and !ent:IsPlayer() then
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

function SWEP:ToolOptions(frame)

end

function SWEP:GetVariable(name, fallback)
	return self.Owner:GetInfoNum(self.ToolName .. "_" .. name, fallback)
end

-- Somehow it's depricated in documentation, but original toolgun still uses it
function SWEP:RenderScreen()
	local OldRT = render.GetRenderTarget()

	matScreen:SetTexture( "$basetexture", RTTexture )
	render.SetRenderTarget( RTTexture )
	render.SetViewPort( 0, 0, 256, 256 )
	cam.Start2D()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( txBackground )
		surface.DrawTexturedRect( 0, 0, 256, 256 )

		surface.SetFont( "GModToolScreen" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 5, 80 )
		surface.DrawText( self.PrintName )
	cam.End2D()

	render.SetRenderTarget( OldRT )
	render.SetViewPort( 0, 0, ScrW(), ScrH() )
end
