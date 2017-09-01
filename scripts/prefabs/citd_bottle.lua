local assets = 
{
	Asset("ANIM", "anim/bubbles.zip"),
	Asset("ANIM", "anim/bubble_item.zip"),
}

local AIR = 1
local WATER = 2
local ICE = 3
local SetAir
local SetWater
local SetIce

-------------------------

local function canuse(inst)
	if GetWorld():IsUnderwater() then
		return inst.state == AIR
	-- else
		-- return inst.state == WATER
	end
end

local function onuse(inst)
    local player = GetPlayer()
    -- player.components.talker:Say(GetString(player.prefab, "ANNOUNCE_UNIMPLEMENTED"))
	if player and player.components.oxygen then
		inst.SoundEmitter:PlaySound("citd/common/bubble_pop")
		player.components.oxygen:DoDelta(UW_TUNING.BOTTLE_OXYGEN)
		SpawnAt("deathbubble_fx",player)
	end
	
	SetWater(inst)
	
    if inst.components.useableitem then
        inst.components.useableitem:StopUsingItem()
    end
end

local function makebottle(inst, fire, player)
	local prod = SpawnPrefab("citd_bottle")
	
	if prod and GetWorld().components.moisturemanager then
		GetWorld().components.moisturemanager:MakeEntityDry(prod)
	end
	
	local target = player or fire
	if target then
		if target.components.inventory then
			target.components.inventory:GiveItem(prod)
		else
			prod.Transform:SetPosition(target.Transform:GetWorldPosition())
		end
	end
	
	return prod
end
local function makeairbottle(inst, fire, player)
	makebottle(inst,fire,player).state = AIR
end
local function makewaterbottle(inst, fire, player)
	makebottle(inst,fire,player).state = WATER
end

------------------------- Set state

SetAir = function(inst)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bubble_item.xml"	
	inst.components.inventoryitem:ChangeImageName("bubble_item")
	inst.AnimState:PlayAnimation("idle")
	
	-- can be used in uw to restore oxygen and get waterbottle
	-- (handled by component)
	
	if inst.components.cookable then 
		inst:RemoveComponent("cookable")
	end
	if inst.components.smotherer then 
		inst:RemoveComponent("smotherer")
	end
	
    inst.state = AIR
end

SetWater = function(inst)
    inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"
	inst.components.inventoryitem:ChangeImageName("spear")
	inst.AnimState:PlayAnimation("idle")
	
	-- freeze if the bottle is icy cold
	inst:DoTaskInTime(3, function()
		if inst.components.temperature.current < 0 then
			SetIce(inst)
		end
	end)
	
	-- smotherer (just add the component, but requires edit to burnable component for callback)
	-- can be emptied on surface and makes wet?
	
	-- can be cooked to get salt and airbottle
	if not GetWorld():IsUnderwater() then
		if not inst.components.cookable then
			inst:AddComponent("cookable")
		end
		inst.components.cookable.product = "salt"
		inst.components.cookable:SetOnCookedFn(makeairbottle)
	elseif inst.components.cookable then 
		inst:RemoveComponent("cookable")
	end
	
    inst.state = WATER
end

SetIce = function(inst)
    inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"
	inst.components.inventoryitem:ChangeImageName("ice")
	inst.AnimState:PlayAnimation("idle")
	
	-- can be mined to get ice (RoG only)
	
	-- can be thawed faster by cooking
	if not inst.components.cookable then
		inst:AddComponent("cookable")
	end
	inst.components.cookable.product = nil
	inst.components.cookable:SetOnCookedFn(makewaterbottle)
	
    inst.state = ICE
end

-------------------------

local function applystate(inst)
	if not inst.state then
		inst.state = GetWorld():IsUnderwater() and WATER or AIR
	end
	if inst.state == ICE then
		SetIce(inst)
	elseif inst.state == WATER then
		SetWater(inst)
	else
		SetAir(inst)
	end
end

local function onload(inst, data)
	inst.state = data.state or inst.state
end
local function onsave(inst, data)
	data.state = inst.state
end

local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("bubble_item")
    inst.AnimState:SetBuild("bubble_item")

    MakeInventoryPhysics(inst)
    
	inst:AddTag("bubble") --for eat state (sounds)
	inst:AddTag("bottle")
	
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "bubble_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bubble_item.xml"

	inst:AddComponent("temperature")
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_SMALL
	inst:ListenForEvent("startfreezing", SetIce)
    inst:ListenForEvent("stopfreezing", SetWater)
	
	-- This is not the ideal choice of component, but it'll do
    inst:AddComponent("useableitem")
    -- inst.components.useableitem.verb = "OPEN"
    inst.components.useableitem:SetCanInteractFn(canuse)
    inst.components.useableitem:SetOnUseFn(onuse)
	
	inst.OnLoad = onload
	inst.OnSave = onsave
	
	inst:DoTaskInTime(0, applystate)
	
    return inst
end


return Prefab("citd_bottle", fn, assets)