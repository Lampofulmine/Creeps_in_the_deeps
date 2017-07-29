local assets=
{
	Asset("ANIM", "anim/lavastone.zip"),
}

local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("lavastone")
    inst.AnimState:SetBuild("lavastone")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 2
	
    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "lavastone"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/lavastone.xml"

    return inst
end

return Prefab( "common/inventory/lavastone", fn, assets) 
