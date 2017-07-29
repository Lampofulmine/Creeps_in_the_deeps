require "behaviours/wander"

local SquidBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MAX_WANDER_DIST = 20
local SEE_FOOD_DIST = 10

local function EatFoodAction(inst)

    local target = FindEntity(inst, SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnValidGround() end)
    if target then
        return BufferedAction(inst, target, ACTIONS.EAT)
    end
end

function SquidBrain:OnStart()

    local root = PriorityNode(
    {
		DoAction(self.inst, function() return EatFoodAction(self.inst) end ),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)        
    }, .5)
        
    self.bt = BT(self.inst, root)
end

return SquidBrain