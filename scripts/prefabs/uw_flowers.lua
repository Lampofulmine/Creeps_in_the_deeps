local assets=
{
	Asset("ANIM", "anim/uw_flowers.zip"),
}


local prefabs =
{
    "sea_petals",
}    


local names = {"f1","f2","f3","f4","f5","f6"}

local function onsave(inst, data)
	data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function onpickedfn(inst, picker)
	if picker and picker.components.sanity then
		picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
	end	
	
	inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("uw_flowers")
    inst.animname = names[math.random(#names)]
    inst.AnimState:SetBuild("uw_flowers")
    inst.AnimState:PlayAnimation(inst.animname)
    inst.AnimState:SetRayTestOnBB(true);
    
    inst:AddTag("flower")
	inst:AddTag("underwater")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("sea_petals", 6)-- changhe into sea_petals
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
    
    inst.OnSave = onsave 
    inst.OnLoad = onload 
    
    return inst
end

return Prefab( "underwater/objects/uw_flowers", fn, assets, prefabs) 
