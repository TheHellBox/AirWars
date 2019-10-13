if !clientside_models then
	clientside_models = {}
end
if !aw_parts_ents then
	aw_parts_ents = {}
end

function try_load_model(model)
	print(model)
	clientside_models[model] = ClientsideModel(model)
	clientside_models[model]:SetNoDraw(true)
end

net.Receive("aw_sync_parts", function(len)
	local msg_length = net.ReadInt(32)
	local parts = net.ReadData(msg_length)
	local ship_id = net.ReadInt(16)
	local parts = util.Decompress(parts)
	if parts == nil then return end
	local parts = util.JSONToTable(parts)
	if parts == nil then return end
	world_ships[ship_id].parts = parts
end)

net.Receive("aw_sync_part_health", function(len)
	local part_id = net.ReadInt(32)
	local ship_id = net.ReadInt(16)
	local health  = net.ReadInt(16)

	local part = world_ships[ship_id].parts[part_id]

	if world_ships[ship_id] == nil then return end
	if part == nil then return end

	local damage = part.health - health
	part.health = health

	if health <= 0 then
		hook.Run("aw_part_destroyed", world_ships[ship_id], part, damage)
		world_ships[ship_id].parts[part_id] = nil
	end
end)
