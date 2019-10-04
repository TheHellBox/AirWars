local PANEL = {}

function PANEL:Init()
	local size_x, size_y = 64, 64
	self:SetSize(size_x, size_y)
	self:SetText("")

	self.icon = self:Add("SpawnIcon")
	self.icon:Dock(FILL)
	self.icon.DoClick = function()
		self.DoClick()
	end
	self.color = Color(70, 70, 70)
	self.values = {}
	self.values_hide = false
end

function PANEL:SetModel(model)
	self.icon:SetModel(model)
end

function PANEL:Think()
	if self.icon:IsHovered() then
		if self.values_hide then
			for k, v in pairs(self.values) do
				v:Show()
				v.value:Show()
				self.values_hide = false
			end
		end
	else
		if !self.values_hide then
			for k, v in pairs(self.values) do
				v:Hide()
				v.value:Hide()
				self.values_hide = true
			end
		end
	end
end

function PANEL:AddValue(material, value)
	local icon = self:Add( "DSprite" )
	icon:SetMaterial( material )
	icon:SetPos(8, #self.values * 16 + 8)
	icon:SetSize(16, 16)

	icon.value = self:Add( "DLabel" )
	icon.value:SetPos(16, #self.values * 16)
	icon.value:SetTextColor(Color(255, 255, 255))
	icon.value:SetText(value)
	table.insert(self.values, icon)
end

function PANEL:SetColor(color)
	self.color = color
end

function PANEL:Paint(w, h)
	draw.RoundedBox(5, 0, 0, w, h, self.color)
end

vgui.Register("AWIcon", PANEL, "DButton")
