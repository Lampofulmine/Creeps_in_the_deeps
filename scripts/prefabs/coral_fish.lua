require "stategraphs/SGcoralfish"
require "brains/coralfishbrain"

local assets =
{
	Asset("ANIM", "anim/coralfish.zip"),
}

local function OnAttacked(inst, data)
   --
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	
	inst.Transform:SetTwoFaced()
	local scale = 0.3333
    inst.Transform:SetScale(scale, scale, scale)
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .5 )
	
	MakeGhostPhysics(inst, 1, .5)
   
    local brain = require "brains/coralfishbrain"
    inst:SetBrain(brain)
    
    anim:SetBank("coralfish")
    anim:SetBuild("coralfish")
	
	inst:AddTag("underwater")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.ABIGAIL_SPEED*.6667
    inst.components.locomotor.runspeed = TUNING.ABIGAIL_SPEED*1.3333
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
	
    inst:SetStateGraph("SGcoralfish")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)

	inst:AddComponent("combat")
    inst:ListenForEvent("attacked", OnAttacked)
	
    inst:AddComponent("lootdropper")
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("herdmember")
    inst.components.herdmember.herdprefab = "coralfishschool"
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(2)

    return inst
end

return Prefab( "common/monsters/coralfish", fn, assets) 
