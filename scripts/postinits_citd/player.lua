-- Player components
function fn(inst)

	-- Tidal manager
	print("Adding tidal manager component")
	inst:AddComponent("tidalmanager")
	
	-- Oxygen component
	print("Adding oxygen component")
	inst:AddComponent("oxygen")

	-- Custom Oxygen Levels
	if inst.prefab == "willow" then inst.components.oxygen.max = 80 end
	if inst.prefab == "wilson" then inst.components.oxygen.max = 100 end
	if inst.prefab == "wolfgang" then inst.components.oxygen.max = 150 end
	if inst.prefab == "waxwell" then inst.components.oxygen.max = 120 end
	if inst.prefab == "woodie" then inst.components.oxygen.max = 150 end
	if inst.prefab == "wendy" then inst.components.oxygen.max = 80 end
	if inst.prefab == "wickerbottom" then inst.components.oxygen.max = 100 end
	if inst.prefab == "wes" then inst.components.oxygen.max = 55 end
	if inst.prefab == "wigfrid" then inst.components.oxygen.max = 150 end
	if inst.prefab == "webber" then inst.components.oxygen.max = 85 end
	
	-- Drowning events
	inst:ListenForEvent("runningoutofoxygen", function(inst, data)
		inst.components.talker:Say(GetString(inst.prefab, "ANNOUNCE_OUT_OF_OXYGEN"))
    end)
	
	inst:ListenForEvent("startdrowning", 
		function(inst, data)
			if inst.HUD then
				inst.HUD.bloodover:UpdateState() 
			end
		end,
	inst)
	
	inst:ListenForEvent("stopdrowning", 
		function(inst, data) 
			if inst.HUD then
				inst.HUD.bloodover:UpdateState()
			end
		end,
	inst)
	

	-- WX78 is a robot!
	if inst.prefab == "wx78" then
		inst:AddTag("robot")
	end
	
	-- Everything is slower underwater
	inst:DoTaskInTime(0.05, function(inst) 
		if GetWorld():IsUnderwater() then
			print("Moving underwater is hard for "..inst.name)
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED*0.8
			inst.components.locomotor.walkspeed = TUNING.WILSON_RUN_SPEED*0.8
			inst:DoPeriodicTask(0.05, function(inst) inst.AnimState:SetDeltaTimeMultiplier(0.8) end)
		end
	end)
end

return fn