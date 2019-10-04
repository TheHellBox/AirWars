local player_meta = FindMetaTable("Player")

if !aw_team_requests then
	aw_team_requests = {}
end

if !aw_teams_list then
	aw_teams_list = {}
end

if !aw_team_flags then
	aw_team_flags = {}
end

function aw_remove_team(id)
	aw_teams_list[id] = nil
end

function aw_add_to_team(id, member)
	if !aw_teams_list[id] then return end
	table.insert(aw_teams_list[id].members, member)
end

function aw_leave_from_team(member)
	local team = aw_teams_list[member:GetAWTeam()]
	if !team then return end
	table.RemoveByValue(team.members, member)
	if #team.members < 1 then
		aw_remove_team(member:GetAWTeam())
		return
	end
	if member == team.leader then
		team.leader = team.members[1]
	end
end

function player_meta:SetAWTeam(team)
	self:SetCurrentShip(team)
	self:SetNWInt("aw_team", team)
	self.aw_team = team or -1
	AirWars:BroadcastGameState()
end

function player_meta:SetLeader()
	self:SetNWInt("aw_leader", true)
end

function player_meta:CreateAWTeam(team)
	aw_leave_from_team(self)
	self:SetAWTeam(team)
	aw_teams_list[team] = {
		name = self:Name(),
		members = {self},
		leader = self,
		id = self:GetAWTeam()
	}
	AirWars:BroadcastGameState()
end

function player_meta:JoinAWTeam(team)
	aw_leave_from_team(self)
	self:SetAWTeam(team)
	aw_add_to_team(team, self)
	AirWars:BroadcastGameState()
end

-- Lua strings are 8-bit clean. So non-english characters can use more than 1 byte, which can cause incorrect result with such functions as Left
local function str_left(str, len)
	local chars = string.ToTable(str)
	local result = ""
	local k = 0
	for v in string.gmatch(str, ".[\128-\191]*") do
		if k > len then
			break
		end
		result = result..v
		k = k + 1
	end
	return result
end

net.Receive("aw_send_team_request", function(len, applicant_player)
	local id = net.ReadInt(32)
	if game_state.state == GAME_STATE_FIGHT then return end
	local team = aw_teams_list[id]
	if !team then return end

	local leader = team.leader
	local index = table.insert(aw_team_requests, {leader, applicant_player})
	net.Start("aw_team_request")
	net.WriteEntity(applicant_player)
	net.WriteInt(index, 8)
	net.Send(leader)
end)

net.Receive("aw_change_team_name", function(len, player)
	local name = net.ReadString()
	if game_state.state == GAME_STATE_FIGHT then return end
	if !player:IsLeader() then return end
	aw_teams_list[player:GetAWTeam()].name = str_left(name, 15)
	AirWars:BroadcastGameState()
end)

net.Receive("aw_team_kick_player", function(len, player)
	local target = net.ReadEntity()
	if game_state.state == GAME_STATE_FIGHT then return end
	if !player:IsLeader() and target != player then return end
	target:CreateAWTeam(AirWars:GenerateTeamId(), str_left(target:Name(), 15))
	AirWars:BroadcastGameState()
end)

net.Receive("aw_update_flag", function(len, player)
	local data = {}
	local len = net.ReadInt(32)
	for k=0, len do
		table.insert(data, net.ReadInt(5))
	end
	aw_team_flags[player:GetCurrentShip()] = data
	AirWars:SyncFlag(player:GetCurrentShip())
end)

net.Receive("aw_accept_team_request", function(len, ply)
	local request_id = net.ReadInt(8)
	if game_state.state == GAME_STATE_FIGHT then return end
	local request = table.remove(aw_team_requests, request_id)
	if request == nil then return end
	local leader = request[1]
	local target = request[2]
	if leader ~= ply then return end
	if !IsValid(target) then return end
	target:JoinAWTeam(leader:GetAWTeam())
end)

hook.Add("PlayerInitialSpawn", "Sync Flags", function(player)
	timer.Simple(3, function()
		for id, team in pairs(aw_teams_list) do
			AirWars:PlayerSyncFlag(id, player)
		end
	end)
end)
