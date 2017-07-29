local assets=
{
	Asset("ANIM", "anim/cave_exit_lightsource.zip"),
}

local col = {91/255, 164/255, 255/255}

local function turnoff(inst, light)
    if light then
        light:Enable(false)
    end
    inst:Hide()
end

local phasefunctions = 
{
    day = function(inst)
        inst.Light:Enable(true)
        inst:Show()
        inst.components.lighttweener:StartTween(nil, inst.scale * 10, .6, .6, col, 4)
    end,
    dusk = function(inst) 
        inst.Light:Enable(true)
        inst:Show()
        inst.components.lighttweener:StartTween(nil, inst.scale * 8, .3, .6, col, 5)
    end,
    night = function(inst) 
        inst.components.lighttweener:StartTween(nil, 0, 0, 1, col, 6, turnoff)
    end,
}

local function timechange(inst)
    phasefunctions[ GetClock():GetPhase() ](inst)
end

local function commonfn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.Transform:SetScale(0.5, 0.5, 1)
    anim:SetBank("cavelight")
    anim:SetBuild("cave_exit_lightsource")
    anim:PlayAnimation("idle_loop", true)

    inst:AddTag("NOCLICK")

    inst:ListenForEvent("daytime", function() timechange(inst) end, GetWorld())
    inst:ListenForEvent("dusktime", function() timechange(inst) end, GetWorld())
    inst:ListenForEvent("nighttime", function() timechange(inst) end, GetWorld())

    inst:AddComponent("lighttweener")
    inst.AnimState:SetMultColour(255/255,177/255,32/255,0)

    return inst
end

local function smallfn()
	local inst = commonfn()
	
	inst.scale = 0.5
    inst.Transform:SetScale(inst.scale, 0.5, 1)
	
    inst.components.lighttweener:StartTween(inst.entity:AddLight(), 1, .3, .6, col, 0)
	timechange(inst)
	
    return inst
end

local function tinyfn()
	local inst = commonfn()

	inst.scale = 0.2
    inst.Transform:SetScale(inst.scale, 0.5, 1)
	
    inst.components.lighttweener:StartTween(inst.entity:AddLight(), 1, .3, .6, col, 0)
	timechange(inst)
	
    return inst
end

return Prefab( "common/reeflight_small", smallfn, assets),
	Prefab( "underwater/objects/reeflight_tiny", tinyfn, assets) 
