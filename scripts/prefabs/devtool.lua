local assets=
{
	Asset("ANIM", "anim/axe.zip"),
	Asset("ANIM", "anim/goldenaxe.zip"),
	Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/swap_goldenaxe.zip"),
}

local function onfinished(inst)
    inst:Remove()
end

local isRogEnabled = IsDLCEnabled and IsDLCEnabled(1)

local function giveitems(inst, data)
    if data.owner.components.inventory and data.recipe then
      for ik, iv in pairs(data.recipe.ingredients) do
            if not data.owner.components.inventory:Has(iv.type, iv.amount) then
                for i = 1, iv.amount do
                    local item = SpawnPrefab(iv.type)
                    data.owner.components.inventory:GiveItem(item)
                end
            end
        end
    end
end

local function HeatFn(inst, observer)
	if GetPlayer().components.temperature:GetCurrent() < 15 then
	return 100
	end
	if GetPlayer().components.temperature:GetCurrent() > TUNING.OVERHEAT_TEMP-10 then
	return -100
	end
	return 0
end

local function onequipgold(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_goldenaxe", "swap_goldenaxe")
    owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")     
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    inst.Light:Enable(true)
    inst.task = inst:DoPeriodicTask(0.25, function() 
        if owner.components.health then
            owner.components.health:DoDelta(500)
        end

        if owner.components.hunger then
            owner.components.hunger:DoDelta(500)
        end

        if owner.components.thirst then
            owner.components.thirst:DoDelta(500)
        end
    end)
    inst.prev_hungerrate = owner.components.hunger.hungerrate
    inst.prev_thirstrate = owner.components.thirst.thirstrate
    owner.components.hunger:SetRate(0)
    owner.components.thirst:SetRate(0)
    owner:ListenForEvent("cantbuild", giveitems)

    --owner.components.combat:SetAreaDamage(10, 1)--That's a bit too dangerous
end

local function GetPoints(pt)
    local points = {}
    local radius = 0.5
    for i = 1, 2 do
        local theta = 0     
        local circ = 2*PI*radius
        local numPoints = math.ceil(circ * .25)
        for p = 1, numPoints do
            if not points[i] then
                points[i] = {}
            end
            local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
            local point = pt + offset
            table.insert(points[i], point)
            theta = theta - (2*PI/numPoints)
        end
        radius = radius + 1.5
    end
    return points
end

local function onattacked(inst, owner, targer)
    local fx = SpawnPrefab("groundpoundring_fx")
    fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
    fx.Transform:SetScale(0.5,0.5,0.5)
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
    local points = GetPoints(owner:GetPosition())
    print(points)
    for k,v in ipairs(points) do
        for j,x in ipairs(v) do
            inst:DoTaskInTime(0.2 * (k-1), function() SpawnPrefab("groundpound_fx").Transform:SetPosition(x:Get()) end)
        end
    end
end

local function onunequip(inst, owner) 
    inst.Light:Enable(false)
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 

    if inst.task then
        inst.task:Cancel()
        inst.task = nil
    end
    owner.components.hunger:SetRate(inst.prev_hungerrate or TUNING.WILSON_HUNGER_RATE)
    owner.components.thirst:SetRate(inst.prev_thirstrate or 5/30)
    owner:RemoveEventCallback("cantbuild", giveitems)

    --owner.components.combat.areahitrange = nil
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("axe")
    anim:SetBuild("goldenaxe")
    anim:PlayAnimation("idle")
    
    inst:AddTag("sharp")
    
    -----

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("goldenaxe")

    --if BRANCH == "dev" then
        inst:AddComponent("weapon")
        inst.components.weapon:SetRange(10) 
        inst.components.weapon:SetDamage(10000)
        --inst.components.weapon:SetDamage(10)
        --inst.components.weapon.onattack = onattacked

        inst:AddComponent("heater")
		
		if not isRogEnabled then
		inst.components.heater.carriedheat = math.huge
		inst.components.heater.equippedheat = math.huge
		else
        inst.components.heater.heatfn = HeatFn
		inst.components.heater.carriedheatfn = HeatFn
		inst.components.heater.equippedheatfn = HeatFn
		end
		
        inst:AddComponent("blinkstaff")

        inst:AddComponent("tool")
        inst.components.tool:SetAction(ACTIONS.CHOP, 100)
        inst.components.tool:SetAction(ACTIONS.MINE, 100)
        inst.components.tool:SetAction(ACTIONS.HAMMER)
        inst.components.tool:SetAction(ACTIONS.DIG, 100)
        inst.components.tool:SetAction(ACTIONS.NET)

        inst.entity:AddLight()
        inst.Light:SetColour(255/255,255/255,192/255)
        inst.Light:SetIntensity(.8)
        inst.Light:SetRadius(5)
        inst.Light:SetFalloff(.33)

        inst:AddComponent("prototyper")
        inst.components.prototyper.trees = {SCIENCE = 100, MAGIC = 100, ANCIENT = 100}
        inst:AddTag("prototyper")

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip( onequipgold )  
        inst.components.equippable:SetOnUnequip( onunequip)
        inst.components.equippable.walkspeedmult = 2

        if isRogEnabled then
            inst.components.equippable.dapperness = math.huge
        else
        inst:AddComponent("dapperness")
        inst.components.dapperness.dapperness = math.huge
        end
    --else
        --inst:Remove()
    --end
    
    return inst
end

return Prefab( "common/inventory/devtool", fn, assets)
