local PANEL = {}

function PANEL:Init()
	self:SetDraggable(false)
	self:SetTitle("")

	self.color = Color(50, 50, 50)
end

function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0, 0, w, h, self.color)
end

vgui.Register("AWSMFrame", PANEL, "DFrame")
