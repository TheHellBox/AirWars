function teams_menu_update(frame)
	for id, team in pairs(game_state.teams) do
		if id == LocalPlayer():GetAWTeam() then continue end
		local send_request = frame.teams_menu.teams_list:AddButton(team.name, "Join")

		local flag = send_request:Add("DPanel")
		flag:SetWide(32)
		flag:Dock(LEFT)
		function flag:Paint()
			aw_render_flag_texture(aw_flag_mat, id)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial(aw_flag_mat)
			surface.DrawTexturedRect(0, 0, 32, 32)
		end

		send_request.DoClick = function()
			net.Start("aw_send_team_request")
			net.WriteInt(id, 32)
			net.SendToServer()
			frame:Hide()
		end
	end

	for k, v in pairs(player.GetAll()) do
		if v:GetAWTeam() != LocalPlayer():GetAWTeam() then continue end
		local send_request = frame.teams_menu.member_list:AddButton(v:Name(), "Kick")
		send_request.DoClick = function()
			net.Start("aw_team_kick_player")
			net.WriteEntity(v)
			net.SendToServer()
			frame:Hide()
		end

		if !LocalPlayer():IsLeader() or v:IsLeader() then
			send_request.button:Remove()
		end

		if v:IsLeader() then
			send_request.label:SetTextColor(Color(255, 0, 0))
		end

		local icon = send_request:Add("AvatarImage")
		icon:SetWide(30)
		icon:Dock(LEFT)
		icon:SetPlayer( v, 30 )
	end
end

function name_change_menu()
	local frame = vgui.Create("AWFrame")
	frame:SetSize(512, 128)
	frame:Center()
	frame:ShowCloseButton(true)
	frame:SetDraggable(true)

	local team_name = frame:Add( "DTextEntry" )
	team_name:SetTall( 30 )
	team_name:SetText( "Team Name" )
	team_name:Dock(TOP)

	local create_team = frame:Add("AWButton")
	create_team:SetText( "Change" )
	create_team:Dock(BOTTOM)
	create_team.DoClick = function()
		net.Start("aw_change_team_name")
		net.WriteString(team_name:GetValue() or "Default")
		net.SendToServer()
		frame:Close()
	end
end

function open_teams_menu(sheet, frame)
	if !frame.teams_menu then
		frame.teams_menu = sheet:Add("DPanel")
		frame.teams_menu:Dock(FILL)
		frame.teams_menu:SetBackgroundColor(Color(0, 0, 0, 0))
	else
		for k, v in pairs(frame.teams_menu:GetChildren()) do
			v:Remove()
		end
	end
	if LocalPlayer():IsLeader() then
		frame.teams_menu.team_name = frame.teams_menu:Add("AWButton")
		frame.teams_menu.team_name:SetText( "Change Name" )
		frame.teams_menu.team_name:Dock(BOTTOM)
		frame.teams_menu.team_name:DockMargin(5, 5, 5, 5)
		frame.teams_menu.team_name:SetTextColor(Color(0, 0, 0))
		frame.teams_menu.team_name:SetFont("aw_hud_small")
		function frame.teams_menu.team_name:DoClick()
			name_change_menu()
		end
	end

	local open_paint = frame.teams_menu:Add("AWButton")
	open_paint:SetText( "Draw Flag" )
	open_paint:Dock(BOTTOM)
	open_paint:DockMargin(5, 5, 5, 5)
	open_paint:SetTextColor(Color(0, 0, 0))
	open_paint:SetFont("aw_hud_small")
	function open_paint:DoClick()
		open_paint_menu()
	end


	local team_name_label = frame.teams_menu:Add("AWButton")
	team_name_label:SetText( "Leave Team" )
	team_name_label:Dock(BOTTOM)
	team_name_label:DockMargin(5, 5, 5, 5)
	team_name_label:SetTextColor(Color(0, 0, 0))
	team_name_label:SetFont("aw_hud_small")
	function team_name_label:DoClick()
		net.Start("aw_team_kick_player")
		net.WriteEntity(LocalPlayer())
		net.SendToServer()
		frame:Hide()
	end

	frame.teams_menu.teams_list = frame.teams_menu:Add("AWList")
	frame.teams_menu.teams_list:DockMargin(5, 5, 5, 5)
	frame.teams_menu.teams_list:Dock( BOTTOM )
	frame.teams_menu.teams_list:SetTall(150)

	frame.teams_menu.member_list = frame.teams_menu:Add("AWList")
	frame.teams_menu.member_list:DockMargin(5, 5, 5, 5)
	frame.teams_menu.member_list:Dock( FILL )
	frame.teams_menu.member_list:SetTall(150)

	teams_menu_update(frame)

	return frame.teams_menu
end

net.Receive("aw_team_request", function()
	local applicant_player = net.ReadEntity()
	local request_id = net.ReadInt(8)

	local frame = vgui.Create("AWFrame")
	frame:SetSize(512, 100)
	frame:Center()
	frame:ShowCloseButton(true)
	frame:SetDraggable(true)

	local description = frame:Add( "DLabel" )
	description:SetTall( 30 )
	description:SetText( "Player "..applicant_player:Name().." wants to join your team." )
	description:SetTextColor(Color(255, 255, 255))
	description:SetFont("Trebuchet24")
	description:Dock(TOP)

	local bottom_panel = frame:Add( "DPanel" )
	bottom_panel:SetTall( 30 )
	bottom_panel:SetBackgroundColor(Color(0, 0, 0, 0))
	bottom_panel:Dock(BOTTOM)

	local accept = bottom_panel:Add("AWButton")
	accept:SetText( "Accept" )
	accept:Dock(LEFT)
	accept:SetWide(150)
	accept:SetColor(Color(50, 80, 50))
	accept.DoClick = function()
		net.Start("aw_accept_team_request")
		net.WriteInt(request_id, 8)
		net.SendToServer()
		frame:Close()
	end

	local deny = bottom_panel:Add("AWButton")
	deny:SetText( "Deny" )
	deny:Dock(RIGHT)
	deny:SetWide(150)
	deny:SetColor(Color(80, 50, 50))
	deny.DoClick = function()
		frame:Close()
	end

end)
