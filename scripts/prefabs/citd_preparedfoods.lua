local function MakePreparedFood(data)

	local assets=
	{
		--Asset("ANIM", "anim/cook_pot_food.zip"),
	}
	
	local prefabs = 
	{
		"spoiled_food",
	}
	
	local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBuild(data.name)
		inst.AnimState:SetBank(data.name)
		inst.AnimState:PlayAnimation("BUILD", false)
		inst.AnimState:SetScale(1.5,1.5,1.5)
	    
	    inst:AddTag("preparedfood")

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.health or 0
		inst.components.edible.hungervalue = data.hunger or 0
		inst.components.edible.foodtype = data.foodtype or "GENERIC"
		inst.components.edible.sanityvalue = data.sanity or 0
		inst.components.edible.oneaten = data.oneaten

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = data.name
		inst.components.inventoryitem.atlasname = "images/inventoryimages/food/"..data.name..".xml"
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(data.perishtime or TUNING.PERISH_SLOW)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
	    
        MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)   

		inst:AddComponent("bait")
		inst:AddComponent("tradable")
	    
		return inst
	end

	return Prefab( "common/inventory/"..data.name, fn, assets, prefabs)
end


local prefs = {}

local foods = require "citdcooking"
for k,v in pairs(foods) do
	table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs) 
