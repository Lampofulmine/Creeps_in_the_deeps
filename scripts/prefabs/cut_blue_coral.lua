local assets =
{
	Asset("ANIM", "anim/coral_blue_ground.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)
     
       
    inst.AnimState:SetBank("coral_blue_ground")
    inst.AnimState:SetBuild("coral_blue_ground")
    inst.AnimState:PlayAnimation("anim")

    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "cut_blue_coral"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cut_blue_coral.xml"
    
    return inst
end

return Prefab( "common/inventory/cut_blue_coral", fn, assets) 
