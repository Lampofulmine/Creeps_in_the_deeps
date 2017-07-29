local assets =
{
	Asset("ANIM", "anim/sea_cucumber.zip"),
	Asset( "IMAGE", "images/inventoryimages/sea_cucumber.tex" ),
	Asset( "ATLAS", "images/inventoryimages/sea_cucumber.xml" ),
}

local function StartSpoil(inst)
	inst.components.perishable:StartPerishing()
end
local function StopSpoil(inst)
	inst.components.perishable:StopPerishing()
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
   
    anim:SetBank("sea_cucumber")
    anim:SetBuild("sea_cucumber")
    anim:PlayAnimation("idle")
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "FISH"
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 20
	inst.components.edible.sanityvalue = -5


    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sea_cucumber"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/sea_cucumber.xml"

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:DoTaskInTime(0.1, function()
		if GetWorld():IsUnderwater() then
			StopSpoil(inst)
			inst:ListenForEvent("onpickup", StartSpoil)
			inst:ListenForEvent("ondropped", StopSpoil)
		else
			StartSpoil(inst)
		end
	end)
    
	
    return inst
end

return Prefab( "common/inventory/sea_cucumber", fn, assets) 
