local clouds_mesh = clouds_mesh or Mesh()
local cloud_material = Material("particles/smokey")

function spawn_clouds()
	local vertices = {}
	for k=1, 30 do
		local seed = 115
		local x = util.SharedRandom( "1"..seed..k, -24000, 24000 )
		local y = util.SharedRandom( "2"..seed..k, -24000, 24000 )
		local z = util.SharedRandom( "3"..seed..k, 2000, 16000 )
		local position = Vector(x, y, z)
		for z=0, 50 do
			local x = util.SharedRandom( "4"..seed..z, -3000, 3000 )
			local y = util.SharedRandom( "5"..seed..z, -3000, 3000 )
			local z = util.SharedRandom( "6"..seed..z, -500, 500 )
			local rnd_position = Vector(x, y, z)
			//add_particle(position + rnd_position, "particles/smokey", 3, 10000, 99999, 99999, 2, Vector(), 5, 30)
			local angle = Angle(math.Rand(0, 360), math.Rand(0, 360), math.Rand(0, 360))
			local vecs = {
				Vector(0, 0),
				Vector(0, 1),
				Vector(1, 1),

				Vector(0, 0),
				Vector(1, 1),
				Vector(1, 0),

				Vector(1, 1),
				Vector(0, 1),
				Vector(0, 0),

				Vector(1, 0),
				Vector(1, 1),
				Vector(0, 0),
			}

			for _, vec in pairs(vecs) do
				table.insert(vertices, {
					color = Color(255, 255, 255, 10),
					normal = angle:Forward(),
					pos = LocalToWorld( (vec - Vector(0.5, 0.5)) * 6000, Angle(), position + rnd_position, angle ),
					u = vec.x,
					v = vec.y
				})
			end
		end
	end
	clouds_mesh:BuildFromTriangles( vertices )
end

function draw_clouds(view)
	local matrix = Matrix()
	matrix:Translate(Vector())
	matrix:Rotate(Angle())

	cam.PushModelMatrix( view * matrix)
		render.SetMaterial( cloud_material )
		if clouds_mesh ~= nil then
			clouds_mesh:Draw()
		end
	cam.PopModelMatrix()
end

spawn_clouds()
