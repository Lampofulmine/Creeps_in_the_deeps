-- Add underwater postinits
local function fn(inst)
	
	local player = GetPlayer()
	local world = GetWorld()
	local clock = GetClock()
	
	-- Are we underwater?
	local level = SaveGameIndex:GetCurrentCaveLevel(SaveGameIndex:GetCurrentSaveSlot())
	local levels = require("map/levels")
	
	if world and SaveGameIndex:GetCurrentMode() == "cave"
	and levels.cave_levels[level].id == "UNDERWATER_LEVEL_1" or levels.cave_levels[level].id == "UNDERWATER_LEVEL_2" then
		world:AddTag("underwater")
		world.components.ambientsoundmixer:SetReverbPreset("default")
		
		
		-- Stop the cave rain
		if world.components.seasonmanager and world.components.seasonmanager.StopCavesRain then
			world.components.seasonmanager:StopCavesRain()
		end
		
		-- Switch the earthquake component for our sea quake component
		if world.components.quaker then
			world:RemoveComponent("quaker")
		end
		
		world:AddComponent("seaquaker")
		
		
		-- Change cave lighting
		if clock then
			clock.caveColour = Point(107/255,  235/255, 192/255)
			clock.dayColour =  Point(107/255,  235/255, 192/255)
			clock.duskColour = Point(54/255,  78/255, 72/255)
			clock.nightColour = Point(5/255,  0/255, 10/255)
			clock.dawnColour = Point(42/255,  92/255, 92/255) -- for "Dawnbreak" mod
			-- crude fix for loading
			clock:LongUpdate(0)
		end
		
		
		-- Underwater ambience

		-- Adjust dynamic music
		-- if player and player.components.dynamicmusic then
			-- player.components.dynamicmusic:OnStartBusy()
			-- player.components.dynamicmusic:Disable()
		-- end
		TheSim:RemapSoundEvent("dontstarve/music/music_dawn_stinger", "citd/music/music_dawn_stinger")
		TheSim:RemapSoundEvent("dontstarve/music/music_dusk_stinger", "citd/music/music_dusk_stinger")
		
		-- Clear out all other ambience music for now
		for k,v in pairs(world.components.ambientsoundmixer.ambient_sounds) do
			v.sound = ""
		end
		
		-- Force the sound mixer to stop
		for k,v in pairs(world.components.ambientsoundmixer.playing_sounds) do
			world.SoundEmitter:KillSound(v.sound)
		end
		
		world.components.ambientsoundmixer.lastpos = nil
		
		-- Start playing underwater ambience
		TheFrontEnd:GetSound():PlaySound("citd/amb/underwater")
		
		-- Start playing underwater music
		-- if levels.cave_levels[level].id == "UNDERWATER_LEVEL_2" then
			-- TheFrontEnd:GetSound():PlaySound("citd/music/music_work_deep")
		-- else
			-- TheFrontEnd:GetSound():PlaySound("citd/music/music_work_shallow")
		-- end
		
		
		--[[if UW_TUNING.DEBUG_MODE then
			-- Map revealer (temporary effect) for testing
			--RunScript("consolecommands")
			inst:DoTaskInTime( 0.1, function()
				world.minimap.MiniMap:ShowArea(0,0,0,40000)
			end)
		end]]--
		
		
	end
	
	-- Player meters
	if player and player.HUD and player.components.oxygen then

		local status = player.HUD.controls.status

		
		-- Oxygen meter
		local OxygenBadge = require("widgets/oxygenbadge")
		status.oxygen = status:AddChild(OxygenBadge(status.owner))
		
		-- Position logic
		if status.moisturemeter and UW_TUNING.OXYGENMETER_COMPACT then
			local sourcepos = status.moisturemeter:GetPosition()
			status.moisturemeter:SetPosition(sourcepos.x - 40, sourcepos.y + 15, sourcepos.z)
			status.oxygen:SetPosition(sourcepos.x + 40, sourcepos.y + 15, sourcepos.z)
		else
			local above = status.moisturemeter or status.brain
			local sourcepos = above:GetPosition()
			status.oxygen:SetPosition(sourcepos.x, sourcepos.y - 75 ,sourcepos.z)
		end
		-- status.brain:SetPosition(-40,20,0)
		-- status.stomach:SetPosition(-40,-60,0)
		-- if status.moisturemeter then status.moisturemeter:SetPosition(0, -140,0) end
		
		status.oxygen:SetPercent(status.owner.components.oxygen:GetPercent(), status.owner.components.oxygen.max)
		
		local function OxygenDelta(data)
			status.oxygen:SetPercent(status.owner.components.oxygen:GetPercent(), status.owner.components.oxygen.max)
		
			if data.newpercent <= 0 then
				status.oxygen:StartWarning()
			else
				status.oxygen:StopWarning()
			end

			if not data.overtime then
				if data.newpercent > data.oldpercent then
					status.oxygen:PulseGreen()
					TheFrontEnd:GetSound():PlaySound("citd/HUD/thirst_up")
				elseif data.newpercent < data.oldpercent then
					TheFrontEnd:GetSound():PlaySound("citd/HUD/thirst_down")
					status.oxygen:PulseRed()
				end
			end
		end
			
		player:ListenForEvent("oxygendelta", function(inst, data) OxygenDelta(data) end, player)
	end
	
end

return fn