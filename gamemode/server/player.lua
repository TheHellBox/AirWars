local meta = FindMetaTable("Player")

function meta:AddToPropBuffer(entity)
	if self.prop_buffer then
		table.insert(self.prop_buffer, entity)
	else
		self.prop_buffer = {entity}
	end
end

function meta:ExitControl()
	local entity_under_control = self:GetEntityUnderControl()
	if IsValid(entity_under_control) then
		entity_under_control:SetController(Entity(-1))
	end
	self:SetNWEntity("aw_entity_under_control", Entity( -1 ) )
	hook.Run("aw_player_exit_control", self, entity_under_control)
end

function meta:AWControl(entity)
	if self:IsInControl() then
		self:ExitControl()
	end
	self:SetNWEntity("aw_entity_under_control", entity)
end

function meta:GetEntityUnderControl()
	return self:GetNWEntity("aw_entity_under_control", Entity( -1 ))
end

function meta:AWGiveAmmo(ammo)
	if ammo == nil then ammo = true end
	self.aw_ammo = ammo
end

function meta:AWHasAmmo()
	return self.aw_ammo
end

local function check_player_ship_collisions()
	local players = player.GetAll()
	for _, ship in pairs(world_ships) do
		local view = Matrix()
		view:Translate(global_config.world_center)
		view:Rotate(-ship.angles)
		view:Translate(-ship.position)

		for key, player in pairs(players) do
			if ship.id == player:GetCurrentShip() then continue end
			if player:IsSpectator() then continue end

			local players_ship = world_ships[player:GetCurrentShip()]
			if players_ship == nil then continue end
			if player:IsSpectator() then continue end
			if players_ship.position:Distance(ship.position) > 2000 then
				continue
			end

			local player_matrix = Matrix()
			player_matrix:Translate(players_ship.position)
			player_matrix:Rotate(players_ship.angles)

			player_matrix:Translate((player:EyePos() - global_config.world_center))
			player_matrix:Rotate(player:EyeAngles())

			local player_matrix = view * player_matrix

			local tr = util.TraceLine( {
				start = player_matrix:GetTranslation(),
				endpos = player_matrix:GetTranslation() - Vector(0, 0, 40),
				filter = function( entity )
					if entity:GetAWTeam() == ship.id then
						return true
					end
				end,
				ignoreworld = true
			} )

			if IsValid(tr.Entity) then
				if tr.Entity.part_id and tr.HitNormal.z > 0 then
					player:SetCurrentShip(tr.Entity:GetAWTeam())
					local pos = LocalToWorld(Vector(20, 0, 0), Angle(), tr.HitPos, tr.HitNormal:Angle())
					player:SetPos(pos)
					player:SetEyeAngles(Angle(0, player_matrix:GetAngles().y, 0))
					player:SetVelocity(-player:GetVelocity())
					--player:SetVelocity(velocity)
					player:ExitControl()
				end
			end
		end
	end
end

hook.Add("Think", "Players Check Collisions", function()
	check_player_ship_collisions()
end)

hook.Add("Think", "Kill after fall", function()
	for k, player in pairs(player.GetAll()) do
		if player:GetPos():WithinAABox( Vector(-1519, -1519, -1023), Vector(1519, 1519, -1025) ) and game_state.state == GAME_STATE_FIGHT then
			if player:Alive() then
				player:Kill()
			end
		end
	end
end)

hook.Add("Think", "Check Bounds", function()
	if game_state.state == GAME_STATE_FIGHT then return end
	for k, player in pairs(player.GetAll()) do
		if !player:GetPos():WithinAABox( global_config.build_bounds.min, global_config.build_bounds.max ) then
			player:SetPos(global_config.build_bounds.player_spawn)
		end
	end
end)

hook.Add("PlayerDeath", "Remove Corpse", function(victim, _, _)
	victim:GetRagdollEntity():Remove()
end)

hook.Add("PostPlayerDeath", "Respawn Player", function(victim, _, _)
	victim:ExitControl()
	timer.Simple(3, function()
		if !victim:Alive() then
			victim:Spawn()
		end
	end)
end)
