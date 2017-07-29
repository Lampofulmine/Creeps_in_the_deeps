require "stategraphs/SGsquid"
require "brains/squidbrain"

local assets =
{
	Asset("ANIM", "anim/squid.zip"),
	--Asset("SOUND", "sound/squid.fsb"),
}
 
local prefabs =
{
	"fish_fillet",
    "trinket_12"
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.Transform:SetTwoFaced()
    MakeGhostPhysics(inst, 1, .5)
    
    local brain = require "brains/squidbrain"
    inst:SetBrain(brain)
    
    anim:SetBank("squid")
    anim:SetBuild("squid")
    
    inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("squid")
	inst:AddTag("underwater")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.ABIGAIL_SPEED
    inst.components.locomotor.runspeed = TUNING.ABIGAIL_SPEED
    
    inst:SetStateGraph("SGsquid")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)

	inst:AddComponent("combat")
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"fish_fillet","trinket_12"}) 
	inst.components.lootdropper:AddChanceLoot("trinket_12", 0.7)
    inst.components.lootdropper:AddChanceLoot("salt", 0.2)

	inst:AddComponent("knownlocations")   
    inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)
	
	inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(2)

    return inst
end

return Prefab( "common/monsters/squid", fn, assets) 
