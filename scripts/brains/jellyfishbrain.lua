require "behaviours/wander"

local JellyFishBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MAX_CHASE_TIME = 6
local MAX_WANDER_DIST = 20

function JellyFishBrain:OnStart()

    local root = PriorityNode(
    {
        ChaseAndAttack(self.inst, MAX_CHASE_TIME),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, MAX_WANDER_DIST)        
    }, .5)
        
    self.bt = BT(self.inst, root)
end

return JellyFishBrain