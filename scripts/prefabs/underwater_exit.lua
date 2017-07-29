local levels = require("map/levels")
local PopupDialogScreen = require "screens/popupdialog"

local assets=
{
	Asset("ANIM", "anim/cave_exit_rope.zip"),
	Asset("ANIM", "anim/underwater_exit.zip"),
}

local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.CLIMB
end

local function OnActivate(inst)

	SetPause(true)
	local level = GetWorld().topology.level_number or 1
	local function head_upwards()
		SaveGameIndex:GetSaveFollowers(GetPlayer())

		local function onsaved()
		    SetPause(false)
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
		end

		local cave_num =  SaveGameIndex:GetCurrentCaveNum()
		if level == 1 or levels.cave_levels[level].id == "UNDERWATER_LEVEL_1" then
			SaveGameIndex:SaveCurrent(function() SaveGameIndex:LeaveCave(onsaved) end, "ascend", cave_num)
		else
			-- Ascend
			local level = level - 1
			
			SaveGameIndex:SaveCurrent(function() SaveGameIndex:EnterCave(onsaved,nil, cave_num, level) end, "ascend", cave_num)
		end
	end
	GetPlayer().HUD:Hide()
	TheFrontEnd:Fade(false, 2, function()
									head_upwards()
								end)
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
     
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "cave_open2.png" )
    
	inst.Transform:SetScale(2, 2, 2)
    anim:SetBank("underwater_exit")
    anim:SetBuild("underwater_exit")
	
	inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle", true)
    --inst.SoundEmitter:PlaySound("dontstarve/cave/rope_down")

    --inst:AddComponent("playerprox")
    --inst.components.playerprox:SetDist(5,7)
    --inst.components.playerprox:SetOnPlayerFar(onfar)
	--inst.components.playerprox:SetOnPlayerNear(onnear)

    inst:AddComponent("inspectable")

	inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
    inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = true

    return inst
end

return Prefab( "common/underwater_exit", fn, assets) 
