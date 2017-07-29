local assets = 
    {
        Asset("ANIM", "anim/bubbles.zip"),
        Asset("ANIM", "anim/bubble_item.zip"),
    }

--------

local function fx()
  	local inst = CreateEntity()
   	inst.entity:AddTransform()
   	inst.entity:AddAnimState()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("bubbles")
    inst.AnimState:SetBuild("bubbles")

    local anims = {"bubble_small", "bubble_medium", "bubble_large"}

    inst.AnimState:PlayAnimation(anims[math.random(#anims)])

    inst:AddTag("FX")
    inst.persists = false

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fx_small()
  	local inst = CreateEntity()
   	inst.entity:AddTransform()
   	inst.entity:AddAnimState()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("bubbles")
    inst.AnimState:SetBuild("bubbles")

    inst.AnimState:PlayAnimation("bubble_small")

    inst:AddTag("FX")
    inst.persists = false

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

--------

local function onfloated(inst)
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("inspectable")
    inst:AddTag("FX")
    inst.persists = false
    inst.AnimState:PlayAnimation("bubble_float")
    inst.stopfloating(inst)
    inst:ListenForEvent("animover", inst.Remove)
end

local function startfloating(inst)
	inst.AnimState:PlayAnimation("bubble_pickable")
	if GetWorld():IsUnderwater() then
		inst:ListenForEvent("animover", inst.onfloated)
	elseif not inst.components.inventoryitem.owner then
		inst:DoTaskInTime(1, function()
			inst.SoundEmitter:PlaySound("citd/common/bubble_pop")
			inst:Remove()
		end)
	end
end

local function stopfloating(inst)
	inst:RemoveEventCallback("animover", inst.onfloated)
end

local function oneaten(inst, eater)
	if eater and eater.components.oxygen then
		eater.components.oxygen:DoDelta(UW_TUNING.BUBBLE_OXYGEN_AMOUNT)
	end
end

local function onperish(inst)
	inst:Remove()
end

local function item()

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("bubble_item")
    inst.AnimState:SetBuild("bubble_item")

    MakeInventoryPhysics(inst)
    
	inst:AddTag("bubble")
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "bubble_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bubble_item.xml"

    inst.startfloating = startfloating
    inst.stopfloating = stopfloating
    inst.onfloated = onfloated

    inst.components.inventoryitem:SetOnPutInInventoryFn(inst.stopfloating)
    inst:ListenForEvent("ondropped", inst.startfloating)
    
	-- Give the world time to load
	inst:DoTaskInTime(0, function() inst:startfloating() end)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY)
    inst.components.perishable:SetOnPerishFn(onperish)
	inst.components.perishable:StartPerishing()
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
	inst.components.edible.sanityvalue = 0
	inst.components.edible:SetOnEatenFn(oneaten)

    return inst
end

--------

local function offset()
    return math.random(-60, 60)*0.01
end

local function pack()
    local prefs = {"bubble_fx", "bubble_item"}

    local inst = CreateEntity()
    inst.entity:AddTransform() 
    inst:DoTaskInTime(0, function()
        for i = 0, 5 do
            SpawnPrefab(prefs[math.random(#prefs)]).Transform:SetPosition(inst:GetPosition().x+offset(), 0, inst:GetPosition().z+offset())
        end
    end)

    inst:DoTaskInTime(0, inst.Remove)

    return inst
end

local function deathbubble_fx()
    local inst = CreateEntity()
    inst.entity:AddTransform() 
	
	inst:AddTag("FX")
	inst:AddComponent("bubbleblower")
	inst.components.bubbleblower:RemoveOnFinish(true)
	
	inst.persists = false
	
	return inst
end

return Prefab("bubble_fx", fx, assets),
	Prefab("bubble_fx_small", fx_small, assets),
    Prefab("bubble_item", item, assets),
    Prefab("bubble_pack", pack),
	Prefab("deathbubble_fx", deathbubble_fx)