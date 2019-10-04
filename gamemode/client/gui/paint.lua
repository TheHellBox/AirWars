local function color_converter(color)
	if color.a < 255 then
		return 0
	end
	local new_color = 0
	local min = 999
	for id, v in pairs(aw_flag_colors) do
		local d = math.sqrt(math.pow((v.r-color.r)*0.3, 2) + math.pow((v.g-color.g)*0.6, 2) + math.pow((v.b-color.b)*0.1, 2))
		if d < min then
			new_color = id
			min = d
		end
	end
	return new_color
end

local function load_from_material(file)
	local material = Material("data/"..file)
	local pixels = {}
	for y=0,31 do
		for x=0,31 do
			table.insert(pixels, color_converter(material:GetColor(x, y)))
		end
	end
	return pixels
end

local function load_from_dat(file_name)
	local data = file.Read(file_name, "DATA")
	local pixels = {}
	for k, v in pairs({string.byte(data, 1, #data)}) do
		table.insert(pixels, v)
	end
	return pixels
end

local function save_flag(flag)
	local data = ""
	for _, v in pairs(flag) do
		data = data..string.char(v)
	end

	local frame = vgui.Create("AWFrame")
	frame:SetSize(512, 128)
	frame:Center()
	frame:ShowCloseButton(true)
	frame:SetDraggable(true)

	local team_name = frame:Add( "DTextEntry" )
	team_name:SetTall( 30 )
	team_name:SetText( LocalPlayer():GetAWTeamName().."_flag" )
	team_name:Dock(TOP)

	local save = frame:Add("AWButton")
	save:SetText( "Save" )
	save:Dock(BOTTOM)
	save.DoClick = function()
		if !file.Exists("aw_sprites", "DATA") then
			file.CreateDir("aw_sprites")
		end
		file.Write("aw_sprites/"..team_name:GetValue()..".dat", data)
		frame:Close()
	end

end

function open_paint_menu()
	local res = 32

	local frame = vgui.Create("DFrame")
	frame:SetText("Paint")
	frame:SetSize(700, 545)
	frame:Center()
	frame:ShowCloseButton(true)
	frame:MakePopup()
	frame.color = #aw_flag_colors
	frame.flag = {}

	function frame:OnClose()
		net.Start("aw_update_flag")
		net.WriteInt(res*res, 32)
		for k, v in pairs(frame.flag) do
			net.WriteInt(v or 0, 5)
		end
		net.SendToServer()
	end

	local paint_panel = frame:Add("DPanel")
	paint_panel:SetWide(512)
	paint_panel:SetTall(512)
	paint_panel:Dock(LEFT)

	if !aw_team_flags[LocalPlayer():GetAWTeam()] then
		for i=1, res*res do
			frame.flag[i] = 0
		end
	else
		frame.flag = aw_team_flags[LocalPlayer():GetCurrentShip()]
	end
	function paint_panel:OnMousePressed()
		self.drawing = true
	end

	function paint_panel:OnMouseReleased()
		self.drawing = false
	end

	function paint_panel:Paint(w, h)
		local scale = 512 / res
		draw_flag(frame.flag or {}, scale, res)
		local c_x, c_y = self:CursorPos()
		local x = math.floor(c_x / self:GetWide() * res)
		local y = math.floor(c_y / self:GetWide() * res)
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawOutlinedRect( x * scale, y * scale, scale, scale )
	end

	function paint_panel:Think()
		if self.drawing then
			local c_x, c_y = self:CursorPos()
			local x = math.floor(c_x / self:GetWide() * res)
			local y = math.floor(c_y / self:GetWide() * res)
			frame.flag[y * res + x + 1] = frame.color
		end
		if !input.IsMouseDown(MOUSE_LEFT) then
			self.drawing = false
		end
	end

	local right_panel = frame:Add("DPanel")
	right_panel:SetWide(180)
	right_panel:Dock(LEFT)

	local pallete = right_panel:Add( "DColorPalette" )
	pallete:Dock(TOP)
	pallete:SetButtonSize(20)
	pallete:SetColorButtons(aw_flag_colors)

	local fill = right_panel:Add( "DButton" )
	fill:SetTall(30)
	fill:Dock(TOP)
	fill:SetText("Fill")
	function fill:DoClick()
		for i=1, res*res do
			frame.flag[i] = frame.color
		end
	end

	local save = right_panel:Add( "DButton" )
	save:SetTall(30)
	save:Dock(BOTTOM)
	save:SetText("Save")
	function save:DoClick()
		save_flag(frame.flag)
	end

	function pallete:OnValueChanged( value )
		local color = table.KeyFromValue(aw_flag_colors, value)
		frame.color = color or 0
	end

	local icons = right_panel:Add( "DTree" )
	icons:Dock(BOTTOM)
	icons:SetTall(300)
	local node = icons:AddNode( "Sprites" )
	node:MakeFolder( "aw_sprites", "DATA", true )

	function icons:DoClick()
		local node = self:GetSelectedItem()
		local f_name = node:GetFileName()
		if f_name then
			if string.GetExtensionFromFilename( f_name ) == "dat" then
				frame.flag = load_from_dat(f_name)
			else
				frame.flag = load_from_material(f_name)
			end
		end
	end
end
