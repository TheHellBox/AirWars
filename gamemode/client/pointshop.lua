aw_pointshop_models = {}

if !aw_player_items then
	aw_player_items = {}
end

function aw_load_pointshop_models()
	print("Loading pointshop models...")
	for _, category in pairs(point_shop_config.categories) do
		for k, prop in pairs(category.props) do
			aw_pointshop_models[prop.model] = ClientsideModel(prop.model, RENDER_GROUP_OPAQUE_ENTITY)
			aw_pointshop_models[prop.model]:SetNoDraw(true)
		end
	end
end

function draw_hat(item, player)
	if player == nil then return end
	local model = aw_pointshop_models[item.model]
	local bone = item.bone
	if !bone or !model then return end
	local bone_id = player:LookupBone( bone )
	local matrix = player:GetBoneMatrix( bone_id )
	if !matrix then return end
	local position, angle = LocalToWorld( item.offset, item.angle, matrix:GetTranslation(), matrix:GetAngles() )
	model:SetPos( position )
	model:SetAngles( angle )
	model:SetupBones()
	model:DrawModel()
end

function draw_hats(player, entity)
	if player == nil then return end
	local items = aw_player_items[player:EntIndex()]
	if items == nil then return end
	for k, item in pairs(items) do
		local item = aw_get_item_data(item[1], item[2])
		if !item then continue end
		draw_hat(item, entity or player, view)
	end
end

net.Receive("aw_player_sync_wearables", function()
	local items = net.ReadTable()
	local player = net.ReadInt(32)
	aw_player_items[player] = items
end)

hook.Add( "PostPlayerDraw" , "manual_model_draw_example" , function( player )
	if player:GetCurrentShip() != LocalPlayer():GetCurrentShip() then return end
	draw_hats(player)
end)
