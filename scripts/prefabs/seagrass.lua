--All of the --!!! marked lines will be removed once we have all the proper animations

local START_TIME_SCALE = 1.5
local SPEED_MULT = 3

-- Determined by the idle animation. Time 1 and Time 2 are the two points where the anim is neither leaning left or right 
local ANIM_LENGTH = 8
local TIME_1 = 2.4
local TIME_2 = 6.9

local assets=
{
	Asset("SOUND", "sound/common.fsb"),
	Asset("ANIM", "anim/seagrass.zip")
}

local prefabs =
{
    "cutgrass",
}    

-- Speeds all the idle animation to sync it with all the others
local function OnGrow(inst)
	inst.AnimState:PlayAnimation(inst.animnum, true)
	
	local target_time = math.fmod(GetTimePlaying(), ANIM_LENGTH) + math.random()*START_TIME_SCALE
	if target_time > ANIM_LENGTH then
		target_time = target_time - ANIM_LENGTH
	end
	
	local set_time = 0
	if target_time > TIME_2 or target_time < TIME_1 then
		set_time = TIME_2
	else
		set_time = TIME_1
	end
	
	inst.AnimState:SetTime(set_time)
	inst.AnimState:SetDeltaTimeMultiplier(SPEED_MULT)
	
	local end_time = 0
	if set_time < target_time then
		end_time = (target_time - set_time)/SPEED_MULT
	else
		end_time = ((target_time + ANIM_LENGTH) - set_time)/SPEED_MULT
	end
	
	inst:DoTaskInTime(end_time, function(inst) inst.AnimState:SetDeltaTimeMultiplier(1) end)

	inst:RemoveEventCallback("animover", OnGrow)
end

local function onregenfn(inst)
	inst.AnimState:PlayAnimation(inst.animnum .."_grow") 
	inst:ListenForEvent("animover", OnGrow)
end

local function onpickedfn(inst)
	inst.AnimState:SetDeltaTimeMultiplier(1)
	inst.AnimState:PlayAnimation(inst.animnum .."_pick") 
	inst.AnimState:PushAnimation(inst.animnum .."_picked")
end

local function LoadPostPass(inst, data, newents)
	if not inst.components.pickable:CanBePicked() then
		inst.AnimState:PlayAnimation(inst.animnum .."_picked")
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()

	inst:AddTag("underwater")
	
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("seagrass.tex")
	
	-- Since they are so similiar, we don't bother remembering which type it is and just re-roll every time
	if math.random() < .5 then
		inst.animnum = "idle_1"
	else
		inst.animnum = "idle_2"
	end
	
	inst.Transform:SetScale(0.4, 0.4, 0.4) --!!!
	anim:SetBank("seagrass")
	anim:SetBuild("seagrass")
	anim:PlayAnimation(inst.animnum,true)
	anim:SetTime(math.random()*START_TIME_SCALE)
	
	local color = 0.75 + math.random() * 0.25
	anim:SetMultColour(color, color, color, 1)

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	
	--inst.components.pickable:SetUp("cutgrass", 5)
	inst.components.pickable:SetUp("seagrass_chunk", TUNING.GRASS_REGROW_TIME)
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn

	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")    
	
	---------------------        
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)
	---------------------
	
    inst.LoadPostPass = LoadPostPass
	
	return inst
end

return Prefab("underwater/objects/seagrass", fn, assets, prefabs)
