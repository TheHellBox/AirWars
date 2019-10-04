local PANEL = {}

function PANEL:Init()
	self:MakePopup()
	self:SetDraggable(false)
	self:SetTitle("")

	self.color = Color(50, 50, 50)
end

vgui.Register("AWFrame", PANEL, "DFrame")
