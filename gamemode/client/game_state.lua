if !game_state then
	game_state = {
		time_left = 999,
		state = 0,
		team_name = "",
		teams = {}
	}
end

net.Receive("aw_sync_game_state", function()
	game_state = net.ReadTable()
end)

net.Receive("aw_round_reset", function()
	world_ships = {}
end)

net.Receive("aw_player_sync_data", function()
	local data = net.ReadTable()
	LocalPlayer().player_data = data
end)

function game_state_get_time_left()
	return game_state.time_left or 0
end

function game_state_get_state()
	return game_state.state or 1
end
