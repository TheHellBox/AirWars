local meta = FindMetaTable("Player")

function meta:GetDataValue(value_name)
	if !self.player_data then
		return nil
	end
	return self.player_data[value_name]
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
