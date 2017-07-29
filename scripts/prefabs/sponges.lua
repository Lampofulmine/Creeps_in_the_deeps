
local assets=
{
	Asset("ANIM", "anim/sponge.zip"),
}

local prefabs =
{
    "sponge_piece",
}    

local names = {"f1","f2"}

local function onsave(inst, data)
	data.animbank = inst.animbank
end

local function onload(inst, data)
    if data and data.animbank then
        inst.animbank = data.animbank
	    inst.AnimState:SetBank(inst.animbank)
	end
end

local function LoadPostPass(inst, data, newents)
	if not inst.components.pickable:CanBePicked() then
		inst.AnimState:PlayAnimation("picked", true)
	end
end

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("grow") 
	inst.AnimState:PushAnimation("idle", true)
end

local function onpickedfn(inst)
	inst.AnimState:PlayAnimation("pick") 
	inst.AnimState:PushAnimation("picked", true)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()

	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("sponge.tex")

	inst:AddTag("underwater")
	
	
	--inst.Transform:SetScale(0.4, 0.4, 0.4) --!!!
	
	inst.animbank = names[math.random(#names)]
	
	anim:SetBank(inst.animbank)
	anim:SetBuild("sponge")
	anim:PlayAnimation("idle", true)
	anim:SetTime(math.random()*2)
	
	local color = 0.75 + math.random() * 0.25
	anim:SetMultColour(color, color, color, 1)

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	
	inst.components.pickable:SetUp("sponge_piece", TUNING.GRASS_REGROW_TIME)
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.quickpick = true

	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable") 

    --------SaveLoad
    inst.OnSave = onsave 
    inst.OnLoad = onload
    inst.LoadPostPass = LoadPostPass
	
	return inst
end 

return Prefab("underwater/objects/sponge", fn, assets, prefabs)