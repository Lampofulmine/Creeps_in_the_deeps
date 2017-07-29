local assets=
{
	Asset("ANIM", "anim/jelly_lantern.zip"),
}

local function onperish(inst)
    --inst:AddTag("rotten")
	--inst.components.health:Kill()
	--inst.AnimState:PlayAnimation("rotten")
	inst:Remove()
end

local function turnon(inst)
    if inst.components.perishable.perishremainingtime > 0 then
		inst.components.perishable:StartPerishing()
		inst.Light:Enable(true)
		inst.AnimState:PlayAnimation("on")
		inst.components.machine.ison = true
    end
end

local function turnoff(inst)
	inst.components.perishable:StopPerishing()
    inst.Light:Enable(false)
    inst.AnimState:PlayAnimation("off")
    inst.components.machine.ison = false
end

local function OnLoad(inst, data)
    if inst.components.machine and inst.components.machine.ison then
        turnon(inst)
    else
        turnoff(inst)
    end
end

local function fn(Sim)
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)

    inst.Transform:SetScale(2, 2, 2)
    inst.AnimState:SetBank("jelly_lantern")
    inst.AnimState:SetBuild("jelly_lantern")
    inst.AnimState:PlayAnimation("off")
	
    local light = inst.entity:AddLight()
    light:SetFalloff(.5)
    light:SetIntensity(.8)
    light:SetRadius(1.5)
    light:SetColour(200/255, 100/255, 170/255)
	light:Enable(false)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "jelly_lantern"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/jelly_lantern.xml"
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem:SetOnDroppedFn(turnon)
    inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)

	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(30*TUNING.SEG_TIME)
    inst.components.perishable:SetOnPerishFn(onperish)
	
    inst:AddTag("light")
    inst:AddTag("show_spoilage")
	
    inst:AddComponent("machine")
    inst.components.machine.turnonfn = turnon
    inst.components.machine.turnofffn = turnoff
    inst.components.machine.cooldowntime = 0
    inst.components.machine.caninteractfn = function()
		return inst.components.perishable.perishremainingtime > 0
		and not inst.components.inventoryitem.owner
	end

	inst.OnLoad = OnLoad
	
	turnon(inst)
	
    return inst
end

return Prefab( "common/inventory/jelly_lantern", fn, assets) 
