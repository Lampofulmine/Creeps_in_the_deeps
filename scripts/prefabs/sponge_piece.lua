local assets =
{
	Asset("ANIM", "anim/sponge_piece.zip"),
	Asset( "IMAGE", "images/inventoryimages/sponge_piece.tex" ),
	Asset( "ATLAS", "images/inventoryimages/sponge_piece.xml" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
       
    anim:SetBank("sponge_piece")
    anim:SetBuild("sponge_piece")
    anim:PlayAnimation("anim")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sponge_piece"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sponge_piece.xml"
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = "SPONGE"
    
    return inst
end

return Prefab( "common/inventory/sponge_piece", fn, assets) 
