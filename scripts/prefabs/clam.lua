require "stategraphs/SGclam"
require "brains/clambrain"

local assets =
{
	Asset("ANIM", "anim/clam.zip"),
}

local prefabs =
{
	"fish_fillet",
	"pearl",
	"slurtle_shellpieces",
	"salt",
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()
	inst.Transform:SetTwoFaced()

	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("clam.tex")

    
	MakeObstaclePhysics(inst, 0.8, 1.2)
	inst.Transform:SetScale(0.7,0.7,0.7)
	
    local brain = require "brains/clambrain"
    inst:SetBrain(brain)
    
    anim:SetBank("clam")
    anim:SetBuild("clam")
    
    inst:AddTag("scarytoprey")
	inst:AddTag("clam")
	inst:AddTag("underwater")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 0
    inst.components.locomotor.runspeed = 0
    
    inst:SetStateGraph("SGclam")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(UW_TUNING.CLAM_HEALTH)

	inst:AddComponent("combat")
    
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"fish_fillet", "fish_fillet","slurtle_shellpieces","slurtle_shellpieces"}) 
	inst.components.lootdropper:AddChanceLoot("pearl", 0.5)
	inst.components.lootdropper:AddChanceLoot("salt", 0.2)

	--inst:AddComponent("sleeper")
	--inst.components.sleeper:SetResistance(2)
	
	inst:AddComponent("bubbleblower")

    return inst
end

return Prefab( "common/monsters/clam", fn, assets, prefabs) 
