concommand.Add( "set_time", function( ply, cmd, args )
	if !ply:IsAdmin() then return end
	AirWars:SetTimeLeft(util.StringToType( args[1], "int" ))
end )
