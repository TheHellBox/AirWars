global_config = {}

CATEGORY_PROPS = 1
CATEGORY_SPECIALS = 2
CATEGORY_WEAPONS = 3
CATEGORY_FLAGS = 4

local function generate_prop_info(weight, health, cost)
	return {
		weight = weight,
		health = health,
		cost = cost
	}
end

global_config.build_time = 420
global_config.fight_time = 900
global_config.max_founds = 12000
global_config.prop_limit = 100
global_config.world_center = Vector(0, 0, 0)
global_config.position_sync_rate = 0.1
global_config.disable_crew_sync = fals

global_config.build_bounds = {
	max = Vector(1264, -2355, 1168),
	min = Vector(-1190, -4763, -163),
	player_spawn = Vector(3, -3583, 453)
}

global_config.categories = {}
global_config.categories[CATEGORY_PROPS] = {}
global_config.categories[CATEGORY_PROPS].name = "Props"
global_config.categories[CATEGORY_PROPS].props = {
	// Metal
	{
		model = "models/props_phx/construct/metal_plate1.mdl",
		info = {
			weight = 10,
			health = 30,
			cost = 50
		},
	},
	{
		model = "models/props_phx/construct/metal_plate1x2.mdl",
		info = {
			weight = 20,
			health = 60,
			cost = 100
		},
	},
	{
		model = "models/props_phx/construct/metal_plate2x2.mdl",
		info = {
			weight = 40,
			health = 120,
			cost = 200
		},
	},

	// Glass
	{
		model = "models/props_phx/construct/windows/window1x1.mdl",
		info = {
			weight = 10,
			health = 20,
			cost = 60
		},
	},
	{
		model = "models/props_phx/construct/windows/window1x2.mdl",
		info = {
			weight = 20,
			health = 40,
			cost = 120
		},
	},
	{
		model = "models/props_phx/construct/windows/window2x2.mdl",
		info = {
			weight = 40,
			health = 80,
			cost = 240
		},
	},

	// Plastic
	{
		model = "models/hunter/plates/plate1x1.mdl",
		info = {
			weight = 7,
			health = 20,
			cost = 30
		},
	},
	{
		model = "models/hunter/plates/plate1x2.mdl",
		info = {
			weight = 14,
			health = 40,
			cost = 60
		},
	},
	{
		model = "models/hunter/plates/plate2x2.mdl",
		info = {
			weight = 28,
			health = 80,
			cost = 120
		},
	},

	// Wood
	{
		model = "models/props_phx/construct/wood/wood_panel1x1.mdl",
		info = {
			weight = 4,
			health = 10,
			cost = 15
		},
	},
	{
		model = "models/props_phx/construct/wood/wood_panel1x2.mdl",
		info = {
			weight = 8,
			health = 20,
			cost = 30
		},
	},
	{
		model = "models/props_phx/construct/wood/wood_panel2x2.mdl",
		info = {
			weight = 16,
			health = 40,
			cost = 60
		},
	},

	// Decorations
	{
		model = "models/props_interiors/vendingmachinesoda01a_door.mdl",
		info = {
			weight = 25,
			health = 65,
			cost = 105
		},
	},
	{
		model = "models/props_c17/furnitureradiator001a.mdl",
		info = {
			weight = 15,
			health = 45,
			cost = 75
		},
	},
	{
		model = "models/props_doors/door03_slotted_left.mdl",
		info = {
			weight = 20,
			health = 45,
			cost = 80
		},
	},
	{
		model = "models/props_interiors/bathtub01a.mdl",
		info = {
			weight = 80,
			health = 240,
			cost = 400
		},
	},
	{
		model = "models/props_trainstation/benchoutdoor01a.mdl",
		info = {
			weight = 5,
			health = 15,
			cost = 25
		},
	},
	{
		model = "models/maxofs2d/companion_doll.mdl",
		info = {
			weight = 10,
			health = 1,
			cost = 50
		},
	},
	{
		model = "models/props_lab/blastdoor001b.mdl",
		info = {
			weight = 40,
			health = 120,
			cost = 200
		},
	},

	// Boxes
	{
		model = "models/props_junk/wood_crate001a.mdl",
		info = {
			weight = 14,
			health = 50,
			cost = 60
		},
	},
	{
		model = "models/props_junk/wood_crate002a.mdl",
		info = {
			weight = 28,
			health = 80,
			cost = 120
		},
	},
	{
		model = "models/props_junk/TrashDumpster01a.mdl",
		info = {
			weight = 130,
			health = 290,
			cost = 600
		},
	},
	{
		model = "models/props_c17/furnitureStove001a.mdl",
		info = {
			weight = 130,
			health = 290,
			cost = 600
		},
	},
	{
		model = "models/props_interiors/VendingMachineSoda01a.mdl",
		info = {
			weight = 110,
			health = 270,
			cost = 550
		},
	},
	{
		model = "models/props_c17/shelfunit01a.mdl",
		info = {
			weight = 30,
			health = 90,
			cost = 130
		},
	},
	{
		model = "models/props_trainstation/traincar_seats001.mdl",
		info = {
			weight = 90,
			health = 90,
			cost = 100
		},
	},
}

global_config.categories[CATEGORY_SPECIALS] = {}
global_config.categories[CATEGORY_SPECIALS].name = "Specials"
global_config.categories[CATEGORY_SPECIALS].props = {
	// Specials
	{
		name = "Steering Wheel",
		model = "models/aw_steering_wheel/aw_steering_wheel.mdl",
		entity = "aw_ship_controller",
		info = {
			weight = 20,
			health = 100,
			cost = 200
		},
	},
	{
		name = "Sail",
		model = "models/aw_sail/aw_sail.mdl",
		info = {
			weight = 20,
			health = 110,
			cost = 400
		},
		entity = "aw_sail",
		custom_info = {
			force = 300,
			intersection_radius = 50
		},
	},
	{
		name = "Small Balloon",
		model = "models/aw_balloon_small/aw_balloon_small.mdl",
		entity = "aw_engine",
		info = {
			weight = 20,
			health = 150,
			cost = 300
		},
		custom_info = {
			lift_force = 200,
			intersection_radius = 50
		},
	},
	{
		name = "Balloon",
		model = "models/aw_balloon_big/aw_balloon_big.mdl",
		entity = "aw_engine",
		info = {
			weight = 50,
			health = 300,
			cost = 600
		},
		custom_info = {
			lift_force = 400,
			intersection_radius = 50
		},
	},
	{
		name = "Player Spawn",
		model = "models/aw_player_spawn/aw_player_spawn.mdl",
		entity = "aw_player_spawn",
		info = {
			weight = 20,
			health = 100,
			cost = 50
		},
	},
	{
		name = "Ammunition Storage",
		model = "models/aw_ammunition_crate/aw_ammunition_crate.mdl",
		entity = "aw_ammunition_storage",
		info = {
			weight = 20,
			health = 100,
			cost = 300
		},
	},
}
global_config.categories[CATEGORY_WEAPONS] = {}
global_config.categories[CATEGORY_WEAPONS].name = "Weapons"
global_config.categories[CATEGORY_WEAPONS].props = {
	// Weapons
	{
		name = "Cannon",
		model = "models/aw_cannon/aw_cannon_full.mdl",
		entity = "aw_weapon_cannon",
		info = {
			weight = 50,
			health = 100,
			cost = 500
		},
		custom_info = {
			damage = 60,
			speed = 2000,
			gravity = 3,
			splash_radius = 70,
			effect_type = EFFECT_TYPE_CANNON
		},
		category = CATEGORY_WEAPONS
	},
	{
		name = "Rifle",
		model = "models/aw_rifle/aw_rifle_full.mdl",
		entity = "aw_weapon_rifle",
		info = {
			weight = 20,
			health = 50,
			cost = 500
		},
		custom_info = {
			damage = 3,
			speed = 3000,
			gravity = 1,
			splash_radius = 10,
			effect_type = EFFECT_TYPE_RIFLE
		},
		category = CATEGORY_WEAPONS
	},
	{
		name = "Bomb",
		model = "models/aw_bomb/aw_bomb.mdl",
		entity = "aw_weapon_bomb",
		info = {
			weight = 20,
			health = 10,
			cost = 400
		},
		custom_info = {
			damage = 100,
			speed = 0,
			gravity = 4,
			splash_radius = 200,
			effect_type = EFFECT_TYPE_BOMB
		},
		category = CATEGORY_WEAPONS
	},
}

global_config.categories[CATEGORY_FLAGS] = {}
global_config.categories[CATEGORY_FLAGS].name = "Flags"
global_config.categories[CATEGORY_FLAGS].props = {
	{
		model = "models/aw_flag/aw_flag.mdl",
		entity = "aw_flag",
		info = {
			weight = 10,
			health = 30,
			cost = 50
		},
	},
	{
		model = "models/aw_flag/aw_flag_b.mdl",
		entity = "aw_flag",
		info = {
			weight = 50,
			health = 100,
			cost = 150
		},
	},
}
