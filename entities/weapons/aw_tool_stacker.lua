SWEP.Base = "aw_tool_base"
SWEP.PrintName = "Stacker"
SWEP.ToolName = "aw_stacker"

tool_create_convar(SWEP.ToolName, "mode", 1)
tool_create_convar(SWEP.ToolName, "offset", 0)

aw_stacker_ghosts = {}

function SWEP:PrimaryAttack()
	local trace = self:MakeTrace()
	if IsValid(trace.Entity) then
		if CLIENT then
			trace.Entity:EmitSound("buttons/button15.wav", 75, 100, 1, CHAN_WEAPON)
			return
		end
		local position = trace.Entity:GetPos()
		local mode = self:GetVariable("mode", 1)
		local offset = self:GetVariable("offset", 0)
		local direction = DIRECTION_FUNCTIONS[mode](trace.Entity:GetAngles())
		local distance = DISTANCE_FUNCTIONS[mode](trace.Entity:OBBMins(), trace.Entity:OBBMaxs())
		if trace.Entity:GetClass() != "aw_building_prop" then return end
		AirWars:SpawnProp(
			position + direction * (distance + offset),
			trace.Entity:GetAngles(),
			trace.Entity:GetCategory(),
			trace.Entity:GetProp(),
			self.Owner,
			true
		)
	end
end
function SWEP:Holster( wep )
	for key, ghost in pairs(aw_stacker_ghosts) do
		aw_stacker_ghosts[key] = nil
		ghost:Remove()
	end
	return true
end

function SWEP:Think()
	if !CLIENT then return end
	local trace = self:MakeTrace()
	for _, ghost in pairs(aw_stacker_ghosts) do
		if !IsValid(ghost) then continue end
		ghost:SetNoDraw(true)
	end
	if IsValid(trace.Entity) then
		if !aw_stacker_ghosts[trace.Entity] then
			if !trace.Entity.prop then return end
			local ghost = ClientsideModel(trace.Entity.prop.model, RENDERMODE_TRANSALPHA)
			ghost:SetRenderMode(RENDERMODE_TRANSALPHA)
			ghost:SetColor(Color(255, 255, 255, 100))
			aw_stacker_ghosts[trace.Entity] = ghost
		end

		local position = trace.Entity:GetPos()
		local mode = self:GetVariable("mode", 1)
		local offset = self:GetVariable("offset", 0)
		local direction = DIRECTION_FUNCTIONS[mode](trace.Entity:GetAngles())
		local distance = DISTANCE_FUNCTIONS[mode](trace.Entity:OBBMins(), trace.Entity:OBBMaxs())

		aw_stacker_ghosts[trace.Entity]:SetPos(position + direction * (distance + offset))
		aw_stacker_ghosts[trace.Entity]:SetAngles(trace.Entity:GetAngles())
		aw_stacker_ghosts[trace.Entity]:SetNoDraw(false)
	end
end

function SWEP:Reload()
	if SERVER then return end
	if self.Owner != LocalPlayer() then return end
	if CurTime() > (self.reload_time or 0) then
		self.reload_time = CurTime() + 0.3
		local mode_convar = GetConVar(self.ToolName .. "_mode"):GetInt()
		RunConsoleCommand( self.ToolName .. "_mode", mode_convar % 6 + 1 )
	end
end

function SWEP:ToolOptions(frame)
	local amount_slider = frame:Add( "DNumSlider" )
	amount_slider:SetConVar( self.ToolName .. "_offset" )
	amount_slider:SetMax(100)
	amount_slider:SetMin(0)
	amount_slider:SetText( "Offset" )
	amount_slider:SetWide(200)
	amount_slider.Label:SetTextColor(Color(255, 255, 255))
	amount_slider:DockMargin( 10, 0, 0, 0 )
	amount_slider:Dock(TOP)
	local self_ent = self
	local mode_convar = GetConVar(self.ToolName .. "_mode"):GetInt()
	if mode_convar == 0 then
		mode_convar = 1
	end

	local mode = frame:Add( "DComboBox" )
	mode:Dock( TOP )
	mode:AddChoice( "Front", DIRECTION_FRONT )
	mode:AddChoice( "Back", DIRECTION_BACK )
	mode:AddChoice( "Right", DIRECTION_RIGHT )
	mode:AddChoice( "Left", DIRECTION_LEFT )
	mode:AddChoice( "Up", DIRECTION_UP )
	mode:AddChoice( "Down", DIRECTION_DOWN )
	mode:DockMargin( 10, 0, 10, 0 )
	mode:ChooseOptionID( mode_convar )
	mode.OnSelect = function( self, index, value )
		RunConsoleCommand( self_ent.ToolName .. "_mode", index )
	end
end
