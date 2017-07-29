require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events=
{
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
	CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(true),
    CommonHandlers.OnDeath(),
}

local states=
{
    State
    {
        name = "idle",
        tags = {"idle", "canrotate", "canslide"},
        
		onenter = function(inst)
            inst.AnimState:PlayAnimation("idle", true)
			inst.sg:SetTimeout(math.random()*4+2)
        end,
		
		ontimeout= function(inst)
            inst.sg:GoToState("funnyidle")
        end,
    },  
	
	State
    {
        name = "funnyidle",
        tags = {"busy"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("flip")
			inst.Physics:Stop()  
        end,
		
		events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },  
    
    State{
        name = "hit",
        tags = {"busy"},
        
        onenter = function(inst)                
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
	
	State{
        name = "eat",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()            
            inst.AnimState:PlayAnimation("eat")
        end,
        
        timeline=
        {
            TimeEvent(20*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },        
    },
	
	State{
        name = "attack",
        tags = {"attack", "busy"},
        
        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,
        
        timeline=
        {
            --TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/Attack") end),
            --TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/attack_grunt") end),
            TimeEvent(10*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
		
		events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("dead") end ),
        },  
    },
	
	State{
        name = "dead",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("dead", true)

			local fish = SpawnPrefab("fish")
			fish.Transform:SetPosition(inst.Transform:GetWorldPosition())
			
			fish.AnimState:SetBank("commonfish")
			fish.AnimState:SetBuild("commonfish")
			
			fish.Transform:SetFourFaced()
			local angle = inst.Transform:GetRotation()
			fish.Transform:SetRotation(angle)
			
			fish.AnimState:PlayAnimation("dead", true)
			
			if fish.components.inventoryitem then
				fish.components.inventoryitem:SetOnPickupFn(function(fish)
					fish.AnimState:SetBank("fish")
					fish.AnimState:SetBuild("fish")
					fish.AnimState:PlayAnimation("dead")
					fish.Transform:SetRotation(0)
				end)
			end
			
			inst:Remove()
        end,
    },
}

CommonStates.AddSleepStates(states)
CommonStates.AddWalkStates(states)
CommonStates.AddRunStates(states)
    
return StateGraph("commonfish", states, events, "idle", actionhandlers)