hook.Add("HUDPaint", "Draw Compass", function()
	if game_state_get_state() != GAME_STATE_FIGHT then return end
	if LocalPlayer():IsSpectator() then return end
	local angles = {}
	local rad = 100

	for k=0, 35 do
		local angle = k * 10
		local cos = math.cos( math.rad( angle + 45 - EyeAngles().y) )
		local sin = math.sin( math.rad( angle + 45 - EyeAngles().y) )

		local x = rad * sin - rad * cos + ScrW() - 150
		local y = rad * cos + rad * sin + ScrH() - 150

		draw.SimpleText( ""..angle, "DermaDefault", x, y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local local_ship = world_ships[LocalPlayer():GetCurrentShip()]
	if local_ship == nil then return end
	for _, ship in pairs(world_ships) do
		if ship == local_ship then continue end
		if #get_crew(ship) < 1 then continue end

		local dif = local_ship.position - ship.position
		local x, y = dif.x, dif.y
		local angle = math.deg( math.atan2(y, x) ) + 50

		local cos = math.cos( math.rad( angle - EyeAngles().y - local_ship.angles.y) )
		local sin = math.sin( math.rad( angle - EyeAngles().y - local_ship.angles.y) )

		local x = rad * sin - rad * cos + ScrW() - 150
		local y = rad * cos + rad * sin + ScrH() - 150

		draw.RoundedBox( 5, x, y, 10, 10, Color(255, 0, 0) )
	end
end)
