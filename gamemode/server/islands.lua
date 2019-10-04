function AirWars:SpawnIslands()
	for k=0, 20 do
		local island = AirWars:CreateShip(math.floor(math.Rand(1001, 2000)))
		island.position = AirWars:GetRandomPosition(16000)

		local island_id = math.floor(math.Rand(1, 4))

		local island_part = Part:new(island.id)
		island_part.model = "models/aw_islands/island0"..island_id.."/island_0"..island_id..".mdl"
		island_part.info = {
			cost = 0,
			weight = 10000,
			health = 10000
		}
		island_part.collision_bounds = {Vector(1541, 1580, 319), Vector(-1449, -1695, -942), Vector(45, -57, -311)}
		island_part.health = 10000
		island_part.angle = Angle()
		island_part.aw_team = island.id

		island:AddPart(island_part)
		island:Sync()
		island.disable_position_sync = true
		island.velocity = Vector()

		AirWars:BuildShipProps(island)
	end
end
