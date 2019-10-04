local next_props_update_time = 0

hook.Add("Think", "Highlight props", function()
	if CurTime() < next_props_update_time then return end
	next_props_update_time = CurTime() + 0.2
	local blocked = find_blocked_entities(LocalPlayer():GetAWTeam())
	for k, v in pairs(ents.FindByClass("aw_building_prop")) do
		if table.HasValue(blocked, v) then
			v:SetColor(Color(255, 0, 0))
		else
			v:SetColor(Color(255, 255, 255))
		end
	end
end)
