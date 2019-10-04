local entity_meta = FindMetaTable("Entity")
local player_meta = FindMetaTable("Player")

function get_team_members(team_id)
	local result = {}
	for k, v in pairs(player.GetAll()) do
		if v:GetAWTeam() == team_id then
			table.insert(result, v)
		end
	end
	return result
end

function player_meta:GetAWTeam()
	if CLIENT then
		return self:GetNWInt("aw_team", -1)
	end
	return self.aw_team or -1
end

function entity_meta:AWIsInTeam(team)
	if !self.GetAWTeam then return 0 end
	local self_team = self:GetAWTeam()
	return self_team == team
end

function player_meta:GetAWTeamName()
	if CLIENT then
		local team = game_state.teams[self:GetAWTeam()]
		if !team then return "Error" end
		return team.name or "Error"
	end
	return aw_teams_list[self:GetAWTeam()].name or self:Name()
end

function player_meta:IsLeader()
	if CLIENT then
		local team = game_state.teams[self:GetAWTeam()]
		if !team then return "Error" end
		return team.leader == self
	end
	return aw_teams_list[self:GetAWTeam()].leader == self
end

hook.Add( "PhysgunPickup", "Crew Props Pickup", function(player, entity)
	return player:AWIsInTeam(entity:GetAWTeam()) and !entity:IsPlayer()
end)

hook.Add("PlayerFootstep", "disable_footstep_sound", function(player)
	if CLIENT then
		return player:GetAWTeam() != LocalPlayer():GetAWTeam()
	end
end)
