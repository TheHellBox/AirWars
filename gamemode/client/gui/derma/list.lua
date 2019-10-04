local PANEL = {}

function PANEL:Init()

end

function PANEL:AddButton(text, button_text)
	local button = self:Add( "AWListButton" )
	button.button:SetText(button_text)
	button.label:SetText(text)
	button:Dock( TOP )
	button:DockMargin( 0, 0, 0, 5 )
	return button
end

function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0, 0, w, h, Color(200, 200, 200, 200))
end

vgui.Register("AWList", PANEL, "DScrollPanel")
