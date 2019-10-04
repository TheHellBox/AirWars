local meta = FindMetaTable("Entity")


function meta:GetAmmoAmount()
	return self:GetNWInt("aw_ammo_amount", 0)
end

function meta:SetAmmoAmount(amount)
	return self:SetNWInt("aw_ammo_amount", amount or 0)
end
