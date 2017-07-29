local OxygenAura = Class(function(self, inst)
    self.inst = inst
    self.aura = 0
    self.aurafn = nil
    self.penalty = nil
	
	self.inst.entity:AddTag("oxygen_aura")
end)

function OxygenAura:SetAura(n)
	self.aura = n
end

function OxygenAura:GetAura(observer)
	if self.aurafn then
		return self.aurafn(self.inst, observer)
	end
	
	return self.aura
end

return OxygenAura