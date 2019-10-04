AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck(true)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator, caller)
	-- Yep I know I'm lazy as fuck
	if IsValid(activator) then
		activator:SendLua("open_paint_menu()")
	end
end
