local meta = FindMetaTable("Player")

function meta:SyncWearables()
	net.Start("aw_player_sync_wearables")
	net.WriteTable(self.items)
	net.WriteInt(self:EntIndex(), 32)
	net.Broadcast()
end

function meta:SyncPlayerData()
	net.Start("aw_player_sync_data")
	net.WriteTable(self.player_data)
	net.Send(self)
end

function meta:AddPoints(amount)
	self:SetPoints(math.Clamp(self:GetPoints() + amount, 0, math.huge))
end

function meta:SetPoints(amount)
	self:SetDataValue("points",
		math.Clamp(amount, 0, math.huge)
	)
	self:SyncPlayerData()
end

function meta:GetPoints()
	return self:GetDataValue("points") or 0
end

function meta:CanAfford(cost)
	return self:GetPoints() >= cost
end

function meta:HasItem(item_category, item_id)
	local unlocked = self:GetDataValue("unlocked") or {}
	if table.HasValue(unlocked[item_category] or {}, item_id) then
		return true
	end
	return false
end

function meta:Unlock(category, index)
	local unlocked = self:GetDataValue("unlocked") or {}
	unlocked[category] = unlocked[category] or {}
	table.insert(unlocked[category], index)
	self:SetDataValue("unlocked", unlocked)
	self:SyncPlayerData()
end

net.Receive("aw_pointshop_wear", function(len, player)
	local category = net.ReadInt(8)
	local index = net.ReadInt(8)
	player.items = player.items or {}
	if player.items[category] ~= nil and player.items[category][2] == index then
		player.items[category] = nil
	else
		if player:HasItem(category, index) then
			player.items[category] = {category, index}
		else
			local category_table = point_shop_config.categories[category]
			if !category_table then return end
			local item = category_table.props[index]
			if !item then return end
			if player:CanAfford(item.cost) then
				player.items[category] = {category, index}
				player:AddPoints(-item.cost)
				player:Unlock(category, index)
			else
				player:ChatPrint("You cannot afford this")
				return
			end
		end
	end

	net.Start("aw_player_sync_wearables")
	net.WriteTable(player.items)
	net.WriteInt(player:EntIndex(), 32)
	net.Broadcast()

	player:SetDataValue("wearables", player.items)
end)


hook.Add("PlayerInitialSpawn", "Sync wearables", function( ply )
	for k, v in pairs(player.GetAll()) do
		net.Start("aw_player_sync_wearables")
		net.WriteTable(v.items or {})
		net.WriteInt(v:EntIndex(), 32)
		net.Send(ply)
	end
end)

hook.Add("PlayerInitialSpawn", "Load wearables", function( ply )
	timer.Simple(1, function()
		if ply:GetDataValue("wearables") then
			ply.items = ply:GetDataValue("wearables")
		end
		ply:SyncWearables()
		ply:SetPoints(ply:GetPoints())
	end)
end)
