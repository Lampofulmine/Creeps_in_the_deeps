require "brains/mermbrain"
require "stategraphs/SGmerm"

local assets=
{
	Asset("ANIM", "anim/merm_build.zip"),
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
	Asset("SOUND", "sound/merm.fsb"),
}

local prefabs =
{
    "fish",
    "froglegs",
}

local loot = 
{
    "fish",
    "froglegs",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function ontalk(inst, script)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/idle")
end

local function ShouldAcceptItem(inst, item)
    if inst.components.sleeper:IsAsleep() then
        return false
    end

    if item and item.prefab == "goldnugget" then
        return true
    end   
end

local function OnGetItemFromPlayer(inst, giver, item)  
	if item and item.prefab == "goldnugget" then
		if inst.components.combat.target and inst.components.combat.target == giver then
			inst.components.combat:SetTarget(nil)
		elseif giver.components.leader then
			inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
			giver.components.leader:AddFollower(inst)
			inst.components.follower:AddLoyaltyTime(200)
		end
	end
	
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function ShouldSleep(inst)
    return not GetClock():IsDay()
           and not (inst.components.combat and inst.components.combat.target)
           and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           and not (inst.components.burnable and inst.components.burnable:IsBurning() )
           and not (inst.components.freezable and inst.components.freezable:IsFrozen() )
end

local function ShouldWake(inst)
    return GetClock():IsDay()
           or (inst.components.combat and inst.components.combat.target)
           or (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           or (inst.components.burnable and inst.components.burnable:IsBurning() )
           or (inst.components.freezable and inst.components.freezable:IsFrozen() )
end

local function RetargetFn(inst)
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST then
        defenseTarget = home
    end
    local invader = FindEntity(defenseTarget or inst, TUNING.MERM_TARGET_DIST, function(guy)
        return guy:HasTag("character") and not guy:HasTag("merm")
    end)
    return invader
end
local function KeepTargetFn(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home then
        return home:GetDistanceSqToInst(target) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
               and home:GetDistanceSqToInst(inst) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
    end
    return inst.components.combat:CanTarget(target)     
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    if attacker and inst.components.combat:CanTarget(attacker) then
        inst.components.combat:SetTarget(attacker)
        local targetshares = MAX_TARGET_SHARES
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= SHARE_TARGET_DIST*SHARE_TARGET_DIST then
                targetshares = targetshares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude)
                return dude.components.homeseeker
                       and dude.components.homeseeker.home
                       and dude.components.homeseeker.home == home
            end, targetshares)
        end
    end
end

local function onsave(inst, data)
	if inst.hat_assigned then
		data.hat_assigned = inst.hat_assigned
	end
end

local function onload(inst, data)
    if data and data.hat_assigned then
        inst.hat_assigned = data.hat_assigned
	end
end

local function common(merm_type, n)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .75 )
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 50, .5)

    anim:SetBank("pigman")
    anim:SetBuild("merm_build")
    
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.MERM_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.MERM_WALK_SPEED
    
    inst:SetStateGraph("SGmerm")
    anim:Hide("hat")

    inst:AddTag("character")
    inst:AddTag("merm")
    inst:AddTag("wet")
	inst:AddTag("underwater")
	inst:AddTag("civilised")
	inst:AddTag(merm_type)
	
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)
    --inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
	
	inst:AddComponent("follower")
	
	inst:AddComponent("talker")
	inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.talker.offset = Vector3(0,-400,0)
	
    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
    
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")

    inst:ListenForEvent("attacked", OnAttacked)

	-- Guards don't have names
	if merm_type and n then
		inst:AddComponent("named")
		local name_lists = STRINGS.MERMNAMES[string.upper(merm_type)]
		inst.components.named.possiblenames = name_lists[n]
		inst.components.named:PickNewName()
	end
	
	inst.OnSave = onsave
	inst.OnLoad = onload
	
    return inst
end

local function merm_noble()
	local n = math.random(2)
	local inst = common("merm_noble", n)
	
	if not inst.hat_assigned then
		local item = nil
		if n == 1 then
			item = SpawnPrefab("tophat")
		else
			item = SpawnPrefab("flowerhat")
		end
		
		if item then
			item.persists = false
			inst.components.inventory:Equip(item)
			inst.AnimState:Show("hat")
			item.components.inventoryitem:SetOnDroppedFn(function() item:Remove() end)
			inst.hat_assigned = true
		end
	end
	
	local brain = require "brains/mermnoblebrain"
	local brain = require "brains/civilisedmermbrain"
    inst:SetBrain(brain)
	
	return inst
end

local function merm_worker()

	local n = math.random(2)
	local inst = common("merm_worker", n)

	if not inst.hat_assigned then
		local item = nil
		item = SpawnPrefab("strawhat")
		
		if item then
			item.persists = false
			inst.components.inventory:Equip(item)
			inst.AnimState:Show("hat")
			item.components.inventoryitem:SetOnDroppedFn(function() item:Remove() end)
			inst.hat_assigned = true
		end
	end
	
	local brain = require "brains/mermworkerbrain"
	local brain = require "brains/civilisedmermbrain"
    inst:SetBrain(brain)
	
	return inst
end

local function merm_guard()
	local inst = common("merm_guard")

	if not inst.hat_assigned then
		local item = SpawnPrefab("footballhat")
		if item then
			item.persists = false
			inst.components.inventory:Equip(item)
			inst.AnimState:Show("hat")
			item.components.inventoryitem:SetOnDroppedFn(function() item:Remove() end)
			inst.hat_assigned = true
		end
	end
	
	local brain = require "brains/mermguardbrain"
	local brain = require "brains/civilisedmermbrain"
    inst:SetBrain(brain)
	
	return inst
end

return Prefab("underwater/animals/mermnoble", merm_noble, assets, prefabs),
		Prefab("underwater/animals/mermworker", merm_worker, assets, prefabs), 
		Prefab("underwater/animals/mermguard", merm_guard, assets, prefabs) 
