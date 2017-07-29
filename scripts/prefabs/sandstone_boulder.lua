local assets =
{
	Asset("ANIM", "anim/sandstone_boulder.zip"),
}

local prefabs =
{
    "rocks",
    "nitre",
    "flint",
    "iron_ore",
}    

SetSharedLootTable( 'sandstone_boulder',
{
    {'sandstone',     	1.00},
    {'sandstone',     	1.00},
    {'sandstone',     	1.00},
    {'sandstone',  		0.5},
    {'sandstone',     	0.25},
})

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	inst.AnimState:SetBank("sandstonerock")
	inst.AnimState:SetBuild("sandstone_boulder")
	inst.AnimState:PlayAnimation("full")
	
	MakeObstaclePhysics(inst, 1.)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "rock.png" )

	inst:AddComponent("lootdropper") 
	inst.components.lootdropper:SetChanceLootTable('sandstone_boulder')
	
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

return Prefab("underwater/objects/sandstone_boulder", fn, assets, prefabs)
