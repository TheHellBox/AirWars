include("game_state.lua")
include("teams.lua")
include("timer.lua")


hook.Add("Think", "Check Winners", function()
	if aw_developer then return end
	if game_state.state != GAME_STATE_FIGHT then return end
	local winners = {}
	for k, v in pairs(player.GetAll()) do
		if v:IsSpectator() then continue end
		winners[v:GetAWTeam()] = winners[v:GetAWTeam()] or {}
		table.insert(winners[v:GetAWTeam()], v)
	end
	if table.Count(winners) <= 1 then
		AirWars:ResetRound()
		for _, ply in pairs(player.GetAll()) do
			ply:AddPoints(2)
			ply:ChatPrint("You got 2 points for playing")
		end
		for _, team in pairs(winners) do
			for _, ply in pairs(player.GetAll()) do
				ply:ChatPrint("Winners:")
			end
			for _, winner in pairs(team) do
				for _, ply in pairs(player.GetAll()) do
					ply:ChatPrint("	"..winner:Name())
				end
				winner:AddPoints(10)
				winner:ChatPrint("You got 10 points for winning this round")
			end
		end
		hook.Run("AirWars_RoundEnd", winners)
	end
end)
