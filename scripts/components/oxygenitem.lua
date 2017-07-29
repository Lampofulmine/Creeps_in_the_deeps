local OxygenItem = Class(function(self, inst)
    self.inst = inst
    self.amount = 1
	
	self.inst.entity:AddTag("oxygen_item")
end)

function OxygenItem:SetOxygenAmount(n)
	self.amount = n
end

return OxygenItem