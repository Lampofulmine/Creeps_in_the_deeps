local assets=
{
	Asset("ANIM", "anim/sea_petals.zip"),
}

local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sea_petals")
    inst.AnimState:SetBuild("sea_petals")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetScale(2,2,2)
	
    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "sea_petals"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sea_petals.xml"

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = 0
    inst.components.edible.foodtype = "VEGGIE"
    
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)

    return inst
end

return Prefab( "common/inventory/sea_petals", fn, assets) 
