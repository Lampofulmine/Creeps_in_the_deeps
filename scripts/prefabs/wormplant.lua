local assets=
{
	Asset("ANIM", "anim/wormplant.zip"),
}

local function onfar(inst)
    inst.AnimState:PlayAnimation("show")
	inst.AnimState:PushAnimation("idle", true)
end

local function onnear(inst)
    inst.AnimState:PlayAnimation("hide")
	inst.AnimState:PushAnimation("hidden", true)
 end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()

	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("wormplant.tex")
	
	trans:SetScale(0.6, 0.6, 0.6) --!!!
	MakeObstaclePhysics(inst, .25) 
	
	anim:SetBank("wormplant")
	anim:SetBuild("wormplant")
	anim:PlayAnimation("hidden", true)
	anim:SetTime(math.random()*2)
	
	local color = 0.75 + math.random() * 0.25
	anim:SetMultColour(color, color, color, 1)

	inst:AddTag("underwater")
	
	inst:AddComponent("inspectable") 

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	return inst
end

return Prefab( "underwater/objects/wormplant", fn, assets) 