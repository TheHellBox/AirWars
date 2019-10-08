local function check_collision(ship, other_ship, part)
	local matrix = Matrix()
	matrix:Translate(ship.position)
	matrix:Rotate(ship.angles)

	matrix:Translate(part.position - ship.center)
	--matrix:Rotate(part.angle)

	local start_pos = matrix:GetTranslation()

	for k, other_part in pairs(other_ship.parts) do
		local matrix = Matrix()
		matrix:Translate(other_ship.position)
		matrix:Rotate(other_ship.angles)
		matrix:Translate(other_part.position - other_ship.center + other_part.collision_bounds[3])
		--matrix:Rotate(other_part.angle)

		local part_pos = matrix:GetTranslation()
		local angle = matrix:GetAngles()

		local hit = start_pos:WithinAABox( part_pos + other_part.collision_bounds[1], part_pos + other_part.collision_bounds[2] )

		if hit then
			return hit, other_part, start_pos
		end
	end
	return false, nil, Vector()
end

col_next_update_time = CurTime()

// Collision detection is REALLY expensive.
hook.Add("Think", "Check Collisions", function()
	if CurTime() < col_next_update_time then return end
	col_next_update_time = CurTime() + 0.5

	for _, ship in pairs(world_ships) do
		for _, other_ship in pairs(world_ships) do
			if ship == other_ship then continue end
			local len = ship.max:Length() / 2
			if ship.position:DistToSqr(other_ship.position) > math.pow(len, 2) then continue end
			print("check")
			for _, part in pairs(ship.parts) do
				local hit, hit_part, hit_pos = check_collision(ship, other_ship, part)
				if hit then
					local mass_a = calculate_ship_weight(ship.id)
					local mass_b = calculate_ship_weight(other_ship.id)

					local damage_a = -math.Clamp(ship.speed / 4, 0, math.Clamp(hit_part.health, 0, math.huge))
					local damage_b = -math.Clamp(ship.speed / 4, 0, math.Clamp(part.health, 0, math.huge))

					local mass_sum = (mass_a + mass_b)
					local mass_dif_a = (mass_a - mass_b)
					local mass_dif_b = (mass_b - mass_a)

					local velocity_a = (mass_dif_a / mass_sum) * ship.velocity
					velocity_a = velocity_a + (2 * mass_b) / mass_sum * other_ship.velocity

					local velocity_b = (2 * mass_a) / mass_sum * ship.velocity
					velocity_b = velocity_b + mass_dif_b / mass_sum * other_ship.velocity


					part:AddHealth(damage_a, ship.id)
					hit_part:AddHealth(damage_b, ship.id)

					ship.velocity = velocity_a
					other_ship.velocity = velocity_b
				end
			end
		end
	end
end)

hook.Add("Think", "Ground Collision", function()
	for k, ship in pairs(world_ships) do
		if ship.position.z < 10 then
			AirWars:DestroyShip(ship)
		end
	end
end)
