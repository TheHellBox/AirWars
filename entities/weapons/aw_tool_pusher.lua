SWEP.Base = "aw_tool_base"
SWEP.PrintName = "Pusher"
SWEP.ToolName = "aw_pusher"

tool_create_convar(SWEP.ToolName, "amount", 2)

function SWEP:PrimaryAttack()
	if SERVER then
		local amount = self:GetVariable("amount", 0)
		local trace = self:MakeTrace()
		if IsValid(trace.Entity) then
			local pos = trace.Entity:GetPos()
			trace.Entity:SetPos(pos - trace.HitNormal * amount)
		end
	else
		local trace = self:MakeTrace()
		if IsValid(trace.Entity) then
			trace.Entity:EmitSound("buttons/button15.wav", 75, 100, 1, CHAN_WEAPON)
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local amount = self:GetVariable("amount", 0)
		local trace = self.Owner:GetEyeTraceNoCursor()
		if IsValid(trace.Entity) then
			local pos = trace.Entity:GetPos()
			trace.Entity:SetPos(pos + trace.HitNormal * amount)
		end
	else
		local trace = self.Owner:GetEyeTraceNoCursor()
		if IsValid(trace.Entity) then
			trace.Entity:EmitSound("buttons/button15.wav", 75, 100, 1, CHAN_WEAPON)
		end
	end
end

function SWEP:ToolOptions(frame)
	local amount_slider = frame:Add( "DNumSlider" )
	amount_slider:SetConVar( self.ToolName .. "_amount" )
	amount_slider:SetMax(20)
	amount_slider:SetMin(0.25)
	amount_slider:SetText( "Push Force" )
	amount_slider:SetWide(200)
	amount_slider.Label:SetTextColor(Color(255, 255, 255))
	amount_slider:DockMargin( 10, 0, 0, 0 )
	amount_slider:Dock(TOP)
end
