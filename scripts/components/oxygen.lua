local Oxygen = Class(function(self, inst)
    self.inst = inst
   
	self.max = 100
    self.current = self.max
	self.rate = 0
	self.hurtrate = 1
	self.burning = true
	
	self.inst:StartUpdatingComponent(self)
end)

function Oxygen:Pause()
    self.burning = false
end

function Oxygen:Resume()
    self.burning = true
end

function Oxygen:IsDrowning()
	return (self.current <= 0)
end

function Oxygen:OnSave()
	local data = {}
	data.current = self.current
	
	if self.max ~= 100 then
		data.max = self.max
	end
	
	return data
end

function Oxygen:OnLoad(data)
	
	if data.max then
		self.max = data.max
	end
	
	if data.current then
        self.current = data.current
		
		if self.current <= 0 then
			self.current = 0.001
		end
	end 
end

function Oxygen:GetCurrent()
	return self.current
end

function Oxygen:GetMax()
	return self.max
end

function Oxygen:GetDelta()
	return self.rate
end

function Oxygen:GetPercent()	
	return self.current / self.max
end

function Oxygen:SetPercent(n)
    local target = n * self.max
    local delta = target - self.current
    self:DoDelta(delta)
end

function Oxygen:GetDebugString()
    return string.format("%2.2f / %2.2f at %2.4f", self.current, self.max, self.rate)
end

function Oxygen:SetMax(amount)
    self.max = amount
    self.current = amount
end

function Oxygen:GetRate()
	return self.rate
end

function Oxygen:DoDelta(delta, overtime)
	
	-- No oxygen loss while invincible or teleporting
	if self.inst.components.health.invincible == true or self.inst.is_teleporting == true then
		return
	end
	
	-- Oxygen loss only occurs while underwater
	if not GetWorld():IsUnderwater() then		
		self.rate = 0
		self.current = self.max
		
		return
	end
	
	-- No oxygen loss if you don't breathe
	if self.inst:HasTag("robot") or self.inst:HasTag("waterbreather") then
		return
	end

	-- Hook for external shenanigans
    if self.redirect then
        self.redirect(self.inst, delta, overtime)
        return
    end

    if self.ignore then return end

	-- Update values
    local old = self.current

    self.current = self.current + delta
    if self.current < 0 then 
        self.current = 0
    elseif self.current > self:GetMax() then
        self.current = self:GetMax()
    end
    
    local oldpercent = old/self.max
    local newpercent = self.current/self.max
    
    self.inst:PushEvent("oxygendelta", {oldpercent = oldpercent, newpercent = newpercent, overtime=overtime})
	
	-- Drowning!
	if old > 0 and self.current <= 0 then
        self.inst:PushEvent("startdrowning")
    elseif old <= 0 and self.current > 0 then
        self.inst:PushEvent("stopdrowning")
    end
	
	-- Running out of oxygen!
	if (newpercent > UW_TUNING.OXYGEN_THRESH) ~= (oldpercent > UW_TUNING.OXYGEN_THRESH) then
		if newpercent <= UW_TUNING.OXYGEN_THRESH then
			self.inst:PushEvent("runningoutofoxygen")
		end
	end	
end

function Oxygen:OnUpdate(dt)

	-- Recalculate
	self:Recalc(dt)
	
	-- Drowning!
	if self:IsDrowning() and self.inst.components.health and not self.inst.components.health:IsDead() and self.burning then
		self.inst.components.health:DoDelta(-self.hurtrate*dt, true, "drowning")
	end
end

function Oxygen:Recalc(dt)
	
	if not self.burning then
		return
	end
	
	local loss_delta = UW_TUNING.OXYGEN_LOSS_RATE
	local oxygen_supply = self.oxygen_supply or 0
	
	-- Oxygen suppliers items
	for k,v in pairs (self.inst.components.inventory.equipslots) do
		if v.components.oxygensupplier then
			oxygen_supply = oxygen_supply + v.components.oxygensupplier:GetSupplyRate(self.inst)
		end		
	end
	
	local supply_delta = oxygen_supply*UW_TUNING.OXYGEN_AIRINESS
	
	-- Oxygen supplying / removing environmental objects / monsters
	local aura_delta = 0
	local x,y,z = self.inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z, UW_TUNING.OXYGEN_EFFECT_RANGE, {"oxygen_aura"})
    for k,v in pairs(ents) do 
		if v.components.oxygenaura and v ~= self.inst then
			local distsq = self.inst:GetDistanceSqToInst(v)
			local aura_val = v.components.oxygenaura:GetAura(self.inst)/math.max(1, distsq)
			aura_delta = aura_delta + aura_val
		end
    end

	-- Final rate of oxygen gain / loss
	self.rate = (supply_delta + loss_delta + aura_delta)	
	
	-- Custom rate adjustment
	if self.custom_rate_fn then
		self.rate = self.rate + self.custom_rate_fn(self.inst)
	end
	
	-- Reduce rate loss if wearing oxygen apparatus
	if self.rate < 0 then
		for k,v in pairs (self.inst.components.inventory.equipslots) do
			if v.components.oxygenapparatus then
				self.rate = self.rate*(1-v.components.oxygenapparatus:GetReductionPercentage())
			end		
		end
	end
	
	-- No oxygen loss if you don't breathe
	if self.inst:HasTag("robot") or self.inst:HasTag("waterbreather") then
		self.rate = 0
		return
	end
	
	self:DoDelta(self.rate*dt, true)
end

function Oxygen:LongUpdate(dt)
	self:OnUpdate(dt)
end

return Oxygen