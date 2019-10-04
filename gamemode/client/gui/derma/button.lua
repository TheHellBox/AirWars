local PANEL = {}

function PANEL:Init()
	self:SetTall(30)

	self:SetText("Join")
	self:SetFont("Trebuchet18")
	self.color = Color(90, 90, 90)
end

function PANEL:SetColor(color)
	self.color = color
end

vgui.Register("AWButton", PANEL, "DButton")
