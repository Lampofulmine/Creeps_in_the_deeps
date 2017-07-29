local assets=
{
	Asset("ANIM", "anim/vent.zip"),
}

local function onsave(inst, data)
	data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	local minimap = inst.entity:AddMiniMapEntity()
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("vent.tex")
	
	inst.entity:AddAnimState()
	inst.AnimState:SetBank("air_vent")
	inst.AnimState:SetBuild("vent")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetRayTestOnBB(true);
	
	inst.Transform:SetScale(0.5, 0.5, 0.5)
  
    inst:AddTag("vent")
	inst:AddTag("underwater")
	
	inst:AddComponent("oxygenaura")
	inst.components.oxygenaura:SetAura(UW_TUNING.GEOTHERMAL_VENT_AIR*0.5)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("bubbleblower")
	inst.components.bubbleblower:SetYOffset(40)
	inst.components.bubbleblower:SetYOffset(30)
    inst.components.bubbleblower:SetBubbleRate(10)
	
    return inst
end

return Prefab( "underwater/objects/bubble_vent", fn, assets) 
