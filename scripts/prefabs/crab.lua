require "brains/crabbrain"
require "stategraphs/SGcrab"

-- Assets
local assets =
{
	Asset("ANIM", "anim/crabbit_build.zip"),
	Asset("ANIM", "anim/crabbit_beardling_build.zip"),
	Asset("ANIM", "anim/beardling_crabbit.zip"),

	Asset("ANIM", "anim/crabbit.zip"),
    Asset("SOUND", "sound/rocklobster.fsb"),
}

local prefabs = {}

local colours =
{
    {1,1,1},
    --{174/255,158/255,151/255},
    {167/255,180/255,180/255},
    {159/255,163/255,146/255}
}

----------------------------------------

-- Sleeping functions
local function ShouldSleep(inst)
    return inst.components.sleeper:GetTimeAwake() > TUNING.TOTAL_DAY_TIME*2
end

local function ShouldWake(inst)
    return inst.components.sleeper:GetTimeAsleep() > TUNING.TOTAL_DAY_TIME*.5
end

-- Combat functions
local function OnAttacked(inst, data)
    if inst.components.growable.stage == 1 then
		local x,y,z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, 30, {'tinycrab'})
		
		local num_friends = 0
		local maxnum = 5
		for k,v in pairs(ents) do
			v:PushEvent("gohome")
			num_friends = num_friends + 1
			
			if num_friends > maxnum then
				break
			end
		end
	
	else	
		local attacker = data.attacker
		inst.components.combat:SetTarget(attacker)
		--inst.components.combat:ShareTarget(attacker, 20, function(dude) return dude.prefab == inst.prefab end, 2)
	end	
end

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function retargetfn(inst)
	if inst.components.growable.stage <= 2 then
		return
	end
	
    local dist = UW_TUNING.CRAB_TARGET_DIST
    return FindEntity(inst, dist, function(guy) 
		return not guy:HasTag("crab") and inst.components.combat:CanTarget(guy)
    end)
end

local function KeepTarget(inst, target)
	if inst.components.growable.stage == 1 then
		return
	end
	
    return inst.components.combat:CanTarget(target)
end

-- Loot
local tinyloot = {"smallmeat"}
local smallloot = {"meat","slurtle_shellpieces"}
local mediumloot = {"meat","meat","slurtle_shellpieces","slurtle_shellpieces"}
local largeloot = {"meat","meat","meat","slurtle_shellpieces","slurtle_shellpieces","slurtle_shellpieces"}

-- Growth functions
local function Grow(inst)
    if inst.components.sleeper:IsAsleep() then
        inst.sg:GoToState("wake")
	end
	
	if inst.components.locomotor then
		inst.components.locomotor:Stop()
	end
	
	inst.components.growable:SetStage(inst.components.growable:GetNextStage())
end

local function GetGrowTime()
    return GetRandomWithVariance(UW_TUNING.CRAB_GROW_TIME.base, UW_TUNING.CRAB_GROW_TIME.random)
end

local function SetTiny(inst)
	local scale = 1
	inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(tinyloot)
    inst.components.sleeper:SetResistance(1)
	inst.components.locomotor.walkspeed = UW_TUNING.TINYCRAB_WALK_SPEED
	
	inst.components.combat:SetDefaultDamage(UW_TUNING.TINYCRAB_DAMAGE)
    local percent = inst.components.health:GetPercent()
    inst.components.health:SetMaxHealth(UW_TUNING.TINYCRAB_HEALTH)
    inst.components.health:SetPercent(percent)
	
	inst:AddTag("prey")
	inst:AddTag("smallcreature")
	inst:AddTag("canbetrapped")  
	inst:AddTag("tinycrab")
	inst:RemoveTag("scarytoprey")
end

local function SetSmall(inst)
	local scale = 1.2
	inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(smallloot)
    inst.components.sleeper:SetResistance(2)
	inst.components.locomotor.walkspeed = UW_TUNING.SMALLCRAB_WALK_SPEED
	
	inst.components.combat:SetDefaultDamage(UW_TUNING.SMALLCRAB_DAMAGE)
    local percent = inst.components.health:GetPercent()
    inst.components.health:SetMaxHealth(UW_TUNING.SMALLCRAB_HEALTH)
    inst.components.health:SetPercent(percent)
	
	if inst.components.homeseeker and inst.components.homeseeker.home and inst.components.homeseeker.home.components.spawner then
		inst.components.homeseeker.home.components.spawner:OnChildKilled(inst)
		inst:RemoveComponent("homeseeker")
	end
	
	local brain = require "brains/crabbrain"
	inst:SetBrain(brain)
	inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)
	
	inst:RemoveTag("prey")
	inst:RemoveTag("smallcreature")
	inst:RemoveTag("canbetrapped")  
	inst:RemoveTag("tinycrab")
	inst:AddTag("scarytoprey")
end

local function SetMedium(inst)
	local scale = 1.4
	inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(mediumloot)
    inst.components.sleeper:SetResistance(3)
	inst.components.locomotor.walkspeed = UW_TUNING.MEDIUMCRAB_WALK_SPEED
	
	inst.components.combat:SetDefaultDamage(UW_TUNING.MEDIUMCRAB_DAMAGE)
    local percent = inst.components.health:GetPercent()
    inst.components.health:SetMaxHealth(UW_TUNING.MEDIUMCRAB_HEALTH)
    inst.components.health:SetPercent(percent)
end

local function SetLarge(inst)
    local scale = 2
	inst.Transform:SetScale(scale, scale, scale)
    inst.components.lootdropper:SetLoot(largeloot)
    inst.components.sleeper:SetResistance(4)
	inst.components.locomotor.walkspeed = UW_TUNING.LARGECRAB_WALK_SPEED
	
	inst.components.combat:SetDefaultDamage(UW_TUNING.LARGECRAB_DAMAGE)
    local percent = inst.components.health:GetPercent()
    inst.components.health:SetMaxHealth(UW_TUNING.LARGECRAB_HEALTH)
    inst.components.health:SetPercent(percent)
end

local function SetDead(inst)
	print("Crab has died of old age!")
	inst.components.lootdropper:SetLoot({})
    inst.components.health:Kill()
end

local growth_stages =
{
    {name="tiny", time = GetGrowTime, fn = SetTiny},
    {name="small", time = GetGrowTime, fn = SetSmall, growfn = Grow},
    {name="medium", time = GetGrowTime, fn = SetMedium, growfn = Grow},
    {name="large", time = GetGrowTime, fn = SetLarge, growfn = Grow},
	{name="dead", time = GetGrowTime, fn = SetDead, growfn = Grow},
}

-- On save
local function onsave(inst,data)
    data.colour = inst.colour_idx
end

-- On load
local function onload(inst,data)
    if data and data.colour and data.colour > 0 and data.colour <= #colours then
        inst.colour_idx = data.colour
        inst.AnimState:SetMultColour(colours[inst.colour_idx][1],colours[inst.colour_idx][2],colours[inst.colour_idx][3],1)
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	
	-- Physics
	MakeCharacterPhysics(inst, 200, 1)
	
	-- Colour
    inst.colour_idx = math.random(#colours)
    inst.AnimState:SetMultColour(colours[inst.colour_idx][1],colours[inst.colour_idx][2],colours[inst.colour_idx][3],1)
	
	-- Anim
	anim:SetBank("crabbit")
	anim:SetBuild("crabbit_build")
	anim:PlayAnimation("idle", true)
	inst.Transform:SetFourFaced()
	
	-- Tags
    inst:AddTag("crab")
    inst:AddTag("animal")
	inst:AddTag("underwater")
	inst:AddTag("scarytoprey")
	inst:AddTag("prey")
    inst:AddTag("smallcreature")
    inst:AddTag("canbetrapped")  
	
	-- Combat
    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(1)
    inst.components.combat:SetRange(2)
    inst.components.combat:SetDefaultDamage(UW_TUNING.TINYCRAB_DAMAGE)
	inst.components.combat:SetRetargetFunction(1, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("newcombattarget", OnNewTarget)
	
	-- Shadow
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( 1.25, 1 )
    
	-- Loot dropper
    inst:AddComponent("lootdropper")

	-- Sleeper
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)

	-- Health
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(UW_TUNING.TINYCRAB_HEALTH)

	-- Inspectable
	inst:AddComponent("inspectable")
	
	-- Eater
    inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
	
	-- Locomotor
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = TUNING.TINYCRAB_WALK_SPEED
	
	-- Growable
	inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable.growonly = true
    inst.components.growable:SetStage(1)
    inst.components.growable:StartGrowing()
	
	-- Entering and exiting limbo
	inst:ListenForEvent("enterlimbo", function() inst.components.growable:Pause() end)
	inst:ListenForEvent("exitlimbo", function() inst.components.growable:Resume() end)
	
	inst:DoTaskInTime(0, function() 
		if inst:HasTag("INLIMBO") then
			inst.components.growable:Pause()
		end
	end)
	
	-- Known locations
    inst:AddComponent("knownlocations")

	-- Brain / SG functions
	local brain = nil
	if inst.components.growable.stage == 1 then
		brain = require "brains/babycrabbrain"
	else
		brain = require "brains/crabbrain"
		inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)	
	end
	
    inst:SetBrain(brain)
	inst:SetStateGraph("SGcrab")

	-- Save / load functions
    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("underwater/monsters/crab", fn, assets, prefabs)
