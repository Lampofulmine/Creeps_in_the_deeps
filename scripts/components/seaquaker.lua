local quakelevels =
{
	level1={
		prequake = 7, 																								--the warning before the quake
		quaketime = function() return math.random(5, 10) + 5 end, 													--how long the quake lasts
		tentaclespersecond = function() return math.random(2, 3) end, 													--how much debris falls every second
		nextquake = function() return TUNING.TOTAL_DAY_TIME * 0.5 + math.random() * TUNING.TOTAL_DAY_TIME end 	--how long until the next quake
	},

	level2={
		prequake = 6,
		quaketime = function() return math.random(7, 12) + 5 end, 
		tentaclespersecond = function() return math.random(3, 4) end, 
		nextquake =  function() return TUNING.TOTAL_DAY_TIME * 2 + math.random() * TUNING.TOTAL_DAY_TIME * 1 end
	},

	level3={
		prequake = 5, 
		quaketime = function() return math.random(10, 15) + 5 end, 
		tentaclespersecond = function() return math.random(4, 5) end, 
		nextquake =  function() return TUNING.TOTAL_DAY_TIME * 1 + math.random() * TUNING.TOTAL_DAY_TIME * 1 end
	},

	level4={
		prequake = 4, 
		quaketime = function() return math.random(12, 17) + 5 end, 
		tentaclespersecond = function() return math.random(5, 6) end, 
		nextquake =  function() return TUNING.TOTAL_DAY_TIME * 1 + math.random() * TUNING.TOTAL_DAY_TIME * 0.5 end
	},

	level5=
	{
		prequake = 3, 
		quaketime = function() return math.random(15, 20) + 5 end, 
		tentaclespersecond = function() return math.random(3, 4) end, 
		nextquake =  function() return TUNING.TOTAL_DAY_TIME * 0.5 + math.random() * TUNING.TOTAL_DAY_TIME end
	},

	tentacleQuake=
    { -- quake during tentacle pillar death throes
		prequake = -3,                                                           --the warning before the quake
		quaketime = function() return GetRandomWithVariance(3,.5) end, 	        --how long the quake lasts
		tentaclespersecond = function() return GetRandomWithVariance(20,.5) end, 	--how much debris falls every second
		nextquake = function() return TUNING.TOTAL_DAY_TIME * 100 end, 	        --how long until the next quake
	},
}

local SeaQuaker = Class(function(self,inst)
	self.inst = inst
	self.timetospawn = 0
	self.spawntime = 0.5
	self.quake = false
	self.inst:StartUpdatingComponent(self)
	self.emittingsound = false
	self.quakelevel = quakelevels["level1"]
	self.prequake = self.quakelevel.prequake
	self.quaketime = self.quakelevel.quaketime()
	self.tentaclespersecond = self.quakelevel.tentaclespersecond()
	self.nextquake = self.quakelevel.nextquake()

	self.inst:ListenForEvent("explosion", function(inst, data)
		if not self.quake and self.nextquake > self.prequake + 1 then
			self.nextquake = self.nextquake - data.damage

			if self.nextquake < self.prequake then
				self.nextquake = self.prequake + 1
			end
		end
	 end)
end)

function SeaQuaker:OnSave()
	if not self.noserial then
        if self.quakeold then
            self.quakelevel = self.quakeold
            self.quakeold = nil
            self.prequake = self.quakelevel.prequake
            self.quaketime = self.quakelevel.quaketime()
            self.tentaclespersecond = self.quakelevel.tentaclespersecond()
            self.nextquake = self.quakelevel.nextquake()
        end
		return
		{
			prequake = self.prequake,
			quaketime = self.quaketime,
			tentaclespersecond = self.tentaclespersecond,
			nextquake = self.nextquake,
		}
	end
	self.noserial = false
end

function SeaQuaker:OnLoad(data)
	self.prequake = data.prequake or self.quakelevel.prequake
	self.quaketime = data.quaketime or self.quakelevel.quaketime()
	self.tentaclespersecond = data.tentaclespersecond or self.quakelevel.tentaclespersecond()
	self.nextquake = data.nextquake or self.quakelevel.nextquake()
end

function SeaQuaker:OnProgress()
	self.noserial = true
end

function SeaQuaker:GetDebugString()
	if self.nextquake > 0 then
		return string.format("Next seaquake in %2.2f. There will be a %2.2f second warning. %2.2f tentacles will appear every second. It will last for %2.2f seconds",
		self.nextquake, self.prequake, self.tentaclespersecond, self.quaketime)
	else
		return string.format("QUAKING")
	end
end

function SeaQuaker:SetNextQuake()
	self.prequake = self.quakelevel.prequake
	self.quaketime = self.quakelevel.quaketime()
	self.tentaclespersecond = self.quakelevel.tentaclespersecond()
	self.nextquake = self.quakelevel.nextquake()
end

function SeaQuaker:GetTimeForNextTentacle()
	return 1/self.tentaclespersecond
end

function SeaQuaker:SetQuakeLevel(level)
 	self.quakelevel = quakelevels[level]
    self.levelname = level
	self:SetNextQuake()
end

function SeaQuaker:GetSpawnPoint(pt, rad)

    local theta = math.random() * 2 * PI
    local radius = math.random()*(rad or TUNING.FROG_RAIN_SPAWN_RADIUS)
    	
	local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
		local ground = GetWorld()
        local spawn_point = pt + offset
        if not (ground.Map and ground.Map:GetTileAtPoint(spawn_point.x, spawn_point.y, spawn_point.z) == GROUND.IMPASSABLE or ground.Map:GetTileAtPoint(spawn_point.x, spawn_point.y, spawn_point.z) > GROUND.UNDERGROUND ) then
			return true
        end
		return false
    end)

	if result_offset then
		return pt+result_offset
	end

end

function SeaQuaker:WarnQuake()
	self.inst:DoTaskInTime(1, function()
		GetPlayer().components.talker:Say(GetString(GetPlayer().prefab, "ANNOUNCE_QUAKE"))
		self.inst:PushEvent("warnquake")
	end)
	self.emittingsound = true
	TheCamera:Shake("FULL", self.prequake + 3, 0.02, .2, 40)
	self.inst.SoundEmitter:PlaySound("dontstarve/cave/earthquake", "earthquake")
	self.inst.SoundEmitter:SetParameter("earthquake", "intensity", 0.08)
end

function SeaQuaker:StartQuake()
	self.inst.SoundEmitter:SetParameter("earthquake", "intensity", 1)
	self.quake = true
	self.inst:PushEvent("startquake")
end

function SeaQuaker:EndQuake()
    if self.quakeold then
 	    self.quakelevel = self.quakeold
 	    self.quakeold = nil
        self.prequake = self.quakelevel.prequake
        self.quaketime = self.quakelevel.quaketime()
        self.tentaclespersecond = self.quakelevel.tentaclespersecond()
        self.nextquake = self.quakelevel.nextquake()
    end
	self.quake = false
	self.inst:PushEvent("endquake")
	self.emittingsound = false
	self.inst.SoundEmitter:KillSound("earthquake")
	self:SetNextQuake()
end

-- Immediately start the current or a specified quake
-- If a new quake type is forced, save current quake type and restore it once quake has finished
function SeaQuaker:ForceQuake(level)

	if self.quake then return false end  

    if level and quakelevels[level] then
 	    self.quakeold = self.quakelevel
 	    self.quakelevel = quakelevels[level]
        self.prequake = self.quakelevel.prequake
        self.quaketime = self.quakelevel.quaketime()
        self.tentaclespersecond = self.quakelevel.tentaclespersecond()
        self.nextquake = self.quakelevel.nextquake()
    end
	self.nextquake = self.prequake

    return true
end

function SeaQuaker:MiniQuake(rad, num, duration, target)
	self.inst.SoundEmitter:PlaySound("dontstarve/cave/earthquake", "miniearthquake")
	self.inst.SoundEmitter:SetParameter("miniearthquake", "intensity", 1)
    self.inst:DoTaskInTime(duration, function() self.inst.SoundEmitter:KillSound("miniearthquake") end)
end

function SeaQuaker:SpawnTentacle(spawn_point)
	local tentacle = SpawnPrefab("seaquaketentacle")
	tentacle.Physics:Teleport(spawn_point.x,0,spawn_point.z)
end

function SeaQuaker:OnUpdate( dt )

	if self.nextquake > 0 then
		self.nextquake = self.nextquake - dt

		if self.nextquake < self.prequake and not self.emittingsound then
			self:WarnQuake()
		end

	elseif self.nextquake <= 0 and not self.quake then		
		self:StartQuake()
	end

	if self.quake then
		if self.quaketime > 0 then
			self.quaketime = self.quaketime - dt

			local maincharacter = GetPlayer()

		    if maincharacter then
				if self.timetospawn > 0 then
					self.timetospawn = self.timetospawn - dt
				end

				if self.timetospawn <= 0 then				
					local char_pos = Vector3(maincharacter.Transform:GetWorldPosition())
					local spawn_point = self:GetSpawnPoint(char_pos)								
					if spawn_point then
						self:SpawnTentacle(spawn_point)
						
				    	TheCamera:Shake("FULL", 0.7, 0.02, .75, 40)

						if self.spawntime then
							self.timetospawn = self:GetTimeForNextTentacle()
						end
					end
				end
			end
		else
			self:EndQuake()
		end
	end    
end

return SeaQuaker
