require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/useshield"

local CrabBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 16
local WANDER_DIST = 60
local SEE_BAIT_DIST = 20
local DAMAGE_UNTIL_SHIELD = 200
local AVOID_PROJECTILE_ATTACKS = true
local SHIELD_TIME = 5

local function EatFoodAction(inst)

    local target = FindEntity(inst, SEE_BAIT_DIST, function(item) return inst.components.eater:CanEat(item) and not item:HasTag("planted") and not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) end)
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
        return act
    end
end

function CrabBrain:OnStart()
	local root = PriorityNode(
	{
        UseShield(self.inst, DAMAGE_UNTIL_SHIELD, SHIELD_TIME, AVOID_PROJECTILE_ATTACKS),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
        DoAction(self.inst, EatFoodAction),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, WANDER_DIST)        
	} ,0.25)

	self.bt = BT(self.inst, root)

end

return CrabBrain