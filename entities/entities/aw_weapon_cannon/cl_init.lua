include("shared.lua")

function ENT:Draw()
	if self:GetAWTeam() != LocalPlayer():GetCurrentShip() then return end
	local position = self:LocalToWorld( Vector( -25, -40, 25 ) )
	local angle = self:GetAngles() - Angle(180, 180, 90)

	self:DrawInfo(position, angle)
end

function ENT:WakePart()
	local part_id = self:GetPartID()
	if world_ships[self:GetAWTeam()] == nil then return end
	local part = world_ships[self:GetAWTeam()].parts[part_id]
	if part == nil then return end
	part.subparts = {}
	part.subparts[1] = {
		model = "models/aw_cannon/aw_cannon_base.mdl",
		angle = Angle(0.0, self:GetAngles().y, 0.0),
		offset = LocalToWorld( Vector(0, -20, -18), Angle(), part.position, self:GetAngles()) - part.position
	}
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
			local angle = (-controller:EyeAngles():Forward()):Angle().x
			part.angle.z = angle
		end
	end
end
