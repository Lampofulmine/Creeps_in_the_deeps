require "behaviours/wander"
require "behaviours/runaway"
--require "behaviours/doaction"

local ShrimpBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local RUN_AWAY_DIST = 10
local STOP_RUN_AWAY_DIST = 20
local MAX_WANDER_DIST = 10


function ShrimpBrain:OnStart()

    local root = PriorityNode(
    {
        RunAway(self.inst, "scarytoprey", RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)        
    }, .25)
        
    self.bt = BT(self.inst, root)
end

return ShrimpBrain