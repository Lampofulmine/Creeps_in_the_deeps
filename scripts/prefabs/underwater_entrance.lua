local levels = require("map/levels")
local PopupDialogScreen = require "screens/popupdialog"

local assets=
{
	--Asset("ANIM", "anim/cave_entrance.zip"),
	--Asset("ANIM", "anim/ruins_entrance.zip"),
	Asset("ANIM", "anim/underwater_entrance.zip"),
}

local prefabs = 
{
	"exitcavelight"
}

-- To make flying fish or whatever is exiting the entrance go back at some point
--[[local function ReturnChildren(inst)
	for k,child in pairs(inst.components.childspawner.childrenoutside) do
		if child.components.homeseeker then
			child.components.homeseeker:GoHome()
		end
		child:PushEvent("gohome")
	end
end]]--


local function OnActivate(inst)

	if not IsGamePurchased() then return end

    ProfileStatsSet("cave_entrance_used", true)
	
	SetPause(true)

	TheFrontEnd:Fade(false, 2, function()
		SaveGameIndex:GetSaveFollowers(GetPlayer())

		local function onsaved()
			SetPause(false)
			StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
		end

		local function doenter()
			local level = 1
			if GetWorld().prefab == "cave" then
				level = (GetWorld().topology.level_number or 1 ) + 1
			elseif levels then
				print("Searching for first underwater level")
				
				for k,v in ipairs(levels.cave_levels) do					
					if v.id == "UNDERWATER_LEVEL_1" then
						level = k
						print("Level found. ID "..level)
						break
					end
				end				
			end
			SaveGameIndex:SaveCurrent(function() SaveGameIndex:EnterCave(onsaved,nil, inst.cavenum, level) end, "descend", inst.cavenum)
		end

		if not inst.cavenum then
			-- We need to make sure we only ever have one cave underground
			-- this is because caves are verticle and dont have sub caves
			if GetWorld().prefab == "cave"  then
				inst.cavenum = SaveGameIndex:GetCurrentCaveNum()
				doenter()
			else
				inst.cavenum = SaveGameIndex:GetNumCaves() + 1
				SaveGameIndex:AddCave(nil, doenter)
			end
		else
			doenter()
		end
	end)
	
end
-- This will have to be tranformed into our "make abyss"
local function MakeRuins(inst)
	inst.AnimState:SetBank("ruins_entrance")
	inst.AnimState:SetBuild("ruins_entrance")

	if inst.components.lootdropper then
		inst.components.lootdropper:SetLoot({"thulecite", "thulecite_pieces", "thulecite_pieces"})
	end

	inst.MiniMapEntity:SetIcon("ruins_closed.png")
end

local function Open(inst)

-- Declare spawning time and regen of entity that spawns from entrance--

--[[inst.startspawningfn = function()	
		inst.components.childspawner:StopRegen()	
		inst.components.childspawner:StartSpawning()
	end

	inst.stopspawningfn = function()
		inst.components.childspawner:StartRegen()
		inst.components.childspawner:StopSpawning()
		ReturnChildren(inst)
	end
	inst.components.childspawner:StopSpawning()
	inst:ListenForEvent("dusktime", inst.startspawningfn, GetWorld())
	inst:ListenForEvent("daytime", inst.stopspawningfn, GetWorld()) ]]--

    inst.AnimState:PlayAnimation("idle_open", true)
    inst:RemoveComponent("workable")
    
    inst.open = true

    inst.name = STRINGS.NAMES.UNDERWATER_ENTRANCE_OPEN
	if SaveGameIndex:GetCurrentMode() == "cave" then
        inst.name = STRINGS.NAMES.UNDERWATER_ENTRANCE_OPEN_CAVE
    end
	inst:RemoveComponent("lootdropper")

	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("entrance_open.tex")

    inst:DoTaskInTime(2, function() 

		if IsGamePurchased() then
			inst:AddComponent("oceantransporter")
		    inst.components.oceantransporter.OnActivate = OnActivate
		    inst.components.oceantransporter.inactive = true
		end
	end)
end      

local function OnWork(inst, worker, workleft)
	local pt = Point(inst.Transform:GetWorldPosition())
	if workleft <= 0 then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
		inst.components.lootdropper:DropLoot(pt)
        ProfileStatsSet("cave_entrance_opened", true)
		Open(inst)
	else	-- The animations name shall be changed when designs will be available --			
		if workleft < TUNING.ROCKS_MINE*(1/3) then
			inst.AnimState:PlayAnimation("idle_closed")
		elseif workleft < TUNING.ROCKS_MINE*(2/3) then
			inst.AnimState:PlayAnimation("idle_closed")
		else
			inst.AnimState:PlayAnimation("idle_closed")
		end
	end
end


local function Close(inst)
	inst:RemoveComponent("oceantransporter")
    inst.AnimState:PlayAnimation("idle_closed", true)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"rocks", "rocks", "flint", "flint", "flint"})

    inst.name = STRINGS.NAMES.UNDERWATER_ENTRANCE_CLOSED
	if SaveGameIndex:GetCurrentMode() == "cave" then
        inst.name = STRINGS.NAMES.UNDERWATER_ENTRANCE_CLOSED_CAVE
    end

    inst.open = false
end      

local function onsave(inst, data)
	data.cavenum = inst.cavenum
	data.open = inst.open
end           

local function onload(inst, data)
	inst.cavenum = data and data.cavenum 

	if GetWorld():IsCave() then
		MakeRuins(inst)
	end

	if data and data.open then
		Open(inst)
	end
end

local function GetStatus(inst)
    if inst.open then
        return "OPEN"
    end
end  

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	
    anim:SetLayer(LAYER_BACKGROUND)
	anim:SetSortOrder(3)
	MakeObstaclePhysics(inst, 1)
    local minimap = 
	inst.entity:AddMiniMapEntity()
	inst.Transform:SetScale(0.3, 0.3, 0.3)
    inst.MiniMapEntity:SetIcon("entrance_closed.tex")
    anim:SetBank("entrance_reef")
    anim:SetBuild("underwater_entrance")

    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
	inst.components.inspectable.getstatus = GetStatus

	--[[inst:AddComponent( "childspawner" )
	inst.components.childspawner:SetRegenPeriod(60)
	inst.components.childspawner:SetSpawnPeriod(.1)
	inst.components.childspawner:SetMaxChildren(6)
	inst.components.childspawner.childname = "bat"]]--

	Close(inst)
	
	inst.OnSave = onsave
	inst.OnLoad = onload
	
	if SaveGameIndex:GetCurrentMode() == "adventure" then
		inst:DoTaskInTime(0, function() inst:Remove() end)
	end
	
    return inst
end

return Prefab( "common/underwater_entrance", fn, assets, prefabs) 