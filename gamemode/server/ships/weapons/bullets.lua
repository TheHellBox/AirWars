aw_bullets = {}

function calculate_bullet_start(ship, position, angle)
	local view = Matrix()
	view:Translate(ship.position)
	view:Rotate(ship.angles)

	local matrix = Matrix()
	matrix:Translate(position - ship.center)
	matrix:Rotate(angle)

	matrix = view * matrix

	return matrix:GetTranslation(), matrix:GetAngles()
end

function add_bullet(position, direction, weapon, velocity)
	local speed = weapon.custom_info.speed
	local damage = weapon.custom_info.damage
	local gravity = weapon.custom_info.gravity
	local ignore = {weapon.id}
	local effect_type = weapon.custom_info.effect_type
	local splash_radius = weapon.custom_info.splash_radius

	local bullet = {
		position = position,
		direction = direction,
		speed = speed,
		damage = damage,
		ignore = ignore,
		gravity = gravity,
		velocity = velocity,
		fall_speed = Vector(),
		life_time = CurTime() + 6,
		effect_type = effect_type,
		splash_radius = splash_radius,
		id = math.Rand(1, 1000)
	}
	table.insert(aw_bullets, bullet)
	return bullet
end

local function find_close_parts(position, ship, radius)
	local list = {}
	for _, part in pairs(ship.parts) do
		local distance = part.position:Distance(position)
		if distance < radius then
			table.insert(list, part)
		end
	end
	return list
end

local function send_hit(bullet)
	net.Start("aw_bullet_hit")
	net.WriteInt(bullet.id, 16)
	net.WriteInt(bullet.effect_type, 8)
	net.WriteVector(bullet.position)
	net.Broadcast()
end

local function check_bullets_collision()
	for _, ship in pairs(world_ships) do
		local view = Matrix()
		view:Translate(global_config.world_center)
		view:Rotate(-ship.angles)
		view:Translate(-ship.position)

		for key, bullet in pairs(aw_bullets) do
			if ship.position:Distance(bullet.position) > ship.max:Length() / 2 then continue end
			local bullet_matrix = Matrix()
			bullet_matrix:Translate(bullet.position)
			bullet_matrix:Rotate(bullet.direction)
			bullet_matrix = view * bullet_matrix
			local tr = util.TraceLine( {
				start = bullet_matrix:GetTranslation(),
				endpos = bullet_matrix:GetTranslation() - bullet_matrix:GetAngles():Forward() * 200,
				filter = function( entity )
					if table.HasValue(bullet.ignore, entity.part_id) then return false end
					if entity:GetAWTeam() == ship.id or (entity:IsPlayer() and entity:GetCurrentShip() == ship.id)then
						return true
					end
				end,
				ignoreworld = true
			} )

			if IsValid(tr.Entity) then
				if tr.Entity.part_id then
					local hit_part = ship.parts[tr.Entity.part_id]
					if hit_part ~= nil then
						for _, part in pairs(find_close_parts(hit_part.position, ship, bullet.splash_radius)) do
							local distance = hit_part.position:Distance(part.position)
							part:AddHealth(-bullet.damage * ((bullet.splash_radius - distance) / bullet.splash_radius))
						end
						send_hit(bullet)
					end
				end
				if tr.Entity:IsPlayer() then
					tr.Entity:TakeDamage(bullet.damage * 3, game.GetWorld(), game.GetWorld())
				end
				table.remove(aw_bullets, key)
			end
		end
	end
end

hook.Add("Think", "Move Bullets", function()
	for key, bullet in pairs(aw_bullets) do
		bullet.fall_speed:Add(Vector(0, 0, bullet.gravity) * FrameTime())
		local forward = (bullet.direction:Forward() * bullet.speed + bullet.velocity) * FrameTime()
		bullet.position:Add(-forward)
		bullet.position:Add(-bullet.fall_speed)
		if CurTime() > bullet.life_time then
			table.remove(aw_bullets, key)
		end
	end
end)

hook.Add("Think", "Check bullets collisions", check_bullets_collision)
