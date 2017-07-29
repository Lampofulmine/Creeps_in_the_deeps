-- Burning things autoextinguish
local function fn(inst)
	inst.Ignite_pre = inst.Ignite
	
	inst.Ignite = function(self, immediate)
	
		if GetWorld():IsUnderwater() and not self.inst:HasTag("chemicalfire") then
			if self.inst.components.fueled and self.inst.components.fueled.fueltype == "BURNABLE" then
				self.inst.components.fueled.currentfuel = 0.0001
				self.inst.components.fueled:StartConsuming()
				
				self.inst:DoTaskInTime(0, function()
					local steam_cloud = SpawnPrefab("collapse_small")
					local pt = self.inst:GetPosition()
					if steam_cloud and pt then
						steam_cloud.Transform:SetPosition(pt.x, 0.1, pt.z)
					end
				end)		
			else
				return
			end
		end
		
		self:Ignite_pre(immediate)
	end
end

return fn