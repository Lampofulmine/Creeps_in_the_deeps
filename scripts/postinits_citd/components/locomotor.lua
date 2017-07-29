-- Add tidal currents to locomotor calculations
local function fn(inst)
	inst.UpdateGroundSpeedMultiplier_pre = inst.UpdateGroundSpeedMultiplier
	
	inst.UpdateGroundSpeedMultiplier = function(self)
		self:UpdateGroundSpeedMultiplier_pre()
		
		local x, y, z = self.inst:GetPosition():Get()
		local ents = TheSim:FindEntities(x,y,z, UW_TUNING.TIDAL_EFFECT_RANGE, {"tidal_node"})
		for k,v in pairs(ents) do 
			
			local wave_power = GetPlayer().components.tidalmanager:WavePowerPercentage()
			
			local guy_direction = self.inst.Transform:GetRotation()*DEGREES
			local wave_direction = GetPlayer().components.tidalmanager:GetWaveDirection()*DEGREES
			
			local v_1 = Vector3(math.cos(guy_direction), 0, math.sin(guy_direction)) 
			local v_2 = Vector3(math.cos(wave_direction), 0, math.sin(wave_direction)) 
			
			local dot_product = (v_1.x*v_2.x) + (v_1.y*v_2.y) + (v_1.z*v_2.z);
			
			self.groundspeedmultiplier = self.groundspeedmultiplier*(1 + wave_power*dot_product)
			
			--print(self.groundspeedmultiplier)
			break
		end
	end
end

return fn