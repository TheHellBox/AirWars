function open_props_menu(sheet, frame)
	frame.icons = {}
	local list = sheet:Add("DCategoryList")
	local cost_material = Material("materials/icon16/coins.png")
	local health_material = Material("materials/icon16/heart.png")
	local weight_material = Material("materials/icon16/box.png")
	for category_key, category in pairs(global_config.categories) do
		local category_panel = list:Add(category.name)
		local layout = frame:Add("DTileLayout")
		layout:SetBaseSize(64)
		layout:SetSpaceX(4)
		layout:SetSpaceY(4)
		layout:Dock(FILL)
		category_panel:SetContents(layout)

		for k, v in pairs(category.props) do
			local icon = layout:Add("AWIcon")
			icon:SetModel(v.model)
			icon.key = k
			icon.entity = v.entity

			icon:AddValue(cost_material, v.info.cost)
			icon:AddValue(health_material, v.info.health)
			icon:AddValue(weight_material, v.info.weight)

			icon.icon:SetTooltip(v.name)

			--icon.icon:RebuildSpawnIcon()
			icon.DoClick = function()
				spawn_prop(category_key, k)
			end
			table.insert(frame.icons, icon)
		end
	end
	return list
end

function spawn_prop(category_key, key)
	surface.PlaySound( "ui/buttonclickrelease.wav")

	net.Start("aw_spawn_prop")
	net.WriteInt(category_key, 8)
	net.WriteInt(key, 8)
	net.SendToServer()
end
