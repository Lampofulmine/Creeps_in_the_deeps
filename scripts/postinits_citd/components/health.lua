return function(cmp)

    local _RecalculatePenalty = cmp.RecalculatePenalty
    function cmp:RecalculatePenalty()
        -- first, calculate the normal penalty
        _RecalculatePenalty(self)
		
        -- you could also check for a specific player prefab, e.g. "wx78"
        if self.inst:HasTag("robot") and GetWorld():IsUnderwater() then
            -- initialise the water penalty
            self.waterpenalty = self.waterpenalty or 0
			self.penalty = self.penalty + self.waterpenalty
            local waterpen = .6 -- percent
			
            -- check for insulator
            local hat = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            local vest = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            if vest then
                if vest.prefab == "diving_suit_summer" then
                    waterpen = waterpen - .25
                elseif vest.prefab == "diving_suit_winter" then
                    waterpen = waterpen - .25
                end
            end
            if hat and hat.prefab == "snorkel" then
                    waterpen = waterpen - .10
            end
            waterpen = math.max(waterpen, 0) -- no negative penalty, of course
            -- calculate actual water penalty
            local waterpenreal = waterpen * self.maxhealth / TUNING.EFFIGY_HEALTH_PENALTY
			-- round it to avoid microdifferences from division
			waterpenreal = math.floor(waterpenreal * 1000) *.001
			
            if self.waterpenalty ~= waterpenreal then
				-- self.penalty = self.penalty + (waterpenreal - self.waterpenalty)
                -- self.waterpenalty = waterpenreal
                -- self:DoDelta(0, nil, "resurrection_penalty")
				
                -- transition to new penalty
                local NUMSTEPS = 10
                local penstep = (waterpenreal - self.waterpenalty) / NUMSTEPS
                if self.waterpentask then
                    self.waterpentask:Cancel()
                end
                -- new periodic task, takes 6 seconds to finish 
                self.waterpentask = self.inst:DoPeriodicTask(6/NUMSTEPS, function()
                    self.penalty = self.penalty + penstep
                    self.waterpenalty = self.waterpenalty + penstep
                    self:DoDelta(0, nil, "resurrection_penalty")
                end, 0)
                self.waterpentask.limit = NUMSTEPS
                self.waterpentask.onfinish = function()
                    self.waterpentask = nil
                end
            end
        end
    end
end