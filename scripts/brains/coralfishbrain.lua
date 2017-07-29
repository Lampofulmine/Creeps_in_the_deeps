require "behaviours/wander"

local CoralFishBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function CoralFishBrain:OnStart()

    local root = PriorityNode(
    {
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, MAX_WANDER_DIST)        
    }, .5)
        
    self.bt = BT(self.inst, root)
end

return CoralFishBrain