hook.Add("ShouldCollide", "disable_prop_collisions", function(entity_a, entity_b )
	if !entity_a.GetAWTeam or !entity_b.GetAWTeam then return end
	if !entity_a.GetAWTeamRaw or !entity_b.GetAWTeamRaw then return end

	local a_is_player = entity_a:IsPlayer()
	local b_is_player = entity_b:IsPlayer()

	if a_is_player and entity_a:IsSpectator() then
		return false
	elseif b_is_player and entity_b:IsSpectator() then
		return false
	end
	if a_is_player && b_is_player then
		return false
	end
	if a_is_player then
		return entity_a:GetCurrentShip() == entity_b:GetAWTeam()
	elseif b_is_player then
		return entity_b:GetCurrentShip() == entity_a:GetAWTeam()
	end
end)
