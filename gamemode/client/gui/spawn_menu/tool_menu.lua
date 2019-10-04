function open_tool_menu(sheet, frame)
	if !frame.tool_menu then
		frame.tool_menu = sheet:Add("DPanel")
		frame.tool_menu:Dock(FILL)
		frame.tool_menu:SetBackgroundColor(Color(0, 0, 0, 0))
	else
		for k, v in pairs(frame.tool_menu:GetChildren()) do
			v:Remove()
		end
	end

	local weapon = LocalPlayer():GetActiveWeapon()
	if weapon.ToolOptions ~= nil then
		weapon:ToolOptions(frame.tool_menu)
	end
	return frame.tool_menu
end
