if !game_state then
	game_state = {
		time_left = global_config.build_time,
		state = GAME_STATE_BUILDING
	}
end

local function gen_state_table()
	local state = {
		time_left = game_state.time_left,
		state = game_state.state,
		teams = aw_teams_list
	}
	return state
end

function AirWars:PlayerSyncGameState(player)
	local state = gen_state_table()
	net.Start("aw_sync_game_state")
	net.WriteTable(state)
	net.Send(player)
end

function AirWars:SyncFlag(team)
	local state = gen_state_table()
	net.Start("aw_sync_flag")
	net.WriteInt(team, 16)
	net.WriteInt(#(aw_team_flags[team] or {}), 32)
	for k, v in pairs(aw_team_flags[team] or {}) do
		net.WriteInt(v, 5)
	end
	net.Broadcast()
end

function AirWars:PlayerSyncFlag(team, player)
	local state = gen_state_table()
	net.Start("aw_sync_flag")
	net.WriteInt(team, 16)
	net.WriteInt(#(aw_team_flags[team] or {}), 32)
	for k, v in pairs(aw_team_flags[team] or {}) do
		net.WriteInt(v, 5)
	end
	net.Send(player)
end

function AirWars:BroadcastGameState()
	local state = gen_state_table()
	net.Start("aw_sync_game_state")
	net.WriteTable(state)
	net.Broadcast()
end

function AirWars:TeamSyncGameState(team)
	local state = gen_state_table(team)
	local players = {}
	for k, v in pairs(player.GetAll()) do
		if v:GetAWTeam() != team then continue end
		table.insert(players, v)
	end
	net.Start("aw_sync_game_state")
	net.WriteTable(state)
	net.Send(players)
end

function AirWars:ResetRound()
	for _, ship in pairs(world_ships) do
		AirWars:TeamSyncGameState(ship.id)
		for _, entity in pairs(ents.FindByClass("aw*")) do
			if entity.AWIsInTeam == nil then return end
			if entity:AWIsInTeam(ship.id) then
				entity:Remove()
			end
		end
	end
	world_ships = {}
	game_state.state = GAME_STATE_BUILDING
	game_state.time_left = global_config.build_time

	AirWars:BroadcastGameState()

	net.Start("aw_round_reset")
	net.Broadcast()

	AirWars:SpawnPlayers()
end
