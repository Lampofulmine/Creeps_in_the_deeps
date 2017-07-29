local assets=
{
	Asset("ANIM", "anim/kelp.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()

	MakeObstaclePhysics(inst, .25) 
	
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("kelp.tex")
	
	trans:SetScale(1, 1, 1)
	
	anim:SetBank("kelp")
	anim:SetBuild("kelp")
	anim:PlayAnimation("idle", true)
	anim:SetTime(math.random()*1.5)
	
	local color = 0.75 + math.random() * 0.25
	anim:SetMultColour(color, color, color, 1)

	inst:AddTag("underwater")
	inst:AddTag("tree")

	inst:AddComponent("inspectable")    
	
	return inst
end


return Prefab("underwater/objects/kelp", fn, assets)
