include("camera.lua")

hook.Add("Think", "Move Spectator Camera", function()
	if !LocalPlayer():IsSpectator() then return end
	local frame_time = FrameTime()
	local modifier = 4
	if input.IsKeyDown( KEY_LSHIFT ) then
		modifier = 8
	end
	if input.IsKeyDown( KEY_LCONTROL  ) then
		modifier = 1
	end
	if input.IsKeyDown( KEY_W ) then
		aw_spectator_camera:AddVector(Vector(-300, 0, 0) * frame_time * modifier)
	end
	if input.IsKeyDown( KEY_A ) then
		aw_spectator_camera:AddVector(Vector(0, 300, 0) * frame_time * modifier)
	end
	if input.IsKeyDown( KEY_S ) then
		aw_spectator_camera:AddVector(Vector(300, 0, 0) * frame_time * modifier)
	end
	if input.IsKeyDown( KEY_D ) then
		aw_spectator_camera:AddVector(Vector(0, -300, 0) * frame_time * modifier)
	end
	if input.IsKeyDown( KEY_SPACE ) then
		aw_spectator_camera:AddVectorSimple(Vector(0, 0, -300) * frame_time * modifier)
	end
end)
