include("prop_spawn_menu.lua")
include("options_menu.lua")
include("teams_menu.lua")
include("point_shop.lua")
include("tool_menu.lua")

local function check_ents()
	local entities = {"aw_player_spawn", "aw_ammunition_storage", "aw_ship_controller"}
	for k, v in pairs(ents.FindByClass("aw_building_prop")) do
		if !v.prop then continue end
		if v:GetAWTeam() != LocalPlayer():GetAWTeam() then continue end
		if table.HasValue(entities, v.prop.entity) then
			table.RemoveByValue(entities, v.prop.entity)
		end
	end
	local height = calculate_height(LocalPlayer():GetAWTeam())
	local force = build_calculate_ship_force(LocalPlayer():GetAWTeam())
	local weight = build_calculate_ship_weight(LocalPlayer():GetAWTeam())

	if height <= 5 then table.insert(entities, "aw_engine") end
	if force <= (weight / 2) then table.insert(entities, "aw_sail") end
	return entities
end

local function update_icons()
	local warnings = check_ents()
	for k, icon in pairs(spawn_menu_frame.icons) do
		if table.HasValue(warnings, icon.entity) then
			icon:SetColor(Color(60, 160, 60))
		else
			icon:SetColor(Color(60, 60, 60))
		end
	end
	spawn_menu_frame.point_shop.points:UpdateLabel()
	for k, icon in pairs(spawn_menu_frame.point_shop.icons) do
		local item = aw_get_item_data(icon.category, icon.id)
		if !item then continue end
		if !LocalPlayer():HasItem(icon.category, icon.id) then
			if LocalPlayer():CanAfford(item.cost) then
				icon:SetColor(Color(60, 160, 60))
			else
				icon:SetColor(Color(160, 60, 60))
			end
		else
			icon:SetColor(Color(60, 60, 60))
		end
	end
end

function GM:OnSpawnMenuOpen()
	if game_state.state == GAME_STATE_FIGHT then return end
	aw_hide_spawnmenu_tip = true

	gui.EnableScreenClicker(true)
	RestoreCursorPosition()

	if !IsValid(spawn_menu_frame) then
		local frame = vgui.Create("AWSMFrame")
		frame:SetSize(510, 512)
		frame:Center()
		frame:ShowCloseButton(false)
		frame:SetScreenLock(true)
		function frame:Paint(w, h) end
		function frame:Think()
			update_icons()
		end
		spawn_menu_frame = frame
	end

	spawn_menu_frame:Show()

	if !IsValid(spawn_menu_frame.sheet) then
		spawn_menu_frame.sheet = spawn_menu_frame:Add( "DPropertySheet" )
		spawn_menu_frame.sheet:Dock( FILL )
	end
	local sheet = spawn_menu_frame.sheet

	if !sheet.props then
		sheet.props = open_props_menu(sheet, spawn_menu_frame)
		sheet.props:Dock(FILL)
		sheet:AddSheet( "Props", sheet.props, "icon16/application_view_icons.png" )
	end

	if !sheet.teams then
		sheet.teams = open_teams_menu(sheet, spawn_menu_frame)
		sheet.teams:Dock(FILL)
		sheet:AddSheet( "Teams", sheet.teams, "icon16/find.png" )
	else
		sheet.teams = open_teams_menu(sheet, spawn_menu_frame)
	end

	if !sheet.point_shop then
		sheet.point_shop = open_point_shop(sheet, spawn_menu_frame)
		sheet.point_shop:Dock(FILL)
		sheet:AddSheet( "Character", sheet.point_shop, "icon16/user.png" )
	else
		sheet.point_shop = open_point_shop(sheet, spawn_menu_frame)
	end

	if !sheet.tool_menu then
		sheet.tool_menu = open_tool_menu(sheet, spawn_menu_frame)
		sheet.tool_menu:Dock(FILL)
		sheet:AddSheet( "Tool Options", sheet.tool_menu, "icon16/cog.png" )
	else
		sheet.tool_menu = open_tool_menu(sheet, spawn_menu_frame)
	end
end

function GM:OnSpawnMenuClose()
	if IsValid(spawn_menu_frame) then
		RememberCursorPosition()
		gui.EnableScreenClicker(false)
		spawn_menu_frame:Hide()
	end
end

concommand.Add("close_spawn_menu", function()
	spawn_menu_frame:Close()
end)
