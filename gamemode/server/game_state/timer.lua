timer_next_update_time = CurTime()

function AirWars:SetTimeLeft(amount)
	game_state.time_left = amount
	AirWars:BroadcastGameState()
end

hook.Add("Think", "Update timer", function()
	if game_state.state == GAME_STATE_PAUSE then return end

	if CurTime() > timer_next_update_time then
		game_state.time_left = math.Clamp(game_state.time_left - 1, 0, math.huge)
		timer_next_update_time = CurTime() + 1
		if game_state.time_left <= 0 then
			game_state.time_left = global_config.build_time
			if game_state.state == GAME_STATE_BUILDING then
				if table.Count(aw_teams_list) > 1 or aw_developer then
					game_state.time_left = global_config.fight_time
					game_state.state = GAME_STATE_FIGHT
					AirWars:SpawnShips()
				else
					for k, v in pairs(player.GetAll()) do
						v:ChatPrint("Not enough teams to start the round")
					end
				end
			else
				game_state.time_left = global_config.build_time
				game_state.state = GAME_STATE_BUILDING
				AirWars:ResetRound()
			end
			AirWars:BroadcastGameState()
		end
	end
end)
