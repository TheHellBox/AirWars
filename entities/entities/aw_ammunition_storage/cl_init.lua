include("shared.lua")

function ENT:DrawInfo(position, angle)
	if LocalPlayer():IsSpectator() then return end
	render.OverrideDepthEnable( true, true )
	render.DepthRange( 0.0, 0.0 )
	cam.Start3D2D( position, angle, 0.25 )
		surface.SetDrawColor( 80, 80, 150, 255 )
		surface.DrawRect( 0, 0, 200, 60 )
		surface.SetDrawColor( 50, 50, 120, 255 )
		surface.DrawRect( 5, 5, 190, 50 )

		draw.SimpleText( "Ammo:"..self:GetAmmoAmount(), "DermaLarge", 100, 30, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()

	render.DepthRange( 0.0, 1.0 )
	render.OverrideDepthEnable( false, false )
end

function ENT:Draw()
	if self:GetAWTeam() != LocalPlayer():GetCurrentShip() then return end
	local position = self:LocalToWorld( Vector( 23, 0, 40 ) )
	local angle = self:GetAngles() - Angle(180, 0, 180)
	self:DrawInfo(position, angle)
end
