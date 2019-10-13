DEFINE_BASECLASS( "player_default" )

local meta = FindMetaTable("Player")

local PLAYER = { }

function PLAYER:SetupDataTables()
	self.Player:NetworkVar( "Int", 0, "AWTeamRaw" )
	self.Player:NetworkVar( "Int", 1, "CurrentShipRaw" )
end

player_manager.RegisterClass( "player_class", PLAYER, "player_default" )

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
	hook.Run("AirWars_PlayerChangedShip", self, ship)
end

function meta:SetSpectator(is_spectator)
	self:SetNWBool("aw_spectator", is_spectator)
end

function meta:IsSpectator()
	return self:GetNWBool("aw_spectator", false)
end
