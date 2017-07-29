local assets=
{
	Asset("ANIM", "anim/pearl.zip"),
}

local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)

	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )    
	
    inst.AnimState:SetBank("pearl")
    inst.AnimState:SetBuild("pearl")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 2
	
    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "pearl"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/pearl.xml"
	
    return inst
end

return Prefab( "common/inventory/pearl", fn, assets) 
