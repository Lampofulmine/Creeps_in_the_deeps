local assets =
{
	Asset("ANIM", "anim/iron_boulder.zip"),
}

local prefabs =
{
    "rocks",
    "nitre",
    "flint",
    "iron_ore",
}    

SetSharedLootTable( 'iron_boulder',
{
    {'rocks',     	1.00},
    {'rocks',     	1.00},
    {'iron_ore',  	1.00},
    {'flint',     	1.00},
    {'iron_ore',  	0.25},
    {'flint',     	0.60},
})

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	inst.AnimState:SetBank("iron_boulder")
	inst.AnimState:SetBuild("iron_boulder")
	inst.AnimState:PlayAnimation("full")

	MakeObstaclePhysics(inst, 1.)
	
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("iron_boulder.tex")

	inst:AddComponent("lootdropper") 
	inst.components.lootdropper:SetChanceLootTable('iron_boulder')
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	
	inst.components.workable:SetOnWorkCallback(
		function(inst, worker, workleft)
			local pt = Point(inst.Transform:GetWorldPosition())
			if workleft <= 0 then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
				inst.components.lootdropper:DropLoot(pt)
				inst:Remove()
			else
				if workleft < TUNING.ROCKS_MINE*(1/3) then
					inst.AnimState:PlayAnimation("low")
				elseif workleft < TUNING.ROCKS_MINE*(2/3) then
					inst.AnimState:PlayAnimation("med")
				else
					inst.AnimState:PlayAnimation("full")
				end
			end
		end)     

    local color = 0.5 + math.random() * 0.5
    anim:SetMultColour(color, color, color, 1)    

	inst:AddComponent("inspectable")
	MakeSnowCovered(inst, .01)    
  
	return inst
end

return Prefab("underwater/objects/iron_boulder", fn, assets, prefabs)
