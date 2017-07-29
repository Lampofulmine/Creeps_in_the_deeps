local OxygenApparatus = Class(function(self, inst)
    self.inst = inst
    self.percentage = 1
	
	self.inst.entity:AddTag("oxygen_apparatus")
end)

function OxygenApparatus:SetReductionPercentage(n)
	self.percentage = n
end

function OxygenApparatus:GetReductionPercentage()
	return self.percentage
end

return OxygenApparatus