local assets=
{
	Asset("ANIM", "anim/jelly_cap.zip"),
}

local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("jelly_cap")
    inst.AnimState:SetBuild("jelly_cap")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = -15
    inst.components.edible.hungervalue = 0
	inst.components.edible.sanityvalue = 0
	
    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "jelly_cap"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/jelly_cap.xml"

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

return Prefab( "common/inventory/jelly_cap", fn, assets) 
