concommand.Add( "set_time", function( ply, cmd, args )
	AirWars:SetTimeLeft(util.StringToType( args[1], "int" ))
end )
