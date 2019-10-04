function count_team_props(team)
	local count = 0
	for k, v in pairs(ents.FindByClass("aw_building_prop")) do
		if v:GetAWTeam() == team then
			count = count + 1
		end
	end
	return count
end

function AirWars:SpawnProp(position, angle, category, index, player, stacker)
	if game_state.state == GAME_STATE_FIGHT then return end
	local prop = global_config.categories[category].props[index]
	if !can_afford(player:GetAWTeam(), prop.info.cost) then return end
	if count_team_props(player:GetAWTeam()) > global_config.prop_limit then return end
	local ent = ents.Create("aw_building_prop")
	ent:SetModel(prop.model)
	local pos = position
	if !stacker then
		pos = pos - Vector(0, 0, ent:OBBMins().z)
	end
	ent:SetPos(pos)
	ent:SetAngles(angle)

	ent.owner = player
	ent.info = prop.info
	ent.entity = prop.entity
	ent.custom_info = prop.custom_info
	ent:SetAWTeam(player:GetAWTeam())

	ent:SetCategory(category)
	ent:SetProp(index)

	ent:Spawn()
	ent:Activate()

	AirWars:TeamSyncGameState(player:GetAWTeam())

	undo.Create( "prop" )
		undo.AddEntity( ent )
		undo.SetPlayer( player )
	undo.Finish()
	return ent
end

local function spawn_prop(player, category_index, index)
	local trace = {}
	trace.start = player:GetShootPos()
	trace.endpos = trace.start + (player:GetAimVector() * 2048)
	trace.filter = function(ent)
		if ent:GetAWTeam() == player:GetAWTeam() then
			return ent != player
		end
		return false
	end
	trace = util.TraceLine(trace)

	local position = trace.HitPos
	local ent = AirWars:SpawnProp(position, Angle(), category_index, index, player)

	player.cooldown_time = CurTime() + 1
end

net.Receive("aw_spawn_prop", function(_, player)
	local category_index = net.ReadInt(8)
	local prop_index = net.ReadInt(8)
	spawn_prop(player, category_index, prop_index)
end)
