local assets =
{
    Asset("ANIM", "anim/tree_marsh.zip"),
}

local prefabs =
{
    "log",
    "twigs",
}

local loot = 
{
	"log",
	"log",
	"twigs",
	"twigs",
	"twigs",
}

local function sway(inst)
    inst.AnimState:PushAnimation("sway"..math.random(4).."_loop", true)
end

local function chop_tree(inst, chopper, chops)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
    inst.AnimState:PlayAnimation("chop")
	
    sway(inst)
end

local function chop_down_tree(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")

    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local shadow = inst.entity:AddDynamicShadow()
    local sound = inst.entity:AddSoundEmitter()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "marshtree.png" )
    minimap:SetPriority(-1)

    MakeObstaclePhysics(inst, .25)   
    inst:AddTag("underwater")
    
    inst:AddComponent("lootdropper") 
    inst.components.lootdropper:SetLoot(loot)
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    anim:SetBuild("tree_marsh")
    anim:SetBank("marsh_tree")
    local color = 0.5 + math.random() * 0.5
    anim:SetMultColour(color, color, color, 1)
    sway(inst)
    anim:SetTime(math.random()*2)
    
    inst:AddComponent("inspectable")
    
    MakeSnowCovered(inst, .01)
	
    return inst
end

return Prefab( "underwater/objects/rotting_trunk", fn, assets) 