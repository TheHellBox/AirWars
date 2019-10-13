local trace_material = Material("cable/smoke")
local hook_material = Material("cable/cable2")

function aw_draw_particles(view)
	for key, particle in pairs(aw_particles) do
		local position = particle.position
		local matrix = particle.matrix or Matrix()
		matrix:Translate(particle.position)
		matrix:Rotate(particle.angle)
		matrix = view * matrix
		if aw_check_in_view(matrix:GetTranslation()) then continue end
		local opacity = 1 - ((CurTime() - particle.start_time) / (particle.life_time - particle.start_time))
		local color = Color(255, 255, 255, particle.opacity * opacity)
		render.SetMaterial(aw_particle_materials[particle.texture])
		cam.PushModelMatrix(matrix)
			render.DrawQuadEasy( Vector(), Vector(1), particle.size, particle.size, color )
			render.DrawQuadEasy( Vector(), Vector(-1), particle.size, particle.size, color )
		cam.PopModelMatrix()
	end
end

function draw_projectile(projectile, view)
	render.SetColorMaterial()
	local matrix = Matrix()
	matrix:Translate(projectile.position)
	matrix:Rotate(projectile.angle + Angle(0, 90))

	matrix = view * matrix

	local model = clientside_models[projectile.model]
	if model ~= nil then
		model:EnableMatrix("RenderMultiply", matrix)
		model:SetupBones()
		model:DrawModel()
	else
		try_load_model(projectile.model)
	end
	render.SetColorModulation( 1, 1, 1 )
end

function draw_hook(projectile, view)
	local ship = world_ships[projectile.ship_id]
	if !ship then return end
	local part = ship.parts[projectile.weapon]
	if !part then return end

	local start = calculate_part_position(ship, part.position, part.angle)
	local start_mat = Matrix()
	start_mat:Translate(start)
	start_mat = view * start_mat

	local end_mat = Matrix()
	end_mat:Translate(projectile.position)
	end_mat = view * end_mat

	render.SetMaterial(hook_material)
	render.DrawBeam(start_mat:GetTranslation(), end_mat:GetTranslation(), 3, 0, 1, Color(255, 255, 255))
end

function draw_trace(projectile, view)
	if projectile.is_hook then
		draw_hook(projectile, view)
		return
	end
	if CurTime() > (projectile.tr_update_time or 0) then
		projectile.prev_positions = projectile.prev_positions or {}
		local new_vec = Vector()
		new_vec:Set(projectile.position)
		table.insert(projectile.prev_positions, new_vec)
		projectile.tr_update_time = CurTime() + 0.001
		if #projectile.prev_positions > 30 then
			table.remove(projectile.prev_positions, 1)
		end
	end

	local prev_matrix = nil
	for k, position in ipairs(projectile.prev_positions) do
		local matrix = Matrix()
		matrix:Translate(position)
		matrix = view * matrix
		if prev_matrix == nil then
			prev_matrix = matrix
		end
		render.SetMaterial(trace_material)
		render.DrawBeam(prev_matrix:GetTranslation(), matrix:GetTranslation(), k / 2, 0, 1, Color(255, 255, 255, k * 10))
		prev_matrix = matrix
	end
end

function aw_draw_effects(view, view_raw)
	for key, projectile in pairs(projectiles) do
		draw_trace(projectile, view)
		draw_projectile(projectile, view)
	end
end
