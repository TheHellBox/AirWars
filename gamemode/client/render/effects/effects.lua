projectiles = {}

net.Receive("aw_play_weapon_effect", function()
	local effect_type = net.ReadInt(8)
	local speed = net.ReadInt(16)
	local id = net.ReadInt(16)
	local bullet_position = net.ReadVector()
	local angle = net.ReadAngle()
	local velocity = net.ReadVector()

	local sound_position = calculate_position_raw(bullet_position, angle)

	local projectile = {
		model = "models/weapons/w_bullet.mdl",
		position = bullet_position,
		angle = angle or Angle(),
		speed = speed,
		velocity = velocity,
		fall_speed = Vector(0, 0, 0),
		life_time = CurTime() + 6,
		gravity = 1,
		id = id
	}
	if effect_type == EFFECT_TYPE_CANNON then

		util.ScreenShake( Vector( 0, 0, 0 ), 400 / (LocalPlayer():GetPos() - sound_position):Length(), 3, 1, 8000 )
		sound.Play( "ambient/explosions/explode_9.wav", sound_position, 120 )
		add_particle(bullet_position, "particles/smokey", 20, 60, 1, 3, 20, angle:Forward(), 0.5, 100)
		add_particle(bullet_position, "particles/flamelet4", 5, 30, 1, 2, 40, angle:Forward(), 0.5)
		projectile.gravity = 3
		projectile.model = "models/props_phx/misc/smallcannonball.mdl"
		table.insert(projectiles, projectile)

	elseif effect_type == EFFECT_TYPE_RIFLE then

		util.ScreenShake( Vector( 0, 0, 0 ), 20 / (LocalPlayer():GetPos() - sound_position):Length(), 3, 1, 8000 )
		sound.Play( "weapons/ar2/fire1.wav", sound_position, 120 )
		table.insert(projectiles, projectile)
		--add_particle(bullet_position, "particles/smokey", 20, 20, 1, 3, 20, angle, 0.5)
		add_particle(bullet_position, "particles/flamelet4", 10, 5, 0, 0.4, 100, angle:Forward(), 0.1)
		add_particle(bullet_position, "particles/smokey", 10, 20, 0, 1, 10, angle:Forward(), 0.3, 60)

	elseif effect_type == EFFECT_TYPE_BOMB then
		projectile.gravity = 2
		projectile.model = "models/aw_bomb/aw_bomb_bullet.mdl"
		table.insert(projectiles, projectile)

	end
end)

net.Receive("aw_bullet_hit", function()
	local id = net.ReadInt(16)
	local effect_type = net.ReadInt(8)
	local raw_position = net.ReadVector()
	for key, bullet in pairs(projectiles) do
		if bullet.id == id then
			table.remove(projectiles, key)
			local position = calculate_position_raw(raw_position)
			if effect_type == EFFECT_TYPE_CANNON then
				util.ScreenShake( Vector( 0, 0, 0 ), 300 / (LocalPlayer():GetPos() - position):Length(), 3, 1, 8000 )
				sound.Play( "FX_RicochetSound.Ricochet", position )
				add_particle(raw_position, "particles/smokey", 20, 120, 1, 3, 20, Vector(), 0.5, 100)
				add_particle(raw_position, "particles/flamelet4", 5, 60, 1, 2, 40, Vector(), 0.5)
			end
			if effect_type == EFFECT_TYPE_RIFLE then
				util.ScreenShake( Vector( 0, 0, 0 ), 100 / (LocalPlayer():GetPos() - position):Length(), 3, 1, 8000 )
				sound.Play( "FX_RicochetSound.Ricochet", position )
				add_particle(raw_position, "particles/flamelet4", 10, 5, 0, 0.4, 100, Vector(), 0.1)
				add_particle(raw_position, "particles/smokey", 10, 20, 0, 1, 10, Vector(), 0.3, 60)
			end
			if effect_type == EFFECT_TYPE_BOMB then
				util.ScreenShake( Vector( 0, 0, 0 ), 500 / (LocalPlayer():GetPos() - position):Length(), 3, 1, 8000 )
				sound.Play( "ambient/explosions/explode_2.wav", position, 120 )
				add_particle(raw_position, "particles/smokey", 40, 220, 1, 3, 20, Vector(), 2, 100)
				add_particle(raw_position, "particles/flamelet4", 10, 120, 1, 2, 40, Vector(), 2)
			end
		end
	end
end)

net.Receive("aw_weapon_effect", function()
	local hit_pos = net.ReadVector()
	local normal = net.ReadVector()
	local surface_props = net.ReadInt(32)
	local hitbox = net.ReadInt(32)
	local entity = net.ReadEntity()
	if !IsValid(entity) then return end
	if entity:GetAWTeam() != LocalPlayer():GetCurrentShip() then return end
	local effectdata = EffectData()
	effectdata:SetOrigin( hit_pos )
	effectdata:SetNormal( normal )
	effectdata:SetSurfaceProp( surface_props )
	effectdata:SetHitBox( hitbox )
	effectdata:SetEntity( entity )

	util.Effect( "Impact", effectdata)
end)

net.Receive("aw_effect", function()
	local effect_type = net.ReadInt(8)
	if effect_type == EFFECT_TYPE_CRASH then

	end
end)

hook.Add("Tick", "Move Projectiles", function()
	local tick_time = engine.TickInterval()
	for key, projectile in pairs(projectiles) do
		projectile.fall_speed:Add(Vector(0, 0, projectile.gravity) * tick_time)
		projectile.position:Add(-(projectile.angle:Forward() * projectile.speed) * tick_time)
		projectile.position:Add(-projectile.fall_speed)
		projectile.position:Add(projectile.velocity * tick_time)
		if CurTime() > (projectile.life_time or 0) then
			table.remove(projectiles, key)
		end
	end
end)

hook.Add("aw_part_destroyed", "Spawn Particles", function(ship, part, damage)
	local position = calculate_part_position(ship, part.position, part.angle)
	add_particle(position, "particles/smokey", 15, damage * 10, 1, 3, 5, Vector(), 2, 90)
	local sound_position = calculate_position_raw(position)
	if damage > 20 then
		sound.Play( "ambient/explosions/explode_2.wav", position, 120, math.Rand(50, 150) )
	end
end)
