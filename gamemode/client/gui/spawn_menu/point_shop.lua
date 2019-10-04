function open_point_shop(sheet, frame)
	if !frame.point_shop then
		frame.point_shop = sheet:Add("DPanel")
		frame.point_shop:Dock(FILL)
		frame.point_shop:SetBackgroundColor(Color(0, 0, 0, 0))
	else
		frame.point_shop.player:UpdateModel()
		return frame.point_shop
	end
	frame.point_shop.icons = {}

	frame.point_shop.player = frame.point_shop:Add( "AWPlayerModel" )
	frame.point_shop.player:SetModel( LocalPlayer():GetModel() )
	frame.point_shop.player:SetWide(200)
	frame.point_shop.player:Dock(RIGHT)

	frame.point_shop.points = frame.point_shop.player:Add( "DLabel" )
	frame.point_shop.points:SetText( "Points: "..LocalPlayer():GetPoints() )
	frame.point_shop.points:Dock(TOP)
	frame.point_shop.points:SetFont("aw_hud_small")
	frame.point_shop.points:DockMargin(5, 5, 5, 5)
	frame.point_shop.points:SetTextColor(Color(255, 255, 255))
	function frame.point_shop.points:UpdateLabel()
		self:SetText( "Points: "..LocalPlayer():GetPoints() )
	end

	local list = frame.point_shop:Add("DCategoryList")
	list:Dock(FILL)

	local cost_material = Material("materials/icon16/coins.png")

	for category_id, category in pairs(point_shop_config.categories) do
		local category_panel = list:Add(category.name)

		local layout = frame.point_shop:Add("DTileLayout")
		layout:SetBaseSize(64)
		layout:SetSpaceX(4)
		layout:SetSpaceY(4)
		layout:Dock(FILL)

		category_panel:SetContents(layout)

		for item_id, v in pairs(category.props) do
			local icon = layout:Add("AWIcon")
			icon:SetModel(v.model)
			icon.DoClick = function()
				net.Start("aw_pointshop_wear")
				net.WriteInt(category_id, 8)
				net.WriteInt(item_id, 8)
				net.SendToServer()
			end
			icon:AddValue(cost_material, v.cost)
			icon.icon:RebuildSpawnIcon()
			icon.category = category_id
			icon.id = item_id
			table.insert(frame.point_shop.icons, icon)
		end
	end

	return frame.point_shop
end
