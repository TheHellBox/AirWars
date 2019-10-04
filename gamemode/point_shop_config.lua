// WARNING: Keep hats/categories IDs the same
// You can use any random number as hat ID
// WARNING: ID can't be more than 128!

PS_CATEGORY_HATS = 1
PS_CATEGORY_GLASSES = 2

point_shop_config = {}
point_shop_config.categories = {}

point_shop_config.categories[PS_CATEGORY_HATS] = {}
point_shop_config.categories[PS_CATEGORY_HATS].name = "Hats"
point_shop_config.categories[PS_CATEGORY_HATS].props = {
	[10] = {
		name = "Hat with glasses",
		model = "models/aw_pointshop/hat_a/hat_a.mdl",
		cost = 40,
		bone = "ValveBiped.Bip01_Head1",
		offset = Vector(5, 2, 0),
		angle = Angle(0, -40, -90)
	},
	[25] = {
		name = "Steampunk Hat",
		model = "models/aw_pointshop/hat_b/hat_b.mdl",
		cost = 40,
		bone = "ValveBiped.Bip01_Head1",
		offset = Vector(4, -0.5, 0),
		angle = Angle(0, -60, -90)
	},
	[64] = {
		name = "Steampunk Hat",
		model = "models/aw_pointshop/hat_d/hat_d.mdl",
		cost = 30,
		bone = "ValveBiped.Bip01_Head1",
		offset = Vector(4, -0.5, 0),
		angle = Angle(0, -60, -90)
	},
	[32] = {
		name = "Small Hat",
		model = "models/aw_pointshop/hat_c/hat_c.mdl",
		cost = 10,
		bone = "ValveBiped.Bip01_Head1",
		offset = Vector(7.3, 3.3, -1.3),
		angle = Angle(0, -45, -105)
	},
	[112] = {
		name = "Steampunk Hat",
		model = "models/aw_pointshop/hat_e/hat_e.mdl",
		cost = 20,
		bone = "ValveBiped.Bip01_Head1",
		offset = Vector(4, -0.5, 0),
		angle = Angle(0, -60, -90)
	},
	[55] = {
		name = "Steampunk Hat",
		model = "models/aw_pointshop/hat_f/hat_f.mdl",
		cost = 50,
		bone = "ValveBiped.Bip01_Head1",
		offset = Vector(5, -0.5, 0),
		angle = Angle(0, -60, -90)
	},
}

point_shop_config.categories[PS_CATEGORY_GLASSES] = {}
point_shop_config.categories[PS_CATEGORY_GLASSES].name = "Glasses"
point_shop_config.categories[PS_CATEGORY_GLASSES].props = {
	[100] = {
		name = "Steampunk Glasses",
		model = "models/aw_pointshop/glasses_a/glasses_a.mdl",
		cost = 10,
		bone = "ValveBiped.Bip01_Head1",
		offset = Vector(2.3, 0, 0),
		angle = Angle(0, -70, -90)
	},
}

function aw_get_item_data(category, index)
	local category = point_shop_config.categories[category]
	if !category then return end
	local item = category.props[index]
	return item
end
