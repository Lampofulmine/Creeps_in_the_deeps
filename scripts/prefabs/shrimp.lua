require "stategraphs/SGshrimp"
require "brains/shrimpbrain"

local assets =
{
	Asset("ANIM", "anim/shrimp.zip"),
	--Asset("SOUND", "sound/shrimp.fsb"),
}
 
local prefabs =
{
	"shrimp_tail",
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.Transform:SetTwoFaced()
    MakeGhostPhysics(inst, 1, .5)

    local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .5 )
    
    local brain = require "brains/shrimpbrain"
    inst:SetBrain(brain)
    
    anim:SetBank("shrimp")
    anim:SetBuild("shrimp")
    
    inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("shrimp")
	inst:AddTag("underwater")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 7
    
    inst:SetStateGraph("SGshrimp")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(20)

    inst:AddComponent("combat")
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"shrimp_tail"}) 
    inst.components.lootdropper:AddChanceLoot("salt", 0.1)

	inst:AddComponent("knownlocations")   
    inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)
	
	
	

    return inst
end

return Prefab( "common/monsters/shrimp", fn, assets) 
