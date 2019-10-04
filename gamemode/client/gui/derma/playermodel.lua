local PANEL = {}

function PANEL:Init()
	self.color = Color(50, 50, 50)
	self:UpdateModel()
end

function PANEL:UpdateModel()
	if self.entity then
		self.entity:Remove()
	end
	self.entity = ClientsideModel( LocalPlayer():GetModel(), RENDER_GROUP_OPAQUE_ENTITY )
	self.entity:SetPos(Vector(0,0,0))
	self.entity:SetNoDraw( true )
	self.entity:SetIK(false)
end

function PANEL:Paint(w, h)
	local x, y = self:LocalToScreen( 0, 0 )
	local camera_pos = Vector(60, 0, 40)
	local model_pos = Vector(0, 0, 40)
	draw.RoundedBox(5, 0, 0, w, h, self.color)

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( LocalPlayer():GetPos() )

	cam.Start3D( camera_pos, (model_pos - camera_pos):Angle(), 40, x, y, w, h, 5, 10000 )
		self.entity:SetSequence( self.entity:LookupSequence( "menu_walk" ) )
		self.entity:SetCycle(CurTime())
		self.entity:SetAngles(Angle(0, (CurTime() * 25) % 360 , 0))
		self.entity:DrawModel()

		local items = aw_player_items[LocalPlayer():EntIndex()]
		if items != nil then
			for k, item in pairs(items) do
				local category = point_shop_config.categories[item[1]]
				if !category then continue end
				local item = category.props[item[2]]
				if !item then continue end
				local model = aw_pointshop_models[item.model]
				local bone = item.bone
				if !bone or !model then continue end
				local bone_id = self.entity:LookupBone( bone )
				local matrix = self.entity:GetBoneMatrix( bone_id )

				local position, angle = LocalToWorld( item.offset, item.angle, matrix:GetTranslation(), matrix:GetAngles() )
				model:SetPos( position )
				model:SetAngles( angle )
				model:SetupBones()
				model:DrawModel()
			end
		end
	cam.End3D()
	render.SuppressEngineLighting( false )
end

vgui.Register("AWPlayerModel", PANEL, "DPanel")
