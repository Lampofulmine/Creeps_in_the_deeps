require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
--require "behaviours/choptree"
require "behaviours/findlight"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/leash"


local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9
local MAX_WANDER_DIST = 20

local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 30

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8
local START_RUN_DIST = 3
local STOP_RUN_DIST = 5
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30
local SEE_LIGHT_DIST = 20
local TRADE_DIST = 20
local SEE_TREE_DIST = 15
local SEE_TARGET_DIST = 20

local KEEP_CHOPPING_DIST = 10

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8

local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:IsNear(target, KEEP_FACE_DIST) and not target:HasTag("notarget")
end

local function ShouldRunAway(inst, target)
    return not inst.components.trader:IsTryingToTradeWithMe(target)
end

local function GetTraderFn(inst)
    return FindEntity(inst, TRADE_DIST, function(target) return inst.components.trader:IsTryingToTradeWithMe(target) end, {"player"})
end

local function KeepTraderFn(inst, target)
    return inst.components.trader:IsTryingToTradeWithMe(target)
end

local function KeepChoppingAction(inst)
	if not inst:HasTag("merm_worker") then return false end
    return inst.components.follower.leader and inst.components.follower.leader:GetDistanceSqToInst(inst) <= KEEP_CHOPPING_DIST*KEEP_CHOPPING_DIST
end

local function StartChoppingCondition(inst)
	if not inst:HasTag("merm_worker") then return false end
    return inst.components.follower.leader and inst.components.follower.leader.sg and inst.components.follower.leader.sg:HasStateTag("chopping")
end

local function FindTreeToChopAction(inst)
	if not inst:HasTag("merm_worker") then return false end
    local target = FindEntity(inst, SEE_TREE_DIST, function(item) return item.components.workable and item.components.workable.action == ACTIONS.CHOP end)
    if target then
        return BufferedAction(inst, target, ACTIONS.CHOP)
    end
end

local function HasValidHome(inst)
    return inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid()
end

local function GoHomeAction(inst)
    if not inst.components.follower.leader and
        HasValidHome(inst) and
        not inst.components.combat.target then
            return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetLeader(inst)
    return inst.components.follower.leader 
end

local function GetHomePos(inst)
    return HasValidHome(inst) and inst.components.homeseeker:GetHomePos()
end

local function GetNoLeaderHomePos(inst)
    if GetLeader(inst) then
        return nil
    end
    return GetHomePos(inst)
end

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local CivilisedMermBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function CivilisedMermBrain:OnStart()

	local TYPE_TAG = nil
	if self.inst:HasTag("merm_noble") then
		TYPE_TAG = "MERM_NOBLE"
	elseif self.inst:HasTag("merm_worker") then
		TYPE_TAG = "MERM_WORKER"
	else
		TYPE_TAG = "MERM_GUARD"
	end

    local clock = GetClock()
    
    local day = WhileNode( function() return clock and clock:IsDay() end, "IsDay",
        PriorityNode{
            IfNode(function() return StartChoppingCondition(self.inst) end, "chop", 
                WhileNode(function() return KeepChoppingAction(self.inst) end, "keep chopping",
                    LoopNode{ 
                        ChattyNode(self.inst, STRINGS.MERM_TALK_HELP_CHOP_WOOD[TYPE_TAG],
                            DoAction(self.inst, FindTreeToChopAction ))})),
            ChattyNode(self.inst, STRINGS.MERM_TALK_FOLLOWWILSON[TYPE_TAG], 
                Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),
            IfNode(function() return GetLeader(self.inst) end, "has leader",
				ChattyNode(self.inst, STRINGS.MERM_TALK_FOLLOWWILSON[TYPE_TAG],
					FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn ))),

            Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),

            ChattyNode(self.inst, STRINGS.MERM_TALK_RUNAWAY_WILSON[TYPE_TAG],
                RunAway(self.inst, "player", START_RUN_DIST, STOP_RUN_DIST)),
            ChattyNode(self.inst, STRINGS.MERM_TALK_LOOKATWILSON[TYPE_TAG],
                FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
            Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST)
        },.5)
        
    
    local night = WhileNode( function() return clock and not clock:IsDay() end, "IsNight",
        PriorityNode{      
            RunAway(self.inst, "player", START_RUN_DIST, STOP_RUN_DIST, function(target) return ShouldRunAway(self.inst, target) end ),
            ChattyNode(self.inst, STRINGS.MERM_TALK_GO_HOME[TYPE_TAG],
                DoAction(self.inst, GoHomeAction, "go home", true )),
        },1)
    
    local root = 
        PriorityNode(
        {       
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire",
				ChattyNode(self.inst, STRINGS.MERM_TALK_PANICFIRE[TYPE_TAG],
					Panic(self.inst))),
            ChattyNode(self.inst, STRINGS.MERM_TALK_FIGHT[TYPE_TAG],
                WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
                    ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST) )),
            ChattyNode(self.inst, STRINGS.MERM_TALK_FIGHT[TYPE_TAG],
                WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
                    RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST) )),
            RunAway(self.inst, function(guy) return guy:HasTag("merm") and guy.components.combat and guy.components.combat.target == self.inst end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST ),
            ChattyNode(self.inst, STRINGS.MERM_TALK_ATTEMPT_TRADE[TYPE_TAG],
                FaceEntity(self.inst, GetTraderFn, KeepTraderFn)),            
            day,
            night
        }, .5)
    
    self.bt = BT(self.inst, root)
    
end

return CivilisedMermBrain
