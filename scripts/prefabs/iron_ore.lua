local assets=
{
	Asset("ANIM", "anim/iron_ore.zip"),
}

local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("iron_ore")
    inst.AnimState:SetBuild("iron_ore")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 2
	
    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "iron_ore"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/iron_ore.xml"

    return inst
end

return Prefab( "common/inventory/iron_ore", fn, assets) 
