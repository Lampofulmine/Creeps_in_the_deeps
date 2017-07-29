local assets=
{
	Asset("ANIM", "anim/diving_suit_summer.zip"),
	Asset("ANIM", "anim/diving_suit_winter.zip"),
}

local function onperish(inst)
	inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", inst.prefab, "swap_body")
    inst.components.fueled:StartConsuming()
    if owner.components.health then -- for robots
		owner:DoTaskInTime(0, function(wilson)
			wilson.components.health:RecalculatePenalty()
		end)
	end
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
    if owner.components.health then -- for robots
		owner:DoTaskInTime(0, function(wilson)
			wilson.components.health:RecalculatePenalty()
		end)
	end
end

local function create_common(inst)
    
    MakeInventoryPhysics(inst)
    
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/trunksuit"

    inst:AddComponent("dapperness")
    inst.components.dapperness.dapperness = TUNING.DAPPERNESS_SMALL


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
	inst:AddComponent("insulator")
	
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "USAGE"
    inst.components.fueled:InitializeFuelLevel(TUNING.TRUNKVEST_PERISHTIME)
    inst.components.fueled:SetDepletedFn(onperish)
	
	inst:AddComponent("oxygenapparatus")
	
    
    return inst
end

local function create_summer()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("diving_suit_summer")
    inst.AnimState:SetBuild("diving_suit_summer")

    create_common(inst)

    inst.components.insulator.insulation = TUNING.INSULATION_SMALL

    if GetWorld():IsUnderwater() then
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
    end
    
	inst.components.oxygenapparatus:SetReductionPercentage(0.5)
	
	inst.components.inventoryitem.imagename = "diving_suit_summer"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/diving_suit_summer.xml"
    
	return inst
end

local function create_winter()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("diving_suit_winter")
    inst.AnimState:SetBuild("diving_suit_winter")

    create_common(inst)

    inst.components.insulator.insulation = TUNING.INSULATION_LARGE
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
	inst.components.oxygenapparatus:SetReductionPercentage(0.5)
	
	inst.components.inventoryitem.imagename = "diving_suit_winter"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/diving_suit_winter.xml"
    
	return inst
end

return Prefab( "common/inventory/diving_suit_summer", create_summer, assets),
		Prefab( "common/inventory/diving_suit_winter", create_winter, assets) 
