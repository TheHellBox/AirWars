include("shared.lua")

function ENT:Initialize()
	local team = self:GetAWTeam()
	if !aw_parts_ents[team] then
		aw_parts_ents[team] = {}
	end
	aw_parts_ents[team][self:GetPartID()] = self
	self:PostInitialize()
end

function ENT:DrawInfo(position, angle, scale)
	if LocalPlayer():IsSpectator() then return end
	local scale = scale or 0.25
	local ammo_amount = self:GetAmmoAmount()
	local text = "Ammo:"..ammo_amount
	if ammo_amount < 1 then
		text = "Reload"
	end

	render.OverrideDepthEnable( true, true )
	render.DepthRange( 0.0, 0.0 )
	cam.Start3D2D( position, angle, scale )
		surface.SetDrawColor( 80, 80, 150, 255 )
		surface.DrawRect( 0, 0, 200, 60 )
		surface.SetDrawColor( 50, 50, 120, 255 )
		surface.DrawRect( 5, 5, 190, 50 )
		draw.SimpleText( text, "DermaLarge", 100, 30, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
	render.DepthRange( 0.0, 1.0 )
	render.OverrideDepthEnable( false, false )
end

function ENT:Draw()
	if self:GetAWTeam() != LocalPlayer():GetCurrentShip() then return end
	local position = self:LocalToWorld( Vector( -25, -40, 25 ) )
	local angle = self:GetAngles() - Angle(180, 180, 90)
	self:DrawInfo(position, angle)
end

-- This is beeing called after effect was played
function ENT:OnShoot()

end

function ENT:PostInitialize()

end
