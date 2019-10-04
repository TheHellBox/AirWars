GM.Version = "0.1"
GM.Name = "Air Wars"
GM.Author = "The HellBox"

include("enums.lua")
include("config.lua")
include("point_shop_config.lua")
include("shared/main.lua")
include("client/main.lua")

aw_load_pointshop_models()

function GM:OnPlayerChat( player, text, team, _ )
	if team and player:GetAWTeam() != LocalPlayer():GetAWTeam() then
		return true
	end
	if team then
		chat.AddText( Color(100, 100, 255), "[TEAM] ", player:Name(), Color(250, 250, 250), ": ", text )
		return true
	end
end

function GM:OnUndo( name, customText )
	surface.PlaySound("buttons/button15.wav")
end
