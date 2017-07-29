local assets=
{
	Asset("ANIM", "anim/seagrass_chunk.zip"),
}

local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("seagrass_chunk")
    inst.AnimState:SetBuild("seagrass_chunk")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetScale(2,2,2)

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = -15
    inst.components.edible.hungervalue = 2
	
    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "seagrass_chunk"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/seagrass_chunk.xml"

    return inst
end

return Prefab( "common/inventory/seagrass_chunk", fn, assets) 
