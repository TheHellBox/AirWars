SWEP.Base = "aw_tool_base"
SWEP.PrintName = "Remover"
SWEP.ToolName = "aw_remover"

function SWEP:PrimaryAttack()
	if SERVER then
		local trace = self:MakeTrace()
		if IsValid(trace.Entity) then
			trace.Entity:Remove()
		end
	else
		local trace = self:MakeTrace()
		if IsValid(trace.Entity) then
			trace.Entity:EmitSound("buttons/button15.wav", 75, 100, 1, CHAN_WEAPON)
		end
	end
end

function SWEP:ToolOptions(frame)

end
