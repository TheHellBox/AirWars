if !world_ships then
	world_ships = {}
end

net.Receive("aw_sync_ship", function()
	local ship = net.ReadTable()
	print("Syncing ship id ", ship.id)
	world_ships[ship.id] = ship
	net.Start("aw_sync_parts")
	net.WriteInt(ship.id, 32)
	net.SendToServer()
end)

net.Receive("aw_destroy_ship", function()
	local id = net.ReadInt(32)
	if local_ship then
		sound.Play("ambient/explosions/explode_8.wav", calculate_position_raw(world_ships[id].position))
	end
	world_ships[id] = nil
end)

net.Receive("aw_sync_direction", function()
	local direction = net.ReadTable()
	local id = net.ReadInt(32)
	if world_ships[id] then
		world_ships[id].direction = direction
	end
end)

net.Receive("aw_sync_ship_position", function()
	local info = net.ReadTable()

	if world_ships[info.id] then
		world_ships[info.id].future_position = Vector(info.position[1], info.position[2], info.position[3])
		world_ships[info.id].future_angles = info.angles
	end
end)

hook.Add("Think", "lerp ship positions", function()
	for _, ship in pairs(world_ships) do
		if !ship.future_position or !ship.future_angles then continue end
		ship.speed = ship.position
		ship.position = LerpVector(FrameTime() * 5, ship.position, ship.future_position)
		ship.angles = LerpAngle(FrameTime() * 5, ship.angles, ship.future_angles)
		ship.speed = (ship.speed - ship.position):Length()
	end
end)
