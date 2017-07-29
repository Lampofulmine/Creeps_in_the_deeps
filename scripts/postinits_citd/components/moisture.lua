-- You get wet when standing in rivers
local function fn(inst)
	inst.GetMoistureRate_pre = inst.GetMoistureRate
	inst.GetMoistureRate = function(self)
		local rate = self:GetMoistureRate_pre()
		
		local tile, tileinfo = self.inst:GetCurrentTileType()
		if not self.inst:IsInLimbo() and tile == GROUND.WATER_RIVER then
			rate = rate + self.maxMoistureRate*UW_TUNING.RIVER_WETNESS
		end
		
		return rate
	end
end

return IsDLCInstalled(REIGN_OF_GIANTS) and softresolvefilepath("scripts/components/moisture.lua") and fn