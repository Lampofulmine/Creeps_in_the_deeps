local assets =
{
	Asset("ANIM", "anim/torch.zip"),
	Asset("ANIM", "anim/swap_torch.zip"),
	Asset("SOUND", "sound/common.fsb"),
	
	Asset("IMAGE", "images/inventoryimages/flare.tex"),
	Asset("ATLAS", "images/inventoryimages/flare.xml"),
}
 
local prefabs =
{
	"torchfire",
	"sparks",
}

local function stop_sparks(inst)
	if inst.Light then
		inst.Light:Enable(false)
	end
	
	if inst.fx then
		inst.fx:Remove()
		inst.fx = nil
	end
	
	if inst.task then
		inst.task:Cancel()
		inst.task = nil
	end
 
	inst.components.fueled:StopConsuming()
end

local function start_sparks(inst, owner)	
	stop_sparks(inst)
	
	if inst.Light then
		inst.Light:Enable(true)
	end
	
	inst.task = inst:DoPeriodicTask(0.2, function()
		inst.fx = SpawnPrefab("sparks")	
		inst.fx.Transform:SetScale(.9,.9,.9)
		
		if owner then
			local follower = inst.fx.entity:AddFollower()
			follower:FollowSymbol( owner.GUID, "swap_object", 0, -110, 1 )	
		else
			local follower = inst.fx.entity:AddFollower()
			follower:FollowSymbol( inst.GUID, "swap_object", 65, -45, 1 )
		end
		
		-- check firefx component for sound intensity
	end)
 
	inst.components.fueled:StartConsuming()
end

local function onequip(inst, owner) 
	start_sparks(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_torch", "swap_torch")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst,owner) 
	stop_sparks(inst, owner)
    
    owner.components.combat.damage = owner.components.combat.defaultdamage --???
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")     
end

local function onload(inst, data)
	if inst.components.inventoryitem and not inst.components.inventoryitem.owner then
		start_sparks(inst)
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
	
	inst.entity:AddLight()
	inst.Light:SetIntensity(.75)
    inst.Light:SetColour(197/255,197/255,50/255)
    inst.Light:SetFalloff( 0.5 )
    inst.Light:SetRadius( 2.5 )
	inst.Light:Enable(false)
	
    anim:SetBank("torch")
    anim:SetBuild("torch")
    anim:PlayAnimation("idle")
    MakeInventoryPhysics(inst)
    
	inst:AddTag("chemicalfire")
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.TORCH_DAMAGE)
    inst.components.weapon:SetAttackCallback(function(attacker, target)        
		if target.components.burnable
		and math.random() < TUNING.TORCH_ATTACK_IGNITE_PERCENT * target.components.burnable.flammability then
			target.components.burnable:Ignite()
		end
	end)
    
    inst:AddComponent("lighter")  
	inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn( start_sparks )
	inst.components.inventoryitem:SetOnPickupFn( stop_sparks )
	
	inst.components.inventoryitem.imagename = "flare"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/flare.xml"
	
	inst:AddComponent("equippable")  
    inst.components.equippable:SetOnEquip( onequip )    
    inst.components.equippable:SetOnUnequip( onunequip )
    
    inst:AddComponent("heater")
    inst.components.heater.equippedheat = 5
	
  	inst:AddComponent("fueled")  
   	inst.components.fueled:SetSectionCallback(
        function(section)
            if section == 0 then
                --when we burn out
				
                if inst.components.inventoryitem and inst.components.inventoryitem:IsHeld() then
                    local owner = inst.components.inventoryitem.owner
                    inst:Remove()
                    
                    if owner then
                        owner:PushEvent("torchranout", {torch = inst})
                    end
                end            
            end
        end)
    inst.components.fueled:InitializeFuelLevel(TUNING.TORCH_FUEL*10)
    inst.components.fueled:SetDepletedFn(function(inst) inst:Remove() end)
	
	inst.OnLoad = onload
	
    return inst
end

return Prefab( "common/inventory/flare", fn, assets, prefabs) 
