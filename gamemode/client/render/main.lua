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
	local view = calculate_view()
	aw_draw_props(view)
	aw_draw_effects(view)
	aw_draw_particles(view)
	draw_clouds(view)
end)
