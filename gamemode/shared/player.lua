local meta = FindMetaTable("Player")

function meta:IsInControl()
	return IsValid(self:GetNWEntity("aw_entity_under_control"))
end

function meta:SetSpectator(is_spectator)
	self:SetNWBool("aw_spectator", is_spectator)
end

function meta:IsSpectator()
	return self:GetNWBool("aw_spectator", false)
end

function PLAYER:SetupDataTables()
	self.Player:NetworkVar( "Int", 0, "AWTeam" )
	self.Player:NetworkVar( "Int", 1, "CurrentShip" )
end
