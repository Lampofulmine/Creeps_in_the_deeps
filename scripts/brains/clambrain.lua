require "behaviours/standstill"
require "behaviours/useshield"

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8

local DAMAGE_UNTIL_SHIELD = 1
local SHIELD_TIME = 3
local AVOID_PROJECTILE_ATTACKS = true

local ClamBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= KEEP_FACE_DIST*KEEP_FACE_DIST and not target:HasTag("notarget")
end

function ClamBrain:OnStart()

    local root = PriorityNode(
    {
        UseShield(self.inst, DAMAGE_UNTIL_SHIELD, SHIELD_TIME, AVOID_PROJECTILE_ATTACKS),
		FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
    }, .25)
        
    self.bt = BT(self.inst, root)
end

return ClamBrain