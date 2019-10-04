DIRECTION_FRONT = 1
DIRECTION_BACK  = 2
DIRECTION_RIGHT = 3
DIRECTION_LEFT  = 4
DIRECTION_UP    = 5
DIRECTION_DOWN  = 6

DISTANCE_FUNCTIONS = {
	[DIRECTION_FRONT] = function( min, max ) return math.abs(max.x - min.x) end,
	[DIRECTION_BACK]  = function( min, max ) return math.abs(max.x - min.x) end,
	[DIRECTION_RIGHT] = function( min, max ) return math.abs(max.y - min.y) end,
	[DIRECTION_LEFT]  = function( min, max ) return math.abs(max.y - min.y) end,
	[DIRECTION_UP]    = function( min, max ) return math.abs(max.z - min.z) end,
	[DIRECTION_DOWN]  = function( min, max ) return math.abs(max.z - min.z) end,
}

DIRECTION_FUNCTIONS = {
	[DIRECTION_FRONT] = function( angle ) return  angle:Forward() end,
	[DIRECTION_BACK]  = function( angle ) return -angle:Forward() end,
	[DIRECTION_RIGHT] = function( angle ) return  angle:Right()   end,
	[DIRECTION_LEFT]  = function( angle ) return -angle:Right()   end,
	[DIRECTION_UP]    = function( angle ) return  angle:Up()      end,
	[DIRECTION_DOWN]  = function( angle ) return -angle:Up()      end,
}

function tool_create_convar(tool, name, default)
	CreateClientConVar( tool .. "_" .. name, default, true, true )
end
