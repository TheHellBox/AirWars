local function point_in_sphere(point, sphere_center, rad)
	local x = math.pow(( point.x - sphere_center.x ), 2)
	local y = math.pow(( point.y - sphere_center.y ), 2)
	local z = math.pow(( point.z - sphere_center.z ), 2)

	return (x + y + z) < math.pow(rad, 2)
end


hook.Add("Think", "Check Borders", function()
	for k, ship in pairs(world_ships) do
		local rad = 32000 * (game_state.time_left / global_config.fight_time)
		if !point_in_sphere(ship.position, Vector(), rad) then
			if ship.disable_position_sync then
				for k, v in pairs(get_crew(ship)) do
					v:TakeDamage(FrameTime() * 5, game.GetWorld(), game.GetWorld())
				end
			end
			ship.velocity.z = -200
		end
	end
end)
