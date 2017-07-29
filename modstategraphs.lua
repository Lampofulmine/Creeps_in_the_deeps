
AddStategraphPostInit("wilson", function(sg)
	
	if sg.states.quickeat then
		local _onenter = sg.states.quickeat.onenter
		sg.states.quickeat.onenter = function(inst)
			_onenter(inst)
			
			if inst:GetBufferedAction() and inst:GetBufferedAction().invobject and inst:GetBufferedAction().invobject.components.edible and inst:GetBufferedAction().invobject:HasTag("bubble") then
				inst.SoundEmitter:KillSound("eating") 
				inst.SoundEmitter:PlaySound("citd/common/bubble_pop", "eating")
				
				if inst.components.oxygen then
					inst.components.oxygen:Pause()
				end
			end
		end
		
		local _onexit = sg.states.quickeat.onexit
		sg.states.quickeat.onexit = function(inst)
			_onexit(inst)
			
			if inst.components.oxygen then
				inst.components.oxygen:Resume()
			end
		end
	end
	
end)

AddStategraphState("wilson", GLOBAL.State{
	name = "divedeep",
	tags = {"doing", "canrotate", "busy"},
	
	onenter = function(inst)
		inst.sg.statemem.pos = inst:GetBufferedAction().target:GetPosition()
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("jump")
	end,
	
	--This shouldn't actually be reached
	onexit = function(inst)
		inst.components.locomotor:Stop()
		GLOBAL.ChangeToCharacterPhysics(inst)
		inst.components.health:SetInvincible(false)
		inst.components.playercontroller:Enable(true)
		inst.HUD:Show()
	end,
	
	timeline =
	{
		-- point of no return, if you wait this long, you can't abort anymore
		GLOBAL.TimeEvent(7*GLOBAL.FRAMES, function(inst)
			inst:ForceFacePoint(inst.sg.statemem.pos:Get())
			local dist = inst:GetPosition():Dist(inst.sg.statemem.pos)
			local speed = dist / (18/30)
			inst.Physics:SetMotorVelOverride(speed, 0, 0)
		
			GLOBAL.ChangeToGhostPhysics(inst)
			inst.components.health:SetInvincible(true)
			inst.components.playercontroller:Enable(false)
			inst.HUD:Hide()
		end),
		--when hitting the ground, spawn a splash ocean effect incl. sound and hide & stop
		GLOBAL.TimeEvent(22*GLOBAL.FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/pengull/splash")
		end),
		GLOBAL.TimeEvent(24*GLOBAL.FRAMES, function(inst)
			inst.components.locomotor:Stop()
			
			inst.DynamicShadow:Enable(false)
			GLOBAL.SpawnAt("splash_ocean", inst)
		end),
		GLOBAL.TimeEvent(30*GLOBAL.FRAMES, function(inst)
			inst:PerformBufferedAction()
		end),
	},
})

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.DIVEDEEP, "divedeep"))

