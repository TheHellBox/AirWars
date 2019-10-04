function init_options_menu(frame)
	local panel = frame:Add("DPanel")
	panel:Dock(FILL)

	function panel:Paint(w, h)
		draw.RoundedBox(5, 0, 0, w, h, Color(100, 100, 100))
	end

	local enable_effects = panel:Add( "DCheckBoxLabel" )
	enable_effects:SetText( "Enable Effects" )
	enable_effects:SetConVar("aw_enable_effects")
	enable_effects:Dock(TOP)
	return panel
end
