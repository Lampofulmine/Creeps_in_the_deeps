require "prefabutil"
require "recipes"

local assets =
{
	Asset("ANIM", "anim/pig_house.zip"),
}

local prefabs = 
{
	
}

local function LightsOn(inst)
    inst.Light:Enable(true)
    inst.AnimState:PlayAnimation("lit", true)
    inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")
    inst.lightson = true
end

local function LightsOff(inst)
    inst.Light:Enable(false)
    inst.AnimState:PlayAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
    inst.lightson = false
end

local function onfar(inst) 
    if inst.components.spawner:IsOccupied() then
        LightsOn(inst)
    end
end

local function getstatus(inst)
    if inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        else
            return "LIGHTSOUT"
        end
    end
end

local function onnear(inst) 
    if inst.components.spawner:IsOccupied() then
        LightsOff(inst)
    end
end

local function onoccupied(inst, child)
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
	
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
	
	inst.doortask = inst:DoTaskInTime(1, function() if not inst.components.playerprox:IsPlayerClose() then LightsOn(inst) end end)
end

local function onvacate(inst, child)
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
	
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
	
	if child and child.components.health then
		child.components.health:SetPercent(1)
	end    
end

local function onhammered(inst, worker)
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
	inst.components.spawner:ReleaseChild()
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function OnDay(inst)
    if inst.components.spawner:IsOccupied() and not inst:HasTag("merm_guard_house") then
        LightsOff(inst)
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
        inst.doortask = inst:DoTaskInTime(1 + math.random()*2, function() inst.components.spawner:ReleaseChild() end)
    end
end

local function OnDusk(inst)
    if inst.components.spawner:IsOccupied() and inst:HasTag("merm_guard_house") then
        LightsOff(inst)
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
        inst.doortask = inst:DoTaskInTime(1 + math.random()*2, function() inst.components.spawner:ReleaseChild() end)
    end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
end

local function house(owner)
	local function fn(Sim)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		local light = inst.entity:AddLight()
		inst.entity:AddSoundEmitter()

		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon( "pighouse.png" )

		light:SetFalloff(1)
		light:SetIntensity(.5)
		light:SetRadius(1)
		light:Enable(false)
		light:SetColour(180/255, 195/255, 50/255)
		
		MakeObstaclePhysics(inst, 1)

		anim:SetBank("pig_house")
		anim:SetBuild("pig_house")
		anim:PlayAnimation("idle", true)

		inst:AddTag("structure")
		inst:AddTag(owner.."_house")
		
		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(4)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)
		
		inst:AddComponent( "spawner" )
		inst.components.spawner:Configure( owner, TUNING.TOTAL_DAY_TIME*3 )
		inst.components.spawner.onoccupied = onoccupied
		inst.components.spawner.onvacate = onvacate
		inst:ListenForEvent( "daytime", function() OnDay(inst) end, GetWorld())    
		inst:ListenForEvent( "dusktime", function() OnDusk(inst) end, GetWorld())    
		
		inst:AddComponent( "playerprox" )
		inst.components.playerprox:SetDist(10,13)
		inst.components.playerprox:SetOnPlayerNear(onnear)
		inst.components.playerprox:SetOnPlayerFar(onfar)
		
		inst:AddComponent("inspectable")
		
		inst.components.inspectable.getstatus = getstatus
		
		MakeSnowCovered(inst, .01)

		inst:ListenForEvent( "onbuilt", onbuilt)
		inst:DoTaskInTime(math.random(), function() 
			if GetClock():IsDay() then 
				OnDay(inst)
			elseif not GetClock():IsDay() then 
				OnDusk(inst)
			end 
		end)

		return inst
	end
	
	return fn
end

return Prefab( "common/objects/mermnoblehouse", house("mermnoble"), assets, prefabs ),
		Prefab( "common/objects/mermworkerhouse", house("mermworker"), assets, prefabs ),
		Prefab( "common/objects/mermguardhouse", house("mermguard"), assets, prefabs ),
		MakePlacer("common/pighouse_placer", "pig_house", "pig_house", "idle") 