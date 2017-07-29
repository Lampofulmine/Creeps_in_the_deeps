
local function onsave(inst, data)
	
end

local function onload(inst, data)

end

local function LaunchItem(inst, item, data)
	local wave_angle = data.wave_angle
	local wave_power = data.wave_power
	
    if item.Physics then
        local x, y, z = item:GetPosition():Get()
        item.Physics:Teleport(x,0,z)
  
        local speed = wave_power + (math.random() * (wave_power/4))
        item.Physics:SetVel(math.cos(wave_angle*DEGREES) * speed, 0, math.sin(wave_angle*DEGREES) * speed)
    end
end

local function TidalChange(inst, data)
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z, UW_TUNING.TIDAL_EFFECT_RANGE, nil, {"INLIMBO"})
    for k,v in pairs(ents) do 
		if v.components.inventoryitem then
			LaunchItem(inst, v, data)
		end
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	--inst.entity:AddAnimState() 
	--inst.AnimState:SetBank("goldnugget")
	--inst.AnimState:SetBuild("gold_nugget")
	--inst.AnimState:PlayAnimation("idle")
    
    inst:AddTag("tidal_node")
	inst:AddTag("underwater")
	
	inst:ListenForEvent("tidal_change", function(i, data) TidalChange(inst, data) end, GetPlayer())

    --------SaveLoad
    inst.OnSave = onsave 
    inst.OnLoad = onload 
    
    return inst
end

return Prefab( "underwater/objects/tidal_node", fn) 
