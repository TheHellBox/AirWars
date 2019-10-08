hook.Add("ShouldCollide", "disable_prop_collisions", function(entity_a, entity_b )
	if entity_a.stuck or entity_b.stuck then
		return false
	end
	if entity_a:IsPlayer() and entity_a:IsSpectator() then
		return false
	elseif entity_b:IsPlayer() and entity_b:IsSpectator() then
		return false
	end
	if entity_a:IsPlayer() && entity_b:IsPlayer() then
		return false
	end
	if !(entity_b.GetAWTeam && entity_a.GetAWTeam) then return end
	if entity_a:IsPlayer() && entity_b:GetAWTeam() then
		return entity_a:GetCurrentShip() == entity_b:GetAWTeam()
	elseif entity_a:GetAWTeam() && entity_b:IsPlayer() then
		return entity_b:GetCurrentShip() == entity_a:GetAWTeam()
	end
end)
