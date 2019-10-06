function GM:PlayerCanHearPlayersVoice(listener, talker)
	if GAME_STATE_FIGHT then
		local listener_ship = world_ships[listener:GetCurrentShip()]
		local talker_ship = world_ships[talker:GetCurrentShip()]
		if listener_ship and talker_ship then
			local distance = 1000
			local ent = talker:GetEntityUnderControl()
			if IsValid(ent) and ent:GetClass() == "aw_speaker" then
				distance = distance * 6
			end
			if listener_ship.position:Distance(talker_ship.position) < distance then
				return true
			end
		end
	end
	if listener:GetCurrentShip() == talker:GetCurrentShip() then
		return true
	else
		return false
	end
end
