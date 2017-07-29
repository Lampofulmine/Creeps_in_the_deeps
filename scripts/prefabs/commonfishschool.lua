local assets =
{
    --Asset("ANIM", "anim/arrow_indicator.zip"),
}

local prefabs = 
{
    "commonfish",
}

local function CanSpawn(inst)
    return inst.components.herd and not inst.components.herd:IsFull()
end

local function OnSpawned(inst, newent)
    if inst.components.herd then
        inst.components.herd:AddMember(newent)
    end
end

local function OnEmpty(inst)
    inst:Remove()
end

local function OnFull(inst)
    --TODO: mark some for death
end
   
local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    inst:AddTag("herd")
    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("commonfish")
    inst.components.herd:SetGatherRange(40)
    inst.components.herd:SetUpdateRange(20)
    inst.components.herd:SetOnEmptyFn(OnEmpty)
    inst.components.herd:SetOnFullFn(OnFull)
    inst.components.herd.maxsize = 6
    
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(UW_TUNING.JELLYFISH_SPAWN_DELAY, UW_TUNING.JELLYFISH_SPAWN_VAR)
    inst.components.periodicspawner:SetPrefab("commonfish")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetDensityInRange(20, 6)
    inst.components.periodicspawner:Start()
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
    
    return inst
end

return Prefab( "underwater/commonfishschool", fn, assets, prefabs) 
