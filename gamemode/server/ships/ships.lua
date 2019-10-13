if !world_ships then
	world_ships = {}
end

--[[
Description:
	Adds part to ship.
Arguments:
	part - table
]]
local function add_part(self, part)
	table.insert( self.parts, part.id, part)
end

--[[
Description:
	Sync basic information about ship
]]

local function sync(self)
	net.Start("aw_sync_ship")
	net.WriteTable({
		health = self.health,
		id = self.id,
		position = self.position,
		angles = self.angles,
		center = self.center,
		parts = {}
	})
	net.Broadcast()
end

local function sync_to_player(self, player)
	net.Start("aw_sync_ship")
	net.WriteTable({
		health = self.health,
		id = self.id,
		position = self.position,
		angles = self.angles,
		center = self.center,
		crew_positions = get_crew(self),
		parts = {}
	})
	net.Send(player)
end

--[[
Description:
	Sync ship's position
]]

local function sync_position(self)
	net.Start("aw_sync_ship_position", true)
	net.WriteTable({
		id = self.id,
		position = {self.position.x, self.position.y, self.position.z},
		angles = self.angles
	})
	net.Broadcast()
end

--[[
Description:
	Finds maximal and minimal points in ship
]]
function find_max_min(self)
	local max = Vector(-9999, -9999, -9999)
	local min = Vector(9999, 9999, 9999)

	for _, part in pairs(self.parts) do
		if max.x < part.position.x then
			max.x = part.position.x
		end
		if max.y < part.position.y then
			max.y = part.position.y
		end
		if max.z < part.position.z then
			max.z = part.position.z
		end

		if min.x > part.position.x then
			min.x = part.position.x
		end
		if min.y > part.position.y then
			min.y = part.position.y
		end
		if min.z > part.position.z then
			min.z = part.position.z
		end
	end
	return max, min
end

--[[
Description:
	Finds ship center
]]

local function find_center(self)
	local max, min = find_max_min(self)
	return (max + min) / 2
end

--[[
Description:
	Updates ship center
]]
local function update_center(self)
	self.center = find_center(self)
end

local function update_max_min(self)
	local max, min = find_max_min(self)
	self.max = max
	self.min = min
end

function AirWars:DestroyShip(self)
	for k, v in pairs(ents.FindByClass("aw*")) do
		if v:AWIsInTeam(self.id) and !v:IsWeapon() then
			v:Remove()
		end
	end
	net.Start("aw_destroy_ship")
	net.WriteInt(self.id, 32)
	net.Broadcast()
	world_ships[self.id] = nil
end

--[[
Description:
	Creates new ship and adds it to the world
Arguments:
	id - The id of a new ship(Should be equal to team id)
]]
function AirWars:CreateShip(id)
	local ship = {
		health = 100,
		id = id,
		position = Vector(-83, 1248, 242),
		center = Vector(),
		max = Vector(),
		min = Vector(),
		angles = Angle(),
		direction = init_ship_controls(),
		parts = {}
	}
	ship.AddPart = add_part
	ship.Sync = sync
	ship.SyncDirection = sync_direction
	ship.UpdateCenter = update_center
	ship.UpdateMinMax = update_max_min
	ship.AssignPlayer = assign_player
	ship.SyncPosition = sync_position
	ship.SyncToPlayer = sync_to_player
	world_ships[ship.id] = ship
	hook.Run("AirWars_ShipCreated", id)
	return world_ships[ship.id]
end

net.Receive("aw_sync_parts", function(len, player)
	local ship_id = net.ReadInt(32)
	local ship = world_ships[ship_id]
	if ship == nil then
		return
	end

	local parts = {}
	for _, part in pairs(ship.parts) do
		parts[part.id] = part_table_simple(part)
	end
	local parts = util.TableToJSON(parts)
	if parts ~= nil then
		local parts = util.Compress( parts )
		local len = #parts
		if len > 63000 then
			player:ChatPrint("Oups! Something went wrong. Your ship seems to be too big and server cannot sync it ):")
			print("Ship is too big!")
		end
		net.Start("aw_sync_parts")
		net.WriteInt(len, 32)
		net.WriteData(parts, len)
		net.WriteInt(ship_id, 16)
		net.Send(player)
	end
end)
