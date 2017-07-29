require("stategraphs/commonstates")

-- Anims
-- idle--
-- walk--
-- jump
-- run
-- float--
-- death--

-- The "walk" and "run" states get overridden by commonstates, I think. It'd be better to make custom run states so shrimps can be locked in the run state while jumping -Mobb

local events=
{
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnAttacked(true),
    CommonHandlers.OnDeath(),
}

local states=
{
    State --idle anim
    {
        name = "idle",
        tags = {"idle", "canrotate", "canslide"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle", true)
            inst.sg:SetTimeout(math.random()*4+2)
        end,

       ontimeout= function(inst)
            inst.sg:GoToState("float")
         end,
    },  
    
    -- walking anim
    State
    { 
        name = "walk",
        tags = {"walk", "canrotate", "canslide", "walking"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk", true)
            inst.sg:SetTimeout(math.random()*4+2)  
        end,
    
        ontimeout= function(inst)
            inst.sg:GoToState("jump")
        end, 

        timeline=
        {
           TimeEvent(20*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },
    
    },

    -- floating anim
    State
    {
        name = "float",
        tags = {"float", "canrotate", "canslide","floating"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("float", true) 
        end,

       timeline=
        {
            TimeEvent(40*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
	},
		
    State
    { 
        name = "jump",
        tags = { "canrotate", "canslide", "jumping"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("jump", true)
            inst.sg:SetTimeout(math.random()*4+2)  
        end,
    
        ontimeout= function(inst)
            inst.sg:GoToState("idle")
        end, 

        --timeline=
        -- {
        --   TimeEvent(20*FRAMES, function(inst) inst:PerformBufferedAction() end),
        --},
    
    },

    State
    { 
        name = "run",
        tags = { "run", "canslide", "running", "busy"}, --"canrotate"
        onenter = function(inst)
            inst.AnimState:PlayAnimation("run", true)
            inst.sg:SetTimeout(math.random()*4+2)  
        end,
    
        ontimeout= function(inst)
            inst.sg:GoToState("idle")
        end, 

        timeline=
        {
           TimeEvent(20*FRAMES, function(inst) inst:PerformBufferedAction() end),
        },
    
    },

    -- jump anim when shrimp is scared of player (add only when present in SGShrimp)
    -- State{
    --    name = "scared",
    --    tags = {"scared", "canrotate", "canslide","jumping"},
    --    onenter = function(inst)
    --        inst.AnimState:PlayAnimation("jump", true)
    --        inst.Physics:Stop()
    --    end,
    --       events=
    --    {
    --        EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
    --    },
-- },

	
 -- Death anim
	State
    {
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
        },
}

CommonStates.AddSleepStates(states)
CommonStates.AddWalkStates(states)
CommonStates.AddRunStates(states)
    
return StateGraph("shrimp", states, events, "idle")