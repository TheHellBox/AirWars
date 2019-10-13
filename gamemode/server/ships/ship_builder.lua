function AirWars:BuildShipProps(ship)
	for _, part in pairs(ship.parts) do
		local ent = ents.Create(part.entity or "aw_part")
		ent:SetPos(part.position + global_config.world_center - ship.center)
		ent:SetModel(part.model)
		ent:SetAngles(part.angle)
		ent.part_id = part.id
		ent:SetAWTeam(part.aw_team)
		ent:Spawn()
		ent:Activate()
		ent.ship_collision = true
		ent:SetPartID(ent.part_id)

		local model_bounds_max, model_bounds_min, center = ent:OBBMaxs(), ent:OBBMins(), ent:OBBCenter()

		part.collision_bounds = {model_bounds_max, model_bounds_min, center}
	end
end

local function setup_part(entity, ship)
	local base = Part:new(ship.id)
	base.position = entity:GetPos()
	base.angle = entity:GetAngles()
	base.model = entity:GetModel()
	base.aw_team = ship.id
	base.ship_id = ship.id
	base.entity = entity.entity
	base.custom_info = entity.custom_info
	base.info = entity.info
	base.health = entity.info.health
	ship:AddPart(base)
end

local function create_ships()
	for _, player in pairs(player.GetAll()) do
		local ship = world_ships[player:GetAWTeam()]
		if !ship then
			AirWars:CreateShip(player:GetAWTeam())
		end
	end
end

function AirWars:SpawnPlayers()
	for k, v in pairs(player.GetAll()) do
		v.prop_buffer = {}
		v.lives = 3
		v:Spawn()
	end
end

function AirWars:GetRandomPosition(rad)
	local position = Vector(math.Rand(-rad, rad), math.Rand(-rad, rad), math.Rand(0, rad))
	for k, v in pairs(world_ships) do
		if v.position:Distance(position) < 2000 then
			return AirWars:GetRandomPosition(rad, ship)
		end
	end
	return position
end

function AirWars:GenShipsPosition(ship)
	local position = Vector(math.Rand(-5000, 5000), math.Rand(-5000, 5000), calculate_height(ship.id))
	for k, v in pairs(world_ships) do
		if v.position:Distance(position) < 2000 then
			return AirWars:GenShipsPosition(ship)
		end
	end
	return position
end

function AirWars:SpawnShips()
	create_ships()

	for _, ship in pairs(world_ships) do
		local blocked = find_blocked_entities(ship.id)
		for _, entity in pairs(ents.GetAll()) do
			if table.HasValue(blocked, entity) then continue end
			if entity:GetClass() == "aw_building_prop" then
				if entity:AWIsInTeam(ship.id) then
					setup_part(entity, ship)
					entity:Remove()
				end
			end
		end
		ship:UpdateCenter()
		ship:UpdateMinMax()
		AirWars:BuildShipProps(ship)
		ship.position = AirWars:GenShipsPosition(ship)
		ship:Sync()
		AirWars:TeamSyncGameState(ship.id)
	end
	AirWars:SpawnPlayers()
	AirWars:SpawnIslands()

	hook.Run("AirWars_ShipsSpawned")
end
