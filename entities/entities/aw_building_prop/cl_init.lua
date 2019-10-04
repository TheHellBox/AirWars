include("shared.lua")

function ENT:Initialize()
	local category = global_config.categories[self:GetCategory()]
	if category == nil then return end
	local prop = category.props[self:GetProp()]
	if prop == nil then return end
	self.prop = prop
	self.info = prop.info
	if prop.custom_info then
		self.custom_info = prop.custom_info
	end
end

function ENT:Draw()
	if LocalPlayer():AWIsInTeam(self:GetAWTeam()) or self.owner == LocalPlayer() then
		if table.HasValue(self:GetMaterials(), "models/aw_model_materials/aw_flag_a") then
			self:SetSubMaterial( 2, "!AWFlagMaterial" )
			aw_render_flag_texture(aw_flag_mat, self:GetAWTeam())
		end
		self:DrawModel()
	end
end
