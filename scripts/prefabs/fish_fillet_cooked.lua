local assets=
{
	Asset("ANIM", "anim/fish_fillet.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("fish_fillet")
    inst.AnimState:SetBuild("fish_fillet")
    inst.AnimState:PlayAnimation("cooked")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "MEAT"
	inst.components.edible.healthvalue = 10
	inst.components.edible.hungervalue = 27
	inst.components.edible.sanityvalue = 0

    inst:AddComponent("tradable")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "fish_fillet_cooked"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fish_fillet_cooked.xml"
	
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

return Prefab( "common/inventory/fish_fillet_cooked", fn, assets) 
