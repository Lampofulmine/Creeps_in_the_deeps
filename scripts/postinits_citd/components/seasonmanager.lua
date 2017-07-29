-- Season manager post init
local function fn(inst)
	
	-- Vanilla compatible
	if not inst.StartCavesRain then
		return
	end
	
	inst.StartCavesRainPre = inst.StartCavesRain
	inst.StartCavesRain = function(self, force_target)
		if GetWorld():IsUnderwater() then
			print("It can't rain underwater!")
			return
		else
			print("Not underwater. Rain can commence in the cave.")
			self:StartCavesRainPre()
		end
	end
end

return fn