local txBackground = surface.GetTextureID("models/aw_model_materials/cloth_a")
local rt = GetRenderTarget( "AWFlagTexture", 512, 512 )

aw_flag_mat = CreateMaterial( "AWFlagMaterial", "UnlitGeneric", {
	["$basetexture"] = "color/white",
	["$model"] = "1"
} )

if !aw_team_flags or !flags_rts then
	flags_rts = {}
	aw_team_flags = {}
end

function draw_flag(flag, scale, res)
	local x, y = 0, 0
	for i=1, res*res do
		draw.RoundedBox( 0, x * scale, y * scale, scale, scale, aw_flag_colors[flag[i] or 0] or Color(255, 255, 255))
		x = x + 1
		if x >= res then
			x = 0
			y = y + 1
		end
	end
end

function update_rt(team)
	if !flags_rts[team] then
		flags_rts[team] = GetRenderTarget( "AWFlagTexture"..team, 512, 512 )
	end
	render.PushRenderTarget( flags_rts[team], 0, 0, 1024, 1024)
	cam.Start2D()
		draw.RoundedBox( 0, 0, 0, 1024, 1024, Color(255, 255, 255) )
		draw_flag(aw_team_flags[team] or {}, 1024 / 32, 32)
	cam.End2D()
	render.PopRenderTarget()
end

function aw_render_flag_texture(matScreen, team)
	if !flags_rts[team] then
		update_rt(team)
	end
	aw_flag_mat:SetTexture("$basetexture", flags_rts[team])
end

net.Receive("aw_sync_flag", function()
	local team = net.ReadInt(16)
	local len = net.ReadInt(32)
	local flag = {}
	for k=0, len do
		table.insert(flag, net.ReadInt(5))
	end
	aw_team_flags[team] = flag
	update_rt(team)
end)
