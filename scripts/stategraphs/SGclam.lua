require("stategraphs/commonstates")

local events=
{
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnAttacked(true),
    CommonHandlers.OnDeath(),
	
	EventHandler("entershield", function(inst) inst.sg:GoToState("closing") end),
    EventHandler("exitshield", function(inst) inst.sg:GoToState("opening") end),
}

local states=
{
    State
    {
        name = "idle",
        tags = {"idle", "canrotate"},
        
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
        tags = {"idle", "canrotate"},
        
		onenter = function(inst)
            inst.AnimState:PlayAnimation("idle_throw", true)
        end,
		
		events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    }, 
	
	State{
        name = "closing",
        tags = {"busy", "hiding"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("close")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/foley")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/hide")
            inst.Physics:Stop()
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("closed") end ),
        },
    },
	
	State{
        name = "closed",
        tags = {"busy", "hiding"},

        onenter = function(inst)
			if inst.components.health.SetAbsorbAmount then -- Why is this necessary Klei, whhhhyyyy?
				inst.components.health:SetAbsorbAmount(TUNING.ROCKY_ABSORB)
			else
				inst.components.health:SetAbsorptionAmount(TUNING.ROCKY_ABSORB)
			end
			
            inst.AnimState:PlayAnimation("closed")
            inst.sg:SetTimeout(3)
        end,

        onexit = function(inst)
            if inst.components.health.SetAbsorbAmount then
				inst.components.health:SetAbsorbAmount(0)
			else
				inst.components.health:SetAbsorptionAmount(0)
			end
        end,
        
        ontimeout = function(inst)
            inst.sg:GoToState("closed")            
        end,

        timeline = 
        {
            TimeEvent(20*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/sleep") end),
        },
    },
	
	State{
        name = "opening",
        tags = {"busy", "hiding"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("open")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/foley")
        end,

        timeline = 
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/foley") end),        
        },

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
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
            EventHandler("animover", function(inst) inst.sg:GoToState("close") end ),
        },
    }, 
	
	State{
        name = "hit_closed",
        tags = {"busy"},
        
        onenter = function(inst)                
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()            
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("close") end ),
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
        
    },
}

local function hitanim(inst)
    if inst:HasTag("hiding") then
        return "hit_closed"
    else
        return "hit"
    end
end

local combatanims =
{
    hit = hitanim,
}

CommonStates.AddCombatStates(states,
{
    hittimeline = {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/hurt") end),
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/foley") end),        
    },
	
    deathtimeline = {
        TimeEvent(0*FRAMES, function(inst) 
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/death") 
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/explode") 
        end), 
    },
}, 
combatanims)

--CommonStates.AddSleepStates(states)
    
return StateGraph("clam", states, events, "idle")