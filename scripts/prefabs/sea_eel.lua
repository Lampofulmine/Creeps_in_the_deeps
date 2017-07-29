require "stategraphs/SGsea_eel"
require "brains/sea_eelbrain"

local MAX_CHASEAWAY_DIST = 40

local assets =
{
	Asset("ANIM", "anim/sea_eel.zip"),
}

local function Retarget(inst)
    local target = FindEntity(inst, TUNING.BISHOP_TARGET_DIST, function(guy)
            return (guy:HasTag("character") or guy:HasTag("prey") )
                   and not guy:HasTag("eel")
                   and inst.components.combat:CanTarget(guy)
    end)

	return target
end

local function KeepTarget(inst, target)
    local homePos = inst.components.knownlocations:GetLocation("home")
    local targetPos = Vector3(target.Transform:GetWorldPosition() )
    return homePos and distsq(homePos, targetPos) < MAX_CHASEAWAY_DIST*MAX_CHASEAWAY_DIST
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end
 
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.Transform:SetTwoFaced()
    MakeGhostPhysics(inst, 1, .5)
	
	inst.Transform:SetScale(0.3,0.3,0.3)
    
    local brain = require "brains/sea_eelbrain"
    inst:SetBrain(brain)
    
    anim:SetBank("sea_eel")
    anim:SetBuild("sea_eel")
    
    inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("eel")
	inst:AddTag("underwater")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.ABIGAIL_SPEED*4
    inst.components.locomotor.runspeed = TUNING.ABIGAIL_SPEED*6
    
    inst:SetStateGraph("SGsea_eel")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(UW_TUNING.SEA_EEL_HEALTH)

	inst:AddComponent("combat")
	inst.components.combat:SetRange(3.5)
	inst.components.combat:SetAttackPeriod(UW_TUNING.SEA_EEL_ATTACK_PERIOD)
	inst.components.combat:SetDefaultDamage(UW_TUNING.SEA_EEL_DAMAGE)
    inst.components.combat:SetRetargetFunction(3, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
    
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("knownlocations")   
    inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)
	
	inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(1)

    return inst
end

return Prefab( "common/monsters/sea_eel", fn, assets) 
