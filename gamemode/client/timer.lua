timer_next_update_time = CurTime()

hook.Add("Think", "Update timer", function()
	if game_state_get_state() == GAME_STATE_PAUSE then return end

	if CurTime() > timer_next_update_time then
		game_state.time_left = math.Clamp(game_state.time_left - 1, 0, math.huge)
		timer_next_update_time = CurTime() + 1
	end
end)
