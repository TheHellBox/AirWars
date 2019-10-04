-- Naming is wrong probably
function local_rotation_to_global(angle)
	local matrix = Matrix()
	matrix:SetRight(Vector(0, 1, 0))
	matrix:SetForward(Vector(0, 0, 1))
	matrix:SetUp(Vector(1, 0, 0))
	matrix:Rotate(angle)
	return matrix:GetAngles() + Angle(90, 0, 0)
end
