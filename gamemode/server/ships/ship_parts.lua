-- Do I really need tables to make it look more like oop? idk
Part = {}

--[[
Description:
	basic information about part
]]
function part_table_simple(self)
	return {
		model = self.model,
		position = self.position,
		angle = self.angle,
		id = self.id,
		health = self.health,
		ship_id = self.ship_id,
		info = self.info,
	}
end

--[[
Description:
	Removes part from the ship
Arguments:
	part - table
]]

local function destroy_part(part)
	world_ships[part.ship_id].parts[part.id] = nil
	for k, v in pairs(ents.FindByClass("aw*")) do
		if v.part_id == part.id then
			v:Remove()
		end
	end
	world_ships[part.ship_id]:UpdateMinMax()
end

--[[
Description:
	Adds health to part. Destroys it if health is < 0
Arguments:
	amount - int. amount of health to add(can be negative)
]]

local function add_health(self, amount)
	self.health = self.health + amount
	net.Start("aw_sync_part_health")
	net.WriteInt(self.id, 32)
	net.WriteInt(self.ship_id, 16)
	net.WriteInt(self.health, 16)
	net.Broadcast()

	if self.health <= 0 then
		destroy_part(self)
	end
end

function Part:new(ship_id)
	local part = {
		health = 100,
		collisions = {},
		position = Vector(),
		angle = Angle(),
		model = "models/props_phx/construct/metal_plate1.mdl",
		info = {},
		-- Somehow math.huge doesn't work with math.Rand :thinking:
		id = math.floor(math.Rand(1, 99999)),
		ship_id = ship_id
	}

	-- We are OOP boys, aren't we? Actualy OOP in lua is quite shitty.
	-- Here we add function fields to table we just created
	part.AddHealth = add_health
	part.CheckHit = check_hit

	return part
end
