local meta = FindMetaTable("Player")

function meta:IsInControl()
	return IsValid(self:GetNWEntity("aw_entity_under_control"))
end

function meta:GetCurrentShip()
	if CLIENT then return self:GetCurrentShipRaw() end
	return self.current_ship
end

function meta:SetCurrentShip(ship)
	self:SetCurrentShipRaw(ship)
	self.current_ship = ship
end

function meta:SetSpectator(is_spectator)
	self:SetNWBool("aw_spectator", is_spectator)
end

function meta:IsSpectator()
	return self:GetNWBool("aw_spectator", false)
end

function PLAYER:SetupDataTables()
	self.Player:NetworkVar( "Int", 0, "AWTeamRaw" )
	self.Player:NetworkVar( "Int", 1, "CurrentShipRaw" )
end
