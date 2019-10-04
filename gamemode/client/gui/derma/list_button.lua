local PANEL = {}

function PANEL:Init()
	self:SetTall(32)

	self.button = self:Add("DButton")
	self.button:SetText("Join")
	self.button:SetTextColor(Color(255, 255, 255))
	self.button:SetFont("Trebuchet18")
	self.button:Dock(RIGHT)
	self.button.DoClick = function()
		self.DoClick()
	end

	function self.button:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90))
	end

	self.label = self:Add("DLabel")
	self.label:SetText("")
	self.label:SetFont("aw_hud_small")
	self.label:SetTextColor(Color(0, 0, 0))
	self.label:DockMargin( 5, 0, 0, 0 )
	self.label:Dock(FILL)
end

function PANEL:DoClick()

end

vgui.Register("AWListButton", PANEL, "DPanel")
