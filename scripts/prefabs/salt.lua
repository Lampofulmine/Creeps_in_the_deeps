local assets=
{
	Asset("ANIM", "anim/salt.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    inst.Transform:SetScale(1.3, 1.3, 1.3)
    inst.AnimState:SetBank("salt")
    inst.AnimState:SetBuild("salt")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
	inst.components.edible.healthvalue = -10
	inst.components.edible.hungervalue = -10
	inst.components.edible.sanityvalue = 3

    inst:AddComponent("tradable")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "salt"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/salt.xml"
	

    return inst
end

return Prefab( "common/inventory/salt", fn, assets) 
