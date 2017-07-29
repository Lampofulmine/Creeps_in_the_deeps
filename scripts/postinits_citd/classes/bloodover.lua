-- Blood over postinit to include drowning
local function fn(inst)
	print("Adding blood over postinit")
	
	inst.UpdateStatePre = inst.UpdateState
	inst.UpdateState = function(self)
		self:UpdateStatePre()
		if (self.owner.components.oxygen and self.owner.components.oxygen:IsDrowning()) or (self.owner.components.thirst and self.owner.components.thirst:IsThirsty()) then
			self:TurnOn()
		end
	end
end

return {fullname = "widgets/bloodover", fn = fn}