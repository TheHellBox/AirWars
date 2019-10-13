local function draw(view, prop, ship, player)
	render.SetColorMaterial()
	local matrix = Matrix()
	matrix:Translate(ship.position)
	matrix:Rotate(ship.angles)

	matrix:Translate(prop.position - ship.center)
	matrix:Rotate(prop.angle)
	matrix = view * matrix

	local pos = matrix:GetTranslation()
	local local_ship = world_ships[LocalPlayer():GetCurrentShip()]
	if aw_check_in_view(pos) and local_ship and LocalPlayer():GetPos():Distance(pos) > 4000 then
		return
	end

	if ship.id == LocalPlayer():GetCurrentShip() then
		matrix = Matrix()
		matrix:Translate(prop.position - ship.center)
		matrix:Rotate(prop.angle)
	end

	local model = clientside_models[prop.model]
	if model ~= nil then
		if prop.sequence then
			model:SetCycle(CurTime() % 1)
			model:SetSequence(prop.sequence)
		end
		model:EnableMatrix("RenderMultiply", matrix)
		model:SetupBones()
		if player then
			draw_hats(player, model)
		end
		if prop.health && prop.info then
			render.SetColorModulation( 1, prop.health / prop.info.health, prop.health / prop.info.health )
		end
		if table.HasValue(model:GetMaterials(), "models/aw_model_materials/aw_flag_a") then
			model:SetSubMaterial( 2, "!AWFlagMaterial" )
			aw_render_flag_texture(aw_flag_mat, ship.id)
		end
		model:DrawModel()
	else
		try_load_model(prop.model)
	end
	render.SetColorModulation( 1, 1, 1 )
end

function aw_draw_props(view)
	for ship_id, ship in pairs(world_ships) do
		for id, prop in pairs(ship.parts) do
			draw(view, prop, ship)
			for k, subpart in pairs(prop.subparts or {}) do
				local subpart_renderer = {
					model = subpart.model,
					position = prop.position + subpart.offset,
					angle = subpart.angle
				}
				draw(view, subpart_renderer, ship)
			end
		end
		for id, crew_member in pairs(get_crew(ship)) do
			if !IsValid(crew_member) or crew_member:GetCurrentShip() == LocalPlayer():GetCurrentShip() or crew_member:IsSpectator() then continue end
			local prop = {
				model = crew_member:GetModel(),
				position = crew_member:GetPos() + ship.center - global_config.world_center,
				angle = Angle(0, crew_member:EyeAngles().y),
				sequence = crew_member:GetSequenceName(crew_member:GetSequence())
			}
			draw(view, prop, ship, crew_member)
		end
	end
end
