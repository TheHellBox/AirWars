function get_crew(ship)
	local result = {}
	for k, v in pairs(player.GetAll()) do
		if v:IsSpectator() then continue end
		if ship.id == v:GetCurrentShip() then
			table.insert(result, v)
		end
	end
	return result
end

function get_team_crew(ship)
	local result = {}
	for k, v in pairs(player.GetAll()) do
		if ship.id == v:GetAWTeam() then
			table.insert(result, v)
		end
	end
	return result
end
