include("effects.lua")
include("particles.lua")

function calculate_position_raw(position, angle)
	if LocalPlayer():IsSpectator() then
		local view = aw_spectator_camera:GetView()
		local matrix = Matrix()
		matrix:Translate(position)
		return (view * matrix):GetTranslation()
	end
	local ship = world_ships[LocalPlayer():GetCurrentShip()]
	if !ship then return Vector(), Angle() end
	local view = Matrix()
	view:Translate(global_config.world_center)
	view:Rotate(-ship.angles)
	view:Translate(-ship.position)

	local matrix = Matrix()
	matrix:Translate(position)
	matrix:Rotate(angle or Angle())

	matrix = view * matrix

	return matrix:GetTranslation(), matrix:GetAngles()
end

function calculate_part_position(ship, position, angle)
	local view = Matrix()
	view:Translate(ship.position)
	view:Rotate(ship.angles)

	local matrix = Matrix()
	matrix:Translate(position - ship.center)
	matrix:Rotate(angle)

	matrix = view * matrix

	return matrix:GetTranslation(), matrix:GetAngles()
end
