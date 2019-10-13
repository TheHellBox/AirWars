local hooked_ships = {}

hook.Add("Think", "Grappling Hook Update", function()
	for k, v in pairs(hooked_ships) do
		if v[3] < CurTime() then
			table.remove(hooked_ships, k)
		end
		local a, b = world_ships[v[1]], world_ships[v[2]]
		if !a or !b then continue end

		local mass_a = calculate_ship_weight(a.id)
		local mass_b = calculate_ship_weight(b.id)

		local mass_sum = (mass_a + mass_b)
		local mass_dif_a = (mass_a - mass_b)
		local mass_dif_b = (mass_b - mass_a)

		local dist = a.position:Distance(b.position) / 2
		a.velocity = a.velocity + (mass_dif_a / mass_sum) * (a.position - b.position):GetNormalized() * dist * FrameTime()
		b.velocity = b.velocity + (mass_dif_b / mass_sum) * (a.position - b.position):GetNormalized() * dist * FrameTime()
	end
end)

hook.Add("AirWars_BulletHit", "Grappling Hook Hit", function(entity, bullet, ship)
	if bullet.effect_type == EFFECT_TYPE_HOOK then
		if bullet.ship == ship then return end
		table.insert(hooked_ships, {bullet.ship, ship.id, CurTime() + 10})
		bullet.weapon_ent.hit = true
		timer.Simple(10, function()
			if !IsValid(bullet.weapon_ent) then return end
			bullet.weapon_ent:SetHookState(0)
		end)
	end
end)
