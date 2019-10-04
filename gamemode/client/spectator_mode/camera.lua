aw_spectator_camera = {
	position = Vector(),
	angles = Angle()
}

function aw_spectator_camera:GetView()
	local view = Matrix()
	view:Translate(aw_spectator_camera.position)
	view:Rotate(aw_spectator_camera.angles)
	return view
end

function aw_spectator_camera:SetPosition(position)
	self.position = position
end

function aw_spectator_camera:SetAngles(angle)
	self.angles = angle
end

function aw_spectator_camera:AddVector(vector)
	local direction_forward = LocalPlayer():EyeAngles():Forward()
	local direction_right = LocalPlayer():EyeAngles():Right()
	local direction_up = LocalPlayer():EyeAngles():Up()

	local forward = vector.x * direction_forward
	local right = vector.y * direction_right
	local up = vector.z * direction_up
	self:SetPosition(self.position + (forward + right + up))
end

function aw_spectator_camera:AddVectorSimple(vector)
	self:SetPosition(self.position + vector)
end

function aw_spectator_camera:AddAngle(angle)
	self:SetAngles(self.angles + angle)
end
