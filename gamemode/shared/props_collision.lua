hook.Add("ShouldCollide", "disable_prop_collisions", function(entity_a, entity_b )
	if entity_a:IsPlayer() && entity_b:IsPlayer() then
		return false
	end
	if !entity_a:IsPlayer() && !entity_b:IsPlayer() then
		return false
	end
	if !(entity_b.GetAWTeam && entity_a.GetAWTeam) then return end

	if GAME_STATE_FIGHT then
		if entity_a:IsPlayer() && entity_b:GetAWTeam() then
			return entity_a:GetCurrentShip() == entity_b:GetAWTeam()
		end
		if entity_a:GetAWTeam() && entity_b:IsPlayer() then
			return entity_b:GetCurrentShip() == entity_a:GetAWTeam()
		end
	end
	if entity_a:GetAWTeam() && entity_b:IsPlayer() then
		return entity_b:AWIsInTeam(entity_a:GetAWTeam())
	end
	if entity_b:GetAWTeam() && entity_a:IsPlayer() then
		return entity_a:AWIsInTeam(entity_b:GetAWTeam())
	end
end)

hook.Add("ShouldCollide", "disable_player_collision", function(entity_a, entity_b )
	if entity_a:IsPlayer() && entity_b:IsPlayer() then
		return false
	end
end)
