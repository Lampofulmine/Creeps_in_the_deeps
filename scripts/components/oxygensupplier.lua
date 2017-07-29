local OxygenSupplier = Class(function(self, inst)
    self.inst = inst
	self.oxgyenrate = 0
	
	self.inst.entity:AddTag("oxygen_supplier")
end)

function OxygenSupplier:SetSupplyRate(n)
	self.oxgyenrate = n
end

function OxygenSupplier:GetSupplyRate(owner)
	if self.oxygenfn then
		return self.oxygenfn(self.inst, owner)
	end
	
	return self.oxgyenrate
end

return OxygenSupplier
