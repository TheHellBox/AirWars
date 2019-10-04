aw_enable_noclip = false

local function is_in_world( pos )
	local tr = { collisiongroup = COLLISION_GROUP_WORLD }
	tr.start = pos
	tr.endpos = pos
	return util.TraceLine( tr ).HitWorld
end


function GM:Move( ply, mv )
	if !aw_enable_noclip then return end
	
	local speed = 0.0005 * FrameTime()
	if ( mv:KeyDown( IN_SPEED ) ) then speed = 0.005 * FrameTime() end


	local ang = mv:GetMoveAngles()
	local pos = mv:GetOrigin()
	local vel = mv:GetVelocity()

	vel = vel + ang:Forward() * mv:GetForwardSpeed() * speed
	vel = vel + ang:Right() * mv:GetSideSpeed() * speed
	vel = vel + ang:Up() * mv:GetUpSpeed() * speed

	if ( math.abs( mv:GetForwardSpeed() ) + math.abs( mv:GetSideSpeed() ) + math.abs( mv:GetUpSpeed() ) < 0.1 ) then
	vel = vel * 0.90
	else
	vel = vel * 0.99
	end

	pos = pos + vel

	mv:SetVelocity( vel )
	mv:SetOrigin( pos )

	return true

end
