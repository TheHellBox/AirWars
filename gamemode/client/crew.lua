hook.Add("PrePlayerDraw", "draw_crew_members", function(player)
	if player:IsSpectator() then return true end
	if LocalPlayer():IsSpectator() then return true end
	return player:GetCurrentShip() != LocalPlayer():GetCurrentShip()
end)

hook.Add( "CreateClientsideRagdoll", "Disable Corpses", function( entity, ragdoll )
	ragdoll:SetNoDraw()
end )

hook.Add( "PostPlayerDraw", "Draw Team Names", function(player)
	if !player:IsValid() then return end
	if player == LocalPlayer() then return end
	if !player:Alive() then return end
	if player:GetCurrentShip() != LocalPlayer():GetCurrentShip() then return end
	local color = Color(255, 255, 255)

	if !player:AWIsInTeam(LocalPlayer():GetAWTeam()) then
		color = Color(255, 0, 0)
	end

	local angle = LocalPlayer():EyeAngles()

	angle:RotateAroundAxis( angle:Forward(), 90 )
	angle:RotateAroundAxis( angle:Right(), 90 )

	local position = player:GetBonePosition(player:LookupBone("ValveBiped.Bip01_Head1"))
	cam.Start3D2D( position + Vector(0, 0, 20), Angle( 0, angle.y, 90 ), 0.25 )
		draw.DrawText( player:GetName(), "DermaLarge", 2, 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end)

hook.Add( "DrawPhysgunBeam", "Disable Physgun Beam", function( player )
	if player:GetAWTeam() != LocalPlayer():GetAWTeam() then
		return false
	end
end )
