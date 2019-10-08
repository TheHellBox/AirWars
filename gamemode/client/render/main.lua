aw_skyboxes = {
	[1] = {
		material = Material("aw_materials/skybox/skybox_01.png", "smooth"),
		brightness = 1
	},
	[2] = {
		material = Material("aw_materials/skybox/skybox_02.png", ""),
		brightness = 0.1
	}
}
game_state.skybox_id = 1

include("effects/main.lua")
include("parts_draw.lua")
include("skybox.lua")
include("clouds.lua")
include("draw_effects.lua")
include("image_render.lua")

local function calculate_view()
	if LocalPlayer():IsSpectator() then
		return aw_spectator_camera:GetView()
	end
	local local_ship = world_ships[LocalPlayer():GetCurrentShip()]
	local view = Matrix()

	if local_ship ~= nil then
		view:SetAngles(-local_ship.angles)
		view:Translate(-local_ship.position)
	end
	return view
end

function aw_check_in_view(point)
	local data = point:ToScreen()
	return !((data.x > -(ScrW() * 0.5) and data.x < ScrW() * 1.5) and (data.y > -(ScrH() * 0.5) and data.y < ScrH() * 1.5))
end

hook.Add("PostDrawOpaqueRenderables", "AW Render", function()
	if game_state_get_state() != GAME_STATE_FIGHT then return end
	local brightness = aw_skyboxes[game_state.skybox_id].brightness or 1
	render.SuppressEngineLighting( true )
	render.ResetModelLighting( brightness, brightness, brightness )
	local view = calculate_view()
	aw_draw_props(view)
	aw_draw_effects(view)
	aw_draw_particles(view)
	draw_clouds(view)
	render.SuppressEngineLighting( false )
end)
