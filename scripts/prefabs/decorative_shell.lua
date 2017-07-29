local assets =
{
	Asset("ANIM", "anim/decorative_shell.zip"),
}

local prefabs =
{
	"slurtle_shellpieces"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")	
	inst:Remove()
end

local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("decorative_shell")
    inst.AnimState:SetBuild("decorative_shell")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("lootdropper")
	--inst.components.lootdropper:SetLoot({"shell_fragment"})

    return inst
end

return Prefab( "common/inventory/decorative_shell", fn, assets) 
