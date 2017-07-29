local assets=
{
	Asset("ANIM", "anim/shrimp_tail.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("shrimp_tail")
    inst.AnimState:SetBuild("shrimp_tail")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "MEAT"
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 17
	inst.components.edible.sanityvalue = -5

    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "shrimp_tail"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/shrimp_tail.xml"
	
	inst.Transform:SetScale(0.80,0.80,0.80)
	
	inst:AddComponent("bait")
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

return Prefab( "common/inventory/shrimp_tail", fn, assets) 
