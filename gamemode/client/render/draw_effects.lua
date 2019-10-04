local trace_material = Material("cable/smoke")

function aw_draw_particles(view)
	for key, particle in pairs(aw_particles) do
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
	matrix:Rotate(projectile.angle)

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

function draw_trace(projectile, view)
	if CurTime() > (projectile.tr_update_time or 0) then
		projectile.prev_positions = projectile.prev_positions or {}
		local position = projectile.position
		table.insert(projectile.prev_positions, position)
		projectile.tr_update_time = CurTime() + 0.01
		if #projectile.prev_positions > 30 then
			table.remove(projectile.prev_positions, 1)
		end
	end

	local prev_position = projectile.prev_positions[1]
	for k, position in ipairs(projectile.prev_positions) do
		local matrix = Matrix()
		matrix:Translate(position)
		matrix = view * matrix

		local matrix_prev = Matrix()
		matrix_prev:Translate(prev_position)
		matrix_prev = view * matrix_prev

		render.SetMaterial(trace_material)
		render.DrawBeam(matrix_prev:GetTranslation(), matrix:GetTranslation(), k / 2, 0, 1, Color(255, 255, 255, k * 10))
		prev_position = position
	end
end

function aw_draw_effects(view, view_raw)
	for key, projectile in pairs(projectiles) do
		draw_trace(projectile, view_raw)
		draw_projectile(projectile, view)
	end
end
