include("props_collision.lua")
include("teams.lua")
include("entity.lua")
include("player.lua")
include("noclip.lua")
include("crew.lua")
include("founds.lua")
include("tool_base.lua")
include("math.lua")

aw_flag_colors = {
	Color(255, 255, 255),
	Color(26, 26, 44),
	Color(93, 39, 93),
	Color(177, 62, 83),
	Color(239, 125, 87),
	Color(255, 205, 117),
	Color(167, 240, 112),
	Color(56, 183, 100),
	Color(37, 113, 121),
	Color(41, 53, 111),
	Color(59, 93, 201),
	Color(65, 166, 246),
	Color(115, 239, 247),
	Color(148, 176, 194),
	Color(86, 108, 134),

}

hook.Add("Move", "FreezePlayer", function(player, move_data)
	if player:IsInControl() then
		if ( move_data:KeyDown( IN_JUMP ) ) then return true end
		move_data:SetMaxSpeed(0)
		return false
	end
end)

-- http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function find_blocked_entities(team)
	local center = Vector()
	local count = 0
	for k, a in pairs(ents.FindByClass("aw_building_prop")) do
		if a:GetAWTeam() != team then continue end
		center = center + a:GetPos()
		count = count + 1
	end
	center = center / count
	local result = {}
	for k, v in pairs(ents.FindByClass("aw_building_prop")) do
		if v:GetAWTeam() != team then continue end
		if v:GetPos():Distance(center) > 300 then
			table.insert(result, v)
		end
	end
	return result
end
