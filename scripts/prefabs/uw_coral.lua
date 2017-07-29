local assets=
{
	Asset("ANIM", "anim/coral_orange.zip"),
	Asset("ANIM", "anim/coral_blue.zip"),
	Asset("ANIM", "anim/coral_green.zip"),
}


local prefabs =
{
    "cut_orange_coral",
	"cut_blue_coral",
	"cut_green_coral",
}    

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("growing") 
	inst.AnimState:PushAnimation("idle", true)
end

local function onpickedfn(inst, picker)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_lightbulb") 
	inst.AnimState:PlayAnimation("picking") 
	inst.AnimState:PushAnimation("picked", false)
	if picker.components.combat then
        picker.components.combat:GetAttacked(inst, TUNING.MARSHBUSH_DAMAGE)
        picker:PushEvent("thorns")
	end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")	
	inst:Remove()
end

local function onsave(inst, data)
	data.coralname = inst.coralname
end

local function onload(inst,data)
	if data then
		inst.coralname = data.coralname
	end
end

local function LoadPostPass(inst, data, newents)
	if not inst.components.pickable:CanBePicked() then
		inst.AnimState:PlayAnimation("picked", false)
	end
end


local function commonfn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()
       
	--inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	
    anim:SetTime(math.random()*2)
    local color = 0.75 + math.random() * 0.25
    anim:SetMultColour(color, color, color, 1)

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
	 
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered)

	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")  
	
	inst:AddTag("coral")
	inst:AddTag("underwater")

	inst.OnSave = onsave
	inst.OnLoad = onload
    inst.LoadPostPass = LoadPostPass
        
    return inst
end

-- This part was made to add diff colors of coral which have diff drops and anims --

-- Coral Types
local coralnames = {"coral_orange", "coral_blue", "coral_green"}

-------------------------
-------------------------

-- Orange Coral

local function orange() 
	local inst = commonfn()
	inst.Transform:SetScale(2, 2, 2)
	inst.AnimState:SetBank("coral_orange")
	inst.AnimState:SetBuild("coral_orange")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetTime(math.random()*2)  

    inst.MiniMapEntity:SetIcon("orange_coral.tex")

	inst.components.pickable:SetUp("cut_orange_coral", TUNING.GRASS_REGROW_TIME)
	
	return inst
end
   
-- Blue Coral

local function blue() 
	local inst = commonfn()
	inst.Transform:SetScale(2, 2, 2)
	inst.AnimState:SetBank("coral_blue")
	inst.AnimState:SetBuild("coral_blue")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetTime(math.random()*2)  

    inst.MiniMapEntity:SetIcon("orange_coral.tex")--"blue_coral.tex"

	inst.components.pickable:SetUp("cut_blue_coral", TUNING.GRASS_REGROW_TIME)--"cut_blue_coral"

	return inst
end

-- Green Coral

local function green() 
	local inst = commonfn()
	inst.Transform:SetScale(2, 2, 2)
	inst.AnimState:SetBank("coral_green")
	inst.AnimState:SetBuild("coral_green")
    inst.AnimState:PlayAnimation("idle",true)
	inst.AnimState:SetTime(math.random()*2)  

    inst.MiniMapEntity:SetIcon("orange_coral.tex")--"green_coral.tex"

	inst.components.pickable:SetUp("cut_green_coral", TUNING.GRASS_REGROW_TIME)--"cut_green_coral"

	return inst
end

return Prefab( "underwater/objects/uw_coral", orange, assets, prefabs), 
Prefab("cave/objects/uw_coral_blue", blue, assets, prefabs),
Prefab("cave/objects/uw_coral_green", green, assets, prefabs)

