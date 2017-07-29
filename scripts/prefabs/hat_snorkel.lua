local assets =
{
	Asset("ANIM", "anim/snorkel.zip"),
	
   	Asset("IMAGE", "images/inventoryimages/snorkel.tex"),
	Asset("ATLAS", "images/inventoryimages/snorkel.xml"),
}

-- On equip
local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_hat", "snorkel", "swap_hat")
	owner.AnimState:Show("HAT")
	owner.AnimState:Show("HAT_HAIR")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")
	
	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Show("HEAD_HAIR")
	end
	
	if owner.components.health then -- for robots
		owner:DoTaskInTime(0, function(wilson)
			wilson.components.health:RecalculatePenalty()
		end)
	end
	
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()        
	end
end

-- On unequip
local function onunequip(inst, owner)
	owner.AnimState:Hide("HAT")
	owner.AnimState:Show("HAT_HAIR")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")

	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Show("HEAD_HAIR")
	end
	
    if owner.components.health then -- for robots
		owner:DoTaskInTime(0, function(wilson)
			wilson.components.health:RecalculatePenalty()
		end)
	end

	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)

	-- Anim
	inst.AnimState:SetBank("snorkel")
	inst.AnimState:SetBuild("snorkel")
	inst.AnimState:PlayAnimation("anim")

	-- Tags
	inst:AddTag("hat")

	-- Misc components
	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	
	-- Inventory item
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "snorkel"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/snorkel.xml"

	-- Equippable
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)

	-- Fueled
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = "USAGE"
	inst.components.fueled:InitializeFuelLevel(UW_TUNING.HAT_SNORKEL_PERISHTIME)
	inst.components.fueled:SetDepletedFn(function() inst:Remove() end)
	
	-- Oxygen
	inst:AddComponent("oxygenapparatus")
	inst.components.oxygenapparatus:SetReductionPercentage(UW_TUNING.HAT_SNORKEL_PERCENTAGE)
	
	return inst
end

return Prefab( "common/inventory/snorkel", fn, assets)