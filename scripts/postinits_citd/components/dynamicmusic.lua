return function(cmp)

    local _StartPlayingBusy = cmp.StartPlayingBusy
    function cmp:StartPlayingBusy()
        
		if GetWorld():IsUnderwater() then
			self.inst.SoundEmitter:PlaySound( "citd/music/music_work_shallow", "busy")
			self.inst.SoundEmitter:SetParameter( "busy", "intensity", 0 )
		else
			_StartPlayingBusy(self)
		end
		
    end
	
    local _OnStartDanger = cmp.OnStartDanger
    function cmp:OnStartDanger()
        
		if GetWorld():IsUnderwater() then
			--crude copy
			if not self.enabled then return end
			
			self.danger_timeout = 10
			if not self.playing_danger then
				local epic = GetClosestInstWithTag("epic", self.inst, 30)
				local soundpath = nil
				
				if epic then
					soundpath = "dontstarve/music/music_epicfight_shallow"
				else
					soundpath = "dontstarve/music/music_danger_shallow"
				end

				self.inst.SoundEmitter:PlaySound(soundpath, "danger")
				self:StopPlayingBusy()
				self.playing_danger = true
			end
		else
			_OnStartDanger(self)
		end
		
    end
	
end