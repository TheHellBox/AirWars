aw_particles = {}

aw_particle_materials = {}
aw_particle_materials["particles/smokey"] = Material("particles/smokey")
aw_particle_materials["particles/flamelet4"] = Material("particles/flamelet4")

function add_particle(position, texture, amount, size, min_time, max_time, speed, direction, r_f, opacity)
	for k=1, amount do
		table.insert(aw_particles, {
				position = position,
				texture = texture,
				size = size,
				start_time = CurTime(),
				life_time = CurTime() + math.Rand(min_time, max_time),
				direction = (Vector(math.Rand(-r_f, r_f), math.Rand(-r_f, r_f), math.Rand(-r_f, r_f)) - direction) * speed,
				angle = Angle(math.Rand(0, 360), math.Rand(0, 360), math.Rand(0, 360)),
				opacity = opacity or 255
		})
	end
end

hook.Add("Think", "Move Particles", function()
	for key, particle in pairs(aw_particles) do
		particle.position = particle.position + particle.direction * FrameTime()

		if CurTime() > particle.life_time then
			table.remove(aw_particles, key)
		end
	end
end)
