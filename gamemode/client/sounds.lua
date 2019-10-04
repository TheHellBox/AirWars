sound.Add( {
	name = "wind_sound",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "ambient/levels/canals/windmill_wind_loop1.wav"
} )

hook.Add("Think", "Wind Sound Update", function()
	if (game_state_get_state() != GAME_STATE_FIGHT or LocalPlayer():IsSpectator()) and aw_wind_sound then
		if aw_wind_sound:IsPlaying() then
			aw_wind_sound:Stop()
		end
		return
	end
	if !aw_wind_sound or !aw_wind_sound:IsPlaying() then
		aw_wind_sound = CreateSound( LocalPlayer(), "wind_sound" )
		aw_wind_sound:Play()
	end
	local local_ship = world_ships[LocalPlayer():GetCurrentShip()]
	if local_ship ~= nil and aw_wind_sound ~= nil then
		aw_wind_sound:ChangeVolume(math.Clamp((local_ship.speed or 0) / 5, 0.01, 1))
	end
end)

hook.Add("Think", "Sound Track Update", function()
	if (game_state_get_state() != GAME_STATE_FIGHT) and aw_soundtrack then
		if aw_soundtrack:IsPlaying() then
			aw_soundtrack:Stop()
		end
		return
	end
	local ship_count = 0
	for _, ship in pairs(world_ships) do
		if #get_crew(ship) < 1 then continue end
		ship_count = ship_count + 1
	end
	if ship_count <= 3 and game_state_get_state() == GAME_STATE_FIGHT then
		local sounds = file.Find( "sound/aw_soundtrack/fight/*", "GAME" )
		if sounds then
			if !aw_soundtrack or !aw_soundtrack:IsPlaying() then
				local sound = table.Random(sounds)
				if sound then
					aw_soundtrack = CreateSound( LocalPlayer(), "aw_soundtrack/fight/"..sound )
					aw_soundtrack:PlayEx(0, 100)
					aw_soundtrack:ChangeVolume( 1, 4 )
				end
			end
		end
	end
end)
