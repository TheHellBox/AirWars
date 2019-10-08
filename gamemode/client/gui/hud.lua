local tips_offset = 10

local gear_icon = Material("aw_icons/gear.png")

local states = {}
states[GAME_STATE_PAUSE] = "PAUSE"
states[GAME_STATE_FIGHT] = "FIGHT!"
states[GAME_STATE_BUILDING] = "BUILD"

function GM:HUDDrawTargetID()

end

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if name == "CHudHealth" or name == "CHudBattery" then return false end
end )

local function draw_key(x, y, key, text, hide, length)
	if hide then return end
	local length = length or 50

	draw.RoundedBox( 5, x - 5, y - 5, length + 10, 50 + 10, Color(150, 150, 150) )
	draw.RoundedBox( 5, x, y, length, 50, Color(255, 255, 255) )
	draw.SimpleText(key, "DermaLarge", x + length / 2, y + 25, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleTextOutlined(text, "DermaLarge", x + length + 10, y + 25, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1)
	tips_offset = tips_offset + 70
end

hook.Add( "HUDPaint", "Draw HUD", function()
	if LocalPlayer():IsSpectator() then return end
	local padding_x, padding_y = 10, ScrH() - 50

	-- Text
	surface.SetFont( "aw_hud_main" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( padding_x, padding_y - 200)
	surface.DrawText( states[game_state_get_state()] )

	surface.SetTextPos( padding_x + 80, padding_y - 150)
	surface.DrawText( string.ToMinutesSeconds( game_state_get_time_left() ) )

	surface.SetTextPos( padding_x, padding_y - 100)
	surface.DrawText( LocalPlayer():GetAWTeamName() )

	surface.SetFont( "aw_hud_ultra_light" )

	draw.SimpleText( "Cost", "aw_hud_ultra_light",        padding_x + 30, padding_y - 30, Color(255, 255, 255), TEXT_ALIGN_CENTER )
	draw.SimpleText( "Weight", "aw_hud_ultra_light",      padding_x + 95, padding_y - 30, Color(255, 255, 255), TEXT_ALIGN_CENTER )
	draw.SimpleText( "Force", "aw_hud_ultra_light",       padding_x + 165, padding_y - 30, Color(255, 255, 255), TEXT_ALIGN_CENTER )
	draw.SimpleText( "Max.Height", "aw_hud_ultra_light", padding_x + 255, padding_y - 30, Color(255, 255, 255), TEXT_ALIGN_CENTER )

	local cost = build_calculate_ship_cost(LocalPlayer():GetCurrentShip())
	local weight = calculate_ship_weight(LocalPlayer():GetCurrentShip())
	local force = calculate_ship_force(LocalPlayer():GetCurrentShip())
	local height = calculate_height(LocalPlayer():GetCurrentShip()) / 50

	draw.SimpleText( cost, "aw_hud_small", padding_x + 30, padding_y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawLine(padding_x, padding_y + 12, padding_x + 60, padding_y + 12)
	draw.SimpleText( global_config.max_founds, "aw_hud_ultra_light", padding_x + 30, padding_y + 15, Color(255, 255, 255), TEXT_ALIGN_CENTER )

	draw.SimpleText( weight, "aw_hud_small", padding_x + 95, padding_y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER )
	draw.SimpleText( force, "aw_hud_small", padding_x + 165, padding_y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER )
	draw.SimpleText( height, "aw_hud_small", padding_x + 255, padding_y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER )

	-- Icons
	surface.SetDrawColor(Color(255, 255, 255))
	surface.SetMaterial( gear_icon )
	surface.DrawTexturedRect( padding_x, padding_y - 170, 70, 70 )

	-- Bars
	local health = LocalPlayer():Health() / LocalPlayer():GetMaxHealth()
	draw.RoundedBox( 4, padding_x, padding_y - 60, 304, 24, Color(102, 32, 20) )
	draw.RoundedBox( 4, padding_x + 2, padding_y - 58, 300 * health, 20, Color(204, 65, 37) )

	if height < 5 then
		if game_state_get_state() != GAME_STATE_FIGHT then
			draw.SimpleTextOutlined( "Your height is too low. Place more balloons", "aw_hud_main", padding_x, padding_y - 230, Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1)
		end
	end
end )
 
hook.Add( "HUDPaint", "Draw Controls", function()
	if !LocalPlayer():IsInControl() then return end
	local entity_under_control = LocalPlayer():GetNWEntity("aw_entity_under_control")
	if entity_under_control:GetClass() != "aw_ship_controller" then return end
	draw_key(10, tips_offset,  "W",  "Forward", false)
	draw_key(10, tips_offset,  "A",  "Turn Left", false)
	draw_key(10, tips_offset,  "S",  "Back", false)
	draw_key(10, tips_offset,  "D",  "Turn Right", false)
	draw_key(10, tips_offset,  "_",  "Go Up", false, 100)
	draw_key(10, tips_offset,  "Shift",  "Go Down", false, 100)

	local height = 0
	tips_offset = 10
	if world_ships[LocalPlayer():GetCurrentShip()] then
		height = world_ships[LocalPlayer():GetCurrentShip()].position.z
	end

	draw.SimpleTextOutlined("Height: "..math.Round(height / 50), "DermaLarge", 10, ScrH() - 300, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
end )

hook.Add( "HUDPaint", "Draw Exit", function()
	if !LocalPlayer():IsInControl() then return end
	tips_offset = 10
	draw_key(10, tips_offset,  "R",  "Exit", false)
end )

hook.Add( "HUDPaint", "HightlightUse", function()
	if LocalPlayer():IsInControl() then return end
	local trace = {}
	trace.start = LocalPlayer():GetShootPos()
	trace.endpos = trace.start + (LocalPlayer():GetAimVector() * 128)
	trace.filter = function(ent)
		if ent.GetAWTeam and ent:GetAWTeam() == LocalPlayer():GetCurrentShip() then
			return ent != LocalPlayer()
		end
		return false
	end
	trace = util.TraceLine(trace)
	if IsValid(trace.Entity) and trace.Entity.Useable then
		draw_key(ScrW() / 2 - 25, ScrH() / 2 - 25,  "E",  trace.Entity.CustomText or "Use", false)
	end
end )
