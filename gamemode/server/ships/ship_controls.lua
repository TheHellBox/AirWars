local next_position_update = 0

function init_ship_controls()
	return {
		direction = Vector(),
		angle = Angle(),
		controller_angle = Angle()
	}
end

hook.Add("PlayerButtonDown", "Ship Controls PBD", function(player, button)
	local controller = player:GetEntityUnderControl()
	if !IsValid(controller) or controller:GetClass() != "aw_ship_controller" then return end
	local player_ship = world_ships[player:GetCurrentShip()]
	if player_ship ~= nil then
		player_ship.direction.controller_angle = player.controller_angle
		if button == KEY_W then
			player_ship.direction.direction.x = 1
		end
		if button == KEY_S then
			player_ship.direction.direction.x = -1
		end
		if button == KEY_A then
			player_ship.direction.angle.y = 1
		end
		if button == KEY_D then
			player_ship.direction.angle.y = -1
		end
		if button == KEY_SPACE then
			player_ship.direction.direction.z = 1
		end
		if button == KEY_LSHIFT then
			player_ship.direction.direction.z = -1
		end
	end
end)

hook.Add("Think", "Ships Jingle", function()

end)

hook.Add("PlayerButtonUp", "Ship Controls PBU", function(player, button)
	local controller = player:GetEntityUnderControl()
	if !IsValid(controller) or controller:GetClass() != "aw_ship_controller" then return end
	local player_ship = world_ships[player:GetCurrentShip()]
	if player_ship ~= nil then
		player_ship.direction.controller_angle = player.controller_angle
		if button == KEY_W then
			player_ship.direction.direction.x = 0
		end
		if button == KEY_S then
			player_ship.direction.direction.x = 0
		end
		if button == KEY_A then
			player_ship.direction.angle.y = 0
		end
		if button == KEY_D then
			player_ship.direction.angle.y = 0
		end
		if button == KEY_LSHIFT then
			player_ship.direction.direction.z = 0
		end
		if button == KEY_SPACE then
			player_ship.direction.direction.z = 0
		end
		if button == KEY_R then
			if player:IsInControl() then
				player:ExitControl()
			end
		end
	end
end)

hook.Add("Think", "Update Ships Position", function()
	if next_position_update < CurTime() then
		next_position_update = CurTime() + global_config.position_sync_rate
		for _, ship in pairs(world_ships) do
			if ship.disable_position_sync then continue end
			ship:SyncPosition()
		end
	end
end)

hook.Add("Think", "Update Ships Controls", function()
	for _, ship in pairs(world_ships) do
		-- If we don't sync the position, why should we move ships
		if ship.disable_position_sync then continue end

		ship.velocity = ship.velocity or Vector()
		ship.angle_velocity = ship.angle_velocity or Angle()
		ship.speed = ship.velocity:Length()
		ship.rotation_speed = ship.angle_velocity.x + ship.angle_velocity.y + ship.angle_velocity.z

		local forward = (ship.angles + ship.direction.controller_angle + Angle(0, 90)):Forward()
		local vector = -ship.direction.direction.x * forward + Vector(0, 0, ship.direction.direction.z)
		local angle = ship.direction.angle

		local efficiency = fight_calculate_efficiency(ship.id)
		local max_height = calculate_height(ship.id)

		ship.velocity:Add(vector * 2 * efficiency)
		local damping = ship.velocity * 0.01
		ship.velocity:Add(-damping)

		--ship.angle_velocity.x = ship.direction.direction.x * (ship.speed / 50)
		--ship.angle_velocity.x = ship.angle_velocity.x - ship.local_angle.x / 2
		ship.angle_velocity = ship.angle_velocity + (angle / 4 * efficiency)
		local angle_damping = ship.angle_velocity * 0.01
		ship.angle_velocity = ship.angle_velocity - angle_damping

		if ship.position.z > max_height then
			ship.velocity.z = -200
		end

		ship.angles:Add(ship.angle_velocity * FrameTime())
		ship.position:Add(ship.velocity * FrameTime())
		--ship.angles = local_rotation_to_global(ship.local_angle)
	end
end)


hook.Add("aw_player_exit_control", "Reset ship velocity", function(player, controller)
	if !IsValid(controller) or controller:GetClass() != "aw_ship_controller" then return end
	local player_ship = world_ships[player:GetCurrentShip()]
	if !player_ship then return end
	player_ship.direction.direction = Vector()
	player_ship.direction.angle = Angle()
end)
