local function play_effect(position, angle, bullet, weapon, ship)
	net.Start("aw_play_weapon_effect", false)
	net.WriteInt(weapon.custom_info.effect_type, 8)
	net.WriteInt(weapon.custom_info.speed, 16)
	net.WriteInt(bullet.id, 16)
	net.WriteVector(bullet.position)
	net.WriteAngle(angle)
	net.WriteVector(ship.velocity)
	net.Broadcast()
end

-- NOTE: Weapon is just a part
function AirWars:ShipShoot(ship, weapon, offset, angle)
	local end_pos = Vector()
	local angle = angle or Angle()
	local offset = offset or 0

	local angle = weapon.angle + angle
	local position = weapon.position - angle:Forward() * offset

	local bullet_position, bullet_angle = calculate_bullet_start(ship, position, angle)
	local bullet = add_bullet(
		bullet_position,
		bullet_angle,
		weapon,
		ship.velocity
	)
	play_effect(bullet_position, bullet_angle, bullet, weapon, ship)
end

hook.Add("PlayerButtonDown", "AW Try Shoot", function(player, button)
	if button != MOUSE_LEFT then return end
	player.shooting = true
	for k, v in pairs(ents.FindByClass("aw_weapon*")) do
		if v:GetController() == player then
			v:Shoot(player)
		end
	end
end)

hook.Add("PlayerButtonUp", "AW Exit Weapon", function(player, button)
	if button == MOUSE_LEFT then
		player.shooting = false
	end
	if button != KEY_R then return end
	player:ExitControl()
end)

hook.Add("Think", "Shoot", function(ply, button)
	for k, v in pairs(ents.FindByClass("aw_weapon*")) do
		for k, player in pairs(player.GetAll()) do
			if player.shooting and v:GetController() == player then
				v:Shoot(player)
			end
		end
	end
end)
