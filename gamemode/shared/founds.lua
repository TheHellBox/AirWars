function build_calculate_ship_cost(team_id)
	local cost = 0
	for k, v in pairs(ents.FindByClass("aw_building_prop")) do
		if !v.info then continue end
		if v:GetAWTeam() != team_id then continue end
		cost = cost + v.info.cost
	end
	return cost
end

function build_calculate_ship_weight(team_id)
	local weight = 0
	for k, v in pairs(ents.FindByClass("aw_building_prop")) do
		if !v.info then continue end
		if v:GetAWTeam() != team_id then continue end
		weight = weight + v.info.weight
	end
	if CLIENT then
		weight = weight + #get_team_members(LocalPlayer():GetAWTeam()) * 40
	end
	return weight
end

function build_calculate_ship_force(team_id)
	local force = 0
	for k, v in pairs(ents.FindByClass("aw_building_prop")) do
		if !v.info then continue end
		if v:GetAWTeam() != team_id then continue end
		if v.custom_info and v.custom_info.force then
			force = force + v.custom_info.force
		end
	end
	return force
end

function build_calculate_ship_lift_force(team_id)
	local force = 0
	for k, v in pairs(ents.FindByClass("aw_building_prop")) do
		if !v.info then continue end
		if v.GetAWTeam and v:GetAWTeam() != team_id then continue end
		if v.custom_info and v.custom_info.lift_force then
			force = force + v.custom_info.lift_force
		end
	end
	return force
end

function fight_calculate_ship_weight(ship)
	if ship == nil then return 0 end
	local weight = 1
	for k, v in pairs(ship.parts) do
		if !v.info then continue end
		weight = weight + v.info.weight
	end
	weight = weight + #get_crew(ship) * 40
	return weight
end

function fight_calculate_efficiency(ship)
	if ship == nil then return 0 end
	local efficiency = calculate_ship_force(ship) / calculate_ship_weight(ship)
	if efficiency > 3.0 then
		efficiency = 3
	end
	return efficiency
end

function fight_calculate_ship_force(ship)
	local force = 1
	if ship == nil then return 0 end
	for k, part in pairs(ship.parts) do
		if part.custom_info and part.custom_info.force then
			force = force + (part.custom_info.force or 0)
		end
	end
	return force
end

function fight_calculate_ship_lift_force(ship)
	if ship == nil then return 0 end
	local force = 1
	for k, part in pairs(ship.parts) do
		if part.custom_info and part.custom_info.lift_force then
			force = force + (part.custom_info.lift_force or 0)
		end
	end
	return force
end


function calculate_ship_weight(ship)
	if ship == nil then return 0 end
	if game_state.state == GAME_STATE_FIGHT then
		return fight_calculate_ship_weight(world_ships[ship])
	else
		return build_calculate_ship_weight(ship)
	end
end

function calculate_ship_force(ship)
	if ship == nil then return 0 end
	if game_state.state == GAME_STATE_FIGHT then
		return fight_calculate_ship_force(world_ships[ship])
	else
		return build_calculate_ship_force(ship)
	end
end

function calculate_ship_lift_force(ship)
	if ship == nil then return 0 end
	if game_state.state == GAME_STATE_FIGHT then
		return fight_calculate_ship_lift_force(world_ships[ship])
	else
		return build_calculate_ship_lift_force(ship)
	end
end

function calculate_height(ship)
	if ship == nil then return 0 end
	local height = -calculate_ship_weight(ship) + calculate_ship_lift_force(ship)
	return math.Clamp(height, 0, 1100) * 10
end

function can_afford(ship, amount)
	if ship == nil then return 0 end
	local cost = build_calculate_ship_cost(ship)
	return (cost + amount) <= global_config.max_founds
end
