require "stategraphs/SGjellyfish"
require "brains/jellyfishbrain"

local assets =
{
	Asset("ANIM", "anim/jellyfish.zip"),
	--Asset("SOUND", "sound/jellyfish.fsb"),
}

local prefabs =
{
    "fish_fillet",
    "jelly_cap"
}

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30,function(dude)
        return dude:HasTag("jellyfish") and not dude:HasTag("player") and not dude.components.health:IsDead()
    end, 5)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
    local light = inst.entity:AddLight()
	inst.Transform:SetTwoFaced()
	local scale = 0.3333
    inst.Transform:SetScale(scale, scale, scale)
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .5 )
	
	MakeGhostPhysics(inst, 1, .5)
    
    light:SetIntensity(.4)
    light:SetRadius(.5)
    light:SetFalloff(.6)
    light:Enable(true)
    light:SetColour(180/255, 195/255, 225/255)
    
    local brain = require "brains/jellyfishbrain"
    inst:SetBrain(brain)
    
    anim:SetBank("jellyfish")
    anim:SetBuild("jellyfish")
    anim:SetBloomEffectHandle( "shaders/anim.ksh" )
    anim:SetFinalOffset(-2+math.random(1,10))
	
    inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("jellyfish")
	inst:AddTag("underwater")
	inst:AddTag("noauradamage")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.ABIGAIL_SPEED*.6667
    inst.components.locomotor.runspeed = TUNING.ABIGAIL_SPEED*1.3333
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
	
    inst:SetStateGraph("SGjellyfish")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(150)

	inst:AddComponent("combat")
    inst.components.combat.defaultdamage = TUNING.GHOST_DAMAGE
    inst.components.combat.playerdamagepercent = TUNING.GHOST_DMG_PLAYER_PERCENT
    inst:ListenForEvent("attacked", OnAttacked)
	
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"fish_fillet"}) 
	inst.components.lootdropper:AddChanceLoot("jelly_cap", 0.2)
    inst.components.lootdropper:AddChanceLoot("salt", 0.2)
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("herdmember")
    inst.components.herdmember.herdprefab = "jellyfishschool"
	
	inst:AddComponent("shockaura")
    inst.components.shockaura.radius = TUNING.GHOST_RADIUS*2
    inst.components.shockaura.tickperiod = TUNING.GHOST_DMG_PERIOD*2
	inst.components.shockaura:Enable(true)
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(2)

    return inst
end

return Prefab( "common/monsters/reef_jellyfish", fn, assets) 
