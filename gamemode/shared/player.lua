local meta = FindMetaTable("Player")

function meta:IsInControl()
	return IsValid(self:GetNWEntity("aw_entity_under_control"))
end

function meta:GetCurrentShip()
	if CLIENT then
		return self:GetNWInt("aw_current_ship", -1)
	end
	return self.aw_current_ship or -1
end

function meta:SetCurrentShip(ship)
	if SERVER then
		self:SetNWInt("aw_current_ship", ship)
	end
	self.aw_current_ship = ship
end

function meta:SetSpectator(is_spectator)
	self:SetNWBool("aw_spectator", is_spectator)
end

function meta:IsSpectator()
	return self:GetNWBool("aw_spectator", false)
end
