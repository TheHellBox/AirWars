local skybox_material = Material("aw_materials/skybox/skybox_01.png", "smooth")
local water_material = Material("aw_materials/water.png", "smooth noclamp")

local function IsInWorld( pos )
	local tr = { collisiongroup = COLLISION_GROUP_WORLD }
	tr.start = pos
	tr.endpos = pos
	return util.TraceLine( tr ).HitWorld
end

local function draw_limit_sphere( )
	if game_state_get_state() != GAME_STATE_FIGHT then return end
	local local_ship = world_ships[LocalPlayer():GetCurrentShip()]
	local position, angles = Vector(), Angle()
	if local_ship != nil then
			position = -local_ship.position - EyePos()
			angles = -local_ship.angles
	end
	if LocalPlayer():IsSpectator() then
			position = aw_spectator_camera.position
			angles = aw_spectator_camera.angles
	end

	local view = Matrix()
	view:Rotate(angles)
	view:Translate(position)

	local radius = 32000 * (game_state_get_time_left() / global_config.fight_time)
	local distance = position:Distance(Vector())
	if distance > radius * 0.8 then
		local opacity = (distance - radius * 0.8) / (radius * 0.2)
		render.SetColorMaterial()
		cam.PushModelMatrix(view)
			render.CullMode( 1 )
			render.DrawSphere( Vector(), radius, 80, 80, Color( 255, 100, 100, opacity * 255 * 0.1) )
			render.CullMode( 0 )
			render.DrawWireframeSphere( Vector(), radius, 80, 80, Color( 255, 255, 255, opacity * 255) )
		cam.PopModelMatrix()
	end
end

hook.Add("PreDrawOpaqueRenderables", "AW Draw Skybox", function()
	-- Do not draw the skybox if player is flying outside the map
	--if IsInWorld(EyePos()) then return end
	local view = Matrix()
	view:Translate(EyePos())

	local local_ship = world_ships[LocalPlayer():GetCurrentShip()]
	local ship_position = Vector(0, 0, 1000)
	local ship_angles = Angle()

	if local_ship then
		view:Rotate(-local_ship.angles)
		ship_position = local_ship.position
		ship_angles = local_ship.angles
	end

	if LocalPlayer():IsSpectator() then
		ship_position = -aw_spectator_camera.position
	end

	render.CullMode( 1 )
	render.SetMaterial(skybox_material)
	cam.PushModelMatrix(view)
		render.DrawSphere( Vector(), 20000, 50, 50, Color( 255, 255, 255, 255 ) )
	cam.PopModelMatrix()
	render.CullMode( 0 )

	draw_limit_sphere()

	view:Translate(Vector(0, 0, ship_position.z))
	view:Translate(-(LocalPlayer():GetPos() - global_config.world_center))

	local matrix = Matrix()
	matrix:Translate(global_config.world_center)
	matrix:Rotate(view:GetAngles())
	matrix:Translate(-Vector(0, 0, ship_position.z))

	local x, y = ship_position.x / 20000 % 1, -ship_position.y / 20000 % 1
	local time = (CurTime() / 1000)

	surface.SetDrawColor( Color(255, 255, 255, 60) )
	surface.SetMaterial(water_material)

	cam.Start3D2D( matrix:GetTranslation(), view:GetAngles(), 100 )
		surface.DrawTexturedRectUV( -1000, -1000, 2000, 2000, x, y, x + 10, y + 10 )
	cam.End3D2D()

	cam.Start3D2D( matrix:GetTranslation() + Vector(0, 0, 10), view:GetAngles(), 100 )
		surface.SetDrawColor(Color(255, 255, 255, 30))
		surface.DrawTexturedRectUV( -1000, -1000, 2000, 2000, x * 10 + time * 10, y * 10 + time * 10, x + 100 + time * 10, y + 100 + time * 10)
	cam.End3D2D()

	cam.Start3D2D( matrix:GetTranslation() + Vector(0, 0, 20), view:GetAngles(), 100 )
		surface.SetDrawColor(Color(255, 255, 255, 30))
		surface.DrawTexturedRectUV( -1000, -1000, 2000, 2000, x - time, y - time, x + 10 - time, y + 10 - time)
	cam.End3D2D()
end)
