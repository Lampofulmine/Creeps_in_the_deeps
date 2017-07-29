require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/sunken_chest.zip"),
	Asset("ANIM", "anim/ui_chest_3x2.zip"),
}

local function onopen(inst) 
	inst.AnimState:PlayAnimation("open") 
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end 

local function onclose(inst) 
	inst.AnimState:PlayAnimation("close") 
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")		
end 

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.components.container:DropEverything()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")	
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.components.container:DropEverything()
	inst.AnimState:PushAnimation("closed", false)
	inst.components.container:Close()
end

local slotpos = {}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
	end
end

local fn = function(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()
	
	minimap:SetIcon("treasure_chest.png")

	inst:AddTag("structure")
	inst.AnimState:SetBank("sunken_chest")
	inst.AnimState:SetBuild("sunken_chest")
	inst.AnimState:PlayAnimation("closed")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("container")
	inst.components.container:SetNumSlots(#slotpos)
	
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose
	
	inst.components.container.widgetslotpos = slotpos
	inst.components.container.widgetanimbank = "ui_chest_3x3"
	inst.components.container.widgetanimbuild = "ui_chest_3x3"
	inst.components.container.widgetpos = Vector3(0,200,0)
	inst.components.container.side_align_tip = 160
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"boards", "boards"})
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(2)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit) 
	
	MakeSnowCovered(inst, .01)	
	return inst
end

return Prefab( "common/sunken_chest", fn, assets)
