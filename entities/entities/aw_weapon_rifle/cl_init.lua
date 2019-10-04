include("shared.lua")


function ENT:WakePart()
	local part_id = self:GetPartID()
	if world_ships[self:GetAWTeam()] == nil then return end
	local part = world_ships[self:GetAWTeam()].parts[part_id]
	if part == nil then return end
	part.subparts = {}
	part.subparts[1] = {
		model = "models/aw_rifle/aw_rifle_stand.mdl",
		angle = Angle(0.0, part.angle.y, 0.0),
		offset = Vector(0, 0, 0)
	}
	part.subparts[2] = {
		model = "models/aw_rifle/aw_rifle_base.mdl",
		angle = Angle(0.0, part.angle.y, 0.0),
		offset = Vector(0, 0, -40)
	}
end

function ENT:Draw()
	if self:GetAWTeam() != LocalPlayer():GetCurrentShip() then return end
	local position = self:LocalToWorld( Vector( -25, -10, 20 ) )
	local angle = self:GetAngles() - Angle(0, 0, -90)
	self:DrawInfo(position, angle)
end

function ENT:Think()
	local controller = self:GetController()
	local part_id = self:GetPartID()
	local ship = world_ships[self:GetAWTeam()]
	if !ship then return end
	local part = ship.parts[part_id]
	if part ~= nil then
		if part.subparts == nil then self:WakePart() end
	end
	if IsValid(controller) then
		local part = world_ships[self:GetAWTeam()].parts[part_id]
		if part ~= nil then
			local angle = (-controller:EyeAngles():Forward()):Angle()
			part.angle.z = angle.x
			part.angle.y = angle.y + 90
			part.subparts[1].angle.y = part.angle.y
		end
	end
end
