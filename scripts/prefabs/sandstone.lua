local assets=
{
	Asset("ANIM", "anim/sand.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("sand")
    inst.AnimState:SetBuild("sand")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 0.5
    inst:AddComponent("tradable")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "sand"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sand.xml"

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "sand"
	inst.components.repairer.healthrepairvalue = TUNING.REPAIR_ROCKS_HEALTH
	
	inst:AddComponent("cookable")
    inst.components.cookable.product = "glass_chunk"

    return inst
end

return Prefab( "common/inventory/sandstone", fn, assets) 
